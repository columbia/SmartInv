1 pragma solidity ^0.4.24;
2 
3 library MathLib {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         c = a + b;
7         assert(c >= a);
8     }
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         assert(b <= a);
12         c = a - b;
13     }
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         if (a == 0 || b == 0) {
17             c = 0;
18         } else {
19             c = a * b;
20             assert(c / a == b);
21         }
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         c = a / b;
26     }
27 }
28 
29 interface IMultiOwnable {
30 
31     function owners() external view returns (address[]);
32     function transferOwnership(address newOwner) external;
33     function appointHeir(address heir) external;
34     function succeedOwner(address owner) external;
35 
36     event OwnershipTransfer(address indexed owner, address indexed newOwner);
37     event HeirAppointment(address indexed owner, address indexed heir);
38     event OwnershipSuccession(address indexed owner, address indexed heir);
39 }
40 
41 
42 library AddressLib {
43 
44     using AddressLib for AddressLib.Set;
45 
46     function isEmpty(address value) internal pure returns (bool) {
47         return value == address(0);
48     }
49 
50     function isSender(address value) internal view returns (bool) {
51         return value == msg.sender;
52     }
53 
54     struct Set {
55         address[] vals;
56         mapping(address => uint256) seqs;
57     }
58 
59     function values(Set storage set) internal view returns (address[]) {
60         return set.vals;
61     }
62 
63     function count(Set storage set) internal view returns (uint256) {
64         return set.vals.length;
65     }
66 
67     function first(Set storage set) internal view returns (address) {
68         require(set.count() > 0, "Set cannot be empty");
69 
70         return set.vals[0];
71     }
72 
73     function last(Set storage set) internal view returns (address) {
74         require(set.count() > 0, "Set cannot be empty");
75 
76         return set.vals[set.vals.length - 1];
77     }
78 
79     function contains(Set storage set, address value) internal view returns (bool) {
80         return set.seqs[value] > 0;
81     }
82 
83     function add(Set storage set, address value) internal {
84         if (!set.contains(value)) {
85             set.seqs[value] = set.vals.push(value);
86         }
87     }
88 
89     function remove(Set storage set, address value) internal {
90         if (set.contains(value)) {
91             uint256 seq = set.seqs[value];
92 
93             if (seq < set.count()) {
94                 address lastVal = set.last();
95 
96                 set.vals[seq - 1] = lastVal;
97                 set.seqs[lastVal] = seq;
98             }
99 
100             set.vals.length--;
101             set.seqs[value] = 0;
102         }
103     }
104 }
105 
106 
107 contract MultiOwnable is IMultiOwnable {
108 
109     using AddressLib for address;
110     using AddressLib for AddressLib.Set;
111 
112     AddressLib.Set private _owners;
113     mapping(address => address) private _heirs;
114 
115     modifier onlyOwner {
116         require(_owners.contains(msg.sender), "Only allowed for a owner");
117         _;
118     }
119 
120     constructor (address[] owners) internal {
121         for (uint256 i = 0; i < owners.length; i++) {
122             _owners.add(owners[i]);
123         }
124     }
125 
126     function owners() external view returns (address[]) {
127         return _owners.values();
128     }
129 
130     function transferOwnership(address newOwner) external onlyOwner {
131         _transferOwnership(msg.sender, newOwner);
132 
133         emit OwnershipTransfer(msg.sender, newOwner);
134     }
135 
136     function appointHeir(address heir) external onlyOwner {
137         _heirs[msg.sender] = heir;
138 
139         emit HeirAppointment(msg.sender, heir);
140     }
141 
142     function succeedOwner(address owner) external {
143         require(_heirs[owner].isSender(), "Only heir may succeed owner");
144 
145         _transferOwnership(owner, msg.sender);
146         
147         emit OwnershipSuccession(owner, msg.sender);
148     }
149 
150     function _transferOwnership(address owner, address newOwner) private {
151         _owners.remove(owner);
152         _owners.add(newOwner);
153         _heirs[owner] = address(0);
154     }
155 }
156 
157 
158 contract Geo {
159 
160     enum Class { District, Zone, Target }
161     enum Status { Locked, Unlocked, Owned }
162 
163     struct Area {
164         Class class;
165         Status status;
166         uint256 parent;
167         uint256[] siblings;
168         uint256[] children;
169         address owner;
170         uint256 cost;
171         uint256 unlockTime;
172     }
173 
174     mapping(uint256 => Area) internal areas;
175 
176     constructor () internal { }
177 
178     function initAreas() internal {
179         areas[0].class = Class.Target;
180 
181         areas[1].class = Class.District;
182         areas[1].parent = 46;
183         areas[1].siblings = [2,3];
184         areas[2].class = Class.District;
185         areas[2].parent = 46;
186         areas[2].siblings = [1,3];
187         areas[3].class = Class.District;
188         areas[3].parent = 46;
189         areas[3].siblings = [1,2,4,6,8,9,11,13];
190         areas[4].class = Class.District;
191         areas[4].parent = 46;
192         areas[4].siblings = [3,5,6,9];
193         areas[5].class = Class.District;
194         areas[5].parent = 46;
195         areas[5].siblings = [4,6,7,9,37,38,39,41];
196         areas[6].class = Class.District;
197         areas[6].parent = 46;
198         areas[6].siblings = [3,4,5,7,13,22];
199         areas[7].class = Class.District;
200         areas[7].parent = 46;
201         areas[7].siblings = [5,6,21,22,26,38];
202         areas[8].class = Class.District;
203         areas[8].parent = 46;
204 
205         areas[9].class = Class.District;
206         areas[9].parent = 47;
207         areas[9].siblings = [3,4,5,10,11,12,39,41];
208         areas[10].class = Class.District;
209         areas[10].parent = 47;
210         areas[10].siblings = [9,11,12];
211         areas[11].class = Class.District;
212         areas[11].parent = 47;
213         areas[11].siblings = [3,9,10,14];
214         areas[12].class = Class.District;
215         areas[12].parent = 47;
216         areas[12].siblings = [9,10];
217         areas[13].class = Class.District;
218         areas[13].parent = 47;
219         areas[13].siblings = [3,6,15,16,17,22];
220         areas[14].class = Class.District;
221         areas[14].parent = 47;
222         areas[15].class = Class.District;
223         areas[15].parent = 47;
224         areas[16].class = Class.District;
225         areas[16].parent = 47;
226 
227         areas[17].class = Class.District;
228         areas[17].parent = 48;
229         areas[17].siblings = [13,18,19,22,23];
230         areas[18].class = Class.District;
231         areas[18].parent = 48;
232         areas[18].siblings = [17,19];
233         areas[19].class = Class.District;
234         areas[19].parent = 48;
235         areas[19].siblings = [17,18,20,21,22,25];
236         areas[20].class = Class.District;
237         areas[20].parent = 48;
238         areas[20].siblings = [19,21,24,27];
239         areas[21].class = Class.District;
240         areas[21].parent = 48;
241         areas[21].siblings = [7,19,20,22,26,27];
242         areas[22].class = Class.District;
243         areas[22].parent = 48;
244         areas[22].siblings = [6,7,13,17,19,21];
245         areas[23].class = Class.District;
246         areas[23].parent = 48;
247         areas[24].class = Class.District;
248         areas[24].parent = 48;
249         areas[25].class = Class.District;
250         areas[25].parent = 48;
251 
252         areas[26].class = Class.District;
253         areas[26].parent = 49;
254         areas[26].siblings = [7,21,27,28,31,38];
255         areas[27].class = Class.District;
256         areas[27].parent = 49;
257         areas[27].siblings = [20,21,26,28,29,32,33,34,36];
258         areas[28].class = Class.District;
259         areas[28].parent = 49;
260         areas[28].siblings = [26,27,30,31,35];
261         areas[29].class = Class.District;
262         areas[29].parent = 49;
263         areas[29].siblings = [27];
264         areas[30].class = Class.District;
265         areas[30].parent = 49;
266         areas[30].siblings = [28,31,37,42];
267         areas[31].class = Class.District;
268         areas[31].parent = 49;
269         areas[31].siblings = [26,28,30,37,38];
270         areas[32].class = Class.District;
271         areas[32].parent = 49;
272         areas[32].siblings = [27];
273         areas[33].class = Class.District;
274         areas[33].parent = 49;
275         areas[33].siblings = [27];
276         areas[34].class = Class.District;
277         areas[34].parent = 49;
278         areas[35].class = Class.District;
279         areas[35].parent = 49;
280         areas[36].class = Class.District;
281         areas[36].parent = 49;
282 
283         areas[37].class = Class.District;
284         areas[37].parent = 50;
285         areas[37].siblings = [5,30,31,38,39,40,42,45];
286         areas[38].class = Class.District;
287         areas[38].parent = 50;
288         areas[38].siblings = [5,7,26,31,37];
289         areas[39].class = Class.District;
290         areas[39].parent = 50;
291         areas[39].siblings = [5,9,37,40,41,43,44];
292         areas[40].class = Class.District;
293         areas[40].parent = 50;
294         areas[40].siblings = [37,39,42,43];
295         areas[41].class = Class.District;
296         areas[41].parent = 50;
297         areas[41].siblings = [5,9,39];
298         areas[42].class = Class.District;
299         areas[42].parent = 50;
300         areas[42].siblings = [30,37,40,43];
301         areas[43].class = Class.District;
302         areas[43].parent = 50;
303         areas[43].siblings = [39,40,42];
304         areas[44].class = Class.District;
305         areas[44].parent = 50;
306         areas[45].class = Class.District;
307         areas[45].parent = 50;
308 
309         areas[46].class = Class.Zone;
310         areas[46].children = [1,2,3,4,5,6,7,8];
311         areas[47].class = Class.Zone;
312         areas[47].children = [9,10,11,12,13,14,15,16];
313         areas[48].class = Class.Zone;
314         areas[48].children = [17,18,19,20,21,22,23,24,25];
315         areas[49].class = Class.Zone;
316         areas[49].children = [26,27,28,29,30,31,32,33,34,35,36];
317         areas[50].class = Class.Zone;
318         areas[50].children = [37,38,39,40,41,42,43,44,45];
319     }
320 }
321 
322 
323 contract Configs {
324 
325     address[] internal GAME_MASTER_ADDRESSES = [
326         0xb855F909a562f65954687c9c4BC6695424f68885,
327         address(0),
328         address(0),
329         address(0),
330         address(0)
331     ];
332 
333     address internal constant ROYALTY_ADDRESS = 0xb855F909a562f65954687c9c4BC6695424f68885;
334 
335     uint256 internal constant AREA_COUNT = 51;
336     uint256 internal constant TARGET_AREA = 0;
337     uint256 internal constant SOURCE_AREA = 1;
338     uint256 internal constant ZONE_START = 46;
339     uint256 internal constant ZONE_COUNT = 5;
340 
341     uint256[][] internal UNLOCKED_CONFIGS = [
342         [uint256(1 * 10**10), 0, 0, 0, 5, 4],
343         [uint256(2 * 10**10), 0, 0, 0, 4, 3],
344         [uint256(3 * 10**10), 0, 0, 0, 3, 2]
345     ];
346 
347     uint256[][] internal OWNED_CONFIGS = [
348         [uint256(90), 2, 3, 5, 4],
349         [uint256(80), 0, 5, 4, 3],
350         [uint256(99), 0, 1, 3, 2]
351     ];
352 
353     uint256 internal constant DISTRICT_UNLOCK_TIME = 1 seconds;
354     uint256 internal constant ZONE_UNLOCK_TIME = 3 seconds;
355     uint256 internal constant TARGET_UNLOCK_TIME = 10 seconds;
356 
357     uint256 internal constant END_TIME_COUNTDOWN = 5 minutes;
358     uint256 internal constant DISTRICT_END_TIME_EXTENSION = 30 seconds;
359     uint256 internal constant ZONE_END_TIME_EXTENSION = 30 seconds;
360     uint256 internal constant TARGET_END_TIME_EXTENSION = 30 seconds;
361 
362     uint256 internal constant LAST_OWNER_SHARE = 55;
363     uint256 internal constant TARGET_OWNER_SHARE = 30;
364     uint256 internal constant SOURCE_OWNER_SHARE = 5;
365     uint256 internal constant ZONE_OWNERS_SHARE = 10;
366 }
367 
368 contract Main is Configs, Geo, MultiOwnable {
369 
370     using MathLib for uint256;
371 
372     uint256 private endTime;
373     uint256 private countdown;
374     address private lastOwner;
375 
376     event Settings(uint256 lastOwnerShare, uint256 targetOwnerShare, uint256 sourceOwnerShare, uint256 zoneOwnersShare);
377     event Summary(uint256 currentTime, uint256 endTime, uint256 prize, address lastOwner);
378     event Reset();
379     event Start();
380     event Finish();
381     event Unlock(address indexed player, uint256 indexed areaId, uint256 unlockTime);
382     event Acquisition(address indexed player, uint256 indexed areaId, uint256 price, uint256 newPrice);
383     event Post(address indexed player, uint256 indexed areaId, string message);
384     event Dub(address indexed player, string nickname);
385 
386     modifier onlyHuman {
387         uint256 codeSize;
388         address sender = msg.sender;
389         assembly { codeSize := extcodesize(sender) }
390 
391         require(sender == tx.origin, "Sorry, human only");
392         require(codeSize == 0, "Sorry, human only");
393 
394         _;
395     }
396 
397     constructor () public MultiOwnable(GAME_MASTER_ADDRESSES) { }
398 
399     function init() external onlyOwner {
400         require(countdown == 0 && endTime == 0, "Game has already been initialized");
401 
402         initAreas();
403         reset();
404 
405         emit Settings(LAST_OWNER_SHARE, TARGET_OWNER_SHARE, SOURCE_OWNER_SHARE, ZONE_OWNERS_SHARE);
406     }
407 
408     function start() external onlyOwner {
409         require(areas[SOURCE_AREA].status == Status.Locked, "Game has already started");
410 
411         areas[SOURCE_AREA].status = Status.Unlocked;
412 
413         emit Start();
414     }
415 
416     function finish() external onlyOwner {
417         require(endTime > 0 && now >= endTime, "Cannot end yet");
418 
419         uint256 unitValue = address(this).balance.div(100);
420         uint256 zoneValue = unitValue.mul(ZONE_OWNERS_SHARE).div(ZONE_COUNT);
421 
422         for (uint256 i = 0; i < ZONE_COUNT; i++) {
423             areas[ZONE_START.add(i)].owner.transfer(zoneValue);
424         }
425         lastOwner.transfer(unitValue.mul(LAST_OWNER_SHARE));
426         areas[TARGET_AREA].owner.transfer(unitValue.mul(TARGET_OWNER_SHARE));
427         areas[SOURCE_AREA].owner.transfer(unitValue.mul(SOURCE_OWNER_SHARE));
428 
429         emit Finish();
430 
431         for (i = 0; i < AREA_COUNT; i++) {
432             delete areas[i].cost;
433             delete areas[i].owner;
434             delete areas[i].status;
435             delete areas[i].unlockTime;
436         }
437         reset();
438     }
439 
440     function acquire(uint256 areaId) external payable onlyHuman {
441         //TODO: trigger special events within this function somewhere
442 
443         require(endTime == 0 || now < endTime, "Game has ended");
444 
445         Area storage area = areas[areaId];
446         if (area.status == Status.Unlocked) {
447             area.cost = getInitialCost(area);            
448         }
449 
450         require(area.status != Status.Locked, "Cannot acquire locked area");
451         require(area.unlockTime <= now, "Cannot acquire yet");
452         require(area.owner != msg.sender, "Cannot acquire already owned area");
453         require(area.cost == msg.value, "Incorrect value for acquiring this area");
454 
455         uint256 unitValue = msg.value.div(100);
456         uint256 ownerShare;
457         uint256 parentShare;
458         uint256 devShare;
459         uint256 inflationNum;
460         uint256 inflationDenom;
461         (ownerShare, parentShare, devShare, inflationNum, inflationDenom) = getConfigs(area);
462 
463         if (ownerShare > 0) {
464             area.owner.transfer(unitValue.mul(ownerShare));
465         }
466         if (parentShare > 0 && areas[area.parent].status == Status.Owned) {
467             areas[area.parent].owner.transfer(unitValue.mul(parentShare));
468         }
469         if (devShare > 0) {
470             ROYALTY_ADDRESS.transfer(unitValue.mul(devShare));
471         }
472 
473         area.cost = area.cost.mul(inflationNum).div(inflationDenom);
474         area.owner = msg.sender;
475         if (area.class != Class.Target) {
476             lastOwner = msg.sender;
477         }
478 
479         emit Acquisition(msg.sender, areaId, msg.value, area.cost);        
480 
481         if (area.status == Status.Unlocked) {
482             area.status = Status.Owned;
483             countdown = countdown.sub(1);
484 
485             if (area.class == Class.District) {
486                 tryUnlockSiblings(area);
487                 tryUnlockParent(area);
488             } else if (area.class == Class.Zone) {
489                 tryUnlockTarget();
490             } else if (area.class == Class.Target) {
491                 endTime = now.add(END_TIME_COUNTDOWN);
492             }
493         } else if (area.status == Status.Owned) {
494             if (endTime > 0) {
495                 if (area.class == Class.District) {
496                     endTime = endTime.add(DISTRICT_END_TIME_EXTENSION);
497                 } else if (area.class == Class.Zone) {
498                     endTime = endTime.add(ZONE_END_TIME_EXTENSION);
499                 } else if (area.class == Class.Target) {
500                     endTime = endTime.add(TARGET_END_TIME_EXTENSION);
501                 }
502             }
503 
504             if (endTime > now.add(END_TIME_COUNTDOWN)) {
505                 endTime = now.add(END_TIME_COUNTDOWN);
506             }
507         }
508 
509         emit Summary(now, endTime, address(this).balance, lastOwner);
510     }
511 
512     function post(uint256 areaId, string message) external onlyHuman {
513         require(areas[areaId].owner == msg.sender, "Cannot post message on other's area");
514 
515         emit Post(msg.sender, areaId, message);
516     }
517 
518     function dub(string nickname) external onlyHuman {
519         emit Dub(msg.sender, nickname);
520     }
521 
522 
523 
524     function reset() private {
525         delete endTime;
526         countdown = AREA_COUNT;
527         delete lastOwner;
528         
529         emit Reset();
530     }
531 
532     function tryUnlockSiblings(Area storage area) private {
533         for (uint256 i = 0; i < area.siblings.length; i++) {
534             Area storage sibling = areas[area.siblings[i]];
535 
536             if (sibling.status == Status.Locked) {
537                 sibling.status = Status.Unlocked;
538                 sibling.unlockTime = now.add(DISTRICT_UNLOCK_TIME);
539 
540                 emit Unlock(msg.sender, area.siblings[i], sibling.unlockTime);
541             }
542         }
543     }
544 
545     function tryUnlockParent(Area storage area) private {
546         Area storage parent = areas[area.parent];
547 
548         for (uint256 i = 0; i < parent.children.length; i++) {
549             Area storage child = areas[parent.children[i]];
550 
551             if (child.status != Status.Owned) {
552                 return;
553             }
554         }
555 
556         parent.status = Status.Unlocked;
557         parent.unlockTime = now.add(ZONE_UNLOCK_TIME);
558 
559         emit Unlock(msg.sender, area.parent, parent.unlockTime);
560     }
561 
562     function tryUnlockTarget() private {
563         if (countdown == 1) {
564             areas[TARGET_AREA].status = Status.Unlocked;
565             areas[TARGET_AREA].unlockTime = now.add(TARGET_UNLOCK_TIME);
566 
567             emit Unlock(msg.sender, TARGET_AREA, areas[TARGET_AREA].unlockTime);
568         }
569     }
570 
571 
572 
573     function getInitialCost(Area storage area) private view returns (uint256) {
574         return UNLOCKED_CONFIGS[uint256(area.class)][0];
575     }
576 
577     function getConfigs(Area storage area) private view returns (uint256, uint256, uint256, uint256, uint256) {
578         uint256 index = uint256(area.class);
579         
580         if (area.status == Status.Unlocked) {
581             return (UNLOCKED_CONFIGS[index][1], UNLOCKED_CONFIGS[index][2], UNLOCKED_CONFIGS[index][3], UNLOCKED_CONFIGS[index][4], UNLOCKED_CONFIGS[index][5]);
582         } else if (area.status == Status.Owned) {
583             return (OWNED_CONFIGS[index][0], OWNED_CONFIGS[index][1], OWNED_CONFIGS[index][2], OWNED_CONFIGS[index][3], OWNED_CONFIGS[index][4]);
584         }
585     }
586 }