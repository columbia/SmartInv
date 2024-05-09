1 pragma solidity ^0.8.0;
2 
3 library LOOKLib {
4 
5     function textures() public pure returns (string[64] memory) {
6         return
7         [
8         "Silky",
9         "Velvety",
10         "Slimy",
11         "Sharp",
12         "Latex",
13         "Wool",
14         "Scaly",
15         "Coarse",
16         "Sandy",
17         "Rocky",
18         "Bumpy",
19         "Slippery",
20         "Fuzzy",
21         "Synthetic",
22         "Rough",
23         "Fizzy",
24         "Sticky",
25         "Slick",
26         "Popcorn",
27         "Cotton Candy",
28         "Slap Brush",
29         "Feathery",
30         "Prickly",
31         "Crows Feet",
32         "Smooth",
33         "Cloudy",
34         "Misty",
35         "Bristly",
36         "Solid",
37         "Liquid",
38         "Foamy",
39         "Spongey",
40         "Gelatinous",
41         "Crumbly",
42         "Spiked",
43         "Crackled",
44         "Barbed",
45         "Crusty",
46         "Powdery",
47         "Leathery",
48         "Squishy",
49         "Wrinkly",
50         "Reflective",
51         "Glittery",
52         "Felt",
53         "Puffy",
54         "Fleece",
55         "Polymer",
56         "Ceramic",
57         "Chiffon",
58         "Plastic",
59         "Glass",
60         "Lumpy",
61         "Cotton",
62         "Denim",
63         "Lace",
64         "Double Knit",
65         "Knit",
66         "Lace",
67         "Mesh",
68         "Nylon",
69         "Satin",
70         "Tactel",
71         "Wool"
72         ];
73 
74     }
75 
76     function flares() public pure returns (string[45] memory) {
77         return
78         [
79         "Empty Wine Bottle",
80         "Copper Dragon",
81         "Sugary Cereal",
82         "White Dragon",
83         "Rainbow Serpent",
84         "Paradise A Burn",
85         "Asteroid En Route",
86         "Neptune Sword",
87         "Jupiter Honey",
88         "Cosmic Heat",
89         "Indie Luna",
90         "Flashbulb Camera",
91         "Category Four Hurricane",
92         "Blood Mustang",
93         "Candle in the Wind",
94         "Diamond Wave",
95         "All Powerful Trident",
96         "Multifaceted Buzz",
97         "1964 California Spyder",
98         "Millions of Polka Dots",
99         "Interstellar Mass",
100         "Endless Galaxies",
101         "A 1999 Video Game",
102         "Glimmering Swimming Pool",
103         "Black Cristal",
104         "Zero Gravity",
105         "Coney Island",
106         "Aerodynamic Steering Wheel",
107         "National Turbulence",
108         "Heavy Metal Hour",
109         "Seagull\xE2\x80\x99s Circling",
110         "Mermaid Motel",
111         "Self Loathing Poet",
112         "Canyon\xE2\x80\x99s Infinite Abyss",
113         "Diet Mountain Dew",
114         "Harem Silks From Bombay",
115         "Rolling Party Ashes",
116         "Gate of the Gargoyles",
117         "Bel Air Palm Trees",
118         "Rare Jazz Collection",
119         "Hydroponic Weed",
120         "Spicy Caviar",
121         "Brooklyn Cola Bottle",
122         "Wabi Sabi",
123         "Summer Apartment Complex"
124         ];
125     }
126 
127     function colours() public pure returns (string[54] memory) {
128         return [
129         "Crow Black",
130         "Raven Black",
131         "Jet Black",
132         "Black as Night",
133         "Black as Ink",
134         "Milky White",
135         "Pearl White",
136         "Sugar White",
137         "Eggshell White",
138         "Scarlet",
139         "Crimson",
140         "Ruby Red",
141         "Cranberry",
142         "Aqua",
143         "Navy",
144         "Turquoise",
145         "Teal",
146         "Aquamarine",
147         "Golden Oak",
148         "Sapphire Blue",
149         "Glacial Blue",
150         "Lemon Yellow",
151         "Butter Yellow",
152         "Military Green",
153         "Sunshine Yellow",
154         "Golden Blue",
155         "Silver Red",
156         "Silver Purple",
157         "Golden Purple",
158         "Golden Green",
159         "Golden Orange",
160         "Silver Teal",
161         "Jade",
162         "Lime Green",
163         "Bottle Green",
164         "Flamingo Pink",
165         "Shell Pink",
166         "Violet",
167         "Pansy Purple",
168         "Pumpkin Orange",
169         "Sunset Orange",
170         "Tiger Lily Orange",
171         "Mocha Brown",
172         "Coffee Brown",
173         "Bronze Green",
174         "Cinnamon Yellow",
175         "Caramel Orange",
176         "Burnt Red",
177         "Caramel Yellow",
178         "Hazel Gray",
179         "Charcoal Gray",
180         "Mellow Yellow",
181         "Smoke Gray",
182         "Cocoa Brown"
183         ];
184     }
185 
186     function backgroundColours() public pure returns (string[30] memory) {
187         return [
188         "FF0294",
189         "02FF6A",
190         "EE740D",
191         "EE0D0D",
192         "00C0D0",
193         "0056F6",
194         "C600F6",
195         "F60091",
196         "CA215C",
197         "DA9708",
198         "5EDA08",
199         "DA801A",
200         "771ADA",
201         "1A6EDA",
202         "1AC6DA",
203         "18B144",
204         "7E18B1",
205         "A533DE",
206         "A8DE33",
207         "D9DE33",
208         "DE7C33",
209         "E36100",
210         "E300BA",
211         "731F64",
212         "66D83F",
213         "3FB5D8",
214         "000000",
215         "3B289B",
216         "9B285E",
217         "3ACFA4"
218         ];
219     }
220 
221     function lines() public pure returns (string[33] memory) {
222         return [
223         "Angular",
224         "Fringe",
225         "Quiff",
226         "Chemise",
227         "Bretelles",
228         "Embroidery",
229         "Drop Waist",
230         "Peplum",
231         "Bowl Cut",
232         "Jagged",
233         "Princess Line",
234         "Yolk Line",
235         "Crossover Line",
236         "Hand Stitch",
237         "Lock Stitch",
238         "Gimp",
239         "Multi-Thread Stitch",
240         "Over Edge Stitch",
241         "Blanket Stitch",
242         "Running Stitch",
243         "Satin Stitch",
244         "French Knot Stitch",
245         "Lazy Daisy Stitch",
246         "Herringbone Stitch",
247         "Seed Stitch",
248         "Bullion Knot",
249         "Buttonhole Stitch",
250         "Shell Tuck Stitch",
251         "Square Knot",
252         "Water Knot",
253         "Rolling Hitch",
254         "Blood Knot",
255         "Tripod Lashing"
256         ];
257     }
258 
259     function shapes() public pure returns (string[39] memory) {
260         return [
261         "Spiral",
262         "Maxi",
263         "Empire",
264         "Asymmetrical",
265         "A-line",
266         "Hourglass",
267         "Bell",
268         "Mermaid",
269         "Trumpet",
270         "Squiggle",
271         "Ruffle",
272         "Lemniscate",
273         "Mobius Strip",
274         "Squircle",
275         "Heptagram",
276         "Butterfly Curve",
277         "Inverted Bell",
278         "Golden Ratio",
279         "Cos",
280         "Sine",
281         "S Curve",
282         "Deltoid",
283         "Cassini Oval",
284         "Spline",
285         "B\xC3\xA9zier Triangle",
286         "Roulette",
287         "Cone",
288         "Torus",
289         "Honeycomb",
290         "Star",
291         "Broken",
292         "Obtuse",
293         "Straight",
294         "Wavy",
295         "Diagonal",
296         "Prism",
297         "Ring",
298         "ZigZag",
299         "Mangled"
300         ];
301     }
302 
303     function forms() public pure returns (string[23] memory) {
304         return [
305         "Antifragile",
306         "Fragile",
307         "Shifting",
308         "Temporal",
309         "Terrestrial",
310         "Ephemeral",
311         "Transient",
312         "Intense",
313         "Flimsy",
314         "Reliable",
315         "Fading",
316         "Bright",
317         "Repaired",
318         "Renewed",
319         "Over Extended",
320         "Retracted",
321         "Halted",
322         "Short Form",
323         "Long Form",
324         "Kintsugi",
325         "Downforce",
326         "Melting",
327         "Quenched"
328         ];
329     }
330 
331     function elements() public pure returns (string[113] memory) {
332         return [
333         "Hydrogen",
334         "Helium",
335         "Lithium",
336         "Beryllium",
337         "Boron",
338         "Carbon",
339         "Nitrogen",
340         "Oxygen",
341         "Fluorine",
342         "Neon",
343         "Sodium",
344         "Magnesium",
345         "Aluminum",
346         "Silicon",
347         "Phosphorus",
348         "Sulfur",
349         "Chlorine",
350         "Argon",
351         "Potassium",
352         "Calcium",
353         "Scandium",
354         "Titanium",
355         "Vanadium",
356         "Chromium",
357         "Manganese",
358         "Iron",
359         "Cobalt",
360         "Nickel",
361         "Copper",
362         "Zinc",
363         "Gallium",
364         "Germanium",
365         "Arsenic",
366         "Selenium",
367         "Bromine",
368         "Krypton",
369         "Rubidium",
370         "Strontium",
371         "Yttrium",
372         "Zirconium",
373         "Niobium",
374         "Molybdenum",
375         "Technetium",
376         "Ruthenium",
377         "Rhodium",
378         "Palladium",
379         "Silver",
380         "Cadmium",
381         "Indium",
382         "Tin",
383         "Antimony",
384         "Tellurium",
385         "Iodine",
386         "Xenon",
387         "Cesium",
388         "Barium",
389         "Lanthanum",
390         "Cerium",
391         "Praseodymium",
392         "Neodymium",
393         "Promethium",
394         "Samarium",
395         "Europium",
396         "Gadolinium",
397         "Terbium",
398         "Dysprosium",
399         "Holmium",
400         "Erbium",
401         "Thulium",
402         "Ytterbium",
403         "Lutetium",
404         "Hafnium",
405         "Tantalum",
406         "Tungsten",
407         "Rhenium",
408         "Osmium",
409         "Iridium",
410         "Platinum",
411         "Gold",
412         "Mercury",
413         "Thallium",
414         "Lead",
415         "Bismuth",
416         "Polonium",
417         "Astatine",
418         "Radon",
419         "Francium",
420         "Radium",
421         "Actinium",
422         "Thorium",
423         "Protactinium",
424         "Uranium",
425         "Neptunium",
426         "Plutonium",
427         "Americium",
428         "Curium",
429         "Berkelium",
430         "Californium",
431         "Einsteinium",
432         "Fermium",
433         "Mendelevium",
434         "Nobelium",
435         "Lawrencium",
436         "Rutherfordium",
437         "Dubnium",
438         "Seaborgium",
439         "Bohrium",
440         "Hassium",
441         "Meitnerium",
442         "Darmstadtium",
443         "Roentgenium",
444         "Ununbiium",
445         "Ununquadium"
446         ];
447     }
448 }
449 
450 library LOOKLogic {
451     function prefixCommon() public pure returns (string[15] memory) {
452         return [
453         "Angel\xE2\x80\x99s",
454         "Chimera\xE2\x80\x99s",
455         "Demon\xE2\x80\x99s",
456         "Dragon\xE2\x80\x99s",
457         "Hydra\xE2\x80\x99s",
458         "Aphrodite\xE2\x80\x99s",
459         "Goblin",
460         "Muses\xE2\x80\x99",
461         "Phoenix\xE2\x80\x99s",
462         "Pixie",
463         "Trolls\xE2\x80\x99",
464         "Vampire",
465         "Amaterasu\xE2\x80\x99s",
466         "Inari\xE2\x80\x99s",
467         "Ebisu\xE2\x80\x99s"
468         ];
469     }
470 
471     function prefixSemirare() public pure returns (string[24] memory) {
472         return [
473         "Izanagi\xE2\x80\x99s",
474         "Osiris\xE2\x80\x99s",
475         "Horus\xE2\x80\x99",
476         "Anubis\xE2\x80\x99s",
477         "Zeus\xE2\x80\x99s",
478         "Artemis\xE2\x80\x99s",
479         "Apollo\xE2\x80\x99s",
480         "Athena\xE2\x80\x99s",
481         "Venus\xE2\x80\x99s",
482         "Poseidon\xE2\x80\x99s",
483         "Winter\xE2\x80\x99s",
484         "Summer\xE2\x80\x99s",
485         "Autumn\xE2\x80\x99s",
486         "Eclectic\xE2\x80\x99s",
487         "Pluto\xE2\x80\x99s",
488         "Solar\xE2\x80\x99s",
489         "King\xE2\x80\x99s",
490         "Queen\xE2\x80\x99s",
491         "Prince\xE2\x80\x99s",
492         "Princess\xE2\x80\x99s",
493         "Elve\xE2\x80\x99s",
494         "Fairies\xE2\x80\x99",
495         "Firebird\xE2\x80\x99s",
496         "Cupid\xE2\x80\x99s"
497         ];
498     }
499 
500     function prefixExclusive() public pure returns (string[27] memory) {
501         return [
502         "Edgy",
503         "Magical",
504         "Charming",
505         "Ambitious",
506         "Bold",
507         "Brave",
508         "Daring",
509         "Bright",
510         "Audacious",
511         "Courageous",
512         "Fearless",
513         "Pawned",
514         "Dashing",
515         "Dapper",
516         "Gallant",
517         "Funky",
518         "Sophisticated",
519         "Graceful",
520         "Voguish",
521         "Majestic",
522         "Enchanting",
523         "Elegant",
524         "Saucy",
525         "Sassy",
526         "Roaring",
527         "Vintage",
528         "Honest"
529         ];
530     }
531 
532     function pickSuffixCategories(uint256 rand, uint256 tokenId) public pure returns (uint256[6] memory categoryIds){
533         // Need to draw for the category that will be randomnly selected
534         uint256 randCategory = random(string(abi.encodePacked("SuffixCategory", toString(rand))));
535         uint256 selection = (randCategory + tokenId ) % 7; // Pick one suffix to omit
536 
537         uint256 counter = 0;
538         // First add category ids in but omit one suffix category
539         for(uint256 i = 0; i< 7; i++){
540             if(i == selection){
541                 continue;
542             }
543             categoryIds[counter] = i;
544             counter = counter + 1;
545         }
546 
547         // Then remix these ids and get with rarity as well
548         for( uint256 j = 0; j < 6; j++){
549             // Just make some rarity
550 
551             uint256 randRarity = random(string(abi.encodePacked("SuffixRarity", toString(tokenId))));
552             uint256 finalRarityResult = randRarity % 21;
553             uint256 rarity = 0;
554             if (finalRarityResult > 14){
555                 rarity = 1;
556             }
557             if (finalRarityResult > 19){
558                 rarity = 2;
559             }
560             categoryIds[j] = rarity + (categoryIds[j] * 3); // Suffix arrays -> 0,1,2 then 3,4,5 then 6,7,8 etc
561         }
562 
563         // Now that we have selected categories, now we need to randomize the order more
564         // Fisher Yates type Shuffle
565         // Shuffle 10 times
566         for(uint256 k= 1; k < 10; k++){
567             for (uint256 i = 5; i == 0; i--) {
568                 // This next line is just a random code to try and get some shuffling in
569                 uint256 randomSelect = ((random(string(abi.encodePacked("FisherYates", rand))) * random(string(abi.encodePacked("RandomString"))) / random (string(abi.encodePacked(toString(tokenId))))) + (tokenId + (tokenId * k) * 234983)) % 6;
570                 uint256 x = categoryIds[i];
571                 categoryIds[i] = categoryIds[randomSelect];
572                 categoryIds[randomSelect] = x;
573             }
574         }
575 
576         return categoryIds;
577     }
578 
579     function pickPrefix(uint256 rand, uint256 tokenId) public pure returns (string memory prefix1, string memory prefix2){
580         // Need to draw for
581         uint256 randRarity1Full = random(string(abi.encodePacked("PrefixRarityOne", toString(rand)))) + tokenId;
582         uint256 randRarity2Full = random(string(abi.encodePacked("PrefixRarityTwo", toString(rand)))) + tokenId + 1;
583         uint256 randRarity3Full = random(string(abi.encodePacked("PrefixRarityThree3", toString(rand)))) + tokenId + 2;
584 
585         uint256 randRarity1 = randRarity1Full % 21;
586         uint256 randRarity2 = randRarity2Full % 21;
587         uint256 randRarity3 = randRarity3Full % 21;
588 
589         prefix1 = prefixCommon()[randRarity1Full % prefixCommon().length];
590         if (randRarity1 > 15){
591             prefix1 = prefixSemirare()[randRarity1Full % prefixSemirare().length];
592         }
593         if(randRarity1 > 19){
594             prefix1 = prefixExclusive()[randRarity1Full % prefixExclusive().length];
595         }
596 
597         prefix2 = prefixCommon()[randRarity2Full % prefixCommon().length];
598         if (randRarity2 > 15){
599             prefix2 = prefixSemirare()[randRarity2Full % prefixSemirare().length];
600         }
601         if(randRarity2 > 19){
602             prefix2 = prefixExclusive()[randRarity2Full % prefixExclusive().length];
603         }
604 
605         if(keccak256(bytes(prefix1)) == keccak256(bytes(prefix2))){
606             // Redraw once to try and prevent duplicates
607             prefix2 = prefixCommon()[randRarity3Full % prefixCommon().length];
608             if (randRarity3 > 15){
609                 prefix2 = prefixSemirare()[randRarity3Full % prefixSemirare().length];
610                 if(randRarity3 > 19)
611                     prefix2 = prefixExclusive()[randRarity3Full % prefixExclusive().length];
612             }
613         }
614         return (prefix1, prefix2);
615     }
616 
617     function random(string memory input) public pure returns (uint256) {
618         return uint256(keccak256(abi.encodePacked(input)));
619     }
620 
621 
622     function toString(uint256 value) public pure returns (string memory) {
623         // Inspired by OraclizeAPI's implementation - MIT license
624         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
625 
626         if (value == 0) {
627             return "0";
628         }
629         uint256 temp = value;
630         uint256 digits;
631         while (temp != 0) {
632             digits++;
633             temp /= 10;
634         }
635         bytes memory buffer = new bytes(digits);
636         while (value != 0) {
637             digits -= 1;
638             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
639             value /= 10;
640         }
641         return string(buffer);
642     }
643 
644 
645 }
646 
647 library LOOKSuffix{
648     function socksSuffixCommon() public pure returns (string[3] memory) {
649             return [
650                 "Casual Socks",
651                  "Sport Socks",
652                 "Grip Socks"
653             ];
654     }
655 
656     function socksSuffixSemirare() public pure returns (string[3] memory) {
657             return [
658                 "Winter Socks",
659                 "Crew Length Socks",
660                 "Split Toe Socks"
661             ];
662     }
663 
664     function socksSuffixExclusive() public pure returns (string[3] memory) {
665             return  [
666                 "Dress Socks",
667                 "Novelty Print Socks",
668                 "Knee High Socks"
669             ];
670     }
671 
672     function sunglassSuffixCommon() public pure returns (string[4] memory) {
673             return [
674                 "Round Sunglasses",
675                 "Square Sunglasses",
676                 "Semi-Rimless Sunglasses",
677                 "Browline Sunglasses"
678             ];
679     }
680 
681     function sunglassSuffixSemirare() public pure returns (string[4] memory) {
682             return [
683                 "Keyhole Sunglasses",
684                 "Brow Bar Sunglasses",
685                 "Wayfarer Sunglasses",
686                 "Club Master Sunglasses"
687             ];
688     }
689 
690     function sunglassSuffixExclusive() public pure returns (string[4] memory) {
691             return [
692                 "Cat Eye Sunglasses",
693                 "Aviator Sunglasses",
694                 "Retro Square Sunglasses",
695                 "3D Glasses"
696             ];
697     }
698 
699     function shoeSuffixCommon() public pure returns (string[8] memory) {
700             return [
701                 "Sandals",
702                 "High Top Sneakers",
703                 "Wedge Sneakers",
704                 "Gladiators",
705                 "Gum Shoes",
706                 "Army Boots",
707                 "Mary Jane Shoes",
708                 "Combat Boots"
709             ];
710     }
711 
712     function shoeSuffixSemirare() public pure returns (string[9] memory) {
713             return [
714                 "Stiletto",
715                 "Platforms",
716                 "Slip Ons",
717                 "Peep Toe",
718                 "Ankle Strap",
719                 "Flats",
720                 "Ballerina Slippers",
721                 "Hiking Boots",
722                 "Buck Shoes"
723             ];
724     }
725 
726     function shoeSuffixExclusive() public pure returns (string[7] memory) {
727             return [
728                 "Loafers",
729                 "Boat Shoes",
730                 "Brogue Shoes",
731                 "Snow Boots",
732                 "High Boots",
733                 "Oxfords",
734                 "Ankle Boots"
735             ];
736     }
737 
738     function accessorySuffixCommon() public pure returns (string[18] memory) {
739             return [
740                 "Clip-on Earrings",
741                 "Jacket Earrings",
742                 "Festoon",
743                 "Negligee",
744                 "Cartilage Earrings",
745                 "Snap Belt",
746                 "Reversible Belt",
747                 "Athletic Belt",
748                 "Apron Necktie",
749                 "Ascot Tie",
750                 "Clip-on Tie",
751                 "Bolo/Bola Tie",
752                 "Cravat Necktie",
753                 "Sailor Tie",
754                 "String Tie",
755                 "Ribbon Sash",
756                 "Bullet Back Cufflink",
757                 "Whale Back Cufflink"
758             ];
759     }
760 
761     function accessorySuffixSemirare() public pure returns (string[17] memory) {
762             return [
763                 "Mismatched Earrings",
764                 "Drop Earrings",
765                 "Teardrop Earrings",
766                 "Tassel Earrings",
767                 "Military Belt",
768                 "Leather Belt",
769                 "Metallic Belt",
770                 "Woven Belt",
771                 "Wide Belt",
772                 "Elastic Belt",
773                 "Sash Belt",
774                 "Corset Belt",
775                 "Studded Belt",
776                 "Cutout Gloves",
777                 "Cutout Mittens",
778                 "Fixed Back Cufflink",
779                 "Chain Link Cufflink"
780             ];
781     }
782 
783     function accessorySuffixExclusive() public pure returns (string[29] memory) {
784             return [
785                 "Zipper Gloves",
786                 "Fine Textured Mittens",
787                 "Fur Lined Mittens",
788                 "Evening Gloves",
789                 "Gauntlet Gloves",
790                 "Lace Gloves",
791                 "Lace Mittens",
792                 "Ball Return Cufflink",
793                 "Locking Cufflink",
794                 "Knotted Cufflink",
795                 "Faux Leather",
796                 "Dress Belt",
797                 "Casual Belt",
798                 "Braided Belt",
799                 "7-Fold Tie",
800                 "Bowtie",
801                 "Kipper Tie",
802                 "Skinny Tie",
803                 "Western Bow-Tie",
804                 "Diamond Stud Earrings",
805                 "Pearl Earrings",
806                 "Hoop Earrings",
807                 "Chandelier Earrings",
808                 "Ear Cuff Earrings",
809                 "Ball Earrings",
810                 "Streamlined Hoops",
811                 "Pendant Necklace",
812                 "Collar Necklace",
813                 "Multi-Charmed Bracelet"
814             ];
815     }
816 
817     function swimmerSuffixCommon() public pure returns (string[3] memory) {
818             return [
819                 "Front Tie Bikini Top",
820                 "Tori Bandeau Bikini Top",
821                 "Swim Briefs"
822             ];
823     }
824 
825     function swimmerSuffixSemirare() public pure returns (string[3] memory) {
826             return [
827                 "Square Cut Board Shorts",
828                 "Crinkle Frill Bottom",
829                 "Terracotta One Piece"
830             ];
831     }
832 
833     function swimmerSuffixExclusive() public pure returns (string[4] memory) {
834             return [
835                 "Mesh Rhinestone Swimwear",
836                 "Knotted-Front Swim Crop Top",
837                 "Mesh Bikini Top",
838                 "Steamer Wetsuit"
839             ];
840     }
841 
842     function outfitSuffixCommon() public pure returns (string[24] memory) {
843             return [
844                 "Aline Dress",
845                 "Tent Dress",
846                 "Yoke Dress",
847                 "Shift Dress",
848                 "Dirndl Dress",
849                 "Tunic Dress",
850                 "Blouson Dress",
851                 "Shirtwaist Dress",
852                 "Wrap around Dress",
853                 "Baby doll Dress",
854                 "Body con Dress",
855                 "Cocktail Dress",
856                 "Debutante Dress",
857                 "Skater Dress",
858                 "Camisole Dress",
859                 "Pinafore Dress",
860                 "Harem Dress",
861                 "Apron Dress",
862                 "Patch Pocket Suit",
863                 "Flap Pocket Suit",
864                 "Jetted Pocket Suit",
865                 "Basic Overalls",
866                 "Old Fashioned Overalls",
867                 "Casual Overalls"
868             ];
869     }
870 
871     function outfitSuffixSemirare() public pure returns (string[24] memory) {
872             return [
873                 "Sweater Dress",
874                 "Swing Dress",
875                 "Tutu Dress",
876                 "Sun Dress",
877                 "Little Black Dress",
878                 "Coat Dress",
879                 "Corset Dress",
880                 "Balloon Dress",
881                 "Bouffant Dress",
882                 "Paneled Dress",
883                 "Handkerchief Hem Dress",
884                 "Gathered Dress",
885                 "Kaftan Dress",
886                 "Pillowcase Dress",
887                 "Slip Dress",
888                 "Shirt Dress",
889                 "Ball Gown",
890                 "Party Dress",
891                 "Single Vent Suit",
892                 "Double Vent Suit",
893                 "No Vent Suit",
894                 "One-Button Suit",
895                 "Two-Button Suit",
896                 "Three-Button Suit"
897             ];
898     }
899 
900     function outfitSuffixExclusive() public pure returns (string[21] memory) {
901             return [
902                 "Off Shoulder Dress",
903                 "One Shoulder Dress",
904                 "Strapless Dress",
905                 "Halterneck Dress",
906                 "Draped Dress",
907                 "Xray Dress",
908                 "Fit and Flare Dress",
909                 "Cape Dress",
910                 "Sheath Dress",
911                 "Slim Fit Suit",
912                 "Classic Fit Suit",
913                 "Modern Fit Suit",
914                 "Notch Lapel Suit",
915                 "Shawl Lapel Suit",
916                 "Peak Lapel Suit",
917                 "Single Breasted Suit",
918                 "Double Breasted Suit",
919                 "American Cut Suit",
920                 "British Cut Suit",
921                 "Italian Cut Suit",
922                 "Tuxedo"
923             ];
924     }
925 
926     function topBottomSuffixCommon() public pure returns (string[19] memory) {
927             return [
928                 "Jersey shirt",
929                 "Night Shirt",
930                 "Western shirt",
931                 "Polo shirts",
932                 "Sweatshirt",
933                 "T-shirt",
934                 "Tunic shirt",
935                 "Tuxedo shirt",
936                 "Undershirt",
937                 "Chinos",
938                 "Cords",
939                 "Drawstring Trousers",
940                 "Slim-Fit Trousers",
941                 "Wool Trousers",
942                 "Relaxed Leg Trousers",
943                 "Cropped Trousers",
944                 "Cargo Pants",
945                 "Pleated Trousers",
946                 "Tracksuit Bottoms"
947             ];
948     }
949 
950     function topBottomSuffixSemirare() public pure returns (string[19] memory) {
951             return [
952                 "Aloha Shirt",
953                 "Baseball Shirt",
954                 "Camp Shirt",
955                 "Casual Shirt",
956                 "Epaulette Shirt",
957                 "Flannel Shirt",
958                 "Lumberjack Shirt",
959                 "Golf Shirt",
960                 "Henley Shirt",
961                 "Ivy league Shirt",
962                 "Leggings",
963                 "Palazzo",
964                 "Pegged Pants",
965                 "Trousers",
966                 "Sailor Pants",
967                 "Straight Pants",
968                 "Stirrup Pants",
969                 "Stove Pipe Pants",
970                 "Toreador Pants"
971             ];
972     }
973 
974     function topBottomSuffixExclusive() public pure returns (string[19] memory) {
975             return [
976                 "Baggy Pants",
977                 "Culottes",
978                 "Fatigue Trousers",
979                 "Jeans",
980                 "Harem Pants",
981                 "Hot Pants",
982                 "Jodhpurs",
983                 "Oxford Button-Down Shirt",
984                 "Dress Shirt",
985                 "Cuban Collar Shirt",
986                 "Overshirt",
987                 "Flannel Shirt",
988                 "Office Shirt",
989                 "Chambray Shirt",
990                 "Denim Shirt",
991                 "Linen Shirt",
992                 "Polo Shirt",
993                 "Unstructured Blazer",
994                 "Patch Pocket Blazer"
995             ];
996     }
997 }
998 
999 /**
1000  * @dev Interface of the ERC165 standard, as defined in the
1001  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1002  *
1003  * Implementers can declare support of contract interfaces, which can then be
1004  * queried by others ({ERC165Checker}).
1005  *
1006  * For an implementation, see {ERC165}.
1007  */
1008 interface IERC165 {
1009     /**
1010      * @dev Returns true if this contract implements the interface defined by
1011      * `interfaceId`. See the corresponding
1012      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1013      * to learn more about how these ids are created.
1014      *
1015      * This function call must use less than 30 000 gas.
1016      */
1017     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1018 }
1019 
1020 /**
1021  * @dev Required interface of an ERC721 compliant contract.
1022  */
1023 interface IERC721 is IERC165 {
1024     /**
1025      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1026      */
1027     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1028 
1029     /**
1030      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1031      */
1032     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1033 
1034     /**
1035      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1036      */
1037     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1038 
1039     /**
1040      * @dev Returns the number of tokens in ``owner``'s account.
1041      */
1042     function balanceOf(address owner) external view returns (uint256 balance);
1043 
1044     /**
1045      * @dev Returns the owner of the `tokenId` token.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      */
1051     function ownerOf(uint256 tokenId) external view returns (address owner);
1052 
1053     /**
1054      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1055      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1056      *
1057      * Requirements:
1058      *
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must exist and be owned by `from`.
1062      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1063      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function safeTransferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) external;
1072 
1073     /**
1074      * @dev Transfers `tokenId` token from `from` to `to`.
1075      *
1076      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1077      *
1078      * Requirements:
1079      *
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      * - `tokenId` token must be owned by `from`.
1083      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function transferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) external;
1092 
1093     /**
1094      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1095      * The approval is cleared when the token is transferred.
1096      *
1097      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1098      *
1099      * Requirements:
1100      *
1101      * - The caller must own the token or be an approved operator.
1102      * - `tokenId` must exist.
1103      *
1104      * Emits an {Approval} event.
1105      */
1106     function approve(address to, uint256 tokenId) external;
1107 
1108     /**
1109      * @dev Returns the account approved for `tokenId` token.
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must exist.
1114      */
1115     function getApproved(uint256 tokenId) external view returns (address operator);
1116 
1117     /**
1118      * @dev Approve or remove `operator` as an operator for the caller.
1119      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1120      *
1121      * Requirements:
1122      *
1123      * - The `operator` cannot be the caller.
1124      *
1125      * Emits an {ApprovalForAll} event.
1126      */
1127     function setApprovalForAll(address operator, bool _approved) external;
1128 
1129     /**
1130      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1131      *
1132      * See {setApprovalForAll}
1133      */
1134     function isApprovedForAll(address owner, address operator) external view returns (bool);
1135 
1136     /**
1137      * @dev Safely transfers `tokenId` token from `from` to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `from` cannot be the zero address.
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must exist and be owned by `from`.
1144      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function safeTransferFrom(
1150         address from,
1151         address to,
1152         uint256 tokenId,
1153         bytes calldata data
1154     ) external;
1155 }
1156 
1157 
1158 
1159 
1160 /**
1161  * @dev String operations.
1162  */
1163 library Strings {
1164     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1165 
1166     /**
1167      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1168      */
1169     function toString(uint256 value) internal pure returns (string memory) {
1170         // Inspired by OraclizeAPI's implementation - MIT licence
1171         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1172 
1173         if (value == 0) {
1174             return "0";
1175         }
1176         uint256 temp = value;
1177         uint256 digits;
1178         while (temp != 0) {
1179             digits++;
1180             temp /= 10;
1181         }
1182         bytes memory buffer = new bytes(digits);
1183         while (value != 0) {
1184             digits -= 1;
1185             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1186             value /= 10;
1187         }
1188         return string(buffer);
1189     }
1190 
1191     /**
1192      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1193      */
1194     function toHexString(uint256 value) internal pure returns (string memory) {
1195         if (value == 0) {
1196             return "0x00";
1197         }
1198         uint256 temp = value;
1199         uint256 length = 0;
1200         while (temp != 0) {
1201             length++;
1202             temp >>= 8;
1203         }
1204         return toHexString(value, length);
1205     }
1206 
1207     /**
1208      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1209      */
1210     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1211         bytes memory buffer = new bytes(2 * length + 2);
1212         buffer[0] = "0";
1213         buffer[1] = "x";
1214         for (uint256 i = 2 * length + 1; i > 1; --i) {
1215             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1216             value >>= 4;
1217         }
1218         require(value == 0, "Strings: hex length insufficient");
1219         return string(buffer);
1220     }
1221 }
1222 
1223 
1224 /*
1225  * @dev Provides information about the current execution context, including the
1226  * sender of the transaction and its data. While these are generally available
1227  * via msg.sender and msg.data, they should not be accessed in such a direct
1228  * manner, since when dealing with meta-transactions the account sending and
1229  * paying for execution may not be the actual sender (as far as an application
1230  * is concerned).
1231  *
1232  * This contract is only required for intermediate, library-like contracts.
1233  */
1234 abstract contract Context {
1235     function _msgSender() internal view virtual returns (address) {
1236         return msg.sender;
1237     }
1238 
1239     function _msgData() internal view virtual returns (bytes calldata) {
1240         return msg.data;
1241     }
1242 }
1243 
1244 /**
1245  * @dev Contract module which provides a basic access control mechanism, where
1246  * there is an account (an owner) that can be granted exclusive access to
1247  * specific functions.
1248  *
1249  * By default, the owner account will be the one that deploys the contract. This
1250  * can later be changed with {transferOwnership}.
1251  *
1252  * This module is used through inheritance. It will make available the modifier
1253  * `onlyOwner`, which can be applied to your functions to restrict their use to
1254  * the owner.
1255  */
1256 abstract contract Ownable is Context {
1257     address private _owner;
1258 
1259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1260 
1261     /**
1262      * @dev Initializes the contract setting the deployer as the initial owner.
1263      */
1264     constructor() {
1265         _setOwner(_msgSender());
1266     }
1267 
1268     /**
1269      * @dev Returns the address of the current owner.
1270      */
1271     function owner() public view virtual returns (address) {
1272         return _owner;
1273     }
1274 
1275     /**
1276      * @dev Throws if called by any account other than the owner.
1277      */
1278     modifier onlyOwner() {
1279         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1280         _;
1281     }
1282 
1283     /**
1284      * @dev Leaves the contract without owner. It will not be possible to call
1285      * `onlyOwner` functions anymore. Can only be called by the current owner.
1286      *
1287      * NOTE: Renouncing ownership will leave the contract without an owner,
1288      * thereby removing any functionality that is only available to the owner.
1289      */
1290     function renounceOwnership() public virtual onlyOwner {
1291         _setOwner(address(0));
1292     }
1293 
1294     /**
1295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1296      * Can only be called by the current owner.
1297      */
1298     function transferOwnership(address newOwner) public virtual onlyOwner {
1299         require(newOwner != address(0), "Ownable: new owner is the zero address");
1300         _setOwner(newOwner);
1301     }
1302 
1303     function _setOwner(address newOwner) private {
1304         address oldOwner = _owner;
1305         _owner = newOwner;
1306         emit OwnershipTransferred(oldOwner, newOwner);
1307     }
1308 }
1309 
1310 
1311 
1312 
1313 
1314 /**
1315  * @dev Contract module that helps prevent reentrant calls to a function.
1316  *
1317  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1318  * available, which can be applied to functions to make sure there are no nested
1319  * (reentrant) calls to them.
1320  *
1321  * Note that because there is a single `nonReentrant` guard, functions marked as
1322  * `nonReentrant` may not call one another. This can be worked around by making
1323  * those functions `private`, and then adding `external` `nonReentrant` entry
1324  * points to them.
1325  *
1326  * TIP: If you would like to learn more about reentrancy and alternative ways
1327  * to protect against it, check out our blog post
1328  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1329  */
1330 abstract contract ReentrancyGuard {
1331     // Booleans are more expensive than uint256 or any type that takes up a full
1332     // word because each write operation emits an extra SLOAD to first read the
1333     // slot's contents, replace the bits taken up by the boolean, and then write
1334     // back. This is the compiler's defense against contract upgrades and
1335     // pointer aliasing, and it cannot be disabled.
1336 
1337     // The values being non-zero value makes deployment a bit more expensive,
1338     // but in exchange the refund on every call to nonReentrant will be lower in
1339     // amount. Since refunds are capped to a percentage of the total
1340     // transaction's gas, it is best to keep them low in cases like this one, to
1341     // increase the likelihood of the full refund coming into effect.
1342     uint256 private constant _NOT_ENTERED = 1;
1343     uint256 private constant _ENTERED = 2;
1344 
1345     uint256 private _status;
1346 
1347     constructor() {
1348         _status = _NOT_ENTERED;
1349     }
1350 
1351     /**
1352      * @dev Prevents a contract from calling itself, directly or indirectly.
1353      * Calling a `nonReentrant` function from another `nonReentrant`
1354      * function is not supported. It is possible to prevent this from happening
1355      * by making the `nonReentrant` function external, and make it call a
1356      * `private` function that does the actual work.
1357      */
1358     modifier nonReentrant() {
1359         // On the first call to nonReentrant, _notEntered will be true
1360         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1361 
1362         // Any calls to nonReentrant after this point will fail
1363         _status = _ENTERED;
1364 
1365         _;
1366 
1367         // By storing the original value once again, a refund is triggered (see
1368         // https://eips.ethereum.org/EIPS/eip-2200)
1369         _status = _NOT_ENTERED;
1370     }
1371 }
1372 
1373 
1374 
1375 
1376 
1377 
1378 
1379 
1380 
1381 
1382 
1383 
1384 
1385 
1386 /**
1387  * @title ERC721 token receiver interface
1388  * @dev Interface for any contract that wants to support safeTransfers
1389  * from ERC721 asset contracts.
1390  */
1391 interface IERC721Receiver {
1392     /**
1393      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1394      * by `operator` from `from`, this function is called.
1395      *
1396      * It must return its Solidity selector to confirm the token transfer.
1397      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1398      *
1399      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1400      */
1401     function onERC721Received(
1402         address operator,
1403         address from,
1404         uint256 tokenId,
1405         bytes calldata data
1406     ) external returns (bytes4);
1407 }
1408 
1409 
1410 
1411 
1412 
1413 
1414 
1415 /**
1416  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1417  * @dev See https://eips.ethereum.org/EIPS/eip-721
1418  */
1419 interface IERC721Metadata is IERC721 {
1420     /**
1421      * @dev Returns the token collection name.
1422      */
1423     function name() external view returns (string memory);
1424 
1425     /**
1426      * @dev Returns the token collection symbol.
1427      */
1428     function symbol() external view returns (string memory);
1429 
1430     /**
1431      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1432      */
1433     function tokenURI(uint256 tokenId) external view returns (string memory);
1434 }
1435 
1436 
1437 /**
1438  * @dev Collection of functions related to the address type
1439  */
1440 library Address {
1441     /**
1442      * @dev Returns true if `account` is a contract.
1443      *
1444      * [IMPORTANT]
1445      * ====
1446      * It is unsafe to assume that an address for which this function returns
1447      * false is an externally-owned account (EOA) and not a contract.
1448      *
1449      * Among others, `isContract` will return false for the following
1450      * types of addresses:
1451      *
1452      *  - an externally-owned account
1453      *  - a contract in construction
1454      *  - an address where a contract will be created
1455      *  - an address where a contract lived, but was destroyed
1456      * ====
1457      */
1458     function isContract(address account) internal view returns (bool) {
1459         // This method relies on extcodesize, which returns 0 for contracts in
1460         // construction, since the code is only stored at the end of the
1461         // constructor execution.
1462 
1463         uint256 size;
1464         assembly {
1465             size := extcodesize(account)
1466         }
1467         return size > 0;
1468     }
1469 
1470     /**
1471      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1472      * `recipient`, forwarding all available gas and reverting on errors.
1473      *
1474      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1475      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1476      * imposed by `transfer`, making them unable to receive funds via
1477      * `transfer`. {sendValue} removes this limitation.
1478      *
1479      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1480      *
1481      * IMPORTANT: because control is transferred to `recipient`, care must be
1482      * taken to not create reentrancy vulnerabilities. Consider using
1483      * {ReentrancyGuard} or the
1484      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1485      */
1486     function sendValue(address payable recipient, uint256 amount) internal {
1487         require(address(this).balance >= amount, "Address: insufficient balance");
1488 
1489         (bool success, ) = recipient.call{value: amount}("");
1490         require(success, "Address: unable to send value, recipient may have reverted");
1491     }
1492 
1493     /**
1494      * @dev Performs a Solidity function call using a low level `call`. A
1495      * plain `call` is an unsafe replacement for a function call: use this
1496      * function instead.
1497      *
1498      * If `target` reverts with a revert reason, it is bubbled up by this
1499      * function (like regular Solidity function calls).
1500      *
1501      * Returns the raw returned data. To convert to the expected return value,
1502      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1503      *
1504      * Requirements:
1505      *
1506      * - `target` must be a contract.
1507      * - calling `target` with `data` must not revert.
1508      *
1509      * _Available since v3.1._
1510      */
1511     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1512         return functionCall(target, data, "Address: low-level call failed");
1513     }
1514 
1515     /**
1516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1517      * `errorMessage` as a fallback revert reason when `target` reverts.
1518      *
1519      * _Available since v3.1._
1520      */
1521     function functionCall(
1522         address target,
1523         bytes memory data,
1524         string memory errorMessage
1525     ) internal returns (bytes memory) {
1526         return functionCallWithValue(target, data, 0, errorMessage);
1527     }
1528 
1529     /**
1530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1531      * but also transferring `value` wei to `target`.
1532      *
1533      * Requirements:
1534      *
1535      * - the calling contract must have an ETH balance of at least `value`.
1536      * - the called Solidity function must be `payable`.
1537      *
1538      * _Available since v3.1._
1539      */
1540     function functionCallWithValue(
1541         address target,
1542         bytes memory data,
1543         uint256 value
1544     ) internal returns (bytes memory) {
1545         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1546     }
1547 
1548     /**
1549      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1550      * with `errorMessage` as a fallback revert reason when `target` reverts.
1551      *
1552      * _Available since v3.1._
1553      */
1554     function functionCallWithValue(
1555         address target,
1556         bytes memory data,
1557         uint256 value,
1558         string memory errorMessage
1559     ) internal returns (bytes memory) {
1560         require(address(this).balance >= value, "Address: insufficient balance for call");
1561         require(isContract(target), "Address: call to non-contract");
1562 
1563         (bool success, bytes memory returndata) = target.call{value: value}(data);
1564         return _verifyCallResult(success, returndata, errorMessage);
1565     }
1566 
1567     /**
1568      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1569      * but performing a static call.
1570      *
1571      * _Available since v3.3._
1572      */
1573     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1574         return functionStaticCall(target, data, "Address: low-level static call failed");
1575     }
1576 
1577     /**
1578      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1579      * but performing a static call.
1580      *
1581      * _Available since v3.3._
1582      */
1583     function functionStaticCall(
1584         address target,
1585         bytes memory data,
1586         string memory errorMessage
1587     ) internal view returns (bytes memory) {
1588         require(isContract(target), "Address: static call to non-contract");
1589 
1590         (bool success, bytes memory returndata) = target.staticcall(data);
1591         return _verifyCallResult(success, returndata, errorMessage);
1592     }
1593 
1594     /**
1595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1596      * but performing a delegate call.
1597      *
1598      * _Available since v3.4._
1599      */
1600     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1601         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1602     }
1603 
1604     /**
1605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1606      * but performing a delegate call.
1607      *
1608      * _Available since v3.4._
1609      */
1610     function functionDelegateCall(
1611         address target,
1612         bytes memory data,
1613         string memory errorMessage
1614     ) internal returns (bytes memory) {
1615         require(isContract(target), "Address: delegate call to non-contract");
1616 
1617         (bool success, bytes memory returndata) = target.delegatecall(data);
1618         return _verifyCallResult(success, returndata, errorMessage);
1619     }
1620 
1621     function _verifyCallResult(
1622         bool success,
1623         bytes memory returndata,
1624         string memory errorMessage
1625     ) private pure returns (bytes memory) {
1626         if (success) {
1627             return returndata;
1628         } else {
1629             // Look for revert reason and bubble it up if present
1630             if (returndata.length > 0) {
1631                 // The easiest way to bubble the revert reason is using memory via assembly
1632 
1633                 assembly {
1634                     let returndata_size := mload(returndata)
1635                     revert(add(32, returndata), returndata_size)
1636                 }
1637             } else {
1638                 revert(errorMessage);
1639             }
1640         }
1641     }
1642 }
1643 
1644 /**
1645  * @dev Implementation of the {IERC165} interface.
1646  *
1647  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1648  * for the additional interface id that will be supported. For example:
1649  *
1650  * ```solidity
1651  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1652  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1653  * }
1654  * ```
1655  *
1656  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1657  */
1658 abstract contract ERC165 is IERC165 {
1659     /**
1660      * @dev See {IERC165-supportsInterface}.
1661      */
1662     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1663         return interfaceId == type(IERC165).interfaceId;
1664     }
1665 }
1666 
1667 /**
1668  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1669  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1670  * {ERC721Enumerable}.
1671  */
1672 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1673     using Address for address;
1674     using Strings for uint256;
1675 
1676     // Token name
1677     string private _name;
1678 
1679     // Token symbol
1680     string private _symbol;
1681 
1682     // Mapping from token ID to owner address
1683     mapping(uint256 => address) private _owners;
1684 
1685     // Mapping owner address to token count
1686     mapping(address => uint256) private _balances;
1687 
1688     // Mapping from token ID to approved address
1689     mapping(uint256 => address) private _tokenApprovals;
1690 
1691     // Mapping from owner to operator approvals
1692     mapping(address => mapping(address => bool)) private _operatorApprovals;
1693 
1694     /**
1695      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1696      */
1697     constructor(string memory name_, string memory symbol_) {
1698         _name = name_;
1699         _symbol = symbol_;
1700     }
1701 
1702     /**
1703      * @dev See {IERC165-supportsInterface}.
1704      */
1705     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1706         return
1707         interfaceId == type(IERC721).interfaceId ||
1708         interfaceId == type(IERC721Metadata).interfaceId ||
1709         super.supportsInterface(interfaceId);
1710     }
1711 
1712     /**
1713      * @dev See {IERC721-balanceOf}.
1714      */
1715     function balanceOf(address owner) public view virtual override returns (uint256) {
1716         require(owner != address(0), "ERC721: balance query for the zero address");
1717         return _balances[owner];
1718     }
1719 
1720     /**
1721      * @dev See {IERC721-ownerOf}.
1722      */
1723     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1724         address owner = _owners[tokenId];
1725         require(owner != address(0), "ERC721: owner query for nonexistent token");
1726         return owner;
1727     }
1728 
1729     /**
1730      * @dev See {IERC721Metadata-name}.
1731      */
1732     function name() public view virtual override returns (string memory) {
1733         return _name;
1734     }
1735 
1736     /**
1737      * @dev See {IERC721Metadata-symbol}.
1738      */
1739     function symbol() public view virtual override returns (string memory) {
1740         return _symbol;
1741     }
1742 
1743     /**
1744      * @dev See {IERC721Metadata-tokenURI}.
1745      */
1746     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1747         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1748 
1749         string memory baseURI = _baseURI();
1750         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1751     }
1752 
1753     /**
1754      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1755      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1756      * by default, can be overriden in child contracts.
1757      */
1758     function _baseURI() internal view virtual returns (string memory) {
1759         return "";
1760     }
1761 
1762     /**
1763      * @dev See {IERC721-approve}.
1764      */
1765     function approve(address to, uint256 tokenId) public virtual override {
1766         address owner = ERC721.ownerOf(tokenId);
1767         require(to != owner, "ERC721: approval to current owner");
1768 
1769         require(
1770             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1771             "ERC721: approve caller is not owner nor approved for all"
1772         );
1773 
1774         _approve(to, tokenId);
1775     }
1776 
1777     /**
1778      * @dev See {IERC721-getApproved}.
1779      */
1780     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1781         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1782 
1783         return _tokenApprovals[tokenId];
1784     }
1785 
1786     /**
1787      * @dev See {IERC721-setApprovalForAll}.
1788      */
1789     function setApprovalForAll(address operator, bool approved) public virtual override {
1790         require(operator != _msgSender(), "ERC721: approve to caller");
1791 
1792         _operatorApprovals[_msgSender()][operator] = approved;
1793         emit ApprovalForAll(_msgSender(), operator, approved);
1794     }
1795 
1796     /**
1797      * @dev See {IERC721-isApprovedForAll}.
1798      */
1799     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1800         return _operatorApprovals[owner][operator];
1801     }
1802 
1803     /**
1804      * @dev See {IERC721-transferFrom}.
1805      */
1806     function transferFrom(
1807         address from,
1808         address to,
1809         uint256 tokenId
1810     ) public virtual override {
1811         //solhint-disable-next-line max-line-length
1812         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1813 
1814         _transfer(from, to, tokenId);
1815     }
1816 
1817     /**
1818      * @dev See {IERC721-safeTransferFrom}.
1819      */
1820     function safeTransferFrom(
1821         address from,
1822         address to,
1823         uint256 tokenId
1824     ) public virtual override {
1825         safeTransferFrom(from, to, tokenId, "");
1826     }
1827 
1828     /**
1829      * @dev See {IERC721-safeTransferFrom}.
1830      */
1831     function safeTransferFrom(
1832         address from,
1833         address to,
1834         uint256 tokenId,
1835         bytes memory _data
1836     ) public virtual override {
1837         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1838         _safeTransfer(from, to, tokenId, _data);
1839     }
1840 
1841     /**
1842      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1843      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1844      *
1845      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1846      *
1847      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1848      * implement alternative mechanisms to perform token transfer, such as signature-based.
1849      *
1850      * Requirements:
1851      *
1852      * - `from` cannot be the zero address.
1853      * - `to` cannot be the zero address.
1854      * - `tokenId` token must exist and be owned by `from`.
1855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1856      *
1857      * Emits a {Transfer} event.
1858      */
1859     function _safeTransfer(
1860         address from,
1861         address to,
1862         uint256 tokenId,
1863         bytes memory _data
1864     ) internal virtual {
1865         _transfer(from, to, tokenId);
1866         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1867     }
1868 
1869     /**
1870      * @dev Returns whether `tokenId` exists.
1871      *
1872      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1873      *
1874      * Tokens start existing when they are minted (`_mint`),
1875      * and stop existing when they are burned (`_burn`).
1876      */
1877     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1878         return _owners[tokenId] != address(0);
1879     }
1880 
1881     /**
1882      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1883      *
1884      * Requirements:
1885      *
1886      * - `tokenId` must exist.
1887      */
1888     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1889         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1890         address owner = ERC721.ownerOf(tokenId);
1891         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1892     }
1893 
1894     /**
1895      * @dev Safely mints `tokenId` and transfers it to `to`.
1896      *
1897      * Requirements:
1898      *
1899      * - `tokenId` must not exist.
1900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1901      *
1902      * Emits a {Transfer} event.
1903      */
1904     function _safeMint(address to, uint256 tokenId) internal virtual {
1905         _safeMint(to, tokenId, "");
1906     }
1907 
1908     /**
1909      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1910      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1911      */
1912     function _safeMint(
1913         address to,
1914         uint256 tokenId,
1915         bytes memory _data
1916     ) internal virtual {
1917         _mint(to, tokenId);
1918         require(
1919             _checkOnERC721Received(address(0), to, tokenId, _data),
1920             "ERC721: transfer to non ERC721Receiver implementer"
1921         );
1922     }
1923 
1924     /**
1925      * @dev Mints `tokenId` and transfers it to `to`.
1926      *
1927      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1928      *
1929      * Requirements:
1930      *
1931      * - `tokenId` must not exist.
1932      * - `to` cannot be the zero address.
1933      *
1934      * Emits a {Transfer} event.
1935      */
1936     function _mint(address to, uint256 tokenId) internal virtual {
1937         require(to != address(0), "ERC721: mint to the zero address");
1938         require(!_exists(tokenId), "ERC721: token already minted");
1939 
1940         _beforeTokenTransfer(address(0), to, tokenId);
1941 
1942         _balances[to] += 1;
1943         _owners[tokenId] = to;
1944 
1945         emit Transfer(address(0), to, tokenId);
1946     }
1947 
1948     /**
1949      * @dev Destroys `tokenId`.
1950      * The approval is cleared when the token is burned.
1951      *
1952      * Requirements:
1953      *
1954      * - `tokenId` must exist.
1955      *
1956      * Emits a {Transfer} event.
1957      */
1958     function _burn(uint256 tokenId) internal virtual {
1959         address owner = ERC721.ownerOf(tokenId);
1960 
1961         _beforeTokenTransfer(owner, address(0), tokenId);
1962 
1963         // Clear approvals
1964         _approve(address(0), tokenId);
1965 
1966         _balances[owner] -= 1;
1967         delete _owners[tokenId];
1968 
1969         emit Transfer(owner, address(0), tokenId);
1970     }
1971 
1972     /**
1973      * @dev Transfers `tokenId` from `from` to `to`.
1974      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1975      *
1976      * Requirements:
1977      *
1978      * - `to` cannot be the zero address.
1979      * - `tokenId` token must be owned by `from`.
1980      *
1981      * Emits a {Transfer} event.
1982      */
1983     function _transfer(
1984         address from,
1985         address to,
1986         uint256 tokenId
1987     ) internal virtual {
1988         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1989         require(to != address(0), "ERC721: transfer to the zero address");
1990 
1991         _beforeTokenTransfer(from, to, tokenId);
1992 
1993         // Clear approvals from the previous owner
1994         _approve(address(0), tokenId);
1995 
1996         _balances[from] -= 1;
1997         _balances[to] += 1;
1998         _owners[tokenId] = to;
1999 
2000         emit Transfer(from, to, tokenId);
2001     }
2002 
2003     /**
2004      * @dev Approve `to` to operate on `tokenId`
2005      *
2006      * Emits a {Approval} event.
2007      */
2008     function _approve(address to, uint256 tokenId) internal virtual {
2009         _tokenApprovals[tokenId] = to;
2010         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2011     }
2012 
2013     /**
2014      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2015      * The call is not executed if the target address is not a contract.
2016      *
2017      * @param from address representing the previous owner of the given token ID
2018      * @param to target address that will receive the tokens
2019      * @param tokenId uint256 ID of the token to be transferred
2020      * @param _data bytes optional data to send along with the call
2021      * @return bool whether the call correctly returned the expected magic value
2022      */
2023     function _checkOnERC721Received(
2024         address from,
2025         address to,
2026         uint256 tokenId,
2027         bytes memory _data
2028     ) private returns (bool) {
2029         if (to.isContract()) {
2030         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2031         return retval == IERC721Receiver(to).onERC721Received.selector;
2032         } catch (bytes memory reason) {
2033         if (reason.length == 0) {
2034         revert("ERC721: transfer to non ERC721Receiver implementer");
2035         } else {
2036         assembly {
2037         revert(add(32, reason), mload(reason))
2038         }
2039         }
2040         }
2041         } else {
2042             return true;
2043         }
2044     }
2045 
2046     /**
2047      * @dev Hook that is called before any token transfer. This includes minting
2048      * and burning.
2049      *
2050      * Calling conditions:
2051      *
2052      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2053      * transferred to `to`.
2054      * - When `from` is zero, `tokenId` will be minted for `to`.
2055      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2056      * - `from` and `to` are never both zero.
2057      *
2058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2059      */
2060     function _beforeTokenTransfer(
2061         address from,
2062         address to,
2063         uint256 tokenId
2064     ) internal virtual {}
2065 }
2066 
2067 
2068 
2069 
2070 
2071 
2072 
2073 /**
2074  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
2075  * @dev See https://eips.ethereum.org/EIPS/eip-721
2076  */
2077 interface IERC721Enumerable is IERC721 {
2078     /**
2079      * @dev Returns the total amount of tokens stored by the contract.
2080      */
2081     function totalSupply() external view returns (uint256);
2082 
2083     /**
2084      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
2085      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
2086      */
2087     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
2088 
2089     /**
2090      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
2091      * Use along with {totalSupply} to enumerate all tokens.
2092      */
2093     function tokenByIndex(uint256 index) external view returns (uint256);
2094 }
2095 
2096 
2097 /**
2098  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2099  * enumerability of all the token ids in the contract as well as all token ids owned by each
2100  * account.
2101  */
2102 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2103     // Mapping from owner to list of owned token IDs
2104     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2105 
2106     // Mapping from token ID to index of the owner tokens list
2107     mapping(uint256 => uint256) private _ownedTokensIndex;
2108 
2109     // Array with all token ids, used for enumeration
2110     uint256[] private _allTokens;
2111 
2112     // Mapping from token id to position in the allTokens array
2113     mapping(uint256 => uint256) private _allTokensIndex;
2114 
2115     /**
2116      * @dev See {IERC165-supportsInterface}.
2117      */
2118     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2119         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2120     }
2121 
2122     /**
2123      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2124      */
2125     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2126         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2127         return _ownedTokens[owner][index];
2128     }
2129 
2130     /**
2131      * @dev See {IERC721Enumerable-totalSupply}.
2132      */
2133     function totalSupply() public view virtual override returns (uint256) {
2134         return _allTokens.length;
2135     }
2136 
2137     /**
2138      * @dev See {IERC721Enumerable-tokenByIndex}.
2139      */
2140     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2141         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2142         return _allTokens[index];
2143     }
2144 
2145     /**
2146      * @dev Hook that is called before any token transfer. This includes minting
2147      * and burning.
2148      *
2149      * Calling conditions:
2150      *
2151      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2152      * transferred to `to`.
2153      * - When `from` is zero, `tokenId` will be minted for `to`.
2154      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2155      * - `from` cannot be the zero address.
2156      * - `to` cannot be the zero address.
2157      *
2158      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2159      */
2160     function _beforeTokenTransfer(
2161         address from,
2162         address to,
2163         uint256 tokenId
2164     ) internal virtual override {
2165         super._beforeTokenTransfer(from, to, tokenId);
2166 
2167         if (from == address(0)) {
2168             _addTokenToAllTokensEnumeration(tokenId);
2169         } else if (from != to) {
2170             _removeTokenFromOwnerEnumeration(from, tokenId);
2171         }
2172         if (to == address(0)) {
2173             _removeTokenFromAllTokensEnumeration(tokenId);
2174         } else if (to != from) {
2175             _addTokenToOwnerEnumeration(to, tokenId);
2176         }
2177     }
2178 
2179     /**
2180      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2181      * @param to address representing the new owner of the given token ID
2182      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2183      */
2184     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2185         uint256 length = ERC721.balanceOf(to);
2186         _ownedTokens[to][length] = tokenId;
2187         _ownedTokensIndex[tokenId] = length;
2188     }
2189 
2190     /**
2191      * @dev Private function to add a token to this extension's token tracking data structures.
2192      * @param tokenId uint256 ID of the token to be added to the tokens list
2193      */
2194     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2195         _allTokensIndex[tokenId] = _allTokens.length;
2196         _allTokens.push(tokenId);
2197     }
2198 
2199     /**
2200      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2201      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2202      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2203      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2204      * @param from address representing the previous owner of the given token ID
2205      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2206      */
2207     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2208         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2209         // then delete the last slot (swap and pop).
2210 
2211         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2212         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2213 
2214         // When the token to delete is the last token, the swap operation is unnecessary
2215         if (tokenIndex != lastTokenIndex) {
2216             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2217 
2218             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2219             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2220         }
2221 
2222         // This also deletes the contents at the last position of the array
2223         delete _ownedTokensIndex[tokenId];
2224         delete _ownedTokens[from][lastTokenIndex];
2225     }
2226 
2227     /**
2228      * @dev Private function to remove a token from this extension's token tracking data structures.
2229      * This has O(1) time complexity, but alters the order of the _allTokens array.
2230      * @param tokenId uint256 ID of the token to be removed from the tokens list
2231      */
2232     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2233         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2234         // then delete the last slot (swap and pop).
2235 
2236         uint256 lastTokenIndex = _allTokens.length - 1;
2237         uint256 tokenIndex = _allTokensIndex[tokenId];
2238 
2239         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2240         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2241         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2242         uint256 lastTokenId = _allTokens[lastTokenIndex];
2243 
2244         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2245         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2246 
2247         // This also deletes the contents at the last position of the array
2248         delete _allTokensIndex[tokenId];
2249         _allTokens.pop();
2250     }
2251 }
2252 
2253 // LOOK Content was designed by Emma Jane MacKinnon Lee, CEO DIGITALAX
2254 // LOOK Contract was forked from LOOTProject.com and re-built by @vvictor, Blockchain Lead DIGITALAX
2255 // All rights reserved, 2021
2256 contract Look is ERC721Enumerable, ReentrancyGuard, Ownable {
2257     mapping (uint256 => string[]) indexToSuffixCategory;
2258     uint256 public randomMultiplier;
2259 
2260     uint256 public uriSwap;
2261 
2262     mapping (address => bool) public whitelistAddress;
2263 
2264     function getPattern(uint256 tokenId) public view returns (string memory) {
2265         return pluck(tokenId, "PATTERN");
2266     }
2267 
2268     function getTexture(uint256 tokenId) public view returns (string memory) {
2269         return pluck(tokenId, "TEXTURE");
2270     }
2271 
2272     function getColour(uint256 tokenId) public view returns (string memory) {
2273         return pluck(tokenId, "COLOUR");
2274     }
2275 
2276     function getBackgroundColour(uint256 tokenId) public view returns (string memory) {
2277         return pluck(tokenId, "BACKGROUND");
2278     }
2279 
2280     function getLine(uint256 tokenId) public view returns (string memory) {
2281         return pluck(tokenId, "LINE");
2282     }
2283 
2284     function getFlare(uint256 tokenId) public view returns (string memory) {
2285         return pluck(tokenId, "FLARE");
2286     }
2287 
2288     function getShape(uint256 tokenId) public view returns (string memory) {
2289         return pluck(tokenId, "SHAPE");
2290     }
2291 
2292     function getForm(uint256 tokenId) public view returns (string memory) {
2293         return pluck(tokenId, "FORM");
2294     }
2295 
2296     function getElement(uint256 tokenId) public view returns (string memory) {
2297         return pluck(tokenId, "ELEMENT");
2298     }
2299 
2300     function pluck(uint256 tokenId, string memory keyPrefix) internal view returns (string memory) {
2301         uint256 rand = LOOKLogic.random(string(abi.encodePacked(LOOKLogic.toString(tokenId  * randomMultiplier), LOOKLogic.toString(tokenId), tokenId * randomMultiplier))) + randomMultiplier + tokenId;
2302 
2303         uint256 randomPrefix = LOOKLogic.random(string(abi.encodePacked("PREFIXRANDOM", LOOKLogic.toString(tokenId + randomMultiplier))));
2304 
2305         uint256 randomSuffix = LOOKLogic.random(string(abi.encodePacked("SUFFIX", LOOKLogic.toString(tokenId + randomMultiplier))));
2306 
2307         string memory output;
2308 
2309         uint256[6] memory mixUpValues = [uint256(0),uint256(1),uint256(2),uint256(3),uint256(4),uint256(5)];
2310         uint256 mixUpSuffix = rand % 6;
2311         if(mixUpSuffix == 1) {
2312             mixUpValues = [uint256(1),uint256(2),uint256(3),uint256(4),uint256(5),uint256(0)];
2313         } else if (mixUpSuffix == 2){
2314             mixUpValues = [uint256(2),uint256(3),uint256(4),uint256(5),uint256(0),uint256(1)];
2315         } else if (mixUpSuffix == 3){
2316             mixUpValues = [uint256(3),uint256(4),uint256(5),uint256(0),uint256(1),uint256(2)];
2317         } else if (mixUpSuffix == 4){
2318             mixUpValues = [uint256(4),uint256(5),uint256(0),uint256(1),uint256(2),uint256(3)];
2319         } else if (mixUpSuffix == 5){
2320             mixUpValues = [uint256(5),uint256(0),uint256(1),uint256(2),uint256(3),uint256(4)];
2321         }
2322 
2323         if (keccak256(bytes(keyPrefix)) == keccak256(bytes("TEXTURE"))) {
2324             output = LOOKLib.textures()[rand % LOOKLib.textures().length];
2325             string[] memory suffixes = indexToSuffixCategory[LOOKLogic.pickSuffixCategories(randomSuffix, tokenId)[mixUpValues[0]]];
2326             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
2327         } else if (keccak256(bytes(keyPrefix)) == keccak256(bytes("COLOUR"))){
2328             output = LOOKLib.colours()[rand % LOOKLib.colours().length];
2329             string[] memory suffixes = indexToSuffixCategory[LOOKLogic.pickSuffixCategories(randomSuffix, tokenId)[mixUpValues[1]]];
2330             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
2331         } else if( keccak256(bytes(keyPrefix)) == keccak256(bytes("SHAPE"))){
2332             output = LOOKLib.shapes()[rand % LOOKLib.shapes().length];
2333             string[] memory suffixes = indexToSuffixCategory[LOOKLogic.pickSuffixCategories(randomSuffix, tokenId)[mixUpValues[2]]];
2334             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
2335         } else if (keccak256(bytes(keyPrefix)) == keccak256(bytes("ELEMENT"))){
2336             output = LOOKLib.elements()[rand % LOOKLib.elements().length];
2337             string[] memory suffixes = indexToSuffixCategory[LOOKLogic.pickSuffixCategories(randomSuffix, tokenId)[mixUpValues[3]]];
2338             output = string(abi.encodePacked(output, " ", suffixes[rand % suffixes.length]));
2339         } else if (keccak256(bytes(keyPrefix)) == keccak256(bytes("LINE"))){
2340             output = LOOKLib.lines()[rand % LOOKLib.lines().length];
2341             string[] memory suffixes = indexToSuffixCategory[LOOKLogic.pickSuffixCategories(randomSuffix, tokenId)[mixUpValues[4]]];
2342             (string memory prefix1,) = LOOKLogic.pickPrefix(randomPrefix, tokenId);
2343             output = string(abi.encodePacked(prefix1, " ", output, " ",  suffixes[rand % suffixes.length]));
2344         } else if (keccak256(bytes(keyPrefix)) == keccak256(bytes("FORM"))){
2345             output = LOOKLib.forms()[rand % LOOKLib.forms().length];
2346             string[] memory suffixes = indexToSuffixCategory[LOOKLogic.pickSuffixCategories(randomSuffix, tokenId)[mixUpValues[5]]];
2347             (, string memory prefix2) = LOOKLogic.pickPrefix(randomPrefix, tokenId);
2348             output = string(abi.encodePacked(prefix2, " ", output, " ",  suffixes[rand % suffixes.length]));
2349         } else if (keccak256(bytes(keyPrefix)) == keccak256(bytes("FLARE"))){
2350             output = LOOKLib.flares()[rand % LOOKLib.flares().length];
2351         } else if(keccak256(bytes(keyPrefix)) == keccak256(bytes("PATTERN"))){
2352             output = string(abi.encodePacked("DXM #", LOOKLogic.toString((rand % 177) + 100013)));
2353         } else {
2354             output = LOOKLib.backgroundColours()[rand % LOOKLib.backgroundColours().length];
2355         }
2356         // else {} // Background colour
2357         return output;
2358     }
2359 
2360     function tokenURI(uint256 tokenId) override public view returns (string memory) {
2361         if(totalSupply() < uriSwap){
2362             string[7] memory partsOfPreClaim;
2363             partsOfPreClaim[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>@import url("https://fonts.googleapis.com/css?family=Inknut+Antiqua:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900,900italic"); .base { fill: white; font-family: Inknut Antiqua; font-size: 10px; font-weight:bold; }</style><rect width="100%" height="100%" fill="black';
2364             partsOfPreClaim[2] = '" /><text x="245" y="20" class="base"> LookBook #';
2365             partsOfPreClaim[3] = LOOKLogic.toString(tokenId);
2366             partsOfPreClaim[4] = '</text><text x="10" y="60" class="base"> There are ';
2367             partsOfPreClaim[5] = LOOKLogic.toString(3000 - totalSupply());
2368             partsOfPreClaim[6] = ' remaining to be claimed!</text><text x="10" y="80" class="base"> Go get your LOOKs before its too late!</text><text x="10" y="100" class="base">When every LOOK is claimed, the random number will be drawn</text><text x="10" y="120" class="base"> Once we draw randomness, LOOKs will appear</text></svg>';
2369             string memory outputPreClaim = string(abi.encodePacked(partsOfPreClaim[0], partsOfPreClaim[1], partsOfPreClaim[2], partsOfPreClaim[3], partsOfPreClaim[4], partsOfPreClaim[5], partsOfPreClaim[6]));
2370             string memory jsonPreclaim = Base64.encode(bytes(string(abi.encodePacked('{"name": "LookBook #', LOOKLogic.toString(tokenId), '", "description": "LOOK: Composable, open source metaverse fashion. A web3 fashion derivative of the Loot project", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(outputPreClaim)), '"}'))));
2371             outputPreClaim = string(abi.encodePacked('data:application/json;base64,', jsonPreclaim));
2372             return outputPreClaim;
2373         }
2374 
2375         string[21] memory parts;
2376         parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>@import url("https://fonts.googleapis.com/css?family=Inknut+Antiqua:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900,900italic"); .base { fill: white; font-family: Inknut Antiqua; font-size: 10.8px; font-weight:bold; }</style><rect width="100%" height="100%" fill="#';
2377 
2378         parts[1] = getBackgroundColour(tokenId);
2379 
2380         parts[2] = '" /><text x="245" y="20" class="base"> LookBook #';
2381 
2382         parts[3] = LOOKLogic.toString(tokenId);
2383 
2384         parts[4] = '</text><text x="10" y="60" class="base">';
2385 
2386         parts[5] = getPattern(tokenId);
2387 
2388         parts[6] = '</text><text x="10" y="80" class="base">';
2389 
2390         parts[7] = getTexture(tokenId);
2391 
2392         parts[8] = '</text><text x="10" y="100" class="base">';
2393 
2394         parts[9] = getColour(tokenId);
2395 
2396         parts[10] = '</text><text x="10" y="120" class="base">';
2397 
2398         parts[11] = getLine(tokenId);
2399 
2400         parts[12] = '</text><text x="10" y="140" class="base">';
2401 
2402         parts[13] = getFlare(tokenId);
2403 
2404         parts[14] = '</text><text x="10" y="160" class="base">';
2405 
2406         parts[15] = getShape(tokenId);
2407 
2408         parts[16] = '</text><text x="10" y="180" class="base">';
2409 
2410         parts[17] = getForm(tokenId);
2411 
2412         parts[18] = '</text><text x="10" y="200" class="base">';
2413 
2414         parts[19] = getElement(tokenId);
2415 
2416         parts[20] = '</text></svg>';
2417 
2418         string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
2419         output = string(abi.encodePacked(output, parts[9], parts[10], parts[11], parts[12], parts[13], parts[14], parts[15], parts[16]));
2420         output = string(abi.encodePacked(output, parts[17], parts[18], parts[19], parts[20]));
2421 
2422         string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "LookBook #', LOOKLogic.toString(tokenId), '", "description": "LOOK: Composable, open source metaverse fashion. A web3 fashion derivative of the Loot project", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
2423         output = string(abi.encodePacked('data:application/json;base64,', json));
2424 
2425         return output;
2426     }
2427 
2428     function claim(uint256 tokenId) public nonReentrant{
2429         require(tokenId > 0 && tokenId < 3001, "Token ID invalid");
2430         require(whitelistAddress[msg.sender], "Address not whitelisted");
2431         _safeMint(msg.sender, tokenId);
2432     }
2433 
2434     // FOR TESTING PURPOSES
2435     function setRandomMultiplier(uint256 _random) public onlyOwner {
2436         randomMultiplier = _random;
2437     }
2438 
2439     function setUriSwap(uint256 _uriSwap) public onlyOwner {
2440         uriSwap = _uriSwap;
2441     }
2442 
2443     function addWhitelisted(address[] memory whitelisted) external onlyOwner {
2444         for( uint256 i = 0; i < whitelisted.length; i++){
2445             whitelistAddress[whitelisted[i]] = true;
2446         }
2447     }
2448 
2449     function removeWhitelisted(address[] memory whitelisted) external onlyOwner {
2450         for( uint256 i = 0; i < whitelisted.length; i++){
2451             whitelistAddress[whitelisted[i]] = false;
2452         }
2453     }
2454 
2455     constructor() ERC721("Look", "LOOK") Ownable() {
2456 
2457         randomMultiplier = 564564564;
2458         uriSwap = 3001;
2459 
2460         indexToSuffixCategory[0] = LOOKSuffix.socksSuffixCommon();
2461         indexToSuffixCategory[1] = LOOKSuffix.socksSuffixSemirare();
2462         indexToSuffixCategory[2] = LOOKSuffix.socksSuffixExclusive();
2463 
2464         indexToSuffixCategory[3] = LOOKSuffix.accessorySuffixCommon();
2465         indexToSuffixCategory[4] = LOOKSuffix.accessorySuffixSemirare();
2466         indexToSuffixCategory[5] = LOOKSuffix.accessorySuffixExclusive();
2467 
2468         indexToSuffixCategory[6] = LOOKSuffix.shoeSuffixCommon();
2469         indexToSuffixCategory[7] = LOOKSuffix.shoeSuffixSemirare();
2470         indexToSuffixCategory[8] = LOOKSuffix.shoeSuffixExclusive();
2471 
2472         indexToSuffixCategory[9] = LOOKSuffix.swimmerSuffixCommon();
2473         indexToSuffixCategory[10] = LOOKSuffix.swimmerSuffixSemirare();
2474         indexToSuffixCategory[11] = LOOKSuffix.swimmerSuffixExclusive();
2475 
2476         indexToSuffixCategory[12] = LOOKSuffix.sunglassSuffixCommon();
2477         indexToSuffixCategory[13] = LOOKSuffix.sunglassSuffixSemirare();
2478         indexToSuffixCategory[14] = LOOKSuffix.sunglassSuffixExclusive();
2479 
2480         indexToSuffixCategory[15] = LOOKSuffix.outfitSuffixCommon();
2481         indexToSuffixCategory[16] = LOOKSuffix.outfitSuffixSemirare();
2482         indexToSuffixCategory[17] = LOOKSuffix.outfitSuffixExclusive();
2483 
2484         indexToSuffixCategory[18] = LOOKSuffix.topBottomSuffixCommon();
2485         indexToSuffixCategory[19] = LOOKSuffix.topBottomSuffixSemirare();
2486         indexToSuffixCategory[20] = LOOKSuffix.topBottomSuffixExclusive();
2487     }
2488 }
2489 
2490 /// [MIT License]
2491 /// @title Base64
2492 /// @notice Provides a function for encoding some bytes in base64
2493 /// @author Brecht Devos <brecht@loopring.org>
2494 library Base64 {
2495     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2496 
2497     /// @notice Encodes some bytes to the base64 representation
2498     function encode(bytes memory data) internal pure returns (string memory) {
2499         uint256 len = data.length;
2500         if (len == 0) return "";
2501 
2502         // multiply by 4/3 rounded up
2503         uint256 encodedLen = 4 * ((len + 2) / 3);
2504 
2505         // Add some extra buffer at the end
2506         bytes memory result = new bytes(encodedLen + 32);
2507 
2508         bytes memory table = TABLE;
2509 
2510         assembly {
2511             let tablePtr := add(table, 1)
2512             let resultPtr := add(result, 32)
2513 
2514             for {
2515                 let i := 0
2516             } lt(i, len) {
2517 
2518             } {
2519                 i := add(i, 3)
2520                 let input := and(mload(add(data, i)), 0xffffff)
2521 
2522                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
2523                 out := shl(8, out)
2524                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
2525                 out := shl(8, out)
2526                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
2527                 out := shl(8, out)
2528                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
2529                 out := shl(224, out)
2530 
2531                 mstore(resultPtr, out)
2532 
2533                 resultPtr := add(resultPtr, 4)
2534             }
2535 
2536             switch mod(len, 3)
2537             case 1 {
2538                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2539             }
2540             case 2 {
2541                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2542             }
2543 
2544             mstore(result, encodedLen)
2545         }
2546 
2547         return string(result);
2548     }
2549 }