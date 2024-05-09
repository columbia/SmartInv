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
29 
30 interface IMultiOwnable {
31 
32     function owners() external view returns (address[]);
33     function transferOwnership(address newOwner) external;
34     function appointHeir(address heir) external;
35     function succeedOwner(address owner) external;
36 
37     event OwnershipTransfer(address indexed owner, address indexed newOwner);
38     event HeirAppointment(address indexed owner, address indexed heir);
39     event OwnershipSuccession(address indexed owner, address indexed heir);
40 }
41 
42 
43 library AddressLib {
44 
45     using AddressLib for AddressLib.Set;
46 
47     function isEmpty(address value) internal pure returns (bool) {
48         return value == address(0);
49     }
50 
51     function isSender(address value) internal view returns (bool) {
52         return value == msg.sender;
53     }
54 
55     struct Set {
56         address[] vals;
57         mapping(address => uint256) seqs;
58     }
59 
60     function values(Set storage set) internal view returns (address[]) {
61         return set.vals;
62     }
63 
64     function count(Set storage set) internal view returns (uint256) {
65         return set.vals.length;
66     }
67 
68     function first(Set storage set) internal view returns (address) {
69         require(set.count() > 0, "Set cannot be empty");
70 
71         return set.vals[0];
72     }
73 
74     function last(Set storage set) internal view returns (address) {
75         require(set.count() > 0, "Set cannot be empty");
76 
77         return set.vals[set.vals.length - 1];
78     }
79 
80     function contains(Set storage set, address value) internal view returns (bool) {
81         return set.seqs[value] > 0;
82     }
83 
84     function add(Set storage set, address value) internal {
85         if (!set.contains(value)) {
86             set.seqs[value] = set.vals.push(value);
87         }
88     }
89 
90     function remove(Set storage set, address value) internal {
91         if (set.contains(value)) {
92             uint256 seq = set.seqs[value];
93 
94             if (seq < set.count()) {
95                 address lastVal = set.last();
96 
97                 set.vals[seq - 1] = lastVal;
98                 set.seqs[lastVal] = seq;
99             }
100 
101             set.vals.length--;
102             set.seqs[value] = 0;
103         }
104     }
105 }
106 
107 
108 contract MultiOwnable is IMultiOwnable {
109 
110     using AddressLib for address;
111     using AddressLib for AddressLib.Set;
112 
113     AddressLib.Set private _owners;
114     mapping(address => address) private _heirs;
115 
116     modifier onlyOwner {
117         require(_owners.contains(msg.sender), "Only allowed for a owner");
118         _;
119     }
120 
121     constructor (address[] owners) internal {
122         for (uint256 i = 0; i < owners.length; i++) {
123             _owners.add(owners[i]);
124         }
125     }
126 
127     function owners() external view returns (address[]) {
128         return _owners.values();
129     }
130 
131     function transferOwnership(address newOwner) external onlyOwner {
132         _transferOwnership(msg.sender, newOwner);
133 
134         emit OwnershipTransfer(msg.sender, newOwner);
135     }
136 
137     function appointHeir(address heir) external onlyOwner {
138         _heirs[msg.sender] = heir;
139 
140         emit HeirAppointment(msg.sender, heir);
141     }
142 
143     function succeedOwner(address owner) external {
144         require(_heirs[owner].isSender(), "Only heir may succeed owner");
145 
146         _transferOwnership(owner, msg.sender);
147         
148         emit OwnershipSuccession(owner, msg.sender);
149     }
150 
151     function _transferOwnership(address owner, address newOwner) private {
152         _owners.remove(owner);
153         _owners.add(newOwner);
154         _heirs[owner] = address(0);
155     }
156 }
157 
158 
159 contract Geo {
160 
161     enum Class { District, Zone, Target }
162     enum Status { Locked, Unlocked, Owned }
163 
164     struct Area {
165         Class class;
166         Status status;
167         uint256 parent;
168         uint256[] siblings;
169         uint256[] children;
170         address owner;
171         uint256 cost;
172         uint256 unlockTime;
173     }
174 
175     mapping(uint256 => Area) internal areas;
176 
177     constructor () internal { }
178 
179     function initAreas() internal {
180         areas[0].class = Class.Target;
181 
182         areas[1].class = Class.District;
183         areas[1].parent = 46;
184         areas[1].siblings = [2,3];
185         areas[2].class = Class.District;
186         areas[2].parent = 46;
187         areas[2].siblings = [1,3];
188         areas[3].class = Class.District;
189         areas[3].parent = 46;
190         areas[3].siblings = [1,2,4,6,8,9,11,13];
191         areas[4].class = Class.District;
192         areas[4].parent = 46;
193         areas[4].siblings = [3,5,6,9];
194         areas[5].class = Class.District;
195         areas[5].parent = 46;
196         areas[5].siblings = [4,6,7,9,37,38,39,41];
197         areas[6].class = Class.District;
198         areas[6].parent = 46;
199         areas[6].siblings = [3,4,5,7,13,22];
200         areas[7].class = Class.District;
201         areas[7].parent = 46;
202         areas[7].siblings = [5,6,21,22,26,38];
203         areas[8].class = Class.District;
204         areas[8].parent = 46;
205 
206         areas[9].class = Class.District;
207         areas[9].parent = 47;
208         areas[9].siblings = [3,4,5,10,11,12,39,41];
209         areas[10].class = Class.District;
210         areas[10].parent = 47;
211         areas[10].siblings = [9,11,12];
212         areas[11].class = Class.District;
213         areas[11].parent = 47;
214         areas[11].siblings = [3,9,10,14];
215         areas[12].class = Class.District;
216         areas[12].parent = 47;
217         areas[12].siblings = [9,10];
218         areas[13].class = Class.District;
219         areas[13].parent = 47;
220         areas[13].siblings = [3,6,15,16,17,22];
221         areas[14].class = Class.District;
222         areas[14].parent = 47;
223         areas[15].class = Class.District;
224         areas[15].parent = 47;
225         areas[16].class = Class.District;
226         areas[16].parent = 47;
227 
228         areas[17].class = Class.District;
229         areas[17].parent = 48;
230         areas[17].siblings = [13,18,19,22,23];
231         areas[18].class = Class.District;
232         areas[18].parent = 48;
233         areas[18].siblings = [17,19];
234         areas[19].class = Class.District;
235         areas[19].parent = 48;
236         areas[19].siblings = [17,18,20,21,22,25];
237         areas[20].class = Class.District;
238         areas[20].parent = 48;
239         areas[20].siblings = [19,21,24,27];
240         areas[21].class = Class.District;
241         areas[21].parent = 48;
242         areas[21].siblings = [7,19,20,22,26,27];
243         areas[22].class = Class.District;
244         areas[22].parent = 48;
245         areas[22].siblings = [6,7,13,17,19,21];
246         areas[23].class = Class.District;
247         areas[23].parent = 48;
248         areas[24].class = Class.District;
249         areas[24].parent = 48;
250         areas[25].class = Class.District;
251         areas[25].parent = 48;
252 
253         areas[26].class = Class.District;
254         areas[26].parent = 49;
255         areas[26].siblings = [7,21,27,28,31,38];
256         areas[27].class = Class.District;
257         areas[27].parent = 49;
258         areas[27].siblings = [20,21,26,28,29,32,33,34,36];
259         areas[28].class = Class.District;
260         areas[28].parent = 49;
261         areas[28].siblings = [26,27,30,31,35];
262         areas[29].class = Class.District;
263         areas[29].parent = 49;
264         areas[29].siblings = [27];
265         areas[30].class = Class.District;
266         areas[30].parent = 49;
267         areas[30].siblings = [28,31,37,42];
268         areas[31].class = Class.District;
269         areas[31].parent = 49;
270         areas[31].siblings = [26,28,30,37,38];
271         areas[32].class = Class.District;
272         areas[32].parent = 49;
273         areas[32].siblings = [27];
274         areas[33].class = Class.District;
275         areas[33].parent = 49;
276         areas[33].siblings = [27];
277         areas[34].class = Class.District;
278         areas[34].parent = 49;
279         areas[35].class = Class.District;
280         areas[35].parent = 49;
281         areas[36].class = Class.District;
282         areas[36].parent = 49;
283 
284         areas[37].class = Class.District;
285         areas[37].parent = 50;
286         areas[37].siblings = [5,30,31,38,39,40,42,45];
287         areas[38].class = Class.District;
288         areas[38].parent = 50;
289         areas[38].siblings = [5,7,26,31,37];
290         areas[39].class = Class.District;
291         areas[39].parent = 50;
292         areas[39].siblings = [5,9,37,40,41,43,44];
293         areas[40].class = Class.District;
294         areas[40].parent = 50;
295         areas[40].siblings = [37,39,42,43];
296         areas[41].class = Class.District;
297         areas[41].parent = 50;
298         areas[41].siblings = [5,9,39];
299         areas[42].class = Class.District;
300         areas[42].parent = 50;
301         areas[42].siblings = [30,37,40,43];
302         areas[43].class = Class.District;
303         areas[43].parent = 50;
304         areas[43].siblings = [39,40,42];
305         areas[44].class = Class.District;
306         areas[44].parent = 50;
307         areas[45].class = Class.District;
308         areas[45].parent = 50;
309 
310         areas[46].class = Class.Zone;
311         areas[46].children = [1,2,3,4,5,6,7,8];
312         areas[47].class = Class.Zone;
313         areas[47].children = [9,10,11,12,13,14,15,16];
314         areas[48].class = Class.Zone;
315         areas[48].children = [17,18,19,20,21,22,23,24,25];
316         areas[49].class = Class.Zone;
317         areas[49].children = [26,27,28,29,30,31,32,33,34,35,36];
318         areas[50].class = Class.Zone;
319         areas[50].children = [37,38,39,40,41,42,43,44,45];
320     }
321 }
322 
323 
324 contract Configs {
325 
326     address[] internal GAME_MASTER_ADDRESSES = [
327         0x33e03f9F3eFe593D10327245f8107eAaD09730B7,
328         0xbcec8fc952776F4F83829837881092596C29A666,
329         0x4Eb1E2B89Aba03b7383F07cC80003937b7814B54,
330         address(0),
331         address(0)
332     ];
333 
334     address internal constant ROYALTY_ADDRESS = 0x8C1A581a19A08Ddb1dB271c82da20D88977670A8;
335 
336     uint256 internal constant AREA_COUNT = 51;
337     uint256 internal constant TARGET_AREA = 0;
338     uint256 internal constant SOURCE_AREA = 1;
339     uint256 internal constant ZONE_START = 46;
340     uint256 internal constant ZONE_COUNT = 5;
341 
342     uint256[][] internal UNLOCKED_CONFIGS = [
343         [uint256(16 * 10**15), 0, 0, 0, 5, 4],
344         [uint256(32 * 10**15), 0, 0, 0, 4, 3],
345         [uint256(128 * 10**15), 0, 0, 0, 3, 2]
346     ];
347 
348     uint256[][] internal OWNED_CONFIGS = [
349         [uint256(90), 2, 3, 5, 4],
350         [uint256(80), 0, 5, 4, 3],
351         [uint256(99), 0, 1, 3, 2]
352     ];
353 
354     uint256 internal constant DISTRICT_UNLOCK_TIME = 1 minutes;
355     uint256 internal constant ZONE_UNLOCK_TIME = 3 minutes;
356     uint256 internal constant TARGET_UNLOCK_TIME = 10 minutes;
357 
358     uint256 internal constant END_TIME_COUNTDOWN = 6 hours;
359     uint256 internal constant DISTRICT_END_TIME_EXTENSION = 30 seconds;
360     uint256 internal constant ZONE_END_TIME_EXTENSION = 1 minutes;
361     uint256 internal constant TARGET_END_TIME_EXTENSION = 3 minutes;
362 
363     uint256 internal constant LAST_OWNER_SHARE = 55;
364     uint256 internal constant TARGET_OWNER_SHARE = 30;
365     uint256 internal constant SOURCE_OWNER_SHARE = 5;
366     uint256 internal constant ZONE_OWNERS_SHARE = 10;
367 }
368 
369 
370 contract Main is Configs, Geo, MultiOwnable {
371 
372     using MathLib for uint256;
373 
374     uint256 private endTime;
375     uint256 private countdown;
376     address private lastOwner;
377 
378     event Settings(uint256 lastOwnerShare, uint256 targetOwnerShare, uint256 sourceOwnerShare, uint256 zoneOwnersShare);
379     event Summary(uint256 currentTime, uint256 endTime, uint256 prize, address lastOwner);
380     event Reset();
381     event Start();
382     event Finish();
383     event Unlock(address indexed player, uint256 indexed areaId, uint256 unlockTime);
384     event Acquisition(address indexed player, uint256 indexed areaId, uint256 price, uint256 newPrice);
385     event Post(address indexed player, uint256 indexed areaId, string message);
386     event Dub(address indexed player, string nickname);
387 
388     modifier onlyHuman {
389         uint256 codeSize;
390         address sender = msg.sender;
391         assembly { codeSize := extcodesize(sender) }
392 
393         require(sender == tx.origin, "Sorry, human only");
394         require(codeSize == 0, "Sorry, human only");
395 
396         _;
397     }
398 
399     constructor () public MultiOwnable(GAME_MASTER_ADDRESSES) { }
400 
401     function init() external onlyOwner {
402         require(countdown == 0 && endTime == 0, "Game has already been initialized");
403 
404         initAreas();
405         reset();
406 
407         emit Settings(LAST_OWNER_SHARE, TARGET_OWNER_SHARE, SOURCE_OWNER_SHARE, ZONE_OWNERS_SHARE);
408     }
409 
410     function start() external onlyOwner {
411         require(areas[SOURCE_AREA].status == Status.Locked, "Game has already started");
412 
413         areas[SOURCE_AREA].status = Status.Unlocked;
414 
415         emit Start();
416     }
417 
418     function finish() external onlyOwner {
419         require(endTime > 0 && now >= endTime, "Cannot end yet");
420 
421         uint256 unitValue = address(this).balance.div(100);
422         uint256 zoneValue = unitValue.mul(ZONE_OWNERS_SHARE).div(ZONE_COUNT);
423 
424         for (uint256 i = 0; i < ZONE_COUNT; i++) {
425             areas[ZONE_START.add(i)].owner.transfer(zoneValue);
426         }
427         lastOwner.transfer(unitValue.mul(LAST_OWNER_SHARE));
428         areas[TARGET_AREA].owner.transfer(unitValue.mul(TARGET_OWNER_SHARE));
429         areas[SOURCE_AREA].owner.transfer(unitValue.mul(SOURCE_OWNER_SHARE));
430 
431         emit Finish();
432 
433         for (i = 0; i < AREA_COUNT; i++) {
434             delete areas[i].cost;
435             delete areas[i].owner;
436             delete areas[i].status;
437             delete areas[i].unlockTime;
438         }
439         reset();
440     }
441 
442     function acquire(uint256 areaId) external payable onlyHuman {
443         //TODO: trigger special events within this function somewhere
444 
445         require(endTime == 0 || now < endTime, "Game has ended");
446 
447         Area storage area = areas[areaId];
448         if (area.status == Status.Unlocked) {
449             area.cost = getInitialCost(area);            
450         }
451 
452         require(area.status != Status.Locked, "Cannot acquire locked area");
453         require(area.unlockTime <= now, "Cannot acquire yet");
454         require(area.owner != msg.sender, "Cannot acquire already owned area");
455         require(area.cost == msg.value, "Incorrect value for acquiring this area");
456 
457         uint256 unitValue = msg.value.div(100);
458         uint256 ownerShare;
459         uint256 parentShare;
460         uint256 devShare;
461         uint256 inflationNum;
462         uint256 inflationDenom;
463         (ownerShare, parentShare, devShare, inflationNum, inflationDenom) = getConfigs(area);
464 
465         if (ownerShare > 0) {
466             area.owner.transfer(unitValue.mul(ownerShare));
467         }
468         if (parentShare > 0 && areas[area.parent].status == Status.Owned) {
469             areas[area.parent].owner.transfer(unitValue.mul(parentShare));
470         }
471         if (devShare > 0) {
472             ROYALTY_ADDRESS.transfer(unitValue.mul(devShare));
473         }
474 
475         area.cost = area.cost.mul(inflationNum).div(inflationDenom);
476         area.owner = msg.sender;
477         if (area.class != Class.Target) {
478             lastOwner = msg.sender;
479         }
480 
481         emit Acquisition(msg.sender, areaId, msg.value, area.cost);        
482 
483         if (area.status == Status.Unlocked) {
484             area.status = Status.Owned;
485             countdown = countdown.sub(1);
486 
487             if (area.class == Class.District) {
488                 tryUnlockSiblings(area);
489                 tryUnlockParent(area);
490             } else if (area.class == Class.Zone) {
491                 tryUnlockTarget();
492             } else if (area.class == Class.Target) {
493                 endTime = now.add(END_TIME_COUNTDOWN);
494             }
495         } else if (area.status == Status.Owned) {
496             if (endTime > 0) {
497                 if (area.class == Class.District) {
498                     endTime = endTime.add(DISTRICT_END_TIME_EXTENSION);
499                 } else if (area.class == Class.Zone) {
500                     endTime = endTime.add(ZONE_END_TIME_EXTENSION);
501                 } else if (area.class == Class.Target) {
502                     endTime = endTime.add(TARGET_END_TIME_EXTENSION);
503                 }
504             }
505 
506             if (endTime > now.add(END_TIME_COUNTDOWN)) {
507                 endTime = now.add(END_TIME_COUNTDOWN);
508             }
509         }
510 
511         emit Summary(now, endTime, address(this).balance, lastOwner);
512     }
513 
514     function post(uint256 areaId, string message) external onlyHuman {
515         require(areas[areaId].owner == msg.sender, "Cannot post message on other's area");
516 
517         emit Post(msg.sender, areaId, message);
518     }
519 
520     function dub(string nickname) external onlyHuman {
521         emit Dub(msg.sender, nickname);
522     }
523 
524 
525 
526     function reset() private {
527         delete endTime;
528         countdown = AREA_COUNT;
529         delete lastOwner;
530         
531         emit Reset();
532     }
533 
534     function tryUnlockSiblings(Area storage area) private {
535         for (uint256 i = 0; i < area.siblings.length; i++) {
536             Area storage sibling = areas[area.siblings[i]];
537 
538             if (sibling.status == Status.Locked) {
539                 sibling.status = Status.Unlocked;
540                 sibling.unlockTime = now.add(DISTRICT_UNLOCK_TIME);
541 
542                 emit Unlock(msg.sender, area.siblings[i], sibling.unlockTime);
543             }
544         }
545     }
546 
547     function tryUnlockParent(Area storage area) private {
548         Area storage parent = areas[area.parent];
549 
550         for (uint256 i = 0; i < parent.children.length; i++) {
551             Area storage child = areas[parent.children[i]];
552 
553             if (child.status != Status.Owned) {
554                 return;
555             }
556         }
557 
558         parent.status = Status.Unlocked;
559         parent.unlockTime = now.add(ZONE_UNLOCK_TIME);
560 
561         emit Unlock(msg.sender, area.parent, parent.unlockTime);
562     }
563 
564     function tryUnlockTarget() private {
565         if (countdown == 1) {
566             areas[TARGET_AREA].status = Status.Unlocked;
567             areas[TARGET_AREA].unlockTime = now.add(TARGET_UNLOCK_TIME);
568 
569             emit Unlock(msg.sender, TARGET_AREA, areas[TARGET_AREA].unlockTime);
570         }
571     }
572 
573 
574 
575     function getInitialCost(Area storage area) private view returns (uint256) {
576         return UNLOCKED_CONFIGS[uint256(area.class)][0];
577     }
578 
579     function getConfigs(Area storage area) private view returns (uint256, uint256, uint256, uint256, uint256) {
580         uint256 index = uint256(area.class);
581         
582         if (area.status == Status.Unlocked) {
583             return (UNLOCKED_CONFIGS[index][1], UNLOCKED_CONFIGS[index][2], UNLOCKED_CONFIGS[index][3], UNLOCKED_CONFIGS[index][4], UNLOCKED_CONFIGS[index][5]);
584         } else if (area.status == Status.Owned) {
585             return (OWNED_CONFIGS[index][0], OWNED_CONFIGS[index][1], OWNED_CONFIGS[index][2], OWNED_CONFIGS[index][3], OWNED_CONFIGS[index][4]);
586         }
587     }
588 }