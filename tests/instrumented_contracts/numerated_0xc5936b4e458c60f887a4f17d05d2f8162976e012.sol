1 pragma solidity ^0.4.17;
2 
3 /**
4  * V 1.0. 
5  * (C) profit-chain.net Licensed under MIT terms
6  *
7  * ProfitChain is a game allowing participants to win some Ether. Based on Ethereum intrinsic randomness and difficulty, you must be either lucky or one
8  * hell of a hacker to win... Read the code, and if you find a problem, write owner AT profit-chain.net !
9  *
10  * Investors participate in rounds of fixed size and investment. Once a round is full, a new one opens automatically.
11  * A single winner is picked per round, raking all the round's investments (minus invitor fees).
12  *
13  * Each investor must provide an invitor address when making the first investment in the group.
14  * The game includes a time and depth limited invitation pyramid - you must invest first, then you can invite others. As invitor you'll enjoy a part of invitees investment
15  * and wins, as well as their sub-invitees, for a limited time, and up to certain number of generations.
16  *
17  * There are multiple groups, each with its specific characteristics- to cater to all players.
18  * 
19  * We deter hacking of the winner by making it non-economical:
20  * There is a "security factor" K, which is larger than the group round size N.
21  * For example, for N=10 we may choose K=50.
22  * A few blocks following the round's last investment, the winner is picked if the block's hash mod K is a number of 1...N.
23  * If a hacker miner made a single invetment in the round, the miner would have to match 1 out of 50 "guesses", ie. 50 times greater effort than usual...
24  * If a hacker miner made all invetments but one in the round, the miner would have to match 9 of of 50 "guesses", or about 5 times greater than usual...
25  * And then there's the participation fees, that render even that last scenario non-economical.
26  *
27  * It would take a little over K blocks on average to declare the winner.
28  * At 15 seconds per block, if K=50, it would take on average 13 minutes after the last investment, before a winner is found.
29  * BUT! 
30  * Winner declaration is temporary - checking is done on last 255 blocks. So even if a winner exists now, the winner must be actively named using a transaction while relevant.
31  * A "checkAndDeclareWinner" transaction is required to write the winner (at the time of the transaction!) into the blockchain.
32  * 
33  * All Ether withdrawals, after wins or invitor fees payouts, require execution of a "withdraw" transaction, for safety. 
34  */
35 
36 
37 contract ProfitChain {
38 
39     using SafeMath256 for uint256;
40     using SafeMath32 for uint32;
41     
42     // types
43     
44     struct Investment {
45         address investor;               // who made the investment
46         uint256 sum;                    // actual investment, after fees deduction
47         uint256 time;                   // investment time
48     }
49     
50     struct Round {
51         mapping(uint32 => Investment) investments;      // all investments made in round
52         mapping (address => uint32) investorMapping;    // quickly find an investor by address
53         uint32 totalInvestors;          // the number of investors in round so far
54         uint256 totalInvestment;        // the sum of all investments in round, so far
55         address winner;                 // winner of the round (0 if not yet known)
56         uint256 lastBlock;              // block number of latest investment
57     }
58     
59     struct GroupMember {
60         uint256 joinTime;               // when the pariticipant joined the group
61         address invitor;                // who invited the participant
62     }
63 
64     struct Group {
65         string name;                    // group name
66         uint32 roundSize;               // round size (number of investors)
67         uint256 investment;             // investment size in wei
68         uint32 blocksBeforeWinCheck;    // how many blocks to wait after round's final investment, prior to determining the winner
69         uint32 securityFactor;          // security factor, larger than the group size, to make hacking difficult
70         uint32 invitationFee;           // promiles of invitation fee out of investment and winning
71         uint32 ownerFee;                // promiles of owner fee out of investment
72         uint32 invitationFeePeriod;     // number of days an invitation incurs fees
73         uint8 invitationFeeDepth;       // how many invitors can be paid up the invitation chain
74         bool active;                    // is the group open for new rounds?
75         mapping (address => GroupMember) members;   // all the group members
76         mapping(uint32 => Round) rounds;            // rounds of this group
77         uint32 currentRound;            // the current round
78         uint32 firstUnwonRound;         // the oldest round we need to check for win
79     }
80     
81     
82     // variables
83     string public contractName = "ProfitChain 1.0";
84     uint256 public contractBlock;               // block of contract
85     address public owner;                       // owner of the contract
86     mapping (address => uint256) balances;      // balance of each investor
87     Group[] groups;                             // all groups
88     mapping (string => bool) groupNames;        // for exclusivity of group names
89 
90     // modifiers
91     modifier onlyOwner() {require(msg.sender == owner); _;}
92     
93     // events
94     event GroupCreated(uint32 indexed group, uint256 timestamp);
95     event GroupClosed(uint32 indexed group, uint256 timestamp);
96     event NewInvestor(address indexed investor, uint32 indexed group, uint256 timestamp);
97     event Invest(address indexed investor, uint32 indexed group, uint32 indexed round, uint256 timestamp);
98     event Winner(address indexed payee, uint32 indexed group, uint32 indexed round, uint256 timestamp);
99     event Deposit(address indexed payee, uint256 sum, uint256 timestamp);
100     event Withdraw(address indexed payee, uint256 sum, uint256 timestamp);
101 
102     // functions
103     
104     /**
105      * Constructor:
106      * - owner account
107      */
108     function ProfitChain () public {
109         owner = msg.sender;
110         contractBlock = block.number;
111     }
112 
113     /**
114      * if someones sends Ether directly to the contract - fail it!
115      */
116     function /* fallback */ () public payable {
117         revert();
118     } 
119 
120     /**
121      * Create new group (only owner)
122      */
123     function newGroup (
124         string _groupName, 
125         uint32 _roundSize,
126         uint256 _investment,
127         uint32 _blocksBeforeWinCheck,
128         uint32 _securityFactor,
129         uint32 _invitationFee,
130         uint32 _ownerFee,
131         uint32 _invitationFeePeriod,
132         uint8 _invitationFeeDepth
133     ) public onlyOwner 
134     {
135         // some basic tests
136         require(_roundSize > 0);
137         require(_investment > 0);
138         require(_invitationFee.add(_ownerFee) < 1000);
139         require(_securityFactor > _roundSize);
140         // check if group name exists
141         require(!groupNameExists(_groupName));
142         
143         // create the group
144         Group memory group;
145         group.name = _groupName;
146         group.roundSize = _roundSize;
147         group.investment = _investment;
148         group.blocksBeforeWinCheck = _blocksBeforeWinCheck;
149         group.securityFactor = _securityFactor;
150         group.invitationFee = _invitationFee;
151         group.ownerFee = _ownerFee;
152         group.invitationFeePeriod = _invitationFeePeriod;
153         group.invitationFeeDepth = _invitationFeeDepth;
154         group.active = true;
155         // group.currentRound = 0; // initialized with 0 anyway
156         // group.firstUnwonRound = 0; // initialized with 0 anyway
157         
158         groups.push(group);
159         groupNames[_groupName] = true;
160 
161         // notify world
162         GroupCreated(uint32(groups.length).sub(1), block.timestamp);
163     }
164 
165     /**
166      * Close group (only owner)
167      * Once closed, it will not initiate new rounds.
168      */
169     function closeGroup(uint32 _group) onlyOwner public {
170         // verify group exists and not closed
171         require(groupExists(_group));
172         require(groups[_group].active);
173         
174         groups[_group].active = false;
175 
176         // notify the world
177         GroupClosed(_group, block.timestamp);
178     } 
179     
180     
181     /**
182      * Join group and make first investment
183      * Invitor must already belong to group (or be owner), investor must not.
184      */
185      
186     function joinGroupAndInvest(uint32 _group, address _invitor) payable public {
187         address investor = msg.sender;
188         // owner is not allowed to invest
189         require(msg.sender != owner);
190         // check group exists, investor does not yet belong to group, and invitor exists (or owner)
191         Group storage thisGroup = groups[_group];
192         require(thisGroup.roundSize > 0);
193         require(thisGroup.members[_invitor].joinTime > 0 || _invitor == owner);
194         require(thisGroup.members[investor].joinTime == 0);
195         // check payment is as required
196         require(msg.value == thisGroup.investment);
197         
198         // add investor to group
199         thisGroup.members[investor].joinTime = block.timestamp;
200         thisGroup.members[investor].invitor = _invitor;
201         
202         // notify the world
203         NewInvestor(investor, _group, block.timestamp);
204         
205         // make the first investment
206         invest(_group);
207     }
208 
209     /**
210      * Invest in a group
211      * Can invest once per round.
212      * Must be a member of the group.
213      */
214     function invest(uint32 _group) payable public {
215         address investor = msg.sender;
216         Group storage thisGroup = groups[_group];
217         uint32 round = thisGroup.currentRound;
218         Round storage thisRound = thisGroup.rounds[round];
219         
220         // check the group is still open for business - only if we're about to be the first investors
221         require(thisGroup.active || thisRound.totalInvestors > 0);
222         
223         // check payment is as required
224         require(msg.value == thisGroup.investment);
225         // verify we're members
226         require(thisGroup.members[investor].joinTime > 0);
227         // verify we're not already investors in this round
228         require(! isInvestorInRound(thisRound, investor));
229         
230         // notify the world
231         Invest(investor, _group, round, block.timestamp);
232 
233         // calculate fees. there are owner fee and invitor fee
234         uint256 ownerFee = msg.value.mul(thisGroup.ownerFee).div(1000);
235         balances[owner] = balances[owner].add(ownerFee);
236         Deposit(owner, ownerFee, block.timestamp);
237                 
238         uint256 investedSumLessOwnerFee = msg.value.sub(ownerFee);
239 
240         uint256 invitationFee = payAllInvitors(thisGroup, investor, block.timestamp, investedSumLessOwnerFee, 0);
241 
242         uint256 investedNetSum = investedSumLessOwnerFee.sub(invitationFee);
243         
244         // join the round
245         thisRound.investorMapping[investor] = thisRound.totalInvestors;
246         thisRound.investments[thisRound.totalInvestors] = Investment({
247             investor: investor,
248             sum: investedNetSum,
249             time: block.timestamp});
250         
251         thisRound.totalInvestors = thisRound.totalInvestors.add(1);
252         thisRound.totalInvestment = thisRound.totalInvestment.add(investedNetSum);
253         
254         // check if this round has been completely populated. If so, close this round and prepare the next round
255         if (thisRound.totalInvestors == thisGroup.roundSize) {
256             thisGroup.currentRound = thisGroup.currentRound.add(1);
257             thisRound.lastBlock = block.number;
258         }
259 
260         // every investor also helps by checking for a previous winner.
261         address winner;
262         string memory reason;
263         (winner, reason) = checkWinnerInternal(thisGroup);
264         if (winner != 0)
265             declareWinner(_group, winner);
266     }
267 
268     
269     /**
270      * withdraw collects due funds in a safe manner
271      */
272     function withdraw(uint256 sum) public {
273         address withdrawer = msg.sender;
274         // do we have enough funds for withdrawal?
275         require(balances[withdrawer] >= sum);
276 
277         // notify the world
278         Withdraw(withdrawer, sum, block.timestamp);
279         
280         // update (safely)
281         balances[withdrawer] = balances[withdrawer].sub(sum);
282         withdrawer.transfer(sum);
283     }
284     
285     /**
286      * checkWinner checks if at the time of the call a winner exists for the currently earliest unwon round of the given group.
287      * No declaration is made - so another winner could be selected later!
288      */
289     function checkWinner(uint32 _group) public constant returns (bool foundWinner, string reason) {
290         Group storage thisGroup = groups[_group];
291         require(thisGroup.roundSize > 0);
292         address winner;
293         (winner, reason) = checkWinnerInternal(thisGroup);
294         foundWinner = winner != 0;
295     }
296     
297     /**
298      * checkAndDeclareWinner checks if at the time of the call a winner exists for the currently earliest unwon round of the given group,
299      * and then declares the winner.
300      * Reverts if no winner found, to prevent unnecessary gas expenses.
301      */
302 
303     function checkAndDeclareWinner(uint32 _group) public {
304         Group storage thisGroup = groups[_group];
305         require(thisGroup.roundSize > 0);
306         address winner;
307         string memory reason;
308         (winner, reason) = checkWinnerInternal(thisGroup);
309         // revert if no winner found
310         require(winner != 0);
311         // let's declare the winner!
312         declareWinner(_group, winner);
313     }
314 
315     /**
316      * declareWinner etches the winner into the blockchain.
317      */
318 
319     function declareWinner(uint32 _group, address _winner) internal {
320         // let's declare the winner!
321         Group storage thisGroup = groups[_group];
322         Round storage unwonRound = thisGroup.rounds[thisGroup.firstUnwonRound];
323     
324         unwonRound.winner = _winner;
325         
326         // notify the world
327         Winner(_winner, _group, thisGroup.firstUnwonRound, block.timestamp);
328         uint256 wonSum = unwonRound.totalInvestment;
329         
330         wonSum = wonSum.sub(payAllInvitors(thisGroup, _winner, block.timestamp, wonSum, 0));
331         
332         balances[_winner] = balances[_winner].add(wonSum);
333         
334         Deposit(_winner, wonSum, block.timestamp);
335             
336         // update the unwon round
337         thisGroup.firstUnwonRound = thisGroup.firstUnwonRound.add(1);
338     }
339 
340     /**
341      * checkWinnerInernal tries finding a winner for the oldest non-decided round.
342      * Returns winner != 0 iff a new winner was found, as well as reason
343      */
344     function checkWinnerInternal(Group storage thisGroup) internal constant returns (address winner, string reason) {
345         winner = 0; // assume have not found a new winner
346         // some tests
347         // the first round has no previous rounds to check
348         if (thisGroup.currentRound == 0) {
349             reason = 'Still in first round';
350             return;
351         }
352         // we don't check current round - by definition it is not full
353         if (thisGroup.currentRound == thisGroup.firstUnwonRound) {
354             reason = 'No unwon finished rounds';
355             return;
356         }
357      
358         Round storage unwonRound = thisGroup.rounds[thisGroup.firstUnwonRound];
359         
360         // we will scan a range of blocks, from unwonRound.lastBlock + thisGroup.blocksBeforeWinCheck;
361         uint256 firstBlock = unwonRound.lastBlock.add(thisGroup.blocksBeforeWinCheck);
362         // but we can't scan more than 255 blocks into the past
363         // the first test is for testing environments that may have less than 256 blocks :)
364         if (block.number > 255 && firstBlock < block.number.sub(255))
365             firstBlock = block.number.sub(255);
366         // the scan ends at the last committed block
367         uint256 lastBlock = block.number.sub(1);
368 
369         for (uint256 thisBlock = firstBlock; thisBlock <= lastBlock; thisBlock = thisBlock.add(1)) {
370             uint256 latestHash = uint256(block.blockhash(thisBlock));
371             // we're "drawing" a winner out of the security-factor-sized group - perhaps no winner at all  
372             uint32 drawn = uint32(latestHash % thisGroup.securityFactor);
373             if (drawn < thisGroup.roundSize) {
374                 // we have a winner!
375                 winner = unwonRound.investments[drawn].investor;
376                 return;
377             }
378         }
379         reason = 'No winner picked';
380     } 
381     
382     /**
383      * Given a group, investor and amount of wei, pay all the eligible invitors.
384      * NOTE: does not draw from the _payer balance - we're assuming the returned value will be deducted when necessary.
385      * NOTE 2: a recursive call, yet the depth is limited by 8-bits so no real stack concren.
386      * Return the amount of wei to be deducted from the payer
387      */
388     function payAllInvitors(Group storage thisGroup, address _payer, uint256 _relevantTime, uint256 _amount, uint32 _depth) internal returns (uint256 invitationFee) {
389 
390         address invitor = thisGroup.members[_payer].invitor;
391         // conditions for payment:
392         if (
393         // the payer's invitor is not the owner...
394             invitor == owner ||
395         // must have something to share...
396             _amount == 0 ||
397         // no more than specified depth
398             _depth >= thisGroup.invitationFeeDepth ||
399         // the invitor's invitation time has not expired
400             _relevantTime > thisGroup.members[_payer].joinTime.add(thisGroup.invitationFeePeriod.mul(1 days))
401         ) {
402             return;
403         }
404 
405         // compute how much to pay
406         invitationFee = _amount.mul(thisGroup.invitationFee).div(1000);
407         
408         // we may have reached rock bottom - don't continue
409         if (invitationFee == 0) return;
410 
411         // calculate recursively even higher-hierarcy fees
412         uint256 invitorFee = payAllInvitors(thisGroup, invitor, _relevantTime,  invitationFee, _depth.add(1));
413         
414         // out net invitation fees are...
415         uint256 paid = invitationFee.sub(invitorFee);
416         
417         // pay
418         balances[invitor] = balances[invitor].add(paid);
419         
420         // notify the world
421         Deposit(invitor, paid, block.timestamp);
422     }
423 
424 
425     
426     /**
427      * Is a specific investor in a specific round?
428      */
429     function isInvestorInRound(Round storage _round, address _investor) internal constant returns (bool investorInRound) {
430         return (_round.investments[_round.investorMapping[_investor]].investor == _investor);
431     }
432     
433     
434     /**
435      * Get info about specific account
436      */
437     function balanceOf(address investor) public constant returns (uint256 balance) {
438         balance = balances[investor];
439     }
440     
441      
442     /**
443      * Get info about groups
444      */
445     function groupsCount() public constant returns (uint256 count) {
446         count = groups.length;
447     }
448      
449     /**
450      * Get info about specific group
451      */ 
452     function groupInfo(uint32 _group) public constant returns (
453         string name,
454         uint32 roundSize,
455         uint256 investment,
456         uint32 blocksBeforeWinCheck,
457         uint32 securityFactor,
458         uint32 invitationFee,
459         uint32 ownerFee,
460         uint32 invitationFeePeriod,
461         uint8 invitationFeeDepth,
462         bool active,
463         uint32 currentRound,
464         uint32 firstUnwonRound
465     ) {
466         require(groupExists(_group));
467         Group storage thisGroup = groups[_group];
468         name = thisGroup.name;
469         roundSize = thisGroup.roundSize;
470         investment = thisGroup.investment;
471         blocksBeforeWinCheck = thisGroup.blocksBeforeWinCheck;
472         securityFactor = thisGroup.securityFactor;
473         invitationFee = thisGroup.invitationFee;
474         ownerFee = thisGroup.ownerFee;
475         invitationFeePeriod = thisGroup.invitationFeePeriod;
476         invitationFeeDepth = thisGroup.invitationFeeDepth;
477         active = thisGroup.active;
478         currentRound = thisGroup.currentRound;
479         firstUnwonRound = thisGroup.firstUnwonRound;
480     }
481     
482      
483     /**
484      * Get info about specific group member
485      */
486     function groupMemberInfo (uint32 _group, address investor) public constant returns (
487         uint256 joinTime,
488         address invitor
489     ) {
490         require(groupExists(_group));
491         GroupMember storage groupMember = groups[_group].members[investor];
492         joinTime = groupMember.joinTime;
493         invitor = groupMember.invitor;
494     }
495     
496     /**
497      * Get info about specific group's round
498      */
499     function roundInfo (uint32 _group, uint32 _round) public constant returns (
500         uint32 totalInvestors,
501         uint256 totalInvestment,
502         address winner,
503         uint256 lastBlock
504     ) {
505         require(groupExists(_group));
506         Round storage round = groups[_group].rounds[_round];
507         totalInvestors = round.totalInvestors;
508         totalInvestment = round.totalInvestment;
509         winner = round.winner;
510         lastBlock = round.lastBlock;
511     } 
512     
513     /**
514      * Get info about specific round's investment, by investor
515      */
516     function roundInvestorInfoByAddress (uint32 _group, uint32 _round, address investor) public constant returns (
517         bool inRound,
518         uint32 index
519     ) {
520         require(groupExists(_group));
521         index = groups[_group].rounds[_round].investorMapping[investor];
522         inRound = isInvestorInRound(groups[_group].rounds[_round], investor);
523     }
524     
525     /**
526      * Get info about specific round's investment - by index
527      */
528     function roundInvestorInfoByIndex (uint32 _group, uint32 _round, uint32 _index) public constant returns (
529         address investor,
530         uint256 sum,
531         uint256 time
532     ) {
533         require(groupExists(_group));
534         require(groups[_group].rounds[_round].totalInvestors > _index);
535         Investment storage investment = groups[_group].rounds[_round].investments[_index];
536         investor = investment.investor;
537         sum = investment.sum;
538         time = investment.time;
539     }
540 
541     /**
542      * Does group name exist?
543      */
544     function groupNameExists(string _groupName) internal constant returns (bool exists) {
545         return groupNames[_groupName];
546     }
547 
548     function groupExists(uint32 _group) internal constant returns (bool exists) {
549         return _group < groups.length;
550     }
551 
552 }
553 
554 
555 
556 
557 
558 library SafeMath256 {
559   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
560     uint256 c = a * b;
561     require(a == 0 || c / a == b);
562     return c;
563   }
564 
565   function div(uint256 a, uint256 b) internal pure returns (uint256) {
566     // require(b > 0); // Solidity automatically throws when dividing by 0
567     uint256 c = a / b;
568     // require(a == b * c + a % b); // There is no case in which this doesn't hold
569     return c;
570   }
571 
572   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
573     require(b <= a);
574     return a - b;
575   }
576 
577   function add(uint256 a, uint256 b) internal pure returns (uint256) {
578     uint256 c = a + b;
579     require(c >= a);
580     return c;
581   }
582 }
583 
584 library SafeMath32 {
585   function mul(uint32 a, uint32 b) internal pure returns (uint32) {
586     uint32 c = a * b;
587     require(a == 0 || c / a == b);
588     return c;
589   }
590 
591   function div(uint32 a, uint32 b) internal pure returns (uint32) {
592     // require(b > 0); // Solidity automatically throws when dividing by 0
593     uint32 c = a / b;
594     // require(a == b * c + a % b); // There is no case in which this doesn't hold
595     return c;
596   }
597 
598   function sub(uint32 a, uint32 b) internal pure returns (uint32) {
599     require(b <= a);
600     return a - b;
601   }
602 
603   function add(uint32 a, uint32 b) internal pure returns (uint32) {
604     uint32 c = a + b;
605     require(c >= a);
606     return c;
607   }
608 }