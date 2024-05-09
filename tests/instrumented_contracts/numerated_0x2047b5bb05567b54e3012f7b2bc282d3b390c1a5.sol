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
138     uint public  _MINIMUM_TARGET = 2**16;
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
285     function balanceOf(address tokenOwner) public view returns (uint balance){
286          return balances[tokenOwner];
287      }
288 
289 
290     function transfer(address to, uint tokens) public returns (bool success){
291          require(tokens > 0);
292 
293          balances[msg.sender] = balances[msg.sender].sub(tokens);
294 
295          balances[to] = balances[to].add(tokens);
296 
297          emit Transfer(msg.sender, to, tokens);
298 
299          return true;
300      }
301 
302 
303      // -------------  Mining system functions ---------------- //
304 
305          function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
306 
307 
308              //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
309              bytes32 digest =  keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
310 
311              //the challenge digest must match the expected
312              if (digest != challenge_digest) revert();
313 
314              //the digest must be smaller than the target
315              if(uint256(digest) > miningTarget) revert();
316 
317 
318              //only allow one reward for each challenge
319               bytes32 solution = solutionForChallenge[challengeNumber];
320               solutionForChallenge[challengeNumber] = digest;
321               if(solution != 0x0) revert();  //prevent the same answer from awarding twice
322 
323               if(tokensMinted > 1890000 * 10**uint(decimals)){
324  
325               if(tokensMinted >= 6300000 * 10**uint(decimals)) {
326                 // 6 300 000 = 5 040 000 + 1 260 000;
327                 //era5 to era10
328                 blockreward = 19977152530194267420; // 19.977152530194267420 per block (amounts to 1050000 ETI a year)
329                 periodrewardtemp = 20136969750435821559600; // from era5 to era 10: 20136.9697504358215596 ETI per week
330               }
331 
332               else if (tokensMinted < 3570000 * 10**uint(decimals)) {
333                 // 3 570 000 = 1 890 000 + 1 680 000;
334                 // era2
335                 blockreward = 31963444048310827872; // 31.963444048310827872 ETI per block (amounts to 1680000 ETI a year)
336                 periodrewardtemp = 8054787900174328623800; // era2 8054.787900174328623800 ETI per week
337               }
338               else if (tokensMinted < 5040000 * 10**uint(decimals)) {
339                 // 5 040 000 = 3 570 000 + 1 470 000;
340                 //era3
341                 blockreward = 27968013542271974388; // 27.968013542271974388 ETI per block (amounts to 1470000 ETI a year)
342                 periodrewardtemp = 12082181850261492935800; // era3 12082.181850261492935800 ETI per week
343               }
344               else {
345                 // era4
346                 blockreward = 23972583036233120904; // 23.972583036233120904 per block (amounts to 1260000 ETI a year)
347                 periodrewardtemp = 16109575800348657247700; // era4 16109.575800348657247700 ETI per week
348               }
349 
350               }
351 
352              tokensMinted = tokensMinted.add(blockreward);
353              //Cannot mint more tokens than there are: maximum ETI ever mined: _totalMiningSupply
354              assert(tokensMinted < _totalMiningSupply);
355 
356              supply = supply.add(blockreward);
357              balances[msg.sender] = balances[msg.sender].add(blockreward);
358 
359 
360              //set readonly diagnostics data
361              lastRewardTo = msg.sender;
362              lastRewardEthBlockNumber = block.number;
363 
364 
365               _startNewMiningEpoch();
366 
367                emit Mint(msg.sender, blockreward, epochCount, challengeNumber );
368 
369             return true;
370 
371          }
372 
373 
374      //a new 'block' to be mined
375      function _startNewMiningEpoch() internal {
376 
377 
378        epochCount = epochCount.add(1);
379 
380        //every so often, readjust difficulty. Dont readjust when deploying
381        if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
382        {
383          _reAdjustDifficulty();
384        }
385 
386 
387        //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
388        //do this last since this is a protection mechanism in the mint() function
389        challengeNumber = blockhash(block.number.sub(1));
390        challengeNumber = keccak256(abi.encode(challengeNumber, RANDOMHASH)); // updates challengeNumber with merged mining protection
391 
392      }
393 
394 
395 
396 
397      //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
398      //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
399 
400      //readjust the target by up to 50 percent
401      function _reAdjustDifficulty() internal {
402 
403           // should get as close as possible to (2016 * 10 minutes) seconds => 1 209 600 seconds
404          uint ethTimeSinceLastDifficultyPeriod = block.timestamp.sub(latestDifficultyPeriodStarted);      
405 
406          //we want miners to spend 10 minutes to mine each 'block'
407          uint targetTimePerDiffPeriod = _BLOCKS_PER_READJUSTMENT.mul(10 minutes); //Target is 1 209 600 seconds. (2016 * 10 minutes) seconds to mine _BLOCKS_PER_READJUSTMENT blocks of ETI.
408 
409          //if there were less eth seconds-timestamp than expected
410          if( ethTimeSinceLastDifficultyPeriod < targetTimePerDiffPeriod )
411          {
412            uint excess_block_pct = (targetTimePerDiffPeriod.mul(100)).div( ethTimeSinceLastDifficultyPeriod );
413 
414            uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
415            // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
416 
417            //make it harder
418            miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
419          }else{
420            uint shortage_block_pct = (ethTimeSinceLastDifficultyPeriod.mul(100)).div( targetTimePerDiffPeriod );
421 
422            uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
423 
424            //make it easier
425            miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
426          }
427 
428 
429 
430          latestDifficultyPeriodStarted = block.timestamp;
431 
432          if(miningTarget < _MINIMUM_TARGET) //very difficult
433          {
434            miningTarget = _MINIMUM_TARGET;
435          }
436 
437          if(miningTarget > _MAXIMUM_TARGET) //very easy
438          {
439            miningTarget = _MAXIMUM_TARGET;
440          }
441      }
442 
443 
444      //this is a recent ethereum block hash, used to prevent pre-mining future blocks
445      function getChallengeNumber() public view returns (bytes32) {
446          return challengeNumber;
447      }
448 
449      //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
450       function getMiningDifficulty() public view returns (uint) {
451          return _MAXIMUM_TARGET.div(miningTarget);
452      }
453 
454      function getMiningTarget() public view returns (uint) {
455         return miningTarget;
456     }
457 
458 
459     //mining reward only if the protocol didnt reach the max ETI supply that can be ever mined: 
460     function getMiningReward() public view returns (uint) {
461          if(tokensMinted <= _totalMiningSupply){
462           return blockreward;
463          }
464          else {
465           return 0;
466          }
467          
468     }
469 
470      //help debug mining software
471      function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
472 
473          bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
474 
475          return digest;
476 
477        }
478 
479          //help debug mining software
480        function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
481 
482            bytes32 digest = keccak256(abi.encodePacked(challenge_number,msg.sender,nonce));
483 
484            if(uint256(digest) > testTarget) revert();
485 
486            return (digest == challenge_digest);
487 
488          }
489 
490 
491 // ------------------      Mining system functions   -------------------------  //
492 
493 // ------------------------------------------------------------------------
494 
495 // Don't accept ETH
496 
497 // ------------------------------------------------------------------------
498 
499 function () payable external {
500 
501     revert();
502 
503 }
504 
505 }
506 
507 
508 
509 
510 contract EticaRelease is EticaToken {
511   /* --------- PROD VALUES -------------  */
512 uint public REWARD_INTERVAL = 7 days; // periods duration 7 jours
513 uint public STAKING_DURATION = 28 days; // default stake duration 28 jours
514 uint public DEFAULT_VOTING_TIME = 21 days; // default voting duration 21 days
515 uint public DEFAULT_REVEALING_TIME = 7 days; // default revealing duration 7 days
516     /* --------- PROD VALUES ------------- */
517 
518 /* --------- TESTING VALUES -------------
519 uint public REWARD_INTERVAL = 1 minutes; // periods duration 7 jours
520 uint public STAKING_DURATION = 4 minutes; // default stake duration 28 jours
521 uint public DEFAULT_VOTING_TIME = 3 minutes; // default voting duration 21 days
522 uint public DEFAULT_REVEALING_TIME = 1 minutes; // default revealing duration 7 days
523  --------- TESTING VALUES -------------*/
524 
525 uint public DISEASE_CREATION_AMOUNT = 100 * 10**uint(decimals); // 100 ETI amount to pay for creating a new disease. Necessary in order to avoid spam. Will create a function that periodically increase it in order to take into account inflation
526 uint public PROPOSAL_DEFAULT_VOTE = 10 * 10**uint(decimals); // 10 ETI amount to vote for creating a new proposal. Necessary in order to avoid spam. Will create a function that periodically increase it in order to take into account inflation
527 
528 
529 uint public APPROVAL_THRESHOLD = 5000; // threshold for proposal to be accepted. 5000 means 50.00 %, 6000 would mean 60.00%
530 uint public PERIODS_PER_THRESHOLD = 5; // number of Periods before readjusting APPROVAL_THRESHOLD
531 uint public SEVERITY_LEVEL = 4; // level of severity of the protocol, the higher the more slash to wrong voters
532 uint public PROPOSERS_INCREASER = 3; // the proposers should get more slashed than regular voters to avoid spam, the higher this var the more severe the protocol will be against bad proposers
533 uint public PROTOCOL_RATIO_TARGET = 7250; // 7250 means the Protocol has a goal of 72.50% proposals approved and 27.5% proposals rejected
534 uint public LAST_PERIOD_COST_UPDATE = 0;
535 
536 
537 struct Period{
538     uint id;
539     uint interval;
540     uint curation_sum; // used for proposals weight system
541     uint editor_sum; // used for proposals weight system
542     uint reward_for_curation; // total ETI issued to be used as Period reward for Curation
543     uint reward_for_editor; // total ETI issued to be used as Period reward for Editor
544     uint forprops; // number of accepted proposals in this period
545     uint againstprops; // number of rejected proposals in this period
546 }
547 
548   struct Stake{
549       uint amount;
550       uint endTime; // Time when the stake will be claimable
551   }
552 
553 // -----------  PROPOSALS STRUCTS  ------------  //
554 
555 // general information of Proposal:
556   struct Proposal{
557       uint id;
558       bytes32 proposed_release_hash; // Hash of "raw_release_hash + name of Disease"
559       bytes32 disease_id;
560       uint period_id;
561       uint chunk_id;
562       address proposer; // address of the proposer
563       string title; // Title of the Proposal
564       string description; // Description of the Proposal
565       string freefield;
566       string raw_release_hash;
567   }
568 
569 // main data of Proposal:
570   struct ProposalData{
571 
572       uint starttime; // epoch time of the proposal
573       uint endtime;  // voting limite
574       uint finalized_time; // when first clmpropbyhash() was called
575       ProposalStatus status; // Only updates once, when the voting process is over
576       ProposalStatus prestatus; // Updates During voting process
577       bool istie;  // will be initialized with value 0. if prop is tie it won't slash nor reward participants
578       uint nbvoters;
579       uint slashingratio; // solidity does not support float type. So will emulate float type by using uint
580       uint forvotes;
581       uint againstvotes;
582       uint lastcuration_weight; // period curation weight of proposal
583       uint lasteditor_weight; // period editor weight of proposal
584   }
585 
586   // -----------  PROPOSALS STRUCTS ------------  //
587 
588     // -----------  CHUNKS STRUCTS ------------  //
589 
590     struct Chunk{
591     uint id;
592     bytes32 diseaseid; // hash of the disease
593     uint idx;
594     string title;
595     string desc;
596   }
597 
598   // -----------  CHUNKS STRUCTS ------------  //
599 
600   // -----------  VOTES STRUCTS ----------------  //
601   struct Vote{
602     bytes32 proposal_hash; // proposed_release_hash of proposal
603     bool approve;
604     bool is_editor;
605     uint amount;
606     address voter; // address of the voter
607     uint timestamp; // epoch time of the vote
608     bool is_claimed; // keeps track of whether or not vote has been claimed to avoid double claim on same vote
609   }
610 
611     struct Commit{
612     uint amount;
613     uint timestamp; // epoch time of the vote
614   }
615     // -----------  VOTES STRUCTS ----------------  //
616 
617     // -----------  DISEASES STRUCTS ----------------  //
618 
619   struct Disease{
620       bytes32 disease_hash;
621       string name;
622   }
623 
624      // -----------  DISEASES STRUCTS ----------------  //
625 
626 enum ProposalStatus { Rejected, Accepted, Pending, Singlevoter }
627 
628 mapping(uint => Period) public periods;
629 uint public periodsCounter;
630 mapping(uint => uint) public PeriodsIssued; // keeps track of which periods have already issued ETI
631 uint public PeriodsIssuedCounter;
632 mapping(uint => uint) public IntervalsPeriods; // keeps track of which intervals have already a period
633 uint public IntervalsPeriodsCounter;
634 
635 mapping(uint => Disease) public diseases; // keeps track of which intervals have already a period
636 uint public diseasesCounter;
637 mapping(bytes32 => uint) public diseasesbyIds; // get disease.index by giving its disease_hash: example: [leiojej757575ero] => [0]  where leiojej757575ero is disease_hash of a Disease
638 mapping(string => bytes32) private diseasesbyNames; // get disease.disease_hash by giving its name: example: ["name of a disease"] => [leiojej757575ero]  where leiojej757575ero is disease_hash of a Disease. Set visibility to private because mapping with strings as keys have issues when public visibility
639 
640 mapping(bytes32 => mapping(uint => bytes32)) public diseaseproposals; // mapping of mapping of all proposals for a disease
641 mapping(bytes32 => uint) public diseaseProposalsCounter; // keeps track of how many proposals for each disease
642 
643 // -----------  PROPOSALS MAPPINGS ------------  //
644 mapping(bytes32 => Proposal) public proposals;
645 mapping(uint => bytes32) public proposalsbyIndex; // get proposal.proposed_release_hash by giving its id (index): example: [2] => [huhihgfytoouhi]  where huhihgfytoouhi is proposed_release_hash of a Proposal
646 uint public proposalsCounter;
647 
648 mapping(bytes32 => ProposalData) public propsdatas;
649 // -----------  PROPOSALS MAPPINGS ------------  //
650 
651 // -----------  CHUNKS MAPPINGS ----------------  //
652 mapping(uint => Chunk) public chunks;
653 uint public chunksCounter;
654 mapping(bytes32 => mapping(uint => uint)) public diseasechunks; // chunks of a disease
655 mapping(uint => mapping(uint => bytes32)) public chunkproposals; // proposals of a chunk
656 mapping(bytes32 => uint) public diseaseChunksCounter; // keeps track of how many chunks for each disease
657 mapping(uint => uint) public chunkProposalsCounter; // keeps track of how many proposals for each chunk
658 // -----------  CHUNKS MAPPINGS ----------------  //
659 
660 // -----------  VOTES MAPPINGS ----------------  //
661 mapping(bytes32 => mapping(address => Vote)) public votes;
662 mapping(address => mapping(bytes32 => Commit)) public commits;
663 // -----------  VOTES MAPPINGS ----------------  //
664 
665 mapping(address => uint) public bosoms;
666 mapping(address => mapping(uint => Stake)) public stakes;
667 mapping(address => uint) public stakesCounters; // keeps track of how many stakes for each user
668 mapping(address => uint) public stakesAmount; // keeps track of total amount of stakes for each user
669 
670 // Blocked ETI amount, user has votes with this amount in process and can't retrieve this amount before the system knows if the user has to be slahed
671 mapping(address => uint) public blockedeticas;
672 
673 // ---------- EVENTS ----------- //
674 event CreatedPeriod(uint indexed period_id, uint interval);
675 event NewDisease(uint indexed diseaseindex, string title);
676 event NewProposal(bytes32 proposed_release_hash, address indexed _proposer, bytes32 indexed diseasehash, uint indexed chunkid);
677 event NewChunk(uint indexed chunkid, bytes32 indexed diseasehash);
678 event RewardClaimed(address indexed voter, uint amount, bytes32 proposal_hash);
679 event NewFee(address indexed voter, uint fee, bytes32 proposal_hash);
680 event NewSlash(address indexed voter, uint duration, bytes32 proposal_hash);
681 event NewCommit(address indexed _voter, bytes32 votehash);
682 event NewReveal(address indexed _voter, bytes32 indexed _proposal);
683 event NewStake(address indexed staker, uint amount);
684 event StakeClaimed(address indexed staker, uint stakeamount);
685 // ----------- EVENTS ---------- //
686 
687 
688 
689 // -------------  PUBLISHING SYSTEM REWARD FUNCTIONS ---------------- //
690 
691 function issue(uint _id) internal returns (bool success) {
692   // we check whether there is at least one period
693   require(periodsCounter > 0);
694 
695   // we check that the period exists
696   require(_id > 0 && _id <= periodsCounter);
697 
698   // we retrieve the period
699   Period storage period = periods[_id];
700 
701   // we check that the period is legit and has been retrieved
702   require(period.id != 0);
703 
704 
705 //only allow one issuance for each period
706 uint rwd = PeriodsIssued[period.id];
707 if(rwd != 0x0) revert();  //prevent the same period from issuing twice
708 
709 uint _periodsupply;
710 
711 // Phase 2 (after 21 000 000 ETI has been reached)
712 if(supply >= 21000000 * 10**(decimals)){
713 _periodsupply = uint((supply.mul(inflationrate)).div(10**(31)));
714 }
715 // Phase 1 (before 21 000 000 ETI has been reached)
716 else {
717   _periodsupply = periodrewardtemp;
718 }
719 
720 // update Period Reward:
721 period.reward_for_curation = uint((_periodsupply.mul(PERIOD_CURATION_REWARD_RATIO)).div(10**(11)));
722 period.reward_for_editor = uint((_periodsupply.mul(PERIOD_EDITOR_REWARD_RATIO)).div(10**(11)));
723 
724 
725 supply = supply.add(_periodsupply);
726 balances[address(this)] = balances[address(this)].add(_periodsupply);
727 PeriodsIssued[period.id] = _periodsupply;
728 PeriodsIssuedCounter = PeriodsIssuedCounter.add(1);
729 
730 return true;
731 
732 }
733 
734 
735 // create a period
736 function newPeriod() internal {
737 
738   uint _interval = uint((block.timestamp).div(REWARD_INTERVAL));
739 
740   //only allow one period for each interval
741   uint rwd = IntervalsPeriods[_interval];
742   if(rwd != 0x0) revert();  //prevent the same interval from having 2 periods
743 
744 
745   periodsCounter = periodsCounter.add(1);
746 
747   // store this interval period
748   periods[periodsCounter] = Period(
749     periodsCounter,
750     _interval,
751     0x0, //_curation_sum
752     0x0, //_editor_sum
753     0x0, //_reward_for_curation
754     0x0, //_reward_for_editor
755     0x0, // _forprops
756     0x0 //_againstprops
757   );
758 
759   // an interval cannot have 2 Periods
760   IntervalsPeriods[_interval] = periodsCounter;
761   IntervalsPeriodsCounter = IntervalsPeriodsCounter.add(1);
762 
763   // issue ETI for this Period Reward
764   issue(periodsCounter);
765 
766 
767   //readjust APPROVAL_THRESHOLD every PERIODS_PER_THRESHOLD periods:
768   if((periodsCounter.sub(1)) % PERIODS_PER_THRESHOLD == 0 && periodsCounter > 1)
769   {
770     readjustThreshold();
771   }
772 
773   emit CreatedPeriod(periodsCounter, _interval);
774 }
775 
776 function readjustThreshold() internal {
777 
778 uint _meanapproval = 0;
779 uint _totalfor = 0; // total of proposals accepetd
780 uint _totalagainst = 0; // total of proposals rejected
781 
782 
783 // calculate the mean approval rate (forprops / againstprops) of last PERIODS_PER_THRESHOLD Periods:
784 for(uint _periodidx = periodsCounter.sub(PERIODS_PER_THRESHOLD); _periodidx <= periodsCounter.sub(1);  _periodidx++){
785    _totalfor = _totalfor.add(periods[_periodidx].forprops);
786    _totalagainst = _totalagainst.add(periods[_periodidx].againstprops); 
787 }
788 
789   if(_totalfor.add(_totalagainst) == 0){
790    _meanapproval = 5000;
791   }
792   else{
793    _meanapproval = uint(_totalfor.mul(10000).div(_totalfor.add(_totalagainst)));
794   }
795 
796 // increase or decrease APPROVAL_THRESHOLD based on comparason between _meanapproval and PROTOCOL_RATIO_TARGET:
797 
798          // if there were not enough approvals:
799          if( _meanapproval < PROTOCOL_RATIO_TARGET )
800          {
801            uint shortage_approvals_rate = (PROTOCOL_RATIO_TARGET.sub(_meanapproval));
802 
803            // require lower APPROVAL_THRESHOLD for next period:
804            APPROVAL_THRESHOLD = uint(APPROVAL_THRESHOLD.sub(((APPROVAL_THRESHOLD.sub(4500)).mul(shortage_approvals_rate)).div(10000)));   // decrease by up to 27.50 % of (APPROVAL_THRESHOLD - 45)
805          }else{
806            uint excess_approvals_rate = uint((_meanapproval.sub(PROTOCOL_RATIO_TARGET)));
807 
808            // require higher APPROVAL_THRESHOLD for next period:
809            APPROVAL_THRESHOLD = uint(APPROVAL_THRESHOLD.add(((10000 - APPROVAL_THRESHOLD).mul(excess_approvals_rate)).div(10000)));   // increase by up to 27.50 % of (100 - APPROVAL_THRESHOLD)
810          }
811 
812 
813          if(APPROVAL_THRESHOLD < 4500) // high discouragement to vote against proposals
814          {
815            APPROVAL_THRESHOLD = 4500;
816          }
817 
818          if(APPROVAL_THRESHOLD > 9900) // high discouragement to vote for proposals
819          {
820            APPROVAL_THRESHOLD = 9900;
821          }
822 
823 }
824 
825 // -------------  PUBLISHING SYSTEM REWARD FUNCTIONS ---------------- //
826 
827 
828 // -------------------- STAKING ----------------------- //
829 // eticatobosoms(): Stake etica in exchange for bosom
830 function eticatobosoms(address _staker, uint _amount) public returns (bool success){
831   require(msg.sender == _staker);
832   require(_amount > 0); // even if transfer require amount > 0 I prefer checking for more security and very few more gas
833   // transfer _amount ETI from staker wallet to contract balance:
834   transfer(address(this), _amount);
835 
836   // Get bosoms and add Stake
837   bosomget(_staker, _amount);
838 
839 
840   return true;
841 
842 }
843 
844 
845 
846 // ----  Get bosoms  ------  //
847 
848 //bosomget(): Get bosoms and add Stake. Only contract is able to call this function:
849 function bosomget (address _staker, uint _amount) internal {
850 
851 addStake(_staker, _amount);
852 bosoms[_staker] = bosoms[_staker].add(_amount);
853 
854 }
855 
856 // ----  Get bosoms  ------  //
857 
858 // ----  add Stake ------  //
859 
860 function addStake(address _staker, uint _amount) internal returns (bool success) {
861 
862     require(_amount > 0);
863     stakesCounters[_staker] = stakesCounters[_staker].add(1); // notice that first stake will have the index of 1 thus not 0 !
864 
865 
866     // increase variable that keeps track of total value of user's stakes
867     stakesAmount[_staker] = stakesAmount[_staker].add(_amount);
868 
869     uint endTime = block.timestamp.add(STAKING_DURATION);
870 
871     // store this stake in _staker's stakes with the index stakesCounters[_staker]
872     stakes[_staker][stakesCounters[_staker]] = Stake(
873       _amount, // stake amount
874       endTime // endTime
875     );
876 
877     emit NewStake(_staker, _amount);
878 
879     return true;
880 }
881 
882 function addConsolidation(address _staker, uint _amount, uint _endTime) internal returns (bool success) {
883 
884     require(_amount > 0);
885     stakesCounters[_staker] = stakesCounters[_staker].add(1); // notice that first stake will have the index of 1 thus not 0 !
886 
887 
888     // increase variable that keeps track of total value of user's stakes
889     stakesAmount[_staker] = stakesAmount[_staker].add(_amount);
890 
891     // store this stake in _staker's stakes with the index stakesCounters[_staker]
892     stakes[_staker][stakesCounters[_staker]] = Stake(
893       _amount, // stake amount
894       _endTime // endTime
895     );
896 
897     emit NewStake(_staker, _amount);
898 
899     return true;
900 }
901 
902 // ----  add Stake ------  //
903 
904 // ----  split Stake ------  //
905 
906 function splitStake(address _staker, uint _amount, uint _endTime) internal returns (bool success) {
907 
908     require(_amount > 0);
909     stakesCounters[_staker] = stakesCounters[_staker].add(1); // notice that first stake will have the index of 1 thus not 0 !
910 
911     // store this stake in _staker's stakes with the index stakesCounters[_staker]
912     stakes[_staker][stakesCounters[_staker]] = Stake(
913       _amount, // stake amount
914       _endTime // endTime
915     );
916 
917 
918     return true;
919 }
920 
921 // ----  split Stake ------  //
922 
923 
924 // ----  Redeem a Stake ------  //
925 //stakeclmidx(): redeem a stake by its index
926 function stakeclmidx (uint _stakeidx) public {
927 
928   // we check that the stake exists
929   require(_stakeidx > 0 && _stakeidx <= stakesCounters[msg.sender]);
930 
931   // we retrieve the stake
932   Stake storage _stake = stakes[msg.sender][_stakeidx];
933 
934   // The stake must be over
935   require(block.timestamp > _stake.endTime);
936 
937   // the amount to be unstaked must be less or equal to the amount of ETI currently marked as blocked in blockedeticas as they need to go through the clmpropbyhash before being unstaked !
938   require(_stake.amount <= stakesAmount[msg.sender].sub(blockedeticas[msg.sender]));
939 
940   // transfer back ETI from contract to staker:
941   balances[address(this)] = balances[address(this)].sub(_stake.amount);
942 
943   balances[msg.sender] = balances[msg.sender].add(_stake.amount);
944 
945   emit Transfer(address(this), msg.sender, _stake.amount);
946   emit StakeClaimed(msg.sender, _stake.amount);
947 
948   // deletes the stake
949   _deletestake(msg.sender, _stakeidx);
950 
951 }
952 
953 // ----  Redeem a Stake ------  //
954 
955 // ----  Remove a Stake ------  //
956 
957 function _deletestake(address _staker,uint _index) internal {
958   // we check that the stake exists
959   require(_index > 0 && _index <= stakesCounters[_staker]);
960 
961   // decrease variable that keeps track of total value of user's stakes
962   stakesAmount[_staker] = stakesAmount[_staker].sub(stakes[_staker][_index].amount);
963 
964   // replace value of stake to be deleted by value of last stake
965   stakes[_staker][_index] = stakes[_staker][stakesCounters[_staker]];
966 
967   // remove last stake
968   stakes[_staker][stakesCounters[_staker]] = Stake(
969     0x0, // amount
970     0x0 // endTime
971     );
972 
973   // updates stakesCounter of _staker
974   stakesCounters[_staker] = stakesCounters[_staker].sub(1);
975 
976 }
977 
978 // ----  Remove a Stake ------  //
979 
980 
981 // ----- Stakes consolidation  ----- //
982 
983 // slashing function needs to loop through stakes. Can create issues for claiming votes:
984 // The function stakescsldt() has been created to consolidate (gather) stakes when user has too much stakes
985 function stakescsldt(uint _endTime, uint _min_limit, uint _maxidx) public {
986 
987 // security to avoid blocking ETI by front end apps that could call function with too high _endTime:
988 require(_endTime < block.timestamp.add(730 days)); // _endTime cannot be more than two years ahead  
989 
990 // _maxidx must be less or equal to nb of stakes and we set a limit for loop of 50:
991 require(_maxidx <= 50 && _maxidx <= stakesCounters[msg.sender]);
992 
993 uint newAmount = 0;
994 
995 uint _nbdeletes = 0;
996 
997 uint _currentidx = 1;
998 
999 for(uint _stakeidx = 1; _stakeidx <= _maxidx;  _stakeidx++) {
1000     // only consolidates if account nb of stakes >= 2 :
1001     if(stakesCounters[msg.sender] >= 2){
1002 
1003     if(_stakeidx <= stakesCounters[msg.sender]){
1004        _currentidx = _stakeidx;
1005     } 
1006     else {
1007       // if _stakeidx > stakesCounters[msg.sender] it means the _deletestake() function has pushed the next stakes at the begining:
1008       _currentidx = _stakeidx.sub(_nbdeletes); //Notice: initial stakesCounters[msg.sender] = stakesCounters[msg.sender] + _nbdeletes. 
1009       //So "_stackidx <= _maxidx <= initial stakesCounters[msg.sender]" ===> "_stakidx <= stakesCounters[msg.sender] + _nbdeletes" ===> "_stackidx - _nbdeletes <= stakesCounters[msg.sender]"
1010       assert(_currentidx >= 1); // makes sure _currentidx is within existing stakes range
1011     }
1012       
1013       //if stake should end sooner than _endTime it can be consolidated into a stake that end latter:
1014       // Plus we check the stake.endTime is above the minimum limit the user is willing to consolidate. For instance user doesn't want to consolidate a stake that is ending tomorrow
1015       if(stakes[msg.sender][_currentidx].endTime <= _endTime && stakes[msg.sender][_currentidx].endTime >= _min_limit) {
1016 
1017         newAmount = newAmount.add(stakes[msg.sender][_currentidx].amount);
1018 
1019         _deletestake(msg.sender, _currentidx);    
1020 
1021         _nbdeletes = _nbdeletes.add(1);
1022 
1023       }  
1024 
1025     }
1026 }
1027 
1028 if (newAmount > 0){
1029 // creates the new Stake
1030 addConsolidation(msg.sender, newAmount, _endTime);
1031 }
1032 
1033 }
1034 
1035 // ----- Stakes consolidation  ----- //
1036 
1037 // ----- Stakes de-consolidation  ----- //
1038 
1039 // this function is necessary because if user has a stake with huge amount and has blocked few ETI then he can't claim the Stake because
1040 // stake.amount > StakesAmount - blockedeticas
1041 function stakesnap(uint _stakeidx, uint _snapamount) public {
1042 
1043   require(_snapamount > 0);
1044   
1045   // we check that the stake exists
1046   require(_stakeidx > 0 && _stakeidx <= stakesCounters[msg.sender]);
1047 
1048   // we retrieve the stake
1049   Stake storage _stake = stakes[msg.sender][_stakeidx];
1050 
1051 
1052   // the stake.amount must be higher than _snapamount:
1053   require(_stake.amount > _snapamount);
1054 
1055   // calculate the amount of new stake:
1056   uint _restAmount = _stake.amount.sub(_snapamount);
1057   
1058   // updates the stake amount:
1059   _stake.amount = _snapamount;
1060 
1061 
1062   // ----- creates a new stake with the rest -------- //
1063   stakesCounters[msg.sender] = stakesCounters[msg.sender].add(1);
1064 
1065   // store this stake in _staker's stakes with the index stakesCounters[_staker]
1066   stakes[msg.sender][stakesCounters[msg.sender]] = Stake(
1067       _restAmount, // stake amount
1068       _stake.endTime // endTime
1069     );
1070   // ------ creates a new stake with the rest ------- //  
1071 
1072 assert(_restAmount > 0);
1073 
1074 }
1075 
1076 // ----- Stakes de-consolidation  ----- //
1077 
1078 
1079 function stakescount(address _staker) public view returns (uint slength){
1080   return stakesCounters[_staker];
1081 }
1082 
1083 // ----------------- STAKING ------------------ //
1084 
1085 
1086 // -------------  PUBLISHING SYSTEM CORE FUNCTIONS ---------------- //
1087 function createdisease(string memory _name) public {
1088 
1089 
1090   // --- REQUIRE PAYMENT FOR ADDING A DISEASE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1091 
1092   // make sure the user has enough ETI to create a disease
1093   require(balances[msg.sender] >= DISEASE_CREATION_AMOUNT);
1094   // transfer DISEASE_CREATION_AMOUNT ETI from user wallet to contract wallet:
1095   transfer(address(this), DISEASE_CREATION_AMOUNT);
1096 
1097   UNRECOVERABLE_ETI = UNRECOVERABLE_ETI.add(DISEASE_CREATION_AMOUNT);
1098 
1099   // --- REQUIRE PAYMENT FOR ADDING A DISEASE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1100 
1101 
1102   bytes32 _diseasehash = keccak256(abi.encode(_name));
1103 
1104   diseasesCounter = diseasesCounter.add(1); // notice that first disease will have the index of 1 thus not 0 !
1105 
1106   //check: if the disease is new we continue, otherwise we exit
1107    if(diseasesbyIds[_diseasehash] != 0x0) revert();  //prevent the same disease from being created twice. The software manages diseases uniqueness based on their unique english name. Note that even the first disease will not have index of 0 thus should pass this check
1108    require(diseasesbyNames[_name] == 0); // make sure it is not overwriting another disease thanks to unexpected string tricks from user
1109 
1110    // store the Disease
1111    diseases[diseasesCounter] = Disease(
1112      _diseasehash,
1113      _name
1114    );
1115 
1116    // Updates diseasesbyIds and diseasesbyNames mappings:
1117    diseasesbyIds[_diseasehash] = diseasesCounter;
1118    diseasesbyNames[_name] = _diseasehash;
1119 
1120    emit NewDisease(diseasesCounter, _name);
1121 
1122 }
1123 
1124 
1125 
1126 function propose(bytes32 _diseasehash, string memory _title, string memory _description, string memory raw_release_hash, string memory _freefield, uint _chunkid) public {
1127 
1128     //check if the disease exits
1129      require(diseasesbyIds[_diseasehash] > 0 && diseasesbyIds[_diseasehash] <= diseasesCounter);
1130      if(diseases[diseasesbyIds[_diseasehash]].disease_hash != _diseasehash) revert(); // second check not necessary but I decided to add it as the gas cost value for security is worth it
1131 
1132     require(_chunkid <= chunksCounter);
1133 
1134      bytes32 _proposed_release_hash = keccak256(abi.encode(raw_release_hash, _diseasehash));
1135      diseaseProposalsCounter[_diseasehash] = diseaseProposalsCounter[_diseasehash].add(1);
1136      diseaseproposals[_diseasehash][diseaseProposalsCounter[_diseasehash]] = _proposed_release_hash;
1137 
1138      proposalsCounter = proposalsCounter.add(1); // notice that first proposal will have the index of 1 thus not 0 !
1139      proposalsbyIndex[proposalsCounter] = _proposed_release_hash;
1140 
1141      // Check that proposal does not already exist
1142      // only allow one proposal for each {raw_release_hash,  _diseasehash} combinasion
1143       bytes32 existing_proposal = proposals[_proposed_release_hash].proposed_release_hash;
1144       if(existing_proposal != 0x0 || proposals[_proposed_release_hash].id != 0) revert();  //prevent the same raw_release_hash from being submited twice on same proposal. Double check for better security and slightly higher gas cost even though one would be enough !
1145 
1146      uint _current_interval = uint((block.timestamp).div(REWARD_INTERVAL));
1147 
1148       // Create new Period if this current interval did not have its Period created yet
1149       if(IntervalsPeriods[_current_interval] == 0x0){
1150         newPeriod();
1151       }
1152 
1153      Proposal storage proposal = proposals[_proposed_release_hash];
1154 
1155        proposal.id = proposalsCounter;
1156        proposal.disease_id = _diseasehash; // _diseasehash has already been checked to equal diseases[diseasesbyIds[_diseasehash]].disease_hash
1157        proposal.period_id = IntervalsPeriods[_current_interval];
1158        proposal.proposed_release_hash = _proposed_release_hash; // Hash of "raw_release_hash + name of Disease",
1159        proposal.proposer = msg.sender;
1160        proposal.title = _title;
1161        proposal.description = _description;
1162        proposal.raw_release_hash = raw_release_hash;
1163        proposal.freefield = _freefield;
1164 
1165 
1166        //  Proposal Data:
1167        ProposalData storage proposaldata = propsdatas[_proposed_release_hash];
1168        proposaldata.status = ProposalStatus.Pending;
1169        proposaldata.istie = true;
1170        proposaldata.prestatus = ProposalStatus.Pending;
1171        proposaldata.nbvoters = 0;
1172        proposaldata.slashingratio = 0;
1173        proposaldata.forvotes = 0;
1174        proposaldata.againstvotes = 0;
1175        proposaldata.lastcuration_weight = 0;
1176        proposaldata.lasteditor_weight = 0;
1177        proposaldata.starttime = block.timestamp;
1178        proposaldata.endtime = block.timestamp.add(DEFAULT_VOTING_TIME);
1179 
1180 
1181 // --- REQUIRE DEFAULT VOTE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1182 
1183     require(bosoms[msg.sender] >= PROPOSAL_DEFAULT_VOTE); // this check is not mandatory as handled by safemath sub function: (bosoms[msg.sender].sub(PROPOSAL_DEFAULT_VOTE))
1184 
1185     // Consume bosom:
1186     bosoms[msg.sender] = bosoms[msg.sender].sub(PROPOSAL_DEFAULT_VOTE);
1187 
1188 
1189     // Block Eticas in eticablkdtbl to prevent user from unstaking before eventual slash
1190     blockedeticas[msg.sender] = blockedeticas[msg.sender].add(PROPOSAL_DEFAULT_VOTE);
1191 
1192 
1193     // store vote:
1194     Vote storage vote = votes[proposal.proposed_release_hash][msg.sender];
1195     vote.proposal_hash = proposal.proposed_release_hash;
1196     vote.approve = true;
1197     vote.is_editor = true;
1198     vote.amount = PROPOSAL_DEFAULT_VOTE;
1199     vote.voter = msg.sender;
1200     vote.timestamp = block.timestamp;
1201 
1202 
1203 
1204       // UPDATE PROPOSAL:
1205       proposaldata.prestatus = ProposalStatus.Singlevoter;
1206 
1207       // if chunk exists and belongs to disease updates proposal.chunk_id:
1208       uint existing_chunk = chunks[_chunkid].id;
1209       if(existing_chunk != 0x0 && chunks[_chunkid].diseaseid == _diseasehash) {
1210         proposal.chunk_id = _chunkid;
1211         // updates chunk proposals infos:
1212         chunkProposalsCounter[_chunkid] = chunkProposalsCounter[_chunkid].add(1);
1213         chunkproposals[_chunkid][chunkProposalsCounter[_chunkid]] = proposal.proposed_release_hash;
1214       }
1215 
1216   // --- REQUIRE DEFAULT VOTE TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1217 
1218   RANDOMHASH = keccak256(abi.encode(RANDOMHASH, _proposed_release_hash)); // updates RANDOMHASH
1219 
1220     emit NewProposal(_proposed_release_hash, msg.sender, proposal.disease_id, _chunkid);
1221 
1222 }
1223 
1224 
1225  function updatecost() public {
1226 
1227 // only start to increase PROPOSAL AND DISEASE COSTS once we are in phase2
1228 require(supply >= 21000000 * 10**(decimals));
1229 // update disease and proposal cost each 52 periods to take into account inflation:
1230 require(periodsCounter % 52 == 0);
1231 uint _new_disease_cost = supply.mul(47619046).div(10**13); // disease cost is 0.00047619046% of supply
1232 uint _new_proposal_vote = supply.mul(47619046).div(10**14); // default vote amount is 0.000047619046% of supply
1233 
1234 PROPOSAL_DEFAULT_VOTE = _new_proposal_vote;
1235 DISEASE_CREATION_AMOUNT = _new_disease_cost;
1236 
1237 assert(LAST_PERIOD_COST_UPDATE < periodsCounter);
1238 LAST_PERIOD_COST_UPDATE = periodsCounter;
1239 
1240  }
1241 
1242 
1243 
1244  function commitvote(uint _amount, bytes32 _votehash) public {
1245 
1246 require(_amount > 10);
1247 
1248  // Consume bosom:
1249  require(bosoms[msg.sender] >= _amount); // this check is not mandatory as handled by safemath sub function
1250  bosoms[msg.sender] = bosoms[msg.sender].sub(_amount);
1251 
1252  // Block Eticas in eticablkdtbl to prevent user from unstaking before eventual slash
1253  blockedeticas[msg.sender] = blockedeticas[msg.sender].add(_amount);
1254 
1255  // store _votehash in commits with _amount and current block.timestamp value:
1256  commits[msg.sender][_votehash].amount = commits[msg.sender][_votehash].amount.add(_amount);
1257  commits[msg.sender][_votehash].timestamp = block.timestamp;
1258 
1259  RANDOMHASH = keccak256(abi.encode(RANDOMHASH, _votehash)); // updates RANDOMHASH
1260 
1261 emit NewCommit(msg.sender, _votehash);
1262 
1263  }
1264 
1265 
1266  function revealvote(bytes32 _proposed_release_hash, bool _approved, string memory _vary) public {
1267  
1268 
1269 // --- check commit --- //
1270 bytes32 _votehash;
1271 _votehash = keccak256(abi.encode(_proposed_release_hash, _approved, msg.sender, _vary));
1272 
1273 require(commits[msg.sender][_votehash].amount > 0);
1274 // --- check commit done --- //
1275 
1276 //check if the proposal exists and that we get the right proposal:
1277 Proposal storage proposal = proposals[_proposed_release_hash];
1278 require(proposal.id > 0 && proposal.proposed_release_hash == _proposed_release_hash);
1279 
1280 
1281 ProposalData storage proposaldata = propsdatas[_proposed_release_hash];
1282 
1283  // Verify commit was done within voting time:
1284  require( commits[msg.sender][_votehash].timestamp <= proposaldata.endtime);
1285 
1286  // Verify we are within revealing time:
1287  require( block.timestamp > proposaldata.endtime && block.timestamp <= proposaldata.endtime.add(DEFAULT_REVEALING_TIME));
1288 
1289  require(proposaldata.prestatus != ProposalStatus.Pending); // can vote for proposal only if default vote has changed prestatus of Proposal. Thus can vote only if default vote occured as supposed to
1290 
1291 uint _old_proposal_curationweight = proposaldata.lastcuration_weight;
1292 uint _old_proposal_editorweight = proposaldata.lasteditor_weight;
1293 
1294 
1295 // get Period of Proposal:
1296 Period storage period = periods[proposal.period_id];
1297 
1298 
1299 // Check that vote does not already exist
1300 // only allow one vote for each {raw_release_hash, voter} combinasion
1301 bytes32 existing_vote = votes[proposal.proposed_release_hash][msg.sender].proposal_hash;
1302 if(existing_vote != 0x0 || votes[proposal.proposed_release_hash][msg.sender].amount != 0) revert();  //prevent the same user from voting twice for same raw_release_hash. Double condition check for better security and slightly higher gas cost even though one would be enough !
1303 
1304 
1305  // store vote:
1306  Vote storage vote = votes[proposal.proposed_release_hash][msg.sender];
1307  vote.proposal_hash = proposal.proposed_release_hash;
1308  vote.approve = _approved;
1309  vote.is_editor = false;
1310  vote.amount = commits[msg.sender][_votehash].amount;
1311  vote.voter = msg.sender;
1312  vote.timestamp = block.timestamp;
1313 
1314  proposaldata.nbvoters = proposaldata.nbvoters.add(1);
1315 
1316      // PROPOSAL VAR UPDATE
1317      if(_approved){
1318       proposaldata.forvotes = proposaldata.forvotes.add(commits[msg.sender][_votehash].amount);
1319      }
1320      else {
1321        proposaldata.againstvotes = proposaldata.againstvotes.add(commits[msg.sender][_votehash].amount);
1322      }
1323 
1324 
1325      // Determine slashing conditions
1326      bool _isapproved = false;
1327      bool _istie = false;
1328      uint totalVotes = proposaldata.forvotes.add(proposaldata.againstvotes);
1329      uint _forvotes_numerator = proposaldata.forvotes.mul(10000); // (newproposal_forvotes / totalVotes) will give a number between 0 and 1. Multiply by 10000 to store it as uint
1330      uint _ratio_slashing = 0;
1331 
1332      if ((_forvotes_numerator.div(totalVotes)) > APPROVAL_THRESHOLD){
1333     _isapproved = true;
1334     }
1335     if ((_forvotes_numerator.div(totalVotes)) == APPROVAL_THRESHOLD){
1336         _istie = true;
1337     }
1338 
1339     proposaldata.istie = _istie;
1340 
1341     if (_isapproved){
1342     _ratio_slashing = uint(((10000 - APPROVAL_THRESHOLD).mul(totalVotes)).div(10000));
1343     _ratio_slashing = uint((proposaldata.againstvotes.mul(10000)).div(_ratio_slashing));  
1344     proposaldata.slashingratio = uint(10000 - _ratio_slashing);
1345     }
1346     else{
1347     _ratio_slashing = uint((totalVotes.mul(APPROVAL_THRESHOLD)).div(10000));
1348     _ratio_slashing = uint((proposaldata.forvotes.mul(10000)).div(_ratio_slashing));
1349     proposaldata.slashingratio = uint(10000 - _ratio_slashing);
1350     }
1351 
1352     // Make sure the slashing reward ratio is within expected range:
1353      require(proposaldata.slashingratio >=0 && proposaldata.slashingratio <= 10000);
1354 
1355         // updates period forvotes and againstvotes system
1356         ProposalStatus _newstatus = ProposalStatus.Rejected;
1357         if(_isapproved){
1358          _newstatus = ProposalStatus.Accepted;
1359         }
1360 
1361         if(proposaldata.prestatus == ProposalStatus.Singlevoter){
1362 
1363           if(_isapproved){
1364             period.forprops = period.forprops.add(1);
1365           }
1366           else {
1367             period.againstprops = period.againstprops.add(1);
1368           }
1369         }
1370         // in this case the proposal becomes rejected after being accepted or becomes accepted after being rejected:
1371         else if(_newstatus != proposaldata.prestatus){
1372 
1373          if(_newstatus == ProposalStatus.Accepted){
1374           period.againstprops = period.againstprops.sub(1);
1375           period.forprops = period.forprops.add(1);
1376          }
1377          // in this case proposal is necessarily Rejected:
1378          else {
1379           period.forprops = period.forprops.sub(1);
1380           period.againstprops = period.againstprops.add(1);
1381          }
1382 
1383         }
1384         // updates period forvotes and againstvotes system done
1385 
1386          // Proposal and Period new weight
1387          if (_istie) {
1388          proposaldata.prestatus =  ProposalStatus.Rejected;
1389          proposaldata.lastcuration_weight = 0;
1390          proposaldata.lasteditor_weight = 0;
1391          // Proposal tied, remove proposal curation and editor sum
1392          period.curation_sum = period.curation_sum.sub(_old_proposal_curationweight);
1393          period.editor_sum = period.editor_sum.sub(_old_proposal_editorweight);
1394          }
1395          else {
1396              // Proposal approved, strengthen curation sum
1397          if (_isapproved){
1398              proposaldata.prestatus =  ProposalStatus.Accepted;
1399              proposaldata.lastcuration_weight = proposaldata.forvotes;
1400              proposaldata.lasteditor_weight = proposaldata.forvotes;
1401              // Proposal approved, replace proposal curation and editor sum with forvotes
1402              period.curation_sum = period.curation_sum.sub(_old_proposal_curationweight).add(proposaldata.lastcuration_weight);
1403              period.editor_sum = period.editor_sum.sub(_old_proposal_editorweight).add(proposaldata.lasteditor_weight);
1404          }
1405          else{
1406              proposaldata.prestatus =  ProposalStatus.Rejected;
1407              proposaldata.lastcuration_weight = proposaldata.againstvotes;
1408              proposaldata.lasteditor_weight = 0;
1409              // Proposal rejected, replace proposal curation sum with againstvotes and remove proposal editor sum
1410              period.curation_sum = period.curation_sum.sub(_old_proposal_curationweight).add(proposaldata.lastcuration_weight);
1411              period.editor_sum = period.editor_sum.sub(_old_proposal_editorweight);
1412          }
1413          }
1414          
1415         // resets commit to save space: 
1416         _removecommit(_votehash);
1417         emit NewReveal(msg.sender, proposal.proposed_release_hash);
1418 
1419   }
1420 
1421   function _removecommit(bytes32 _votehash) internal {
1422         commits[msg.sender][_votehash].amount = 0;
1423         commits[msg.sender][_votehash].timestamp = 0;
1424   }
1425 
1426 
1427   function clmpropbyhash(bytes32 _proposed_release_hash) public {
1428 
1429    //check if the proposal exists and that we get the right proposal:
1430    Proposal storage proposal = proposals[_proposed_release_hash];
1431    require(proposal.id > 0 && proposal.proposed_release_hash == _proposed_release_hash);
1432 
1433 
1434    ProposalData storage proposaldata = propsdatas[_proposed_release_hash];
1435    // Verify voting and revealing period is over
1436    require( block.timestamp > proposaldata.endtime.add(DEFAULT_REVEALING_TIME));
1437 
1438    
1439     // we check that the vote exists
1440     Vote storage vote = votes[proposal.proposed_release_hash][msg.sender];
1441     require(vote.proposal_hash == _proposed_release_hash);
1442     
1443     // make impossible to claim same vote twice
1444     require(!vote.is_claimed);
1445     vote.is_claimed = true;
1446 
1447 
1448 
1449   
1450     // De-Block Eticas from eticablkdtbl to enable user to unstake these Eticas
1451     blockedeticas[msg.sender] = blockedeticas[msg.sender].sub(vote.amount);
1452 
1453 
1454     // get Period of Proposal:
1455     Period storage period = periods[proposal.period_id];
1456 
1457    uint _current_interval = uint((block.timestamp).div(REWARD_INTERVAL));
1458 
1459    // Check if Period is ready for claims or if it needs to wait more
1460    uint _min_intervals = uint(((DEFAULT_VOTING_TIME.add(DEFAULT_REVEALING_TIME)).div(REWARD_INTERVAL)).add(1)); // Minimum intervals before claimable
1461    require(_current_interval >= period.interval.add(_min_intervals)); // Period not ready for claims yet. Need to wait more !
1462 
1463   // if status equals pending this is the first claim for this proposal
1464   if (proposaldata.status == ProposalStatus.Pending) {
1465 
1466   // SET proposal new status
1467   if (proposaldata.prestatus == ProposalStatus.Accepted) {
1468             proposaldata.status = ProposalStatus.Accepted;
1469   }
1470   else {
1471     proposaldata.status = ProposalStatus.Rejected;
1472   }
1473 
1474   proposaldata.finalized_time = block.timestamp;
1475 
1476   // NEW STATUS AFTER FIRST CLAIM DONE
1477 
1478   }
1479 
1480 
1481   // only slash and reward if prop is not tie:
1482   if (!proposaldata.istie) {
1483    
1484    // convert boolean to enum format for making comparasion with proposaldata.status possible:
1485    ProposalStatus voterChoice = ProposalStatus.Rejected;
1486    if(vote.approve){
1487      voterChoice = ProposalStatus.Accepted;
1488    }
1489 
1490    if(voterChoice != proposaldata.status) {
1491      // slash loosers: voter has voted wrongly and needs to be slashed
1492      uint _slashRemaining = vote.amount;
1493      uint _extraTimeInt = uint(STAKING_DURATION.mul(SEVERITY_LEVEL).mul(proposaldata.slashingratio).div(10000));
1494 
1495      if(vote.is_editor){
1496      _extraTimeInt = uint(_extraTimeInt.mul(PROPOSERS_INCREASER));
1497      }
1498 
1499 
1500 // REQUIRE FEE if slashingratio is superior to 90.00%:
1501 if(proposaldata.slashingratio > 9000){
1502     // 33% fee if voter is not proposer or 100% fee if voter is proposer
1503     uint _feeRemaining = uint(vote.amount.mul(33).div(100));
1504       if(vote.is_editor){
1505         _feeRemaining = vote.amount;
1506       }
1507     emit NewFee(msg.sender, _feeRemaining, vote.proposal_hash);  
1508     UNRECOVERABLE_ETI = UNRECOVERABLE_ETI.add(_feeRemaining);  
1509      // update _slashRemaining 
1510     _slashRemaining = vote.amount.sub(_feeRemaining);
1511 
1512          for(uint _stakeidxa = 1; _stakeidxa <= stakesCounters[msg.sender];  _stakeidxa++) {
1513       //if stake is big enough and can take into account the whole fee:
1514       if(stakes[msg.sender][_stakeidxa].amount > _feeRemaining) {
1515  
1516         stakes[msg.sender][_stakeidxa].amount = stakes[msg.sender][_stakeidxa].amount.sub(_feeRemaining);
1517         stakesAmount[msg.sender] = stakesAmount[msg.sender].sub(_feeRemaining);
1518         _feeRemaining = 0;
1519          break;
1520       }
1521       else {
1522         // The fee amount is more than or equal to a full stake, so the stake needs to be deleted:
1523           _feeRemaining = _feeRemaining.sub(stakes[msg.sender][_stakeidxa].amount);
1524           _deletestake(msg.sender, _stakeidxa);
1525           if(_feeRemaining == 0){
1526            break;
1527           }
1528       }
1529     }
1530 }
1531 
1532 
1533 
1534 // SLASH only if slash remaining > 0
1535 if(_slashRemaining > 0){
1536   emit NewSlash(msg.sender, _slashRemaining, vote.proposal_hash);
1537          for(uint _stakeidx = 1; _stakeidx <= stakesCounters[msg.sender];  _stakeidx++) {
1538       //if stake is too small and will only be able to take into account a part of the slash:
1539       if(stakes[msg.sender][_stakeidx].amount <= _slashRemaining) {
1540  
1541         stakes[msg.sender][_stakeidx].endTime = stakes[msg.sender][_stakeidx].endTime.add(_extraTimeInt);
1542         _slashRemaining = _slashRemaining.sub(stakes[msg.sender][_stakeidx].amount);
1543         
1544        if(_slashRemaining == 0){
1545          break;
1546        }
1547       }
1548       else {
1549         // The slash amount does not fill a full stake, so the stake needs to be split
1550         uint newAmount = stakes[msg.sender][_stakeidx].amount.sub(_slashRemaining);
1551         uint oldCompletionTime = stakes[msg.sender][_stakeidx].endTime;
1552 
1553         // slash amount split in _slashRemaining and newAmount
1554         stakes[msg.sender][_stakeidx].amount = _slashRemaining; // only slash the part of the stake that amounts to _slashRemaining
1555         stakes[msg.sender][_stakeidx].endTime = stakes[msg.sender][_stakeidx].endTime.add(_extraTimeInt); // slash the stake
1556 
1557         if(newAmount > 0){
1558           // create a new stake with the rest of what remained from original stake that was split in 2
1559           splitStake(msg.sender, newAmount, oldCompletionTime);
1560         }
1561 
1562         break;
1563       }
1564     }
1565 }
1566     // the slash is over
1567    }
1568    else {
1569 
1570    uint _reward_amount = 0;
1571 
1572    // check beforte diving by 0
1573    require(period.curation_sum > 0); // period curation sum pb !
1574    // get curation reward only if voter is not the proposer:
1575    if (!vote.is_editor){
1576    _reward_amount = _reward_amount.add((vote.amount.mul(period.reward_for_curation)).div(period.curation_sum));
1577    }
1578 
1579        // if voter is editor and proposal accepted:
1580     if (vote.is_editor && proposaldata.status == ProposalStatus.Accepted){
1581           // check before dividing by 0
1582           require( period.editor_sum > 0); // Period editor sum pb !
1583           _reward_amount = _reward_amount.add((proposaldata.lasteditor_weight.mul(period.reward_for_editor)).div(period.editor_sum));
1584     }
1585 
1586     require(_reward_amount <= period.reward_for_curation.add(period.reward_for_editor)); // "System logic error. Too much ETICA calculated for reward."
1587 
1588     // SEND ETICA AS REWARD
1589     balances[address(this)] = balances[address(this)].sub(_reward_amount);
1590     balances[msg.sender] = balances[msg.sender].add(_reward_amount);
1591 
1592     emit Transfer(address(this), msg.sender, _reward_amount);
1593     emit RewardClaimed(msg.sender, _reward_amount, _proposed_release_hash);
1594    }
1595 
1596   }   // end bracket if (proposaldata.istie not true)
1597   
1598   }
1599 
1600 
1601     function createchunk(bytes32 _diseasehash, string memory _title, string memory _description) public {
1602 
1603   //check if the disease exits
1604   require(diseasesbyIds[_diseasehash] > 0 && diseasesbyIds[_diseasehash] <= diseasesCounter);
1605   if(diseases[diseasesbyIds[_diseasehash]].disease_hash != _diseasehash) revert(); // second check not necessary but I decided to add it as the gas cost value for security is worth it
1606 
1607   // --- REQUIRE PAYMENT FOR ADDING A CHUNK TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1608   uint _cost = DISEASE_CREATION_AMOUNT.div(20);
1609   // make sure the user has enough ETI to create a chunk
1610   require(balances[msg.sender] >= _cost);
1611   // transfer DISEASE_CREATION_AMOUNT / 20  ETI from user wallet to contract wallet:
1612   transfer(address(this), _cost);
1613 
1614   // --- REQUIRE PAYMENT FOR ADDING A CHUNK TO CREATE A BARRIER TO ENTRY AND AVOID SPAM --- //
1615 
1616   chunksCounter = chunksCounter.add(1); // get general id of Chunk
1617 
1618   // updates disease's chunks infos:
1619   diseaseChunksCounter[_diseasehash] = diseaseChunksCounter[_diseasehash].add(1); // Increase chunks index of Disease
1620   diseasechunks[_diseasehash][diseaseChunksCounter[_diseasehash]] = chunksCounter;
1621   
1622 
1623   // store the Chunk
1624    chunks[chunksCounter] = Chunk(
1625      chunksCounter, // general id of the chunk
1626      _diseasehash, // disease of the chunk
1627      diseaseChunksCounter[_diseasehash], // Index of chunk within disease
1628      _title,
1629      _description
1630    );
1631 
1632   UNRECOVERABLE_ETI = UNRECOVERABLE_ETI.add(_cost);
1633   emit NewChunk(chunksCounter, _diseasehash);
1634 
1635   }
1636 
1637 
1638 // -------------  PUBLISHING SYSTEM CORE FUNCTIONS ---------------- //
1639 
1640 
1641 
1642 // -------------  GETTER FUNCTIONS ---------------- //
1643 // get bosoms balance of user:
1644 function bosomsOf(address tokenOwner) public view returns (uint _bosoms){
1645      return bosoms[tokenOwner];
1646  }
1647 
1648  function getdiseasehashbyName(string memory _name) public view returns (bytes32 _diseasehash){
1649      return diseasesbyNames[_name];
1650  }
1651 // -------------  GETTER FUNCTIONS ---------------- //
1652 
1653 }