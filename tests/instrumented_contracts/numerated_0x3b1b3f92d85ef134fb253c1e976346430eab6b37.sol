1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, reverts on overflow.
7      */
8     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (_a == 0) {
13             return 0;
14         }
15 
16         uint256 c = _a * _b;
17         require(c / _a == _b);
18 
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24      */
25     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
26         require(_b > 0); // Solidity only automatically asserts when dividing by 0
27         uint256 c = _a / _b;
28         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
37         require(_b <= _a);
38         uint256 c = _a - _b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two numbers, reverts on overflow.
45      */
46     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
47         uint256 c = _a + _b;
48         require(c >= _a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 interface ICaelumMiner {
64     function getMiningReward() external returns (uint) ;
65 }
66 
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipRenounced(address indexed previousOwner);
72   event OwnershipTransferred(
73     address indexed previousOwner,
74     address indexed newOwner
75   );
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() public {
83     owner = msg.sender;
84   }
85 
86   /**
87    * @dev Throws if called by any account other than the owner.
88    */
89   modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94   /**
95    * @dev Allows the current owner to relinquish control of the contract.
96    * @dev Renouncing to ownership will leave the contract without an owner.
97    * It will not be possible to call the functions with the `onlyOwner`
98    * modifier anymore.
99    */
100   function renounceOwnership() public onlyOwner {
101     emit OwnershipRenounced(owner);
102     owner = address(0);
103   }
104 
105   /**
106    * @dev Allows the current owner to transfer control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function transferOwnership(address _newOwner) public onlyOwner {
110     _transferOwnership(_newOwner);
111   }
112 
113   /**
114    * @dev Transfers control of the contract to a newOwner.
115    * @param _newOwner The address to transfer ownership to.
116    */
117   function _transferOwnership(address _newOwner) internal {
118     require(_newOwner != address(0));
119     emit OwnershipTransferred(owner, _newOwner);
120     owner = _newOwner;
121   }
122 }
123 
124 contract InterfaceContracts is Ownable {
125     InterfaceContracts public _internalMod;
126     
127     function setModifierContract (address _t) onlyOwner public {
128         _internalMod = InterfaceContracts(_t);
129     }
130 
131     modifier onlyMiningContract() {
132       require(msg.sender == _internalMod._contract_miner(), "Wrong sender");
133           _;
134       }
135 
136     modifier onlyTokenContract() {
137       require(msg.sender == _internalMod._contract_token(), "Wrong sender");
138       _;
139     }
140     
141     modifier onlyMasternodeContract() {
142       require(msg.sender == _internalMod._contract_masternode(), "Wrong sender");
143       _;
144     }
145     
146     modifier onlyVotingOrOwner() {
147       require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");
148       _;
149     }
150     
151     modifier onlyVotingContract() {
152       require(msg.sender == _internalMod._contract_voting() || msg.sender == owner, "Wrong sender");
153       _;
154     }
155       
156     function _contract_voting () public view returns (address) {
157         return _internalMod._contract_voting();
158     }
159     
160     function _contract_masternode () public view returns (address) {
161         return _internalMod._contract_masternode();
162     }
163     
164     function _contract_token () public view returns (address) {
165         return _internalMod._contract_token();
166     }
167     
168     function _contract_miner () public view returns (address) {
169         return _internalMod._contract_miner();
170     }
171 }
172 
173 contract CaelumAbstractMasternode is Ownable {
174 
175     struct MasterNode {
176         address accountOwner;
177         bool isActive;
178         bool isTeamMember;
179         uint storedIndex;
180         uint startingRound;
181         uint nodeCount;
182         uint[] indexcounter;
183 
184     }
185 
186     mapping(address => MasterNode) public userByAddress;
187     mapping(uint => MasterNode) public masternodeByIndex;
188 
189     uint public userCounter = 0;
190     uint public masternodeIDcounter = 0;
191     uint public masternodeRound = 0;
192     uint public masternodeCandidate;
193 
194     uint public MINING_PHASE_DURATION_BLOCKS = 4500;
195 
196     uint public miningEpoch;
197     uint public rewardsProofOfWork;
198     uint public rewardsMasternode;
199 
200     bool genesisAdded = false;
201 
202     event NewMasternode(address candidateAddress, uint timeStamp);
203     event RemovedMasternode(address candidateAddress, uint timeStamp);
204 
205 
206     address [] public genesisList = [
207       0xdb93CE3cCA2444CE5DA5522a85758af79Af0092D,
208       0x375E97e59dE97BE46D332Ba17185620B81bdB7cc,
209       0x14dB686439Aad3C076B793335BC14D9039F32C54,
210       0x1Ba4b0280163889e7Ee4ab5269C442971F48d13e,
211       0xE4Ac657af0690E9437f36D3E96886DC880b24404,
212       0x08Fcf0027E1e91a12981fBc6371dE39A269C3a47,
213       0x3d664B7B0Eb158798f3E797e194FEe50dD748742,
214       0xB85aC167079020d93033a014efEaD75f14018522,
215       0xc6d00915CbcF9ABE9B27403F8d2338551f4ac43b,
216       0x5256fE3F8e50E0f7f701525e814A2767da2cca06,
217       0x2cf23c6610A70d58D61eFbdEfD6454960b200c2C
218     ];
219 
220     function addGenesis() onlyOwner public {
221         require(!genesisAdded);
222 
223         for (uint i=0; i<genesisList.length; i++) {
224           addMasternode(genesisList[i]);
225         }
226 
227         genesisAdded = true; // Forever lock this.
228     }
229 
230     function addOwner() onlyOwner public {
231         addMasternode(owner);
232         updateMasternodeAsTeamMember(owner);
233     }
234 
235     function addMasternode(address _candidate) internal {
236         /**
237          * @dev userByAddress is used for general statistic data.
238          * All masternode interaction happens by masternodeByIndex!
239          */
240         userByAddress[_candidate].isActive = true;
241         userByAddress[_candidate].accountOwner = _candidate;
242         userByAddress[_candidate].storedIndex = masternodeIDcounter;
243         userByAddress[_candidate].startingRound = masternodeRound + 1;
244         userByAddress[_candidate].indexcounter.push(masternodeIDcounter);
245 
246         masternodeByIndex[masternodeIDcounter].isActive = true;
247         masternodeByIndex[masternodeIDcounter].accountOwner = _candidate;
248         masternodeByIndex[masternodeIDcounter].storedIndex = masternodeIDcounter;
249         masternodeByIndex[masternodeIDcounter].startingRound = masternodeRound + 1;
250 
251         masternodeIDcounter++;
252         userCounter++;
253     }
254 
255     function updateMasternode(uint _index) internal returns(bool) {
256         masternodeByIndex[_index].startingRound++;
257         return true;
258     }
259 
260     function updateMasternodeAsTeamMember(address _candidate) internal returns(bool) {
261         userByAddress[_candidate].isTeamMember = true;
262         return (true);
263     }
264 
265     function deleteMasternode(uint _index) internal {
266         address getUserFrom = getUserFromID(_index);
267         userByAddress[getUserFrom].isActive = false;
268         masternodeByIndex[_index].isActive = false;
269         userCounter--;
270     }
271 
272     function getLastActiveBy(address _candidate) public view returns(uint) {
273       uint lastFound;
274       for (uint i = 0; i < userByAddress[_candidate].indexcounter.length; i++) {
275           if (masternodeByIndex[userByAddress[_candidate].indexcounter[i]].isActive == true) {
276               lastFound = masternodeByIndex[userByAddress[_candidate].indexcounter[i]].storedIndex;
277           }
278       }
279       return lastFound;
280     }
281 
282     function userHasActiveNodes(address _candidate) public view returns(bool) {
283 
284         bool lastFound;
285 
286         for (uint i = 0; i < userByAddress[_candidate].indexcounter.length; i++) {
287             if (masternodeByIndex[userByAddress[_candidate].indexcounter[i]].isActive == true) {
288                 lastFound = true;
289             }
290         }
291         return lastFound;
292     }
293 
294     function setMasternodeCandidate() internal returns(address) {
295 
296         uint hardlimitCounter = 0;
297 
298         while (getFollowingCandidate() == 0x0) {
299             // We must return a value not to break the contract. Require is a secondary killswitch now.
300             require(hardlimitCounter < 6, "Failsafe switched on");
301             // Choose if loop over revert/require to terminate the loop and return a 0 address.
302             if (hardlimitCounter == 5) return (0);
303             masternodeRound = masternodeRound + 1;
304             masternodeCandidate = 0;
305             hardlimitCounter++;
306         }
307 
308         if (masternodeCandidate == masternodeIDcounter - 1) {
309             masternodeRound = masternodeRound + 1;
310             masternodeCandidate = 0;
311         }
312 
313         for (uint i = masternodeCandidate; i < masternodeIDcounter; i++) {
314             if (masternodeByIndex[i].isActive) {
315                 if (masternodeByIndex[i].startingRound == masternodeRound) {
316                     updateMasternode(i);
317                     masternodeCandidate = i;
318                     return (masternodeByIndex[i].accountOwner);
319                 }
320             }
321         }
322 
323         masternodeRound = masternodeRound + 1;
324         return (0);
325 
326     }
327 
328     function getFollowingCandidate() public view returns(address _address) {
329         uint tmpRound = masternodeRound;
330         uint tmpCandidate = masternodeCandidate;
331 
332         if (tmpCandidate == masternodeIDcounter - 1) {
333             tmpRound = tmpRound + 1;
334             tmpCandidate = 0;
335         }
336 
337         for (uint i = masternodeCandidate; i < masternodeIDcounter; i++) {
338             if (masternodeByIndex[i].isActive) {
339                 if (masternodeByIndex[i].startingRound == tmpRound) {
340                     tmpCandidate = i;
341                     return (masternodeByIndex[i].accountOwner);
342                 }
343             }
344         }
345 
346         tmpRound = tmpRound + 1;
347         return (0);
348     }
349 
350     function calculateRewardStructures() internal {
351         //ToDo: Set
352         uint _global_reward_amount = getMiningReward();
353         uint getStageOfMining = miningEpoch / MINING_PHASE_DURATION_BLOCKS * 10;
354 
355         if (getStageOfMining < 10) {
356             rewardsProofOfWork = _global_reward_amount / 100 * 5;
357             rewardsMasternode = 0;
358             return;
359         }
360 
361         if (getStageOfMining > 90) {
362             rewardsProofOfWork = _global_reward_amount / 100 * 2;
363             rewardsMasternode = _global_reward_amount / 100 * 98;
364             return;
365         }
366 
367         uint _mnreward = (_global_reward_amount / 100) * getStageOfMining;
368         uint _powreward = (_global_reward_amount - _mnreward);
369 
370         setBaseRewards(_powreward, _mnreward);
371     }
372 
373     function setBaseRewards(uint _pow, uint _mn) internal {
374         rewardsMasternode = _mn;
375         rewardsProofOfWork = _pow;
376     }
377 
378     function _arrangeMasternodeFlow() internal {
379         calculateRewardStructures();
380         setMasternodeCandidate();
381         miningEpoch++;
382     }
383 
384     function isMasternodeOwner(address _candidate) public view returns(bool) {
385         if (userByAddress[_candidate].indexcounter.length <= 0) return false;
386         if (userByAddress[_candidate].accountOwner == _candidate)
387             return true;
388     }
389 
390     function belongsToUser(address _candidate) public view returns(uint[]) {
391         return userByAddress[_candidate].indexcounter;
392     }
393 
394     function getLastPerUser(address _candidate) public view returns(uint) {
395         return userByAddress[_candidate].indexcounter[userByAddress[_candidate].indexcounter.length - 1];
396     }
397 
398     function getUserFromID(uint _index) public view returns(address) {
399         return masternodeByIndex[_index].accountOwner;
400     }
401 
402     function getMiningReward() public view returns(uint) {
403         return 50 * 1e8;
404     }
405 
406     function masternodeInfo(uint _index) public view returns
407         (
408             address,
409             bool,
410             uint,
411             uint
412         ) {
413             return (
414                 masternodeByIndex[_index].accountOwner,
415                 masternodeByIndex[_index].isActive,
416                 masternodeByIndex[_index].storedIndex,
417                 masternodeByIndex[_index].startingRound
418             );
419         }
420 
421     function contractProgress() public view returns
422         (
423             uint epoch,
424             uint candidate,
425             uint round,
426             uint miningepoch,
427             uint globalreward,
428             uint powreward,
429             uint masternodereward,
430             uint usercount
431         ) {
432             return (
433                 0,
434                 masternodeCandidate,
435                 masternodeRound,
436                 miningEpoch,
437                 getMiningReward(),
438                 rewardsProofOfWork,
439                 rewardsMasternode,
440                 userCounter
441             );
442         }
443 
444 }
445 
446 contract CaelumMasternode is InterfaceContracts, CaelumAbstractMasternode {
447 
448     bool minerSet = false;
449     bool tokenSet = false;
450     uint swapStartedBlock = now;
451 
452     address cloneDataFrom = 0x7600bF5112945F9F006c216d5d6db0df2806eDc6;
453 
454 
455     /**
456      * @dev Use this to externaly call the _arrangeMasternodeFlow function. ALWAYS set a modifier !
457      */
458 
459     function _externalArrangeFlow() onlyMiningContract public {
460         _arrangeMasternodeFlow();
461     }
462 
463     /**
464      * @dev Use this to externaly call the addMasternode function. ALWAYS set a modifier !
465      */
466     function _externalAddMasternode(address _received) onlyTokenContract public {
467         addMasternode(_received);
468     }
469 
470     /**
471      * @dev Use this to externaly call the deleteMasternode function. ALWAYS set a modifier !
472      */
473     function _externalStopMasternode(address _received) onlyTokenContract public {
474         deleteMasternode(getLastActiveBy(_received));
475     }
476 
477     function getMiningReward() public view returns(uint) {
478         return ICaelumMiner(_contract_miner()).getMiningReward();
479     }
480 
481     /**
482     * @dev Move the voting away from token. All votes will be made from the voting
483     */
484     function VoteModifierContract (address _contract) onlyVotingContract external {
485         //_internalMod = CaelumModifierAbstract(_contract);
486         setModifierContract(_contract);
487     }
488 
489     function getDataFromContract() onlyOwner public returns(uint) {
490 
491         CaelumMasternode prev = CaelumMasternode(cloneDataFrom);
492         (
493           uint epoch,
494           uint candidate,
495           uint round,
496           uint miningepoch,
497           uint globalreward,
498           uint powreward,
499           uint masternodereward,
500           uint usercounter
501         ) = prev.contractProgress();
502 
503         masternodeRound = round;
504         miningEpoch = miningepoch;
505         rewardsProofOfWork = powreward;
506         rewardsMasternode = masternodereward;
507     }
508 
509 }