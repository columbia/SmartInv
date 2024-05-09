1 pragma solidity ^0.5.2;
2 
3 /*
4 ETICA: a type1 civilization neutral protocol for medical research
5 KEVIN WAD OSSENI
6 */
7 
8 /*
9 MIT License
10 Copyright © 26/08/2019, KEVIN WAD OSSENI
11 
12 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
13 
14 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
15 
16 The Software is provided “as is”, without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the Software.
17 */
18 
19 
20 // ----------------------------------------------------------------------------
21 
22 // Safe maths
23 
24 // ----------------------------------------------------------------------------
25 
26 library SafeMath {
27 
28     function add(uint a, uint b) internal pure returns (uint c) {
29 
30         c = a + b;
31 
32         require(c >= a);
33 
34     }
35 
36     function sub(uint a, uint b) internal pure returns (uint c) {
37 
38         require(b <= a);
39 
40         c = a - b;
41 
42     }
43 
44     function mul(uint a, uint b) internal pure returns (uint c) {
45 
46         c = a * b;
47 
48         require(a == 0 || c / a == b);
49 
50     }
51 
52     function div(uint a, uint b) internal pure returns (uint c) {
53 
54         require(b > 0);
55 
56         c = a / b;
57 
58     }
59 
60 }
61 
62 
63 
64 library ExtendedMath {
65 
66 
67     //return the smaller of the two inputs (a or b)
68     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
69 
70         if(a > b) return b;
71 
72         return a;
73 
74     }
75 }
76 
77 
78 
79 contract ERC20Interface {
80     function totalSupply() public view returns (uint);
81     function balanceOf(address tokenOwner) public view returns (uint balance);
82     function transfer(address to, uint tokens) public returns (bool success);
83 
84 
85     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
86     function approve(address spender, uint tokens) public returns (bool success);
87     function transferFrom(address from, address to, uint tokens) public returns (bool success);
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 }
92 
93 
94 
95 contract EticaToken is ERC20Interface{
96 
97     using SafeMath for uint;
98     using ExtendedMath for uint;
99 
100     string public name = "Etica";
101     string public symbol = "ETI";
102     uint public decimals = 18;
103 
104     uint public supply;
105     uint public inflationrate; // fixed inflation rate of phase2 (after Etica supply has reached 21 Million ETI)
106     uint public  periodrewardtemp; // Amount of ETI issued per period during phase1 (before Etica supply has reached 21 Million ETI)
107 
108     uint public PERIOD_CURATION_REWARD_RATIO = 38196601125; // 38.196601125% of period reward will be used as curation reward
109     uint public PERIOD_EDITOR_REWARD_RATIO = 61803398875; // 61.803398875% of period reward will be used as editor reward
110 
111     uint public UNRECOVERABLE_ETI;
112 
113     // Etica is a neutral protocol, it has no founder I am only an initiator:
114     string public constant initiatormsg = "Discovering our best Futures. All proposals are made under the Creative Commons license 4.0. Kevin Wad";
115 
116     mapping(address => uint) public balances;
117 
118     mapping(address => mapping(address => uint)) allowed;
119 
120    
121 
122     // ----------- Mining system state variables ------------ //
123     uint public _totalMiningSupply;
124 
125 
126 
127      uint public latestDifficultyPeriodStarted;
128 
129 
130 
131     uint public epochCount; //number of 'blocks' mined
132 
133 
134     uint public _BLOCKS_PER_READJUSTMENT = 2016;
135 
136 
137     //a little number
138     uint public  _MINIMUM_TARGET = 2**2;
139 
140 
141     //a big number is easier ; just find a solution that is smaller
142     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
143     //uint public  _MAXIMUM_TARGET = 2**242; // used for tests 243 much faster, 242 seems to be the limit where mining gets much harder
144     uint public  _MAXIMUM_TARGET = 2**220; // used for prod
145 
146 
147     uint public miningTarget;
148 
149     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
150 
151 
152     uint public blockreward;
153 
154 
155     address public lastRewardTo;
156     uint public lastRewardEthBlockNumber;
157 
158 
159     mapping(bytes32 => bytes32) solutionForChallenge;
160 
161     uint public tokensMinted;
162 
163     bytes32 RANDOMHASH;
164 
165     // ----------- Mining system state variables ------------ //
166 
167 
168 
169 
170     event Transfer(address indexed from, address indexed to, uint tokens);
171     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
172     event Mint(address indexed from, uint blockreward, uint epochCount, bytes32 newChallengeNumber);
173 
174 
175     constructor() public{
176       supply = 100 * (10**18); // initial supply equals 100 ETI
177       balances[address(this)] = balances[address(this)].add(100 * (10**18)); // 100 ETI as the default contract balance.
178 
179 
180     // ------------ PHASE 1 (before 21 Million ETI has been reached) -------------- //
181       
182       /* Phase 1 will last about 10 years:
183       --> 11 550 000 ETI to be distributed through MINING as block reward
184       --> 9 450 000 ETI to be issued during phase 1 as periodrewardtemp for ETICA reward system
185       
186 
187       Phase1 is divided between 10 eras:
188       Each Era will allocate 2 100 000 ETI between mining reward and the staking system reward.
189       Each era is supposed to last about a year but can vary depending on hashrate.
190       Era1: 90% ETI to mining and 10% ETI to Staking  |  Era2: 80% ETI to mining and 20% ETI to Staking
191       Era3: 70% ETI to mining and 30% ETI to Staking  |  Era4: 60% ETI to mining and 40% ETI to Staking
192       Era5: 50% ETI to mining and 50% ETI to Staking  |  Era6: 50% ETI to mining and 50% ETI to Staking
193       Era7: 50% ETI to mining and 50% ETI to Staking  |  Era8: 50% ETI to mining and 50% ETI to Staking
194       Era9: 50% ETI to mining and 50% ETI to Staking  |  Era10: 50% ETI to mining and 50% ETI to Staking
195       Era1: 1 890 000 ETI as mining reward and 210 000 ETI as Staking reward
196       Era2: 1 680 000 ETI as mining reward and 420 000 ETI as Staking reward
197       Era3: 1 470 000 ETI as mining reward and 630 000 ETI as Staking reward 
198       Era4: 1 260 000 ETI as mining reward and 840 000 ETI as Staking reward
199       From Era5 to era10: 1 050 000 ETI as mining reward and 1 050 000 ETI as Staking reward
200       */
201 
202       // --- STAKING REWARD --- //
203        // periodrewardtemp: It is the temporary ETI issued per period (7 days) as reward of Etica System during phase 1. (Will be replaced by dynamic inflation of golden number at phase 2)
204          // Calculation of initial periodrewardtemp:
205          // 210 000 / 52.1429 = 4027.3939500871643119; ETI per week
206       periodrewardtemp = 4027393950087164311900; // 4027.393950087164311900 ETI per period (7 days) for era1
207       // --- STAKING REWARD --- //
208 
209       // --- MINING REWARD --- //
210       _totalMiningSupply = 11550000 * 10**uint(decimals);
211 
212 
213       tokensMinted = 0;
214 
215       // Calculation of initial blockreward:
216       // 1 890 000 / 52.1429 = 36246.5455507844788073; ETI per week
217       // amounts to 5178.0779358263541153286 ETI per day;
218       // amounts to 215.7532473260980881386917 ETI per hour;
219       // amounts to 35.9588745543496813564486167 ETI per block for era1 of phase1;
220       blockreward = 35958874554349681356;
221 
222       miningTarget = _MAXIMUM_TARGET;
223 
224       latestDifficultyPeriodStarted = block.timestamp;
225 
226       _startNewMiningEpoch();
227       // --- MINING REWARD --- //
228 
229     // ------------ PHASE 1 (before 21 Million ETI has been reached) -------------- //
230       
231 
232     // ------------ PHASE 2 (after the first 21 Million ETI have been issued) -------------- //
233 
234       // Golden number power 2: 1,6180339887498948482045868343656 * 1,6180339887498948482045868343656 = 2.6180339887498948482045868343656;
235       // Thus yearly inflation target is 2.6180339887498948482045868343656%
236       // inflationrate calculation:
237       // Each Period is 7 days, so we need to get a weekly inflationrate from the yearlyinflationrate target (1.026180339887498948482045868343656): 
238       // 1.026180339887498948482045868343656 ^(1 / 52.1429) = 1,0004957512263080183722688891602;
239       // 1,0004957512263080183722688891602 - 1 = 0,0004957512263080183722688891602;
240       // Hence weekly inflationrate is 0,04957512263080183722688891602%
241       inflationrate = 4957512263080183722688891602;  // (need to multiple by 10^(-31) to get 0,0004957512263080183722688891602;
242 
243     // ------------ PHASE 2 (after the first 21 Million ETI have been issued) -------------- //
244 
245 
246        //The creator gets nothing! The only way to earn Etica is to mine it or earn it as protocol reward
247        //balances[creator] = _totalMiningSupply;
248        //Transfer(address(0), creator, _totalMiningSupply);
249     }
250 
251 
252     function allowance(address tokenOwner, address spender) view public returns(uint){
253         return allowed[tokenOwner][spender];
254     }
255 
256 
257     //approve allowance
258     function approve(address spender, uint tokens) public returns(bool){
259         require(balances[msg.sender] >= tokens);
260         require(tokens > 0);
261 
262         allowed[msg.sender][spender] = tokens;
263         emit Approval(msg.sender, spender, tokens);
264         return true;
265     }
266 
267     //transfer tokens from the  owner account to the account that calls the function
268     function transferFrom(address from, address to, uint tokens) public returns(bool){
269 
270       balances[from] = balances[from].sub(tokens);
271 
272       allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
273 
274       balances[to] = balances[to].add(tokens);
275 
276       emit Transfer(from, to, tokens);
277 
278       return true;
279     }
280 
281     function totalSupply() public view returns (uint){
282         return supply;
283     }
284 
285     function accessibleSupply() public view returns (uint){
286         return supply.sub(UNRECOVERABLE_ETI);
287     }
288 
289     function balanceOf(address tokenOwner) public view returns (uint balance){
290          return balances[tokenOwner];
291      }
292 
293 
294     function transfer(address to, uint tokens) public returns (bool success){
295          require(tokens > 0);
296 
297          balances[msg.sender] = balances[msg.sender].sub(tokens);
298 
299          balances[to] = balances[to].add(tokens);
300 
301          emit Transfer(msg.sender, to, tokens);
302 
303          return true;
304      }
305 
306 
307      // -------------  Mining system functions ---------------- //
308 
309          function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
310 
311 
312              //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
313              bytes32 digest =  keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
314 
315              //the challenge digest must match the expected
316              if (digest != challenge_digest) revert();
317 
318              //the digest must be smaller than the target
319              if(uint256(digest) > miningTarget) revert();
320 
321 
322              //only allow one reward for each challenge
323               bytes32 solution = solutionForChallenge[challengeNumber];
324               solutionForChallenge[challengeNumber] = digest;
325               if(solution != 0x0) revert();  //prevent the same answer from awarding twice
326 
327               if(tokensMinted > 1890000 * 10**uint(decimals)){
328  
329               if(tokensMinted >= 6300000 * 10**uint(decimals)) {
330                 // 6 300 000 = 5 040 000 + 1 260 000;
331                 //era5 to era10
332                 blockreward = 19977152530194267420; // 19.977152530194267420 per block (amounts to 1050000 ETI a year)
333                 periodrewardtemp = 20136969750435821559600; // from era5 to era 10: 20136.9697504358215596 ETI per week
334               }
335 
336               else if (tokensMinted < 3570000 * 10**uint(decimals)) {
337                 // 3 570 000 = 1 890 000 + 1 680 000;
338                 // era2
339                 blockreward = 31963444048310827872; // 31.963444048310827872 ETI per block (amounts to 1680000 ETI a year)
340                 periodrewardtemp = 8054787900174328623800; // era2 8054.787900174328623800 ETI per week
341               }
342               else if (tokensMinted < 5040000 * 10**uint(decimals)) {
343                 // 5 040 000 = 3 570 000 + 1 470 000;
344                 //era3
345                 blockreward = 27968013542271974388; // 27.968013542271974388 ETI per block (amounts to 1470000 ETI a year)
346                 periodrewardtemp = 12082181850261492935800; // era3 12082.181850261492935800 ETI per week
347               }
348               else {
349                 // era4
350                 blockreward = 23972583036233120904; // 23.972583036233120904 per block (amounts to 1260000 ETI a year)
351                 periodrewardtemp = 16109575800348657247700; // era4 16109.575800348657247700 ETI per week
352               }
353 
354               }
355 
356              tokensMinted = tokensMinted.add(blockreward);
357              //Cannot mint more tokens than there are: maximum ETI ever mined: _totalMiningSupply
358              assert(tokensMinted < _totalMiningSupply);
359 
360              supply = supply.add(blockreward);
361              balances[msg.sender] = balances[msg.sender].add(blockreward);
362 
363 
364              //set readonly diagnostics data
365              lastRewardTo = msg.sender;
366              lastRewardEthBlockNumber = block.number;
367 
368 
369               _startNewMiningEpoch();
370 
371                emit Mint(msg.sender, blockreward, epochCount, challengeNumber );
372                emit Transfer(address(this), msg.sender,blockreward);
373 
374             return true;
375 
376          }
377 
378 
379      //a new 'block' to be mined
380      function _startNewMiningEpoch() internal {
381 
382 
383        epochCount = epochCount.add(1);
384 
385        //every so often, readjust difficulty. Dont readjust when deploying
386        if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
387        {
388          _reAdjustDifficulty();
389        }
390 
391 
392        //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
393        //do this last since this is a protection mechanism in the mint() function
394        challengeNumber = blockhash(block.number.sub(1));
395        challengeNumber = keccak256(abi.encode(challengeNumber, RANDOMHASH)); // updates challengeNumber with merged mining protection
396 
397      }
398 
399 
400 
401 
402      //readjust the target with same rules as bitcoin
403      function _reAdjustDifficulty() internal {
404 
405          uint _oldtarget = miningTarget;
406 
407           // should get as close as possible to (2016 * 10 minutes) seconds => 1 209 600 seconds
408          uint ethTimeSinceLastDifficultyPeriod = block.timestamp.sub(latestDifficultyPeriodStarted);      
409 
410          //we want miners to spend 10 minutes to mine each 'block'
411          uint targetTimePerDiffPeriod = _BLOCKS_PER_READJUSTMENT.mul(10 minutes); //Target is 1 209 600 seconds. (2016 * 10 minutes) seconds to mine _BLOCKS_PER_READJUSTMENT blocks of ETI.
412 
413          //if there were less ethereum seconds-timestamp than expected, make it harder
414          if( ethTimeSinceLastDifficultyPeriod < targetTimePerDiffPeriod )
415          {
416 
417               // New Mining Difficulty = Previous Mining Difficulty * (Time To Mine Last 2016 blocks / 1 209 600 seconds)  
418               miningTarget = miningTarget.mul(ethTimeSinceLastDifficultyPeriod).div(targetTimePerDiffPeriod);
419 
420               // the maximum factor of 4 will be applied as in bitcoin
421               if(miningTarget < _oldtarget.div(4)){
422 
423               //make it harder
424               miningTarget = _oldtarget.div(4);
425 
426               }
427 
428          }else{
429 
430                 // New Mining Difficulty = Previous Mining Difficulty * (Time To Mine Last 2016 blocks / 1 209 600 seconds)
431                  miningTarget = miningTarget.mul(ethTimeSinceLastDifficultyPeriod).div(targetTimePerDiffPeriod);
432 
433                 // the maximum factor of 4 will be applied as in bitcoin
434                 if(miningTarget > _oldtarget.mul(4)){
435 
436                  //make it easier
437                  miningTarget = _oldtarget.mul(4);
438 
439                 }
440 
441          }
442 
443         
444 
445          latestDifficultyPeriodStarted = block.timestamp;
446 
447          if(miningTarget < _MINIMUM_TARGET) //very difficult
448          {
449            miningTarget = _MINIMUM_TARGET;
450          }
451 
452          if(miningTarget > _MAXIMUM_TARGET) //very easy
453          {
454            miningTarget = _MAXIMUM_TARGET;
455          }
456      }
457 
458 
459      //this is a recent ethereum block hash, used to prevent pre-mining future blocks
460      function getChallengeNumber() public view returns (bytes32) {
461          return challengeNumber;
462      }
463 
464      //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
465       function getMiningDifficulty() public view returns (uint) {
466          return _MAXIMUM_TARGET.div(miningTarget);
467      }
468 
469      function getMiningTarget() public view returns (uint) {
470         return miningTarget;
471     }
472 
473 
474     //mining reward only if the protocol didnt reach the max ETI supply that can be ever mined: 
475     function getMiningReward() public view returns (uint) {
476          if(tokensMinted <= _totalMiningSupply){
477           return blockreward;
478          }
479          else {
480           return 0;
481          }
482          
483     }
484 
485      //help debug mining software
486      function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
487 
488          bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
489 
490          return digest;
491 
492        }
493 
494          //help debug mining software
495        function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
496 
497            bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
498 
499            if(uint256(digest) > testTarget) revert();
500 
501            return (digest == challenge_digest);
502 
503          }
504 
505 
506 // ------------------      Mining system functions   -------------------------  //
507 
508 // ------------------------------------------------------------------------
509 
510 // Don't accept ETH
511 
512 // ------------------------------------------------------------------------
513 
514 function () payable external {
515 
516     revert();
517 
518 }
519 
520 }
521 
522 
523 
524 
525 contract EticaRelease is EticaToken {
526   /* --------- PROD VALUES -------------  */
527 uint public REWARD_INTERVAL = 7 days; // periods duration 7 jours
528 uint public STAKING_DURATION = 28 days; // default stake duration 28 jours
529 uint public DEFAULT_VOTING_TIME = 21 days; // default voting duration 21 days
530 uint public DEFAULT_REVEALING_TIME = 7 days; // default revealing duration 7 days
531     /* --------- PROD VALUES ------------- */
532 
533 /* --------- TESTING VALUES -------------
534 uint public REWARD_INTERVAL = 1 minutes; // periods duration 7 jours
535 uint public STAKING_DURATION = 4 minutes; // default stake duration 28 jours
536 uint public DEFAULT_VOTING_TIME = 3 minutes; // default voting duration 21 days
537 uint public DEFAULT_REVEALING_TIME = 1 minutes; // default revealing duration 7 days
538  --------- TESTING VALUES -------------*/
539 
540 uint public DISEASE_CREATION_AMOUNT = 100 * 10**uint(decimals); // 100 ETI amount to pay for creating a new disease. Necessary in order to avoid spam. Will create a function that periodically increase it in order to take into account inflation
541 uint public PROPOSAL_DEFAULT_VOTE = 10 * 10**uint(decimals); // 10 ETI amount to vote for creating a new proposal. Necessary in order to avoid spam. Will create a function that periodically increase it in order to take into account inflation
542 
543 
544 uint public APPROVAL_THRESHOLD = 5000; // threshold for proposal to be accepted. 5000 means 50.00 %, 6000 would mean 60.00%
545 uint public PERIODS_PER_THRESHOLD = 5; // number of Periods before readjusting APPROVAL_THRESHOLD
546 uint public SEVERITY_LEVEL = 4; // level of severity of the protocol, the higher the more slash to wrong voters
547 uint public PROPOSERS_INCREASER = 3; // the proposers should get more slashed than regular voters to avoid spam, the higher this var the more severe the protocol will be against bad proposers
548 uint public PROTOCOL_RATIO_TARGET = 7250; // 7250 means the Protocol has a goal of 72.50% proposals approved and 27.5% proposals rejected
549 uint public LAST_PERIOD_COST_UPDATE = 0;
550 
551 
552 struct Period{
553     uint id;
554     uint interval;
555     uint curation_sum; // used for proposals weight system
556     uint editor_sum; // used for proposals weight system
557     uint reward_for_curation; // total ETI issued to be used as Period reward for Curation
558     uint reward_for_editor; // total ETI issued to be used as Period reward for Editor
559     uint forprops; // number of accepted proposals in this period
560     uint againstprops; // number of rejected proposals in this period
561 }
562 
563   struct Stake{
564       uint amount;
565       uint endTime; // Time when the stake will be claimable
566   }
567 
568 // -----------  PROPOSALS STRUCTS  ------------  //
569 
570 // general information of Proposal:
571   struct Proposal{
572       uint id;
573       bytes32 proposed_release_hash; // Hash of "raw_release_hash + name of Disease"
574       bytes32 disease_id;
575       uint period_id;
576       uint chunk_id;
577       address proposer; // address of the proposer
578       string title; // Title of the Proposal
579       string description; // Description of the Proposal
580       string freefield;
581       string raw_release_hash;
582   }
583 
584 // main data of Proposal:
585   struct ProposalData{
586 
587       uint starttime; // epoch time of the proposal
588       uint endtime;  // voting limite
589       uint finalized_time; // when first clmpropbyhash() was called
590       ProposalStatus status; // Only updates once, when the voting process is over
591       ProposalStatus prestatus; // Updates During voting process
592       bool istie;  // will be initialized with value 0. if prop is tie it won't slash nor reward participants
593       uint nbvoters;
594       uint slashingratio; // solidity does not support float type. So will emulate float type by using uint
595       uint forvotes;
596       uint againstvotes;
597       uint lastcuration_weight; // period curation weight of proposal
598       uint lasteditor_weight; // period editor weight of proposal
599   }
600 
601   // -----------  PROPOSALS STRUCTS ------------  //
602 
603     // -----------  CHUNKS STRUCTS ------------  //
604 
605     struct Chunk{
606     uint id;
607     bytes32 diseaseid; // hash of the disease
608     uint idx;
609     string title;
610     string desc;
611   }
612 
613   // -----------  CHUNKS STRUCTS ------------  //
614 
615   // -----------  VOTES STRUCTS ----------------  //
616   struct Vote{
617     bytes32 proposal_hash; // proposed_release_hash of proposal
618     bool approve;
619     bool is_editor;
620     uint amount;
621     address voter; // address of the voter
622     uint timestamp; // epoch time of the vote
623     bool is_claimed; // keeps track of whether or not vote has been claimed to avoid double claim on same vote
624   }
625 
626     struct Commit{
627     uint amount;
628     uint timestamp; // epoch time of the vote
629   }
630     // -----------  VOTES STRUCTS ----------------  //
631 
632     // -----------  DISEASES STRUCTS ----------------  //
633 
634   struct Disease{
635       bytes32 disease_hash;
636       string name;
637   }
638 
639      // -----------  DISEASES STRUCTS ----------------  //
640 
641 enum ProposalStatus { Rejected, Accepted, Pending, Singlevoter }
642 
643 mapping(uint => Period) public periods;
644 uint public periodsCounter;
645 mapping(uint => uint) public PeriodsIssued; // keeps track of which periods have already issued ETI
646 uint public PeriodsIssuedCounter;
647 mapping(uint => uint) public IntervalsPeriods; // keeps track of which intervals have already a period
648 uint public IntervalsPeriodsCounter;
649 
650 mapping(uint => Disease) public diseases; // keeps track of which intervals have already a period
651 uint public diseasesCounter;
652 mapping(bytes32 => uint) public diseasesbyIds; // get disease.index by giving its disease_hash: example: [leiojej757575ero] => [0]  where leiojej757575ero is disease_hash of a Disease
653 mapping(string => bytes32) private diseasesbyNames; // get disease.disease_hash by giving its name: example: ["name of a disease"] => [leiojej757575ero]  where leiojej757575ero is disease_hash of a Disease. Set visibility to private because mapping with strings as keys have issues when public visibility
654 
655 mapping(bytes32 => mapping(uint => bytes32)) public diseaseproposals; // mapping of mapping of all proposals for a disease
656 mapping(bytes32 => uint) public diseaseProposalsCounter; // keeps track of how many proposals for each disease
657 
658 // -----------  PROPOSALS MAPPINGS ------------  //
659 mapping(bytes32 => Proposal) public proposals;
660 mapping(uint => bytes32) public proposalsbyIndex; // get proposal.proposed_release_hash by giving its id (index): example: [2] => [huhihgfytoouhi]  where huhihgfytoouhi is proposed_release_hash of a Proposal
661 uint public proposalsCounter;
662 
663 mapping(bytes32 => ProposalData) public propsdatas;
664 // -----------  PROPOSALS MAPPINGS ------------  //
665 
666 // -----------  CHUNKS MAPPINGS ----------------  //
667 mapping(uint => Chunk) public chunks;
668 uint public chunksCounter;
669 mapping(bytes32 => mapping(uint => uint)) public diseasechunks; // chunks of a disease
670 mapping(uint => mapping(uint => bytes32)) public chunkproposals; // proposals of a chunk
671 mapping(bytes32 => uint) public diseaseChunksCounter; // keeps track of how many chunks for each disease
672 mapping(uint => uint) public chunkProposalsCounter; // keeps track of how many proposals for each chunk
673 // -----------  CHUNKS MAPPINGS ----------------  //
674 
675 // -----------  VOTES MAPPINGS ----------------  //
676 mapping(bytes32 => mapping(address => Vote)) public votes;
677 mapping(address => mapping(bytes32 => Commit)) public commits;
678 // -----------  VOTES MAPPINGS ----------------  //
679 
680 mapping(address => uint) public bosoms;
681 mapping(address => mapping(uint => Stake)) public stakes;
682 mapping(address => uint) public stakesCounters; // keeps track of how many stakes for each user
683 mapping(address => uint) public stakesAmount; // keeps track of total amount of stakes for each user
684 
685 // Blocked ETI amount, user has votes with this amount in process and can't retrieve this amount before the system knows if the user has to be slahed
686 mapping(address => uint) public blockedeticas;
687 
688 // ---------- EVENTS ----------- //
689 event CreatedPeriod(uint indexed period_id, uint interval);
690 event NewDisease(uint indexed diseaseindex, string title);
691 event NewProposal(bytes32 proposed_release_hash, address indexed _proposer, bytes32 indexed diseasehash, uint indexed chunkid);
692 event NewChunk(uint indexed chunkid, bytes32 indexed diseasehash);
693 event RewardClaimed(address indexed voter, uint amount, bytes32 proposal_hash);
694 event NewFee(address indexed voter, uint fee, bytes32 proposal_hash);
695 event NewSlash(address indexed voter, uint duration, bytes32 proposal_hash);
696 event NewCommit(address indexed _voter, bytes32 votehash);
697 event NewReveal(address indexed _voter, bytes32 indexed _proposal);
698 event NewStake(address indexed staker, uint amount);
699 event StakeClaimed(address indexed staker, uint stakeamount);
700 // ----------- EVENTS ---------- //
701 
702 
703 
704 // -------------  PUBLISHING SYSTEM REWARD FUNCTIONS ---------------- //
705 
706 function issue(uint _id) internal returns (bool success) {
707   // we check whether there is at least one period
708   require(periodsCounter > 0);
709 
710   // we check that the period exists
711   require(_id > 0 && _id <= periodsCounter);
712 
713   // we retrieve the period
714   Period storage period = periods[_id];
715 
716   // we check that the period is legit and has been retrieved
717   require(period.id != 0);
718 
719 
720 //only allow one issuance for each period
721 uint rwd = PeriodsIssued[period.id];
722 if(rwd != 0x0) revert();  //prevent the same period from issuing twice
723 
724 uint _periodsupply;
725 
726 // Phase 2 (after 21 000 000 ETI has been reached)
727 if(supply >= 21000000 * 10**(decimals)){
728 _periodsupply = uint((supply.mul(inflationrate)).div(10**(31)));
729 }
730 // Phase 1 (before 21 000 000 ETI has been reached)
731 else {
732   _periodsupply = periodrewardtemp;
733 }
734 
735 // update Period Reward:
736 period.reward_for_curation = uint((_periodsupply.mul(PERIOD_CURATION_REWARD_RATIO)).div(10**(11)));
737 period.reward_for_editor = uint((_periodsupply.mul(PERIOD_EDITOR_REWARD_RATIO)).div(10**(11)));
738 
739 
740 supply = supply.add(_periodsupply);
741 balances[address(this)] = balances[address(this)].add(_periodsupply);
742 PeriodsIssued[period.id] = _periodsupply;
743 PeriodsIssuedCounter = PeriodsIssuedCounter.add(1);
744 
745 return true;
746 
747 }
748 
749 
750 // create a period
751 function newPeriod() internal {
752 
753   uint _interval = uint((block.timestamp).div(REWARD_INTERVAL));
754 
755   //only allow one period for each interval
756   uint rwd = IntervalsPeriods[_interval];
757   if(rwd != 0x0) revert();  //prevent the same interval from having 2 periods
758 
759 
760   periodsCounter = periodsCounter.add(1);
761 
762   // store this interval period
763   periods[periodsCounter] = Period(
764     periodsCounter,
765     _interval,
766     0x0, //_curation_sum
767     0x0, //_editor_sum
768     0x0, //_reward_for_curation
769     0x0, //_reward_for_editor
770     0x0, // _forprops
771     0x0 //_againstprops
772   );
773 
774   // an interval cannot have 2 Periods
775   IntervalsPeriods[_interval] = periodsCounter;
776   IntervalsPeriodsCounter = IntervalsPeriodsCounter.add(1);
777 
778   // issue ETI for this Period Reward
779   issue(periodsCounter);
780 
781 
782   //readjust APPROVAL_THRESHOLD every PERIODS_PER_THRESHOLD periods:
783   if((periodsCounter.sub(1)) % PERIODS_PER_THRESHOLD == 0 && periodsCounter > 1)
784   {
785     readjustThreshold();
786   }
787 
788   emit CreatedPeriod(periodsCounter, _interval);
789 }
790 
791 function readjustThreshold() internal {
792 
793 uint _meanapproval = 0;
794 uint _totalfor = 0; // total of proposals accepetd
795 uint _totalagainst = 0; // total of proposals rejected
796 
797 
798 // calculate the mean approval rate (forprops / againstprops) of last PERIODS_PER_THRESHOLD Periods:
799 for(uint _periodidx = periodsCounter.sub(PERIODS_PER_THRESHOLD); _periodidx <= periodsCounter.sub(1);  _periodidx++){
800    _totalfor = _totalfor.add(periods[_periodidx].forprops);
801    _totalagainst = _totalagainst.add(periods[_periodidx].againstprops); 
802 }
803 
804   if(_totalfor.add(_totalagainst) == 0){
805    _meanapproval = 5000;
806   }
807   else{
808    _meanapproval = uint(_totalfor.mul(10000).div(_totalfor.add(_totalagainst)));
809   }
810 
811 // increase or decrease APPROVAL_THRESHOLD based on comparason between _meanapproval and PROTOCOL_RATIO_TARGET:
812 
813          // if there were not enough approvals:
814          if( _meanapproval < PROTOCOL_RATIO_TARGET )
815          {
816            uint shortage_approvals_rate = (PROTOCOL_RATIO_TARGET.sub(_meanapproval));
817 
818            // require lower APPROVAL_THRESHOLD for next period:
819            APPROVAL_THRESHOLD = uint(APPROVAL_THRESHOLD.sub(((APPROVAL_THRESHOLD.sub(4500)).mul(shortage_approvals_rate)).div(10000)));   // decrease by up to 27.50 % of (APPROVAL_THRESHOLD - 45)
820          }else{
821            uint excess_approvals_rate = uint((_meanapproval.sub(PROTOCOL_RATIO_TARGET)));
822 
823            // require higher APPROVAL_THRESHOLD for next period:
824            APPROVAL_THRESHOLD = uint(APPROVAL_THRESHOLD.add(((10000 - APPROVAL_THRESHOLD).mul(excess_approvals_rate)).div(10000)));   // increase by up to 27.50 % of (100 - APPROVAL_THRESHOLD)
825          }
826 
827 
828          if(APPROVAL_THRESHOLD < 4500) // high discouragement to vote against proposals
829          {
830            APPROVAL_THRESHOLD = 4500;
831          }
832 
833          if(APPROVAL_THRESHOLD > 9900) // high discouragement to vote for proposals
834          {
835            APPROVAL_THRESHOLD = 9900;
836          }
837 
838 }
839 
840 // -------------  PUBLISHING SYSTEM REWARD FUNCTIONS ---------------- //
841 
842 
843 // -------------------- STAKING ----------------------- //
844 // eticatobosoms(): Stake etica in exchange for bosom
845 function eticatobosoms(address _staker, uint _amount) public returns (bool success){
846   require(msg.sender == _staker);
847   require(_amount > 0); // even if transfer require amount > 0 I prefer checking for more security and very few more gas
848   // transfer _amount ETI from staker wallet to contract balance:
849   transfer(address(this), _amount);
850 
851   // Get bosoms and add Stake
852   bosomget(_staker, _amount);
853 
854 
855   return true;
856 
857 }
858 
859 
860 
861 // ----  Get bosoms  ------  //
862 
863 //bosomget(): Get bosoms and add Stake. Only contract is able to call this function:
864 function bosomget (address _staker, uint _amount) internal {
865 
866 addStake(_staker, _amount);
867 bosoms[_staker] = bosoms[_staker].add(_amount);
868 
869 }
870 
871 // ----  Get bosoms  ------  //
872 
873 // ----  add Stake ------  //
874 
875 function addStake(address _staker, uint _amount) internal returns (bool success) {
876 
877     require(_amount > 0);
878     stakesCounters[_staker] = stakesCounters[_staker].add(1); // notice that first stake will have the index of 1 thus not 0 !
879 
880 
881     // increase variable that keeps track of total value of user's stakes
882     stakesAmount[_staker] = stakesAmount[_staker].add(_amount);
883 
884     uint endTime = block.timestamp.add(STAKING_DURATION);
885 
886     // store this stake in _staker's stakes with the index stakesCounters[_staker]
887     stakes[_staker][stakesCounters[_staker]] = Stake(
888       _amount, // stake amount
889       endTime // endTime
890     );
891 
892     emit NewStake(_staker, _amount);
893 
894     return true;
895 }
896 
897 function addConsolidation(address _staker, uint _amount, uint _endTime) internal returns (bool success) {
898 
899     require(_amount > 0);
900     stakesCounters[_staker] = stakesCounters[_staker].add(1); // notice that first stake will have the index of 1 thus not 0 !
901 
902 
903     // increase variable that keeps track of total value of user's stakes
904     stakesAmount[_staker] = stakesAmount[_staker].add(_amount);
905 
906     // store this stake in _staker's stakes with the index stakesCounters[_staker]
907     stakes[_staker][stakesCounters[_staker]] = Stake(
908       _amount, // stake amount
909       _endTime // endTime
910     );
911 
912     emit NewStake(_staker, _amount);
913 
914     return true;
915 }
916 
917 // ----  add Stake ------  //
918 
919 // ----  split Stake ------  //
920 
921 function splitStake(address _staker, uint _amount, uint _endTime) internal returns (bool success) {
922 
923     require(_amount > 0);
924     stakesCounters[_staker] = stakesCounters[_staker].add(1); // notice that first stake will have the index of 1 thus not 0 !
925 
926     // store this stake in _staker's stakes with the index stakesCounters[_staker]
927     stakes[_staker][stakesCounters[_staker]] = Stake(
928       _amount, // stake amount
929       _endTime // endTime
930     );
931 
932 
933     return true;
934 }
935 
936 // ----  split Stake ------  //
937 
938 
939 // ----  Redeem a Stake ------  //
940 //stakeclmidx(): redeem a stake by its index
941 function stakeclmidx (uint _stakeidx) public {
942 
943   // we check that the stake exists
944   require(_stakeidx > 0 && _stakeidx <= stakesCounters[msg.sender]);
945 
946   // we retrieve the stake
947   Stake storage _stake = stakes[msg.sender][_stakeidx];
948 
949   // The stake must be over
950   require(block.timestamp > _stake.endTime);
951 
952   // the amount to be unstaked must be less or equal to the amount of ETI currently marked as blocked in blockedeticas as they need to go through the clmpropbyhash before being unstaked !
953   require(_stake.amount <= stakesAmount[msg.sender].sub(blockedeticas[msg.sender]));
954 
955   // transfer back ETI from contract to staker:
956   balances[address(this)] = balances[address(this)].sub(_stake.amount);
957 
958   balances[msg.sender] = balances[msg.sender].add(_stake.amount);
959 
960   emit Transfer(address(this), msg.sender, _stake.amount);
961   emit StakeClaimed(msg.sender, _stake.amount);
962 
963   // deletes the stake
964   _deletestake(msg.sender, _stakeidx);
965 
966 }
967 
968 // ----  Redeem a Stake ------  //
969 
970 // ----  Remove a Stake ------  //
971 
972 function _deletestake(address _staker,uint _index) internal {
973   // we check that the stake exists
974   require(_index > 0 && _index <= stakesCounters[_staker]);
975 
976   // decrease variable that keeps track of total value of user's stakes
977   stakesAmount[_staker] = stakesAmount[_staker].sub(stakes[_staker][_index].amount);
978 
979   // replace value of stake to be deleted by value of last stake
980   stakes[_staker][_index] = stakes[_staker][stakesCounters[_staker]];
981 
982   // remove last stake
983   stakes[_staker][stakesCounters[_staker]] = Stake(
984     0x0, // amount
985     0x0 // endTime
986     );
987 
988   // updates stakesCounter of _staker
989   stakesCounters[_staker] = stakesCounters[_staker].sub(1);
990 
991 }
992 
993 // ----  Remove a Stake ------  //
994 
995 
996 // ----- Stakes consolidation  ----- //
997 
998 // slashing function needs to loop through stakes. Can create issues for claiming votes:
999 // The function stakescsldt() has been created to consolidate (gather) stakes when user has too much stakes
1000 function stakescsldt(uint _endTime, uint _min_limit, uint _maxidx) public {
1001 
1002 // security to avoid blocking ETI by front end apps that could call function with too high _endTime:
1003 require(_endTime < block.timestamp.add(730 days)); // _endTime cannot be more than two years ahead  
1004 
1005 // _maxidx must be less or equal to nb of stakes and we set a limit for loop of 50:
1006 require(_maxidx <= 50 && _maxidx <= stakesCounters[msg.sender]);
1007 
1008 uint newAmount = 0;
1009 
1010 uint _nbdeletes = 0;
1011 
1012 uint _currentidx = 1;
1013 
1014 for(uint _stakeidx = 1; _stakeidx <= _maxidx;  _stakeidx++) {
1015     // only consolidates if account nb of stakes >= 2 :
1016     if(stakesCounters[msg.sender] >= 2){
1017 
1018     if(_stakeidx <= stakesCounters[msg.sender]){
1019        _currentidx = _stakeidx;
1020     } 
1021     else {
1022       // if _stakeidx > stakesCounters[msg.sender] it means the _deletestake() function has pushed the next stakes at the begining:
1023       _currentidx = _stakeidx.sub(_nbdeletes); //Notice: initial stakesCounters[msg.sender] = stakesCounters[msg.sender] + _nbdeletes. 
1024       //So "_stackidx <= _maxidx <= initial stakesCounters[msg.sender]" ===> "_stakidx <= stakesCounters[msg.sender] + _nbdeletes" ===> "_stackidx - _nbdeletes <= stakesCounters[msg.sender]"
1025       assert(_currentidx >= 1); // makes sure _currentidx is within existing stakes range
1026     }
1027       
1028       //if stake should end sooner than _endTime it can be consolidated into a stake that end latter:
1029       // Plus we check the stake.endTime is above the minimum limit the user is willing to consolidate. For instance user doesn't want to consolidate a stake that is ending tomorrow
1030       if(stakes[msg.sender][_currentidx].endTime <= _endTime && stakes[msg.sender][_currentidx].endTime >= _min_limit) {
1031 
1032         newAmount = newAmount.add(stakes[msg.sender][_currentidx].amount);
1033 
1034         _deletestake(msg.sender, _currentidx);    
1035 
1036         _nbdeletes = _nbdeletes.add(1);
1037 
1038       }  
1039 
1040     }
1041 }
1042 
1043 if (newAmount > 0){
1044 // creates the new Stake
1045 addConsolidation(msg.sender, newAmount, _endTime);
1046 }
1047 
1048 }
1049 
1050 // ----- Stakes consolidation  ----- //
1051 
1052 // ----- Stakes de-consolidation  ----- //
1053 
1054 // this function is necessary because if user has a stake with huge amount and has blocked few ETI then he can't claim the Stake because
1055 // stake.amount > StakesAmount - blockedeticas
1056 function stakesnap(uint _stakeidx, uint _snapamount) public {
1057 
1058   require(_snapamount > 0);
1059   
1060   // we check that the stake exists
1061   require(_stakeidx > 0 && _stakeidx <= stakesCounters[msg.sender]);
1062 
1063   // we retrieve the stake
1064   Stake storage _stake = stakes[msg.sender][_stakeidx];
1065 
1066 
1067   // the stake.amount must be higher than _snapamount:
1068   require(_stake.amount > _snapamount);
1069 
1070   // calculate the amount of new stake:
1071   uint _restAmount = _stake.amount.sub(_snapamount);
1072   
1073   // updates the stake amount:
1074   _stake.amount = _snapamount;
1075 
1076 
1077   // ----- creates a new stake with the rest -------- //
1078   stakesCounters[msg.sender] = stakesCounters[msg.sender].add(1);
1079 
1080   // store this stake in _staker's stakes with the index stakesCounters[_staker]
1081   stakes[msg.sender][stakesCounters[msg.sender]] = Stake(
1082       _restAmount, // stake amount
1083       _stake.endTime // endTime
1084     );
1085   // ------ creates a new stake with the rest ------- //  
1086 
1087 assert(_restAmount > 0);
1088 
1089 }
1090 
1091 // ----- Stakes de-consolidation  ----- //
1092 
1093 
1094 function stakescount(address _staker) public view returns (uint slength){
1095   return stakesCounters[_staker];
1096 }
1097 
1098 // ----------------- STAKING ------------------ //
1099 
1100 
1101 // -------------  PUBLISHING SYSTEM CORE FUNCTIONS ---------------- //
1102 function createdisease(string memory _name) public {
1103 
1104 
1105   // --- REQUIRE PAYMENT FOR ADDING A DISEASE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1106 
1107   // make sure the user has enough ETI to create a disease
1108   require(balances[msg.sender] >= DISEASE_CREATION_AMOUNT);
1109   // transfer DISEASE_CREATION_AMOUNT ETI from user wallet to contract wallet:
1110   transfer(address(this), DISEASE_CREATION_AMOUNT);
1111 
1112   UNRECOVERABLE_ETI = UNRECOVERABLE_ETI.add(DISEASE_CREATION_AMOUNT);
1113 
1114   // --- REQUIRE PAYMENT FOR ADDING A DISEASE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1115 
1116 
1117   bytes32 _diseasehash = keccak256(abi.encode(_name));
1118 
1119   diseasesCounter = diseasesCounter.add(1); // notice that first disease will have the index of 1 thus not 0 !
1120 
1121   //check: if the disease is new we continue, otherwise we exit
1122    if(diseasesbyIds[_diseasehash] != 0x0) revert();  //prevent the same disease from being created twice. The software manages diseases uniqueness based on their unique english name. Note that even the first disease will not have index of 0 thus should pass this check
1123    require(diseasesbyNames[_name] == 0); // make sure it is not overwriting another disease thanks to unexpected string tricks from user
1124 
1125    // store the Disease
1126    diseases[diseasesCounter] = Disease(
1127      _diseasehash,
1128      _name
1129    );
1130 
1131    // Updates diseasesbyIds and diseasesbyNames mappings:
1132    diseasesbyIds[_diseasehash] = diseasesCounter;
1133    diseasesbyNames[_name] = _diseasehash;
1134 
1135    emit NewDisease(diseasesCounter, _name);
1136 
1137 }
1138 
1139 
1140 
1141 function propose(bytes32 _diseasehash, string memory _title, string memory _description, string memory raw_release_hash, string memory _freefield, uint _chunkid) public {
1142 
1143     //check if the disease exits
1144      require(diseasesbyIds[_diseasehash] > 0 && diseasesbyIds[_diseasehash] <= diseasesCounter);
1145      if(diseases[diseasesbyIds[_diseasehash]].disease_hash != _diseasehash) revert(); // second check not necessary but I decided to add it as the gas cost value for security is worth it
1146 
1147     require(_chunkid <= chunksCounter);
1148 
1149      bytes32 _proposed_release_hash = keccak256(abi.encode(raw_release_hash, _diseasehash));
1150      diseaseProposalsCounter[_diseasehash] = diseaseProposalsCounter[_diseasehash].add(1);
1151      diseaseproposals[_diseasehash][diseaseProposalsCounter[_diseasehash]] = _proposed_release_hash;
1152 
1153      proposalsCounter = proposalsCounter.add(1); // notice that first proposal will have the index of 1 thus not 0 !
1154      proposalsbyIndex[proposalsCounter] = _proposed_release_hash;
1155 
1156      // Check that proposal does not already exist
1157      // only allow one proposal for each {raw_release_hash,  _diseasehash} combinasion
1158       bytes32 existing_proposal = proposals[_proposed_release_hash].proposed_release_hash;
1159       if(existing_proposal != 0x0 || proposals[_proposed_release_hash].id != 0) revert();  //prevent the same raw_release_hash from being submited twice on same proposal. Double check for better security and slightly higher gas cost even though one would be enough !
1160 
1161      uint _current_interval = uint((block.timestamp).div(REWARD_INTERVAL));
1162 
1163       // Create new Period if this current interval did not have its Period created yet
1164       if(IntervalsPeriods[_current_interval] == 0x0){
1165         newPeriod();
1166       }
1167 
1168      Proposal storage proposal = proposals[_proposed_release_hash];
1169 
1170        proposal.id = proposalsCounter;
1171        proposal.disease_id = _diseasehash; // _diseasehash has already been checked to equal diseases[diseasesbyIds[_diseasehash]].disease_hash
1172        proposal.period_id = IntervalsPeriods[_current_interval];
1173        proposal.proposed_release_hash = _proposed_release_hash; // Hash of "raw_release_hash + name of Disease",
1174        proposal.proposer = msg.sender;
1175        proposal.title = _title;
1176        proposal.description = _description;
1177        proposal.raw_release_hash = raw_release_hash;
1178        proposal.freefield = _freefield;
1179 
1180 
1181        //  Proposal Data:
1182        ProposalData storage proposaldata = propsdatas[_proposed_release_hash];
1183        proposaldata.status = ProposalStatus.Pending;
1184        proposaldata.istie = true;
1185        proposaldata.prestatus = ProposalStatus.Pending;
1186        proposaldata.nbvoters = 0;
1187        proposaldata.slashingratio = 0;
1188        proposaldata.forvotes = 0;
1189        proposaldata.againstvotes = 0;
1190        proposaldata.lastcuration_weight = 0;
1191        proposaldata.lasteditor_weight = 0;
1192        proposaldata.starttime = block.timestamp;
1193        proposaldata.endtime = block.timestamp.add(DEFAULT_VOTING_TIME);
1194 
1195 
1196 // --- REQUIRE DEFAULT VOTE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1197 
1198     require(bosoms[msg.sender] >= PROPOSAL_DEFAULT_VOTE); // this check is not mandatory as handled by safemath sub function: (bosoms[msg.sender].sub(PROPOSAL_DEFAULT_VOTE))
1199 
1200     // Consume bosom:
1201     bosoms[msg.sender] = bosoms[msg.sender].sub(PROPOSAL_DEFAULT_VOTE);
1202 
1203 
1204     // Block Eticas in eticablkdtbl to prevent user from unstaking before eventual slash
1205     blockedeticas[msg.sender] = blockedeticas[msg.sender].add(PROPOSAL_DEFAULT_VOTE);
1206 
1207 
1208     // store vote:
1209     Vote storage vote = votes[proposal.proposed_release_hash][msg.sender];
1210     vote.proposal_hash = proposal.proposed_release_hash;
1211     vote.approve = true;
1212     vote.is_editor = true;
1213     vote.amount = PROPOSAL_DEFAULT_VOTE;
1214     vote.voter = msg.sender;
1215     vote.timestamp = block.timestamp;
1216 
1217 
1218 
1219       // UPDATE PROPOSAL:
1220       proposaldata.prestatus = ProposalStatus.Singlevoter;
1221 
1222       // if chunk exists and belongs to disease updates proposal.chunk_id:
1223       uint existing_chunk = chunks[_chunkid].id;
1224       if(existing_chunk != 0x0 && chunks[_chunkid].diseaseid == _diseasehash) {
1225         proposal.chunk_id = _chunkid;
1226         // updates chunk proposals infos:
1227         chunkProposalsCounter[_chunkid] = chunkProposalsCounter[_chunkid].add(1);
1228         chunkproposals[_chunkid][chunkProposalsCounter[_chunkid]] = proposal.proposed_release_hash;
1229       }
1230 
1231   // --- REQUIRE DEFAULT VOTE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1232 
1233   RANDOMHASH = keccak256(abi.encode(RANDOMHASH, _proposed_release_hash)); // updates RANDOMHASH
1234 
1235     emit NewProposal(_proposed_release_hash, msg.sender, proposal.disease_id, _chunkid);
1236 
1237 }
1238 
1239 
1240  function updatecost() public {
1241 
1242 // only start to increase PROPOSAL AND DISEASE COSTS once we are in phase2
1243 require(supply >= 21000000 * 10**(decimals));
1244 // update disease and proposal cost each 52 periods to take into account inflation:
1245 require(periodsCounter % 52 == 0);
1246 uint _new_disease_cost = supply.mul(47619046).div(10**13); // disease cost is 0.00047619046% of supply
1247 uint _new_proposal_vote = supply.mul(47619046).div(10**14); // default vote amount is 0.000047619046% of supply
1248 
1249 PROPOSAL_DEFAULT_VOTE = _new_proposal_vote;
1250 DISEASE_CREATION_AMOUNT = _new_disease_cost;
1251 
1252 assert(LAST_PERIOD_COST_UPDATE < periodsCounter);
1253 LAST_PERIOD_COST_UPDATE = periodsCounter;
1254 
1255  }
1256 
1257 
1258 
1259  function commitvote(uint _amount, bytes32 _votehash) public {
1260 
1261 require(_amount > 10);
1262 
1263  // Consume bosom:
1264  require(bosoms[msg.sender] >= _amount); // this check is not mandatory as handled by safemath sub function
1265  bosoms[msg.sender] = bosoms[msg.sender].sub(_amount);
1266 
1267  // Block Eticas in eticablkdtbl to prevent user from unstaking before eventual slash
1268  blockedeticas[msg.sender] = blockedeticas[msg.sender].add(_amount);
1269 
1270  // store _votehash in commits with _amount and current block.timestamp value:
1271  commits[msg.sender][_votehash].amount = commits[msg.sender][_votehash].amount.add(_amount);
1272  commits[msg.sender][_votehash].timestamp = block.timestamp;
1273 
1274  RANDOMHASH = keccak256(abi.encode(RANDOMHASH, _votehash)); // updates RANDOMHASH
1275 
1276 emit NewCommit(msg.sender, _votehash);
1277 
1278  }
1279 
1280 
1281  function revealvote(bytes32 _proposed_release_hash, bool _approved, string memory _vary) public {
1282  
1283 
1284 // --- check commit --- //
1285 bytes32 _votehash;
1286 _votehash = keccak256(abi.encode(_proposed_release_hash, _approved, msg.sender, _vary));
1287 
1288 require(commits[msg.sender][_votehash].amount > 0);
1289 // --- check commit done --- //
1290 
1291 //check if the proposal exists and that we get the right proposal:
1292 Proposal storage proposal = proposals[_proposed_release_hash];
1293 require(proposal.id > 0 && proposal.proposed_release_hash == _proposed_release_hash);
1294 
1295 
1296 ProposalData storage proposaldata = propsdatas[_proposed_release_hash];
1297 
1298  // Verify commit was done within voting time:
1299  require( commits[msg.sender][_votehash].timestamp <= proposaldata.endtime);
1300 
1301  // Verify we are within revealing time:
1302  require( block.timestamp > proposaldata.endtime && block.timestamp <= proposaldata.endtime.add(DEFAULT_REVEALING_TIME));
1303 
1304  require(proposaldata.prestatus != ProposalStatus.Pending); // can vote for proposal only if default vote has changed prestatus of Proposal. Thus can vote only if default vote occured as supposed to
1305 
1306 uint _old_proposal_curationweight = proposaldata.lastcuration_weight;
1307 uint _old_proposal_editorweight = proposaldata.lasteditor_weight;
1308 
1309 
1310 // get Period of Proposal:
1311 Period storage period = periods[proposal.period_id];
1312 
1313 
1314 // Check that vote does not already exist
1315 // only allow one vote for each {raw_release_hash, voter} combinasion
1316 bytes32 existing_vote = votes[proposal.proposed_release_hash][msg.sender].proposal_hash;
1317 if(existing_vote != 0x0 || votes[proposal.proposed_release_hash][msg.sender].amount != 0) revert();  //prevent the same user from voting twice for same raw_release_hash. Double condition check for better security and slightly higher gas cost even though one would be enough !
1318 
1319 
1320  // store vote:
1321  Vote storage vote = votes[proposal.proposed_release_hash][msg.sender];
1322  vote.proposal_hash = proposal.proposed_release_hash;
1323  vote.approve = _approved;
1324  vote.is_editor = false;
1325  vote.amount = commits[msg.sender][_votehash].amount;
1326  vote.voter = msg.sender;
1327  vote.timestamp = block.timestamp;
1328 
1329  proposaldata.nbvoters = proposaldata.nbvoters.add(1);
1330 
1331      // PROPOSAL VAR UPDATE
1332      if(_approved){
1333       proposaldata.forvotes = proposaldata.forvotes.add(commits[msg.sender][_votehash].amount);
1334      }
1335      else {
1336        proposaldata.againstvotes = proposaldata.againstvotes.add(commits[msg.sender][_votehash].amount);
1337      }
1338 
1339 
1340      // Determine slashing conditions
1341      bool _isapproved = false;
1342      bool _istie = false;
1343      uint totalVotes = proposaldata.forvotes.add(proposaldata.againstvotes);
1344      uint _forvotes_numerator = proposaldata.forvotes.mul(10000); // (newproposal_forvotes / totalVotes) will give a number between 0 and 1. Multiply by 10000 to store it as uint
1345      uint _ratio_slashing = 0;
1346 
1347      if ((_forvotes_numerator.div(totalVotes)) > APPROVAL_THRESHOLD){
1348     _isapproved = true;
1349     }
1350     if ((_forvotes_numerator.div(totalVotes)) == APPROVAL_THRESHOLD){
1351         _istie = true;
1352     }
1353 
1354     proposaldata.istie = _istie;
1355 
1356     if (_isapproved){
1357     _ratio_slashing = uint(((10000 - APPROVAL_THRESHOLD).mul(totalVotes)).div(10000));
1358     _ratio_slashing = uint((proposaldata.againstvotes.mul(10000)).div(_ratio_slashing));  
1359     proposaldata.slashingratio = uint(10000 - _ratio_slashing);
1360     }
1361     else{
1362     _ratio_slashing = uint((totalVotes.mul(APPROVAL_THRESHOLD)).div(10000));
1363     _ratio_slashing = uint((proposaldata.forvotes.mul(10000)).div(_ratio_slashing));
1364     proposaldata.slashingratio = uint(10000 - _ratio_slashing);
1365     }
1366 
1367     // Make sure the slashing reward ratio is within expected range:
1368      require(proposaldata.slashingratio >=0 && proposaldata.slashingratio <= 10000);
1369 
1370         // updates period forvotes and againstvotes system
1371         ProposalStatus _newstatus = ProposalStatus.Rejected;
1372         if(_isapproved){
1373          _newstatus = ProposalStatus.Accepted;
1374         }
1375 
1376         if(proposaldata.prestatus == ProposalStatus.Singlevoter){
1377 
1378           if(_isapproved){
1379             period.forprops = period.forprops.add(1);
1380           }
1381           else {
1382             period.againstprops = period.againstprops.add(1);
1383           }
1384         }
1385         // in this case the proposal becomes rejected after being accepted or becomes accepted after being rejected:
1386         else if(_newstatus != proposaldata.prestatus){
1387 
1388          if(_newstatus == ProposalStatus.Accepted){
1389           period.againstprops = period.againstprops.sub(1);
1390           period.forprops = period.forprops.add(1);
1391          }
1392          // in this case proposal is necessarily Rejected:
1393          else {
1394           period.forprops = period.forprops.sub(1);
1395           period.againstprops = period.againstprops.add(1);
1396          }
1397 
1398         }
1399         // updates period forvotes and againstvotes system done
1400 
1401          // Proposal and Period new weight
1402          if (_istie) {
1403          proposaldata.prestatus =  ProposalStatus.Rejected;
1404          proposaldata.lastcuration_weight = 0;
1405          proposaldata.lasteditor_weight = 0;
1406          // Proposal tied, remove proposal curation and editor sum
1407          period.curation_sum = period.curation_sum.sub(_old_proposal_curationweight);
1408          period.editor_sum = period.editor_sum.sub(_old_proposal_editorweight);
1409          }
1410          else {
1411              // Proposal approved, strengthen curation sum
1412          if (_isapproved){
1413              proposaldata.prestatus =  ProposalStatus.Accepted;
1414              proposaldata.lastcuration_weight = proposaldata.forvotes;
1415              proposaldata.lasteditor_weight = proposaldata.forvotes;
1416              // Proposal approved, replace proposal curation and editor sum with forvotes
1417              period.curation_sum = period.curation_sum.sub(_old_proposal_curationweight).add(proposaldata.lastcuration_weight);
1418              period.editor_sum = period.editor_sum.sub(_old_proposal_editorweight).add(proposaldata.lasteditor_weight);
1419          }
1420          else{
1421              proposaldata.prestatus =  ProposalStatus.Rejected;
1422              proposaldata.lastcuration_weight = proposaldata.againstvotes;
1423              proposaldata.lasteditor_weight = 0;
1424              // Proposal rejected, replace proposal curation sum with againstvotes and remove proposal editor sum
1425              period.curation_sum = period.curation_sum.sub(_old_proposal_curationweight).add(proposaldata.lastcuration_weight);
1426              period.editor_sum = period.editor_sum.sub(_old_proposal_editorweight);
1427          }
1428          }
1429          
1430         // resets commit to save space: 
1431         _removecommit(_votehash);
1432         emit NewReveal(msg.sender, proposal.proposed_release_hash);
1433 
1434   }
1435 
1436   function _removecommit(bytes32 _votehash) internal {
1437         commits[msg.sender][_votehash].amount = 0;
1438         commits[msg.sender][_votehash].timestamp = 0;
1439   }
1440 
1441 
1442   function clmpropbyhash(bytes32 _proposed_release_hash) public {
1443 
1444    //check if the proposal exists and that we get the right proposal:
1445    Proposal storage proposal = proposals[_proposed_release_hash];
1446    require(proposal.id > 0 && proposal.proposed_release_hash == _proposed_release_hash);
1447 
1448 
1449    ProposalData storage proposaldata = propsdatas[_proposed_release_hash];
1450    // Verify voting and revealing period is over
1451    require( block.timestamp > proposaldata.endtime.add(DEFAULT_REVEALING_TIME));
1452 
1453    
1454     // we check that the vote exists
1455     Vote storage vote = votes[proposal.proposed_release_hash][msg.sender];
1456     require(vote.proposal_hash == _proposed_release_hash);
1457     
1458     // make impossible to claim same vote twice
1459     require(!vote.is_claimed);
1460     vote.is_claimed = true;
1461 
1462 
1463 
1464   
1465     // De-Block Eticas from eticablkdtbl to enable user to unstake these Eticas
1466     blockedeticas[msg.sender] = blockedeticas[msg.sender].sub(vote.amount);
1467 
1468 
1469     // get Period of Proposal:
1470     Period storage period = periods[proposal.period_id];
1471 
1472    uint _current_interval = uint((block.timestamp).div(REWARD_INTERVAL));
1473 
1474    // Check if Period is ready for claims or if it needs to wait more
1475    uint _min_intervals = uint(((DEFAULT_VOTING_TIME.add(DEFAULT_REVEALING_TIME)).div(REWARD_INTERVAL)).add(1)); // Minimum intervals before claimable
1476    require(_current_interval >= period.interval.add(_min_intervals)); // Period not ready for claims yet. Need to wait more !
1477 
1478   // if status equals pending this is the first claim for this proposal
1479   if (proposaldata.status == ProposalStatus.Pending) {
1480 
1481   // SET proposal new status
1482   if (proposaldata.prestatus == ProposalStatus.Accepted) {
1483             proposaldata.status = ProposalStatus.Accepted;
1484   }
1485   else {
1486     proposaldata.status = ProposalStatus.Rejected;
1487   }
1488 
1489   proposaldata.finalized_time = block.timestamp;
1490 
1491   // NEW STATUS AFTER FIRST CLAIM DONE
1492 
1493   }
1494 
1495 
1496   // only slash and reward if prop is not tie:
1497   if (!proposaldata.istie) {
1498    
1499    // convert boolean to enum format for making comparasion with proposaldata.status possible:
1500    ProposalStatus voterChoice = ProposalStatus.Rejected;
1501    if(vote.approve){
1502      voterChoice = ProposalStatus.Accepted;
1503    }
1504 
1505    if(voterChoice != proposaldata.status) {
1506      // slash loosers: voter has voted wrongly and needs to be slashed
1507      uint _slashRemaining = vote.amount;
1508      uint _extraTimeInt = uint(STAKING_DURATION.mul(SEVERITY_LEVEL).mul(proposaldata.slashingratio).div(10000));
1509 
1510      if(vote.is_editor){
1511      _extraTimeInt = uint(_extraTimeInt.mul(PROPOSERS_INCREASER));
1512      }
1513 
1514 
1515 // REQUIRE FEE if slashingratio is superior to 90.00%:
1516 if(proposaldata.slashingratio > 9000){
1517     // 33% fee if voter is not proposer or 100% fee if voter is proposer
1518     uint _feeRemaining = uint(vote.amount.mul(33).div(100));
1519       if(vote.is_editor){
1520         _feeRemaining = vote.amount;
1521       }
1522     emit NewFee(msg.sender, _feeRemaining, vote.proposal_hash);  
1523     UNRECOVERABLE_ETI = UNRECOVERABLE_ETI.add(_feeRemaining);  
1524      // update _slashRemaining 
1525     _slashRemaining = vote.amount.sub(_feeRemaining);
1526 
1527          for(uint _stakeidxa = 1; _stakeidxa <= stakesCounters[msg.sender];  _stakeidxa++) {
1528       //if stake is big enough and can take into account the whole fee:
1529       if(stakes[msg.sender][_stakeidxa].amount > _feeRemaining) {
1530  
1531         stakes[msg.sender][_stakeidxa].amount = stakes[msg.sender][_stakeidxa].amount.sub(_feeRemaining);
1532         stakesAmount[msg.sender] = stakesAmount[msg.sender].sub(_feeRemaining);
1533         _feeRemaining = 0;
1534          break;
1535       }
1536       else {
1537         // The fee amount is more than or equal to a full stake, so the stake needs to be deleted:
1538           _feeRemaining = _feeRemaining.sub(stakes[msg.sender][_stakeidxa].amount);
1539           _deletestake(msg.sender, _stakeidxa);
1540           if(_feeRemaining == 0){
1541            break;
1542           }
1543       }
1544     }
1545 }
1546 
1547 
1548 
1549 // SLASH only if slash remaining > 0
1550 if(_slashRemaining > 0){
1551   emit NewSlash(msg.sender, _slashRemaining, vote.proposal_hash);
1552          for(uint _stakeidx = 1; _stakeidx <= stakesCounters[msg.sender];  _stakeidx++) {
1553       //if stake is too small and will only be able to take into account a part of the slash:
1554       if(stakes[msg.sender][_stakeidx].amount <= _slashRemaining) {
1555  
1556         stakes[msg.sender][_stakeidx].endTime = stakes[msg.sender][_stakeidx].endTime.add(_extraTimeInt);
1557         _slashRemaining = _slashRemaining.sub(stakes[msg.sender][_stakeidx].amount);
1558         
1559        if(_slashRemaining == 0){
1560          break;
1561        }
1562       }
1563       else {
1564         // The slash amount does not fill a full stake, so the stake needs to be split
1565         uint newAmount = stakes[msg.sender][_stakeidx].amount.sub(_slashRemaining);
1566         uint oldCompletionTime = stakes[msg.sender][_stakeidx].endTime;
1567 
1568         // slash amount split in _slashRemaining and newAmount
1569         stakes[msg.sender][_stakeidx].amount = _slashRemaining; // only slash the part of the stake that amounts to _slashRemaining
1570         stakes[msg.sender][_stakeidx].endTime = stakes[msg.sender][_stakeidx].endTime.add(_extraTimeInt); // slash the stake
1571 
1572         if(newAmount > 0){
1573           // create a new stake with the rest of what remained from original stake that was split in 2
1574           splitStake(msg.sender, newAmount, oldCompletionTime);
1575         }
1576 
1577         break;
1578       }
1579     }
1580 }
1581     // the slash is over
1582    }
1583    else {
1584 
1585    uint _reward_amount = 0;
1586 
1587    // check beforte diving by 0
1588    require(period.curation_sum > 0); // period curation sum pb !
1589    // get curation reward only if voter is not the proposer:
1590    if (!vote.is_editor){
1591    _reward_amount = _reward_amount.add((vote.amount.mul(period.reward_for_curation)).div(period.curation_sum));
1592    }
1593 
1594        // if voter is editor and proposal accepted:
1595     if (vote.is_editor && proposaldata.status == ProposalStatus.Accepted){
1596           // check before dividing by 0
1597           require( period.editor_sum > 0); // Period editor sum pb !
1598           _reward_amount = _reward_amount.add((proposaldata.lasteditor_weight.mul(period.reward_for_editor)).div(period.editor_sum));
1599     }
1600 
1601     require(_reward_amount <= period.reward_for_curation.add(period.reward_for_editor)); // "System logic error. Too much ETICA calculated for reward."
1602 
1603     // SEND ETICA AS REWARD
1604     balances[address(this)] = balances[address(this)].sub(_reward_amount);
1605     balances[msg.sender] = balances[msg.sender].add(_reward_amount);
1606 
1607     emit Transfer(address(this), msg.sender, _reward_amount);
1608     emit RewardClaimed(msg.sender, _reward_amount, _proposed_release_hash);
1609    }
1610 
1611   }   // end bracket if (proposaldata.istie not true)
1612   
1613   }
1614 
1615 
1616     function createchunk(bytes32 _diseasehash, string memory _title, string memory _description) public {
1617 
1618   //check if the disease exits
1619   require(diseasesbyIds[_diseasehash] > 0 && diseasesbyIds[_diseasehash] <= diseasesCounter);
1620   if(diseases[diseasesbyIds[_diseasehash]].disease_hash != _diseasehash) revert(); // second check not necessary but I decided to add it as the gas cost value for security is worth it
1621 
1622   // --- REQUIRE PAYMENT FOR ADDING A CHUNK TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1623   uint _cost = DISEASE_CREATION_AMOUNT.div(20);
1624   // make sure the user has enough ETI to create a chunk
1625   require(balances[msg.sender] >= _cost);
1626   // transfer DISEASE_CREATION_AMOUNT / 20  ETI from user wallet to contract wallet:
1627   transfer(address(this), _cost);
1628 
1629   // --- REQUIRE PAYMENT FOR ADDING A CHUNK TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1630 
1631   chunksCounter = chunksCounter.add(1); // get general id of Chunk
1632 
1633   // updates disease's chunks infos:
1634   diseaseChunksCounter[_diseasehash] = diseaseChunksCounter[_diseasehash].add(1); // Increase chunks index of Disease
1635   diseasechunks[_diseasehash][diseaseChunksCounter[_diseasehash]] = chunksCounter;
1636   
1637 
1638   // store the Chunk
1639    chunks[chunksCounter] = Chunk(
1640      chunksCounter, // general id of the chunk
1641      _diseasehash, // disease of the chunk
1642      diseaseChunksCounter[_diseasehash], // Index of chunk within disease
1643      _title,
1644      _description
1645    );
1646 
1647   UNRECOVERABLE_ETI = UNRECOVERABLE_ETI.add(_cost);
1648   emit NewChunk(chunksCounter, _diseasehash);
1649 
1650   }
1651 
1652 
1653 // -------------  PUBLISHING SYSTEM CORE FUNCTIONS ---------------- //
1654 
1655 
1656 
1657 // -------------  GETTER FUNCTIONS ---------------- //
1658 // get bosoms balance of user:
1659 function bosomsOf(address tokenOwner) public view returns (uint _bosoms){
1660      return bosoms[tokenOwner];
1661  }
1662 
1663  function getdiseasehashbyName(string memory _name) public view returns (bytes32 _diseasehash){
1664      return diseasesbyNames[_name];
1665  }
1666 // -------------  GETTER FUNCTIONS ---------------- //
1667 
1668 }