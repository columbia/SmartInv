1 // File: contracts/StringBuffer.sol
2 
3 //SPDX-License-Identifier: MIT
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @notice Holds a string that can expand dynamically.
8  */
9 struct StringBuffer {
10     string[] buffer;
11     uint numberOfStrings;
12     uint totalStringLength;
13 }
14 
15 library StringBufferLibrary {
16     /**
17      * @dev Copies 32 bytes of `src` starting at `srcIndex` into `dst` starting at `dstIndex`.
18      */
19     function memcpy32(string memory src, uint srcIndex, bytes memory dst, uint dstIndex) internal pure {
20         assembly {
21             mstore(add(add(dst, 32), dstIndex), mload(add(add(src, 32), srcIndex)))
22         }
23     }
24 
25     /**
26      * @dev Copies 1 bytes of `src` at `srcIndex` into `dst` at `dstIndex`.
27      *      This uses the same amount of gas as `memcpy32`, so prefer `memcpy32` if at all possible.
28      */
29     function memcpy1(string memory src, uint srcIndex, bytes memory dst, uint dstIndex) internal pure {
30         assembly {
31             mstore8(add(add(dst, 32), dstIndex), shr(248, mload(add(add(src, 32), srcIndex))))
32         }
33     }
34 
35     /**
36      * @dev Copies a string into `dst` starting at `dstIndex` with a maximum length of `dstLen`.
37      *      This function will not write beyond `dstLen`. However, if `dstLen` is not reached, it may write zeros beyond the length of the string.
38      */
39     function copyString(string memory src, bytes memory dst, uint dstIndex, uint dstLen) internal pure returns (uint) {
40         uint srcIndex;
41         uint srcLen = bytes(src).length;
42 
43         for (; srcLen > 31 && srcIndex < srcLen && srcIndex < dstLen - 31; srcIndex += 32) {
44             memcpy32(src, srcIndex, dst, dstIndex + srcIndex);
45         }
46         for (; srcIndex < srcLen && srcIndex < dstLen; ++srcIndex) {
47             memcpy1(src, srcIndex, dst, dstIndex + srcIndex);
48         }
49 
50         return dstIndex + srcLen;
51     }
52 
53     /**
54      * @dev Adds `str` to the end of the internal buffer.
55      */
56     function pushToStringBuffer(StringBuffer memory self, string memory str) internal pure returns (StringBuffer memory) {
57         if (self.buffer.length == self.numberOfStrings) {
58             string[] memory newBuffer = new string[](self.buffer.length * 2);
59             for (uint i = 0; i < self.buffer.length; ++i) {
60                 newBuffer[i] = self.buffer[i];
61             }
62             self.buffer = newBuffer;
63         }
64 
65         self.buffer[self.numberOfStrings] = str;
66         self.numberOfStrings++;
67         self.totalStringLength += bytes(str).length;
68 
69         return self;
70     }
71 
72     /**
73      * @dev Concatenates `str` to the end of the last string in the internal buffer.
74      */
75     function concatToLastString(StringBuffer memory self, string memory str) internal pure {
76         if (self.numberOfStrings == 0) {
77             self.numberOfStrings++;
78         }
79         uint idx = self.numberOfStrings - 1;
80         self.buffer[idx] = string(abi.encodePacked(self.buffer[idx], str));
81 
82         self.totalStringLength += bytes(str).length;
83     }
84 
85     /**
86      * @notice Creates a new empty StringBuffer
87      * @dev The initial capacity is 16 strings
88      */
89     function empty() external pure returns (StringBuffer memory) {
90         return StringBuffer(new string[](1), 0, 0);
91     }
92 
93     /**
94      * @notice Converts the contents of the StringBuffer into a string.
95      * @dev This runs in O(n) time.
96      */
97     function get(StringBuffer memory self) internal pure returns (string memory) {
98         bytes memory output = new bytes(self.totalStringLength);
99 
100         uint ptr = 0;
101         for (uint i = 0; i < self.numberOfStrings; ++i) {
102             ptr = copyString(self.buffer[i], output, ptr, self.totalStringLength);
103         }
104 
105         return string(output);
106     }
107 
108     /**
109      * @notice Appends a string to the end of the StringBuffer
110      * @dev Internally the StringBuffer keeps a `string[]` that doubles in size when extra capacity is needed.
111      */
112     function append(StringBuffer memory self, string memory str) internal pure {
113         uint idx = self.numberOfStrings == 0 ? 0 : self.numberOfStrings - 1;
114         if (bytes(self.buffer[idx]).length + bytes(str).length <= 1024) {
115             concatToLastString(self, str);
116         } else {
117             pushToStringBuffer(self, str);
118         }
119     }
120 }
121 
122 // File: contracts/Integer.sol
123 
124 
125 pragma solidity ^0.8.0;
126 
127 library Integer {
128     /**
129      * @dev Gets the bit at the given position in the given integer.
130      *      31 is the leftmost bit, 0 is the rightmost bit.
131      *
132      *      For example: bitAt(2, 0) == 0, because the rightmost bit of 10 is 0
133      *                   bitAt(2, 1) == 1, because the second to last bit of 10 is 1
134      */
135     function bitAt(uint integer, uint pos) external pure returns (uint) {
136         require(pos <= 31, "pos > 31");
137 
138         return (integer & (1 << pos)) >> pos;
139     }
140 
141     /**
142      * @dev Gets the value of the bits between left and right, both inclusive, in the given integer.
143      *      31 is the leftmost bit, 0 is the rightmost bit.
144      *      
145      *      For example: bitsFrom(10, 3, 1) == 7 (101 in binary), because 10 is *101*0 in binary
146      *                   bitsFrom(10, 2, 0) == 2 (010 in binary), because 10 is 1*010* in binary
147      */
148     function bitsFrom(uint integer, uint left, uint right) external pure returns (uint) {
149         require(left >= right, "left > right");
150         require(left <= 31, "left > 31");
151 
152         uint delta = left - right + 1;
153 
154         return (integer & (((1 << delta) - 1) << right)) >> right;
155     }
156 }
157 
158 // File: contracts/Rarities.sol
159 
160 
161 pragma solidity ^0.8.0;
162 
163 library Rarities {
164     function dominant() internal pure returns (uint16[8] memory ret) {
165         ret = [
166             2500,
167             2200,
168             1900,
169             1300,
170             800,
171             600,
172             400,
173             300
174         ];
175     }
176     
177     function recessive() internal pure returns (uint16[6] memory ret) {
178         ret = [
179             4000,
180             2500,
181             1500,
182             1000,
183             600,
184             400
185         ];
186     }
187     
188     function outfit() internal pure returns (uint16[27] memory ret) {
189         ret = [
190             700,
191             700,
192             700,
193             600,
194             600,
195             600,
196             600,
197             600,
198             600,
199             600,
200             600,
201             500,
202             500,
203             400,
204             400,
205             300,
206             200,
207             200,
208             100,
209             100,
210             100,
211             75,
212             50,
213             50,
214             50,
215             50,
216             25
217         ];
218     }
219     
220     function handaccessory() internal pure returns (uint16[16] memory ret) {
221         ret = [
222             5000,
223             600,
224             600,
225             600,
226             600,
227             510,
228             500,
229             500,
230             300,
231             300,
232             150,
233             100,
234             100,
235             75,
236             40,
237             25
238         ];
239     }
240     
241     function mouth() internal pure returns (uint16[22] memory ret) {
242         ret = [
243             2000,
244             1000,
245             1000,
246             1000,
247             700,
248             700,
249             700,
250             700,
251             400,
252             300,
253             300,
254             300,
255             175,
256             100,
257             100,
258             100,
259             100,
260             100,
261             75,
262             75,
263             50,
264             25
265         ];
266     }
267     
268     function eyes() internal pure returns (uint16[24] memory ret) {
269         ret = [
270             2500,
271             600,
272             600,
273             600,
274             600,
275             600,
276             600,
277             400,
278             400,
279             400,
280             400,
281             400,
282             400,
283             400,
284             400,
285             100,
286             100,
287             100,
288             100,
289             75,
290             75,
291             75,
292             50,
293             25
294         ];
295     }
296     
297     function headaccessory() internal pure returns (uint16[29] memory ret) {
298         ret = [
299             3000,
300             500,
301             500,
302             500,
303             500,
304             500,
305             500,
306             500,
307             500,
308             400,
309             300,
310             300,
311             200,
312             200,
313             200,
314             200,
315             200,
316             100,
317             100,
318             100,
319             100,
320             100,
321             100,
322             100,
323             100,
324             75,
325             50,
326             50,
327             25
328         ];
329     }
330 }
331 // File: contracts/Rng.sol
332 
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @title A pseudo random number generator
338  *
339  * @dev This is not a true random number generator because smart contracts must be deterministic (every node a transaction goes to must produce the same result).
340  *      True randomness requires an oracle which is both expensive in terms of gas and would take a critical part of the project off the chain.
341  */
342 struct Rng {
343     bytes32 state;
344 }
345 
346 /**
347  * @title A library for working with the Rng struct.
348  *
349  * @dev Rng cannot be a contract because then anyone could manipulate it by generating random numbers.
350  */
351 library RngLibrary {
352     /**
353      * Creates a new Rng.
354      */
355     function newRng() internal view returns (Rng memory) {
356         return Rng(getEntropy());
357     }
358 
359     /**
360      * Creates a pseudo-random value from the current block miner's address and sender.
361      */
362     function getEntropy() internal view returns (bytes32) {
363         return keccak256(abi.encodePacked(block.coinbase, msg.sender));
364     }
365 
366     /**
367      * Generates a random uint256.
368      */
369     function generate(Rng memory self) internal view returns (uint256) {
370         self.state = keccak256(abi.encodePacked(getEntropy(), self.state));
371         return uint256(self.state);
372     }
373 
374     /**
375      * Generates a random uint256 from min to max inclusive.
376      *
377      * @dev This function is not subject to modulo bias.
378      *      The chance that this function has to reroll is astronomically unlikely, but it can theoretically reroll forever.
379      */
380     function generate(Rng memory self, uint min, uint max) internal view returns (uint256) {
381         require(min <= max, "min > max");
382 
383         uint delta = max - min;
384 
385         if (delta == 0) {
386             return min;
387         }
388 
389         return generate(self) % (delta + 1) + min;
390     }
391 }
392 
393 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
394 
395 
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @dev Interface of the ERC20 standard as defined in the EIP.
401  */
402 interface IERC20 {
403     /**
404      * @dev Returns the amount of tokens in existence.
405      */
406     function totalSupply() external view returns (uint256);
407 
408     /**
409      * @dev Returns the amount of tokens owned by `account`.
410      */
411     function balanceOf(address account) external view returns (uint256);
412 
413     /**
414      * @dev Moves `amount` tokens from the caller's account to `recipient`.
415      *
416      * Returns a boolean value indicating whether the operation succeeded.
417      *
418      * Emits a {Transfer} event.
419      */
420     function transfer(address recipient, uint256 amount) external returns (bool);
421 
422     /**
423      * @dev Returns the remaining number of tokens that `spender` will be
424      * allowed to spend on behalf of `owner` through {transferFrom}. This is
425      * zero by default.
426      *
427      * This value changes when {approve} or {transferFrom} are called.
428      */
429     function allowance(address owner, address spender) external view returns (uint256);
430 
431     /**
432      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
433      *
434      * Returns a boolean value indicating whether the operation succeeded.
435      *
436      * IMPORTANT: Beware that changing an allowance with this method brings the risk
437      * that someone may use both the old and the new allowance by unfortunate
438      * transaction ordering. One possible solution to mitigate this race
439      * condition is to first reduce the spender's allowance to 0 and set the
440      * desired value afterwards:
441      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
442      *
443      * Emits an {Approval} event.
444      */
445     function approve(address spender, uint256 amount) external returns (bool);
446 
447     /**
448      * @dev Moves `amount` tokens from `sender` to `recipient` using the
449      * allowance mechanism. `amount` is then deducted from the caller's
450      * allowance.
451      *
452      * Returns a boolean value indicating whether the operation succeeded.
453      *
454      * Emits a {Transfer} event.
455      */
456     function transferFrom(
457         address sender,
458         address recipient,
459         uint256 amount
460     ) external returns (bool);
461 
462     /**
463      * @dev Emitted when `value` tokens are moved from one account (`from`) to
464      * another (`to`).
465      *
466      * Note that `value` may be zero.
467      */
468     event Transfer(address indexed from, address indexed to, uint256 value);
469 
470     /**
471      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
472      * a call to {approve}. `value` is the new allowance.
473      */
474     event Approval(address indexed owner, address indexed spender, uint256 value);
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
478 
479 
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev Interface for the optional metadata functions from the ERC20 standard.
486  *
487  * _Available since v4.1._
488  */
489 interface IERC20Metadata is IERC20 {
490     /**
491      * @dev Returns the name of the token.
492      */
493     function name() external view returns (string memory);
494 
495     /**
496      * @dev Returns the symbol of the token.
497      */
498     function symbol() external view returns (string memory);
499 
500     /**
501      * @dev Returns the decimals places of the token.
502      */
503     function decimals() external view returns (uint8);
504 }
505 
506 // File: contracts/Enums.sol
507 
508 
509 pragma solidity ^0.8.0;
510 
511 enum RerollTrait {
512     BgColor,
513     Outfit,
514     HandAccessory,
515     Mouth,
516     Eyes,
517     HeadAccessory
518 }
519 
520 enum Special {
521     NONE,
522     DEVIL,
523     GHOST,
524     HIPPIE,
525     JOKER,
526     PRISONER,
527     SQUID_GAME,
528     WHERES_WALDO,
529     HAZMAT,
530     ASTRONAUT
531 }
532 
533 enum Dominant {
534     SKELETON,
535     VAMPIRE,
536     MUMMY,
537     GHOST,
538     WITCH,
539     FRANKENSTEIN,
540     WEREWOLF,
541     PUMPKINHEAD
542 }
543 
544 enum Recessive {
545     SKELETON,
546     VAMPIRE,
547     MUMMY,
548     GHOST,
549     DEVIL,
550     KONG
551 }
552 
553 enum BgColor {
554     DARK_BLUE,
555     GRAY,
556     LIGHT_BLUE,
557     ORANGE,
558     PINK,
559     PURPLE,
560     RED,
561     TAN,
562     TEAL,
563     GREEN,
564     RAINBOW
565 }
566 
567 enum Outfit {
568     WHITE_SHORTS,
569     PINK_SHORTS,
570     GRAY_PANTS,
571     WHITE_AND_BLUE,
572     PURPLE_SHORTS,
573     PINK_AND_PURPLE,
574     BROWN_AND_WHITE,
575     BROWN_AND_BLUE,
576     BLUE_SHORTS,
577     BLUE_AND_WHITE,
578     UNDERGARMENTS,
579     LOUNGEWEAR,
580     HOBO,
581     SPORTS_JERSEY,
582     GOLD_CHAIN,
583     PAJAMAS,
584     OVERALLS,
585     SPEEDO,
586     NINJA_SUIT,
587     KARATE_UNIFORM,
588     NONE,
589     LUMBERJACK,
590     PRIEST,
591     TUX,
592     SKELETON,
593     CAMO,
594     ARMOR
595 }
596 
597 enum HandAccessory {
598     NONE,
599     BLOODY_KNIFE,
600     BOW_AND_ARROW,
601     SWORD,
602     PITCHFORK,
603     WAND,
604     SPIKED_BASEBALL_BAT,
605     ENERGY_DRINK,
606     NINJA_STARS,
607     NUNCHUCKS,
608     POOP,
609     FLAMETHROWER,
610     HOOKS,
611     WEIGHTS,
612     SKULL,
613     BRAIN
614 }
615 
616 enum Mouth {
617     NONE,
618     HAPPY,
619     MAD,
620     SMILE,
621     FANGS,
622     HAPPY_FANGS,
623     MAD_FANGS,
624     SMILE_FANGS,
625     SINGLE_TOOTH,
626     DIRTY_TEETH,
627     SMILE_DIRTY_TEETH,
628     MAD_DIRTY_TEETH,
629     BLOODY_FANGS,
630     BLACK_MASK,
631     HAPPY_BUCK_TEETH,
632     HAPPY_SINGLE_TOOTH,
633     MAD_SINGLE_TOOTH,
634     SMILE_SINGLE_TOOTH,
635     BREATHING_FIRE,
636     GOLD_GRILLS,
637     KISS,
638     SMOKING_JOINT
639 }
640 
641 enum Eyes {
642     NONE,
643     BLACK_EYE,
644     BLACKOUT,
645     BLEEDING,
646     BLOODSHOT,
647     WATERY,
648     WHITE,
649     BIGGER_BLACK_EYES,
650     BIGGER_BLEEDING,
651     BIGGER_WATERY,
652     SMALLER_BLACK_EYES,
653     SMALLER_BLEEDING,
654     SMALLER_BLOODSHOT,
655     SMALLER_WATERY,
656     SMALLER,
657     SUNGLASSES,
658     EYE_PATCH,
659     VR_HEADSET,
660     DEAD,
661     _3D_GLASSES,
662     HEART_EYES,
663     LASER_GLASSES,
664     NINJA_MASK,
665     LASER_EYES
666 }
667 
668 enum HeadAccessory {
669     NONE,
670     BUCKET_HAT,
671     FLOWER,
672     SPORTS_HEADBAND,
673     CHEF_HAT,
674     BLUE_DURAG,
675     RED_DURAG,
676     SPIKY_HAIR,
677     BONES,
678     RICE_HAT,
679     BEANIE_CAP,
680     SANTA_HAT,
681     HEAD_WOUND,
682     HEADPHONES,
683     GOLD_STUDS,
684     WIZARD_HAT,
685     LONG_HAIR,
686     AIR_PODS,
687     WHITE_PARTY_HAT,
688     BLUE_PARTY_HAT,
689     RED_PARTY_HAT,
690     GREEN_PARTY_HAT,
691     YELLOW_PARTY_HAT,
692     PURPLE_PARTY_HAT,
693     PIRATE_HAT,
694     KING_CROWN,
695     JOKER_HAT,
696     DEVIL_HORNS,
697     BRAINS
698 }
699 
700 library Enums {
701     function toString(Special v) external pure returns (string memory) {
702         if (v == Special.NONE) {
703             return "";
704         }
705     
706         if (v == Special.DEVIL) {
707             return "Devil";
708         }
709     
710         if (v == Special.GHOST) {
711             return "Ghost";
712         }
713     
714         if (v == Special.HIPPIE) {
715             return "Hippie";
716         }
717     
718         if (v == Special.JOKER) {
719             return "Society";
720         }
721     
722         if (v == Special.PRISONER) {
723             return "Prisoner";
724         }
725     
726         if (v == Special.SQUID_GAME) {
727             return "Squid Girl";
728         }
729     
730         if (v == Special.WHERES_WALDO) {
731             return "Where's Waldo?";
732         }
733     
734         if (v == Special.HAZMAT) {
735             return "Hazmat";
736         }
737     
738         if (v == Special.ASTRONAUT) {
739             return "Astronaut";
740         }
741         revert("invalid special");
742     }
743     
744     function toString(Dominant v) external pure returns (string memory) {
745         if (v == Dominant.SKELETON) {
746             return "Skeleton";
747         }
748     
749         if (v == Dominant.VAMPIRE) {
750             return "Vampire";
751         }
752     
753         if (v == Dominant.MUMMY) {
754             return "Mummy";
755         }
756     
757         if (v == Dominant.GHOST) {
758             return "Ghost";
759         }
760     
761         if (v == Dominant.WITCH) {
762             return "Witch";
763         }
764     
765         if (v == Dominant.FRANKENSTEIN) {
766             return "Frankenstein";
767         }
768     
769         if (v == Dominant.WEREWOLF) {
770             return "Werewolf";
771         }
772     
773         if (v == Dominant.PUMPKINHEAD) {
774             return "Pumpkinhead";
775         }
776         revert("invalid dominant");
777     }
778     
779     function toString(Recessive v) external pure returns (string memory) {
780         if (v == Recessive.SKELETON) {
781             return "Skeleton";
782         }
783     
784         if (v == Recessive.VAMPIRE) {
785             return "Vampire";
786         }
787     
788         if (v == Recessive.MUMMY) {
789             return "Mummy";
790         }
791     
792         if (v == Recessive.GHOST) {
793             return "Ghost";
794         }
795     
796         if (v == Recessive.DEVIL) {
797             return "Devil";
798         }
799     
800         if (v == Recessive.KONG) {
801             return "Kong";
802         }
803         revert("invalid recessive");
804     }
805     
806     function toString(BgColor v) external pure returns (string memory) {
807         if (v == BgColor.DARK_BLUE) {
808             return "Dark Blue";
809         }
810     
811         if (v == BgColor.GRAY) {
812             return "Gray";
813         }
814     
815         if (v == BgColor.LIGHT_BLUE) {
816             return "Light Blue";
817         }
818     
819         if (v == BgColor.ORANGE) {
820             return "Orange";
821         }
822     
823         if (v == BgColor.PINK) {
824             return "Pink";
825         }
826     
827         if (v == BgColor.PURPLE) {
828             return "Purple";
829         }
830     
831         if (v == BgColor.RED) {
832             return "Red";
833         }
834     
835         if (v == BgColor.TAN) {
836             return "Tan";
837         }
838     
839         if (v == BgColor.TEAL) {
840             return "Teal";
841         }
842     
843         if (v == BgColor.GREEN) {
844             return "Green";
845         }
846     
847         if (v == BgColor.RAINBOW) {
848             return "Rainbow";
849         }
850         revert("invalid bgcolor");
851     }
852     
853     function toString(Outfit v) external pure returns (string memory) {
854         if (v == Outfit.WHITE_SHORTS) {
855             return "White Shorts";
856         }
857     
858         if (v == Outfit.PINK_SHORTS) {
859             return "Pink Shorts";
860         }
861     
862         if (v == Outfit.GRAY_PANTS) {
863             return "Gray Pants";
864         }
865     
866         if (v == Outfit.WHITE_AND_BLUE) {
867             return "White and Blue";
868         }
869     
870         if (v == Outfit.PURPLE_SHORTS) {
871             return "Purple Shorts";
872         }
873     
874         if (v == Outfit.PINK_AND_PURPLE) {
875             return "Pink and Purple";
876         }
877     
878         if (v == Outfit.BROWN_AND_WHITE) {
879             return "Brown and White";
880         }
881     
882         if (v == Outfit.BROWN_AND_BLUE) {
883             return "Brown and Blue";
884         }
885     
886         if (v == Outfit.BLUE_SHORTS) {
887             return "Blue Shorts";
888         }
889     
890         if (v == Outfit.BLUE_AND_WHITE) {
891             return "Blue and White";
892         }
893     
894         if (v == Outfit.UNDERGARMENTS) {
895             return "Undergarments";
896         }
897     
898         if (v == Outfit.LOUNGEWEAR) {
899             return "Loungewear";
900         }
901     
902         if (v == Outfit.HOBO) {
903             return "Hobo";
904         }
905     
906         if (v == Outfit.SPORTS_JERSEY) {
907             return "Sports Jersey";
908         }
909     
910         if (v == Outfit.GOLD_CHAIN) {
911             return "Gold Chain";
912         }
913     
914         if (v == Outfit.PAJAMAS) {
915             return "Pajamas";
916         }
917     
918         if (v == Outfit.OVERALLS) {
919             return "Overalls";
920         }
921     
922         if (v == Outfit.SPEEDO) {
923             return "Speedo";
924         }
925     
926         if (v == Outfit.NINJA_SUIT) {
927             return "Ninja Suit";
928         }
929     
930         if (v == Outfit.KARATE_UNIFORM) {
931             return "Karate Uniform";
932         }
933     
934         if (v == Outfit.NONE) {
935             return "";
936         }
937     
938         if (v == Outfit.LUMBERJACK) {
939             return "Lumberjack";
940         }
941     
942         if (v == Outfit.PRIEST) {
943             return "Priest";
944         }
945     
946         if (v == Outfit.TUX) {
947             return "Tux";
948         }
949     
950         if (v == Outfit.SKELETON) {
951             return "Skeleton";
952         }
953     
954         if (v == Outfit.CAMO) {
955             return "Camo";
956         }
957     
958         if (v == Outfit.ARMOR) {
959             return "Armor";
960         }
961         revert("invalid outfit");
962     }
963     
964     function toString(HandAccessory v) external pure returns (string memory) {
965         if (v == HandAccessory.NONE) {
966             return "";
967         }
968     
969         if (v == HandAccessory.BLOODY_KNIFE) {
970             return "Bloody Knife";
971         }
972     
973         if (v == HandAccessory.BOW_AND_ARROW) {
974             return "Bow and Arrow";
975         }
976     
977         if (v == HandAccessory.SWORD) {
978             return "Sword";
979         }
980     
981         if (v == HandAccessory.PITCHFORK) {
982             return "Pitchfork";
983         }
984     
985         if (v == HandAccessory.WAND) {
986             return "Wand";
987         }
988     
989         if (v == HandAccessory.SPIKED_BASEBALL_BAT) {
990             return "Spiked Baseball Bat";
991         }
992     
993         if (v == HandAccessory.ENERGY_DRINK) {
994             return "Energy Drink";
995         }
996     
997         if (v == HandAccessory.NINJA_STARS) {
998             return "Ninja Stars";
999         }
1000     
1001         if (v == HandAccessory.NUNCHUCKS) {
1002             return "Nunchucks";
1003         }
1004     
1005         if (v == HandAccessory.POOP) {
1006             return "Poop";
1007         }
1008     
1009         if (v == HandAccessory.FLAMETHROWER) {
1010             return "Flamethrower";
1011         }
1012     
1013         if (v == HandAccessory.HOOKS) {
1014             return "Hooks";
1015         }
1016     
1017         if (v == HandAccessory.WEIGHTS) {
1018             return "Weights";
1019         }
1020     
1021         if (v == HandAccessory.SKULL) {
1022             return "Skull";
1023         }
1024     
1025         if (v == HandAccessory.BRAIN) {
1026             return "Brain";
1027         }
1028         revert("invalid handaccessory");
1029     }
1030     
1031     function toString(Mouth v) external pure returns (string memory) {
1032         if (v == Mouth.NONE) {
1033             return "";
1034         }
1035     
1036         if (v == Mouth.HAPPY) {
1037             return "Happy";
1038         }
1039     
1040         if (v == Mouth.MAD) {
1041             return "Mad";
1042         }
1043     
1044         if (v == Mouth.SMILE) {
1045             return "Smile";
1046         }
1047     
1048         if (v == Mouth.FANGS) {
1049             return "Fangs";
1050         }
1051     
1052         if (v == Mouth.HAPPY_FANGS) {
1053             return "Happy Fangs";
1054         }
1055     
1056         if (v == Mouth.MAD_FANGS) {
1057             return "Mad Fangs";
1058         }
1059     
1060         if (v == Mouth.SMILE_FANGS) {
1061             return "Smile Fangs";
1062         }
1063     
1064         if (v == Mouth.SINGLE_TOOTH) {
1065             return "Single Tooth";
1066         }
1067     
1068         if (v == Mouth.DIRTY_TEETH) {
1069             return "Dirty Teeth";
1070         }
1071     
1072         if (v == Mouth.SMILE_DIRTY_TEETH) {
1073             return "Smile Dirty Teeth";
1074         }
1075     
1076         if (v == Mouth.MAD_DIRTY_TEETH) {
1077             return "Mad Dirty Teeth";
1078         }
1079     
1080         if (v == Mouth.BLOODY_FANGS) {
1081             return "Bloody Fangs";
1082         }
1083     
1084         if (v == Mouth.BLACK_MASK) {
1085             return "Black Mask";
1086         }
1087     
1088         if (v == Mouth.HAPPY_BUCK_TEETH) {
1089             return "Happy Buck Teeth";
1090         }
1091     
1092         if (v == Mouth.HAPPY_SINGLE_TOOTH) {
1093             return "Happy Single Tooth";
1094         }
1095     
1096         if (v == Mouth.MAD_SINGLE_TOOTH) {
1097             return "Mad Single Tooth";
1098         }
1099     
1100         if (v == Mouth.SMILE_SINGLE_TOOTH) {
1101             return "Smile Single Tooth";
1102         }
1103     
1104         if (v == Mouth.BREATHING_FIRE) {
1105             return "Breathing Fire";
1106         }
1107     
1108         if (v == Mouth.GOLD_GRILLS) {
1109             return "Gold Grills";
1110         }
1111     
1112         if (v == Mouth.KISS) {
1113             return "Kiss";
1114         }
1115     
1116         if (v == Mouth.SMOKING_JOINT) {
1117             return "Smoking Joint";
1118         }
1119         revert("invalid mouth");
1120     }
1121     
1122     function toString(Eyes v) external pure returns (string memory) {
1123         if (v == Eyes.NONE) {
1124             return "";
1125         }
1126     
1127         if (v == Eyes.BLACK_EYE) {
1128             return "Black Eye";
1129         }
1130     
1131         if (v == Eyes.BLACKOUT) {
1132             return "Blackout";
1133         }
1134     
1135         if (v == Eyes.BLEEDING) {
1136             return "Bleeding";
1137         }
1138     
1139         if (v == Eyes.BLOODSHOT) {
1140             return "Bloodshot";
1141         }
1142     
1143         if (v == Eyes.WATERY) {
1144             return "Watery";
1145         }
1146     
1147         if (v == Eyes.WHITE) {
1148             return "White";
1149         }
1150     
1151         if (v == Eyes.BIGGER_BLACK_EYES) {
1152             return "Bigger Black Eyes";
1153         }
1154     
1155         if (v == Eyes.BIGGER_BLEEDING) {
1156             return "Bigger Bleeding";
1157         }
1158     
1159         if (v == Eyes.BIGGER_WATERY) {
1160             return "Bigger Watery";
1161         }
1162     
1163         if (v == Eyes.SMALLER_BLACK_EYES) {
1164             return "Smaller Black Eyes";
1165         }
1166     
1167         if (v == Eyes.SMALLER_BLEEDING) {
1168             return "Smaller Bleeding";
1169         }
1170     
1171         if (v == Eyes.SMALLER_BLOODSHOT) {
1172             return "Smaller Bloodshot";
1173         }
1174     
1175         if (v == Eyes.SMALLER_WATERY) {
1176             return "Smaller Watery";
1177         }
1178     
1179         if (v == Eyes.SMALLER) {
1180             return "Smaller";
1181         }
1182     
1183         if (v == Eyes.SUNGLASSES) {
1184             return "Sunglasses";
1185         }
1186     
1187         if (v == Eyes.EYE_PATCH) {
1188             return "Eye Patch";
1189         }
1190     
1191         if (v == Eyes.VR_HEADSET) {
1192             return "VR Headset";
1193         }
1194     
1195         if (v == Eyes.DEAD) {
1196             return "Dead";
1197         }
1198     
1199         if (v == Eyes._3D_GLASSES) {
1200             return "3D Glasses";
1201         }
1202     
1203         if (v == Eyes.HEART_EYES) {
1204             return "Heart Eyes";
1205         }
1206     
1207         if (v == Eyes.LASER_GLASSES) {
1208             return "Laser Glasses";
1209         }
1210     
1211         if (v == Eyes.NINJA_MASK) {
1212             return "Ninja Mask";
1213         }
1214     
1215         if (v == Eyes.LASER_EYES) {
1216             return "Laser Eyes";
1217         }
1218         revert("invalid eyes");
1219     }
1220     
1221     function toString(HeadAccessory v) external pure returns (string memory) {
1222         if (v == HeadAccessory.NONE) {
1223             return "";
1224         }
1225     
1226         if (v == HeadAccessory.BUCKET_HAT) {
1227             return "Bucket Hat";
1228         }
1229     
1230         if (v == HeadAccessory.FLOWER) {
1231             return "Flower";
1232         }
1233     
1234         if (v == HeadAccessory.SPORTS_HEADBAND) {
1235             return "Sports Headband";
1236         }
1237     
1238         if (v == HeadAccessory.CHEF_HAT) {
1239             return "Chef Hat";
1240         }
1241     
1242         if (v == HeadAccessory.BLUE_DURAG) {
1243             return "Blue Durag";
1244         }
1245     
1246         if (v == HeadAccessory.RED_DURAG) {
1247             return "Red Durag";
1248         }
1249     
1250         if (v == HeadAccessory.SPIKY_HAIR) {
1251             return "Spiky Hair";
1252         }
1253     
1254         if (v == HeadAccessory.BONES) {
1255             return "Bones";
1256         }
1257     
1258         if (v == HeadAccessory.RICE_HAT) {
1259             return "Rice Hat";
1260         }
1261     
1262         if (v == HeadAccessory.BEANIE_CAP) {
1263             return "Beanie Cap";
1264         }
1265     
1266         if (v == HeadAccessory.SANTA_HAT) {
1267             return "Santa Hat";
1268         }
1269     
1270         if (v == HeadAccessory.HEAD_WOUND) {
1271             return "Head Wound";
1272         }
1273     
1274         if (v == HeadAccessory.HEADPHONES) {
1275             return "Headphones";
1276         }
1277     
1278         if (v == HeadAccessory.GOLD_STUDS) {
1279             return "Gold Studs";
1280         }
1281     
1282         if (v == HeadAccessory.WIZARD_HAT) {
1283             return "Wizard Hat";
1284         }
1285     
1286         if (v == HeadAccessory.LONG_HAIR) {
1287             return "Long Hair";
1288         }
1289     
1290         if (v == HeadAccessory.AIR_PODS) {
1291             return "Air Pods";
1292         }
1293     
1294         if (v == HeadAccessory.WHITE_PARTY_HAT) {
1295             return "White Party Hat";
1296         }
1297     
1298         if (v == HeadAccessory.BLUE_PARTY_HAT) {
1299             return "Blue Party Hat";
1300         }
1301     
1302         if (v == HeadAccessory.RED_PARTY_HAT) {
1303             return "Red Party Hat";
1304         }
1305     
1306         if (v == HeadAccessory.GREEN_PARTY_HAT) {
1307             return "Green Party Hat";
1308         }
1309     
1310         if (v == HeadAccessory.YELLOW_PARTY_HAT) {
1311             return "Yellow Party Hat";
1312         }
1313     
1314         if (v == HeadAccessory.PURPLE_PARTY_HAT) {
1315             return "Purple Party Hat";
1316         }
1317     
1318         if (v == HeadAccessory.PIRATE_HAT) {
1319             return "Pirate Hat";
1320         }
1321     
1322         if (v == HeadAccessory.KING_CROWN) {
1323             return "King Crown";
1324         }
1325     
1326         if (v == HeadAccessory.JOKER_HAT) {
1327             return "Joker Hat";
1328         }
1329     
1330         if (v == HeadAccessory.DEVIL_HORNS) {
1331             return "Devil Horns";
1332         }
1333     
1334         if (v == HeadAccessory.BRAINS) {
1335             return "Brains";
1336         }
1337         revert("invalid headaccessory");
1338     }
1339 }
1340 
1341 // File: contracts/Sprites.sol
1342 
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 
1347 library Sprites {
1348     bytes public constant BODY_SPRITE = hex"4D50300259820013541196AAB08009428012D615975C50049180094B8CCBB0300248E004A5C765D81C012080024B0432EC900090480125825976490048280092594CB4C38A0027A4532D4D52800ACC14CBB25002416004928B65CB2C0098717579E58014112D9748B0029AA5D5EB16005760B65D92C0120C002494632E5980098655E698009C655E798005044C65D230014CCABD4300154CABD63000AEC18CBB2600239A004828D65CB34009871B579E6801411359748D0029AA6D5EB1A005764D65DA34011CE002416732D30E38009E91CCB5354E002B32732ED1C008E780120F3D9740F47513DCAA4C9ECBB47801209400094BA0CB586500049440094BA2CBB08802524004B35265A726900151649975D2004B4C0098AA6CBAC980120D50009C9A8CB54654004754009052ACB96A80130D55969C9AA005455565D65400AECAACBB4A80232C004725665A516B0013155996ACBAC005869665DB5801157002310BB2D24A5C0096B2ECB57617002CB6BB2EE2E008AC0011876197218004A600096830CBA2C00149661975D800596000B4DB0CBB8C00223200451D965C864012990025ACCB2EBB200B2C80169C6597759004468008A3B4CB90D001297680165A002D38D32EEB40088D8011466D971DB004A6C0096B36CBAED802D36005B71B65DD6C008A338004A2DC00262AE32D5977000B6E380096E80130F7596A08BA005255D65D6740131E00269CF32E7BC00A4F0014D4799755E004B7C00986BECB9CF8029BE005455F65D67C012E000261B032E74000A7000151581975A000261D08014D584000";
1349 
1350     function getBgHex(BgColor c) external pure returns (string memory) {
1351         // i don't think a map would be more efficient here, because SLOAD costs 800 gas.
1352         if (c == BgColor.DARK_BLUE) {
1353             return "2B3585";
1354         }
1355         if (c == BgColor.GRAY) {
1356             return "868586";
1357         }
1358         if (c == BgColor.LIGHT_BLUE) {
1359             return "57C8E5";
1360         }
1361         if (c == BgColor.ORANGE) {
1362             return "F3952E";
1363         }
1364         if (c == BgColor.PINK) {
1365             return "EABED9";
1366         }
1367         if (c == BgColor.PURPLE) {
1368             return "8558A4";
1369         }
1370         if (c == BgColor.RED) {
1371             return "E76160";
1372         }
1373         if (c == BgColor.TAN) {
1374             return "EED498";
1375         }
1376         if (c == BgColor.TEAL) {
1377             return "7BCAB0";
1378         }
1379         if (c == BgColor.GREEN) {
1380             return "1A763B";
1381         }
1382         if (c == BgColor.RAINBOW) {
1383             return "FF0000";
1384         }
1385         revert("Invalid BgColor");
1386     }
1387 
1388     function getEyesSprite(Eyes v) external pure returns (bytes memory) {
1389         if (v == Eyes.NONE) {
1390             return hex"";
1391         }
1392         
1393         if (v == Eyes._3D_GLASSES) {
1394             return hex"925002594554C34A224E28AB3CA225229F4A6A1526AA53EAB1526B05002516004B30B224D2CAA9C796445044B0029265C9AA16FA5558B93572C012CC224C30AA9A718449E615691926A663E9515324D58C7D4B35969869A449C695679ACBA46B2D4D4364D54D7D5635969871CCB5354E6580";
1395         }
1396     
1397         if (v == Eyes.BIGGER_BLACK_EYES) {
1398             return hex"4B38A0029AC5002516004B38B26CF2C0148B0029AC5936B96009460025995798600134E32AF3CC00523000A6A1957AA6002B1957AE600251A004B34D26CE34013CD65D235974CD002A2C6936B9A004B34E004E39974CE65AA2C70000";
1399         }
1400     
1401         if (v == Eyes.BIGGER_BLEEDING) {
1402             return hex"4B38A0029AC5002516004B38BABCF2C0148B0029AC5D5EB96009460025995798600134E32AF3CC00523000A6A1957AA6002B1957AE600251A004B34D72CE34013CD65D235974CD002A2C6B96B9A0096700261CE59A700271CCBA6732EA1C00AA7396B1C00987B96A9EE5";
1403         }
1404     
1405         if (v == Eyes.BIGGER_WATERY) {
1406             return hex"4B38A0029AC5002516004B38BABCF2C0148B0029AC5D5EB96009460025995798600134E32AF3CC00523000A6A1957AA6002B1957AE600251A004B34D194E34013CD65D235974CD002A2C68CAB9A004B34E004E39974CE65AA2C70000";
1407         }
1408     
1409         if (v == Eyes.BLACK_EYE) {
1410             return hex"4C38A0029AA5002596004C38BABCF2C0148B0029AA5936B1600966002619579A6002719579E600291800A6655EA1800AA655EB180096680130E36AF3CD00523400A6A9A4DAC680130E3800A6A9C000";
1411         }
1412     
1413         if (v == Eyes.BLACKOUT) {
1414             return hex"4C38A0029AA50012CF2C00A4B16004B3CC00292C60012CF3400A4B1A004C38E0029AA70000";
1415         }
1416     
1417         if (v == Eyes.BLEEDING) {
1418             return hex"4C38A0029AA5002596004C38BABCF2C0148B0029AA5D5EB1600966002619579A6002719579E600291800A6655EA1800AA655EB180096680130E35CB3CD00523400A6A9AE5AC680261C009A739671C00A67002A1CE5AA700269EE5A87B940";
1419         }
1420     
1421         if (v == Eyes.BLOODSHOT) {
1422             return hex"4C38A0029AA500259600985C3E697439C5BCE79600A4580299712A85D0EA96FBAC58025980098650E698009C650E79800A4600299943A86002A9943AC600259A00986BEE69B439C6C4A79A00A4680299B0FA86D0EA9AF3AC680130E3800A6A9C00";
1423         }
1424     
1425         if (v == Eyes.DEAD) {
1426             return hex"4C38A65A9AA532E596CB985802696CB9C5802796CBA45B2E99600A85B2EA9600AC5B2D2CC319734C00271E632D493319750C002AAC632E59ACB98680269ACB9C680279ACBA46B2E99A00A86B2EA9A00AC6B2D30E3996A6A9CCB0";
1427         }
1428     
1429         if (v == Eyes.EYE_PATCH) {
1430             return hex"A0200280A005044600511C00A291000524C90029AC50014972C00A4C1800A46B2D4D734014CE65AA2C7000";
1431         }
1432     
1433         if (v == Eyes.HEART_EYES) {
1434             return hex"4B30A97CD29969C7952F524CA97D42996AAB152F4B3CB97A92C5CBD2CF325EA4B192F966B2D30E365F3CD65D23596A6A9B2FAC6B2E61CCB9A74BE71CCBA6732EA1D2FAA732C0";
1435         }
1436     
1437         if (v == Eyes.LASER_EYES) {
1438             return hex"4C38BA0A9AE5D06619414D38CA5A7A0650699941545CCA5AC3665053D03696A291B41586CDA5AE3E6D054523A96A6A1D415C7CEA5B04275054D43E96AAB1F416084FA5AAAC852D5D84282AEC234B59691A0ACB4952D6DC4A82B6E274B5D793A0AEBCA52D7E05282BF02B4BC2AD070AD4B0";
1439         }
1440     
1441         if (v == Eyes.LASER_GLASSES) {
1442             return hex"4928926A59E497941124E2A49927A545C92F58249B24A26A52E5002C144D9259352902D86A2A16D5555CB61D82C9B24C26A52E6002C184D92693528D35869C99AD5545CD61D8349A9871CCB5354E6580";
1443         }
1444     
1445         if (v == Eyes.NINJA_MASK) {
1446             return hex"8A500125828008CC1600492CC004C32AF34C004E32AE9E91800A6655EA1800AA655D598300092C1A004C38E65A9AA732C0";
1447         }
1448     
1449         if (v == Eyes.SMALLER_BLACK_EYES) {
1450             return hex"4B38A65A92A532D2CF2D96A4B16CB96600130D309B38C004F319748C65D33000A8A984DAC600259A00986D5D34E34013CD65D235974CD005436AEAAB1A004C34E26CE39974CE65AA2A7134";
1451         }
1452     
1453         if (v == Eyes.SMALLER_BLEEDING) {
1454             return hex"4C3CA65A92A532E596CB4C34B00271E5B2D4932D96A8A9600AC5B2E5980098655D34E30013CC65D231974CC005432AEAAB180096680130D35CB38D004F359748D65D33400A8A9AE5AC680261CE59A700271CCBA6732EA1CE5AA700261EE5A87B94";
1455         }
1456     
1457         if (v == Eyes.SMALLER_BLOODSHOT) {
1458             return hex"4C3CA65A92A532E596CB4C34B00271E5B2D4932D96A8A9600AC5B2E5980098650D34E30013CC65D231974CC00543286AAB180096680261B309A6D0E71A009E6B2E91ACBA66802A1B30AA6D0EB1A004C34E004E39974CE65AA2A70000";
1459         }
1460     
1461         if (v == Eyes.SMALLER) {
1462             return hex"4C38A65A9AA532E596CB4C34B00271E5B2D4932D96A8A9600AC5B2E5980098655D34E30013CC65D231974CC005432AEAAB180096680130D36AF38D004F359748D65D33400A8A9B57AC680130D380138E65D33996A8A9C000";
1463         }
1464     
1465         if (v == Eyes.SMALLER_WATERY) {
1466             return hex"4C3CA65A9AA532E596CB4C34B00271E5B2D4932D96A8A9600AC5B2E5980098655D34E30013CC65D231974CC005432AEAAB180096680130D346538D004F359748D65D33400A8A9A32AC680130D380138E65D33996A8A9C000";
1467         }
1468     
1469         if (v == Eyes.SUNGLASSES) {
1470             return hex"4928A1AA59C53113D2286AA6B14C45760A1ACA2D8896616009A58D6716009E5B12916C4A658D55152C0158B1AD72D8928C624B300130C1AA69C6002798C4A463114D4300154C1AD630015CC624A35892CD1AA61A680271AC49E6B2E91ACBA66B12A1A355558D005735889669CC49C732E99CCB5458E620";
1471         }
1472     
1473         if (v == Eyes.VR_HEADSET) {
1474             return hex"4960A00249458012CC2C9B34B21A71E5936816435148B26D32C86A8A964DAC590D5D82C0128C004B309B30C21A69C6136798435044C26D23086A6A184DAA610EB184DAE600251A0096690D30D349B38D21A7A0693689A43524CD26D43486AAB1A4DAE68012D63800";
1475         }
1476     
1477         if (v == Eyes.WATERY) {
1478             return hex"4C38A0029AA5002596004C38BABCF2C0148B0029AA5D5EB1600966002619579A6002719579E600291800A6655EA1800AA655EB180096680130E34653CD00523400A6A9A32AC680130E3800A6A9C000";
1479         }
1480     
1481         if (v == Eyes.WHITE) {
1482             return hex"4C38A0029AA5002596004C38BABCF2C0148B0029AA5D5EB160096600130E32AF3CC00523000A6A9957AC600259A004C38DABCF340148D0029AA6D5EB1A004C38E0029AA70000";
1483         }
1484         revert("invalid eyes");
1485     } 
1486     
1487     function getHeadAccessorySprite(HeadAccessory v) external pure returns (bytes memory) {
1488         if (v == HeadAccessory.NONE) {
1489             return hex"";
1490         }
1491 
1492         if (v == HeadAccessory.AIR_PODS) {
1493             return hex"461CEABAD36755E31F57B67D5E32157B6855C0";
1494         }
1495     
1496         if (v == HeadAccessory.BEANIE_CAP) {
1497             return hex"495400048040092A82B3565C10049080094B84B3B01002486004A5C359D80C0124400252E22CEC0800902801258153F6450048180124659CA19072C659CC190734659CE19073C659D0190744659D219074C659D4190754659D619075C659D8190764600481C0124759CA1D072C759CC1D0734759CE1D073C759D01D0744759D21D074C759D41D0754759D61D075C759D81D076470024B04000";
1498         }
1499     
1500         if (v == HeadAccessory.BLUE_DURAG) {
1501             return hex"4D50322A5AC2115297148B68522A4B231152581C8B68722A43241140";
1502         }
1503     
1504         if (v == HeadAccessory.BLUE_PARTY_HAT) {
1505             return hex"94000270000A60002B80009208025024A960802682009C092A78200A408029824AA80802B0200AE092AC02009210025044A961002684009C112A78400A410029844AA81002B0400AE112AC040092180128B0C9530300269E19294110C00A4A064AAA18015970C956030049100094B884AB0200248A004A5C52558140124600252E312AC0C00496070000";
1506         }
1507     
1508         if (v == HeadAccessory.BONES) {
1509             return hex"8C6002D98008A680231B57B66D5EE1A008A700231D198E755E41D19B27466D1D57B67466E1C008A780231F57B67D5EE1E008C8002DA000";
1510         }
1511     
1512         if (v == HeadAccessory.BRAINS) {
1513             return hex"4D5020025981802686E64E3C39E500DCCA29873CA81B995560C0128400259A24E6708D94F4049CD111B34849CD311B2A8B0939AE200248A00942B612CC161D3456CA7262C3AA0AD955585875715B1605004818009250D1496334930D1A293865EA7A4345298CBD545468A5619A4AEC0D14B2300120A1C012C763261C3C3278EBD5044786521D7AA6A8F0CAC3B195D91C0096B10000";
1514         }
1515     
1516         if (v == HeadAccessory.BUCKET_HAT) {
1517             return hex"4C540004B040098A824AAC0802504004B582255708012830025AC192AB86009420012D610955C4004A140096B0A24AE2801209180094B8C4A5864600471C0090C8E4AB438012192000";
1518         }
1519     
1520         if (v == HeadAccessory.CHEF_HAT) {
1521             return hex"47200002494055D2CE00009E9015753580002BB0055D65A00011810023B40D5ED82008C10011DA0AAF6C200470C0090C8757B418023880048644ABDA100090C8A009030012581AAF64600481C009268F579C38013D21EAF4C7002A303D5EC8E00496080000";
1522         }
1523     
1524         if (v == HeadAccessory.DEVIL_HORNS) {
1525             return hex"8C000238113900002C8000B4044ED80008C08011C8062724100580400B2D0313B60802384004824289A51610015970800B0C8513B4100238600482C389CC0C01543002B301C4EC860090200124B122730400551000ACC0913B2200124B1400ACC0A000";
1526         }
1527     
1528         if (v == HeadAccessory.FLOWER) {
1529             return hex"981CD6589079824E268907942CD658B38982D1668B389C2CD658D079834E268D07983CD4";
1530         }
1531     
1532         if (v == HeadAccessory.GOLD_STUDS) {
1533             return hex"8E7C7ED1F1F0";
1534         }
1535     
1536         if (v == HeadAccessory.GREEN_PARTY_HAT) {
1537             return hex"94000270000A60002B800092080250257960802682009C095E78200A4080298257A80802B0200AE095EC020092100250457961002684009C115E78400A4100298457A81002B0400AE115EC040092180128B0CAF30300269E195D4110C00A4A0657AA18015970CAF6030049100094B8857B0200248A004A5C52BD8140124600252E315EC0C00496070000";
1538         }
1539     
1540         if (v == HeadAccessory.HEADPHONES) {
1541             return hex"4C54100259810015560800925860056603002412200161910008E40A005968500230E300169B1801187005B1C008A310005B708004524017090045280170A00452C011CB0AC82C1564B055A2C2B70B0045300118C0FC7302B20C0559301568C0ADB303F70C00228C687E39A1590682AC9A0AB468556DC343E8A31C1F8E705641C0AB2702AD1C155B70E0FC63C3F1CF0AC83C1564F055A3C2B6CF0FC7402B210055940156900A80";
1542         }
1543     
1544         if (v == HeadAccessory.HEAD_WOUND) {
1545             return hex"4B304004A14012C5A34C1629345004918012865ECB1A2930600251638000";
1546         }
1547     
1548         if (v == HeadAccessory.JOKER_HAT) {
1549             return hex"452800028220002B8000586C0945C000088582009E080141106A748100560400AEE0328BA080110D08013C2002822154E9040054542002B3214A169B0801702945D080114300241E18014110EA6A4986005460394590C01703002422200149812516440024A0280145716516050024A030014571A5160600252E3800";
1550         }
1551     
1552         if (v == HeadAccessory.KING_CROWN) {
1553             return hex"4928000282200015D800012010024940D3E582009E0801411069F48100560400AEC034FB20802484004A2C2A7A61A10027840050442A7D20800A8A8400565C2A7D8080124300251A1D3E706004F483A7D30C00A8B874FB01802488004A5C4A7D81001245004A169F2C555A61E2D3E80AAB51505A7D51556ACB8B4FB0280248C004A2C6A7CC1A389A80D4FA234714951A9F5868E571A9F6060024B03800";
1554         }
1555     
1556         if (v == HeadAccessory.LONG_HAIR) {
1557             return hex"4D503764B11D898A8905AC23B250AEC4B585905715D924676252E34EAC0CEC903BB124A1E74AEC0F3AB23BB12092274B0C913A904CEAC933A9054EAC953A905CEAC973A9064EAC993A906CEAC9B3A9074EAC9D3A907CEAC9F3A9084EACA13A908CEACA33A9094EACA53A909CEACA73A90A4EACA93A90ACEACAB3A90B4EACAD3A90BCEACAF3A0";
1558         }
1559     
1560         if (v == HeadAccessory.PIRATE_HAT) {
1561             return hex"9A000138F01E2A088000524C078D40001301004D05E3381004F05E2A088200A40BC698200A80BC6A8200961002604F14D3C200282213C5494080154278D60801283004B0DE298A8600AC1BC6B86004720400249423C52CF1000A0888E752584002BB023C565A10008A30A004720578A49C280278B5750445005216AEA6C0A005968578ADB8280119B18008E70E005368700249840015582000";
1562         }
1563     
1564         if (v == HeadAccessory.PURPLE_PARTY_HAT) {
1565             return hex"94000270000A60002B8000920802502A2960802682009C0A8A78200A40802982A2A80802B0200AE0A8AC0200921002504A2961002684009C128A78400A41002984A2A81002B0400AE128AC040092180128B0D4530300269E1A894110C00A4A06A2AA18015970D456030049100094B88A2B0200248A004A5C55158140124600252E328AC0C00496070000";
1566         }
1567     
1568         if (v == HeadAccessory.RED_DURAG) {
1569             return hex"4D5037525AC23A929715D56857524B233A92581DD568775243243A80";
1570         }
1571     
1572         if (v == HeadAccessory.RED_PARTY_HAT) {
1573             return hex"94000270000A60002B8000920802502E4960802682009C0B9278200A40802982E4A80802B0200AE0B92C0200921002504E4961002684009C139278400A41002984E4A81002B0400AE1392C040092180128B0DC930300269E1B914110C00A4A06E4AA18015970DC96030049100094B88E4B0200248A004A5C57258140124600252E3392C0C00496070000";
1574         }
1575     
1576         if (v == HeadAccessory.RICE_HAT) {
1577             return hex"4E4C0004D04009C9833DA80802604004D502885508012C300262A1CF6B06009420012D612215C400249428012D615C0AEC0A00472060024B0344165A18011870023B43CF6D8E0047688000";
1578         }
1579     
1580         if (v == HeadAccessory.SANTA_HAT) {
1581             return hex"4854000230E08012150650ACB82008A10011870AAF2020024AE14A2C04008A18011870EAE90486004A5C394580C008C38800922001297125160400481401245944A16032C5944C1603345944E16033C594501603445945216034C594541603545945616035C59458160364500481801246744A19DF2C6744C19DF346744E19DF3C6745019DF446745219DF4C6745419DF546745619DF5C6745819DF64600481C01247ABCA1E952C7ABCC1E95347ABCE1E953C7ABD01E95447ABD21E954C7ABD41E95547ABD61E955C7ABD81E956470024B040000";
1582         }
1583     
1584         if (v == HeadAccessory.SPIKY_HAIR) {
1585             return hex"96080278200A40802B02004C34200282210015150801184005B10008E40A00596850045240170900230E500169B28000";
1586         }
1587     
1588         if (v == HeadAccessory.SPORTS_HEADBAND) {
1589             return hex"4A2C56DA62A2BA559715B724669CA19B69660CE94D3C68AA82234BA90C51535068AAAAC33A6B8CDBB0334E48ED3943B6D2CC1DD29A78F15A03CBA88F57A439454D41E2AAAB0EE9AE3B6EC0ED34A2C86DA62A43A559721B60";
1590         }
1591     
1592         if (v == HeadAccessory.WHITE_PARTY_HAT) {
1593             return hex"94000270000A60002B800092080250357960802682009C0D5E78200A4080298357A80802B0200AE0D5EC020092100250557961002684009C155E78400A4100298557A81002B0400AE155EC040092180128B0EAF30300269E1D5D4110C00A4A0757AA18015970EAF6030049100094B8957B0200248A004A5C5ABD8140124600252E355EC0C00496070000";
1594         }
1595     
1596         if (v == HeadAccessory.WIZARD_HAT) {
1597             return hex"9E00014110043480004E04009E90221A60802704004F48210D30801343002720188688754524C310D40C0096608004D3C410D012A8A2A08215558400249428012D01443445AA292C28855D814012060024B03086C8C00466C70000";
1598         }
1599     
1600         if (v == HeadAccessory.YELLOW_PARTY_HAT) {
1601             return hex"94000270000A60002B80009208025034E960802682009C0D3A78200A408029834EA80802B0200AE0D3AC02009210025054E961002684009C153A78400A410029854EA81002B0400AE153AC040092180128B0E9D30300269E1D394110C00A4A074EAA18015970E9D6030049100094B894EB0200248A004A5C5A758140124600252E353AC0C00496070000";
1602         }
1603         revert("invalid headaccessory");
1604     } 
1605     
1606     function getOutfitSprite(Outfit v) external pure returns (bytes memory) {
1607         if (v == Outfit.NONE) {
1608             return hex"";
1609         }
1610 
1611         if (v == Outfit.ARMOR) {
1612             return hex"47253002C34980232800472544E251AA0015175000B0D28B6B6A0022AA008CAA723AA8F482D51ECC5457355492726A802A2A92AAA8AEB2A3DAEA8AD619547B695495B556D715004658008E42C3D92B0AE52C0096B0F662C2B9AB23D39359255164E5558575961ED7580161615ACB4B0F6DAC008AB80232E9C4721747A494B8025AE3D98B8AD3505D1EA2A2E9CAAB8AEB2E3D57617002CB4BA3EDAE9CB8B8022B0008CC2723B08F90C0025300096C0F66302B4D45847A928C272AB02BACC0F6BB000B2C002D308FB6C272E300088C8011476457219004A6400966323D9AC8AD392651F4D94E546456AAB323DAEC802CB2005A71915DD640111A004569388C3B48F90D0025340096D15930D687A9C9B42B5455A1ED668AD5DA00596800B4DB48FB8D272EB40088D8011466D391DB004A6C012DB34261CD8AD3D26C7AA6AB62BACD9A2BB600B4D8016DC6D3975B00228CE00128B700131C15A69CE23E7B82B5045C2B527056A6A388FAAE0AD5977000B6E380096E80130D75389C7BA8F5045D002926EA3D515753959D004B780131E4E269CF1A27BC00A4F0014D478D155E4E5678012DF00261AF8AE73E00A6F8015157C5759F004A8000966409C9B023E74000A70002A408F555A04E578001261004A8538966C28F9D08029C200545A147D78539621000";
1613         }
1614     
1615         if (v == Outfit.BLUE_AND_WHITE) {
1616             return hex"4C354002A2AA0025AA004C355252726A8015155495595004B580098AAC4AACB00252E004B59725575C012980025ACC12ABB00094C8012D664955D900252ED002536004B59BABD76C00945B8004C55CABAB2EE0025BA004C3DDABA822E80149576AF59D0000";
1617         }
1618     
1619         if (v == Outfit.BLUE_SHORTS) {
1620             return hex"4A5DA004A6C0096B364AAED80128B700098AB84A565DC004B7400987BA4A5045D00292AE92AB3A00";
1621         }
1622     
1623         if (v == Outfit.BROWN_AND_BLUE) {
1624             return hex"4C354002A2AA0025AA004C355612726A8015155585595004B580098AACC2ACB00252E004B59761575C012980025ACC30ABB00094C8012D665855D900252ED002536004B59B25576C00945B8004C55C252B2EE0025BA004C3DD252822E801495749559D0000";
1625         }
1626     
1627         if (v == Outfit.BROWN_AND_WHITE) {
1628             return hex"4C354002A2AA0025AA004C355612726A8015155585595004B580098AACC2ACB00252E004B59761575C012980025ACC30ABB00094C8012D665855D900252ED002536004B59BABD76C00945B8004C55CABAB2EE0025BA004C3DDABA822E80149576AF59D0000";
1629         }
1630     
1631         if (v == Outfit.CAMO) {
1632             return hex"48354002A32A0023AA0090A94A4AA6F94A9C92CC54A5355272726A802A2A4EAAAA82B2A52AEAA82C2A72B2A996D2A008CB0023AC6F90B14A4AC6594B0012CC5941356274E58A53D637D058A5456505258CB4D62954589CAAB2C52AEB0016195941696295B580115700230EB9CA42EA049297004B5CCB317504D5C9D397504F5CE541750515CCB49737D35CE551727555CE559732ABB0B802CAE52B4B9BEDAE72B8B8022B0008CC1963B05290C0025300096C282630729AC13A730529EC19683052A2C1BE93052A6C196A304EAAC282B3065AEC002CB000B4C14ADB065B8C002232008ACA8118764DF219004A64012D9394C64DF359274E65413D932D064E5459502926C9CAA324EAAC94AB326FAEC802CB200B4C9CADB26FB8C94AEB20094D0012CF689CA08B4E15259A2757680129B004B6CDF31B294D6D4139B394F6D4141B39516D40A4A36655559B29576C00945B80098E1966B8529CE1967B8A0A0E14A8B86FA4E1CA9B852A8E282AB865565DC004B740131D32CD74A539D37CF74A4A08BA00A4E94A9BAA0A8E94AABA72ACE8025BC0098F14A6BCA09CF14A7BC00A4F0029BC65A8F1BEABC52ACF0025BE0098F9CA6BE6F9CF8029BE00A8F9BEABE52ACF80128B8000986C0DC9D00029C000545606E2B2F00024C2004A3616E4E84014E1002A2F0B72C42000";
1633         }
1634     
1635         if (v == Outfit.GOLD_CHAIN) {
1636             return hex"4C354002A2AA0025AA009AAD5D3935401515ABD654012D6004D5AAF396A7A7A4B55E9AD36A8B55EB2C0094B80130E5EAF3D7A7A822BD5E92F3653557ABD75C0129800259EC55E8314FA2C4D949662AF5D8004A640096B3357AEC801297680129B0025ACD92ABB6004A2DC00262AE12959770012DD00261EE9294117400A4ABA4AACE8000";
1637         }
1638     
1639         if (v == Outfit.GRAY_PANTS) {
1640             return hex"4A5DA004A6C00967B6805045B00292CDA02BB60094E0012CE71013DC002822E202938005359C405770012DD00262AEA02B3A0096F00130E7900A08BC005355E40567800986BE805455F400";
1641         }
1642     
1643         if (v == Outfit.HOBO) {
1644             return hex"4C354002A2AA0025AA004C355574E54014D5002A2AAABAB2A0096B00130E595CA6AACAEACB00252E004B3D7572928BABAB2EAEAEB802530004B3D857292CC2BABB00094C8012CC655C9C832AE525995757640094BB40094D8012D66D535DB002516E0013557152ACBB80096E80130F7552A08BA005355D54D67400";
1645         }
1646     
1647         if (v == Outfit.KARATE_UNIFORM) {
1648             return hex"48354002A32A0023AA0048355ABA726A80151956AF695004658008E7AD57A0B49545A5AAF6D600455C008C42F574929700259CBD5E7AF2550597ABABB0B80165B5EAF717004560008C3B15790C002530004B358ABCE624A9EB3157AEC002CB0005A6D8ABDC600111900228ECC964320094C8012CC66AF35992A72CCD5EBB200B2C80169C664B75900252ED0025360096DC9530F6EAEA08B6005259BABD76C0129C00259CE55E7B8005045CABD27000A6B3957AEE00253A004B59DABD774012DE00261CF55D3D27800A6ABD57ACF0025BE004C35FABCE7C014DF002A2AFD5EB3E00";
1649         }
1650     
1651         if (v == Outfit.LOUNGEWEAR) {
1652             return hex"4C354002A2AA00120D54949C9AA00546552523B4B1291885C952970025ACB92ABAE00596D725230EC12A530004B59825576000B4DB04A451D9254A640096B324AAEC80169C649494BB40094D8012CF6D00A08B6005259B40576C0129C00259CE2027B8005045C40527000A6B3880AEE0025BA004C55D405674012DE00261CF2014117800A6ABC80ACF00130D7D00A8ABE800";
1653         }
1654     
1655         if (v == Outfit.LUMBERJACK) {
1656             return hex"48354002A32A0023AA0090AB3A4AAAC94AB3A5AAAC98AB3A6AAAC4E4D50054559D5555656559D5D55658559D655565A54011960047586921656495869296004B5869316564D5869396564F58694165651586949656535869516565558695965657580161656595869696565B5801157002310BB3924A5C012D7564C5D9D357564E5D9D3D756505D9D45756525D9D4D756545D9D55756565D9CAEC2E00B2BAB2D2ECEB6BAB2E2E008AC002330AC8EC0D24300094C0025B03498C2B26B0349CC2B27B034A0C2B28B034A4C2B29B034A8C2B2AB034ACC2B2BB000B2C002D30ACB6C0D2E300088C8022B2AC8CCB3A3B2AC90C8025320096CAB2632CE9ACAB2732CE9ECAB2832CEA2CAB2932CEA6CAB2A32CEAACAB2B32CEAEC802CB200B4CB3ADB2ACB8CB3AEB20094D0025B43498D2B26B4349CD2B27B434A0D2B28B434A4D2B29B434A8D2B2AB434ACD2B2BB40094D8012D66C3D5DB004A700096B381EAEE0025BA004C3DD0F2822E801495743D59D004B780131E244D78BB39E0ECF780149E0053783D51E2ED5789159E004B7C00986BE1E9CF8029BE005455F0F567C00945C0004C3600F4E80014E00054803B5600F2B2F00024C2004A36156CE84014E1002A2F0AB6C4200";
1657         }
1658     
1659         if (v == Outfit.NINJA_SUIT) {
1660             return hex"48354002A32A0011CB5400986AB224E4D50054541CAABAA3858695002316B00130D585739661CF5A44A0B2C2B576D6002298B80134E5C573D761D05E44A2AAE2B56717002290C002530004B3D80750618745891292CC03ABB00059718002210C801290640145961D26644A6BB20059759002522D002934C35359A9157680094BB6004A5DC00252EE8012D678009673E005359F0000";
1661         }
1662     
1663         if (v == Outfit.OVERALLS) {
1664             return hex"49354002A30A00124C55FB35529A726A802A2A53556157EC959FB296002598B3F66AC534E4D67ED458A6AAB2CFDAEB002C2CFD49297002598BBF66AE534E4D77ED45CA6AAB2EFD57617004A60012D87ECC60A73585F2726C14EA30BEAAC14EB30FDAEC002532004B39929A7A4C8E94D664A75D9004A6800966B4534E4DA1D2A2CD14EBB40094D8012D66CA75DB004A7000967B8535045C1D292CE14EBB80096E80130E74A73DD1D2822E80293A3A5355D29D674012DE00261AF14E73C3A9EF00293C00A6F0E951578A759E004B7C00986BE3A9CF8029BE005455F1D567C000";
1665         }
1666     
1667         if (v == Outfit.PAJAMAS) {
1668             return hex"48354002A32A0023AA00482953C4B54C33153C4D54C29C9AA00A8A9E2AAA61ACA9E15D954C3695004658008E4AC6194B0025AC6198B1E26AC619CB1E27AC61A0B1E28AC2EA4B1E29AC61A8B1E2AAC61ACB1E2BAC00586963C5B5801157002310B9E124A5C012D730CC5CF135730CE5CF13D730D05CF145717525CF14D730D45CF155730D65CF0AEC2E00596D730DC5C0115800230EC1864300094C0025B06198C1E26B0619CC1E27B061A0C1E28B02EA4C1E29B061A8C1E2AB061ACC1E2BB000B2C00169B60F1718004464008A3B27890C8025320096C986632789AC986732789EC98683278A2C8BA93278A6C986A3278AAC986B3278AEC802CB2005A71930DD640129A0025ACD0BABB40094D8025B66198D9E26B6619CD9E27B661A0D9E28B661A4D9E29B661A8D9E2AB661ACD9E2BB60094E0025B86198E1E26B8619CE1E27B861A0E1E28B861A4E1E29B861A8E1E2AB861ACE1E2BB80096E80263A789AE98673A789EE985411740149D3C5374C351D3C5574C359D004B780131E3C4D78C339E3C4F780149E005378C351E3C5578C359E004B7C0131F3C4D7CC339F00537C0151F3C557CC359F000";
1669         }
1670     
1671         if (v == Outfit.PINK_AND_PURPLE) {
1672             return hex"4C354002A2AA0025AA004C35566A726A801515559B595004B580098AACCDACB00252E004B59766D75C012980025ACC336BB00094C8012D6659B5D900252ED002536004B59B54D76C00945B8004C55C54AB2EE0025BA004C3DD54A822E801495755359D0000";
1673         }
1674     
1675         if (v == Outfit.PINK_SHORTS) {
1676             return hex"4A5DA004A6C0096B36F0AED80128B700098AB8F0565DC004B7400987BAF05045D00292AEBC2B3A00";
1677         }
1678     
1679         if (v == Outfit.PRIEST) {
1680             return hex"48354002A32A0011DA54008C7AC0050456ABA936B00115C5C008A430004A5D8002CB8C001108640094BB2005975900252ED0012976C0094BB8004B59D00259EF00149678009673E005359F00259D00014D680009674200535A1000";
1681         }
1682     
1683         if (v == Outfit.PURPLE_SHORTS) {
1684             return hex"4A5DA004A6C0096B36A9AED80128B700098AB8A9565DC004B7400987BAA95045D00292AEAA6B3A00";
1685         }
1686     
1687         if (v == Outfit.SKELETON) {
1688             return hex"48354002A32A0011C85400925AB574C555002B30AD5D65A54008C3AC0090B55D24B58009872D579EB0014115AAF4960029AAB55D5985801656ABAD36B0011465C011D7ABA41CB8013D25EAEA6CAE00B4BD5D6DC5C008A330008EC55E430004A3D8002822C55D4976001658005A62AEB6E300044159004666AE8E432004A3D9002822CD5D4976400B2D3200B6CD5D71D6400882B4008CD55D1C86800947B4005045AABA92ED00165A68016DAABAE3AD002236008ADD5D1876C00947B6005045BABA92ED80169B6C0171BABDD6C008A338004A3DC002822E55D4977000B6E38004B35D00271EED5D4117400A49BB575459D004C780135EABA71EF001493780151EABD578009663E009AFD5E73E00A6F802A3F575559F004B8001320ABA69D00014D48001560ABD68000987420053561000";
1689         }
1690     
1691         if (v == Outfit.SPEEDO) {
1692             return hex"94D0012D669975DA004A6C0096B3677AED80139370EF3DD3BA822E80293A77";
1693         }
1694     
1695         if (v == Outfit.SPORTS_JERSEY) {
1696             return hex"4C354002A2AA0025AA0098AD5E6AABC4E4D500545579555ABD654012D6004C5AAF3565E4E59989E92CD1A6B332A2CBCAAB55EB2C0094B8025AF5798BAF134E5D993D768D05EAEA29AED1A8BB32AAEBCACBD5EBAE0094C0025B0BC4C358662720C3468B157524D868AA2AC332B30BCAEC0025320096CAF2632D19ACB3139065A3459ABA926CB4551565995995E57640094BB4004B59B66262AE33130F7598A4ABACC0";
1697         }
1698     
1699         if (v == Outfit.TUX) {
1700             return hex"48354002A32A0011DA54008C6AC004E3D6ABA822B0014935AAEA8DAC00453970027A4BD5D4D45C00AAB2ED057717002290C00128E60009E93157535D8002CB8C001108640094732004F499ABA9AEC80165D640094734004F49AABA9AED00128E6C009E93757535DB00252EE0012D67400967BC005259E00259CF8014D67C009674000535A000259D08014D684000";
1701         }
1702     
1703         if (v == Outfit.UNDERGARMENTS) {
1704             return hex"4C354002A2AA0025AA009AAD5D3935401515ABD654012D60026A8B55EB2C0094B8013155EAF5D7004A600096B3157AEC002532004B599ABD7640094BB40094D8012D66EAF5DB002516E00131572AEACBB80096E80130F76AEA08BA005255DABD674000";
1705         }
1706     
1707         if (v == Outfit.WHITE_AND_BLUE) {
1708             return hex"4C354002A2AA0025AA009AAD5D3935401515ABD654012D60026A8B55EB2C0094B8013155EAF5D7004A600096B3157AEC002532004B599ABD7640094BB40094D8012D66C955DB002516E0013157094ACBB80096E80130F7494A08BA005255D255674000";
1709         }
1710     
1711         if (v == Outfit.WHITE_SHORTS) {
1712             return hex"4A5DA004A6C0096B3757AED80128B700098AB957565DC004B7400987BB575045D00292AED5EB3A00";
1713         }
1714         revert("invalid outfit");
1715     } 
1716     
1717     function getMouthSprite(Mouth v) external pure returns (bytes memory) {
1718         if (v == Mouth.NONE) {
1719             return hex"";
1720         }
1721 
1722         if (v == Mouth.BLACK_MASK) {
1723             return hex"90686AC9A1A4828E0D27A470015D9383528F0D25AC7802B9E1A4C55000251688693154400ACBA21A4D51200272698000";
1724         }
1725     
1726         if (v == Mouth.BLOODY_FANGS) {
1727             return hex"9C90027A557504524DD24AAF4D2004F4E99493A64F521B49486CF55A94956A00";
1728         }
1729     
1730         if (v == Mouth.BREATHING_FIRE) {
1731             return hex"5B70D942C3474A16DC3A8574E942A2E7CA161A3E84B6E1F4DBA7D0AF1F28514D0942A2E850961D429B790A15F42514119428A68D0951E469B7D1A16046513D294504A84A2F254DBE950B02528A09CA14534E84A8F274DBE9D0B02728514D4942A2EA50961D529B794A15F5250A8BAB2858695A12DB8AD36EAB42BCACA161A5A50B6E2D42BAB4A16DC5E500";
1732         }
1733     
1734         if (v == Mouth.DIRTY_TEETH) {
1735             return hex"9C90027A47EA091AA8A47EA491AA9A4000";
1736         }
1737     
1738         if (v == Mouth.FANGS) {
1739             return hex"9C90027A5575045200524AAF4D2004F4EAF493AB80";
1740         }
1741     
1742         if (v == Mouth.GOLD_GRILLS) {
1743             return hex"9C90027A4F4A094868A4F4A494869A4000";
1744         }
1745     
1746         if (v == Mouth.HAPPY_BUCK_TEETH) {
1747             return hex"9A8802A22004E3D2002822955D49348009E92600";
1748         }
1749     
1750         if (v == Mouth.HAPPY_FANGS) {
1751             return hex"9A8802A22009C90027A5575045200524AAF4D20027A49800";
1752         }
1753     
1754         if (v == Mouth.HAPPY) {
1755             return hex"9A8802A22004E4D20027A49800";
1756         }
1757     
1758         if (v == Mouth.HAPPY_SINGLE_TOOTH) {
1759             return hex"9A8802A22004E3D200504AAEA29A4004F4930000";
1760         }
1761     
1762         if (v == Mouth.KISS) {
1763             return hex"A28B7938F49974126A28A6932E8A6DE0";
1764         }
1765     
1766         if (v == Mouth.MAD_DIRTY_TEETH) {
1767             return hex"4F491004E48013D23F5048D54523F5248D54D20000";
1768         }
1769     
1770         if (v == Mouth.MAD_FANGS) {
1771             return hex"4F491004E48013D2ABA822932E92557A690027A757A49D5C";
1772         }
1773     
1774         if (v == Mouth.MAD) {
1775             return hex"4F491004E48009E924CBA69000";
1776         }
1777     
1778         if (v == Mouth.MAD_SINGLE_TOOTH) {
1779             return hex"4F491004E48013D265D04AAEA2924CBA690000";
1780         }
1781     
1782         if (v == Mouth.SINGLE_TOOTH) {
1783             return hex"4E3D200504AAEA29A400";
1784         }
1785     
1786         if (v == Mouth.SMILE_DIRTY_TEETH) {
1787             return hex"9C88029A2009C932E7A400A091AA8A47EA490029A4CB";
1788         }
1789     
1790         if (v == Mouth.SMILE_FANGS) {
1791             return hex"9C88029A2009C932E7A5575045200524AAF4D265CF4EAF493AB8";
1792         }
1793     
1794         if (v == Mouth.SMILE) {
1795             return hex"9C88029A2009C932D3D248014D2658";
1796         }
1797     
1798         if (v == Mouth.SMILE_SINGLE_TOOTH) {
1799             return hex"9C88029A2009C932E7A400A0955D45248014D26580";
1800         }
1801     
1802         if (v == Mouth.SMOKING_JOINT) {
1803             return hex"B06CCEB9D0AAE7BE6C20EDB08B6E8A441A491DA9A48FA89296AA4A4AC930EBA4D6";
1804         }
1805         revert("invalid mouth");
1806     } 
1807     
1808     function getHandAccessorySprite(HandAccessory v) external pure returns (bytes memory) {
1809         if (v == HandAccessory.NONE) {
1810             return hex"";
1811         }
1812 
1813         if (v == HandAccessory.BLOODY_KNIFE) {
1814             return hex"82B33D0425CF2841B07982CBAD0C464F311A3CC5680101B75A28CD9E60BAEB";
1815         }
1816     
1817         if (v == HandAccessory.BOW_AND_ARROW) {
1818             return hex"8C9A222A8888CA0F222A888CA8F222C888CB0F21AE888CB8F21B0888CC0F21B2888CC8F20343C4109A5AC3691088334B586DA223363C86E2223383C86EA2233A3C88F22233C3C88FA2233E3C8B02223403C8D0A200";
1819         }
1820     
1821         if (v == HandAccessory.BRAIN) {
1822             return hex"42197004160010988643617A882B10C8CC2F63B00080C8020B31484CAF50C666291D95EC8640101A004169B2843B50E90D0020360082DCE6136D94311B9CC56DB319B9CC76DB321B00208EE000";
1823         }
1824     
1825         if (v == HandAccessory.ENERGY_DRINK) {
1826             return hex"8A9D562295586A89D10556070D613A20AB40E1AE2788BB962AF0386C40E230278AC40D0C4660715913A188D40E2B4274311B81C56C4E";
1827         }
1828     
1829         if (v == HandAccessory.FLAMETHROWER) {
1830             return hex"80BCA20314282C4A1147604D019A6C166850999444644D159414664ED1D93348644C800B54D84D50A1B5284415A414668ED1DA3348684D01BA6C16E8509B94446C4D15B41466CED1DB33486C4D01CA14172508A338268EE1264382680ECA11C8744C";
1831         }
1832     
1833         if (v == HandAccessory.HOOKS) {
1834             return hex"4521809ACB8C04D108644AB2EB2254421A282CBAD1411076CC8B4EB6644519C3A2DB8E1D22BA80B8EA022BC808EF202D3C80B8F20233E80B6FA000";
1835         }
1836     
1837         if (v == HandAccessory.NINJA_STARS) {
1838             return hex"8AD2C2F34B086DAC22369A8AD9FEE36B0BADA6AF367F88E1FE2B89A8CE2C2EB87FBCE26AFB8B088EAC2EBAB0";
1839         }
1840     
1841         if (v == HandAccessory.NUNCHUCKS) {
1842             return hex"441DA44AD3AD226236898EDA26D3689BADA26238898EE226D3889BAE22623A898EEA26D3A89BAEA250C478011DE44DA7912BAF3C0088F8023BE895969F005D7C008E44000B500023C200";
1843         }
1844     
1845         if (v == HandAccessory.PITCHFORK) {
1846             return hex"82720611E818082061A081828A061A2818492050014D030D340C3510311540C4590315740C5610319940C669031DB40C7710321D40C87902";
1847         }
1848     
1849         if (v == HandAccessory.POOP) {
1850             return hex"82851E123408694C61272C82A46212B0986B3FA22EAF86C28D1056150841B296441994C2086D22D1076918841B6874419B4300";
1851         }
1852     
1853         if (v == HandAccessory.SKULL) {
1854             return hex"411D7002002C00108662AE8E4300080C80104766AF2190040680105AABA106D002235574519A00476AAF21A00406C0105BABA106D802237574519B00476EAF21B00407000823B95790E0020BA004219DABC7740105E00427AAF0DE00447AAF15E00467AAF1DE00210CF800";
1855         }
1856     
1857         if (v == HandAccessory.SPIKED_BASEBALL_BAT) {
1858             return hex"827A02020564005142C345010122B41490B0922B20869A162A68084A15A1A88588A15A0AA804315542C5590A8A32E858CC1C118764E11DA380";
1859         }
1860     
1861         if (v == HandAccessory.SWORD) {
1862             return hex"806A0601C814004F40C1410282122818492050834D030D440A188AA0622C818CB19A22E8145197334460CD158714660CC862B2668CCA0518769031DB4080";
1863         }
1864     
1865         if (v == HandAccessory.WAND) {
1866             return hex"829D460AB5086AD460AC7384B13E0AF5184B9CE1AE4F86C1CE2304F88C9CE2B24F8AD1CE3344F0";
1867         }
1868     
1869         if (v == HandAccessory.WEIGHTS) {
1870             return hex"84C05EFB017410990BAFC0C85D002682EBF0B4174005B0BA13EDBD58216C2E80138175F85C0BA084E85D7E0742F09E0BDF782E";
1871         }
1872         revert("invalid handaccessory");
1873     }
1874 } 
1875 
1876 // File: contracts/SpecialSprites.sol
1877 
1878 
1879 pragma solidity ^0.8.0;
1880 
1881 
1882 library SpecialSprites {
1883     function getSpecialSprite(Special v) external pure returns (bytes memory) {
1884         if (v == Special.ASTRONAUT) {
1885             return hex"40840022018081135406AEAB082044010202450AAC8C504044B582ABABC210110090C0894B875758843022010201124B12AE98708204F4440A292A202D59812AEB2F8804C0255B08804402050224942D5D2CD14409C80A145158505ABB02D5D661140900602411AAC8438C0448246ABA51A308138F1828A0B8C0B58646ABAD4230110071C089048F574A30710269E38514171C16B0C8F575A84702200C4012390B790455D24C20409A790145060805D922AF6885BADC2401100624091C95BC826AE92592204C3890A27B0482EC9357B44ADD6E1240880314048E52DE41557492CA10261C50513D8281764AABDA296EB7094044018B02472D6F20BABA496588130E2C289EC160BB25D5ED16B75B84B02200C6012398B790655D24A304096698144E60C05D932AF68C5BADC26011007340920DABA49468812CD34289CC1A0BB26D5D6A134088039C044824EABCA38409669C144E5CE05AC32755D69D380978EAB2FC270110083C0924FABCA3C409669E144E5CF05D83EAEB309E0440210022494855D2CD40289CB200B57610ABACC2801100244090D1AB2212881128C46AF3510A2728882D55746AEB10A204402920225AC955D5E14808805A60498998D3544EAF55331AB4298110075009214ABA494A1192CC52AE9AA286355594ABABB0A35ECA9575A85402200CA8111DA56AEB70AA0480B0120AD5642156022326B55EA2CD7556D6ABAE42B0110045C088A5AF574C3575BA724BD5E9AE46A8BD5EAAE4656717ABAEBEB81302F56C2B81100460088A4315792C01129762AF618022CB8C55D7616008801B20444219ABC96408945B26398CD5E6B2304E559ABAB2EC98EC320459759ABAF42C8110036808883B5574825A02252ED55D6196808B4EB5575E85A022006D8111076EAE904B6044A5DB6BAC32D81169D6EAEBD0B604400DC02220CE35D1C9700894BB9575869C022DBAE35D7A17008801BA044419DABA394E8112D676AEAED3A045B75DABAF42E8110037808882BD574629E02259EF55D4117808A4B3D57576DE022E3AF55D7A178088053E044B39F6BA7A4F8114D67DAEAF0BE04400E03EA20D03251CA80FA96741574F4A03EA9AD055D5DC80FABAFC063608603EC0856E8214263431615BA311098D24E86AE9E84263514A15BA9B10D5D65B84C6B90C2B70";
1886         }
1887     
1888         if (v == Special.DEVIL) {
1889             return hex"40100154500311800047022720000490030945802A4C4001FA8A600A951700316001559000168089DB0000B8E8058BC00357E000B18401FA00608FD10504551810023900C4E482009408A92CC047E9A78258504811FA9AE08AAC02005968189DB04017012C2EBE083582104B08010458431021FA28C10AA384004824289A516100131008B0A2A843F565C2002C32144ED0400B61161720081B8422C400CB104306A10619611050C7F18315470C0090587134C543002B301C4EC8600B419616E10C1A801080D431042C228C20FE3882A90200124B12273040026A8232EA88005660489D91000B50880D400C506A20A2961188147E9258A004C54565AB302801661141A8020C0D451862C47187F2062C49180094B8CCBB0300165A181B6C60CAE4230350031C1A8828E19462072C491C0094B8ECBB03802C8E0D5A7070CAEC23835002201A86310198E4162410004960865D92000B4E90195E80806E120330090CC1241A84392199048012582597649002D384866E9211BC4866F920D608490CA00E5066414004928A65A59C50013D22996A6B14005760A65D92800B4D94195C74A08AF4250650032C3310B08A28C586639611905802496CB9458012CE2E273CB0028225B2E916005358B89D72C0160B65D92C0168B08DB2C32B8E96115E7CB0CE02C2384B0CC03022821981988604514630331CC08C8300124C65CA30012CC89CC30009A719139E6001411319748C0029A8644EA9800AC644EB9800B0632EC9800B46046D98195C78C08DF3032C10981180684609A1984684619A1988684514634331CD0024126B2E51A004B34D89CE34009E91ACBA6680151636275CD002C326B2ED1A005B70D08DD3452BD01A11C268A601C11827065084382314E0CC638231CE002414732D2CD38009C99CCB5458E002BB2732ED1C00B6704571E38537CE08B04270A601E1182786611E118678A51063C231CF00241E7B2E81E8EA27B954993D9768F002DC278A500240228622029451D008A41280012974196B0CA0005A85014A0028845085445319108A39088A64A2004A39165A7A488014D74597611002CBC88A6FA21C6085114C0485305208A10E90A64241C9290A6524004B35265CE48009E924CBA6900151649975D2005848536520E2D3C90A57E0483985214A00498A61A61C441D314C84C3892526299698013154D9759300574C3961314ACB498716DC4C52BB0261CC298A60281C4109414C3503888328298EA07120D50009C9A8CB54654002D36A072E28295D8140E615052800AA1C84A8A50C654391D5002414AB2E5AA004C35565A726A8015155597595002BB2AB2ED2A005B8550E200AB07232C004725665A516B0013155996ACBAC005869665DB5800B90AC1C400970E2188B98A2AE004621765A494B8012D65D96AEC2E00596D765DC5C00BAF2E625F8570E2002C07108360C5118654560008C3B0CB90C0024B01C94C0012D0619745800292CC32EBB000B0C072CB0005A6D865DC6001758652F3EC18982160390190E2084C98A1B2CA88C8011476597219004964C52990025ACCB2EBB200B0C98ACB2005A71965DD6401799652FC0C98B0B21C4005A314269950DA85C468008A3B4CB90D0024B4624A5DA005868C565A002D38D32EEB400BCD42EFB4CA6085A31406CC505B65426E170DB91C46C008A336CB8ED8024366292DB2A536004B59B16576C0161B65596CC569B002DB8DB2EEB600BCDC8EFB70BC0DB2B0B66280E32A0B90B84E48E1B91D88E45914670011DC85C8719525C85A516E0013157058ACBB800B0E42ECB8CAB4E42D6DC700175C8B5E723B7DC91E0721785C6540759505D85C276470DD8EC4762D15D8EC676471DD85C8759525D85CA76472DD00261EE8B14117400A4ABA2CACE802BBB23B0EC2ECBACAB4EC2EDBB23B8EC76EBB16BCEC76FBB23C0EC2F0BACA80F32A0BD0B84F48E1BD1D88F45A2BD1D8CF48E3BD0B90F32A4BD0B94F48E5BD1D98F00134E78593DE002822F32A93C005351E1655780159E8ED77A4761E85D9799569E85DB7A4771E8EDD7A2D79E8EDF7A4781E85E1799501F17A084F8C50C57C5F19F18C77C5E904BE3194F8BE5BE004C35F164E7C009E83E2FA2F8C693E2FA6F8015157C5959F00577C5F61F18D97C5EB4E3E315D79F17AFC2F8C60405483011D08380A88834047472202A49808F2A02A4B8000986C0CB9D00013D280A94E0002A2B032EB4000576202A59808EB4EC054BD011D7E080A986023A00308E508384591211CC584591A11CC78458904C2394A2E116261D08013D08472A29422C53561005684735E1162C3308E6D422CB708E571D8458BD04239C308B00";
1890         }
1891     
1892         if (v == Special.GHOST) {
1893             return hex"4034003A7360021720000F840042016081D311041148100A9AE0822C020959741042F40081F082084028203A5A01022884035254204560812AEF04085F80203E1081080486074A30304269E18028060351503002ABC18217E00C0F843042010201D24A101096608009A24D13901222A298900A823D95561000AEF0808BE201D82110108038A0748245044A14009668B344E40588A8A62C0151615ED5C5002C422821006180E8E40C0892300128D1A689C80D11514C6802A2E33DAC0C005984604200C381D1C81C1124700251A3CD13901E22A298F00545C77B581C00B2D8E095C84704200C401E3900890400124D22689C81111514C8802A3043DAC90005A6C804AE424021006240F1C90448240092693344E40988A8A64C0151825ED649002D38482576124108029407461CA0448280092695344E40A88A8A6540151829ED64A002D38502576128108029607461CB04482C0092597344C38B0027A05C454522E00A6A96005660B7B592C00B4E16095D84B04200A601D187301120C00249464D12CC300134C4A271E600281911A26401493300150C4A2AAC60015D831ED64C002D3A60257A130108029A078C682239A00482CD9A261C68013D03622A291B005354D002B326BDAD1A005B74D04AF426821004380E8A31C088E700120D3A689C81D11514CE802A3273DAD1C005B84E04A006781D1063C111CF00241A7CD138F3E2340F14513C00A499F005464F7B5A3C00B709E09400D003A20E80212094000946A1344E41088A8A6840151741ECB0CA0005A71004AEC2803D003440E884220892880128D466939188CF4401411215144BF49100534600A8BA2F6B0880165B4412B8EA20FBC88417E1441E802240745252044A4800966A5349C90027A442A0917D45248854D2002A2C93DABA4005869204ADC090430A40F400D303A20A98211874C12905260896980130D4E689C82711514D3802A2A9BDAB260057853082006A01D105501119404C75010906A8004E41488A8A6A4015195000B50A810400D503A20CA8223AA00482959A4B5400986AB344E4D5002A2AABDAB2A00576557B5A5400B70AA10400D603C4581115604C658008E4AD344A2D600261AB4D13905A22A29AD00545567B2B2EB00161A59ED6D6002E42B0410035C0F11704455C008C42F344929700259ABCD13905E22A29AF00545977B2BB0B80165B5DED717002EC2B841003600F118044560008C3B13490C0024B00994C0012CD62689C83111514D8802A2CC3DABB000B0C042CB0005A6D87B5C6000BAFB010C0C03F0B007400D903C464008A3B33490C8024B20994C8012CD66689C83311514D9802A2CCBDABB200B0C842CB2005A7197B5D6400BD03210C2C81D003680F11A00228ED4D24340092D025297680161A08596800B4E34F6BAD00179F6820C10B407400DB03C46C008A337348ED8024360892D826536004B35B9A2720DC454536E00A8B36F6AED8016196C2169B002DB8DBDAEB600BCD8417E16C0E801B80788E02114670008E4380992E04128B7000986B9344E41C88A8A6E40151571ECACBB8005869C082DB8E002EB8105E85C03A006E81E23A084521D04A494E8425BA004C35D9A271EEC454117400A49BB005455D7B567400AEEBA105E85D03A006F01E23C084525E04A516F04263C009AF4D273D119EF001411782149E00537A0151E7B557800ACE3C105D85E03A004F81D0C57C108C4BE0994F8425BE004C35F9A4E7C009E93E10A6F8015157DED59F002BB6F8417217C0E8014007431A004239500265C0004C3609A4E80009E94010A7000151581ED5A0002BB500416E1800E8014207431E1042417082530E84009E942105356100568420AECC2095A7A1042FC3081C";
1894         }
1895     
1896         if (v == Special.HAZMAT) {
1897             return hex"4038024A7A404C94E1009300125A09809253540664AB082494004224C2092686384499010ED24A089296B05325770224DD08CEBD084498019250430D2688486494A5C3992C421925008109292C09325980424E110968038A49483059926A828015591664B4E8A495E7C549B042292500718929048D324A2C601262A30015971804B0C8D325A70624AEC0324F08C494018724A3903CC924A1C012C75BA61A3AA93931C015075BAAAC3AA95D81C00B2D0F32B639257211D26803104947208994920052885BA59842A934E212E9E91000A642DD5152154ACB9097B0400965A2264B6F1049BE44DD821209300924C124968429249462099949240494592AA4C3494BA71E4A2941124014895BA9A84AA9556252F5C945582404B2D93325C78924AFC04CDF09249400CA24C428CF14A24A31054CA494029452A92CC292E9A7148A4F48A00532954A8A9497565CA45582804B2D95325C7CA24E02A6F84A24A00A59251882E6524B014A2C012CB4BA61A5A293932C0150B4BAAAC5A2AB9600B0580965B2E64B9096494014C24A31064CA498024A5CC00583004B2D99325C84C24A00A6925189366528D0125AC6802B9A02586CD992E42692500638928E49D3294708D2D638015CE11AC3474C96E138928031E494724F992516788D30E3C009E91E235354F002B2E788D61A3E64B709E498081250424126863A0499084C924A40052D002CC4047350004E40469E92000A6808EA2000AA808EB20055761001594264B50A049400D149A20E8926422024929102A598880A6A2239C88027A205504510052440B4D10054444755100564404AEC2205B2880969D449379148AFC2892500449268A3A44990900924A480B2D201261A908E724029E9001411480B49200534804A8AA423AC90095D8480B652012D42912602649829CDD0884C92925260296981530D4E649C7A6025045302A92698095154E6559302ABB098096614C92800A937421D424A41CA4CA7A805504540152500AA6CA9325A71424DD50CEBD0A84980ACDD04654928ED2B325B85524A00AB1251925A654D600545A65556002B36B4C972158928022E49454D799545C00AAE2F325D85724A008C125148626525824A52EC4CAC304959718992EBCC126FB0676085824C0649305933A106C925108666525924A52ECCCAC324959759992F42C9250036892883B4024825A24A52ED4C96196892B4EB402BCD126FB43B6085A24C06C6E821B649441DB012412D9252976E64B0CB6495A75B015E6C6F7DB25B042D9260383B82E12D083709288338024725C24A52EE4C9619709369C1DADBAE00AF3891BEE0DF03849C2E0EE03A4B82E8EE13A4B86E8ED10674051DD25C874769253A494B59D992BB0E92565A7476B6EBA02BCEA46FBA37C0E92F0BA3B80F12E0BC3B84F12E1BC9188F2D22BC918CF0DE3BC4B90F0EE4BC4B94F0DD2CF7A64A08BC495259E992BB0F0DECBC3BB4F12EDBC375C79E25AFC0F0DF0BC4B80F92E0BE3B84F8C61BE9188F8BE2BE378CF8C63BE2F90F8C64BE3B94F8BD2CE7C049E83E2FA2F8EE93E2F5359F01577C5F61F48D97C5EB4EBE31BCFA46FBE31C0F8DF0BE3181012E0C0478501510C481228A340478F015120980772A02A259D00093D080A94601DD28122A6B4002AF01516198122B4E40545D7A048AFC101530C047400E11BC485228A3C2379108ED24E84009E942375362100598522B4E4237BB0A457A1846E0";
1898         }
1899     
1900         if (v == Special.HIPPIE) {
1901             return hex"402008424A402794D90210B4F813E60840A4200A0C21194053CAAD03085B8019F6106908020508452424F251812E935408F8AAB049E576C2842E4014FB085484004384210E1A7920A0D752C33E262A196EB067CAE1A7961B0E10B90873E4004484210E227920911752843E2598216D3541080AAB085BAE21F1619113CB4E09085D8449F4016108228A9E462055D24B02C0965A153CB6E8B085E8459F20063279108197492C0D02596864F2DBC34217E11A7C8010E9E431875D23903B152581E04B2D8E9E5C787842FC23CF9001213C84290BA461C862C820F92482DA52E432EC105BB241F169B213CB8F11085F8489F40253C82212BA451C962A412496D2972596B0C925BB44AE96DC253CBAF9308608499F200652E9106298B1CA3E4828B724A202516532D30E282E9E914CB5354A0BAB2E532EC1440B2516ED147CB652E971D293CBCF95086084A9F20045AE90C52D8B18B6FC72CF920B2DC92C8128B65CB2C2E98716FF9E585D4112D9748B0BA9AA5BFEB1617AE5B2EC1640B2596ED167CB65AE971D2D3CBCF97086084B9F200462E90C5318B18CA44730F920C2DC9308094598179863FE698009C63FD3D2302F4CC7FD4300154C7FAB2E605EC1840B2616ED187CB662E971E313CBF01908C264F900135748421AC54518DA44734F920D2DC9348128D65CB342E9871AFF9E685D411359748D0BA9AA6BFEB1A17AE6B2EC1A40B2696ED1A7C5B70D5D2EBC6A797E0361184D9F4039748219CC54414EA4463A7D1CE3E4838B724E202516732D30E382E9E91CCB5354E0BAB2E732EC1C40B2716ED1C7C5B70E5D2EBC72797E03A1184E9F403D748219EC5887D211463E7D1CF3E483CB724F20251E7B2E81E8EA27B954973D9760F20593CB768F3E2DB87AE975E3D3CBF01F08C27CFA020BA4109062A1888521146427D1D03E4840B725020252E832EC2040B2816ED207C5B7105D2EBC82797E042118509F40457482122C5868D21106467D1D13E4844B725120252E8B2EC2240B2896ED227C5B7115D2EBC8A797E046118519F40497482124C58695211064A7D1D23E4848B7252204A4800966A4CB4E4D2002A2C932EBA400B09102CA45BB491F2DA4BA5C7924F2FC094230A53E809AE90424D8B0D3A4220C9CFA3A67C90996E4A640949AEA5A6004C55365D64C015D36FD84C816532DDA4CF96D35D2E3A9A797A04E118539F40517482128C586A521106527D1D43E4850B725420251AA0013935196A8BA800B0A102CA85BB4A1F2DA8BA5C7544F2F40A4230A93E80AAE9042558B0D5A4220CACFA3AA7C90A96E4AA4094AB8E5AA004C355482726A8015155521595005755C7615205954B76953E2DBAAA7979F5610C10AB3E80B2E9042598A8622D488AB4FA32C008EB1F242C5B92B10128B5800986AC909CB16A7AC3350456835258674D62D2A2AB2415975801616205958B76963E5B58017164F2EBEB4218215A7C800AEBA84BB161AEDF88BD222AE004621771A494B8025AEC04C357484E5C673D7832822BCB692F06A6B8CD5155D21597602BB0B80165B5DC7717002EBCBC217E15E7C800B0BA84C3161B0DF88C5222B000461D871C86001258844A60012D860261AC242730339EC419411625B49883536066A8AB090ACC302BB000B0C2EACB0005A6D871DC6001758842F42C4F9001657509962C365BF1190045652B1995947652B21900496611299004B6580986B2909CC8CE7B3065045996D2660D4D919AA2ACA42B32C0AEC802C329EB2C802D3295B6CACAE3295BAC802F33085F8599F2002D2E9083698B11A00228ED32E4340092D4225340096D30130D69209C9B4005455A485669815DA0058693D65A002D38D32EEB4005E85A9F2004DAEA1B6C588D8011466D971DB002412DCFA5360096DB0130D6D209C9B6E35455B48566D815DB002C32DC22D36005B71B65DD6C00BD0B73E4009C5D43718B11C6FA28CE0011C9727D29C004B7180986B8904E4DC71AA2AE242B38C0AEE00161A7210B6E38005D81C9F6172908013ABA4311D62C575BE8C3BB484829D9F4B7400987BAE35045D00292AEB8EB3A005765D842D3EECF982176908013CBA4311E62C579BE8C3BD484829E9F4B78009873CE39EF00283D08A2F4FA93C005355E71D67800AEF3D3E5F85EA42006FAE91057D8B19F6FA390FD2124A7E7D2DF00261AFB8E73E004F49F9F537C00A8ABEE3ACF8015DD7E7CBD03F48C2FB7D003817488340C58F037D20982912A09F4B8000986C0CB9D00013D2827D4E0002A2B032EB4000576E09F2E3D05217E081BF86062C0853C82242BA451E162C885BE925C3484C3A10027A50CF94D58400ACD433E5B721A42EBF0B7D821858A0";
1902         }
1903     
1904         if (v == Special.JOKER) {
1905             return hex"404005C28C200010100570A308200404025C28C2100100C0D709A706224F4830DA9A818895610C0080508B84B30411269C20593D21044A6A081655584112BC220010091571285112598285934E14189E90A1653505062AAC285AB8A225884500201032E248C224A2C606261C33B93D21818A6A8CEE565C606581844B308C00401C75C481C2D24706252E3BBAC0E0CB238596A11C0080310B8472080B249643B930E21709E910EE535485C2B3043B965A202CB709000401895C47242D20906249C4BBA792B85044977522570A6C12EEB24832D12165B84900200C52E11C8284492614EE9A501939329DD50A032AB053B965A2844B7094004014B5C462C2D1CB11482C1892596EE4C38B0327A45BB94D52C0CACC16EEB25832D1622B658597212C0080298B8461CC1148301892518EE966002619579A6002719579E600141131DD48C005332AF50C005532AF58C002BB063BAC980C5A6CC112E426001005357118D114734189059AEE4C38D0327A46BB94D5340CACC9AEEB46832D9A225C84D00200A72E231C228E700120C39DD34E03272673BAA1C065564E775A38016CE112E4270010053D7118F11473C009079EEEA07AFE89EA75264F775A3C016CF112E42780100541708C3A0224825000251683BA620B84D51077554170ACBA0EE58650002D368089721400080322B8472111149440094622EE4D3915C27A48B2D4D44570AABA2EEB0880165A4444B70A200401D20048484492524004B352774E49969E924B8A6932D51649DD5D200584971652112D4292E100B4C00987A6EE504535C292A9BBAB2600578535C201AA00139351DCA8CA8005A8545C200EA80120A54D32D500261AA9313935400A8AAA4CACA8015D954D3695002DC2AAE100658008E4AC694A2D6004C58D3356264E59F93D634A822B08A92C69A6B3E2A2C4CAAB1A55975800B0D2C69B6B0017215970802AE004621734A494B8012CD5CD3397264F5DF8A08AE69A4BBE29AE4C5459734ABB0B80165B5CD3717002EC2BAE100560008C3B0694829800259AC1A67304C4F4187E28A4C3E29B04C5459834D760016185C596000B4DB069B8C00176161708023200451D92CA414C8012CD64D33992627A0CBF145265F14D9262A2CC9A6BB200B0CAE2CB2005A7192CDD6400BD0B2B84011A00228ED32D20A68012DA34A61AD13139069F8A29B4F85455A265668D35DA0058697165A002D38D32EEB4005E85A5C2008D8011466D968E5360096D93130F6DF8A08B67B5255B7C566C995DB002C32DAE2D36005B71B65DD6C00BD0B6B8402DC00262AE1ED5977000B0D38B85B71C002EC2E2E100B7400987BA7B5045D00292AE9EEB3A005785D5C2018F00134E78F69E83C00A2F2E293C005351E3DD57800AD0BCB8402DF00261AF9ED3907C00A293EB8A6F8015157CF759F002BC2FAE100B8000986C0CB4E4200028A502E29C0005456065D68000AF0C0B8404210028A50AE14D58400AD0C2B8";
1906         }
1907     
1908         if (v == Special.PRISONER) {
1909             return hex"401002B4501D28C500569603A531000AD44074A92C015AB80E9587002B5D01D2BD0805640081344304AD101344505D3181344704AC9050268960BA530E04D13C12B5004D144174D204D14C12B2A2C09A2B82E958681345B04AD701345D05D3781345F04ACC108268401022B4509D28C504569613A531008AD44274A92C115AB84E9587022B5D09D2BD084568019A2086564210334450DD28C4066892195A50668961BA6606684D40392510DD2A4A0724AA195AB0668AE1BA6C0668B2195969C0CD174374AF4019A308656401042B4511D28C508569623A5310124944474A92C2492B88E9587042B5D11D2BD0885640085344314AD105344515D3185344714AC9048A68942C9258AE94C405925115D2A4B0B24AE2BA561914D1685925B14AD705345D15D3785345F14ACC108A68401062B4519D28C40C5649286924B19D29880D24A233A54961A495C674AC32349169C18AD74674AF42315A00E688239590841CD114774A31039A124A1E492C774A6203C9288EE95258792571DD360792591CAD687922DB839A2E8EE95E80734611CAC80210568A43A518720AC90511249643A5310224944874A92C4492B90E958648922D38415AE90E95E8482B200449A2192568849A2292E98C49A23925690480124A25972C974A6204B2E892E95258965D725D360965D92401689345B24AD709345D25D3789345F24ACC1092684010A2B4529D28C3945690500124A29972CA74A620532E894E95258A65D729D360A65D92800B4E1456BA53A57A128AD00B34412CAC84216688A5BA51872CD120B0024945B2E596E94C40B65D12DD2A4B16CBAE5BA6C16CBB2580169C2CD174B74AF4059A3096564010C2B4531D28C3985690600124A31972CC74A61A6136718004F40C65D131D348C65D33000A8A984DAC6002B98E9B0632EC98005A70C2B5D31D2BD098564008D344334AD10D344535D318D344734009051ACB966BA661B574D38D0027A06B2E89AE9A46B2E99A00A86D5D55634015CD74AC326B2ED1A00B6695AE1A68BA6BA6F1A68BE695982134D08021C568A73A631C568E700120A39972CE74A61A7135390399744E74A926732D515389B58E65D739D2B0C9CCBB470016DC38AD74E74AF42715A01EC8827B0611EBB4310F34453DD318F34473C009051ECB967BA530F3D9740F47513DD2A4B1ECBAE7BA56193D9768F002DB879A2E9EE95E80F34613CAD01060C1417709058A188815A2A0E9461D02B24128002520CB9683A5310419745074A92C832EBA0E958650002D38815AEA0E95E8502B40457705158C245430D12B4444D115174C644D11D12B4844D1251004A45972D174A6208B2E8A2E95259165D745D3611002CB489A2DA256B889A2EA2E9BC89A2FA256608513440496305250C2493286224568A93A518948AD292004B49D2986A4CB4E412005149D2A49A4005459265D749D2B0E2456BA93A57A148AD01334414CAC84226688A9BA51884CD12532B4A4CD12D374A6209B2E8A6E95255365D64C015D374D84CD16532B2D3899A2EA6E95E81334614CAD0142B41517684228568AA3A518750AC905280096A3A530D50009C828CBA2A3A54935196A8B2800AEA3A56195000B4E2856BAA3A57A150AC8012A8A86A95A22A688AABA632A688EA80120A56492D574A61AAC91390540145574A926A8015155649595005755D2B0CAB24B4A802DAA56B8A9A2EAAE9BCA9A2FAA5660855342008B15A2ACE98CB0011C95A49296004B59D2986AD249CB4AA7AD24A0B4AE8ACE9524D6952A2AB492B2C00AEB3A561A5A496D6005C58AD75674AF40B15B0AC8A80B9A20AE564211734455DD28C42F2449297004B5DD2986AF249CBCA93D05E5345774D25E56A6A2E12AABCA6B2F24AEBBA6C2E00596D7925C5C0175774DE5CD0BF02EC9C2BA29001611484230568AC3A51876249218004960AD298004B61D29883124A2C3A69312A53598925761D361845596000B4DB124B8C002EB0E95E858452004CA761B25688C8022B2E9461D98D486401259344A64012D974A620CC928B2E952599925765D361945596400B4E331ABACBA57A1651480134A686D15A234008AD3A5187699721A004968AD29A004B69D29883400A2D3A549668015DA74D868AD65A002D38D32EEB4E95E81A2B616914800B65484DA2A1B65488D8022B6E98CDB2E3B6004825B2A4A6C012DB74A620DC928B6E95259B92576DD2B0CB654B4D8016DC6D9775B74AF40D95B0B68A4011C2E4571D319C002392E1725380096E3A5310724945C74A92AE492B3800AEE3A6C386B5969C2E2DB8E002EB8E95E85C2E2008E9922BAE94629D324B75D2987BB24A0E8028BAE95255D925674015DD74AC38E992EBAE95E85D322008F1BA2BCE94629E374B79D331E00269CF4927BC00A0F1BA8BCE9A4F0014D47A4955E005678DD5DE74AC38F1BAEBCE95E85E372008F9D62BEE94629F3ACB7DD2986BF1E9CF8013D07CEB45F74D27CEB4DF002A2AFC6AB3E00AEFBA561C7CEB75F74AF42F9D500480FB16074A31501F65C0E94C36065CE80009E8407DA303A69407DA7000151581975A0005781D2B0E407DBB03A57A180FA80242848B0BA518A85092E174A61D08013D0850946174D28508A6AC200AD0A12BC2E958721425D85D2BD0C2840";
1910         }
1911     
1912         if (v == Special.SQUID_GAME) {
1913             return hex"400C09DC401BA8B0813B400819DA18A0B7518C06769AA02F7558419DA01414ED2D609EEAEF853BC013770853B402439DA5181BDD3540C00AAB86F7587839DAFC21B75008127692508F74B584002BB023DD65D1276BD088DD401C59DA4142BDD2D61400AEC8AF75A8459DA00E34ED20919EE9468C004E4C6ABAA2E300161919EEB508D3B400479DA1063B751071E769048EF74A347004E1EAE9E90E00A63D5D5171C00B0C8EF75A8479DC0227682210DD451C89DC821EE92690009C455D3D220014C8ABAA304002C90F75A8489DA00A4B7518726772097BA49A4802713574F489005326AEA8C1200B24BDD6A12676803953B9053DD24D280138AABA7A45002995575460A005929EEB50953B401CB9DC82DEE92696004E4CBABAA305802C96F75A84B9DA00E64EE418F74960C005931EEB50993B401CD9DC835EE92C1A00B26BDD69E36777CD6EB0426CED0073A769049CF74A5CE002C3273DD69D3A76BD01CDDC274ED0073E769049EF74A5CF002C327BDD6A13E76804213B9283DD29740016107BACC284ED00246770D16EA2108CED24A45EE96B2200576117BACC28CED0014A7684224DD452529DA51693DD3154800ACBA4F7588529DA0149CEE5A6004C3537BA72698015154DEF593002BC29CED007527690528F74B31400269CA3DD3D25000A6A28F755594002BB2A3DD6A152768032B3B472D57BCC54009AA2AF7AAA80159A55EEB70AB3B401569DA316B3DE62C004D4167BD15800A4A2CF7AAB00159B59EEB90AD3B401179DA296BBDE62E004D4177BD15C00A4A2EF7AAB80159C5DEEBB0AF3B401189DA290C3DE4B13B4A3187BCD60009C830F7A2C00149361EF518002AAEC3DEC313B597187BAEC2C4ED003667688432F792CCED28C65EF359002720CBDE8B200524D97BD46400AABB2F7B0CCED65D65EEBD0B33B400DAA92210D3DE4B5524A31A7BCD68009C834F7A2D00149369EF51A002AAED3DEC35525975A7BAF42D5490036EA4883B6F74825BA9252ED8016196EA4B4EB6F7BCDD117E16EA4801B9444419C7BA392E51129771EEB0D39445B75C7BAF42E51100376888833A004729DA225ACEBDD5DA7688B6EBA005E85DA22006F45D10578008C5BD174C3DE7BA822F45D49579EEACDBD175C75E002F42F45D00A7E2E9673EF74F49F8BA9ACFBDD5E17E2E80541044B3A00027A504114D68000AF0C1044022182249D08013D28608A6C420059861820";
1914         }
1915     
1916         if (v == Special.WHERES_WALDO) {
1917             return hex"800235047018E906008D9A000138F024F4000028A8031D559011AB5000C7C20235001051A84402C74930146A6A40802982C75460146ACBE0B1D821051A800848D4220263A49412352CC08009A9055753542002B30123565F098EC10848D4008346A1921B1E506004B543ABAB2E180161E0D8EBF0868D400C446A210231E488004A5C4ABD81000B2E88C75E84446A0082A35147158F2050024B02D5EC8A005A70563AEC22A35005191A8C38CC748646002D36331D721191A8030E8D8E38012191E4F687002DC23A35006211A8ED10005B84846A00E4A3520A24D896B12CB57649362D424A35006291A8E4146C492CA65A61C50013D22996A6A9400565CA65AC3851B1761291A803968D90580124A2D972CB00261C5D5E796005044B65D22C00A6A9757AC58015D82D9764B002D425A35007311A905980098655E698009C655D3D230014CCABD4300154CABAB3260016A1311B00D63A08C6A3639A004828D65CB34009871B579E6801411359748D0029AA6D5EB1A005764D65DA3400B701A8DC26B1D002398E8631C8D8E700120B39969871C004F48E65A9AA7001599399768E002DBC72357E1398E8021EC74518F46C73C009079ECBA079B689E605264F65DA3C00B6E1E8D5D84F63A00C831E3A08D4825000252E832D619400169046ADC2831D008458F25100252E8B2EC22005985163A012931E524004B35265A726900151649975D2002C42931D00A4DB52D300262A9B2EB2600578536D200EA36920D50009C9A8CB54654002D42A36900655B51D5002414AC9E5AA004C35593A726A801515564F595002BB2AC9ED2A005B8556D200AB3CA32C0047256ABA516B0013155AAEACBAC0058696ABDB5800B90ACF24011779455C008C42F27492970025ACBC9D5D85C00B2DAF27B8B8017615DE480230F28AC00118762AF218004961E52980025ACC55EBB000B0C3CACB0005A6D8ABDC6000BB0B0F2400D98DC464008A3B32790C8024B31B94C8012D6664F5D900586637659002D38CC9EEB2005E8598DA006D46E23400451DAABC8680125A8DCA680096B3557AED002C351BB2D00169C6AAF75A002F42D46D0036E3711B00228CDB2E3B6004825B8DCA6C0096B3636AED8016196E3769B002DB8DB2EEB6005E85B8DA006E4FE238004519C65C77000904B93F4A2DC00262AE0D95977000B0CB93FB4E0016DC719775C002F42E4FD004767E8A33A004729D9FCB7400987BA365045D00292AE8DAB3A005769D9FADB8E801761767E8053D3F96F00130E786D3DE002822F4FE93C005355E1B567800AF0BD3F4029FA4CB7C00986BE369CF8013D27E934DF002A2AF8DAB3E005785FA4A013052528E80009E94149535E0002C430525008869326100251B0AE6742004F4A1A4D38400A8BC2B9B108016618692";
1918         }
1919         revert("invalid special");
1920     } 
1921 }
1922 
1923 // File: contracts/BitMonster.sol
1924 
1925 
1926 pragma solidity ^0.8.0;
1927 
1928 
1929 struct BitMonster {
1930     bool genesis;
1931     bool superYield;
1932     Special special;
1933     Dominant dominant;
1934     Recessive recessive;
1935     BgColor bgColor;
1936     Outfit outfit;
1937     HandAccessory handAccessory;
1938     Mouth mouth;
1939     Eyes eyes;
1940     HeadAccessory headAccessory;
1941 }
1942 
1943 // File: contracts/BitMonsterGen.sol
1944 
1945 
1946 pragma solidity ^0.8.0;
1947 
1948 
1949 
1950 
1951 
1952 library BitMonsterGen {
1953     using RngLibrary for Rng;
1954 
1955     function getRandomBgColor(Rng memory rng) internal view returns (BgColor) {
1956         if (rng.generate(1, 1000) == 1) {
1957             return BgColor.RAINBOW;
1958         }
1959         return BgColor(rng.generate(0, 9));
1960     }
1961 
1962     function getRandomDominant(Rng memory rng) internal view returns (Dominant) {
1963         // all rarities are out of 10000
1964         uint rn = rng.generate(0, 9999);
1965         uint16[8] memory rarities = Rarities.dominant();
1966     
1967         for (uint i = 0; i < rarities.length; ++i) {
1968             if (rarities[i] > rn) {
1969                 return Dominant(i);
1970             }
1971             rn -= rarities[i];
1972         }
1973         revert("getRandomDominant() is fucked");
1974     } 
1975     
1976     function getRandomRecessive(Rng memory rng) internal view returns (Recessive) {
1977         // all rarities are out of 10000
1978         uint rn = rng.generate(0, 9999);
1979         uint16[6] memory rarities = Rarities.recessive();
1980     
1981         for (uint i = 0; i < rarities.length; ++i) {
1982             if (rarities[i] > rn) {
1983                 return Recessive(i);
1984             }
1985             rn -= rarities[i];
1986         }
1987         revert("getRandomRecessive() is fucked");
1988     } 
1989     
1990     function getRandomOutfit(Rng memory rng) internal view returns (Outfit) {
1991         // all rarities are out of 10000
1992         uint rn = rng.generate(0, 9999);
1993         uint16[27] memory rarities = Rarities.outfit();
1994     
1995         for (uint i = 0; i < rarities.length; ++i) {
1996             if (rarities[i] > rn) {
1997                 return Outfit(i);
1998             }
1999             rn -= rarities[i];
2000         }
2001         revert("getRandomOutfit() is fucked");
2002     } 
2003     
2004     function getRandomHandAccessory(Rng memory rng) internal view returns (HandAccessory) {
2005         // all rarities are out of 10000
2006         uint rn = rng.generate(0, 9999);
2007         uint16[16] memory rarities = Rarities.handaccessory();
2008     
2009         for (uint i = 0; i < rarities.length; ++i) {
2010             if (rarities[i] > rn) {
2011                 return HandAccessory(i);
2012             }
2013             rn -= rarities[i];
2014         }
2015         revert("getRandomHandAccessory() is fucked");
2016     } 
2017     
2018     function getRandomMouth(Rng memory rng) internal view returns (Mouth) {
2019         // all rarities are out of 10000
2020         uint rn = rng.generate(0, 9999);
2021         uint16[22] memory rarities = Rarities.mouth();
2022     
2023         for (uint i = 0; i < rarities.length; ++i) {
2024             if (rarities[i] > rn) {
2025                 return Mouth(i);
2026             }
2027             rn -= rarities[i];
2028         }
2029         revert("getRandomMouth() is fucked");
2030     } 
2031     
2032     function getRandomEyes(Rng memory rng) internal view returns (Eyes) {
2033         // all rarities are out of 10000
2034         uint rn = rng.generate(0, 9999);
2035         uint16[24] memory rarities = Rarities.eyes();
2036     
2037         for (uint i = 0; i < rarities.length; ++i) {
2038             if (rarities[i] > rn) {
2039                 return Eyes(i);
2040             }
2041             rn -= rarities[i];
2042         }
2043         revert("getRandomEyes() is fucked");
2044     } 
2045     
2046     function getRandomHeadAccessory(Rng memory rng) internal view returns (HeadAccessory) {
2047         // all rarities are out of 10000
2048         uint rn = rng.generate(0, 9999);
2049         uint16[29] memory rarities = Rarities.headaccessory();
2050     
2051         for (uint i = 0; i < rarities.length; ++i) {
2052             if (rarities[i] > rn) {
2053                 return HeadAccessory(i);
2054             }
2055             rn -= rarities[i];
2056         }
2057         revert("getRandomHeadAccessory() is fucked");
2058     } 
2059 
2060     function generateUnspecialBitMonster(Rng memory rng) internal view returns (BitMonster memory) {
2061         BitMonster memory ret = BitMonster({
2062             genesis:       true,
2063             superYield:    rng.generate(0, 99) == 0,
2064             special:       Special.NONE,
2065             dominant:      getRandomDominant(rng),
2066             recessive:     getRandomRecessive(rng),
2067             bgColor:       getRandomBgColor(rng),
2068             outfit:        getRandomOutfit(rng),
2069             handAccessory: getRandomHandAccessory(rng),
2070             mouth:         getRandomMouth(rng),
2071             eyes:          getRandomEyes(rng),
2072             headAccessory: getRandomHeadAccessory(rng)
2073         });
2074 
2075         return ret;
2076     }
2077 
2078     function generateSpecialBitMonster(Rng memory rng, bool[9] memory mintedSpecials) internal view returns (BitMonster memory) {
2079         uint available = mintedSpecials.length;
2080         for (uint i = 0; i < mintedSpecials.length; ++i) {
2081             if (mintedSpecials[i]) {
2082                 available--;
2083             }
2084         }
2085 
2086         if (available == 0) {
2087             return generateUnspecialBitMonster(rng);
2088         }
2089 
2090         uint rn = rng.generate(0, available - 1);
2091         uint special;
2092 
2093         // generate a random special index, skipping specials that do not exist
2094         for (special = 0; special < 9; ++special) {
2095             if (mintedSpecials[special]) {
2096                 continue;
2097             }
2098             if (rn == 0) {
2099                 break;
2100             }
2101             rn -= 1;
2102         }
2103 
2104         require(!mintedSpecials[special]);
2105         mintedSpecials[special] = true;
2106 
2107         return BitMonster({
2108             genesis:       true,
2109             superYield:    rng.generate(0, 4) == 0,
2110             // + 1 because 0 is None
2111             special:       Special(special + 1),
2112             dominant:      getRandomDominant(rng),
2113             recessive:     getRandomRecessive(rng),
2114             bgColor:       BgColor.DARK_BLUE,
2115             outfit:        Outfit.NONE,
2116             handAccessory: HandAccessory.NONE,
2117             mouth:         Mouth.NONE,
2118             eyes:          Eyes.NONE,
2119             headAccessory: HeadAccessory.NONE
2120         });
2121     }
2122 
2123     function rerollTrait(Rng memory rng, BitMonster memory bm, RerollTrait trait) internal view {
2124         bm.genesis = false;
2125         if (trait == RerollTrait.BgColor) {
2126             BgColor existing = bm.bgColor;
2127             while (bm.bgColor == existing) {
2128                 bm.bgColor = getRandomBgColor(rng);
2129             }
2130         }
2131         else if (trait == RerollTrait.Outfit) {
2132             Outfit existing = bm.outfit;
2133             while (bm.outfit == existing) {
2134                 bm.outfit = getRandomOutfit(rng);
2135             }
2136         }
2137         else if (trait == RerollTrait.HandAccessory) {
2138             HandAccessory existing = bm.handAccessory;
2139             while (bm.handAccessory == existing) {
2140                 bm.handAccessory = getRandomHandAccessory(rng);
2141             }
2142         }
2143         else if (trait == RerollTrait.Mouth) {
2144             Mouth existing = bm.mouth;
2145             while (bm.mouth == existing) {
2146                 bm.mouth = getRandomMouth(rng);
2147             }
2148         }
2149         else if (trait == RerollTrait.Eyes) {
2150             Eyes existing = bm.eyes;
2151             while (bm.eyes == existing) {
2152                 bm.eyes = getRandomEyes(rng);
2153             }
2154         }
2155         else if (trait == RerollTrait.HeadAccessory) {
2156             HeadAccessory existing = bm.headAccessory;
2157             while (bm.headAccessory == existing) {
2158                 bm.headAccessory = getRandomHeadAccessory(rng);
2159             }
2160         }
2161         else {
2162             revert("Invalid reroll trait");
2163         }
2164     }
2165 
2166     function rerollAll(Rng memory rng, BitMonster memory bm) internal view {
2167         bm.genesis = false;
2168         bm.bgColor = getRandomBgColor(rng);
2169         bm.outfit = getRandomOutfit(rng);
2170         bm.handAccessory = getRandomHandAccessory(rng);
2171         bm.mouth = getRandomMouth(rng);
2172         bm.eyes = getRandomEyes(rng);
2173         bm.headAccessory = getRandomHeadAccessory(rng);
2174     }
2175 }
2176 
2177 // File: contracts/Base64.sol
2178 
2179 
2180 pragma solidity ^0.8.0;
2181 
2182 // shamelessly stolen from the anonymice contract
2183 library Base64 {
2184     string internal constant TABLE =
2185         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2186 
2187     function encode(bytes memory data) external pure returns (string memory) {
2188         if (data.length == 0) return "";
2189 
2190         // load the table into memory
2191         string memory table = TABLE;
2192 
2193         // multiply by 4/3 rounded up
2194         uint256 encodedLen = 4 * ((data.length + 2) / 3);
2195 
2196         // add some extra buffer at the end required for the writing
2197         string memory result = new string(encodedLen + 32);
2198 
2199         assembly {
2200             // set the actual output length
2201             mstore(result, encodedLen)
2202 
2203             // prepare the lookup table
2204             let tablePtr := add(table, 1)
2205 
2206             // input ptr
2207             let dataPtr := data
2208             let endPtr := add(dataPtr, mload(data))
2209 
2210             // result ptr, jump over length
2211             let resultPtr := add(result, 32)
2212 
2213             // run over the input, 3 bytes at a time
2214             for {
2215 
2216             } lt(dataPtr, endPtr) {
2217 
2218             } {
2219                 dataPtr := add(dataPtr, 3)
2220 
2221                 // read 3 bytes
2222                 let input := mload(dataPtr)
2223 
2224                 // write 4 characters
2225                 mstore(
2226                     resultPtr,
2227                     shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2228                 )
2229                 resultPtr := add(resultPtr, 1)
2230                 mstore(
2231                     resultPtr,
2232                     shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2233                 )
2234                 resultPtr := add(resultPtr, 1)
2235                 mstore(
2236                     resultPtr,
2237                     shl(248, mload(add(tablePtr, and(shr(6, input), 0x3F))))
2238                 )
2239                 resultPtr := add(resultPtr, 1)
2240                 mstore(
2241                     resultPtr,
2242                     shl(248, mload(add(tablePtr, and(input, 0x3F))))
2243                 )
2244                 resultPtr := add(resultPtr, 1)
2245             }
2246 
2247             // padding with '='
2248             switch mod(mload(data), 3)
2249             case 1 {
2250                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2251             }
2252             case 2 {
2253                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2254             }
2255         }
2256 
2257         return result;
2258     }
2259 }
2260 
2261 // File: @openzeppelin/contracts/utils/Strings.sol
2262 
2263 
2264 
2265 pragma solidity ^0.8.0;
2266 
2267 /**
2268  * @dev String operations.
2269  */
2270 library Strings {
2271     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2272 
2273     /**
2274      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2275      */
2276     function toString(uint256 value) internal pure returns (string memory) {
2277         // Inspired by OraclizeAPI's implementation - MIT licence
2278         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2279 
2280         if (value == 0) {
2281             return "0";
2282         }
2283         uint256 temp = value;
2284         uint256 digits;
2285         while (temp != 0) {
2286             digits++;
2287             temp /= 10;
2288         }
2289         bytes memory buffer = new bytes(digits);
2290         while (value != 0) {
2291             digits -= 1;
2292             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2293             value /= 10;
2294         }
2295         return string(buffer);
2296     }
2297 
2298     /**
2299      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2300      */
2301     function toHexString(uint256 value) internal pure returns (string memory) {
2302         if (value == 0) {
2303             return "0x00";
2304         }
2305         uint256 temp = value;
2306         uint256 length = 0;
2307         while (temp != 0) {
2308             length++;
2309             temp >>= 8;
2310         }
2311         return toHexString(value, length);
2312     }
2313 
2314     /**
2315      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2316      */
2317     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2318         bytes memory buffer = new bytes(2 * length + 2);
2319         buffer[0] = "0";
2320         buffer[1] = "x";
2321         for (uint256 i = 2 * length + 1; i > 1; --i) {
2322             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2323             value >>= 4;
2324         }
2325         require(value == 0, "Strings: hex length insufficient");
2326         return string(buffer);
2327     }
2328 }
2329 
2330 // File: contracts/Colors.sol
2331 
2332 
2333 pragma solidity ^0.8.0;
2334 
2335 
2336 
2337 
2338 library Colors {
2339     using StringBufferLibrary for StringBuffer;
2340 
2341     function uintToColorString(uint value) internal pure returns (string memory) {
2342         require(value >= 0x000000 && value <= 0xFFFFFF, "color out of range");
2343         bytes memory symbols = "0123456789ABCDEF";
2344         bytes memory buf = new bytes(6);
2345 
2346         for (uint i = 0; i < 6; ++i) {
2347             buf[5 - i] = symbols[Integer.bitsFrom(value, (i * 4) + 3, i * 4)];
2348         }
2349 
2350         return string(abi.encodePacked(buf));
2351     }
2352 
2353     function getRainbowCss(StringBuffer memory sb) internal pure {
2354         bytes memory colors = hex"FF0000FF8800FFFF0000FF0000FFFF8800FFFF00FF";
2355 
2356         for (uint i = 0; i < colors.length; i += 3) {
2357             uint val = (uint(uint8(colors[i])) << 16) + (uint(uint8(colors[i + 1])) << 8) + uint(uint8(colors[i + 2]));
2358             sb.append(string(abi.encodePacked(
2359                 ".r",
2360                 Strings.toString(i / 3),
2361                 "{fill:#",
2362                 uintToColorString(val),
2363                 "}"
2364             )));
2365         }
2366     }
2367 
2368     function getColorCss(StringBuffer memory sb) internal pure {
2369         bytes memory colors = hex"0000000202020606050A0B0A10193D11111111578B121212121312131313134C8C14172315592D1616161717171718181719181A0C0D1A19191A1A1A1A1D2D1B589E1B6C371D1D1D1E0F101E1E1E1F1F1F207F3F210F0F225084234F812363AF24283A243E86258541262626263C9227272728282728389429100F2A0F0E2A10102A2A2A2A2B2A2B39912B84BF2C2C2B2E2E2E31313131B0DA32B44A3311113333333383C533B04A3434343535353565A235924436363638383838429B3913123A21123A3A3A3B17173B3B3A3B51A33D4B9F3D4FA23E3E3E3E689C3F40404058A7408940412668414141433217433B364444444450A24454254575B24646464762AD49484849B2494A14134A2B754B65AF4E2B144E4E4F4E77AB4F4F4F502323514B29519ACC521212535352535353536B3454555454B948555555562C825636185756525938355A54375B5B5C5B5D285D35175D5D5D607A35623D2562636363646464656564A5DA65AFE06868686969696A38956A39176B6B6B6E41196F6E6F70717171726E717272727560737374743F1A75441B76441B773C197878787979797A461D7B481D7BCCF27C13197C7C7C7F461E7FC34A802A2A80808080836781461E814B1F818182824D1F82828283848484191C8485858584858588C2858972868C368886868951A08A51218A7F7C8A83818A8A8A8B26268B53228C62A98D8D8D8E52A18F1A298F553E916928925724929292939393965426979B7F97CA52982524983839989898992D2C9D7E4F9DD6E49E9E9E9F1D21A11F4BA2A1A1A33534A35F2FA3A2A1A46A45A51E22A59332A5D099A92451AEE2F8AFAEAEB0B0B1B12325B1CA36B32126B471AFB51F35B52125B72426B82025B8305DBAB9BABC262ABD2428C0C0C0C22126C43465C83464C8AF88C8C8C8C9AC60CAEAF2CB4549CBE199CCAA47CCCB6ACD2C2DCD7F4BCE2227CF393ED33E6FD3D3D3D42027D4D4D4D52628D53229D6AC57D6D5D5D6E377D71F27D796C2D7C427D9BD92DB6E71DBB927DBD4D3DBDCBDDC2727DC8A32DCDCDCDD2126DD888BDD9B33DDDDDDE0B794E0E0DFE0E2C1E11F26E14243E1E2E1E2B486E2BB6FE2E65DE3494AE38E75E3BE9FE3E3E3E43A34E44C7EE58C8EE6618DE6A2A4E6BD43E6E9C6E79598E81D25E85C8AE8E7E7E97A63E9BF95E9C6A9E9E8E8EA8D26EACA9BEB3837EB6763EB8D25EBC220EBC376EBC71DEC1D25EC4A45EC8E25ECECECED1C24ED1E25ED2024ED8B22ED8E25ED8E26EDCEB3EE9B57EF3E23EF474DEFB1B2EFD2BAEFE920EFEEEEEFF4CEF04E4FF0C519F0ED7AF15E5FF16C97F1CA7DF1F6F7F278A0F2CD5EF3B282F3D5A7F3D9C3F48588F57E20F5C8C9F5CCA4F5F085F6A1ABF6E0CEF6F09CF7DDB4F7F8F8F8AFB1F8D1D1F8ED87F9DB07FACE0BFCF7BCFDFBE3FED7B2FEE900FFC709FFCD05FFF9DBFFFFFF";
2370         for (uint i = 0; i < colors.length; i += 3) {
2371             uint val = (uint(uint8(colors[i])) << 16) + (uint(uint8(colors[i + 1])) << 8) + uint(uint8(colors[i + 2]));
2372             sb.append(string(abi.encodePacked(
2373                 ".c",
2374                 Strings.toString(i / 3),
2375                 "{fill:#",
2376                 uintToColorString(val),
2377                 "}"
2378             )));
2379         }
2380     }
2381 }
2382 
2383 // File: contracts/Renderer.sol
2384 
2385 
2386 pragma solidity ^0.8.0;
2387 
2388 
2389 
2390 
2391 
2392 
2393 
2394 
2395 enum RendererState {
2396     HEADER,
2397     HEADER_ZERO,
2398     PIXEL_COL,
2399     ROW_LCOL,
2400     ROW_RCOL,
2401     ROW,
2402     COLOR
2403 }
2404 
2405 library Renderer {
2406     using StringBufferLibrary for StringBuffer;
2407 
2408     uint256 private constant COL_BITS = 6;
2409     uint256 private constant ROW_BITS = 6;
2410     uint256 private constant COLOR_BITS = 9;
2411 
2412     function renderBg(BgColor c) public pure returns (string memory) {
2413         if (c == BgColor.RAINBOW) {
2414             return "<rect x='0' y='0' width='34' height='34'><animate attributeName='class' values='r0;r1;r2;r3;r4;r5;r6' dur='1s' repeatCount='indefinite'/></rect>";
2415         }
2416         else {
2417             string memory color = Sprites.getBgHex(c);
2418             return
2419                 string(
2420                     abi.encodePacked(
2421                         "<rect style='fill: #",
2422                         color,
2423                         "' x='0' y='0' width='34' height='34'/>"
2424                     )
2425                 );
2426         }
2427     }
2428 
2429     function renderSprite(bytes memory b, StringBuffer memory sb) public pure {
2430         RendererState state = RendererState.HEADER;
2431         uint256 buffer = 0;
2432         uint256 bufferPos = 0;
2433         uint256 lcol = 0;
2434         uint256 rcol = 0;
2435         uint256 col = 0;
2436         uint256 row = 0;
2437         bool isRow = false;
2438 
2439         for (uint256 i = 0; i < b.length; ++i) {
2440             uint256 byt = uint256(uint8(b[i]));
2441             for (int256 j = 7; j >= 0; --j) {
2442                 uint256 bit = Integer.bitAt(byt, uint256(j));
2443 
2444                 if (state == RendererState.HEADER) {
2445                     if (bit == 0) {
2446                         // 01 starts a row
2447                         state = RendererState.HEADER_ZERO;
2448                     } else {
2449                         // 1 starts a pixel
2450                         isRow = false;
2451                         state = RendererState.PIXEL_COL;
2452                     }
2453                 } else if (state == RendererState.HEADER_ZERO) {
2454                     if (bit == 0) {
2455                         // 00 ends the sequence
2456                         return;
2457                     } else {
2458                         // 01 starts a row
2459                         isRow = true;
2460                         state = RendererState.ROW_LCOL;
2461                     }
2462                 } else if (state == RendererState.PIXEL_COL) {
2463                     buffer = buffer * 2 + bit;
2464                     bufferPos++;
2465                     if (bufferPos == COL_BITS) {
2466                         col = buffer;
2467                         buffer = 0;
2468                         bufferPos = 0;
2469                         state = RendererState.ROW;
2470                     }
2471                 } else if (state == RendererState.ROW_LCOL) {
2472                     buffer = buffer * 2 + bit;
2473                     bufferPos++;
2474                     if (bufferPos == COL_BITS) {
2475                         lcol = buffer;
2476                         buffer = 0;
2477                         bufferPos = 0;
2478                         state = RendererState.ROW_RCOL;
2479                     }
2480                 } else if (state == RendererState.ROW_RCOL) {
2481                     buffer = buffer * 2 + bit;
2482                     bufferPos++;
2483                     if (bufferPos == COL_BITS) {
2484                         rcol = buffer;
2485                         buffer = 0;
2486                         bufferPos = 0;
2487                         state = RendererState.ROW;
2488                     }
2489                 } else if (state == RendererState.ROW) {
2490                     buffer = buffer * 2 + bit;
2491                     bufferPos++;
2492                     if (bufferPos == ROW_BITS) {
2493                         row = buffer;
2494                         buffer = 0;
2495                         bufferPos = 0;
2496                         state = RendererState.COLOR;
2497                     }
2498                 } else {
2499                     buffer = buffer * 2 + bit;
2500                     bufferPos++;
2501                     if (bufferPos == COLOR_BITS) {
2502                         if (isRow) {
2503                             sb.append(
2504                                 string(
2505                                     abi.encodePacked(
2506                                         "<rect class='c",
2507                                         Strings.toString(buffer),
2508                                         "' x='",
2509                                         Strings.toString(lcol),
2510                                         "' y='"
2511                                     )
2512                                 )
2513                             );
2514                             sb.append(
2515                                 string(
2516                                     abi.encodePacked(
2517                                         Strings.toString(row),
2518                                         "' width='",
2519                                         Strings.toString(rcol - lcol + 1),
2520                                         "' height='1'/>"
2521                                     )
2522                                 )
2523                             );
2524                         } else {
2525                             sb.append(
2526                                 string(
2527                                     abi.encodePacked(
2528                                         "<rect class='c",
2529                                         Strings.toString(buffer),
2530                                         "' x='"
2531                                     )
2532                                 )
2533                             );
2534                             sb.append(
2535                                 string(
2536                                     abi.encodePacked(
2537                                         Strings.toString(col),
2538                                         "' y='",
2539                                         Strings.toString(row),
2540                                         "' width='1' height='1'/>"
2541                                     )
2542                                 )
2543                             );
2544                         }
2545                         buffer = 0;
2546                         bufferPos = 0;
2547                         state = RendererState.HEADER;
2548                     }
2549                 }
2550             }
2551         }
2552     }
2553 
2554     function debugSpriteToSvg(bytes memory sprite)
2555         public
2556         pure
2557         returns (string memory)
2558     {
2559         StringBuffer memory sb = StringBufferLibrary.empty();
2560 
2561         sb.append(
2562             "<svg class='nft' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 34 34' height='100%' width='100%'>"
2563         );
2564         renderSprite(sprite, sb);
2565         sb.append("<style>svg.nft{shape-rendering: crispEdges}");
2566         Colors.getColorCss(sb);
2567         sb.append("</style></svg>");
2568 
2569         return sb.get();
2570     }
2571 
2572     function addSvgHeader(StringBuffer memory sb) internal pure {
2573         sb.append(
2574             "<svg class='nft' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 34 34' height='100%' width='100%'>"
2575         );
2576     }
2577 
2578     function addSvgFooter(StringBuffer memory sb) internal pure {
2579         sb.append("<style>svg.nft{shape-rendering: crispEdges}");
2580         Colors.getColorCss(sb);
2581         Colors.getRainbowCss(sb);
2582         sb.append("</style></svg>");
2583     }
2584 
2585     function bitMonsterToSvg(BitMonster memory bm)
2586         external
2587         pure
2588         returns (string memory)
2589     {
2590         StringBuffer memory sb = StringBufferLibrary.empty();
2591 
2592         addSvgHeader(sb);
2593         if (bm.special == Special.NONE) {
2594             sb.append(renderBg(bm.bgColor));
2595             renderSprite(Sprites.BODY_SPRITE, sb);
2596             renderSprite(Sprites.getOutfitSprite(bm.outfit), sb);
2597             renderSprite(Sprites.getHandAccessorySprite(bm.handAccessory), sb);
2598             if (bm.mouth != Mouth.BREATHING_FIRE) {
2599                 renderSprite(Sprites.getMouthSprite(bm.mouth), sb);
2600             }
2601             if (bm.eyes != Eyes.LASER_EYES) {
2602                 renderSprite(Sprites.getEyesSprite(bm.eyes), sb);
2603             }
2604             renderSprite(Sprites.getHeadAccessorySprite(bm.headAccessory), sb);
2605             if (bm.mouth == Mouth.BREATHING_FIRE) {
2606                 renderSprite(Sprites.getMouthSprite(bm.mouth), sb);
2607             }
2608             if (bm.eyes == Eyes.LASER_EYES) {
2609                 renderSprite(Sprites.getEyesSprite(bm.eyes), sb);
2610             }
2611         }
2612         else {
2613             renderSprite(SpecialSprites.getSpecialSprite(bm.special), sb);
2614         }
2615         addSvgFooter(sb);
2616 
2617         return sb.get();
2618     }
2619 }
2620 
2621 // File: @openzeppelin/contracts/utils/Context.sol
2622 
2623 
2624 
2625 pragma solidity ^0.8.0;
2626 
2627 /**
2628  * @dev Provides information about the current execution context, including the
2629  * sender of the transaction and its data. While these are generally available
2630  * via msg.sender and msg.data, they should not be accessed in such a direct
2631  * manner, since when dealing with meta-transactions the account sending and
2632  * paying for execution may not be the actual sender (as far as an application
2633  * is concerned).
2634  *
2635  * This contract is only required for intermediate, library-like contracts.
2636  */
2637 abstract contract Context {
2638     function _msgSender() internal view virtual returns (address) {
2639         return msg.sender;
2640     }
2641 
2642     function _msgData() internal view virtual returns (bytes calldata) {
2643         return msg.data;
2644     }
2645 }
2646 
2647 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2648 
2649 
2650 
2651 pragma solidity ^0.8.0;
2652 
2653 
2654 
2655 
2656 /**
2657  * @dev Implementation of the {IERC20} interface.
2658  *
2659  * This implementation is agnostic to the way tokens are created. This means
2660  * that a supply mechanism has to be added in a derived contract using {_mint}.
2661  * For a generic mechanism see {ERC20PresetMinterPauser}.
2662  *
2663  * TIP: For a detailed writeup see our guide
2664  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
2665  * to implement supply mechanisms].
2666  *
2667  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2668  * instead returning `false` on failure. This behavior is nonetheless
2669  * conventional and does not conflict with the expectations of ERC20
2670  * applications.
2671  *
2672  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2673  * This allows applications to reconstruct the allowance for all accounts just
2674  * by listening to said events. Other implementations of the EIP may not emit
2675  * these events, as it isn't required by the specification.
2676  *
2677  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2678  * functions have been added to mitigate the well-known issues around setting
2679  * allowances. See {IERC20-approve}.
2680  */
2681 contract ERC20 is Context, IERC20, IERC20Metadata {
2682     mapping(address => uint256) private _balances;
2683 
2684     mapping(address => mapping(address => uint256)) private _allowances;
2685 
2686     uint256 private _totalSupply;
2687 
2688     string private _name;
2689     string private _symbol;
2690 
2691     /**
2692      * @dev Sets the values for {name} and {symbol}.
2693      *
2694      * The default value of {decimals} is 18. To select a different value for
2695      * {decimals} you should overload it.
2696      *
2697      * All two of these values are immutable: they can only be set once during
2698      * construction.
2699      */
2700     constructor(string memory name_, string memory symbol_) {
2701         _name = name_;
2702         _symbol = symbol_;
2703     }
2704 
2705     /**
2706      * @dev Returns the name of the token.
2707      */
2708     function name() public view virtual override returns (string memory) {
2709         return _name;
2710     }
2711 
2712     /**
2713      * @dev Returns the symbol of the token, usually a shorter version of the
2714      * name.
2715      */
2716     function symbol() public view virtual override returns (string memory) {
2717         return _symbol;
2718     }
2719 
2720     /**
2721      * @dev Returns the number of decimals used to get its user representation.
2722      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2723      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2724      *
2725      * Tokens usually opt for a value of 18, imitating the relationship between
2726      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2727      * overridden;
2728      *
2729      * NOTE: This information is only used for _display_ purposes: it in
2730      * no way affects any of the arithmetic of the contract, including
2731      * {IERC20-balanceOf} and {IERC20-transfer}.
2732      */
2733     function decimals() public view virtual override returns (uint8) {
2734         return 18;
2735     }
2736 
2737     /**
2738      * @dev See {IERC20-totalSupply}.
2739      */
2740     function totalSupply() public view virtual override returns (uint256) {
2741         return _totalSupply;
2742     }
2743 
2744     /**
2745      * @dev See {IERC20-balanceOf}.
2746      */
2747     function balanceOf(address account) public view virtual override returns (uint256) {
2748         return _balances[account];
2749     }
2750 
2751     /**
2752      * @dev See {IERC20-transfer}.
2753      *
2754      * Requirements:
2755      *
2756      * - `recipient` cannot be the zero address.
2757      * - the caller must have a balance of at least `amount`.
2758      */
2759     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
2760         _transfer(_msgSender(), recipient, amount);
2761         return true;
2762     }
2763 
2764     /**
2765      * @dev See {IERC20-allowance}.
2766      */
2767     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2768         return _allowances[owner][spender];
2769     }
2770 
2771     /**
2772      * @dev See {IERC20-approve}.
2773      *
2774      * Requirements:
2775      *
2776      * - `spender` cannot be the zero address.
2777      */
2778     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2779         _approve(_msgSender(), spender, amount);
2780         return true;
2781     }
2782 
2783     /**
2784      * @dev See {IERC20-transferFrom}.
2785      *
2786      * Emits an {Approval} event indicating the updated allowance. This is not
2787      * required by the EIP. See the note at the beginning of {ERC20}.
2788      *
2789      * Requirements:
2790      *
2791      * - `sender` and `recipient` cannot be the zero address.
2792      * - `sender` must have a balance of at least `amount`.
2793      * - the caller must have allowance for ``sender``'s tokens of at least
2794      * `amount`.
2795      */
2796     function transferFrom(
2797         address sender,
2798         address recipient,
2799         uint256 amount
2800     ) public virtual override returns (bool) {
2801         _transfer(sender, recipient, amount);
2802 
2803         uint256 currentAllowance = _allowances[sender][_msgSender()];
2804         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
2805         unchecked {
2806             _approve(sender, _msgSender(), currentAllowance - amount);
2807         }
2808 
2809         return true;
2810     }
2811 
2812     /**
2813      * @dev Atomically increases the allowance granted to `spender` by the caller.
2814      *
2815      * This is an alternative to {approve} that can be used as a mitigation for
2816      * problems described in {IERC20-approve}.
2817      *
2818      * Emits an {Approval} event indicating the updated allowance.
2819      *
2820      * Requirements:
2821      *
2822      * - `spender` cannot be the zero address.
2823      */
2824     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2825         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
2826         return true;
2827     }
2828 
2829     /**
2830      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2831      *
2832      * This is an alternative to {approve} that can be used as a mitigation for
2833      * problems described in {IERC20-approve}.
2834      *
2835      * Emits an {Approval} event indicating the updated allowance.
2836      *
2837      * Requirements:
2838      *
2839      * - `spender` cannot be the zero address.
2840      * - `spender` must have allowance for the caller of at least
2841      * `subtractedValue`.
2842      */
2843     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2844         uint256 currentAllowance = _allowances[_msgSender()][spender];
2845         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2846         unchecked {
2847             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
2848         }
2849 
2850         return true;
2851     }
2852 
2853     /**
2854      * @dev Moves `amount` of tokens from `sender` to `recipient`.
2855      *
2856      * This internal function is equivalent to {transfer}, and can be used to
2857      * e.g. implement automatic token fees, slashing mechanisms, etc.
2858      *
2859      * Emits a {Transfer} event.
2860      *
2861      * Requirements:
2862      *
2863      * - `sender` cannot be the zero address.
2864      * - `recipient` cannot be the zero address.
2865      * - `sender` must have a balance of at least `amount`.
2866      */
2867     function _transfer(
2868         address sender,
2869         address recipient,
2870         uint256 amount
2871     ) internal virtual {
2872         require(sender != address(0), "ERC20: transfer from the zero address");
2873         require(recipient != address(0), "ERC20: transfer to the zero address");
2874 
2875         _beforeTokenTransfer(sender, recipient, amount);
2876 
2877         uint256 senderBalance = _balances[sender];
2878         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
2879         unchecked {
2880             _balances[sender] = senderBalance - amount;
2881         }
2882         _balances[recipient] += amount;
2883 
2884         emit Transfer(sender, recipient, amount);
2885 
2886         _afterTokenTransfer(sender, recipient, amount);
2887     }
2888 
2889     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2890      * the total supply.
2891      *
2892      * Emits a {Transfer} event with `from` set to the zero address.
2893      *
2894      * Requirements:
2895      *
2896      * - `account` cannot be the zero address.
2897      */
2898     function _mint(address account, uint256 amount) internal virtual {
2899         require(account != address(0), "ERC20: mint to the zero address");
2900 
2901         _beforeTokenTransfer(address(0), account, amount);
2902 
2903         _totalSupply += amount;
2904         _balances[account] += amount;
2905         emit Transfer(address(0), account, amount);
2906 
2907         _afterTokenTransfer(address(0), account, amount);
2908     }
2909 
2910     /**
2911      * @dev Destroys `amount` tokens from `account`, reducing the
2912      * total supply.
2913      *
2914      * Emits a {Transfer} event with `to` set to the zero address.
2915      *
2916      * Requirements:
2917      *
2918      * - `account` cannot be the zero address.
2919      * - `account` must have at least `amount` tokens.
2920      */
2921     function _burn(address account, uint256 amount) internal virtual {
2922         require(account != address(0), "ERC20: burn from the zero address");
2923 
2924         _beforeTokenTransfer(account, address(0), amount);
2925 
2926         uint256 accountBalance = _balances[account];
2927         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2928         unchecked {
2929             _balances[account] = accountBalance - amount;
2930         }
2931         _totalSupply -= amount;
2932 
2933         emit Transfer(account, address(0), amount);
2934 
2935         _afterTokenTransfer(account, address(0), amount);
2936     }
2937 
2938     /**
2939      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2940      *
2941      * This internal function is equivalent to `approve`, and can be used to
2942      * e.g. set automatic allowances for certain subsystems, etc.
2943      *
2944      * Emits an {Approval} event.
2945      *
2946      * Requirements:
2947      *
2948      * - `owner` cannot be the zero address.
2949      * - `spender` cannot be the zero address.
2950      */
2951     function _approve(
2952         address owner,
2953         address spender,
2954         uint256 amount
2955     ) internal virtual {
2956         require(owner != address(0), "ERC20: approve from the zero address");
2957         require(spender != address(0), "ERC20: approve to the zero address");
2958 
2959         _allowances[owner][spender] = amount;
2960         emit Approval(owner, spender, amount);
2961     }
2962 
2963     /**
2964      * @dev Hook that is called before any transfer of tokens. This includes
2965      * minting and burning.
2966      *
2967      * Calling conditions:
2968      *
2969      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2970      * will be transferred to `to`.
2971      * - when `from` is zero, `amount` tokens will be minted for `to`.
2972      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2973      * - `from` and `to` are never both zero.
2974      *
2975      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2976      */
2977     function _beforeTokenTransfer(
2978         address from,
2979         address to,
2980         uint256 amount
2981     ) internal virtual {}
2982 
2983     /**
2984      * @dev Hook that is called after any transfer of tokens. This includes
2985      * minting and burning.
2986      *
2987      * Calling conditions:
2988      *
2989      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2990      * has been transferred to `to`.
2991      * - when `from` is zero, `amount` tokens have been minted for `to`.
2992      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2993      * - `from` and `to` are never both zero.
2994      *
2995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2996      */
2997     function _afterTokenTransfer(
2998         address from,
2999         address to,
3000         uint256 amount
3001     ) internal virtual {}
3002 }
3003 
3004 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
3005 
3006 
3007 
3008 pragma solidity ^0.8.0;
3009 
3010 
3011 
3012 /**
3013  * @dev Extension of {ERC20} that allows token holders to destroy both their own
3014  * tokens and those that they have an allowance for, in a way that can be
3015  * recognized off-chain (via event analysis).
3016  */
3017 abstract contract ERC20Burnable is Context, ERC20 {
3018     /**
3019      * @dev Destroys `amount` tokens from the caller.
3020      *
3021      * See {ERC20-_burn}.
3022      */
3023     function burn(uint256 amount) public virtual {
3024         _burn(_msgSender(), amount);
3025     }
3026 
3027     /**
3028      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
3029      * allowance.
3030      *
3031      * See {ERC20-_burn} and {ERC20-allowance}.
3032      *
3033      * Requirements:
3034      *
3035      * - the caller must have allowance for ``accounts``'s tokens of at least
3036      * `amount`.
3037      */
3038     function burnFrom(address account, uint256 amount) public virtual {
3039         uint256 currentAllowance = allowance(account, _msgSender());
3040         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
3041         unchecked {
3042             _approve(account, _msgSender(), currentAllowance - amount);
3043         }
3044         _burn(account, amount);
3045     }
3046 }
3047 
3048 // File: @openzeppelin/contracts/access/Ownable.sol
3049 
3050 
3051 
3052 pragma solidity ^0.8.0;
3053 
3054 
3055 /**
3056  * @dev Contract module which provides a basic access control mechanism, where
3057  * there is an account (an owner) that can be granted exclusive access to
3058  * specific functions.
3059  *
3060  * By default, the owner account will be the one that deploys the contract. This
3061  * can later be changed with {transferOwnership}.
3062  *
3063  * This module is used through inheritance. It will make available the modifier
3064  * `onlyOwner`, which can be applied to your functions to restrict their use to
3065  * the owner.
3066  */
3067 abstract contract Ownable is Context {
3068     address private _owner;
3069 
3070     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3071 
3072     /**
3073      * @dev Initializes the contract setting the deployer as the initial owner.
3074      */
3075     constructor() {
3076         _setOwner(_msgSender());
3077     }
3078 
3079     /**
3080      * @dev Returns the address of the current owner.
3081      */
3082     function owner() public view virtual returns (address) {
3083         return _owner;
3084     }
3085 
3086     /**
3087      * @dev Throws if called by any account other than the owner.
3088      */
3089     modifier onlyOwner() {
3090         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3091         _;
3092     }
3093 
3094     /**
3095      * @dev Leaves the contract without owner. It will not be possible to call
3096      * `onlyOwner` functions anymore. Can only be called by the current owner.
3097      *
3098      * NOTE: Renouncing ownership will leave the contract without an owner,
3099      * thereby removing any functionality that is only available to the owner.
3100      */
3101     function renounceOwnership() public virtual onlyOwner {
3102         _setOwner(address(0));
3103     }
3104 
3105     /**
3106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3107      * Can only be called by the current owner.
3108      */
3109     function transferOwnership(address newOwner) public virtual onlyOwner {
3110         require(newOwner != address(0), "Ownable: new owner is the zero address");
3111         _setOwner(newOwner);
3112     }
3113 
3114     function _setOwner(address newOwner) private {
3115         address oldOwner = _owner;
3116         _owner = newOwner;
3117         emit OwnershipTransferred(oldOwner, newOwner);
3118     }
3119 }
3120 
3121 // File: @openzeppelin/contracts/utils/Address.sol
3122 
3123 
3124 
3125 pragma solidity ^0.8.0;
3126 
3127 /**
3128  * @dev Collection of functions related to the address type
3129  */
3130 library Address {
3131     /**
3132      * @dev Returns true if `account` is a contract.
3133      *
3134      * [IMPORTANT]
3135      * ====
3136      * It is unsafe to assume that an address for which this function returns
3137      * false is an externally-owned account (EOA) and not a contract.
3138      *
3139      * Among others, `isContract` will return false for the following
3140      * types of addresses:
3141      *
3142      *  - an externally-owned account
3143      *  - a contract in construction
3144      *  - an address where a contract will be created
3145      *  - an address where a contract lived, but was destroyed
3146      * ====
3147      */
3148     function isContract(address account) internal view returns (bool) {
3149         // This method relies on extcodesize, which returns 0 for contracts in
3150         // construction, since the code is only stored at the end of the
3151         // constructor execution.
3152 
3153         uint256 size;
3154         assembly {
3155             size := extcodesize(account)
3156         }
3157         return size > 0;
3158     }
3159 
3160     /**
3161      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
3162      * `recipient`, forwarding all available gas and reverting on errors.
3163      *
3164      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
3165      * of certain opcodes, possibly making contracts go over the 2300 gas limit
3166      * imposed by `transfer`, making them unable to receive funds via
3167      * `transfer`. {sendValue} removes this limitation.
3168      *
3169      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
3170      *
3171      * IMPORTANT: because control is transferred to `recipient`, care must be
3172      * taken to not create reentrancy vulnerabilities. Consider using
3173      * {ReentrancyGuard} or the
3174      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
3175      */
3176     function sendValue(address payable recipient, uint256 amount) internal {
3177         require(address(this).balance >= amount, "Address: insufficient balance");
3178 
3179         (bool success, ) = recipient.call{value: amount}("");
3180         require(success, "Address: unable to send value, recipient may have reverted");
3181     }
3182 
3183     /**
3184      * @dev Performs a Solidity function call using a low level `call`. A
3185      * plain `call` is an unsafe replacement for a function call: use this
3186      * function instead.
3187      *
3188      * If `target` reverts with a revert reason, it is bubbled up by this
3189      * function (like regular Solidity function calls).
3190      *
3191      * Returns the raw returned data. To convert to the expected return value,
3192      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
3193      *
3194      * Requirements:
3195      *
3196      * - `target` must be a contract.
3197      * - calling `target` with `data` must not revert.
3198      *
3199      * _Available since v3.1._
3200      */
3201     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
3202         return functionCall(target, data, "Address: low-level call failed");
3203     }
3204 
3205     /**
3206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
3207      * `errorMessage` as a fallback revert reason when `target` reverts.
3208      *
3209      * _Available since v3.1._
3210      */
3211     function functionCall(
3212         address target,
3213         bytes memory data,
3214         string memory errorMessage
3215     ) internal returns (bytes memory) {
3216         return functionCallWithValue(target, data, 0, errorMessage);
3217     }
3218 
3219     /**
3220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3221      * but also transferring `value` wei to `target`.
3222      *
3223      * Requirements:
3224      *
3225      * - the calling contract must have an ETH balance of at least `value`.
3226      * - the called Solidity function must be `payable`.
3227      *
3228      * _Available since v3.1._
3229      */
3230     function functionCallWithValue(
3231         address target,
3232         bytes memory data,
3233         uint256 value
3234     ) internal returns (bytes memory) {
3235         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
3236     }
3237 
3238     /**
3239      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
3240      * with `errorMessage` as a fallback revert reason when `target` reverts.
3241      *
3242      * _Available since v3.1._
3243      */
3244     function functionCallWithValue(
3245         address target,
3246         bytes memory data,
3247         uint256 value,
3248         string memory errorMessage
3249     ) internal returns (bytes memory) {
3250         require(address(this).balance >= value, "Address: insufficient balance for call");
3251         require(isContract(target), "Address: call to non-contract");
3252 
3253         (bool success, bytes memory returndata) = target.call{value: value}(data);
3254         return verifyCallResult(success, returndata, errorMessage);
3255     }
3256 
3257     /**
3258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3259      * but performing a static call.
3260      *
3261      * _Available since v3.3._
3262      */
3263     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
3264         return functionStaticCall(target, data, "Address: low-level static call failed");
3265     }
3266 
3267     /**
3268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
3269      * but performing a static call.
3270      *
3271      * _Available since v3.3._
3272      */
3273     function functionStaticCall(
3274         address target,
3275         bytes memory data,
3276         string memory errorMessage
3277     ) internal view returns (bytes memory) {
3278         require(isContract(target), "Address: static call to non-contract");
3279 
3280         (bool success, bytes memory returndata) = target.staticcall(data);
3281         return verifyCallResult(success, returndata, errorMessage);
3282     }
3283 
3284     /**
3285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3286      * but performing a delegate call.
3287      *
3288      * _Available since v3.4._
3289      */
3290     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
3291         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
3292     }
3293 
3294     /**
3295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
3296      * but performing a delegate call.
3297      *
3298      * _Available since v3.4._
3299      */
3300     function functionDelegateCall(
3301         address target,
3302         bytes memory data,
3303         string memory errorMessage
3304     ) internal returns (bytes memory) {
3305         require(isContract(target), "Address: delegate call to non-contract");
3306 
3307         (bool success, bytes memory returndata) = target.delegatecall(data);
3308         return verifyCallResult(success, returndata, errorMessage);
3309     }
3310 
3311     /**
3312      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
3313      * revert reason using the provided one.
3314      *
3315      * _Available since v4.3._
3316      */
3317     function verifyCallResult(
3318         bool success,
3319         bytes memory returndata,
3320         string memory errorMessage
3321     ) internal pure returns (bytes memory) {
3322         if (success) {
3323             return returndata;
3324         } else {
3325             // Look for revert reason and bubble it up if present
3326             if (returndata.length > 0) {
3327                 // The easiest way to bubble the revert reason is using memory via assembly
3328 
3329                 assembly {
3330                     let returndata_size := mload(returndata)
3331                     revert(add(32, returndata), returndata_size)
3332                 }
3333             } else {
3334                 revert(errorMessage);
3335             }
3336         }
3337     }
3338 }
3339 
3340 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
3341 
3342 
3343 
3344 pragma solidity ^0.8.0;
3345 
3346 /**
3347  * @title ERC721 token receiver interface
3348  * @dev Interface for any contract that wants to support safeTransfers
3349  * from ERC721 asset contracts.
3350  */
3351 interface IERC721Receiver {
3352     /**
3353      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
3354      * by `operator` from `from`, this function is called.
3355      *
3356      * It must return its Solidity selector to confirm the token transfer.
3357      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
3358      *
3359      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
3360      */
3361     function onERC721Received(
3362         address operator,
3363         address from,
3364         uint256 tokenId,
3365         bytes calldata data
3366     ) external returns (bytes4);
3367 }
3368 
3369 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3370 
3371 
3372 
3373 pragma solidity ^0.8.0;
3374 
3375 /**
3376  * @dev Interface of the ERC165 standard, as defined in the
3377  * https://eips.ethereum.org/EIPS/eip-165[EIP].
3378  *
3379  * Implementers can declare support of contract interfaces, which can then be
3380  * queried by others ({ERC165Checker}).
3381  *
3382  * For an implementation, see {ERC165}.
3383  */
3384 interface IERC165 {
3385     /**
3386      * @dev Returns true if this contract implements the interface defined by
3387      * `interfaceId`. See the corresponding
3388      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
3389      * to learn more about how these ids are created.
3390      *
3391      * This function call must use less than 30 000 gas.
3392      */
3393     function supportsInterface(bytes4 interfaceId) external view returns (bool);
3394 }
3395 
3396 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
3397 
3398 
3399 
3400 pragma solidity ^0.8.0;
3401 
3402 
3403 /**
3404  * @dev Implementation of the {IERC165} interface.
3405  *
3406  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
3407  * for the additional interface id that will be supported. For example:
3408  *
3409  * ```solidity
3410  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3411  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
3412  * }
3413  * ```
3414  *
3415  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
3416  */
3417 abstract contract ERC165 is IERC165 {
3418     /**
3419      * @dev See {IERC165-supportsInterface}.
3420      */
3421     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3422         return interfaceId == type(IERC165).interfaceId;
3423     }
3424 }
3425 
3426 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
3427 
3428 
3429 
3430 pragma solidity ^0.8.0;
3431 
3432 
3433 /**
3434  * @dev Required interface of an ERC721 compliant contract.
3435  */
3436 interface IERC721 is IERC165 {
3437     /**
3438      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
3439      */
3440     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
3441 
3442     /**
3443      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
3444      */
3445     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
3446 
3447     /**
3448      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
3449      */
3450     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
3451 
3452     /**
3453      * @dev Returns the number of tokens in ``owner``'s account.
3454      */
3455     function balanceOf(address owner) external view returns (uint256 balance);
3456 
3457     /**
3458      * @dev Returns the owner of the `tokenId` token.
3459      *
3460      * Requirements:
3461      *
3462      * - `tokenId` must exist.
3463      */
3464     function ownerOf(uint256 tokenId) external view returns (address owner);
3465 
3466     /**
3467      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3468      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3469      *
3470      * Requirements:
3471      *
3472      * - `from` cannot be the zero address.
3473      * - `to` cannot be the zero address.
3474      * - `tokenId` token must exist and be owned by `from`.
3475      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
3476      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3477      *
3478      * Emits a {Transfer} event.
3479      */
3480     function safeTransferFrom(
3481         address from,
3482         address to,
3483         uint256 tokenId
3484     ) external;
3485 
3486     /**
3487      * @dev Transfers `tokenId` token from `from` to `to`.
3488      *
3489      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
3490      *
3491      * Requirements:
3492      *
3493      * - `from` cannot be the zero address.
3494      * - `to` cannot be the zero address.
3495      * - `tokenId` token must be owned by `from`.
3496      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3497      *
3498      * Emits a {Transfer} event.
3499      */
3500     function transferFrom(
3501         address from,
3502         address to,
3503         uint256 tokenId
3504     ) external;
3505 
3506     /**
3507      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3508      * The approval is cleared when the token is transferred.
3509      *
3510      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
3511      *
3512      * Requirements:
3513      *
3514      * - The caller must own the token or be an approved operator.
3515      * - `tokenId` must exist.
3516      *
3517      * Emits an {Approval} event.
3518      */
3519     function approve(address to, uint256 tokenId) external;
3520 
3521     /**
3522      * @dev Returns the account approved for `tokenId` token.
3523      *
3524      * Requirements:
3525      *
3526      * - `tokenId` must exist.
3527      */
3528     function getApproved(uint256 tokenId) external view returns (address operator);
3529 
3530     /**
3531      * @dev Approve or remove `operator` as an operator for the caller.
3532      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
3533      *
3534      * Requirements:
3535      *
3536      * - The `operator` cannot be the caller.
3537      *
3538      * Emits an {ApprovalForAll} event.
3539      */
3540     function setApprovalForAll(address operator, bool _approved) external;
3541 
3542     /**
3543      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
3544      *
3545      * See {setApprovalForAll}
3546      */
3547     function isApprovedForAll(address owner, address operator) external view returns (bool);
3548 
3549     /**
3550      * @dev Safely transfers `tokenId` token from `from` to `to`.
3551      *
3552      * Requirements:
3553      *
3554      * - `from` cannot be the zero address.
3555      * - `to` cannot be the zero address.
3556      * - `tokenId` token must exist and be owned by `from`.
3557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3559      *
3560      * Emits a {Transfer} event.
3561      */
3562     function safeTransferFrom(
3563         address from,
3564         address to,
3565         uint256 tokenId,
3566         bytes calldata data
3567     ) external;
3568 }
3569 
3570 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
3571 
3572 
3573 
3574 pragma solidity ^0.8.0;
3575 
3576 
3577 /**
3578  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
3579  * @dev See https://eips.ethereum.org/EIPS/eip-721
3580  */
3581 interface IERC721Enumerable is IERC721 {
3582     /**
3583      * @dev Returns the total amount of tokens stored by the contract.
3584      */
3585     function totalSupply() external view returns (uint256);
3586 
3587     /**
3588      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
3589      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
3590      */
3591     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
3592 
3593     /**
3594      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
3595      * Use along with {totalSupply} to enumerate all tokens.
3596      */
3597     function tokenByIndex(uint256 index) external view returns (uint256);
3598 }
3599 
3600 // File: contracts/IBitMonsters.sol
3601 
3602 
3603 pragma solidity ^0.8.0;
3604 
3605 
3606 
3607 interface IBitMonsters is IERC721Enumerable {
3608     function getBitMonster(uint256 tokenId) external view returns (BitMonster memory);
3609     function setBitMonster(uint256 tokenId, BitMonster memory bm) external;
3610     function createBitMonster(BitMonster memory bm, address owner) external;
3611     function isAdmin(address addr) external view returns (bool);
3612 }
3613 // File: contracts/BitMonstersAddon.sol
3614 
3615 
3616 pragma solidity ^0.8.0;
3617 
3618 
3619 
3620 /**
3621  * @title A contract should inherit this if it provides functionality for the Bit Monsters contract.
3622  */
3623 abstract contract BitMonstersAddon is Ownable {
3624     IBitMonsters internal bitMonsters;
3625 
3626     modifier onlyAdmin() {
3627         require(bitMonsters.isAdmin(msg.sender), "admins only");
3628         _;
3629     }
3630 
3631     modifier ownsToken(uint tokenId) {
3632         require(bitMonsters.ownerOf(tokenId) == msg.sender, "you don't own this shit");
3633         _;
3634     }
3635 
3636     /**
3637      * @notice This must be called before the Brainz contract can be used.
3638      *
3639      * @dev Within the BitMonsters contract, call initializeBrainz().
3640      */
3641     function setBitMonstersContract(IBitMonsters _contract) external onlyOwner {
3642         bitMonsters = _contract;
3643     }
3644 }
3645 
3646 // File: contracts/Metadata.sol
3647 
3648 
3649 pragma solidity ^0.8.0;
3650 
3651 
3652 
3653 
3654 
3655 
3656 
3657 struct JsonAttribute {
3658     string key;
3659     string value;
3660 }
3661 
3662 contract Metadata is BitMonstersAddon {
3663     using Strings for uint;
3664     using Enums for *;
3665     using StringBufferLibrary for StringBuffer;
3666 
3667     mapping (uint256 => string) private names;
3668 
3669     function specialOsBgColor(Special s) internal pure returns (string memory) {
3670         if (s == Special.NONE) {
3671             return "FFFFFF";
3672         } 
3673         if (s == Special.DEVIL) {
3674             return "FF0000";
3675         }
3676         if (s == Special.GHOST) {
3677             return "FFFFFF";
3678         }
3679         if (s == Special.HIPPIE) {
3680             return "FF00FF";
3681         }
3682         if (s == Special.JOKER) {
3683             return "00FF00";
3684         }
3685         if (s == Special.PRISONER) {
3686             return "FFFF00";
3687         }
3688         if (s == Special.SQUID_GAME) {
3689             return "0088FF";
3690         }
3691         if (s == Special.WHERES_WALDO) {
3692             return "CC0000";
3693         }
3694         if (s == Special.HAZMAT) {
3695             return "FFFF00";
3696         }
3697         if (s == Special.ASTRONAUT) {
3698             return "000000";
3699         }
3700         revert("Invalid special given");
3701     }
3702 
3703     function makeOsMetadataArray(JsonAttribute[] memory attributes) public pure returns (string memory) {
3704         StringBuffer memory sb = StringBufferLibrary.empty();
3705 
3706         sb.append("[");
3707         bool empty = true;
3708 
3709         for (uint i = 0; i < attributes.length; ++i) {
3710             if (bytes(attributes[i].value).length > 0) {
3711                 sb.append(string(abi.encodePacked(
3712                     empty ? "" : ",",
3713                     '{"trait_type":"',
3714                     attributes[i].key,
3715                     '","value":"',
3716                     attributes[i].value,
3717                     '"}'
3718                 )));
3719                 empty = false;
3720             }
3721         }
3722 
3723         sb.append("]");
3724         return sb.get();
3725     }
3726 
3727     function getName(uint tokenId) public view returns (string memory name) {
3728         name = names[tokenId];
3729         if (bytes(name).length == 0) {
3730             name = string(abi.encodePacked("Bit Monster #", Strings.toString(tokenId)));
3731         }
3732     }
3733 
3734     function setName(uint tokenId, string memory name) external ownsToken(tokenId) {
3735         bytes memory b = bytes(name);
3736         for (uint i = 0; i < b.length; ++i) {
3737             uint8 char = uint8(b[i]);
3738             //              0-9                         A-Z                         a-z                   space
3739             if (!(char >= 48 && char <= 57 || char >= 65 && char <= 90 || char >= 97 && char <= 122 || char == 32)) {
3740                 revert("all chars must be [a-zA-Z0-9]");
3741             }
3742         }
3743         names[tokenId] = name;
3744     }
3745 
3746     function getMetadataJson(uint tokenId) external view returns (string memory) {
3747         BitMonster memory m = bitMonsters.getBitMonster(tokenId);
3748         string memory svg = Renderer.bitMonsterToSvg(m);
3749         string memory svgDataUrl = string(abi.encodePacked(
3750             "data:image/svg+xml;base64,",
3751             string(Base64.encode(bytes(svg)))
3752         ));
3753 
3754         JsonAttribute[] memory attributes;
3755         string memory bgColor;
3756         if (m.special != Special.NONE) {
3757             attributes = new JsonAttribute[](5);
3758             attributes[4] = JsonAttribute("Legendary", m.special.toString());
3759             bgColor = specialOsBgColor(m.special);
3760         }
3761         else {
3762             attributes = new JsonAttribute[](10);
3763             attributes[4] = JsonAttribute("Background Color", m.bgColor.toString());
3764             attributes[5] = JsonAttribute("Outfit", m.outfit.toString());
3765             attributes[6] = JsonAttribute("Hand Accessory", m.handAccessory.toString());
3766             attributes[7] = JsonAttribute("Mouth", m.mouth.toString());
3767             attributes[8] = JsonAttribute("Eyes", m.eyes.toString());
3768             attributes[9] = JsonAttribute("Head Accessory", m.headAccessory.toString());
3769             bgColor = Sprites.getBgHex(m.bgColor);
3770         }
3771         attributes[0] = JsonAttribute("Super Yield", m.superYield ? "true" : "");
3772         attributes[1] = JsonAttribute("Genesis", m.genesis ? "true" : "");
3773         attributes[2] = JsonAttribute("Dominant Gene", m.dominant.toString());
3774         attributes[3] = JsonAttribute("Recessive Gene", m.recessive.toString());
3775 
3776         return string(abi.encodePacked(
3777             '{"name":"',
3778             getName(tokenId),
3779             '","description":"8==D","image":"',
3780             svgDataUrl,
3781             '","attributes":',
3782             makeOsMetadataArray(attributes),
3783             ',"background_color":"',
3784             bgColor,
3785             '"}'
3786         ));
3787     }
3788 }
3789 
3790 // File: contracts/Minter.sol
3791 
3792 
3793 pragma solidity ^0.8.0;
3794 
3795 
3796 
3797 
3798 
3799 
3800 
3801 /**
3802  * @title Controls who (if anyone) can mint a Bit Monster.
3803  *
3804  * @dev In web3, these are represented as 0 (NotAllowed), 1 (WhitelistOnly), and 2 (AllAllowed).
3805  */
3806 enum MintingState {
3807     NotAllowed,
3808     WhitelistOnly,
3809     AllAllowed
3810 }
3811 
3812 contract Minter is BitMonstersAddon {
3813     using RngLibrary for Rng;
3814 
3815     uint256 constant public WHITELIST_PER = 6;
3816 
3817     address payable private payHere;
3818     // 0 == "not whitelisted"
3819     // 1000 + x == "whitelisted and x whitelists left"
3820     mapping (address => uint256) public whitelist;
3821     MintingState public mintingState;
3822 
3823     bool[9] public mintedSpecials;
3824     uint private mintedSpecialsCount = 0;
3825 
3826     Rng private rng;
3827 
3828     constructor(address payable paymentAddress, address[] memory whitelistedAddrs) {
3829         payHere = paymentAddress;
3830         whitelist[paymentAddress] = WHITELIST_PER + 1000;
3831         for (uint i = 0; i < whitelistedAddrs.length; ++i) {
3832             whitelist[whitelistedAddrs[i]] = WHITELIST_PER + 1000;
3833         }
3834         rng = RngLibrary.newRng();
3835     }
3836 
3837     /**
3838      * Adds someone to the whitelist.
3839      */
3840     function addToWhitelist(address[] memory addrs) external onlyAdmin {
3841         for (uint i = 0; i < addrs.length; ++i) {
3842             if (whitelist[addrs[i]] == 0) {
3843                 whitelist[addrs[i]] = WHITELIST_PER + 1000;
3844             }
3845         }
3846     }
3847 
3848     /**
3849      * Removes someone from the whitelist.
3850      */
3851     function removeFromWhitelist(address addr) external onlyAdmin {
3852         delete whitelist[addr];
3853     }
3854 
3855     /**
3856      * Generates a random Bit Monster.
3857      *
3858      * 9/6666 bit monsters will be special, which means they're prebuilt images instead of assembled from the 6 attributes a normal Bit Monster has.
3859      * All 9 specials are guaranteed to be minted by the time all 6666 Bit Monsters are minted.
3860      * The chance of a special at each roll is roughly even, although there's a slight dip in chance in the mid-range.
3861      */
3862     function generateBitMonster(Rng memory rn, bool[9] memory ms) internal returns (BitMonster memory) {
3863         uint count = bitMonsters.totalSupply();
3864 
3865         int ub = 6666 - int(count) - 1 - (90 - int(mintedSpecialsCount) * 10);
3866         if (ub < 0) {
3867             ub = 0;
3868         }
3869 
3870         BitMonster memory m;
3871         if (rn.generate(0, uint(ub)) <= (6666 - count) / 666) {
3872             m = BitMonsterGen.generateSpecialBitMonster(rn, ms);
3873         }
3874         else {
3875             m = BitMonsterGen.generateUnspecialBitMonster(rn);
3876         }
3877 
3878         if (m.special != Special.NONE) {
3879             mintedSpecialsCount++;
3880         }
3881         rng = rn;
3882         return m;
3883     }
3884 
3885     /**
3886      * Sets the MintingState. See MintingState above.
3887      * By default, no one is allowed to mint. This function must be called before any Bit Monsters can be minted.
3888      */
3889     function setMintingState(MintingState state) external onlyAdmin {
3890         mintingState = state;
3891     }
3892 
3893     /**
3894      * Mints some Bit Monsters.
3895      *
3896      * @param count The number of Bit Monsters to mint. Must be >= 1 and <= 10.
3897      *              You must send 0.06 ETH for each Bit Monster you want to mint.
3898      */
3899     function mint(uint count) external payable {
3900         require(count >= 1 && count <= 10, "Count must be >=1 and <=10");
3901         require(!Address.isContract(msg.sender), "Contracts cannot mint");
3902         require(mintingState != MintingState.NotAllowed, "Minting is not allowed atm");
3903 
3904         if (mintingState == MintingState.WhitelistOnly) {
3905             require(whitelist[msg.sender] >= 1000 + count, "Not enough whitelisted mints");
3906             whitelist[msg.sender] -= count;
3907         }
3908 
3909         require(msg.value == count * 0.06 ether, "Send exactly 0.06 ETH for each mint");
3910 
3911         Rng memory rn = rng;
3912         bool[9] memory ms = mintedSpecials;
3913 
3914         for (uint i = 0; i < count; ++i) {
3915             bitMonsters.createBitMonster(generateBitMonster(rn, ms), msg.sender);
3916         }
3917 
3918         rng = rn;
3919         mintedSpecials = ms;
3920 
3921         Address.sendValue(payHere, msg.value);
3922     }
3923 
3924     /**
3925      * Mint for a giveaway.
3926      */
3927     function giveawayMint(address[] memory winners) external onlyAdmin {
3928         Rng memory rn = rng;
3929 
3930         for (uint i = 0; i < winners.length; ++i) {
3931             bitMonsters.createBitMonster(BitMonsterGen.generateUnspecialBitMonster(rn), winners[i]);
3932         }
3933 
3934         rng = rn;
3935     }
3936 }
3937 // File: contracts/Brainz.sol
3938 
3939 
3940 pragma solidity ^0.8.0;
3941 
3942 
3943 
3944 
3945 
3946 
3947 
3948 
3949 
3950 // shamelessly "inspired by" the anonymice cheeth contract
3951 
3952 /**
3953  * @title The contract for the Brainz token and staking. At the moment, these can only be obtained by staking Bit Monsters.
3954  */
3955 contract Brainz is ERC20Burnable, BitMonstersAddon {
3956     using RngLibrary for Rng;
3957 
3958     mapping (uint => uint) public tokenIdToTimestamp;
3959     Rng private rng = RngLibrary.newRng();
3960 
3961     constructor() ERC20("Brainz", "BRAINZ") {
3962     }
3963 
3964     function adminMint(address addr, uint256 count) external onlyAdmin {
3965         _mint(addr, count * 1 ether);
3966     }
3967 
3968     function adminBurn(address addr, uint256 count) external onlyAdmin {
3969         _burn(addr, count * 1 ether);
3970     }
3971 
3972     /**
3973      * Claims all Brainz from all staked Bit Monsters the caller owns.
3974      */
3975     function claimBrainz() external {
3976         uint count = bitMonsters.balanceOf(msg.sender);
3977         uint total = 0;
3978 
3979         for (uint i = 0; i < count; ++i) {
3980             uint tokenId = bitMonsters.tokenOfOwnerByIndex(msg.sender, i);
3981             uint rewards = calculateRewards(tokenId);
3982             if (rewards > 0) {
3983                 tokenIdToTimestamp[tokenId] = block.timestamp - ((block.timestamp - tokenIdToTimestamp[tokenId]) % 86400);
3984             }
3985             total += rewards;
3986         }
3987 
3988         _mint(msg.sender, total);
3989     }
3990 
3991     function rewardRate(BitMonster memory m) public pure returns (uint) {
3992         return ((m.genesis ? 2 : 1) * (m.special != Special.NONE ? 2 : 1) + (m.superYield ? 1 : 0)) * 1 ether;
3993     }
3994 
3995     /**
3996      * Returns the amount of pending Brainz the caller can currently claim.
3997      */
3998     function calculateRewards(uint tokenId) public view returns (uint) {
3999         BitMonster memory m = bitMonsters.getBitMonster(tokenId);
4000         uint nDays = (block.timestamp - tokenIdToTimestamp[tokenId]) / 86400;
4001 
4002         return rewardRate(m) * nDays;
4003     }
4004 
4005     /**
4006      * Tracks the Bit Monster with the given tokenId for reward calculation.
4007      */
4008     function register(uint tokenId) external onlyAdmin {
4009         require(tokenIdToTimestamp[tokenId] == 0, "already staked");
4010         tokenIdToTimestamp[tokenId] = block.timestamp;
4011     }
4012 
4013     /**
4014      * Stake your Brainz a-la OSRS Duel Arena.
4015      *
4016      * 50% chance of multiplying your Brainz by 1.9x rounded up.
4017      * 50% chance of losing everything you stake.
4018      */
4019     function stake(uint count) external returns (bool won) {
4020         require(count > 0, "Must stake at least one BRAINZ");
4021         require(balanceOf(msg.sender) >= count, "You don't have that many tokens");
4022 
4023         Rng memory rn = rng;
4024 
4025         if (rn.generate(0, 1) == 0) {
4026             _mint(msg.sender, (count - count / 10) * 1 ether);
4027             won = true;
4028         }
4029         else {
4030             _burn(msg.sender, count * 1 ether);
4031             won = false;
4032         }
4033 
4034         rng = rn;
4035     }
4036 }
4037 
4038 // File: contracts/Mutator.sol
4039 
4040 
4041 pragma solidity ^0.8.0;
4042 
4043 
4044 
4045 
4046 
4047 
4048 
4049 contract Mutator is BitMonstersAddon {
4050     using RngLibrary for Rng;
4051 
4052     Brainz private brainz;
4053     Rng private rng = RngLibrary.newRng();
4054 
4055     constructor(Brainz _brainz) {
4056         brainz = _brainz;
4057     }
4058 
4059     function rerollTrait(uint256 tokenId, RerollTrait trait) external ownsToken(tokenId) {
4060         BitMonster memory bm = bitMonsters.getBitMonster(tokenId);
4061         require(bm.special == Special.NONE, "Specials cannot be rerolled");
4062 
4063         Rng memory rn = rng;
4064 
4065         uint brainzCount;
4066         if (trait == RerollTrait.BgColor) {
4067             brainzCount = 4;
4068         }
4069         else if (trait == RerollTrait.HandAccessory) {
4070             brainzCount = 10;
4071         }
4072         else {
4073             brainzCount = 8;
4074         }
4075 
4076         brainz.adminBurn(msg.sender, brainzCount);
4077 
4078         BitMonsterGen.rerollTrait(rn, bm, trait);
4079 
4080         bitMonsters.setBitMonster(tokenId, bm);
4081         rng = rn;
4082     }
4083 
4084     function rerollAll(uint256 tokenId) external ownsToken(tokenId) {
4085         BitMonster memory bm = bitMonsters.getBitMonster(tokenId);
4086         require(bm.special == Special.NONE, "Specials cannot be rerolled");
4087 
4088         Rng memory rn = rng;
4089 
4090         brainz.adminBurn(msg.sender, 10);
4091 
4092         BitMonsterGen.rerollAll(rn, bm);
4093 
4094         bitMonsters.setBitMonster(tokenId, bm);
4095         rng = rn;
4096     }
4097 
4098     function mutate(uint256 donorId, uint256 recipientId, RerollTrait trait, uint256 brainzCount) external ownsToken(donorId) ownsToken(recipientId) returns (bool donorBurnt, bool recipientSuccess) {
4099         require(bitMonsters.ownerOf(donorId) == msg.sender, "you don't own the donor");
4100         require(bitMonsters.ownerOf(recipientId) == msg.sender, "you don't own the recipient");
4101         require(donorId != recipientId, "the donor and recipient are the same");
4102         require(brainzCount > 0, "must use at least one brainz");
4103 
4104         brainz.adminBurn(msg.sender, brainzCount);
4105 
4106         BitMonster memory donor = bitMonsters.getBitMonster(donorId);
4107         BitMonster memory recipient = bitMonsters.getBitMonster(recipientId);
4108 
4109         require(donor.special == Special.NONE && recipient.special == Special.NONE, "can't mutate special");
4110         require(trait != RerollTrait.BgColor || donor.bgColor != BgColor.RAINBOW, "rainbow bg cannot be mutated");
4111 
4112         Rng memory rn = rng;
4113 
4114         // success rate of mutation = brainz / (brainz + 3)
4115         if (rn.generate(1, brainzCount + 3) <= brainzCount) {
4116             recipientSuccess = true;
4117             recipient.genesis = false;
4118             if (trait == RerollTrait.BgColor) {
4119                 recipient.bgColor = donor.bgColor;
4120             }
4121             else if (trait == RerollTrait.Outfit) {
4122                 recipient.outfit = donor.outfit;
4123             }
4124             else if (trait == RerollTrait.HandAccessory) {
4125                 recipient.handAccessory = donor.handAccessory;
4126             }
4127             else if (trait == RerollTrait.Mouth) {
4128                 recipient.mouth = donor.mouth;
4129             }
4130             else if (trait == RerollTrait.Eyes) {
4131                 recipient.eyes = donor.eyes;
4132             }
4133             else if (trait == RerollTrait.HeadAccessory) {
4134                 recipient.headAccessory = donor.headAccessory;
4135             }
4136             else {
4137                 revert("Invalid trait");
4138             }
4139         }
4140         // chance of burning the donor trait is a flat 1/3
4141         if (rn.generate(1, 3) == 1) {
4142             donorBurnt = true;
4143             donor.genesis = false;
4144 
4145             // background color can't be burned
4146             if (trait == RerollTrait.Outfit) {
4147                 donor.outfit = Outfit.NONE;
4148             }
4149             else if (trait == RerollTrait.HandAccessory) {
4150                 donor.handAccessory = HandAccessory.NONE;
4151             }
4152             else if (trait == RerollTrait.Mouth) {
4153                 donor.mouth = Mouth.NONE;
4154             }
4155             else if (trait == RerollTrait.Eyes) {
4156                 donor.eyes = Eyes.NONE;
4157             }
4158             else if (trait == RerollTrait.HeadAccessory) {
4159                 donor.headAccessory = HeadAccessory.NONE;
4160             }
4161         }
4162 
4163         bitMonsters.setBitMonster(donorId, donor);
4164         bitMonsters.setBitMonster(recipientId, recipient);
4165 
4166         rng = rn;
4167     }
4168 }
4169 
4170 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
4171 
4172 
4173 
4174 pragma solidity ^0.8.0;
4175 
4176 
4177 /**
4178  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
4179  * @dev See https://eips.ethereum.org/EIPS/eip-721
4180  */
4181 interface IERC721Metadata is IERC721 {
4182     /**
4183      * @dev Returns the token collection name.
4184      */
4185     function name() external view returns (string memory);
4186 
4187     /**
4188      * @dev Returns the token collection symbol.
4189      */
4190     function symbol() external view returns (string memory);
4191 
4192     /**
4193      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
4194      */
4195     function tokenURI(uint256 tokenId) external view returns (string memory);
4196 }
4197 
4198 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
4199 
4200 
4201 
4202 pragma solidity ^0.8.0;
4203 
4204 
4205 
4206 
4207 
4208 
4209 
4210 
4211 /**
4212  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
4213  * the Metadata extension, but not including the Enumerable extension, which is available separately as
4214  * {ERC721Enumerable}.
4215  */
4216 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
4217     using Address for address;
4218     using Strings for uint256;
4219 
4220     // Token name
4221     string private _name;
4222 
4223     // Token symbol
4224     string private _symbol;
4225 
4226     // Mapping from token ID to owner address
4227     mapping(uint256 => address) private _owners;
4228 
4229     // Mapping owner address to token count
4230     mapping(address => uint256) private _balances;
4231 
4232     // Mapping from token ID to approved address
4233     mapping(uint256 => address) private _tokenApprovals;
4234 
4235     // Mapping from owner to operator approvals
4236     mapping(address => mapping(address => bool)) private _operatorApprovals;
4237 
4238     /**
4239      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
4240      */
4241     constructor(string memory name_, string memory symbol_) {
4242         _name = name_;
4243         _symbol = symbol_;
4244     }
4245 
4246     /**
4247      * @dev See {IERC165-supportsInterface}.
4248      */
4249     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
4250         return
4251             interfaceId == type(IERC721).interfaceId ||
4252             interfaceId == type(IERC721Metadata).interfaceId ||
4253             super.supportsInterface(interfaceId);
4254     }
4255 
4256     /**
4257      * @dev See {IERC721-balanceOf}.
4258      */
4259     function balanceOf(address owner) public view virtual override returns (uint256) {
4260         require(owner != address(0), "ERC721: balance query for the zero address");
4261         return _balances[owner];
4262     }
4263 
4264     /**
4265      * @dev See {IERC721-ownerOf}.
4266      */
4267     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
4268         address owner = _owners[tokenId];
4269         require(owner != address(0), "ERC721: owner query for nonexistent token");
4270         return owner;
4271     }
4272 
4273     /**
4274      * @dev See {IERC721Metadata-name}.
4275      */
4276     function name() public view virtual override returns (string memory) {
4277         return _name;
4278     }
4279 
4280     /**
4281      * @dev See {IERC721Metadata-symbol}.
4282      */
4283     function symbol() public view virtual override returns (string memory) {
4284         return _symbol;
4285     }
4286 
4287     /**
4288      * @dev See {IERC721Metadata-tokenURI}.
4289      */
4290     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
4291         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
4292 
4293         string memory baseURI = _baseURI();
4294         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
4295     }
4296 
4297     /**
4298      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
4299      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
4300      * by default, can be overriden in child contracts.
4301      */
4302     function _baseURI() internal view virtual returns (string memory) {
4303         return "";
4304     }
4305 
4306     /**
4307      * @dev See {IERC721-approve}.
4308      */
4309     function approve(address to, uint256 tokenId) public virtual override {
4310         address owner = ERC721.ownerOf(tokenId);
4311         require(to != owner, "ERC721: approval to current owner");
4312 
4313         require(
4314             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
4315             "ERC721: approve caller is not owner nor approved for all"
4316         );
4317 
4318         _approve(to, tokenId);
4319     }
4320 
4321     /**
4322      * @dev See {IERC721-getApproved}.
4323      */
4324     function getApproved(uint256 tokenId) public view virtual override returns (address) {
4325         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
4326 
4327         return _tokenApprovals[tokenId];
4328     }
4329 
4330     /**
4331      * @dev See {IERC721-setApprovalForAll}.
4332      */
4333     function setApprovalForAll(address operator, bool approved) public virtual override {
4334         require(operator != _msgSender(), "ERC721: approve to caller");
4335 
4336         _operatorApprovals[_msgSender()][operator] = approved;
4337         emit ApprovalForAll(_msgSender(), operator, approved);
4338     }
4339 
4340     /**
4341      * @dev See {IERC721-isApprovedForAll}.
4342      */
4343     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
4344         return _operatorApprovals[owner][operator];
4345     }
4346 
4347     /**
4348      * @dev See {IERC721-transferFrom}.
4349      */
4350     function transferFrom(
4351         address from,
4352         address to,
4353         uint256 tokenId
4354     ) public virtual override {
4355         //solhint-disable-next-line max-line-length
4356         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
4357 
4358         _transfer(from, to, tokenId);
4359     }
4360 
4361     /**
4362      * @dev See {IERC721-safeTransferFrom}.
4363      */
4364     function safeTransferFrom(
4365         address from,
4366         address to,
4367         uint256 tokenId
4368     ) public virtual override {
4369         safeTransferFrom(from, to, tokenId, "");
4370     }
4371 
4372     /**
4373      * @dev See {IERC721-safeTransferFrom}.
4374      */
4375     function safeTransferFrom(
4376         address from,
4377         address to,
4378         uint256 tokenId,
4379         bytes memory _data
4380     ) public virtual override {
4381         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
4382         _safeTransfer(from, to, tokenId, _data);
4383     }
4384 
4385     /**
4386      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
4387      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
4388      *
4389      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
4390      *
4391      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
4392      * implement alternative mechanisms to perform token transfer, such as signature-based.
4393      *
4394      * Requirements:
4395      *
4396      * - `from` cannot be the zero address.
4397      * - `to` cannot be the zero address.
4398      * - `tokenId` token must exist and be owned by `from`.
4399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
4400      *
4401      * Emits a {Transfer} event.
4402      */
4403     function _safeTransfer(
4404         address from,
4405         address to,
4406         uint256 tokenId,
4407         bytes memory _data
4408     ) internal virtual {
4409         _transfer(from, to, tokenId);
4410         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
4411     }
4412 
4413     /**
4414      * @dev Returns whether `tokenId` exists.
4415      *
4416      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
4417      *
4418      * Tokens start existing when they are minted (`_mint`),
4419      * and stop existing when they are burned (`_burn`).
4420      */
4421     function _exists(uint256 tokenId) internal view virtual returns (bool) {
4422         return _owners[tokenId] != address(0);
4423     }
4424 
4425     /**
4426      * @dev Returns whether `spender` is allowed to manage `tokenId`.
4427      *
4428      * Requirements:
4429      *
4430      * - `tokenId` must exist.
4431      */
4432     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
4433         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
4434         address owner = ERC721.ownerOf(tokenId);
4435         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
4436     }
4437 
4438     /**
4439      * @dev Safely mints `tokenId` and transfers it to `to`.
4440      *
4441      * Requirements:
4442      *
4443      * - `tokenId` must not exist.
4444      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
4445      *
4446      * Emits a {Transfer} event.
4447      */
4448     function _safeMint(address to, uint256 tokenId) internal virtual {
4449         _safeMint(to, tokenId, "");
4450     }
4451 
4452     /**
4453      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
4454      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
4455      */
4456     function _safeMint(
4457         address to,
4458         uint256 tokenId,
4459         bytes memory _data
4460     ) internal virtual {
4461         _mint(to, tokenId);
4462         require(
4463             _checkOnERC721Received(address(0), to, tokenId, _data),
4464             "ERC721: transfer to non ERC721Receiver implementer"
4465         );
4466     }
4467 
4468     /**
4469      * @dev Mints `tokenId` and transfers it to `to`.
4470      *
4471      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
4472      *
4473      * Requirements:
4474      *
4475      * - `tokenId` must not exist.
4476      * - `to` cannot be the zero address.
4477      *
4478      * Emits a {Transfer} event.
4479      */
4480     function _mint(address to, uint256 tokenId) internal virtual {
4481         require(to != address(0), "ERC721: mint to the zero address");
4482         require(!_exists(tokenId), "ERC721: token already minted");
4483 
4484         _beforeTokenTransfer(address(0), to, tokenId);
4485 
4486         _balances[to] += 1;
4487         _owners[tokenId] = to;
4488 
4489         emit Transfer(address(0), to, tokenId);
4490     }
4491 
4492     /**
4493      * @dev Destroys `tokenId`.
4494      * The approval is cleared when the token is burned.
4495      *
4496      * Requirements:
4497      *
4498      * - `tokenId` must exist.
4499      *
4500      * Emits a {Transfer} event.
4501      */
4502     function _burn(uint256 tokenId) internal virtual {
4503         address owner = ERC721.ownerOf(tokenId);
4504 
4505         _beforeTokenTransfer(owner, address(0), tokenId);
4506 
4507         // Clear approvals
4508         _approve(address(0), tokenId);
4509 
4510         _balances[owner] -= 1;
4511         delete _owners[tokenId];
4512 
4513         emit Transfer(owner, address(0), tokenId);
4514     }
4515 
4516     /**
4517      * @dev Transfers `tokenId` from `from` to `to`.
4518      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
4519      *
4520      * Requirements:
4521      *
4522      * - `to` cannot be the zero address.
4523      * - `tokenId` token must be owned by `from`.
4524      *
4525      * Emits a {Transfer} event.
4526      */
4527     function _transfer(
4528         address from,
4529         address to,
4530         uint256 tokenId
4531     ) internal virtual {
4532         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
4533         require(to != address(0), "ERC721: transfer to the zero address");
4534 
4535         _beforeTokenTransfer(from, to, tokenId);
4536 
4537         // Clear approvals from the previous owner
4538         _approve(address(0), tokenId);
4539 
4540         _balances[from] -= 1;
4541         _balances[to] += 1;
4542         _owners[tokenId] = to;
4543 
4544         emit Transfer(from, to, tokenId);
4545     }
4546 
4547     /**
4548      * @dev Approve `to` to operate on `tokenId`
4549      *
4550      * Emits a {Approval} event.
4551      */
4552     function _approve(address to, uint256 tokenId) internal virtual {
4553         _tokenApprovals[tokenId] = to;
4554         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
4555     }
4556 
4557     /**
4558      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
4559      * The call is not executed if the target address is not a contract.
4560      *
4561      * @param from address representing the previous owner of the given token ID
4562      * @param to target address that will receive the tokens
4563      * @param tokenId uint256 ID of the token to be transferred
4564      * @param _data bytes optional data to send along with the call
4565      * @return bool whether the call correctly returned the expected magic value
4566      */
4567     function _checkOnERC721Received(
4568         address from,
4569         address to,
4570         uint256 tokenId,
4571         bytes memory _data
4572     ) private returns (bool) {
4573         if (to.isContract()) {
4574             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
4575                 return retval == IERC721Receiver.onERC721Received.selector;
4576             } catch (bytes memory reason) {
4577                 if (reason.length == 0) {
4578                     revert("ERC721: transfer to non ERC721Receiver implementer");
4579                 } else {
4580                     assembly {
4581                         revert(add(32, reason), mload(reason))
4582                     }
4583                 }
4584             }
4585         } else {
4586             return true;
4587         }
4588     }
4589 
4590     /**
4591      * @dev Hook that is called before any token transfer. This includes minting
4592      * and burning.
4593      *
4594      * Calling conditions:
4595      *
4596      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
4597      * transferred to `to`.
4598      * - When `from` is zero, `tokenId` will be minted for `to`.
4599      * - When `to` is zero, ``from``'s `tokenId` will be burned.
4600      * - `from` and `to` are never both zero.
4601      *
4602      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
4603      */
4604     function _beforeTokenTransfer(
4605         address from,
4606         address to,
4607         uint256 tokenId
4608     ) internal virtual {}
4609 }
4610 
4611 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
4612 
4613 
4614 
4615 pragma solidity ^0.8.0;
4616 
4617 
4618 
4619 /**
4620  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
4621  * enumerability of all the token ids in the contract as well as all token ids owned by each
4622  * account.
4623  */
4624 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
4625     // Mapping from owner to list of owned token IDs
4626     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
4627 
4628     // Mapping from token ID to index of the owner tokens list
4629     mapping(uint256 => uint256) private _ownedTokensIndex;
4630 
4631     // Array with all token ids, used for enumeration
4632     uint256[] private _allTokens;
4633 
4634     // Mapping from token id to position in the allTokens array
4635     mapping(uint256 => uint256) private _allTokensIndex;
4636 
4637     /**
4638      * @dev See {IERC165-supportsInterface}.
4639      */
4640     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
4641         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
4642     }
4643 
4644     /**
4645      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
4646      */
4647     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
4648         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
4649         return _ownedTokens[owner][index];
4650     }
4651 
4652     /**
4653      * @dev See {IERC721Enumerable-totalSupply}.
4654      */
4655     function totalSupply() public view virtual override returns (uint256) {
4656         return _allTokens.length;
4657     }
4658 
4659     /**
4660      * @dev See {IERC721Enumerable-tokenByIndex}.
4661      */
4662     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
4663         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
4664         return _allTokens[index];
4665     }
4666 
4667     /**
4668      * @dev Hook that is called before any token transfer. This includes minting
4669      * and burning.
4670      *
4671      * Calling conditions:
4672      *
4673      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
4674      * transferred to `to`.
4675      * - When `from` is zero, `tokenId` will be minted for `to`.
4676      * - When `to` is zero, ``from``'s `tokenId` will be burned.
4677      * - `from` cannot be the zero address.
4678      * - `to` cannot be the zero address.
4679      *
4680      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
4681      */
4682     function _beforeTokenTransfer(
4683         address from,
4684         address to,
4685         uint256 tokenId
4686     ) internal virtual override {
4687         super._beforeTokenTransfer(from, to, tokenId);
4688 
4689         if (from == address(0)) {
4690             _addTokenToAllTokensEnumeration(tokenId);
4691         } else if (from != to) {
4692             _removeTokenFromOwnerEnumeration(from, tokenId);
4693         }
4694         if (to == address(0)) {
4695             _removeTokenFromAllTokensEnumeration(tokenId);
4696         } else if (to != from) {
4697             _addTokenToOwnerEnumeration(to, tokenId);
4698         }
4699     }
4700 
4701     /**
4702      * @dev Private function to add a token to this extension's ownership-tracking data structures.
4703      * @param to address representing the new owner of the given token ID
4704      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
4705      */
4706     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
4707         uint256 length = ERC721.balanceOf(to);
4708         _ownedTokens[to][length] = tokenId;
4709         _ownedTokensIndex[tokenId] = length;
4710     }
4711 
4712     /**
4713      * @dev Private function to add a token to this extension's token tracking data structures.
4714      * @param tokenId uint256 ID of the token to be added to the tokens list
4715      */
4716     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
4717         _allTokensIndex[tokenId] = _allTokens.length;
4718         _allTokens.push(tokenId);
4719     }
4720 
4721     /**
4722      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
4723      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
4724      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
4725      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
4726      * @param from address representing the previous owner of the given token ID
4727      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
4728      */
4729     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
4730         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
4731         // then delete the last slot (swap and pop).
4732 
4733         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
4734         uint256 tokenIndex = _ownedTokensIndex[tokenId];
4735 
4736         // When the token to delete is the last token, the swap operation is unnecessary
4737         if (tokenIndex != lastTokenIndex) {
4738             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
4739 
4740             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
4741             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
4742         }
4743 
4744         // This also deletes the contents at the last position of the array
4745         delete _ownedTokensIndex[tokenId];
4746         delete _ownedTokens[from][lastTokenIndex];
4747     }
4748 
4749     /**
4750      * @dev Private function to remove a token from this extension's token tracking data structures.
4751      * This has O(1) time complexity, but alters the order of the _allTokens array.
4752      * @param tokenId uint256 ID of the token to be removed from the tokens list
4753      */
4754     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
4755         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
4756         // then delete the last slot (swap and pop).
4757 
4758         uint256 lastTokenIndex = _allTokens.length - 1;
4759         uint256 tokenIndex = _allTokensIndex[tokenId];
4760 
4761         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
4762         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
4763         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
4764         uint256 lastTokenId = _allTokens[lastTokenIndex];
4765 
4766         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
4767         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
4768 
4769         // This also deletes the contents at the last position of the array
4770         delete _allTokensIndex[tokenId];
4771         _allTokens.pop();
4772     }
4773 }
4774 
4775 // File: contracts/BitMonsters.sol
4776 
4777 
4778 pragma solidity ^0.8.0;
4779 
4780 
4781 
4782 
4783 
4784 
4785 
4786 
4787 
4788 
4789 
4790 /**
4791  * @title The Bit Monsters contract. This is where all of the magic happens.
4792  */
4793 contract BitMonsters is IBitMonsters, ERC721Enumerable, Ownable {
4794     uint256 constant public SUPPLY_LIMIT = 6666;
4795     using RngLibrary for Rng;
4796 
4797     mapping (uint256 => BitMonster) public tokenIdToBitMonster;
4798 
4799     Brainz public brainz;
4800     Mutator public mutator;
4801     Minter public minter;
4802     Metadata public metadata;
4803     mapping (address => bool) private admins;
4804 
4805     bool private initialized;
4806 
4807     /**
4808      * @param whitelistedAddrs The addresses that are allowed to mint when the mintingState is WhiteListOnly.
4809                                The owner of the contract is automatically whitelisted, so the owning address doesn't need to be given.
4810      */
4811     constructor(address[] memory whitelistedAddrs) ERC721("Bit Monsters", unicode"💰🧟") {
4812         brainz = new Brainz();
4813         mutator = new Mutator(brainz);
4814         minter = new Minter(payable(msg.sender), whitelistedAddrs);
4815         metadata = new Metadata();
4816         address[5] memory a = [msg.sender, address(brainz), address(mutator), address(minter), address(metadata)];
4817         for (uint i = 0; i < a.length; ++i) {
4818             admins[a[i]] = true;
4819         }
4820     }
4821 
4822     function isAdmin(address addr) public view override returns (bool) {
4823         return owner() == addr || admins[addr];
4824     }
4825 
4826     modifier onlyAdmin() {
4827         require(isAdmin(msg.sender), "admins only");
4828         _;
4829     }
4830 
4831     function addAdmin(address addr) external onlyAdmin {
4832         admins[addr] = true;
4833     }
4834 
4835     function removeAdmin(address addr) external onlyAdmin {
4836         admins[addr] = false;
4837     }
4838 
4839     /**
4840      * Initializes the sub contracts so they're ready for use.
4841      * @notice IMPORTANT: This must be called before any other contract functions.
4842      *
4843      * @dev This can't be done in the constructor, because the contract doesn't have an address until the transaction is mined.
4844      */
4845     function initialize() external onlyAdmin {
4846         if (initialized) {
4847             return;
4848         }
4849         initialized = true;
4850 
4851         admins[address(this)] = true;
4852         brainz.setBitMonstersContract(this);
4853         metadata.setBitMonstersContract(this);
4854         mutator.setBitMonstersContract(this);
4855         minter.setBitMonstersContract(this);
4856     }
4857 
4858     /**
4859      * Returns the metadata of the Bit Monster corresponding to the given tokenId as a base64-encoded JSON object. Meant for use with OpenSea.
4860      *
4861      * @dev This function can take a painful amount of time to run, sometimes exceeding 9 minutes in length. Use getBitMonster() instead for frontends.
4862      */
4863     function tokenURI(uint256 tokenId) public view override returns (string memory) {
4864         require(_exists(tokenId), "the token doesn't exist");
4865 
4866         string memory metadataRaw = metadata.getMetadataJson(tokenId);
4867         string memory metadataB64 = Base64.encode(bytes(metadataRaw));
4868 
4869         return string(abi.encodePacked(
4870             "data:application/json;base64,",
4871             metadataB64
4872         ));
4873     }
4874 
4875     /**
4876      * Returns the internal representation of the Bit Monster corresponding to the given tokenId.
4877      */
4878     function getBitMonster(uint256 tokenId) external view override returns (BitMonster memory) {
4879         return tokenIdToBitMonster[tokenId];
4880     }
4881 
4882     function setBitMonster(uint256 tokenId, BitMonster memory bm) public override onlyAdmin {
4883         tokenIdToBitMonster[tokenId] = bm;
4884     }
4885 
4886     function createBitMonster(BitMonster memory bm, address owner) external override onlyAdmin {
4887         uint total = totalSupply();
4888         require(total <= SUPPLY_LIMIT, "Supply limit reached");
4889 
4890         uint tid = total + 1;
4891         _mint(owner, tid);
4892         setBitMonster(tid, bm);
4893 
4894         brainz.register(tid);
4895     }
4896 }