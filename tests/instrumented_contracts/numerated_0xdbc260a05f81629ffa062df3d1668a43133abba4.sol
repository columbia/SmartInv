1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 
47 
48 
49 /// @title The contract that manages all the players that appear in our game.
50 /// @author The CryptoStrikers Team
51 contract StrikersPlayerList is Ownable {
52   // We only use playerIds in StrikersChecklist.sol (to
53   // indicate which player features on instances of a
54   // given ChecklistItem), and nowhere else in the app.
55   // While it's not explictly necessary for any of our
56   // contracts to know that playerId 0 corresponds to
57   // Lionel Messi, we think that it's nice to have
58   // a canonical source of truth for who the playerIds
59   // actually refer to. Storing strings (player names)
60   // is expensive, so we just use Events to prove that,
61   // at some point, we said a playerId represents a given person.
62 
63   /// @dev The event we fire when we add a player.
64   event PlayerAdded(uint8 indexed id, string name);
65 
66   /// @dev How many players we've added so far
67   ///   (max 255, though we don't plan on getting close)
68   uint8 public playerCount;
69 
70   /// @dev Here we add the players we are launching with on Day 1.
71   ///   Players are loosely ranked by things like FIFA ratings,
72   ///   number of Instagram followers, and opinions of CryptoStrikers
73   ///   team members. Feel free to yell at us on Twitter.
74   constructor() public {
75     addPlayer("Lionel Messi"); // 0
76     addPlayer("Cristiano Ronaldo"); // 1
77     addPlayer("Neymar"); // 2
78     addPlayer("Mohamed Salah"); // 3
79     addPlayer("Robert Lewandowski"); // 4
80     addPlayer("Kevin De Bruyne"); // 5
81     addPlayer("Luka Modrić"); // 6
82     addPlayer("Eden Hazard"); // 7
83     addPlayer("Sergio Ramos"); // 8
84     addPlayer("Toni Kroos"); // 9
85     addPlayer("Luis Suárez"); // 10
86     addPlayer("Harry Kane"); // 11
87     addPlayer("Sergio Agüero"); // 12
88     addPlayer("Kylian Mbappé"); // 13
89     addPlayer("Gonzalo Higuaín"); // 14
90     addPlayer("David de Gea"); // 15
91     addPlayer("Antoine Griezmann"); // 16
92     addPlayer("N'Golo Kanté"); // 17
93     addPlayer("Edinson Cavani"); // 18
94     addPlayer("Paul Pogba"); // 19
95     addPlayer("Isco"); // 20
96     addPlayer("Marcelo"); // 21
97     addPlayer("Manuel Neuer"); // 22
98     addPlayer("Dries Mertens"); // 23
99     addPlayer("James Rodríguez"); // 24
100     addPlayer("Paulo Dybala"); // 25
101     addPlayer("Christian Eriksen"); // 26
102     addPlayer("David Silva"); // 27
103     addPlayer("Gabriel Jesus"); // 28
104     addPlayer("Thiago"); // 29
105     addPlayer("Thibaut Courtois"); // 30
106     addPlayer("Philippe Coutinho"); // 31
107     addPlayer("Andrés Iniesta"); // 32
108     addPlayer("Casemiro"); // 33
109     addPlayer("Romelu Lukaku"); // 34
110     addPlayer("Gerard Piqué"); // 35
111     addPlayer("Mats Hummels"); // 36
112     addPlayer("Diego Godín"); // 37
113     addPlayer("Mesut Özil"); // 38
114     addPlayer("Son Heung-min"); // 39
115     addPlayer("Raheem Sterling"); // 40
116     addPlayer("Hugo Lloris"); // 41
117     addPlayer("Radamel Falcao"); // 42
118     addPlayer("Ivan Rakitić"); // 43
119     addPlayer("Leroy Sané"); // 44
120     addPlayer("Roberto Firmino"); // 45
121     addPlayer("Sadio Mané"); // 46
122     addPlayer("Thomas Müller"); // 47
123     addPlayer("Dele Alli"); // 48
124     addPlayer("Keylor Navas"); // 49
125     addPlayer("Thiago Silva"); // 50
126     addPlayer("Raphaël Varane"); // 51
127     addPlayer("Ángel Di María"); // 52
128     addPlayer("Jordi Alba"); // 53
129     addPlayer("Medhi Benatia"); // 54
130     addPlayer("Timo Werner"); // 55
131     addPlayer("Gylfi Sigurðsson"); // 56
132     addPlayer("Nemanja Matić"); // 57
133     addPlayer("Kalidou Koulibaly"); // 58
134     addPlayer("Bernardo Silva"); // 59
135     addPlayer("Vincent Kompany"); // 60
136     addPlayer("João Moutinho"); // 61
137     addPlayer("Toby Alderweireld"); // 62
138     addPlayer("Emil Forsberg"); // 63
139     addPlayer("Mario Mandžukić"); // 64
140     addPlayer("Sergej Milinković-Savić"); // 65
141     addPlayer("Shinji Kagawa"); // 66
142     addPlayer("Granit Xhaka"); // 67
143     addPlayer("Andreas Christensen"); // 68
144     addPlayer("Piotr Zieliński"); // 69
145     addPlayer("Fyodor Smolov"); // 70
146     addPlayer("Xherdan Shaqiri"); // 71
147     addPlayer("Marcus Rashford"); // 72
148     addPlayer("Javier Hernández"); // 73
149     addPlayer("Hirving Lozano"); // 74
150     addPlayer("Hakim Ziyech"); // 75
151     addPlayer("Victor Moses"); // 76
152     addPlayer("Jefferson Farfán"); // 77
153     addPlayer("Mohamed Elneny"); // 78
154     addPlayer("Marcus Berg"); // 79
155     addPlayer("Guillermo Ochoa"); // 80
156     addPlayer("Igor Akinfeev"); // 81
157     addPlayer("Sardar Azmoun"); // 82
158     addPlayer("Christian Cueva"); // 83
159     addPlayer("Wahbi Khazri"); // 84
160     addPlayer("Keisuke Honda"); // 85
161     addPlayer("Tim Cahill"); // 86
162     addPlayer("John Obi Mikel"); // 87
163     addPlayer("Ki Sung-yueng"); // 88
164     addPlayer("Bryan Ruiz"); // 89
165     addPlayer("Maya Yoshida"); // 90
166     addPlayer("Nawaf Al Abed"); // 91
167     addPlayer("Lee Chung-yong"); // 92
168     addPlayer("Gabriel Gómez"); // 93
169     addPlayer("Naïm Sliti"); // 94
170     addPlayer("Reza Ghoochannejhad"); // 95
171     addPlayer("Mile Jedinak"); // 96
172     addPlayer("Mohammad Al-Sahlawi"); // 97
173     addPlayer("Aron Gunnarsson"); // 98
174     addPlayer("Blas Pérez"); // 99
175     addPlayer("Dani Alves"); // 100
176     addPlayer("Zlatan Ibrahimović"); // 101
177   }
178 
179   /// @dev Fires an event, proving that we said a player corresponds to a given ID.
180   /// @param _name The name of the player we are adding.
181   function addPlayer(string _name) public onlyOwner {
182     require(playerCount < 255, "You've already added the maximum amount of players.");
183     emit PlayerAdded(playerCount, _name);
184     playerCount++;
185   }
186 }
187 
188 
189 /// @title The contract that manages checklist items, sets, and rarity tiers.
190 /// @author The CryptoStrikers Team
191 contract StrikersChecklist is StrikersPlayerList {
192   // High level overview of everything going on in this contract:
193   //
194   // ChecklistItem is the parent class to Card and has 3 properties:
195   //  - uint8 checklistId (000 to 255)
196   //  - uint8 playerId (see StrikersPlayerList.sol)
197   //  - RarityTier tier (more info below)
198   //
199   // Two things to note: the checklistId is not explicitly stored
200   // on the checklistItem struct, and it's composed of two parts.
201   // (For the following, assume it is left padded with zeros to reach
202   // three digits, such that checklistId 0 becomes 000)
203   //  - the first digit represents the setId
204   //      * 0 = Originals Set
205   //      * 1 = Iconics Set
206   //      * 2 = Unreleased Set
207   //  - the last two digits represent its index in the appropriate set arary
208   //
209   //  For example, checklist ID 100 would represent fhe first checklist item
210   //  in the iconicChecklistItems array (first digit = 1 = Iconics Set, last two
211   //  digits = 00 = first index of array)
212   //
213   // Because checklistId is represented as a uint8 throughout the app, the highest
214   // value it can take is 255, which means we can't add more than 56 items to our
215   // Unreleased Set's unreleasedChecklistItems array (setId 2). Also, once we've initialized
216   // this contract, it's impossible for us to add more checklist items to the Originals
217   // and Iconics set -- what you see here is what you get.
218   //
219   // Simple enough right?
220 
221   /// @dev We initialize this contract with so much data that we have
222   ///   to stage it in 4 different steps, ~33 checklist items at a time.
223   enum DeployStep {
224     WaitingForStepOne,
225     WaitingForStepTwo,
226     WaitingForStepThree,
227     WaitingForStepFour,
228     DoneInitialDeploy
229   }
230 
231   /// @dev Enum containing all our rarity tiers, just because
232   ///   it's cleaner dealing with these values than with uint8s.
233   enum RarityTier {
234     IconicReferral,
235     IconicInsert,
236     Diamond,
237     Gold,
238     Silver,
239     Bronze
240   }
241 
242   /// @dev A lookup table indicating how limited the cards
243   ///   in each tier are. If this value is 0, it means
244   ///   that cards of this rarity tier are unlimited,
245   ///   which is only the case for the 8 Iconics cards
246   ///   we give away as part of our referral program.
247   uint16[] public tierLimits = [
248     0,    // Iconic - Referral Bonus (uncapped)
249     100,  // Iconic Inserts ("Card of the Day")
250     1000, // Diamond
251     1664, // Gold
252     3328, // Silver
253     4352  // Bronze
254   ];
255 
256   /// @dev ChecklistItem is essentially the parent class to Card.
257   ///   It represents a given superclass of cards (eg Originals Messi),
258   ///   and then each Card is an instance of this ChecklistItem, with
259   ///   its own serial number, mint date, etc.
260   struct ChecklistItem {
261     uint8 playerId;
262     RarityTier tier;
263   }
264 
265   /// @dev The deploy step we're at. Defaults to WaitingForStepOne.
266   DeployStep public deployStep;
267 
268   /// @dev Array containing all the Originals checklist items (000 - 099)
269   ChecklistItem[] public originalChecklistItems;
270 
271   /// @dev Array containing all the Iconics checklist items (100 - 131)
272   ChecklistItem[] public iconicChecklistItems;
273 
274   /// @dev Array containing all the unreleased checklist items (200 - 255 max)
275   ChecklistItem[] public unreleasedChecklistItems;
276 
277   /// @dev Internal function to add a checklist item to the Originals set.
278   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
279   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
280   function _addOriginalChecklistItem(uint8 _playerId, RarityTier _tier) internal {
281     originalChecklistItems.push(ChecklistItem({
282       playerId: _playerId,
283       tier: _tier
284     }));
285   }
286 
287   /// @dev Internal function to add a checklist item to the Iconics set.
288   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
289   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
290   function _addIconicChecklistItem(uint8 _playerId, RarityTier _tier) internal {
291     iconicChecklistItems.push(ChecklistItem({
292       playerId: _playerId,
293       tier: _tier
294     }));
295   }
296 
297   /// @dev External function to add a checklist item to our mystery set.
298   ///   Must have completed initial deploy, and can't add more than 56 items (because checklistId is a uint8).
299   /// @param _playerId The player represented by this checklist item. (see StrikersPlayerList.sol)
300   /// @param _tier This checklist item's rarity tier. (see Rarity Tier enum and corresponding tierLimits)
301   function addUnreleasedChecklistItem(uint8 _playerId, RarityTier _tier) external onlyOwner {
302     require(deployStep == DeployStep.DoneInitialDeploy, "Finish deploying the Originals and Iconics sets first.");
303     require(unreleasedCount() < 56, "You can't add any more checklist items.");
304     require(_playerId < playerCount, "This player doesn't exist in our player list.");
305     unreleasedChecklistItems.push(ChecklistItem({
306       playerId: _playerId,
307       tier: _tier
308     }));
309   }
310 
311   /// @dev Returns how many Original checklist items we've added.
312   function originalsCount() external view returns (uint256) {
313     return originalChecklistItems.length;
314   }
315 
316   /// @dev Returns how many Iconic checklist items we've added.
317   function iconicsCount() public view returns (uint256) {
318     return iconicChecklistItems.length;
319   }
320 
321   /// @dev Returns how many Unreleased checklist items we've added.
322   function unreleasedCount() public view returns (uint256) {
323     return unreleasedChecklistItems.length;
324   }
325 
326   // In the next four functions, we initialize this contract with our
327   // 132 initial checklist items (100 Originals, 32 Iconics). Because
328   // of how much data we need to store, it has to be broken up into
329   // four different function calls, which need to be called in sequence.
330   // The ordering of the checklist items we add determines their
331   // checklist ID, which is left-padded in our frontend to be a
332   // 3-digit identifier where the first digit is the setId and the last
333   // 2 digits represents the checklist items index in the appropriate ___ChecklistItems array.
334   // For example, Originals Messi is the first item for set ID 0, and this
335   // is displayed as #000 throughout the app. Our Card struct declare its
336   // checklistId property as uint8, so we have
337   // to be mindful that we can only have 256 total checklist items.
338 
339   /// @dev Deploys Originals #000 through #032.
340   function deployStepOne() external onlyOwner {
341     require(deployStep == DeployStep.WaitingForStepOne, "You're not following the steps in order...");
342 
343     /* ORIGINALS - DIAMOND */
344     _addOriginalChecklistItem(0, RarityTier.Diamond); // 000 Messi
345     _addOriginalChecklistItem(1, RarityTier.Diamond); // 001 Ronaldo
346     _addOriginalChecklistItem(2, RarityTier.Diamond); // 002 Neymar
347     _addOriginalChecklistItem(3, RarityTier.Diamond); // 003 Salah
348 
349     /* ORIGINALS - GOLD */
350     _addOriginalChecklistItem(4, RarityTier.Gold); // 004 Lewandowski
351     _addOriginalChecklistItem(5, RarityTier.Gold); // 005 De Bruyne
352     _addOriginalChecklistItem(6, RarityTier.Gold); // 006 Modrić
353     _addOriginalChecklistItem(7, RarityTier.Gold); // 007 Hazard
354     _addOriginalChecklistItem(8, RarityTier.Gold); // 008 Ramos
355     _addOriginalChecklistItem(9, RarityTier.Gold); // 009 Kroos
356     _addOriginalChecklistItem(10, RarityTier.Gold); // 010 Suárez
357     _addOriginalChecklistItem(11, RarityTier.Gold); // 011 Kane
358     _addOriginalChecklistItem(12, RarityTier.Gold); // 012 Agüero
359     _addOriginalChecklistItem(13, RarityTier.Gold); // 013 Mbappé
360     _addOriginalChecklistItem(14, RarityTier.Gold); // 014 Higuaín
361     _addOriginalChecklistItem(15, RarityTier.Gold); // 015 de Gea
362     _addOriginalChecklistItem(16, RarityTier.Gold); // 016 Griezmann
363     _addOriginalChecklistItem(17, RarityTier.Gold); // 017 Kanté
364     _addOriginalChecklistItem(18, RarityTier.Gold); // 018 Cavani
365     _addOriginalChecklistItem(19, RarityTier.Gold); // 019 Pogba
366 
367     /* ORIGINALS - SILVER (020 to 032) */
368     _addOriginalChecklistItem(20, RarityTier.Silver); // 020 Isco
369     _addOriginalChecklistItem(21, RarityTier.Silver); // 021 Marcelo
370     _addOriginalChecklistItem(22, RarityTier.Silver); // 022 Neuer
371     _addOriginalChecklistItem(23, RarityTier.Silver); // 023 Mertens
372     _addOriginalChecklistItem(24, RarityTier.Silver); // 024 James
373     _addOriginalChecklistItem(25, RarityTier.Silver); // 025 Dybala
374     _addOriginalChecklistItem(26, RarityTier.Silver); // 026 Eriksen
375     _addOriginalChecklistItem(27, RarityTier.Silver); // 027 David Silva
376     _addOriginalChecklistItem(28, RarityTier.Silver); // 028 Gabriel Jesus
377     _addOriginalChecklistItem(29, RarityTier.Silver); // 029 Thiago
378     _addOriginalChecklistItem(30, RarityTier.Silver); // 030 Courtois
379     _addOriginalChecklistItem(31, RarityTier.Silver); // 031 Coutinho
380     _addOriginalChecklistItem(32, RarityTier.Silver); // 032 Iniesta
381 
382     // Move to the next deploy step.
383     deployStep = DeployStep.WaitingForStepTwo;
384   }
385 
386   /// @dev Deploys Originals #033 through #065.
387   function deployStepTwo() external onlyOwner {
388     require(deployStep == DeployStep.WaitingForStepTwo, "You're not following the steps in order...");
389 
390     /* ORIGINALS - SILVER (033 to 049) */
391     _addOriginalChecklistItem(33, RarityTier.Silver); // 033 Casemiro
392     _addOriginalChecklistItem(34, RarityTier.Silver); // 034 Lukaku
393     _addOriginalChecklistItem(35, RarityTier.Silver); // 035 Piqué
394     _addOriginalChecklistItem(36, RarityTier.Silver); // 036 Hummels
395     _addOriginalChecklistItem(37, RarityTier.Silver); // 037 Godín
396     _addOriginalChecklistItem(38, RarityTier.Silver); // 038 Özil
397     _addOriginalChecklistItem(39, RarityTier.Silver); // 039 Son
398     _addOriginalChecklistItem(40, RarityTier.Silver); // 040 Sterling
399     _addOriginalChecklistItem(41, RarityTier.Silver); // 041 Lloris
400     _addOriginalChecklistItem(42, RarityTier.Silver); // 042 Falcao
401     _addOriginalChecklistItem(43, RarityTier.Silver); // 043 Rakitić
402     _addOriginalChecklistItem(44, RarityTier.Silver); // 044 Sané
403     _addOriginalChecklistItem(45, RarityTier.Silver); // 045 Firmino
404     _addOriginalChecklistItem(46, RarityTier.Silver); // 046 Mané
405     _addOriginalChecklistItem(47, RarityTier.Silver); // 047 Müller
406     _addOriginalChecklistItem(48, RarityTier.Silver); // 048 Alli
407     _addOriginalChecklistItem(49, RarityTier.Silver); // 049 Navas
408 
409     /* ORIGINALS - BRONZE (050 to 065) */
410     _addOriginalChecklistItem(50, RarityTier.Bronze); // 050 Thiago Silva
411     _addOriginalChecklistItem(51, RarityTier.Bronze); // 051 Varane
412     _addOriginalChecklistItem(52, RarityTier.Bronze); // 052 Di María
413     _addOriginalChecklistItem(53, RarityTier.Bronze); // 053 Alba
414     _addOriginalChecklistItem(54, RarityTier.Bronze); // 054 Benatia
415     _addOriginalChecklistItem(55, RarityTier.Bronze); // 055 Werner
416     _addOriginalChecklistItem(56, RarityTier.Bronze); // 056 Sigurðsson
417     _addOriginalChecklistItem(57, RarityTier.Bronze); // 057 Matić
418     _addOriginalChecklistItem(58, RarityTier.Bronze); // 058 Koulibaly
419     _addOriginalChecklistItem(59, RarityTier.Bronze); // 059 Bernardo Silva
420     _addOriginalChecklistItem(60, RarityTier.Bronze); // 060 Kompany
421     _addOriginalChecklistItem(61, RarityTier.Bronze); // 061 Moutinho
422     _addOriginalChecklistItem(62, RarityTier.Bronze); // 062 Alderweireld
423     _addOriginalChecklistItem(63, RarityTier.Bronze); // 063 Forsberg
424     _addOriginalChecklistItem(64, RarityTier.Bronze); // 064 Mandžukić
425     _addOriginalChecklistItem(65, RarityTier.Bronze); // 065 Milinković-Savić
426 
427     // Move to the next deploy step.
428     deployStep = DeployStep.WaitingForStepThree;
429   }
430 
431   /// @dev Deploys Originals #066 through #099.
432   function deployStepThree() external onlyOwner {
433     require(deployStep == DeployStep.WaitingForStepThree, "You're not following the steps in order...");
434 
435     /* ORIGINALS - BRONZE (066 to 099) */
436     _addOriginalChecklistItem(66, RarityTier.Bronze); // 066 Kagawa
437     _addOriginalChecklistItem(67, RarityTier.Bronze); // 067 Xhaka
438     _addOriginalChecklistItem(68, RarityTier.Bronze); // 068 Christensen
439     _addOriginalChecklistItem(69, RarityTier.Bronze); // 069 Zieliński
440     _addOriginalChecklistItem(70, RarityTier.Bronze); // 070 Smolov
441     _addOriginalChecklistItem(71, RarityTier.Bronze); // 071 Shaqiri
442     _addOriginalChecklistItem(72, RarityTier.Bronze); // 072 Rashford
443     _addOriginalChecklistItem(73, RarityTier.Bronze); // 073 Hernández
444     _addOriginalChecklistItem(74, RarityTier.Bronze); // 074 Lozano
445     _addOriginalChecklistItem(75, RarityTier.Bronze); // 075 Ziyech
446     _addOriginalChecklistItem(76, RarityTier.Bronze); // 076 Moses
447     _addOriginalChecklistItem(77, RarityTier.Bronze); // 077 Farfán
448     _addOriginalChecklistItem(78, RarityTier.Bronze); // 078 Elneny
449     _addOriginalChecklistItem(79, RarityTier.Bronze); // 079 Berg
450     _addOriginalChecklistItem(80, RarityTier.Bronze); // 080 Ochoa
451     _addOriginalChecklistItem(81, RarityTier.Bronze); // 081 Akinfeev
452     _addOriginalChecklistItem(82, RarityTier.Bronze); // 082 Azmoun
453     _addOriginalChecklistItem(83, RarityTier.Bronze); // 083 Cueva
454     _addOriginalChecklistItem(84, RarityTier.Bronze); // 084 Khazri
455     _addOriginalChecklistItem(85, RarityTier.Bronze); // 085 Honda
456     _addOriginalChecklistItem(86, RarityTier.Bronze); // 086 Cahill
457     _addOriginalChecklistItem(87, RarityTier.Bronze); // 087 Mikel
458     _addOriginalChecklistItem(88, RarityTier.Bronze); // 088 Sung-yueng
459     _addOriginalChecklistItem(89, RarityTier.Bronze); // 089 Ruiz
460     _addOriginalChecklistItem(90, RarityTier.Bronze); // 090 Yoshida
461     _addOriginalChecklistItem(91, RarityTier.Bronze); // 091 Al Abed
462     _addOriginalChecklistItem(92, RarityTier.Bronze); // 092 Chung-yong
463     _addOriginalChecklistItem(93, RarityTier.Bronze); // 093 Gómez
464     _addOriginalChecklistItem(94, RarityTier.Bronze); // 094 Sliti
465     _addOriginalChecklistItem(95, RarityTier.Bronze); // 095 Ghoochannejhad
466     _addOriginalChecklistItem(96, RarityTier.Bronze); // 096 Jedinak
467     _addOriginalChecklistItem(97, RarityTier.Bronze); // 097 Al-Sahlawi
468     _addOriginalChecklistItem(98, RarityTier.Bronze); // 098 Gunnarsson
469     _addOriginalChecklistItem(99, RarityTier.Bronze); // 099 Pérez
470 
471     // Move to the next deploy step.
472     deployStep = DeployStep.WaitingForStepFour;
473   }
474 
475   /// @dev Deploys all Iconics and marks the deploy as complete!
476   function deployStepFour() external onlyOwner {
477     require(deployStep == DeployStep.WaitingForStepFour, "You're not following the steps in order...");
478 
479     /* ICONICS */
480     _addIconicChecklistItem(0, RarityTier.IconicInsert); // 100 Messi
481     _addIconicChecklistItem(1, RarityTier.IconicInsert); // 101 Ronaldo
482     _addIconicChecklistItem(2, RarityTier.IconicInsert); // 102 Neymar
483     _addIconicChecklistItem(3, RarityTier.IconicInsert); // 103 Salah
484     _addIconicChecklistItem(4, RarityTier.IconicInsert); // 104 Lewandowski
485     _addIconicChecklistItem(5, RarityTier.IconicInsert); // 105 De Bruyne
486     _addIconicChecklistItem(6, RarityTier.IconicInsert); // 106 Modrić
487     _addIconicChecklistItem(7, RarityTier.IconicInsert); // 107 Hazard
488     _addIconicChecklistItem(8, RarityTier.IconicInsert); // 108 Ramos
489     _addIconicChecklistItem(9, RarityTier.IconicInsert); // 109 Kroos
490     _addIconicChecklistItem(10, RarityTier.IconicInsert); // 110 Suárez
491     _addIconicChecklistItem(11, RarityTier.IconicInsert); // 111 Kane
492     _addIconicChecklistItem(12, RarityTier.IconicInsert); // 112 Agüero
493     _addIconicChecklistItem(15, RarityTier.IconicInsert); // 113 de Gea
494     _addIconicChecklistItem(16, RarityTier.IconicInsert); // 114 Griezmann
495     _addIconicChecklistItem(17, RarityTier.IconicReferral); // 115 Kanté
496     _addIconicChecklistItem(18, RarityTier.IconicReferral); // 116 Cavani
497     _addIconicChecklistItem(19, RarityTier.IconicInsert); // 117 Pogba
498     _addIconicChecklistItem(21, RarityTier.IconicInsert); // 118 Marcelo
499     _addIconicChecklistItem(24, RarityTier.IconicInsert); // 119 James
500     _addIconicChecklistItem(26, RarityTier.IconicInsert); // 120 Eriksen
501     _addIconicChecklistItem(29, RarityTier.IconicReferral); // 121 Thiago
502     _addIconicChecklistItem(36, RarityTier.IconicReferral); // 122 Hummels
503     _addIconicChecklistItem(38, RarityTier.IconicReferral); // 123 Özil
504     _addIconicChecklistItem(39, RarityTier.IconicInsert); // 124 Son
505     _addIconicChecklistItem(46, RarityTier.IconicInsert); // 125 Mané
506     _addIconicChecklistItem(48, RarityTier.IconicInsert); // 126 Alli
507     _addIconicChecklistItem(49, RarityTier.IconicReferral); // 127 Navas
508     _addIconicChecklistItem(73, RarityTier.IconicInsert); // 128 Hernández
509     _addIconicChecklistItem(85, RarityTier.IconicInsert); // 129 Honda
510     _addIconicChecklistItem(100, RarityTier.IconicReferral); // 130 Alves
511     _addIconicChecklistItem(101, RarityTier.IconicReferral); // 131 Zlatan
512 
513     // Mark the initial deploy as complete.
514     deployStep = DeployStep.DoneInitialDeploy;
515   }
516 
517   /// @dev Returns the mint limit for a given checklist item, based on its tier.
518   /// @param _checklistId Which checklist item we need to get the limit for.
519   /// @return How much of this checklist item we are allowed to mint.
520   function limitForChecklistId(uint8 _checklistId) external view returns (uint16) {
521     RarityTier rarityTier;
522     uint8 index;
523     if (_checklistId < 100) { // Originals = #000 to #099
524       rarityTier = originalChecklistItems[_checklistId].tier;
525     } else if (_checklistId < 200) { // Iconics = #100 to #131
526       index = _checklistId - 100;
527       require(index < iconicsCount(), "This Iconics checklist item doesn't exist.");
528       rarityTier = iconicChecklistItems[index].tier;
529     } else { // Unreleased = #200 to max #255
530       index = _checklistId - 200;
531       require(index < unreleasedCount(), "This Unreleased checklist item doesn't exist.");
532       rarityTier = unreleasedChecklistItems[index].tier;
533     }
534     return tierLimits[uint8(rarityTier)];
535   }
536 }