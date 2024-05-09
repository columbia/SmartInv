1 /*
2 
3  Copyright 2017-2019 RigoBlock, Rigo Investment Sagl.
4 
5  Licensed under the Apache License, Version 2.0 (the "License");
6  you may not use this file except in compliance with the License.
7  You may obtain a copy of the License at
8 
9      http://www.apache.org/licenses/LICENSE-2.0
10 
11  Unless required by applicable law or agreed to in writing, software
12  distributed under the License is distributed on an "AS IS" BASIS,
13  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14  See the License for the specific language governing permissions and
15  limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.2;
20 
21 contract Pool {
22     
23     address public owner;
24 
25     /*
26      * CONSTANT PUBLIC FUNCTIONS
27      */
28     function balanceOf(address _who) external view returns (uint256);
29     function totalSupply() external view returns (uint256 totaSupply);
30     function getEventful() external view returns (address);
31     function getData() external view returns (string memory name, string memory symbol, uint256 sellPrice, uint256 buyPrice);
32     function calcSharePrice() external view returns (uint256);
33     function getAdminData() external view returns (address, address feeCollector, address dragodAO, uint256 ratio, uint256 transactionFee, uint32 minPeriod);
34 }
35 
36 contract SafeMath {
37 
38     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a * b;
40         assert(a == 0 || c / a == b);
41         return c;
42     }
43 
44     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b > 0);
46         uint256 c = a / b;
47         assert(a == b * c + a % b);
48         return c;
49     }
50 
51     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         assert(c>=a && c>=b);
59         return c;
60     }
61 
62     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
63         return a >= b ? a : b;
64     }
65 
66     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
67         return a < b ? a : b;
68     }
69 
70     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a >= b ? a : b;
72     }
73 
74     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 }
78 
79 contract RigoToken {
80 
81     address public minter;
82     uint256 public totalSupply;
83     
84     function balanceOf(address _who) external view returns (uint256);
85 }
86 
87 interface DragoRegistry {
88 
89     //EVENTS
90 
91     event Registered(string name, string symbol, uint256 id, address indexed drago, address indexed owner, address indexed group);
92     event Unregistered(string indexed name, string indexed symbol, uint256 indexed id);
93     event MetaChanged(uint256 indexed id, bytes32 indexed key, bytes32 value);
94 
95     /*
96      * CORE FUNCTIONS
97      */
98     function register(address _drago, string calldata _name, string calldata _symbol, uint256 _dragoId, address _owner) external payable returns (bool);
99     function unregister(uint256 _id) external;
100     function setMeta(uint256 _id, bytes32 _key, bytes32 _value) external;
101     function addGroup(address _group) external;
102     function setFee(uint256 _fee) external;
103     function updateOwner(uint256 _id) external;
104     function updateOwners(uint256[] calldata _id) external;
105     function upgrade(address _newAddress) external payable; //payable as there is a transfer of value, otherwise opcode might throw an error
106     function setUpgraded(uint256 _version) external;
107     function drain() external;
108 
109     /*
110      * CONSTANT PUBLIC FUNCTIONS
111      */
112     function dragoCount() external view returns (uint256);
113     function fromId(uint256 _id) external view returns (address drago, string memory name, string memory symbol, uint256 dragoId, address owner, address group);
114     function fromAddress(address _drago) external view returns (uint256 id, string memory name, string memory symbol, uint256 dragoId, address owner, address group);
115     function fromName(string calldata _name) external view returns (uint256 id, address drago, string memory symbol, uint256 dragoId, address owner, address group);
116     function getNameFromAddress(address _pool) external view returns (string memory);
117     function getSymbolFromAddress(address _pool) external view returns (string memory);
118     function meta(uint256 _id, bytes32 _key) external view returns (bytes32);
119     function getGroups() external view returns (address[] memory);
120     function getFee() external view returns (uint256);
121 }
122 
123 interface Inflation {
124 
125     /*
126      * CORE FUNCTIONS
127      */
128     function mintInflation(address _thePool, uint256 _reward) external returns (bool);
129     function setInflationFactor(address _group, uint256 _inflationFactor) external;
130     function setMinimumRigo(uint256 _minimum) external;
131     function setRigoblock(address _newRigoblock) external;
132     function setAuthority(address _authority) external;
133     function setProofOfPerformance(address _pop) external;
134     function setPeriod(uint256 _newPeriod) external;
135 
136     /*
137      * CONSTANT PUBLIC FUNCTIONS
138      */
139     function canWithdraw(address _thePool) external view returns (bool);
140     function getInflationFactor(address _group) external view returns (uint256);
141 }
142 
143 contract ReentrancyGuard {
144 
145     // Locked state of mutex
146     bool private locked = false;
147 
148     /// @dev Functions with this modifer cannot be reentered. The mutex will be locked
149     ///      before function execution and unlocked after.
150     modifier nonReentrant() {
151         // Ensure mutex is unlocked
152         require(
153             !locked,
154             "REENTRANCY_ILLEGAL"
155         );
156 
157         // Lock mutex before function call
158         locked = true;
159 
160         // Perform function call
161         _;
162 
163         // Unlock mutex after function call
164         locked = false;
165     }
166 }
167 
168 interface ProofOfPerformanceFace {
169 
170     /*
171      * CORE FUNCTIONS
172      */
173     function claimPop(uint256 _ofPool) external;
174     function setRegistry(address _dragoRegistry) external;
175     function setRigoblockDao(address _rigoblockDao) external;
176     function setRatio(address _ofGroup, uint256 _ratio) external;
177 
178     /*
179      * CONSTANT PUBLIC FUNCTIONS
180      */
181     function getPoolData(uint256 _ofPool)
182         external view
183         returns (
184             bool active,
185             address thePoolAddress,
186             address thePoolGroup,
187             uint256 thePoolPrice,
188             uint256 thePoolSupply,
189             uint256 poolValue,
190             uint256 epochReward,
191             uint256 ratio,
192             uint256 pop
193         );
194 
195     function getHwm(uint256 _ofPool) external view returns (uint256);
196 }
197 
198 /// @title Proof of Performance - Controls parameters of inflation.
199 /// @author Gabriele Rigo - <gab@rigoblock.com>
200 // solhint-disable-next-line
201 contract ProofOfPerformance is
202     SafeMath,
203     ReentrancyGuard,
204     ProofOfPerformanceFace
205 {
206     address public RIGOTOKENADDRESS;
207 
208     address public dragoRegistry;
209     address public rigoblockDao;
210 
211     mapping (uint256 => PoolPrice) poolPrice;
212     mapping (address => Group) groups;
213 
214     struct PoolPrice {
215         uint256 highwatermark;
216     }
217 
218     struct Group {
219         uint256 rewardRatio;
220     }
221 
222     modifier onlyRigoblockDao() {
223         require(
224             msg.sender == rigoblockDao,
225             "ONLY_RIGOBLOCK_DAO"
226         );
227         _;
228     }
229 
230     constructor(
231         address _rigoTokenAddress,
232         address _rigoblockDao,
233         address _dragoRegistry)
234         public
235     {
236         RIGOTOKENADDRESS = _rigoTokenAddress;
237         rigoblockDao = _rigoblockDao;
238         dragoRegistry = _dragoRegistry;
239     }
240 
241     /*
242      * CORE FUNCTIONS
243      */
244     /// @dev Allows anyone to allocate the pop reward to pool wizards.
245     /// @param _ofPool Number of pool id in registry.
246     function claimPop(uint256 _ofPool)
247         external
248         nonReentrant
249     {
250         DragoRegistry registry = DragoRegistry(dragoRegistry);
251         address poolAddress;
252         (poolAddress, , , , , ) = registry.fromId(_ofPool);
253         uint256 pop = proofOfPerformanceInternal(_ofPool);
254         require(
255             pop > 0,
256             "POP_REWARD_IS_NULL"
257         );
258         (uint256 price, ) = getPoolPriceInternal(_ofPool);
259         poolPrice[_ofPool].highwatermark = price;
260         require(
261             Inflation(getMinter()).mintInflation(poolAddress, pop),
262             "MINT_INFLATION_ERROR"
263         );
264     }
265 
266     /// @dev Allows RigoBlock Dao to update the pools registry.
267     /// @param _dragoRegistry Address of new registry.
268     function setRegistry(address _dragoRegistry)
269         external
270         onlyRigoblockDao
271     {
272         dragoRegistry = _dragoRegistry;
273     }
274 
275     /// @dev Allows RigoBlock Dao to update its address.
276     /// @param _rigoblockDao Address of new dao.
277     function setRigoblockDao(address _rigoblockDao)
278         external
279         onlyRigoblockDao
280     {
281         rigoblockDao = _rigoblockDao;
282     }
283 
284     /// @dev Allows RigoBlock Dao to set the ratio between assets and performance reward for a group.
285     /// @param _ofGroup Id of the pool.
286     /// @param _ratio Id of the pool.
287     /// @notice onlyRigoblockDao can set ratio.
288     function setRatio(
289         address _ofGroup,
290         uint256 _ratio)
291         external
292         onlyRigoblockDao
293     {
294         require(
295             _ratio <= 10000,
296             "RATIO_BIGGER_THAN_10000"
297         ); //(from 0 to 10000)
298         groups[_ofGroup].rewardRatio = _ratio;
299     }
300 
301     /*
302      * CONSTANT PUBLIC FUNCTIONS
303      */
304     /// @dev Gets data of a pool.
305     /// @param _ofPool Id of the pool.
306     /// @return Bool the pool is active.
307     /// @return address of the pool.
308     /// @return address of the pool factory.
309     /// @return price of the pool in wei.
310     /// @return total supply of the pool in units.
311     /// @return total value of the pool in wei.
312     /// @return value of the reward factor or said pool.
313     /// @return ratio of assets/performance reward (from 0 to 10000).
314     /// @return value of the pop reward to be claimed in GRGs.
315     function getPoolData(uint256 _ofPool)
316         external
317         view
318         returns (
319             bool active,
320             address thePoolAddress,
321             address thePoolGroup,
322             uint256 thePoolPrice,
323             uint256 thePoolSupply,
324             uint256 poolValue,
325             uint256 epochReward,
326             uint256 ratio,
327             uint256 pop
328         )
329     {
330         active = isActiveInternal(_ofPool);
331         (thePoolAddress, thePoolGroup) = addressFromIdInternal(_ofPool);
332         (thePoolPrice, thePoolSupply) = getPoolPriceInternal(_ofPool);
333         (poolValue, ) = calcPoolValueInternal(_ofPool);
334         epochReward = getEpochRewardInternal(_ofPool);
335         ratio = getRatioInternal(_ofPool);
336         pop = proofOfPerformanceInternal(_ofPool);
337         return(
338             active,
339             thePoolAddress,
340             thePoolGroup,
341             thePoolPrice,
342             thePoolSupply,
343             poolValue,
344             epochReward,
345             ratio,
346             pop
347         );
348     }
349 
350     /// @dev Returns the highwatermark of a pool.
351     /// @param _ofPool Id of the pool.
352     /// @return Value of the all-time-high pool nav.
353     function getHwm(uint256 _ofPool)
354         external
355         view
356         returns (uint256)
357     {
358         return poolPrice[_ofPool].highwatermark;
359     }
360     
361     /// @dev Returns the reward factor for a pool.
362     /// @param _ofPool Id of the pool.
363     /// @return Value of the reward factor.
364     function getEpochReward(uint256 _ofPool)
365         external
366         view
367         returns (uint256)
368     {
369         return getEpochRewardInternal(_ofPool);
370     }
371 
372     /// @dev Returns the split ratio of asset and performance reward.
373     /// @param _ofPool Id of the pool.
374     /// @return Value of the ratio from 1 to 100.
375     function getRatio(uint256 _ofPool)
376         external
377         view
378         returns (uint256)
379     {
380         return getRatioInternal(_ofPool);
381     }
382     
383     /// @dev Returns the proof of performance reward for a pool.
384     /// @param _ofPool Id of the pool.
385     /// @return Value of the reward in Rigo tokens.
386     /// @notice epoch reward should be big enough that it.
387     /// @notice can be decreased if number of funds increases.
388     /// @notice should be at least 10^6 (just as pool base) to start with.
389     /// @notice rigo token has 10^18 decimals.
390     function proofOfPerformance(uint256 _ofPool)
391         external
392         view
393         returns (uint256)
394     {
395         return proofOfPerformanceInternal(_ofPool);
396     }
397     
398     /// @dev Checks whether a pool is registered and active.
399     /// @param _ofPool Id of the pool.
400     /// @return Bool the pool is active.
401     function isActive(uint256 _ofPool)
402         external
403         view
404         returns (bool)
405     {
406         return isActiveInternal(_ofPool);
407     }
408 
409     /// @dev Returns the address and the group of a pool from its id.
410     /// @param _ofPool Id of the pool.
411     /// @return Address of the target pool.
412     /// @return Address of the pool's group.
413     function addressFromId(uint256 _ofPool)
414         external
415         view
416         returns (
417             address pool,
418             address group
419         )
420     {
421         return (addressFromIdInternal(_ofPool));
422     }
423 
424     /// @dev Returns the price a pool from its id.
425     /// @param _ofPool Id of the pool.
426     /// @return Price of the pool in wei.
427     /// @return Number of tokens of a pool (totalSupply).
428     function getPoolPrice(uint256 _ofPool)
429         external
430         view
431         returns (
432             uint256 thePoolPrice,
433             uint256 totalTokens
434         )
435     {
436         return (getPoolPriceInternal(_ofPool));
437     }
438 
439     /// @dev Returns the address and the group of a pool from its id.
440     /// @param _ofPool Id of the pool.
441     /// @return Address of the target pool.
442     /// @return Address of the pool's group.
443     function calcPoolValue(uint256 _ofPool)
444         external
445         view
446         returns (
447             uint256 aum,
448             bool success
449         )
450     {
451         return (calcPoolValueInternal(_ofPool));
452     }
453 
454     /*
455      * INTERNAL FUNCTIONS
456      */
457     /// @dev Returns the reward factor for a pool.
458     /// @param _ofPool Id of the pool.
459     /// @return Value of the reward factor.
460     function getEpochRewardInternal(uint256 _ofPool)
461         internal
462         view
463         returns (uint256)
464     {
465         ( , address group) = addressFromIdInternal(_ofPool);
466         return Inflation(getMinter()).getInflationFactor(group);
467     }
468 
469     /// @dev Returns the split ratio of asset and performance reward.
470     /// @param _ofPool Id of the pool.
471     /// @return Value of the ratio from 1 to 100.
472     function getRatioInternal(uint256 _ofPool)
473         internal
474         view
475         returns (uint256)
476     {
477         ( , address group) = addressFromIdInternal(_ofPool);
478         return groups[group].rewardRatio;
479     }
480 
481     /// @dev Returns the address of the Inflation contract.
482     /// @return Address of the minter/inflation.
483     function getMinter()
484         internal
485         view
486         returns (address)
487     {
488         RigoToken token = RigoToken(RIGOTOKENADDRESS);
489         return token.minter();
490     }
491 
492     /// @dev Returns the proof of performance reward for a pool.
493     /// @param _ofPool Id of the pool.
494     /// @return Value of the reward in Rigo tokens.
495     /// @notice epoch reward should be big enough that it.
496     /// @notice can be decreased if number of funds increases.
497     /// @notice should be at least 10^6 (just as pool base) to start with.
498     /// @notice rigo token has 10^18 decimals.
499     function proofOfPerformanceInternal(uint256 _ofPool)
500         internal
501         view
502         returns (uint256)
503     {
504         uint256 highwatermark = 1000 ether; //initialize variable with arbitrarily high value
505         if (poolPrice[_ofPool].highwatermark == 0) {
506             highwatermark = 1 ether;
507         } else {
508             highwatermark = poolPrice[_ofPool].highwatermark;
509         }
510         (uint256 poolValue, ) = calcPoolValueInternal(_ofPool);
511         require(
512             poolValue != 0,
513             "POOL_VALUE_NULL"
514         );
515         (uint256 newPrice, uint256 tokenSupply) = getPoolPriceInternal(_ofPool);
516         require (
517             newPrice >= highwatermark,
518             "PRICE_LOWER_THAN_HWM"
519         );
520         require (
521             tokenSupply > 0,
522             "TOKEN_SUPPLY_NULL"
523         );
524 
525         uint256 epochReward = 0;
526         (address thePoolAddress, ) = addressFromIdInternal(_ofPool);
527         uint256 grgBalance = 
528             RigoToken(RIGOTOKENADDRESS)
529             .balanceOf(
530                 Pool(thePoolAddress)
531                 .owner()
532         );
533         if (grgBalance >= 1 * 10 ** 18) {
534             epochReward = safeMul(getEpochRewardInternal(_ofPool), 10); // 10x reward if wizard holds 1 GRG
535         } else {
536             epochReward = getEpochRewardInternal(_ofPool);
537         }
538 
539         uint256 rewardRatio = getRatioInternal(_ofPool);
540         uint256 prevPrice = highwatermark;
541         uint256 priceDiff = safeSub(newPrice, prevPrice);
542         uint256 performanceComponent = safeMul(safeMul(priceDiff, tokenSupply), epochReward);
543         uint256 performanceReward = safeDiv(safeMul(performanceComponent, rewardRatio), 10000 ether);
544         uint256 assetsComponent = safeMul(poolValue, epochReward);
545         uint256 assetsReward = safeDiv(safeMul(assetsComponent, safeSub(10000, rewardRatio)), 10000 ether);
546         uint256 popReward = safeAdd(performanceReward, assetsReward);
547         if (popReward >= safeDiv(RigoToken(RIGOTOKENADDRESS).totalSupply(), 10000)) {
548             return (safeDiv(RigoToken(RIGOTOKENADDRESS).totalSupply(), 10000));
549         } else {
550             return (popReward);
551         }
552     }
553 
554     /// @dev Checks whether a pool is registered and active.
555     /// @param _ofPool Id of the pool.
556     /// @return Bool the pool is active.
557     function isActiveInternal(uint256 _ofPool)
558         internal view
559         returns (bool)
560     {
561         DragoRegistry registry = DragoRegistry(dragoRegistry);
562         (address thePool, , , , , ) = registry.fromId(_ofPool);
563         if (thePool != address(0)) {
564             return true;
565         }
566     }
567 
568     /// @dev Returns the address and the group of a pool from its id.
569     /// @param _ofPool Id of the pool.
570     /// @return Address of the target pool.
571     /// @return Address of the pool's group.
572     function addressFromIdInternal(uint256 _ofPool)
573         internal
574         view
575         returns (
576             address pool,
577             address group
578         )
579     {
580         DragoRegistry registry = DragoRegistry(dragoRegistry);
581         (pool, , , , , group) = registry.fromId(_ofPool);
582         return (pool, group);
583     }
584 
585     /// @dev Returns the price a pool from its id.
586     /// @param _ofPool Id of the pool.
587     /// @return Price of the pool in wei.
588     /// @return Number of tokens of a pool (totalSupply).
589     function getPoolPriceInternal(uint256 _ofPool)
590         internal
591         view
592         returns (
593             uint256 thePoolPrice,
594             uint256 totalTokens
595         )
596     {
597         (address poolAddress, ) = addressFromIdInternal(_ofPool);
598         Pool pool = Pool(poolAddress);
599         thePoolPrice = pool.calcSharePrice();
600         totalTokens = pool.totalSupply();
601     }
602 
603     /// @dev Returns the address and the group of a pool from its id.
604     /// @param _ofPool Id of the pool.
605     /// @return Address of the target pool.
606     /// @return Address of the pool's group.
607     function calcPoolValueInternal(uint256 _ofPool)
608         internal
609         view
610         returns (
611             uint256 aum,
612             bool success
613         )
614     {
615         (uint256 price, uint256 supply) = getPoolPriceInternal(_ofPool);
616         return ((aum = (price * supply / 1000000)), true); //1000000 is the base (decimals)
617     }
618 }