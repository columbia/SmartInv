1 pragma solidity ^0.4.21;
2 // The GNU General Public License v3
3 // © Musqogees Tech 2018, Redenom ™
4 
5     
6 // -------------------- SAFE MATH ----------------------------------------------
7 library SafeMath {
8     function add(uint a, uint b) internal pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 // ----------------------------------------------------------------------------
27 // Basic ERC20 functions
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public view returns (uint);
31     function balanceOf(address tokenOwner) public view returns (uint balance);
32     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract manages Owner and Admin rights.
43 // Owner is Admin by default and can set other Admin
44 // ----------------------------------------------------------------------------
45 contract Owned {
46     address public owner;
47     address public newOwner;
48     address internal admin;
49 
50     // modifier for Owner functions
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55     // modifier for Admin functions
56     modifier onlyAdmin {
57         require(msg.sender == admin || msg.sender == owner);
58         _;
59     }
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62     event AdminChanged(address indexed _from, address indexed _to);
63 
64     // Constructor
65     function Owned() public {
66         owner = msg.sender;
67         admin = msg.sender;
68     }
69 
70     function setAdmin(address newAdmin) public onlyOwner{
71         emit AdminChanged(admin, newAdmin);
72         admin = newAdmin;
73     }
74 
75     function showAdmin() public view onlyAdmin returns(address _admin){
76         _admin = admin;
77         return _admin;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83 
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88         newOwner = address(0);
89     }
90 }
91 
92 // ----------------------------------------------------------------------------
93 // Contract function to receive approval and execute function in one call
94 // Borrowed from MiniMeToken
95 // ----------------------------------------------------------------------------
96 contract ApproveAndCallFallBack {
97     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
98 }
99 
100 
101 contract Redenom is ERC20Interface, Owned{
102     using SafeMath for uint;
103     
104     //ERC20 params
105     string      public name; // ERC20 
106     string      public symbol; // ERC20 
107     uint        private _totalSupply; // ERC20
108     uint        public decimals = 8; // ERC20 
109 
110 
111     //Redenomination
112     uint public round = 1; 
113     uint public epoch = 1; 
114 
115     bool public frozen = false;
116 
117     //dec - sum of every exponent
118     uint[8] private dec = [0,0,0,0,0,0,0,0];
119     //mul - internal used array for splitting numbers according to round     
120     uint[9] private mul = [1,10,100,1000,10000,100000,1000000,10000000,100000000];
121     //weight - internal used array (weights of every digit)    
122     uint[9] private weight = [uint(0),0,0,0,0,5,10,30,55];
123     //current_toadd - After redenominate() it holds an amount to add on each digit.
124     uint[9] private current_toadd = [uint(0),0,0,0,0,0,0,0,0];
125    
126 
127     //Funds
128     uint public total_fund; // All funds for 100 epochs 100 000 000 NOM
129     uint public epoch_fund; // All funds for current epoch 100 000 NOM
130     uint public team_fund; // Team Fund 10% of all funds paid
131     uint public redenom_dao_fund; // DAO Fund 30% of all funds paid
132 
133     struct Account {
134         uint balance;
135         uint lastRound; // Last round dividens paid
136         uint lastEpoch; // Last round dividens paid
137         uint lastVotedBallotId; // Last ballot user voted
138         uint bitmask;
139             // 2 - got 0.55... for phone verif.
140             // 4 - got 1 for KYC
141             // 1024 - banned
142             //
143             // [2] [4] 8 16 32 64 128 256 512 [1024] ... - free to use
144     }
145     
146     mapping(address=>Account) accounts; 
147     mapping(address => mapping(address => uint)) allowed;
148 
149     //Redenom special events
150     event Redenomination(uint indexed round);
151     event Epoch(uint indexed epoch);
152     event VotingOn(uint indexed _ballotId);
153     event VotingOff(uint indexed winner, uint indexed ballot_id);
154     event Vote(address indexed voter, uint indexed propId, uint voterBalance, uint indexed curentBallotId);
155 
156     function Redenom() public {
157         symbol = "NOMT";
158         name = "Redenom_test";
159         _totalSupply = 0; // total NOM's in the game 
160 
161         total_fund = 10000000 * 10**decimals; // 100 000 00.00000000, 1Mt
162         epoch_fund = 100000 * 10**decimals; // 100 000.00000000, 100 Kt
163         total_fund = total_fund.sub(epoch_fund); // Taking 100 Kt from total to epoch_fund
164 
165     }
166 
167 
168 
169 
170     // New epoch can be started if:
171     // - Current round is 9
172     // - Curen epoch < 10
173     function StartNewEpoch() public onlyAdmin returns(bool succ){
174         require(frozen == false); 
175         require(round == 9);
176         require(epoch < 100);
177 
178         dec = [0,0,0,0,0,0,0,0];  
179         round = 1;
180         epoch++;
181 
182         epoch_fund = 100000 * 10**decimals; // 100 000.00000000, 100 Kt
183         total_fund = total_fund.sub(epoch_fund); // Taking 100 Kt from total to epoch fund
184 
185 
186         emit Epoch(epoch);
187         return true;
188     }
189 
190 
191 
192 
193     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
194 
195     //Is voting active?
196     bool public votingActive = false;
197     uint public curentBallotId = 0;
198     uint public curentWinner;
199 
200     // Voter requirements:
201     modifier onlyVoter {
202         require(votingActive == true);
203         require(bitmask_check(msg.sender, 4) == true); //passed KYC
204         require(bitmask_check(msg.sender, 1024) == false); // banned == false
205         require((accounts[msg.sender].lastVotedBallotId < curentBallotId)); 
206         _;
207     }
208 
209     // This is a type for a single Project.
210     struct Project {
211         uint id;   // Project id
212         uint votesWeight; // total weight
213         bool active; //active status.
214     }
215     Project[] public projects;
216 
217     struct Winner {
218         uint id;
219         uint projId;
220     }
221     Winner[] public winners;
222 
223 
224     function addWinner(uint projId) internal {
225         winners.push(Winner({
226             id: curentBallotId,
227             projId: projId
228         }));
229     }
230     function findWinner(uint _ballotId) public constant returns (uint winner){
231         for (uint p = 0; p < winners.length; p++) {
232             if (winners[p].id == _ballotId) {
233                 return winners[p].projId;
234             }
235         }
236     }
237 
238 
239 
240     // Add prop. with id: _id
241     function addProject(uint _id) public onlyAdmin {
242         require(votingActive == true);
243         projects.push(Project({
244             id: _id,
245             votesWeight: 0,
246             active: true
247         }));
248     }
249 
250     // Turns project ON and OFF
251     function swapProject(uint _id) public onlyAdmin {
252         for (uint p = 0; p < projects.length; p++){
253             if(projects[p].id == _id){
254                 if(projects[p].active == true){
255                     projects[p].active = false;
256                 }else{
257                     projects[p].active = true;
258                 }
259             }
260         }
261     }
262 
263     // Returns proj. weight
264     function projectWeight(uint _id) public constant returns(uint PW){
265         for (uint p = 0; p < projects.length; p++){
266             if(projects[p].id == _id){
267                 return projects[p].votesWeight;
268             }
269         }
270     }
271 
272     // Returns proj. status
273     function projectActive(uint _id) public constant returns(bool PA){
274         for (uint p = 0; p < projects.length; p++){
275             if(projects[p].id == _id){
276                 return projects[p].active;
277             }
278         }
279     }
280 
281     // Vote for proj. using id: _id
282     function vote(uint _id) public onlyVoter returns(bool success){
283 
284         updateAccount(msg.sender);
285         require(frozen == false);
286 
287         for (uint p = 0; p < projects.length; p++){
288             if(projects[p].id == _id && projects[p].active == true){
289                 projects[p].votesWeight += sqrt(accounts[msg.sender].balance);
290                 accounts[msg.sender].lastVotedBallotId = curentBallotId;
291             }
292         }
293         emit Vote(msg.sender, _id, accounts[msg.sender].balance, curentBallotId);
294 
295         return true;
296     }
297 
298     // Shows currently winning proj 
299     function winningProject() public constant returns (uint _winningProject){
300         uint winningVoteWeight = 0;
301         for (uint p = 0; p < projects.length; p++) {
302             if (projects[p].votesWeight > winningVoteWeight && projects[p].active == true) {
303                 winningVoteWeight = projects[p].votesWeight;
304                 _winningProject = projects[p].id;
305             }
306         }
307     }
308 
309     // Activates voting
310     // Clears projects
311     function enableVoting() public onlyAdmin returns(uint ballotId){ 
312         require(votingActive == false);
313         require(frozen == false);
314 
315         curentBallotId++;
316         votingActive = true;
317 
318         delete projects;
319 
320         emit VotingOn(curentBallotId);
321         return curentBallotId;
322     }
323 
324     // Deactivates voting
325     function disableVoting() public onlyAdmin returns(uint winner){
326         require(votingActive == true);
327         require(frozen == false);
328         votingActive = false;
329 
330         curentWinner = winningProject();
331         addWinner(curentWinner);
332         
333         emit VotingOff(curentWinner, curentBallotId);
334         return curentWinner;
335     }
336 
337 
338     // sqrt root func
339     function sqrt(uint x) internal pure returns (uint y) {
340         uint z = (x + 1) / 2;
341         y = x;
342         while (z < y) {
343             y = z;
344             z = (x / z + z) / 2;
345         }
346     }
347 
348     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
349 
350 
351 
352 
353     ///////////////////////////////////////////////////////////////////////////////////////////////////////
354     // NOM token emission functions
355     ///////////////////////////////////////////////////////////////////////////////////////////////////////
356 
357     // Pays 1.00000000 from epoch_fund to KYC-passed user
358     // Uses payout(), bitmask_check(), bitmask_add()
359     // adds 4 to bitmask
360     function pay1(address to) public onlyAdmin returns(bool success){
361         require(bitmask_check(to, 4) == false);
362         uint new_amount = 100000000;
363         payout(to,new_amount);
364         bitmask_add(to, 4);
365         return true;
366     }
367 
368     // Pays .555666XX from epoch_fund to user approved phone;
369     // Uses payout(), bitmask_check(), bitmask_add()
370     // adds 2 to bitmask
371     function pay055(address to) public onlyAdmin returns(bool success){
372         require(bitmask_check(to, 2) == false);
373         uint new_amount = 55566600 + (block.timestamp%100);       
374         payout(to,new_amount);
375         bitmask_add(to, 2);
376         return true;
377     }
378 
379     // Pays .555666XX from epoch_fund to KYC user in new epoch;
380     // Uses payout(), bitmask_check(), bitmask_add()
381     // adds 2 to bitmask
382     function pay055loyal(address to) public onlyAdmin returns(bool success){
383         require(epoch > 1);
384         require(bitmask_check(to, 4) == true);
385         uint new_amount = 55566600 + (block.timestamp%100);       
386         payout(to,new_amount);
387         return true;
388     }
389 
390     // Pays random number from epoch_fund
391     // Uses payout()
392     function payCustom(address to, uint amount) public onlyOwner returns(bool success){
393         payout(to,amount);
394         return true;
395     }
396 
397     // Pays [amount] of money to [to] account from epoch_fund
398     // Counts amount +30% +10%
399     // Updating _totalSupply
400     // Pays to balance and 2 funds
401     // Refreshes dec[]
402     // Emits event
403     function payout(address to, uint amount) private returns (bool success){
404         require(to != address(0));
405         require(amount>=current_mul());
406         require(bitmask_check(to, 1024) == false); // banned == false
407         require(frozen == false); 
408         
409         //Update account balance
410         updateAccount(to);
411         //fix amount
412         uint fixedAmount = fix_amount(amount);
413 
414         renewDec( accounts[to].balance, accounts[to].balance.add(fixedAmount) );
415 
416         uint team_part = (fixedAmount/100)*16;
417         uint dao_part = (fixedAmount/10)*6;
418         uint total = fixedAmount.add(team_part).add(dao_part);
419 
420         epoch_fund = epoch_fund.sub(total);
421         team_fund = team_fund.add(team_part);
422         redenom_dao_fund = redenom_dao_fund.add(dao_part);
423         accounts[to].balance = accounts[to].balance.add(fixedAmount);
424         _totalSupply = _totalSupply.add(total);
425 
426         emit Transfer(address(0), to, fixedAmount);
427         return true;
428     }
429     ///////////////////////////////////////////////////////////////////////////////////////////////////////
430 
431 
432 
433 
434     ///////////////////////////////////////////////////////////////////////////////////////////////////////
435 
436     // Withdraw amount from team_fund to given address
437     function withdraw_team_fund(address to, uint amount) public onlyOwner returns(bool success){
438         require(amount <= team_fund);
439         accounts[to].balance = accounts[to].balance.add(amount);
440         team_fund = team_fund.sub(amount);
441         return true;
442     }
443     // Withdraw amount from redenom_dao_fund to given address
444     function withdraw_dao_fund(address to, uint amount) public onlyOwner returns(bool success){
445         require(amount <= redenom_dao_fund);
446         accounts[to].balance = accounts[to].balance.add(amount);
447         redenom_dao_fund = redenom_dao_fund.sub(amount);
448         return true;
449     }
450 
451     function freeze_contract() public onlyOwner returns(bool success){
452         require(frozen == false);
453         frozen = true;
454         return true;
455     }
456     function unfreeze_contract() public onlyOwner returns(bool success){
457         require(frozen == true);
458         frozen = false;
459         return true;
460     }
461     ///////////////////////////////////////////////////////////////////////////////////////////////////////
462 
463 
464     // Run this on every change of user balance
465     // Refreshes dec[] array
466     // Takes initial and new ammount
467     // while transaction must be called for each acc.
468     function renewDec(uint initSum, uint newSum) internal returns(bool success){
469 
470         if(round < 9){
471             uint tempInitSum = initSum; 
472             uint tempNewSum = newSum; 
473             uint cnt = 1;
474 
475             while( (tempNewSum > 0 || tempInitSum > 0) && cnt <= decimals ){
476 
477                 uint lastInitSum = tempInitSum%10; // 0.0000000 (0)
478                 tempInitSum = tempInitSum/10; // (0.0000000) 0
479 
480                 uint lastNewSum = tempNewSum%10; // 1.5556664 (5)
481                 tempNewSum = tempNewSum/10; // (1.5556664) 5
482 
483                 if(cnt >= round){
484                     if(lastNewSum >= lastInitSum){
485                         // If new is bigger
486                         dec[decimals-cnt] = dec[decimals-cnt].add(lastNewSum - lastInitSum);
487                     }else{
488                         // If new is smaller
489                         dec[decimals-cnt] = dec[decimals-cnt].sub(lastInitSum - lastNewSum);
490                     }
491                 }
492 
493                 cnt = cnt+1;
494             }
495         }//if(round < 9){
496 
497         return true;
498     }
499 
500 
501 
502     ////////////////////////////////////////// BITMASK /////////////////////////////////////////////////////
503     // Adding bit to bitmask
504     // checks if already set
505     function bitmask_add(address user, uint _bit) internal returns(bool success){ //todo privat?
506         require(bitmask_check(user, _bit) == false);
507         accounts[user].bitmask = accounts[user].bitmask.add(_bit);
508         return true;
509     }
510     // Removes bit from bitmask
511     // checks if already set
512     function bitmask_rm(address user, uint _bit) internal returns(bool success){
513         require(bitmask_check(user, _bit) == true);
514         accounts[user].bitmask = accounts[user].bitmask.sub(_bit);
515         return true;
516     }
517     // Checks whether some bit is present in BM
518     function bitmask_check(address user, uint _bit) public view returns (bool status){
519         bool flag;
520         accounts[user].bitmask & _bit == 0 ? flag = false : flag = true;
521         return flag;
522     }
523     ///////////////////////////////////////////////////////////////////////////////////////////////////////
524 
525     function ban_user(address user) public onlyAdmin returns(bool success){
526         bitmask_add(user, 1024);
527         return true;
528     }
529     function unban_user(address user) public onlyAdmin returns(bool success){
530         bitmask_rm(user, 1024);
531         return true;
532     }
533     function is_banned(address user) public view onlyAdmin returns (bool result){
534         return bitmask_check(user, 1024);
535     }
536     ///////////////////////////////////////////////////////////////////////////////////////////////////////
537 
538 
539 
540     //Redenominates 
541     function redenominate() public onlyAdmin returns(uint current_round){
542         require(frozen == false); 
543         require(round<9); // Round must be < 9
544 
545         // Deleting funds rest from TS
546         _totalSupply = _totalSupply.sub( team_fund%mul[round] ).sub( redenom_dao_fund%mul[round] ).sub( dec[8-round]*mul[round-1] );
547 
548         // Redenominating 3 vars: _totalSupply team_fund redenom_dao_fund
549         _totalSupply = ( _totalSupply / mul[round] ) * mul[round];
550         team_fund = ( team_fund / mul[round] ) * mul[round]; // Redenominates team_fund
551         redenom_dao_fund = ( redenom_dao_fund / mul[round] ) * mul[round]; // Redenominates redenom_dao_fund
552 
553         if(round>1){
554             // decimals burned in last round and not distributed
555             uint superold = dec[(8-round)+1]; 
556 
557             // Returning them to epoch_fund
558             epoch_fund = epoch_fund.add(superold * mul[round-2]);
559             dec[(8-round)+1] = 0;
560         }
561 
562         
563         if(round<8){ // if round between 1 and 7 
564 
565             uint unclimed = dec[8-round]; // total sum of burned decimal
566             //[23,32,43,34,34,54,34, ->46<- ]
567             uint total_current = dec[8-1-round]; // total sum of last active decimal
568             //[23,32,43,34,34,54, ->34<-, 46]
569 
570             // security check
571             if(total_current==0){
572                 current_toadd = [0,0,0,0,0,0,0,0,0]; 
573                 round++;
574                 emit Redenomination(round);
575                 return round;
576             }
577 
578             // Counting amounts to add on every digit
579             uint[9] memory numbers  =[uint(1),2,3,4,5,6,7,8,9]; // 
580             uint[9] memory ke9  =[uint(0),0,0,0,0,0,0,0,0]; // 
581             uint[9] memory k2e9  =[uint(0),0,0,0,0,0,0,0,0]; // 
582 
583             uint k05summ = 0;
584 
585                 for (uint k = 0; k < ke9.length; k++) {
586                      
587                     ke9[k] = numbers[k]*1e9/total_current;
588                     if(k<5) k05summ += ke9[k];
589                 }             
590                 for (uint k2 = 5; k2 < k2e9.length; k2++) {
591                     k2e9[k2] = uint(ke9[k2])+uint(k05summ)*uint(weight[k2])/uint(100);
592                 }
593                 for (uint n = 5; n < current_toadd.length; n++) {
594                     current_toadd[n] = k2e9[n]*unclimed/10/1e9;
595                 }
596                 // current_toadd now contains all digits
597                 
598         }else{
599             if(round==8){
600                 // Returns last burned decimals to epoch_fund
601                 epoch_fund = epoch_fund.add(dec[0] * 10000000); //1e7
602                 dec[0] = 0;
603             }
604             
605         }
606 
607         round++;
608         emit Redenomination(round);
609         return round;
610     }
611 
612 
613     function actual_balance(address user) public constant returns(uint _actual_balance){
614         if(epoch > 1 && accounts[user].lastEpoch < epoch){
615             return (accounts[user].balance/100000000)*100000000;
616         }
617         return (accounts[user].balance/current_mul())*current_mul();
618     }
619    
620     // Refresh user acc
621     // Pays dividends if any
622     function updateAccount(address account) public returns(uint new_balance){
623         require(frozen == false); 
624         require(round<=9);
625         require(bitmask_check(account, 1024) == false); // banned == false
626 
627         if(epoch > 1 && accounts[account].lastEpoch < epoch){
628             uint entire = accounts[account].balance/100000000; //1.
629             //uint diff_ = accounts[account].balance - entire*100000000;
630             if((accounts[account].balance - entire*100000000) >0){
631                 emit Transfer(account, address(0), (accounts[account].balance - entire*100000000));
632             }
633             accounts[account].balance = entire*100000000;
634             accounts[account].lastEpoch = epoch;
635             accounts[account].lastRound = round;
636             return accounts[account].balance;
637         }
638 
639         if(round > accounts[account].lastRound){
640 
641             if(round >1 && round <=8){
642 
643 
644                 // Splits user bal by current multiplier
645                 uint tempDividedBalance = accounts[account].balance/current_mul();
646                 // [1.5556663] 4  (r2)
647                 uint newFixedBalance = tempDividedBalance*current_mul();
648                 // [1.55566630]  (r2)
649                 uint lastActiveDigit = tempDividedBalance%10;
650                  // 1.555666 [3] 4  (r2)
651                 uint diff = accounts[account].balance - newFixedBalance;
652                 // 1.5556663 [4] (r2)
653 
654                 if(diff > 0){
655                     accounts[account].balance = newFixedBalance;
656                     emit Transfer(account, address(0), diff);
657                 }
658 
659                 uint toBalance = 0;
660                 if(lastActiveDigit>0 && current_toadd[lastActiveDigit-1]>0){
661                     toBalance = current_toadd[lastActiveDigit-1] * current_mul();
662                 }
663 
664 
665                 if(toBalance > 0 && toBalance < dec[8-round+1]){ // Not enough
666 
667                     renewDec( accounts[account].balance, accounts[account].balance.add(toBalance) );
668                     emit Transfer(address(0), account, toBalance);
669                     // Refreshing dec arr
670                     accounts[account].balance = accounts[account].balance.add(toBalance);
671                     // Adding to ball
672                     dec[8-round+1] = dec[8-round+1].sub(toBalance);
673                     // Taking from burned decimal
674                     _totalSupply = _totalSupply.add(toBalance);
675                     // Add dividend to _totalSupply
676                 }
677 
678                 accounts[account].lastRound = round;
679                 // Writting last round in wich user got dividends
680                 if(accounts[account].lastEpoch != epoch){
681                     accounts[account].lastEpoch = epoch;
682                 }
683 
684 
685                 return accounts[account].balance;
686                 // returns new balance
687             }else{
688                 if( round == 9){ //100000000 = 9 mul (mul8)
689 
690                     uint newBalance = fix_amount(accounts[account].balance);
691                     uint _diff = accounts[account].balance.sub(newBalance);
692 
693                     if(_diff > 0){
694                         renewDec( accounts[account].balance, newBalance );
695                         accounts[account].balance = newBalance;
696                         emit Transfer(account, address(0), _diff);
697                     }
698 
699                     accounts[account].lastRound = round;
700                     // Writting last round in wich user got dividends
701                     if(accounts[account].lastEpoch != epoch){
702                         accounts[account].lastEpoch = epoch;
703                     }
704 
705 
706                     return accounts[account].balance;
707                     // returns new balance
708                 }
709             }
710         }
711     }
712 
713     // Returns current multipl. based on round
714     // Returns current multiplier based on round
715     function current_mul() internal view returns(uint _current_mul){
716         return mul[round-1];
717     }
718     // Removes burned values 123 -> 120  
719     // Returns fixed
720     function fix_amount(uint amount) public view returns(uint fixed_amount){
721         return ( amount / current_mul() ) * current_mul();
722     }
723     // Returns rest
724     function get_rest(uint amount) internal view returns(uint fixed_amount){
725         return amount % current_mul();
726     }
727 
728 
729 
730     // ------------------------------------------------------------------------
731     // ERC20 totalSupply: 
732     //-------------------------------------------------------------------------
733     function totalSupply() public view returns (uint) {
734         return _totalSupply;
735     }
736     // ------------------------------------------------------------------------
737     // ERC20 balanceOf: Get the token balance for account `tokenOwner`
738     // ------------------------------------------------------------------------
739     function balanceOf(address tokenOwner) public constant returns (uint balance) {
740         return accounts[tokenOwner].balance;
741     }
742     // ------------------------------------------------------------------------
743     // ERC20 allowance:
744     // Returns the amount of tokens approved by the owner that can be
745     // transferred to the spender's account
746     // ------------------------------------------------------------------------
747     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
748         return allowed[tokenOwner][spender];
749     }
750     // ------------------------------------------------------------------------
751     // ERC20 transfer:
752     // Transfer the balance from token owner's account to `to` account
753     // - Owner's account must have sufficient balance to transfer
754     // - 0 value transfers are allowed
755     // ------------------------------------------------------------------------
756     function transfer(address to, uint tokens) public returns (bool success) {
757         require(frozen == false); 
758         require(to != address(0));
759         require(bitmask_check(to, 1024) == false); // banned == false
760 
761         //Fixing amount, deleting burned decimals
762         tokens = fix_amount(tokens);
763         // Checking if greater then 0
764         require(tokens>0);
765 
766         //Refreshing accs, payng dividends
767         updateAccount(to);
768         updateAccount(msg.sender);
769 
770         uint fromOldBal = accounts[msg.sender].balance;
771         uint toOldBal = accounts[to].balance;
772 
773         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(tokens);
774         accounts[to].balance = accounts[to].balance.add(tokens);
775 
776         require(renewDec(fromOldBal, accounts[msg.sender].balance));
777         require(renewDec(toOldBal, accounts[to].balance));
778 
779         emit Transfer(msg.sender, to, tokens);
780         return true;
781     }
782 
783 
784     // ------------------------------------------------------------------------
785     // ERC20 approve:
786     // Token owner can approve for `spender` to transferFrom(...) `tokens`
787     // from the token owner's account
788     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
789     // recommends that there are no checks for the approval double-spend attack
790     // as this should be implemented in user interfaces 
791     // ------------------------------------------------------------------------
792     function approve(address spender, uint tokens) public returns (bool success) {
793         require(frozen == false); 
794         require(bitmask_check(msg.sender, 1024) == false); // banned == false
795         allowed[msg.sender][spender] = tokens;
796         emit Approval(msg.sender, spender, tokens);
797         return true;
798     }
799     // ------------------------------------------------------------------------
800     // ERC20 transferFrom:
801     // Transfer `tokens` from the `from` account to the `to` account
802     // The calling account must already have sufficient tokens approve(...)-d
803     // for spending from the `from` account and
804     // - From account must have sufficient balance to transfer
805     // - Spender must have sufficient allowance to transfer
806     // - 0 value transfers are allowed
807     // ------------------------------------------------------------------------
808     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
809         require(frozen == false); 
810         require(bitmask_check(to, 1024) == false); // banned == false
811         updateAccount(from);
812         updateAccount(to);
813 
814         uint fromOldBal = accounts[from].balance;
815         uint toOldBal = accounts[to].balance;
816 
817         accounts[from].balance = accounts[from].balance.sub(tokens);
818         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
819         accounts[to].balance = accounts[to].balance.add(tokens);
820 
821         require(renewDec(fromOldBal, accounts[from].balance));
822         require(renewDec(toOldBal, accounts[to].balance));
823 
824         emit Transfer(from, to, tokens);
825         return true; 
826     }
827 
828     // ------------------------------------------------------------------------
829     // Token owner can approve for `spender` to transferFrom(...) `tokens`
830     // from the token owner's account. The `spender` contract function
831     // `receiveApproval(...)` is then executed
832     // ------------------------------------------------------------------------
833     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
834         require(frozen == false); 
835         require(bitmask_check(msg.sender, 1024) == false); // banned == false
836         allowed[msg.sender][spender] = tokens;
837         emit Approval(msg.sender, spender, tokens);
838         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
839         return true;
840     }
841     // ------------------------------------------------------------------------
842     // Don't accept ETH https://github.com/ConsenSys/Ethereum-Development-Best-Practices/wiki/Fallback-functions-and-the-fundamental-limitations-of-using-send()-in-Ethereum-&-Solidity
843     // ------------------------------------------------------------------------
844     function () public payable {
845         revert();
846     } // OR function() payable { } to accept ETH 
847 
848     // ------------------------------------------------------------------------
849     // Owner can transfer out any accidentally sent ERC20 tokens
850     // ------------------------------------------------------------------------
851     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
852         require(frozen == false); 
853         return ERC20Interface(tokenAddress).transfer(owner, tokens);
854     }
855 
856 
857 
858 
859 } // © Musqogees Tech 2018, Redenom ™