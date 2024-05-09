1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.6.8;
3 
4 // ERC20 Interface
5 interface ERC20 {
6     function transfer(address, uint256) external returns (bool);
7 
8     function transferFrom(
9         address,
10         address,
11         uint256
12     ) external returns (bool);
13 
14     function balanceOf(address account) external view returns (uint256);
15 }
16 
17 library SafeMath {
18 
19   function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29 
30     function sub(
31         uint256 a,
32         uint256 b,
33         string memory errorMessage
34     ) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(
54         uint256 a,
55         uint256 b,
56         string memory errorMessage
57     ) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 }
63 
64 contract PerlinXRewards {
65     using SafeMath for uint256;
66     uint256 private constant _NOT_ENTERED = 1;
67     uint256 private constant _ENTERED = 2;
68     uint256 private _status;
69 
70     address public PERL;
71     address public treasury;
72 
73     address[] public arrayAdmins;
74     address[] public arrayPerlinPools;
75     address[] public arraySynths;
76     address[] public arrayMembers;
77 
78     uint256 public currentEra;
79 
80     mapping(address => bool) public isAdmin; // Tracks admin status
81     mapping(address => bool) public poolIsListed; // Tracks current listing status
82     mapping(address => bool) public poolHasMembers; // Tracks current staking status
83     mapping(address => bool) public poolWasListed; // Tracks if pool was ever listed
84     mapping(address => uint256) public mapAsset_Rewards; // Maps rewards for each asset (PERL, BAL, UNI etc)
85     mapping(address => uint256) public poolWeight; // Allows a reward weight to be applied; 100 = 1.0
86     mapping(uint256 => uint256) public mapEra_Total; // Total PERL staked in each era
87     mapping(uint256 => bool) public eraIsOpen; // Era is open of collecting rewards
88     mapping(uint256 => mapping(address => uint256)) public mapEraAsset_Reward; // Reward allocated for era
89     mapping(uint256 => mapping(address => uint256)) public mapEraPool_Balance; // Perls in each pool, per era
90     mapping(uint256 => mapping(address => uint256)) public mapEraPool_Share; // Share of reward for each pool, per era
91     mapping(uint256 => mapping(address => uint256)) public mapEraPool_Claims; // Total LP tokens locked for each pool, per era
92 
93     mapping(address => address) public mapPool_Asset; // Uniswap pools provide liquidity to non-PERL asset
94     mapping(address => address) public mapSynth_EMP; // Synthetic Assets have a management contract
95 
96     mapping(address => bool) public isMember; // Is Member
97     mapping(address => uint256) public mapMember_poolCount; // Total number of Pools member is in
98     mapping(address => address[]) public mapMember_arrayPools; // Array of pools for member
99     mapping(address => mapping(address => uint256))
100         public mapMemberPool_Balance; // Member's balance in pool
101     mapping(address => mapping(address => bool)) public mapMemberPool_Added; // Member's balance in pool
102     mapping(address => mapping(uint256 => bool))
103         public mapMemberEra_hasRegistered; // Member has registered
104     mapping(address => mapping(uint256 => mapping(address => uint256)))
105         public mapMemberEraPool_Claim; // Value of claim per pool, per era
106     mapping(address => mapping(uint256 => mapping(address => bool)))
107         public mapMemberEraAsset_hasClaimed; // Boolean claimed
108 
109     // Events
110     event Snapshot(
111         address indexed admin,
112         uint256 indexed era,
113         uint256 rewardForEra,
114         uint256 perlTotal,
115         uint256 validPoolCount,
116         uint256 validMemberCount,
117         uint256 date
118     );
119     event NewPool(
120         address indexed admin,
121         address indexed pool,
122         address indexed asset,
123         uint256 assetWeight
124     );
125     event NewSynth(
126         address indexed pool,
127         address indexed synth,
128         address indexed expiringMultiParty
129     );
130     event MemberLocks(
131         address indexed member,
132         address indexed pool,
133         uint256 amount,
134         uint256 indexed currentEra
135     );
136     event MemberUnlocks(
137         address indexed member,
138         address indexed pool,
139         uint256 balance,
140         uint256 indexed currentEra
141     );
142     event MemberRegisters(
143         address indexed member,
144         address indexed pool,
145         uint256 amount,
146         uint256 indexed currentEra
147     );
148     event MemberClaims(address indexed member, uint256 indexed era, uint256 totalClaim);
149 
150     // Only Admin can execute
151     modifier onlyAdmin() {
152         require(isAdmin[msg.sender], "Must be Admin");
153         _;
154     }
155 
156     modifier nonReentrant() {
157         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
158         _status = _ENTERED;
159         _;
160         _status = _NOT_ENTERED;
161     }
162 
163     constructor() public {
164         arrayAdmins.push(msg.sender);
165         isAdmin[msg.sender] = true;
166         PERL = 0xeca82185adCE47f39c684352B0439f030f860318;
167         treasury = 0x3F2a2c502E575f2fd4053c76f4E21623143518d8; 
168         currentEra = 1;
169         _status = _NOT_ENTERED;
170     }
171 
172     //==============================ADMIN================================//
173 
174     // Lists a synth and its parent EMP address
175     function listSynth(
176         address pool,
177         address synth,
178         address emp,
179         uint256 weight
180     ) public onlyAdmin {
181         require(emp != address(0), "Must pass address validation");
182         if (!poolWasListed[pool]) {
183             arraySynths.push(synth); // Add new synth
184         }
185         listPool(pool, synth, weight); // List like normal pool
186         mapSynth_EMP[synth] = emp; // Maps the EMP contract for look-up
187         emit NewSynth(pool, synth, emp);
188     }
189 
190     // Lists a pool and its non-PERL asset (can work for Balance or Uniswap V2)
191     // Use "100" to be a normal weight of "1.0"
192     function listPool(
193         address pool,
194         address asset,
195         uint256 weight
196     ) public onlyAdmin {
197         require(
198             (asset != PERL) && (asset != address(0)) && (pool != address(0)),
199             "Must pass address validation"
200         );
201         require(
202             weight >= 10 && weight <= 1000,
203             "Must be greater than 0.1, less than 10"
204         );
205         if (!poolWasListed[pool]) {
206             arrayPerlinPools.push(pool);
207         }
208         poolIsListed[pool] = true; // Tracking listing
209         poolWasListed[pool] = true; // Track if ever was listed
210         poolWeight[pool] = weight; // Note: weight of 120 = 1.2
211         mapPool_Asset[pool] = asset; // Map the pool to its non-perl asset
212         emit NewPool(msg.sender, pool, asset, weight);
213     }
214 
215     function delistPool(address pool) public onlyAdmin {
216         poolIsListed[pool] = false;
217     }
218 
219     // Quorum Action 1
220     function addAdmin(address newAdmin) public onlyAdmin {
221         require(
222             (isAdmin[newAdmin] == false) && (newAdmin != address(0)),
223             "Must pass address validation"
224         );
225         arrayAdmins.push(newAdmin);
226         isAdmin[newAdmin] = true;
227     }
228 
229     function transferAdmin(address newAdmin) public onlyAdmin {
230         require(
231             (isAdmin[newAdmin] == false) && (newAdmin != address(0)),
232             "Must pass address validation"
233         );
234         arrayAdmins.push(newAdmin);
235         isAdmin[msg.sender] = false;
236         isAdmin[newAdmin] = true;
237     }
238 
239     // Snapshot a new Era, allocating any new rewards found on the address, increment Era
240     // Admin should send reward funds first
241     function snapshot(address rewardAsset) public onlyAdmin {
242         snapshotInEra(rewardAsset, currentEra); // Snapshots PERL balances
243         currentEra = currentEra.add(1); // Increment the eraCount, so users can't register in a previous era.
244     }
245 
246     // Snapshot a particular rewwardAsset, but don't increment Era (like Balancer Rewards)
247     // Do this after snapshotPools()
248     function snapshotInEra(address rewardAsset, uint256 era) public onlyAdmin {
249         uint256 start = 0;
250         uint256 end = poolCount();
251         snapshotInEraWithOffset(rewardAsset, era, start, end);
252     }
253 
254     // Snapshot with offset (in case runs out of gas)
255     function snapshotWithOffset(
256         address rewardAsset,
257         uint256 start,
258         uint256 end
259     ) public onlyAdmin {
260         snapshotInEraWithOffset(rewardAsset, currentEra, start, end); // Snapshots PERL balances
261         currentEra = currentEra.add(1); // Increment the eraCount, so users can't register in a previous era.
262     }
263 
264     // Snapshot a particular rewwardAsset, with offset
265     function snapshotInEraWithOffset(
266         address rewardAsset,
267         uint256 era,
268         uint256 start,
269         uint256 end
270     ) public onlyAdmin {
271         require(rewardAsset != address(0), "Address must not be 0x0");
272         require(
273             (era >= currentEra - 1) && (era <= currentEra),
274             "Must be current or previous era only"
275         );
276         uint256 amount = ERC20(rewardAsset).balanceOf(address(this)).sub(
277             mapAsset_Rewards[rewardAsset]
278         );
279         require(amount > 0, "Amount must be non-zero");
280         mapAsset_Rewards[rewardAsset] = mapAsset_Rewards[rewardAsset].add(
281             amount
282         );
283         mapEraAsset_Reward[era][rewardAsset] = mapEraAsset_Reward[era][rewardAsset]
284             .add(amount);
285         eraIsOpen[era] = true;
286         updateRewards(era, amount, start, end); // Snapshots PERL balances
287     }
288 
289     // Note, due to EVM gas limits, poolCount should be less than 100 to do this before running out of gas
290     function updateRewards(
291         uint256 era,
292         uint256 rewardForEra,
293         uint256 start,
294         uint256 end
295     ) internal {
296         // First snapshot balances of each pool
297         uint256 perlTotal;
298         uint256 validPoolCount;
299         uint256 validMemberCount;
300         for (uint256 i = start; i < end; i++) {
301             address pool = arrayPerlinPools[i];
302             if (poolIsListed[pool] && poolHasMembers[pool]) {
303                 validPoolCount = validPoolCount.add(1);
304                 uint256 weight = poolWeight[pool];
305                 uint256 weightedBalance = (
306                     ERC20(PERL).balanceOf(pool).mul(weight)).div(100); // (depth * weight) / 100
307                 perlTotal = perlTotal.add(weightedBalance);
308                 mapEraPool_Balance[era][pool] = weightedBalance;
309             }
310         }
311         mapEra_Total[era] = perlTotal;
312         // Then snapshot share of the reward for the era
313         for (uint256 i = start; i < end; i++) {
314             address pool = arrayPerlinPools[i];
315             if (poolIsListed[pool] && poolHasMembers[pool]) {
316                 validMemberCount = validMemberCount.add(1);
317                 uint256 part = mapEraPool_Balance[era][pool];
318                 mapEraPool_Share[era][pool] = getShare(
319                     part,
320                     perlTotal,
321                     rewardForEra
322                 );
323             }
324         }
325         emit Snapshot(
326             msg.sender,
327             era,
328             rewardForEra,
329             perlTotal,
330             validPoolCount,
331             validMemberCount,
332             now
333         );
334     }
335 
336     // Quorum Action
337     // Remove unclaimed rewards and disable era for claiming
338     function removeReward(uint256 era, address rewardAsset) public onlyAdmin {
339       uint256 amount = mapEraAsset_Reward[era][rewardAsset];
340       mapEraAsset_Reward[era][rewardAsset] = 0;
341       mapAsset_Rewards[rewardAsset] = mapAsset_Rewards[rewardAsset].sub(
342           amount
343       );
344       eraIsOpen[era] = false;
345       require(
346             ERC20(rewardAsset).transfer(treasury, amount),
347             "Must transfer"
348         );
349     }
350 
351     // Quorum Action - Reuses adminApproveEraAsset() logic since unlikely to collide
352     // Use in anger to sweep off assets (such as accidental airdropped tokens)
353     function sweep(address asset, uint256 amount) public onlyAdmin {
354       require(
355             ERC20(asset).transfer(treasury, amount),
356             "Must transfer"
357         );
358     }
359 
360     //============================== USER - LOCK/UNLOCK ================================//
361     // Member locks some LP tokens
362     function lock(address pool, uint256 amount) public nonReentrant {
363         require(poolIsListed[pool] == true, "Must be listed");
364         if (!isMember[msg.sender]) {
365             // Add new member
366             arrayMembers.push(msg.sender);
367             isMember[msg.sender] = true;
368         }
369         if (!poolHasMembers[pool]) {
370             // Records existence of member
371             poolHasMembers[pool] = true;
372         }
373         if (!mapMemberPool_Added[msg.sender][pool]) {
374             // Record all the pools member is in
375             mapMember_poolCount[msg.sender] = mapMember_poolCount[msg.sender]
376                 .add(1);
377             mapMember_arrayPools[msg.sender].push(pool);
378             mapMemberPool_Added[msg.sender][pool] = true;
379         }
380         require(
381             ERC20(pool).transferFrom(msg.sender, address(this), amount),
382             "Must transfer"
383         ); // Uni/Bal LP tokens return bool
384         mapMemberPool_Balance[msg.sender][pool] = mapMemberPool_Balance[msg.sender][pool]
385             .add(amount); // Record total pool balance for member
386         registerClaim(msg.sender, pool, amount); // Register claim
387         emit MemberLocks(msg.sender, pool, amount, currentEra);
388     }
389 
390     // Member unlocks all from a pool
391     function unlock(address pool) public nonReentrant {
392         uint256 balance = mapMemberPool_Balance[msg.sender][pool];
393         require(balance > 0, "Must have a balance to claim");
394         mapMemberPool_Balance[msg.sender][pool] = 0; // Zero out balance
395         require(ERC20(pool).transfer(msg.sender, balance), "Must transfer"); // Then transfer
396         if (ERC20(pool).balanceOf(address(this)) == 0) {
397             poolHasMembers[pool] = false; // If nobody is staking any more
398         }
399         emit MemberUnlocks(msg.sender, pool, balance, currentEra);
400     }
401 
402     //============================== USER - CLAIM================================//
403     // Member registers claim in a single pool
404     function registerClaim(
405         address member,
406         address pool,
407         uint256 amount
408     ) internal {
409         mapMemberEraPool_Claim[member][currentEra][pool] += amount;
410         mapEraPool_Claims[currentEra][pool] = mapEraPool_Claims[currentEra][pool]
411             .add(amount);
412         emit MemberRegisters(member, pool, amount, currentEra);
413     }
414 
415     // Member registers claim in all pools
416     function registerAllClaims(address member) public {
417         require(
418             mapMemberEra_hasRegistered[msg.sender][currentEra] == false,
419             "Must not have registered in this era already"
420         );
421         for (uint256 i = 0; i < mapMember_poolCount[member]; i++) {
422             address pool = mapMember_arrayPools[member][i];
423             // first deduct any previous claim
424             mapEraPool_Claims[currentEra][pool] = mapEraPool_Claims[currentEra][pool]
425                 .sub(mapMemberEraPool_Claim[member][currentEra][pool]);
426             uint256 amount = mapMemberPool_Balance[member][pool]; // then get latest balance
427             mapMemberEraPool_Claim[member][currentEra][pool] = amount; // then update the claim
428             mapEraPool_Claims[currentEra][pool] = mapEraPool_Claims[currentEra][pool]
429                 .add(amount); // then add to total
430             emit MemberRegisters(member, pool, amount, currentEra);
431         }
432         mapMemberEra_hasRegistered[msg.sender][currentEra] = true;
433     }
434 
435     // Member claims in a era
436     function claim(uint256 era, address rewardAsset)
437         public
438         nonReentrant
439     {
440         require(
441             mapMemberEraAsset_hasClaimed[msg.sender][era][rewardAsset] == false,
442             "Reward asset must not have been claimed"
443         );
444         require(eraIsOpen[era], "Era must be opened");
445         uint256 totalClaim = checkClaim(msg.sender, era);
446         if (totalClaim > 0) {
447             mapMemberEraAsset_hasClaimed[msg.sender][era][rewardAsset] = true; // Register claim
448             mapEraAsset_Reward[era][rewardAsset] = mapEraAsset_Reward[era][rewardAsset]
449                 .sub(totalClaim); // Decrease rewards for that era
450             mapAsset_Rewards[rewardAsset] = mapAsset_Rewards[rewardAsset].sub(
451                 totalClaim
452             ); // Decrease rewards in total
453             require(
454                 ERC20(rewardAsset).transfer(msg.sender, totalClaim),
455                 "Must transfer"
456             ); // Then transfer
457         }
458         emit MemberClaims(msg.sender, era, totalClaim);
459         if (mapMemberEra_hasRegistered[msg.sender][currentEra] == false) {
460             registerAllClaims(msg.sender); // Register another claim
461         }
462     }
463 
464     // Member checks claims in all pools
465     function checkClaim(address member, uint256 era)
466         public
467         view
468         returns (uint256 totalClaim)
469     {
470         for (uint256 i = 0; i < mapMember_poolCount[member]; i++) {
471             address pool = mapMember_arrayPools[member][i];
472             totalClaim += checkClaimInPool(member, era, pool);
473         }
474         return totalClaim;
475     }
476 
477     // Member checks claim in a single pool
478     function checkClaimInPool(
479         address member,
480         uint256 era,
481         address pool
482     ) public view returns (uint256 claimShare) {
483         uint256 poolShare = mapEraPool_Share[era][pool]; // Requires admin snapshotting for era first, else 0
484         uint256 memberClaimInEra = mapMemberEraPool_Claim[member][era][pool]; // Requires member registering claim in the era
485         uint256 totalClaimsInEra = mapEraPool_Claims[era][pool]; // Sum of all claims in a era
486         if (totalClaimsInEra > 0) {
487             // Requires non-zero balance of the pool tokens
488             claimShare = getShare(
489                 memberClaimInEra,
490                 totalClaimsInEra,
491                 poolShare
492             );
493         } else {
494             claimShare = 0;
495         }
496         return claimShare;
497     }
498 
499     //==============================UTILS================================//
500     // Get the share of a total
501     function getShare(
502         uint256 part,
503         uint256 total,
504         uint256 amount
505     ) public pure returns (uint256 share) {
506         return (amount.mul(part)).div(total);
507     }
508 
509     function adminCount() public view returns (uint256) {
510         return arrayAdmins.length;
511     }
512 
513     function poolCount() public view returns (uint256) {
514         return arrayPerlinPools.length;
515     }
516 
517     function synthCount() public view returns (uint256) {
518         return arraySynths.length;
519     }
520 
521     function memberCount() public view returns (uint256) {
522         return arrayMembers.length;
523     }
524 }