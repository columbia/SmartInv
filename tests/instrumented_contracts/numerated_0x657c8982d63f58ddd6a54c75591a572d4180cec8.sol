1 pragma solidity 0.4.24;
2 
3 contract Governable {
4 
5     event Pause();
6     event Unpause();
7 
8     address public governor;
9     bool public paused = false;
10 
11     constructor() public {
12         governor = msg.sender;
13     }
14 
15     function setGovernor(address _gov) public onlyGovernor {
16         governor = _gov;
17     }
18 
19     modifier onlyGovernor {
20         require(msg.sender == governor);
21         _;
22     }
23 
24     /**
25     * @dev Modifier to make a function callable only when the contract is not paused.
26     */
27     modifier whenNotPaused() {
28         require(!paused);
29         _;
30     }
31 
32     /**
33     * @dev Modifier to make a function callable only when the contract is paused.
34     */
35     modifier whenPaused() {
36         require(paused);
37         _;
38     }
39 
40     /**
41     * @dev called by the owner to pause, triggers stopped state
42     */
43     function pause() onlyGovernor whenNotPaused public {
44         paused = true;
45         emit Pause();
46     }
47 
48     /**
49     * @dev called by the owner to unpause, returns to normal state
50     */
51     function unpause() onlyGovernor whenPaused public {
52         paused = false;
53         emit Unpause();
54     }
55 
56 }
57 
58 contract Ownable {
59 
60     address public owner;
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     function setOwner(address _owner) public onlyOwner {
67         owner = _owner;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75 }
76 
77 contract Pausable is Ownable {
78     
79     event Pause();
80     event Unpause();
81 
82     bool public paused = false;
83 
84 
85     /**
86     * @dev Modifier to make a function callable only when the contract is not paused.
87     */
88     modifier whenNotPaused() {
89         require(!paused);
90         _;
91     }
92 
93     /**
94     * @dev Modifier to make a function callable only when the contract is paused.
95     */
96     modifier whenPaused() {
97         require(paused);
98         _;
99     }
100 
101     /**
102     * @dev called by the owner to pause, triggers stopped state
103     */
104     function pause() onlyOwner whenNotPaused public {
105         paused = true;
106         emit Pause();
107     }
108 
109     /**
110     * @dev called by the owner to unpause, returns to normal state
111     */
112     function unpause() onlyOwner whenPaused public {
113         paused = false;
114         emit Unpause();
115     }
116 }
117 
118 contract CardBase is Governable {
119 
120 
121     struct Card {
122         uint16 proto;
123         uint16 purity;
124     }
125 
126     function getCard(uint id) public view returns (uint16 proto, uint16 purity) {
127         Card memory card = cards[id];
128         return (card.proto, card.purity);
129     }
130 
131     function getShine(uint16 purity) public pure returns (uint8) {
132         return uint8(purity / 1000);
133     }
134 
135     Card[] public cards;
136     
137 }
138 
139 contract CardProto is CardBase {
140 
141     event NewProtoCard(
142         uint16 id, uint8 season, uint8 god, 
143         Rarity rarity, uint8 mana, uint8 attack, 
144         uint8 health, uint8 cardType, uint8 tribe, bool packable
145     );
146 
147     struct Limit {
148         uint64 limit;
149         bool exists;
150     }
151 
152     // limits for mythic cards
153     mapping(uint16 => Limit) public limits;
154 
155     // can only set limits once
156     function setLimit(uint16 id, uint64 limit) public onlyGovernor {
157         Limit memory l = limits[id];
158         require(!l.exists);
159         limits[id] = Limit({
160             limit: limit,
161             exists: true
162         });
163     }
164 
165     function getLimit(uint16 id) public view returns (uint64 limit, bool set) {
166         Limit memory l = limits[id];
167         return (l.limit, l.exists);
168     }
169 
170     // could make these arrays to save gas
171     // not really necessary - will be update a very limited no of times
172     mapping(uint8 => bool) public seasonTradable;
173     mapping(uint8 => bool) public seasonTradabilityLocked;
174     uint8 public currentSeason;
175 
176     function makeTradable(uint8 season) public onlyGovernor {
177         seasonTradable[season] = true;
178     }
179 
180     function makeUntradable(uint8 season) public onlyGovernor {
181         require(!seasonTradabilityLocked[season]);
182         seasonTradable[season] = false;
183     }
184 
185     function makePermanantlyTradable(uint8 season) public onlyGovernor {
186         require(seasonTradable[season]);
187         seasonTradabilityLocked[season] = true;
188     }
189 
190     function isTradable(uint16 proto) public view returns (bool) {
191         return seasonTradable[protos[proto].season];
192     }
193 
194     function nextSeason() public onlyGovernor {
195         //Seasons shouldn't go to 0 if there is more than the uint8 should hold, the governor should know this ¯\_(ツ)_/¯ -M
196         require(currentSeason <= 255); 
197 
198         currentSeason++;
199         mythic.length = 0;
200         legendary.length = 0;
201         epic.length = 0;
202         rare.length = 0;
203         common.length = 0;
204     }
205 
206     enum Rarity {
207         Common,
208         Rare,
209         Epic,
210         Legendary, 
211         Mythic
212     }
213 
214     uint8 constant SPELL = 1;
215     uint8 constant MINION = 2;
216     uint8 constant WEAPON = 3;
217     uint8 constant HERO = 4;
218 
219     struct ProtoCard {
220         bool exists;
221         uint8 god;
222         uint8 season;
223         uint8 cardType;
224         Rarity rarity;
225         uint8 mana;
226         uint8 attack;
227         uint8 health;
228         uint8 tribe;
229     }
230 
231     // there is a particular design decision driving this:
232     // need to be able to iterate over mythics only for card generation
233     // don't store 5 different arrays: have to use 2 ids
234     // better to bear this cost (2 bytes per proto card)
235     // rather than 1 byte per instance
236 
237     uint16 public protoCount;
238     
239     mapping(uint16 => ProtoCard) protos;
240 
241     uint16[] public mythic;
242     uint16[] public legendary;
243     uint16[] public epic;
244     uint16[] public rare;
245     uint16[] public common;
246 
247     function addProtos(
248         uint16[] externalIDs, uint8[] gods, Rarity[] rarities, uint8[] manas, uint8[] attacks, 
249         uint8[] healths, uint8[] cardTypes, uint8[] tribes, bool[] packable
250     ) public onlyGovernor returns(uint16) {
251 
252         for (uint i = 0; i < externalIDs.length; i++) {
253 
254             ProtoCard memory card = ProtoCard({
255                 exists: true,
256                 god: gods[i],
257                 season: currentSeason,
258                 cardType: cardTypes[i],
259                 rarity: rarities[i],
260                 mana: manas[i],
261                 attack: attacks[i],
262                 health: healths[i],
263                 tribe: tribes[i]
264             });
265 
266             _addProto(externalIDs[i], card, packable[i]);
267         }
268         
269     }
270 
271     function addProto(
272         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 cardType, uint8 tribe, bool packable
273     ) public onlyGovernor returns(uint16) {
274         ProtoCard memory card = ProtoCard({
275             exists: true,
276             god: god,
277             season: currentSeason,
278             cardType: cardType,
279             rarity: rarity,
280             mana: mana,
281             attack: attack,
282             health: health,
283             tribe: tribe
284         });
285 
286         _addProto(externalID, card, packable);
287     }
288 
289     function addWeapon(
290         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 durability, bool packable
291     ) public onlyGovernor returns(uint16) {
292 
293         ProtoCard memory card = ProtoCard({
294             exists: true,
295             god: god,
296             season: currentSeason,
297             cardType: WEAPON,
298             rarity: rarity,
299             mana: mana,
300             attack: attack,
301             health: durability,
302             tribe: 0
303         });
304 
305         _addProto(externalID, card, packable);
306     }
307 
308     function addSpell(uint16 externalID, uint8 god, Rarity rarity, uint8 mana, bool packable) public onlyGovernor returns(uint16) {
309 
310         ProtoCard memory card = ProtoCard({
311             exists: true,
312             god: god,
313             season: currentSeason,
314             cardType: SPELL,
315             rarity: rarity,
316             mana: mana,
317             attack: 0,
318             health: 0,
319             tribe: 0
320         });
321 
322         _addProto(externalID, card, packable);
323     }
324 
325     function addMinion(
326         uint16 externalID, uint8 god, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe, bool packable
327     ) public onlyGovernor returns(uint16) {
328 
329         ProtoCard memory card = ProtoCard({
330             exists: true,
331             god: god,
332             season: currentSeason,
333             cardType: MINION,
334             rarity: rarity,
335             mana: mana,
336             attack: attack,
337             health: health,
338             tribe: tribe
339         });
340 
341         _addProto(externalID, card, packable);
342     }
343 
344     function _addProto(uint16 externalID, ProtoCard memory card, bool packable) internal {
345 
346         require(!protos[externalID].exists);
347 
348         card.exists = true;
349 
350         protos[externalID] = card;
351 
352         protoCount++;
353 
354         emit NewProtoCard(
355             externalID, currentSeason, card.god, 
356             card.rarity, card.mana, card.attack, 
357             card.health, card.cardType, card.tribe, packable
358         );
359 
360         if (packable) {
361             Rarity rarity = card.rarity;
362             if (rarity == Rarity.Common) {
363                 common.push(externalID);
364             } else if (rarity == Rarity.Rare) {
365                 rare.push(externalID);
366             } else if (rarity == Rarity.Epic) {
367                 epic.push(externalID);
368             } else if (rarity == Rarity.Legendary) {
369                 legendary.push(externalID);
370             } else if (rarity == Rarity.Mythic) {
371                 mythic.push(externalID);
372             } else {
373                 require(false);
374             }
375         }
376     }
377 
378     function getProto(uint16 id) public view returns(
379         bool exists, uint8 god, uint8 season, uint8 cardType, Rarity rarity, uint8 mana, uint8 attack, uint8 health, uint8 tribe
380     ) {
381         ProtoCard memory proto = protos[id];
382         return (
383             proto.exists,
384             proto.god,
385             proto.season,
386             proto.cardType,
387             proto.rarity,
388             proto.mana,
389             proto.attack,
390             proto.health,
391             proto.tribe
392         );
393     }
394 
395     function getRandomCard(Rarity rarity, uint16 random) public view returns (uint16) {
396         // modulo bias is fine - creates rarity tiers etc
397         // will obviously revert is there are no cards of that type: this is expected - should never happen
398         if (rarity == Rarity.Common) {
399             return common[random % common.length];
400         } else if (rarity == Rarity.Rare) {
401             return rare[random % rare.length];
402         } else if (rarity == Rarity.Epic) {
403             return epic[random % epic.length];
404         } else if (rarity == Rarity.Legendary) {
405             return legendary[random % legendary.length];
406         } else if (rarity == Rarity.Mythic) {
407             // make sure a mythic is available
408             uint16 id;
409             uint64 limit;
410             bool set;
411             for (uint i = 0; i < mythic.length; i++) {
412                 id = mythic[(random + i) % mythic.length];
413                 (limit, set) = getLimit(id);
414                 if (set && limit > 0){
415                     return id;
416                 }
417             }
418             // if not, they get a legendary :(
419             return legendary[random % legendary.length];
420         }
421         require(false);
422         return 0;
423     }
424 
425     // can never adjust tradable cards
426     // each season gets a 'balancing beta'
427     // totally immutable: season, rarity
428     function replaceProto(
429         uint16 index, uint8 god, uint8 cardType, uint8 mana, uint8 attack, uint8 health, uint8 tribe
430     ) public onlyGovernor {
431         ProtoCard memory pc = protos[index];
432         require(!seasonTradable[pc.season]);
433         protos[index] = ProtoCard({
434             exists: true,
435             god: god,
436             season: pc.season,
437             cardType: cardType,
438             rarity: pc.rarity,
439             mana: mana,
440             attack: attack,
441             health: health,
442             tribe: tribe
443         });
444     }
445 
446 }
447 
448 contract MigrationInterface {
449 
450     function createCard(address user, uint16 proto, uint16 purity) public returns (uint);
451 
452     function getRandomCard(CardProto.Rarity rarity, uint16 random) public view returns (uint16);
453 
454     function migrate(uint id) public;
455 
456 }
457 
458 contract FirstPheonix is Pausable {
459 
460     MigrationInterface core;
461 
462     constructor(MigrationInterface _core) public {
463         core = _core;
464     }
465 
466     address[] public approved;
467 
468     uint16 PHEONIX_PROTO = 380;
469 
470     mapping(address => bool) public claimed;
471 
472     function approvePack(address toApprove) public onlyOwner {
473         approved.push(toApprove);
474     }
475 
476     function isApproved(address test) public view returns (bool) {
477         for (uint i = 0; i < approved.length; i++) {
478             if (approved[i] == test) {
479                 return true;
480             }
481         }
482         return false;
483     }
484 
485     // pause once cards become tradable
486     function claimPheonix(address user) public returns (bool){
487 
488         require(isApproved(msg.sender));
489 
490         if (claimed[user] || paused){
491             return false;
492         }
493 
494         claimed[user] = true;
495 
496         core.createCard(user, PHEONIX_PROTO, 0);
497 
498         return true;
499     }
500 
501 }