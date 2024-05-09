1 pragma solidity 0.4.25;
2 
3 library SafeMath8 {
4 
5     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
6         if (a == 0) {
7             return 0;
8         }
9         uint8 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint8 a, uint8 b) internal pure returns (uint8) {
15         return a / b;
16     }
17 
18     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint8 a, uint8 b) internal pure returns (uint8) {
24         uint8 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint8 a, uint8 b) internal pure returns (uint8) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint8 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 library SafeMath16 {
40 
41     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
42         if (a == 0) {
43             return 0;
44         }
45         uint16 c = a * b;
46         assert(c / a == b);
47         return c;
48     }
49 
50     function div(uint16 a, uint16 b) internal pure returns (uint16) {
51         return a / b;
52     }
53 
54     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
55         assert(b <= a);
56         return a - b;
57     }
58 
59     function add(uint16 a, uint16 b) internal pure returns (uint16) {
60         uint16 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 
65     function pow(uint16 a, uint16 b) internal pure returns (uint16) {
66         if (a == 0) return 0;
67         if (b == 0) return 1;
68 
69         uint16 c = a ** b;
70         assert(c / (a ** (b - 1)) == a);
71         return c;
72     }
73 }
74 
75 library SafeMath256 {
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81         uint256 c = a * b;
82         assert(c / a == b);
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return a / b;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         assert(b <= a);
92         return a - b;
93     }
94 
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         assert(c >= a);
98         return c;
99     }
100 
101     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) return 0;
103         if (b == 0) return 1;
104 
105         uint256 c = a ** b;
106         assert(c / (a ** (b - 1)) == a);
107         return c;
108     }
109 }
110 
111 library SafeConvert {
112 
113     function toUint8(uint256 _value) internal pure returns (uint8) {
114         assert(_value <= 255);
115         return uint8(_value);
116     }
117 
118     function toUint16(uint256 _value) internal pure returns (uint16) {
119         assert(_value <= 2**16 - 1);
120         return uint16(_value);
121     }
122 
123     function toUint32(uint256 _value) internal pure returns (uint32) {
124         assert(_value <= 2**32 - 1);
125         return uint32(_value);
126     }
127 }
128 
129 contract Ownable {
130     address public owner;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134     function _validateAddress(address _addr) internal pure {
135         require(_addr != address(0), "invalid address");
136     }
137 
138     constructor() public {
139         owner = msg.sender;
140     }
141 
142     modifier onlyOwner() {
143         require(msg.sender == owner, "not a contract owner");
144         _;
145     }
146 
147     function transferOwnership(address newOwner) public onlyOwner {
148         _validateAddress(newOwner);
149         emit OwnershipTransferred(owner, newOwner);
150         owner = newOwner;
151     }
152 
153 }
154 
155 contract Controllable is Ownable {
156     mapping(address => bool) controllers;
157 
158     modifier onlyController {
159         require(_isController(msg.sender), "no controller rights");
160         _;
161     }
162 
163     function _isController(address _controller) internal view returns (bool) {
164         return controllers[_controller];
165     }
166 
167     function _setControllers(address[] _controllers) internal {
168         for (uint256 i = 0; i < _controllers.length; i++) {
169             _validateAddress(_controllers[i]);
170             controllers[_controllers[i]] = true;
171         }
172     }
173 }
174 
175 contract Upgradable is Controllable {
176     address[] internalDependencies;
177     address[] externalDependencies;
178 
179     function getInternalDependencies() public view returns(address[]) {
180         return internalDependencies;
181     }
182 
183     function getExternalDependencies() public view returns(address[]) {
184         return externalDependencies;
185     }
186 
187     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
188         for (uint256 i = 0; i < _newDependencies.length; i++) {
189             _validateAddress(_newDependencies[i]);
190         }
191         internalDependencies = _newDependencies;
192     }
193 
194     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
195         externalDependencies = _newDependencies;
196         _setControllers(_newDependencies);
197     }
198 }
199 
200 contract Getter {
201     function getDragonParents(uint256) external view returns (uint256[2]) {}
202 }
203 
204 
205 
206 
207 //////////////CONTRACT//////////////
208 
209 
210 
211 
212 contract DragonUtils {
213     using SafeMath8 for uint8;
214     using SafeMath256 for uint256;
215 
216     using SafeConvert for uint256;
217 
218 
219     function _getActiveGene(uint8[16] _gene) internal pure returns (uint8[3] gene) {
220         uint8 _index = _getActiveGeneIndex(_gene); // find active gene
221         for (uint8 i = 0; i < 3; i++) {
222             gene[i] = _gene[i + (_index * 4)]; // get all data for this gene
223         }
224     }
225 
226     function _getActiveGeneIndex(uint8[16] _gene) internal pure returns (uint8) {
227         return _gene[3] >= _gene[7] ? 0 : 1;
228     }
229 
230     // returns 10 active genes (one for each part of the body) with the next structure:
231     // each gene is an array of 3 elements:
232     // 0 - type of dragon
233     // 1 - gene type
234     // 2 - gene level
235     function _getActiveGenes(uint8[16][10] _genome) internal pure returns (uint8[30] genome) {
236         uint8[3] memory _activeGene;
237         for (uint8 i = 0; i < 10; i++) {
238             _activeGene = _getActiveGene(_genome[i]);
239             genome[i * 3] = _activeGene[0];
240             genome[i * 3 + 1] = _activeGene[1];
241             genome[i * 3 + 2] = _activeGene[2];
242         }
243     }
244 
245     function _getIndexAndFactor(uint8 _counter) internal pure returns (uint8 index, uint8 factor) {
246         if (_counter < 44) index = 0;
247         else if (_counter < 88) index = 1;
248         else if (_counter < 132) index = 2;
249         else index = 3;
250         factor = _counter.add(1) % 4 == 0 ? 10 : 100;
251     }
252 
253     function _parseGenome(uint256[4] _composed) internal pure returns (uint8[16][10] parsed) {
254         uint8 counter = 160; // 40 genes with 4 values in each one
255         uint8 _factor;
256         uint8 _index;
257 
258         for (uint8 i = 0; i < 10; i++) {
259             for (uint8 j = 0; j < 16; j++) {
260                 counter = counter.sub(1);
261                 // _index - index of value in genome array where current gene is stored
262                 // _factor - denominator that determines the number of digits
263                 (_index, _factor) = _getIndexAndFactor(counter);
264                 parsed[9 - i][15 - j] = (_composed[_index] % _factor).toUint8();
265                 _composed[_index] /= _factor;
266             }
267         }
268     }
269 
270     function _composeGenome(uint8[16][10] _parsed) internal pure returns (uint256[4] composed) {
271         uint8 counter = 0;
272         uint8 _index;
273         uint8 _factor;
274 
275         for (uint8 i = 0; i < 10; i++) {
276             for (uint8 j = 0; j < 16; j++) {
277                 (_index, _factor) = _getIndexAndFactor(counter);
278                 composed[_index] = composed[_index].mul(_factor);
279                 composed[_index] = composed[_index].add(_parsed[i][j]);
280                 counter = counter.add(1);
281             }
282         }
283     }
284 }
285 
286 contract DragonGenetics is Upgradable, DragonUtils {
287     using SafeMath16 for uint16;
288     using SafeMath256 for uint256;
289 
290     Getter getter;
291 
292     uint8 constant MUTATION_CHANCE = 1; // 10%
293     uint16[7] genesWeights = [300, 240, 220, 190, 25, 15, 10];
294 
295     // choose pair
296     function _chooseGen(uint8 _random, uint8[16] _array1, uint8[16] _array2) internal pure returns (uint8[16] gen) {
297         uint8 x = _random.div(2);
298         uint8 y = _random % 2;
299         for (uint8 j = 0; j < 2; j++) {
300             for (uint8 k = 0; k < 4; k++) {
301                 gen[k.add(j.mul(8))] = _array1[k.add(j.mul(4)).add(x.mul(8))];
302                 gen[k.add(j.mul(2).add(1).mul(4))] = _array2[k.add(j.mul(4)).add(y.mul(8))];
303             }
304         }
305     }
306 
307     function _getParents(uint256 _id) internal view returns (uint256[2]) {
308         if (_id != 0) {
309             return getter.getDragonParents(_id);
310         }
311         return [uint256(0), uint256(0)];
312     }
313 
314     function _checkInbreeding(uint256[2] memory _parents) internal view returns (uint8 chance) {
315         uint8 _relatives;
316         uint8 i;
317         uint256[2] memory _parents_1_1 = _getParents(_parents[0]);
318         uint256[2] memory _parents_1_2 = _getParents(_parents[1]);
319         // check grandparents
320         if (_parents_1_1[0] != 0 && (_parents_1_1[0] == _parents_1_2[0] || _parents_1_1[0] == _parents_1_2[1])) {
321             _relatives = _relatives.add(1);
322         }
323         if (_parents_1_1[1] != 0 && (_parents_1_1[1] == _parents_1_2[0] || _parents_1_1[1] == _parents_1_2[1])) {
324             _relatives = _relatives.add(1);
325         }
326         // check parents and grandparents
327         if (_parents[0] == _parents_1_2[0] || _parents[0] == _parents_1_2[1]) {
328             _relatives = _relatives.add(1);
329         }
330         if (_parents[1] == _parents_1_1[0] || _parents[1] == _parents_1_1[1]) {
331             _relatives = _relatives.add(1);
332         }
333         if (_relatives >= 2) return 8; // 80% chance of a bad mutation
334         if (_relatives == 1) chance = 7; // 70% chance
335         // check grandparents and great-grandparents
336         uint256[12] memory _ancestors;
337         uint256[2] memory _parents_2_1 = _getParents(_parents_1_1[0]);
338         uint256[2] memory _parents_2_2 = _getParents(_parents_1_1[1]);
339         uint256[2] memory _parents_2_3 = _getParents(_parents_1_2[0]);
340         uint256[2] memory _parents_2_4 = _getParents(_parents_1_2[1]);
341         for (i = 0; i < 2; i++) {
342             _ancestors[i.mul(6).add(0)] = _parents_1_1[i];
343             _ancestors[i.mul(6).add(1)] = _parents_1_2[i];
344             _ancestors[i.mul(6).add(2)] = _parents_2_1[i];
345             _ancestors[i.mul(6).add(3)] = _parents_2_2[i];
346             _ancestors[i.mul(6).add(4)] = _parents_2_3[i];
347             _ancestors[i.mul(6).add(5)] = _parents_2_4[i];
348         }
349         for (i = 0; i < 12; i++) {
350             for (uint8 j = i.add(1); j < 12; j++) {
351                 if (_ancestors[i] != 0 && _ancestors[i] == _ancestors[j]) {
352                     _relatives = _relatives.add(1);
353                     _ancestors[j] = 0;
354                 }
355                 if (_relatives > 2 || (_relatives == 2 && chance == 0)) return 8; // 80% chance
356             }
357         }
358         if (_relatives == 1 && chance == 0) return 5; // 50% chance
359     }
360 
361     function _mutateGene(uint8[16] _gene, uint8 _genType) internal pure returns (uint8[16]) {
362         uint8 _index = _getActiveGeneIndex(_gene);
363         _gene[_index.mul(4).add(1)] = _genType; // new gene type
364         _gene[_index.mul(4).add(2)] = 1; // reset level
365         return _gene;
366     }
367 
368     // select one of 16 variations
369     function _calculateGen(
370         uint8[16] _momGen,
371         uint8[16] _dadGen,
372         uint8 _random
373     ) internal pure returns (uint8[16] gen) {
374         if (_random < 4) {
375             return _chooseGen(_random, _momGen, _momGen);
376         } else if (_random < 8) {
377             return _chooseGen(_random.sub(4), _momGen, _dadGen);
378         } else if (_random < 12) {
379             return _chooseGen(_random.sub(8), _dadGen, _dadGen);
380         } else {
381             return _chooseGen(_random.sub(12), _dadGen, _momGen);
382         }
383     }
384 
385     function _calculateGenome(
386         uint8[16][10] memory _momGenome,
387         uint8[16][10] memory _dadGenome,
388         uint8 _uglinessChance,
389         uint256 _seed_
390     ) internal pure returns (uint8[16][10] genome) {
391         uint256 _seed = _seed_;
392         uint256 _random;
393         uint8 _mutationChance = _uglinessChance == 0 ? MUTATION_CHANCE : _uglinessChance;
394         uint8 _geneType;
395         for (uint8 i = 0; i < 10; i++) {
396             (_random, _seed) = _getSpecialRandom(_seed, 4);
397             genome[i] = _calculateGen(_momGenome[i], _dadGenome[i], (_random % 16).toUint8());
398             (_random, _seed) = _getSpecialRandom(_seed, 1);
399             if (_random < _mutationChance) {
400                 _geneType = 0;
401                 if (_uglinessChance == 0) {
402                     (_random, _seed) = _getSpecialRandom(_seed, 2);
403                     _geneType = (_random % 9).add(1).toUint8(); // [1..9]
404                 }
405                 genome[i] = _mutateGene(genome[i], _geneType);
406             }
407         }
408     }
409 
410     // 40 points in sum
411     function _calculateDragonTypes(uint8[16][10] _genome) internal pure returns (uint8[11] dragonTypesArray) {
412         uint8 _dragonType;
413         for (uint8 i = 0; i < 10; i++) {
414             for (uint8 j = 0; j < 4; j++) {
415                 _dragonType = _genome[i][j.mul(4)];
416                 dragonTypesArray[_dragonType] = dragonTypesArray[_dragonType].add(1);
417             }
418         }
419     }
420 
421     function createGenome(
422         uint256[2] _parents,
423         uint256[4] _momGenome,
424         uint256[4] _dadGenome,
425         uint256 _seed
426     ) external view returns (
427         uint256[4] genome,
428         uint8[11] dragonTypes
429     ) {
430         uint8 _uglinessChance = _checkInbreeding(_parents);
431         uint8[16][10] memory _parsedGenome = _calculateGenome(
432             _parseGenome(_momGenome),
433             _parseGenome(_dadGenome),
434             _uglinessChance,
435             _seed
436         );
437         genome = _composeGenome(_parsedGenome);
438         dragonTypes = _calculateDragonTypes(_parsedGenome);
439     }
440 
441     function _getWeightedRandom(uint256 _random) internal view returns (uint8) {
442         uint16 _weight;
443         for (uint8 i = 1; i < 7; i++) {
444             _weight = _weight.add(genesWeights[i.sub(1)]);
445             if (_random < _weight) return i;
446         }
447         return 7;
448     }
449 
450     function _generateGen(uint8 _dragonType, uint256 _random) internal view returns (uint8[16]) {
451         uint8 _geneType = _getWeightedRandom(_random); // [1..7]
452         return [
453             _dragonType, _geneType, 1, 1,
454             _dragonType, _geneType, 1, 0,
455             _dragonType, _geneType, 1, 0,
456             _dragonType, _geneType, 1, 0
457         ];
458     }
459 
460     // max 4 digits
461     function _getSpecialRandom(
462         uint256 _seed_,
463         uint8 _digits
464     ) internal pure returns (uint256, uint256) {
465         uint256 _base = 10;
466         uint256 _seed = _seed_;
467         uint256 _random = _seed % _base.pow(_digits);
468         _seed = _seed.div(_base.pow(_digits));
469         return (_random, _seed);
470     }
471 
472     function createGenomeForGenesis(uint8 _dragonType, uint256 _seed_) external view returns (uint256[4]) {
473         uint256 _seed = _seed_;
474         uint8[16][10] memory _genome;
475         uint256 _random;
476         for (uint8 i = 0; i < 10; i++) {
477             (_random, _seed) = _getSpecialRandom(_seed, 3);
478             _genome[i] = _generateGen(_dragonType, _random);
479         }
480         return _composeGenome(_genome);
481     }
482 
483     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
484         super.setInternalDependencies(_newDependencies);
485 
486         getter = Getter(_newDependencies[0]);
487     }
488 }