1 pragma solidity ^0.4.21;
2 // Redenom 2.9.0023
3 // The GNU General Public License v3
4 // © Musqogees Tech 2018, Redenom ™
5 
6     
7 // -------------------- SAFE MATH ----------------------------------------------
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Basic ERC20 functions
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public view returns (uint);
32     function balanceOf(address tokenOwner) public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 // ----------------------------------------------------------------------------
43 // Owned contract manages Owner and Admin rights.
44 // Owner is Admin by default and can set other Admin
45 // ----------------------------------------------------------------------------
46 contract Owned {
47     address public owner;
48     address public newOwner;
49     address internal admin;
50 
51     // modifier for Owner functions
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56     // modifier for Admin functions
57     modifier onlyAdmin {
58         require(msg.sender == admin || msg.sender == owner);
59         _;
60     }
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63     event AdminChanged(address indexed _from, address indexed _to);
64 
65     // Constructor
66     function Owned() public {
67         owner = msg.sender;
68         admin = msg.sender;
69     }
70 
71     function setAdmin(address newAdmin) public onlyOwner{
72         emit AdminChanged(admin, newAdmin);
73         admin = newAdmin;
74     }
75 
76     function showAdmin() public view onlyAdmin returns(address _admin){
77         _admin = admin;
78         return _admin;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84 
85     function acceptOwnership() public {
86         require(msg.sender == newOwner);
87         emit OwnershipTransferred(owner, newOwner);
88         owner = newOwner;
89         newOwner = address(0);
90     }
91 }
92 
93 // ----------------------------------------------------------------------------
94 // Contract function to receive approval and execute function in one call
95 // Borrowed from MiniMeToken
96 // ----------------------------------------------------------------------------
97 contract ApproveAndCallFallBack {
98     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
99 }
100 
101 
102 contract Redenom is ERC20Interface, Owned{
103     using SafeMath for uint;
104     
105     //ERC20 params
106     string      public name; // ERC20 
107     string      public symbol; // ERC20 
108     uint        private _totalSupply; // ERC20
109     uint        public decimals = 8; // ERC20 
110 
111 
112     //Redenomination
113     uint public round = 1; 
114     uint public epoch = 1; 
115 
116     bool public frozen = false;
117 
118     //dec - sum of every exponent
119     uint[8] private dec = [0,0,0,0,0,0,0,0];
120     //mul - internal used array for splitting numbers according to round     
121     uint[9] private mul = [1,10,100,1000,10000,100000,1000000,10000000,100000000];
122     //weight - internal used array (weights of every digit)    
123     uint[9] private weight = [uint(0),0,0,0,0,5,10,30,55];
124     //current_toadd - After redenominate() it holds an amount to add on each digit.
125     uint[9] private current_toadd = [uint(0),0,0,0,0,0,0,0,0];
126    
127 
128     //Funds
129     uint public total_fund; // All funds for 100 epochs 100 000 000 NOM
130     uint public epoch_fund; // All funds for current epoch 100 000 NOM
131     uint public team_fund; // Team Fund 10% of all funds paid
132     uint public redenom_dao_fund; // DAO Fund 30% of all funds paid
133 
134     struct Account {
135         uint balance;
136         uint lastRound; // Last round dividens paid
137         uint lastEpoch; // Last round dividens paid
138         uint lastVotedBallotId; // Last ballot user voted
139         uint bitmask;
140             // 2 - got 0.55... for phone verif.
141             // 4 - got 1 for KYC
142             // 1024 - banned
143             //
144             // [2] [4] 8 16 32 64 128 256 512 [1024] ... - free to use
145     }
146     
147     mapping(address=>Account) accounts; 
148     mapping(address => mapping(address => uint)) allowed;
149 
150     //Redenom special events
151     event Redenomination(uint indexed round);
152     event Epoch(uint indexed epoch);
153     event VotingOn(uint indexed _ballotId);
154     event VotingOff(uint indexed winner, uint indexed ballot_id);
155     event Vote(address indexed voter, uint indexed propId, uint voterBalance, uint indexed curentBallotId);
156 
157     function Redenom() public {
158         symbol = "NOM";
159         name = "Redenom";
160         _totalSupply = 0; // total NOM's in the game 
161 
162         total_fund = 10000000 * 10**decimals; // 100 000 00.00000000, 1Mt
163         epoch_fund = 100000 * 10**decimals; // 100 000.00000000, 100 Kt
164         total_fund = total_fund.sub(epoch_fund); // Taking 100 Kt from total to epoch_fund
165 
166     }
167 
168 
169 
170 
171     // New epoch can be started if:
172     // - Current round is 9
173     // - Curen epoch < 10
174     function StartNewEpoch() public onlyAdmin returns(bool succ){
175         require(frozen == false); 
176         require(round == 9);
177         require(epoch < 100);
178 
179         dec = [0,0,0,0,0,0,0,0];  
180         round = 1;
181         epoch++;
182 
183         epoch_fund = 100000 * 10**decimals; // 100 000.00000000, 100 Kt
184         total_fund = total_fund.sub(epoch_fund); // Taking 100 Kt from total to epoch fund
185 
186 
187         emit Epoch(epoch);
188         return true;
189     }
190 
191 
192 
193 
194     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
195 
196     //Is voting active?
197     bool public votingActive = false;
198     uint public curentBallotId = 0;
199     uint public curentWinner;
200 
201     // Voter requirements:
202     modifier onlyVoter {
203         require(votingActive == true);
204         require(bitmask_check(msg.sender, 4) == true); //passed KYC
205         require(bitmask_check(msg.sender, 1024) == false); // banned == false
206         require((accounts[msg.sender].lastVotedBallotId < curentBallotId)); 
207         _;
208     }
209 
210     // This is a type for a single Project.
211     struct Project {
212         uint id;   // Project id
213         uint votesWeight; // total weight
214         bool active; //active status.
215     }
216     Project[] public projects;
217 
218     struct Winner {
219         uint id;
220         uint projId;
221     }
222     Winner[] public winners;
223 
224 
225     function addWinner(uint projId) internal {
226         winners.push(Winner({
227             id: curentBallotId,
228             projId: projId
229         }));
230     }
231     function findWinner(uint _ballotId) public constant returns (uint winner){
232         for (uint p = 0; p < winners.length; p++) {
233             if (winners[p].id == _ballotId) {
234                 return winners[p].projId;
235             }
236         }
237     }
238 
239 
240 
241     // Add prop. with id: _id
242     function addProject(uint _id) public onlyAdmin {
243         require(votingActive == true);
244         projects.push(Project({
245             id: _id,
246             votesWeight: 0,
247             active: true
248         }));
249     }
250 
251     // Turns project ON and OFF
252     function swapProject(uint _id) public onlyAdmin {
253         for (uint p = 0; p < projects.length; p++){
254             if(projects[p].id == _id){
255                 if(projects[p].active == true){
256                     projects[p].active = false;
257                 }else{
258                     projects[p].active = true;
259                 }
260             }
261         }
262     }
263 
264     // Returns proj. weight
265     function projectWeight(uint _id) public constant returns(uint PW){
266         for (uint p = 0; p < projects.length; p++){
267             if(projects[p].id == _id){
268                 return projects[p].votesWeight;
269             }
270         }
271     }
272 
273     // Returns proj. status
274     function projectActive(uint _id) public constant returns(bool PA){
275         for (uint p = 0; p < projects.length; p++){
276             if(projects[p].id == _id){
277                 return projects[p].active;
278             }
279         }
280     }
281 
282     // Vote for proj. using id: _id
283     function vote(uint _id) public onlyVoter returns(bool success){
284 
285         updateAccount(msg.sender);
286         require(frozen == false);
287 
288         for (uint p = 0; p < projects.length; p++){
289             if(projects[p].id == _id && projects[p].active == true){
290                 projects[p].votesWeight += sqrt(accounts[msg.sender].balance);
291                 accounts[msg.sender].lastVotedBallotId = curentBallotId;
292             }
293         }
294         assert(accounts[msg.sender].lastVotedBallotId == curentBallotId);
295         emit Vote(msg.sender, _id, accounts[msg.sender].balance, curentBallotId);
296 
297         return true;
298     }
299 
300     // Shows currently winning proj 
301     function winningProject() public constant returns (uint _winningProject){
302         uint winningVoteWeight = 0;
303         for (uint p = 0; p < projects.length; p++) {
304             if (projects[p].votesWeight > winningVoteWeight && projects[p].active == true) {
305                 winningVoteWeight = projects[p].votesWeight;
306                 _winningProject = projects[p].id;
307             }
308         }
309     }
310 
311     // Activates voting
312     // Clears projects
313     function enableVoting() public onlyAdmin returns(uint ballotId){ 
314         require(votingActive == false);
315         require(frozen == false);
316 
317         curentBallotId++;
318         votingActive = true;
319         delete projects;
320 
321 
322         emit VotingOn(curentBallotId);
323         return curentBallotId;
324     }
325 
326     // Deactivates voting
327     function disableVoting() public onlyAdmin returns(uint winner){
328         require(votingActive == true);
329         require(frozen == false);
330         votingActive = false;
331 
332         curentWinner = winningProject();
333         addWinner(curentWinner);
334         
335         emit VotingOff(curentWinner, curentBallotId);
336         return curentWinner;
337     }
338 
339 
340     // sqrt root func
341     function sqrt(uint x) internal pure returns (uint y) {
342         uint z = (x + 1) / 2;
343         y = x;
344         while (z < y) {
345             y = z;
346             z = (x / z + z) / 2;
347         }
348     }
349 
350     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
351 
352 
353 
354 
355     ///////////////////////////////////////////////////////////////////////////////////////////////////////
356     // NOM token emission functions
357     ///////////////////////////////////////////////////////////////////////////////////////////////////////
358 
359     // Pays 1.00000000 from epoch_fund to KYC-passed user
360     // Uses payout(), bitmask_check(), bitmask_add()
361     // adds 4 to bitmask
362     function pay1(address to) public onlyAdmin returns(bool success){
363         require(bitmask_check(to, 4) == false);
364         uint new_amount = 100000000;
365         payout(to,new_amount);
366         bitmask_add(to, 4);
367         return true;
368     }
369 
370     // Pays .555666XX from epoch_fund to user approved phone;
371     // Uses payout(), bitmask_check(), bitmask_add()
372     // adds 2 to bitmask
373     function pay055(address to) public onlyAdmin returns(bool success){
374         require(bitmask_check(to, 2) == false);
375         uint new_amount = 55566600 + (block.timestamp%100);       
376         payout(to,new_amount);
377         bitmask_add(to, 2);
378         return true;
379     }
380 
381     // Pays .555666XX from epoch_fund to KYC user in new epoch;
382     // Uses payout(), bitmask_check(), bitmask_add()
383     // adds 2 to bitmask
384     function pay055loyal(address to) public onlyAdmin returns(bool success){
385         require(epoch > 1);
386         require(bitmask_check(to, 4) == true);
387         uint new_amount = 55566600 + (block.timestamp%100);       
388         payout(to,new_amount);
389         return true;
390     }
391 
392     // Pays random number from epoch_fund
393     // Uses payout()
394     function payCustom(address to, uint amount) public onlyOwner returns(bool success){
395         payout(to,amount);
396         return true;
397     }
398 
399     // Pays [amount] of money to [to] account from epoch_fund
400     // Counts amount +30% +10%
401     // Updating _totalSupply
402     // Pays to balance and 2 funds
403     // Refreshes dec[]
404     // Emits event
405     function payout(address to, uint amount) private returns (bool success){
406         require(to != address(0));
407         require(amount>=current_mul());
408         require(bitmask_check(to, 1024) == false); // banned == false
409         require(frozen == false); 
410         
411         //Update account balance
412         updateAccount(to);
413         //fix amount
414         uint fixedAmount = fix_amount(amount);
415 
416         renewDec( accounts[to].balance, accounts[to].balance.add(fixedAmount) );
417 
418         uint team_part = (fixedAmount/100)*16;
419         uint dao_part = (fixedAmount/10)*6;
420         uint total = fixedAmount.add(team_part).add(dao_part);
421 
422         epoch_fund = epoch_fund.sub(total);
423         team_fund = team_fund.add(team_part);
424         redenom_dao_fund = redenom_dao_fund.add(dao_part);
425         accounts[to].balance = accounts[to].balance.add(fixedAmount);
426         _totalSupply = _totalSupply.add(total);
427 
428         emit Transfer(address(0), to, fixedAmount);
429         return true;
430     }
431     ///////////////////////////////////////////////////////////////////////////////////////////////////////
432 
433 
434 
435 
436     ///////////////////////////////////////////////////////////////////////////////////////////////////////
437 
438     // Withdraw amount from team_fund to given address
439     function withdraw_team_fund(address to, uint amount) public onlyOwner returns(bool success){
440         require(amount <= team_fund);
441         accounts[to].balance = accounts[to].balance.add(amount);
442         team_fund = team_fund.sub(amount);
443         return true;
444     }
445     // Withdraw amount from redenom_dao_fund to given address
446     function withdraw_dao_fund(address to, uint amount) public onlyOwner returns(bool success){
447         require(amount <= redenom_dao_fund);
448         accounts[to].balance = accounts[to].balance.add(amount);
449         redenom_dao_fund = redenom_dao_fund.sub(amount);
450         return true;
451     }
452 
453     function freeze_contract() public onlyOwner returns(bool success){
454         require(frozen == false);
455         frozen = true;
456         return true;
457     }
458     function unfreeze_contract() public onlyOwner returns(bool success){
459         require(frozen == true);
460         frozen = false;
461         return true;
462     }
463     ///////////////////////////////////////////////////////////////////////////////////////////////////////
464 
465 
466     // Run this on every change of user balance
467     // Refreshes dec[] array
468     // Takes initial and new ammount
469     // while transaction must be called for each acc.
470     function renewDec(uint initSum, uint newSum) internal returns(bool success){
471 
472         if(round < 9){
473             uint tempInitSum = initSum; 
474             uint tempNewSum = newSum; 
475             uint cnt = 1;
476 
477             while( (tempNewSum > 0 || tempInitSum > 0) && cnt <= decimals ){
478 
479                 uint lastInitSum = tempInitSum%10; // 0.0000000 (0)
480                 tempInitSum = tempInitSum/10; // (0.0000000) 0
481 
482                 uint lastNewSum = tempNewSum%10; // 1.5556664 (5)
483                 tempNewSum = tempNewSum/10; // (1.5556664) 5
484 
485                 if(cnt >= round){
486                     if(lastNewSum >= lastInitSum){
487                         // If new is bigger
488                         dec[decimals-cnt] = dec[decimals-cnt].add(lastNewSum - lastInitSum);
489                     }else{
490                         // If new is smaller
491                         dec[decimals-cnt] = dec[decimals-cnt].sub(lastInitSum - lastNewSum);
492                     }
493                 }
494 
495                 cnt = cnt+1;
496             }
497         }//if(round < 9){
498 
499         return true;
500     }
501 
502 
503 
504     ////////////////////////////////////////// BITMASK /////////////////////////////////////////////////////
505     // Adding bit to bitmask
506     // checks if already set
507     function bitmask_add(address user, uint _bit) internal returns(bool success){ //todo privat?
508         require(bitmask_check(user, _bit) == false);
509         accounts[user].bitmask = accounts[user].bitmask.add(_bit);
510         return true;
511     }
512     // Removes bit from bitmask
513     // checks if already set
514     function bitmask_rm(address user, uint _bit) internal returns(bool success){
515         require(bitmask_check(user, _bit) == true);
516         accounts[user].bitmask = accounts[user].bitmask.sub(_bit);
517         return true;
518     }
519     // Checks whether some bit is present in BM
520     function bitmask_check(address user, uint _bit) public view returns (bool status){
521         bool flag;
522         accounts[user].bitmask & _bit == 0 ? flag = false : flag = true;
523         return flag;
524     }
525     ///////////////////////////////////////////////////////////////////////////////////////////////////////
526 
527     function ban_user(address user) public onlyAdmin returns(bool success){
528         bitmask_add(user, 1024);
529         return true;
530     }
531     function unban_user(address user) public onlyAdmin returns(bool success){
532         bitmask_rm(user, 1024);
533         return true;
534     }
535     function is_banned(address user) public view onlyAdmin returns (bool result){
536         return bitmask_check(user, 1024);
537     }
538     ///////////////////////////////////////////////////////////////////////////////////////////////////////
539 
540 
541 
542     //Redenominates 
543     function redenominate() public onlyAdmin returns(uint current_round){
544         require(frozen == false); 
545         require(round<9); // Round must be < 9
546 
547         // Deleting funds rest from TS
548         _totalSupply = _totalSupply.sub( team_fund%mul[round] ).sub( redenom_dao_fund%mul[round] ).sub( dec[8-round]*mul[round-1] );
549 
550         // Redenominating 3 vars: _totalSupply team_fund redenom_dao_fund
551         _totalSupply = ( _totalSupply / mul[round] ) * mul[round];
552         team_fund = ( team_fund / mul[round] ) * mul[round]; // Redenominates team_fund
553         redenom_dao_fund = ( redenom_dao_fund / mul[round] ) * mul[round]; // Redenominates redenom_dao_fund
554 
555         if(round>1){
556             // decimals burned in last round and not distributed
557             uint superold = dec[(8-round)+1]; 
558 
559             // Returning them to epoch_fund
560             epoch_fund = epoch_fund.add(superold * mul[round-2]);
561             dec[(8-round)+1] = 0;
562         }
563 
564         
565         if(round<8){ // if round between 1 and 7 
566 
567             uint unclimed = dec[8-round]; // total sum of burned decimal
568             //[23,32,43,34,34,54,34, ->46<- ]
569             uint total_current = dec[8-1-round]; // total sum of last active decimal
570             //[23,32,43,34,34,54, ->34<-, 46]
571 
572             // security check
573             if(total_current==0){
574                 current_toadd = [0,0,0,0,0,0,0,0,0]; 
575                 round++;
576                 emit Redenomination(round);
577                 return round;
578             }
579 
580             // Counting amounts to add on every digit
581             uint[9] memory numbers  =[uint(1),2,3,4,5,6,7,8,9]; // 
582             uint[9] memory ke9  =[uint(0),0,0,0,0,0,0,0,0]; // 
583             uint[9] memory k2e9  =[uint(0),0,0,0,0,0,0,0,0]; // 
584 
585             uint k05summ = 0;
586 
587                 for (uint k = 0; k < ke9.length; k++) {
588                      
589                     ke9[k] = numbers[k]*1e9/total_current;
590                     if(k<5) k05summ += ke9[k];
591                 }             
592                 for (uint k2 = 5; k2 < k2e9.length; k2++) {
593                     k2e9[k2] = uint(ke9[k2])+uint(k05summ)*uint(weight[k2])/uint(100);
594                 }
595                 for (uint n = 5; n < current_toadd.length; n++) {
596                     current_toadd[n] = k2e9[n]*unclimed/10/1e9;
597                 }
598                 // current_toadd now contains all digits
599                 
600         }else{
601             if(round==8){
602                 // Returns last burned decimals to epoch_fund
603                 epoch_fund = epoch_fund.add(dec[0] * 10000000); //1e7
604                 dec[0] = 0;
605             }
606             
607         }
608 
609         round++;
610         emit Redenomination(round);
611         return round;
612     }
613 
614 
615     function actual_balance(address user) public constant returns(uint _actual_balance){
616         if(epoch > 1 && accounts[user].lastEpoch < epoch){
617             return (accounts[user].balance/100000000)*100000000;
618         }
619         return (accounts[user].balance/current_mul())*current_mul();
620     }
621    
622     // Refresh user acc
623     // Pays dividends if any
624     function updateAccount(address account) public returns(uint new_balance){
625         require(frozen == false); 
626         require(round<=9);
627         require(bitmask_check(account, 1024) == false); // banned == false
628 
629         if(epoch > 1 && accounts[account].lastEpoch < epoch){
630             uint entire = accounts[account].balance/100000000; //1.
631             //uint diff_ = accounts[account].balance - entire*100000000;
632             if((accounts[account].balance - entire*100000000) >0){
633                 emit Transfer(account, address(0), (accounts[account].balance - entire*100000000));
634             }
635             accounts[account].balance = entire*100000000;
636             accounts[account].lastEpoch = epoch;
637             accounts[account].lastRound = round;
638             return accounts[account].balance;
639         }
640 
641         if(round > accounts[account].lastRound){
642 
643             if(round >1 && round <=8){
644 
645 
646                 // Splits user bal by current multiplier
647                 uint tempDividedBalance = accounts[account].balance/current_mul();
648                 // [1.5556663] 4  (r2)
649                 uint newFixedBalance = tempDividedBalance*current_mul();
650                 // [1.55566630]  (r2)
651                 uint lastActiveDigit = tempDividedBalance%10;
652                  // 1.555666 [3] 4  (r2)
653                 uint diff = accounts[account].balance - newFixedBalance;
654                 // 1.5556663 [4] (r2)
655 
656                 if(diff > 0){
657                     accounts[account].balance = newFixedBalance;
658                     emit Transfer(account, address(0), diff);
659                 }
660 
661                 uint toBalance = 0;
662                 if(lastActiveDigit>0 && current_toadd[lastActiveDigit-1]>0){
663                     toBalance = current_toadd[lastActiveDigit-1] * current_mul();
664                 }
665 
666 
667                 if(toBalance > 0 && toBalance < dec[8-round+1]){ // Not enough
668 
669                     renewDec( accounts[account].balance, accounts[account].balance.add(toBalance) );
670                     emit Transfer(address(0), account, toBalance);
671                     // Refreshing dec arr
672                     accounts[account].balance = accounts[account].balance.add(toBalance);
673                     // Adding to ball
674                     dec[8-round+1] = dec[8-round+1].sub(toBalance);
675                     // Taking from burned decimal
676                     _totalSupply = _totalSupply.add(toBalance);
677                     // Add dividend to _totalSupply
678                 }
679 
680                 accounts[account].lastRound = round;
681                 // Writting last round in wich user got dividends
682                 if(accounts[account].lastEpoch != epoch){
683                     accounts[account].lastEpoch = epoch;
684                 }
685 
686 
687                 return accounts[account].balance;
688                 // returns new balance
689             }else{
690                 if( round == 9){ //100000000 = 9 mul (mul8)
691 
692                     uint newBalance = fix_amount(accounts[account].balance);
693                     uint _diff = accounts[account].balance.sub(newBalance);
694 
695                     if(_diff > 0){
696                         renewDec( accounts[account].balance, newBalance );
697                         accounts[account].balance = newBalance;
698                         emit Transfer(account, address(0), _diff);
699                     }
700 
701                     accounts[account].lastRound = round;
702                     // Writting last round in wich user got dividends
703                     if(accounts[account].lastEpoch != epoch){
704                         accounts[account].lastEpoch = epoch;
705                     }
706 
707 
708                     return accounts[account].balance;
709                     // returns new balance
710                 }
711             }
712         }
713     }
714 
715     // Returns current multipl. based on round
716     // Returns current multiplier based on round
717     function current_mul() internal view returns(uint _current_mul){
718         return mul[round-1];
719     }
720     // Removes burned values 123 -> 120  
721     // Returns fixed
722     function fix_amount(uint amount) public view returns(uint fixed_amount){
723         return ( amount / current_mul() ) * current_mul();
724     }
725     // Returns rest
726     function get_rest(uint amount) internal view returns(uint fixed_amount){
727         return amount % current_mul();
728     }
729 
730 
731 
732     // ------------------------------------------------------------------------
733     // ERC20 totalSupply: 
734     //-------------------------------------------------------------------------
735     function totalSupply() public view returns (uint) {
736         return _totalSupply;
737     }
738     // ------------------------------------------------------------------------
739     // ERC20 balanceOf: Get the token balance for account `tokenOwner`
740     // ------------------------------------------------------------------------
741     function balanceOf(address tokenOwner) public constant returns (uint balance) {
742         return accounts[tokenOwner].balance;
743     }
744     // ------------------------------------------------------------------------
745     // ERC20 allowance:
746     // Returns the amount of tokens approved by the owner that can be
747     // transferred to the spender's account
748     // ------------------------------------------------------------------------
749     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
750         return allowed[tokenOwner][spender];
751     }
752     // ------------------------------------------------------------------------
753     // ERC20 transfer:
754     // Transfer the balance from token owner's account to `to` account
755     // - Owner's account must have sufficient balance to transfer
756     // - 0 value transfers are allowed
757     // ------------------------------------------------------------------------
758     function transfer(address to, uint tokens) public returns (bool success) {
759         require(frozen == false); 
760         require(to != address(0));
761         require(bitmask_check(to, 1024) == false); // banned == false
762 
763         //Fixing amount, deleting burned decimals
764         tokens = fix_amount(tokens);
765         // Checking if greater then 0
766         require(tokens>0);
767 
768         //Refreshing accs, payng dividends
769         updateAccount(to);
770         updateAccount(msg.sender);
771 
772         uint fromOldBal = accounts[msg.sender].balance;
773         uint toOldBal = accounts[to].balance;
774 
775         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(tokens);
776         accounts[to].balance = accounts[to].balance.add(tokens);
777 
778         require(renewDec(fromOldBal, accounts[msg.sender].balance));
779         require(renewDec(toOldBal, accounts[to].balance));
780 
781         emit Transfer(msg.sender, to, tokens);
782         return true;
783     }
784 
785 
786     // ------------------------------------------------------------------------
787     // ERC20 approve:
788     // Token owner can approve for `spender` to transferFrom(...) `tokens`
789     // from the token owner's account
790     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
791     // recommends that there are no checks for the approval double-spend attack
792     // as this should be implemented in user interfaces 
793     // ------------------------------------------------------------------------
794     function approve(address spender, uint tokens) public returns (bool success) {
795         require(frozen == false); 
796         require(bitmask_check(msg.sender, 1024) == false); // banned == false
797         allowed[msg.sender][spender] = tokens;
798         emit Approval(msg.sender, spender, tokens);
799         return true;
800     }
801     // ------------------------------------------------------------------------
802     // ERC20 transferFrom:
803     // Transfer `tokens` from the `from` account to the `to` account
804     // The calling account must already have sufficient tokens approve(...)-d
805     // for spending from the `from` account and
806     // - From account must have sufficient balance to transfer
807     // - Spender must have sufficient allowance to transfer
808     // - 0 value transfers are allowed
809     // ------------------------------------------------------------------------
810     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
811         require(frozen == false); 
812         require(bitmask_check(to, 1024) == false); // banned == false
813         updateAccount(from);
814         updateAccount(to);
815 
816         uint fromOldBal = accounts[from].balance;
817         uint toOldBal = accounts[to].balance;
818 
819         accounts[from].balance = accounts[from].balance.sub(tokens);
820         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
821         accounts[to].balance = accounts[to].balance.add(tokens);
822 
823         require(renewDec(fromOldBal, accounts[from].balance));
824         require(renewDec(toOldBal, accounts[to].balance));
825 
826         emit Transfer(from, to, tokens);
827         return true; 
828     }
829 
830     // ------------------------------------------------------------------------
831     // Token owner can approve for `spender` to transferFrom(...) `tokens`
832     // from the token owner's account. The `spender` contract function
833     // `receiveApproval(...)` is then executed
834     // ------------------------------------------------------------------------
835     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
836         require(frozen == false); 
837         require(bitmask_check(msg.sender, 1024) == false); // banned == false
838         allowed[msg.sender][spender] = tokens;
839         emit Approval(msg.sender, spender, tokens);
840         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
841         return true;
842     }
843     // ------------------------------------------------------------------------
844     // Don't accept ETH https://github.com/ConsenSys/Ethereum-Development-Best-Practices/wiki/Fallback-functions-and-the-fundamental-limitations-of-using-send()-in-Ethereum-&-Solidity
845     // ------------------------------------------------------------------------
846     function () public payable {
847         revert();
848     } // OR function() payable { } to accept ETH 
849 
850     // ------------------------------------------------------------------------
851     // Owner can transfer out any accidentally sent ERC20 tokens
852     // ------------------------------------------------------------------------
853     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
854         require(frozen == false); 
855         return ERC20Interface(tokenAddress).transfer(owner, tokens);
856     }
857 
858 
859 
860 
861 } // © Musqogees Tech 2018, Redenom ™