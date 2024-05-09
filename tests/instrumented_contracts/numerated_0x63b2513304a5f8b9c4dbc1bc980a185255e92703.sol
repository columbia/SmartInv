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
128     uint public total_fund; // All funds for all epochs 1 000 000 NOM
129     uint public epoch_fund; // All funds for current epoch 100 000 NOM
130     uint public team_fund; // Team Fund 10% of all funds paid
131     uint public redenom_dao_fund; // DAO Fund 30% of all funds paid
132 
133     struct Account {
134         uint balance;
135         uint lastRound; // Last round dividens paid
136         uint lastVotedBallotId; // Last epoch user voted
137         uint bitmask;
138             // 2 - got 0.55... for phone verif.
139             // 4 - got 1 for KYC
140             // 1024 - banned
141             //
142             // [2] [4] 8 16 32 64 128 256 512 [1024] ... - free to use
143     }
144     
145     mapping(address=>Account) accounts; 
146     mapping(address => mapping(address => uint)) allowed;
147 
148     //Redenom special events
149     event Redenomination(uint indexed round);
150     event Epoch(uint indexed epoch);
151     event VotingOn(uint indexed _ballotId);
152     event VotingOff(uint indexed winner);
153     event Vote(address indexed voter, uint indexed propId, uint voterBalance, uint indexed curentBallotId);
154 
155     function Redenom() public {
156         symbol = "NOMT";
157         name = "Redenom_test";
158         _totalSupply = 0; // total NOM's in the game 
159 
160         total_fund = 1000000 * 10**decimals; // 1 000 000.00000000, 1Mt
161         epoch_fund = 100000 * 10**decimals; // 100 000.00000000, 100 Kt
162         total_fund = total_fund.sub(epoch_fund); // Taking 100 Kt from total to epoch_fund
163 
164     }
165 
166 
167 
168 
169     // New epoch can be started if:
170     // - Current round is 9
171     // - Curen epoch < 10
172     // - Voting is over
173     function StartNewEpoch() public onlyAdmin returns(bool succ){
174         require(frozen == false); 
175         require(round == 9);
176         require(epoch < 10);
177         require(votingActive == false); 
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
195 /*
196 struct Account {
197     uint balance;
198     uint lastRound; // Last round dividens paid
199     uint lastVotedBallotId; // Last epoch user voted
200     uint[] parts; // Users parts in voted projects 
201     uint bitmask;
202 */
203 
204     //Is voting active?
205     bool public votingActive = false;
206     uint public curentBallotId = 0;
207     uint public curentWinner;
208 
209     // Voter requirements:
210     modifier onlyVoter {
211         require(votingActive == true);
212         require(bitmask_check(msg.sender, 4) == true); //passed KYC
213         require(bitmask_check(msg.sender, 1024) == false); // banned == false
214         require((accounts[msg.sender].lastVotedBallotId < curentBallotId)); 
215         _;
216     }
217 
218     // This is a type for a single Project.
219     struct Project {
220         uint id;   // Project id
221         uint votesWeight; // total weight
222         bool active; //active status.
223     }
224     Project[] public projects;
225 
226     struct Winner {
227         uint id;
228         uint projId;
229     }
230     Winner[] public winners;
231 
232 
233     function addWinner(uint projId) internal {
234         winners.push(Winner({
235             id: curentBallotId,
236             projId: projId
237         }));
238     }
239     function findWinner(uint _ballotId) public constant returns (uint winner){
240         for (uint p = 0; p < winners.length; p++) {
241             if (winners[p].id == _ballotId) {
242                 return winners[p].projId;
243             }
244         }
245     }
246 
247 
248 
249     // Add prop. with id: _id
250     function addProject(uint _id) public onlyAdmin {
251         projects.push(Project({
252             id: _id,
253             votesWeight: 0,
254             active: true
255         }));
256     }
257 
258     // Turns project ON and OFF
259     function swapProject(uint _id) public onlyAdmin {
260         for (uint p = 0; p < projects.length; p++){
261             if(projects[p].id == _id){
262                 if(projects[p].active == true){
263                     projects[p].active = false;
264                 }else{
265                     projects[p].active = true;
266                 }
267             }
268         }
269     }
270 
271     // Returns proj. weight
272     function projectWeight(uint _id) public constant returns(uint PW){
273         for (uint p = 0; p < projects.length; p++){
274             if(projects[p].id == _id){
275                 return projects[p].votesWeight;
276             }
277         }
278     }
279 
280     // Returns proj. status
281     function projectActive(uint _id) public constant returns(bool PA){
282         for (uint p = 0; p < projects.length; p++){
283             if(projects[p].id == _id){
284                 return projects[p].active;
285             }
286         }
287     }
288 
289     // Vote for proj. using id: _id
290     function vote(uint _id) public onlyVoter returns(bool success){
291         require(frozen == false);
292 
293         for (uint p = 0; p < projects.length; p++){
294             if(projects[p].id == _id && projects[p].active == true){
295                 projects[p].votesWeight += sqrt(accounts[msg.sender].balance);
296                 accounts[msg.sender].lastVotedBallotId = curentBallotId;
297             }
298         }
299         emit Vote(msg.sender, _id, accounts[msg.sender].balance, curentBallotId);
300 
301         return true;
302     }
303 
304     // Shows currently winning proj 
305     function winningProject() public constant returns (uint _winningProject){
306         uint winningVoteWeight = 0;
307         for (uint p = 0; p < projects.length; p++) {
308             if (projects[p].votesWeight > winningVoteWeight && projects[p].active == true) {
309                 winningVoteWeight = projects[p].votesWeight;
310                 _winningProject = projects[p].id;
311             }
312         }
313     }
314 
315     // Activates voting
316     // Clears projects
317     function enableVoting() public onlyAdmin returns(uint ballotId){ 
318         require(votingActive == false);
319         require(frozen == false);
320 
321         curentBallotId++;
322         votingActive = true;
323 
324         delete projects;
325 
326         emit VotingOn(curentBallotId);
327         return curentBallotId;
328     }
329 
330     // Deactivates voting
331     function disableVoting() public onlyAdmin returns(uint winner){
332         require(votingActive == true);
333         require(frozen == false);
334         votingActive = false;
335 
336         curentWinner = winningProject();
337         addWinner(curentWinner);
338         
339         emit VotingOff(curentWinner);
340         return curentWinner;
341     }
342 
343 
344     // sqrt root func
345     function sqrt(uint x) internal pure returns (uint y) {
346         uint z = (x + 1) / 2;
347         y = x;
348         while (z < y) {
349             y = z;
350             z = (x / z + z) / 2;
351         }
352     }
353 
354     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
355 
356 
357 
358 
359     ///////////////////////////////////////////////////////////////////////////////////////////////////////
360     // NOM token emission functions
361     ///////////////////////////////////////////////////////////////////////////////////////////////////////
362 
363     // Pays 1.00000000 from epoch_fund to KYC-passed user
364     // Uses payout(), bitmask_check(), bitmask_add()
365     // adds 4 to bitmask
366     function pay1(address to) public onlyAdmin returns(bool success){
367         require(bitmask_check(to, 4) == false);
368         uint new_amount = 100000000;
369         payout(to,new_amount);
370         bitmask_add(to, 4);
371         return true;
372     }
373 
374     // Pays .555666XX from epoch_fund to user approved phone;
375     // Uses payout(), bitmask_check(), bitmask_add()
376     // adds 2 to bitmask
377     function pay055(address to) public onlyAdmin returns(bool success){
378         require(bitmask_check(to, 2) == false);
379         uint new_amount = 55566600 + (block.timestamp%100);       
380         payout(to,new_amount);
381         bitmask_add(to, 2);
382         return true;
383     }
384 
385     // Pays .555666XX from epoch_fund to KYC user in new epoch;
386     // Uses payout(), bitmask_check(), bitmask_add()
387     // adds 2 to bitmask
388     function pay055loyal(address to) public onlyAdmin returns(bool success){
389         require(epoch > 1);
390         require(bitmask_check(to, 4) == true);
391         uint new_amount = 55566600 + (block.timestamp%100);       
392         payout(to,new_amount);
393         return true;
394     }
395 
396     // Pays random number from epoch_fund
397     // Uses payout()
398     function payCustom(address to, uint amount) public onlyOwner returns(bool success){
399         payout(to,amount);
400         return true;
401     }
402 
403     // Pays [amount] of money to [to] account from epoch_fund
404     // Counts amount +30% +10%
405     // Updating _totalSupply
406     // Pays to balance and 2 funds
407     // Refreshes dec[]
408     // Emits event
409     function payout(address to, uint amount) private returns (bool success){
410         require(to != address(0));
411         require(amount>=current_mul());
412         require(bitmask_check(to, 1024) == false); // banned == false
413         require(frozen == false); 
414         
415         //Update account balance
416         updateAccount(to);
417         //fix amount
418         uint fixedAmount = fix_amount(amount);
419 
420         renewDec( accounts[to].balance, accounts[to].balance.add(fixedAmount) );
421 
422         uint team_part = (fixedAmount/100)*10;
423         uint dao_part = (fixedAmount/100)*30;
424         uint total = fixedAmount.add(team_part).add(dao_part);
425 
426         epoch_fund = epoch_fund.sub(total);
427         team_fund = team_fund.add(team_part);
428         redenom_dao_fund = redenom_dao_fund.add(dao_part);
429         accounts[to].balance = accounts[to].balance.add(fixedAmount);
430         _totalSupply = _totalSupply.add(total);
431 
432         emit Transfer(address(0), to, fixedAmount);
433         return true;
434     }
435     ///////////////////////////////////////////////////////////////////////////////////////////////////////
436 
437 
438 
439 
440     ///////////////////////////////////////////////////////////////////////////////////////////////////////
441 
442     // Withdraw amount from team_fund to given address
443     function withdraw_team_fund(address to, uint amount) public onlyOwner returns(bool success){
444         require(amount <= team_fund);
445         accounts[to].balance = accounts[to].balance.add(amount);
446         team_fund = team_fund.sub(amount);
447         return true;
448     }
449     // Withdraw amount from redenom_dao_fund to given address
450     function withdraw_dao_fund(address to, uint amount) public onlyOwner returns(bool success){
451         require(amount <= redenom_dao_fund);
452         accounts[to].balance = accounts[to].balance.add(amount);
453         redenom_dao_fund = redenom_dao_fund.sub(amount);
454         return true;
455     }
456 
457     function freeze_contract() public onlyOwner returns(bool success){
458         require(frozen == false);
459         frozen = true;
460         return true;
461     }
462     function unfreeze_contract() public onlyOwner returns(bool success){
463         require(frozen == true);
464         frozen = false;
465         return true;
466     }
467     ///////////////////////////////////////////////////////////////////////////////////////////////////////
468 
469 
470     // Run this on every change of user balance
471     // Refreshes dec[] array
472     // Takes initial and new ammount
473     // while transaction must be called for each acc.
474     function renewDec(uint initSum, uint newSum) internal returns(bool success){
475 
476         if(round < 9){
477             uint tempInitSum = initSum; 
478             uint tempNewSum = newSum; 
479             uint cnt = 1;
480 
481             while( (tempNewSum > 0 || tempInitSum > 0) && cnt <= decimals ){
482 
483                 uint lastInitSum = tempInitSum%10; // 0.0000000 (0)
484                 tempInitSum = tempInitSum/10; // (0.0000000) 0
485 
486                 uint lastNewSum = tempNewSum%10; // 1.5556664 (5)
487                 tempNewSum = tempNewSum/10; // (1.5556664) 5
488 
489                 if(cnt >= round){
490                     if(lastNewSum >= lastInitSum){
491                         // If new is bigger
492                         dec[decimals-cnt] = dec[decimals-cnt].add(lastNewSum - lastInitSum);
493                     }else{
494                         // If new is smaller
495                         dec[decimals-cnt] = dec[decimals-cnt].sub(lastInitSum - lastNewSum);
496                     }
497                 }
498 
499                 cnt = cnt+1;
500             }
501         }//if(round < 9){
502 
503         return true;
504     }
505 
506 
507 
508     ////////////////////////////////////////// BITMASK /////////////////////////////////////////////////////
509     // Adding bit to bitmask
510     // checks if already set
511     function bitmask_add(address user, uint _bit) internal returns(bool success){ //todo privat?
512         require(bitmask_check(user, _bit) == false);
513         accounts[user].bitmask = accounts[user].bitmask.add(_bit);
514         return true;
515     }
516     // Removes bit from bitmask
517     // checks if already set
518     function bitmask_rm(address user, uint _bit) internal returns(bool success){
519         require(bitmask_check(user, _bit) == true);
520         accounts[user].bitmask = accounts[user].bitmask.sub(_bit);
521         return true;
522     }
523     // Checks whether some bit is present in BM
524     function bitmask_check(address user, uint _bit) internal view returns (bool status){
525         bool flag;
526         accounts[user].bitmask & _bit == 0 ? flag = false : flag = true;
527         return flag;
528     }
529     ///////////////////////////////////////////////////////////////////////////////////////////////////////
530 
531     function ban_user(address user) public onlyAdmin returns(bool success){
532         bitmask_add(user, 1024);
533         return true;
534     }
535     function unban_user(address user) public onlyAdmin returns(bool success){
536         bitmask_rm(user, 1024);
537         return true;
538     }
539     function is_banned(address user) public view onlyAdmin returns (bool result){
540         return bitmask_check(user, 1024);
541     }
542     ///////////////////////////////////////////////////////////////////////////////////////////////////////
543 
544 
545 
546     //Redenominates 
547     function redenominate() public onlyAdmin returns(uint current_round){
548         require(frozen == false); 
549         require(round<9); // Round must be < 9
550 
551         // Deleting funds rest from TS
552         _totalSupply = _totalSupply.sub( team_fund%mul[round] ).sub( redenom_dao_fund%mul[round] ).sub( dec[8-round]*mul[round-1] );
553 
554         // Redenominating 3 vars: _totalSupply team_fund redenom_dao_fund
555         _totalSupply = ( _totalSupply / mul[round] ) * mul[round];
556         team_fund = ( team_fund / mul[round] ) * mul[round]; // Redenominates team_fund
557         redenom_dao_fund = ( redenom_dao_fund / mul[round] ) * mul[round]; // Redenominates redenom_dao_fund
558 
559         if(round>1){
560             // decimals burned in last round and not distributed
561             uint superold = dec[(8-round)+1]; 
562 
563             // Returning them to epoch_fund
564             epoch_fund = epoch_fund.add(superold * mul[round-2]);
565             dec[(8-round)+1] = 0;
566         }
567 
568         
569         if(round<8){ // if round between 1 and 7 
570 
571             uint unclimed = dec[8-round]; // total sum of burned decimal
572             //[23,32,43,34,34,54,34, ->46<- ]
573             uint total_current = dec[8-1-round]; // total sum of last active decimal
574             //[23,32,43,34,34,54, ->34<-, 46]
575 
576             // security check
577             if(total_current==0){
578                 current_toadd = [0,0,0,0,0,0,0,0,0]; 
579                 round++;
580                 return round;
581             }
582 
583             // Counting amounts to add on every digit
584             uint[9] memory numbers  =[uint(1),2,3,4,5,6,7,8,9]; // 
585             uint[9] memory ke9  =[uint(0),0,0,0,0,0,0,0,0]; // 
586             uint[9] memory k2e9  =[uint(0),0,0,0,0,0,0,0,0]; // 
587 
588             uint k05summ = 0;
589 
590                 for (uint k = 0; k < ke9.length; k++) {
591                      
592                     ke9[k] = numbers[k]*1e9/total_current;
593                     if(k<5) k05summ += ke9[k];
594                 }             
595                 for (uint k2 = 5; k2 < k2e9.length; k2++) {
596                     k2e9[k2] = uint(ke9[k2])+uint(k05summ)*uint(weight[k2])/uint(100);
597                 }
598                 for (uint n = 5; n < current_toadd.length; n++) {
599                     current_toadd[n] = k2e9[n]*unclimed/10/1e9;
600                 }
601                 // current_toadd now contains all digits
602                 
603         }else{
604             if(round==8){
605                 // Returns last burned decimals to epoch_fund
606                 epoch_fund = epoch_fund.add(dec[0] * 10000000); //1e7
607                 dec[0] = 0;
608             }
609             
610         }
611 
612         round++;
613         emit Redenomination(round);
614         return round;
615     }
616 
617    
618     // Refresh user acc
619     // Pays dividends if any
620     function updateAccount(address account) public returns(uint new_balance){
621         require(frozen == false); 
622         require(round<=9);
623         require(bitmask_check(account, 1024) == false); // banned == false
624 
625         if(round > accounts[account].lastRound){
626 
627             if(round >1 && round <=8){
628 
629 
630                 // Splits user bal by current multiplier
631                 uint tempDividedBalance = accounts[account].balance/current_mul();
632                 // [1.5556663] 4  (r2)
633                 uint newFixedBalance = tempDividedBalance*current_mul();
634                 // [1.55566630]  (r2)
635                 uint lastActiveDigit = tempDividedBalance%10;
636                  // 1.555666 [3] 4  (r2)
637                 uint diff = accounts[account].balance - newFixedBalance;
638                 // 1.5556663 [4] (r2)
639 
640                 if(diff > 0){
641                     accounts[account].balance = newFixedBalance;
642                     emit Transfer(account, address(0), diff);
643                 }
644 
645                 uint toBalance = 0;
646                 if(lastActiveDigit>0 && current_toadd[lastActiveDigit-1]>0){
647                     toBalance = current_toadd[lastActiveDigit-1] * current_mul();
648                 }
649 
650 
651                 if(toBalance > 0 && toBalance < dec[8-round+1]){ // Not enough
652 
653                     renewDec( accounts[account].balance, accounts[account].balance.add(toBalance) );
654                     emit Transfer(address(0), account, toBalance);
655                     // Refreshing dec arr
656                     accounts[account].balance = accounts[account].balance.add(toBalance);
657                     // Adding to ball
658                     dec[8-round+1] = dec[8-round+1].sub(toBalance);
659                     // Taking from burned decimal
660                     _totalSupply = _totalSupply.add(toBalance);
661                     // Add dividend to _totalSupply
662                 }
663 
664                 accounts[account].lastRound = round;
665                 // Writting last round in wich user got dividends
666                 return accounts[account].balance;
667                 // returns new balance
668             }else{
669                 if( round == 9){ //100000000 = 9 mul (mul8)
670 
671                     uint newBalance = fix_amount(accounts[account].balance);
672                     uint _diff = accounts[account].balance.sub(newBalance);
673 
674                     if(_diff > 0){
675                         renewDec( accounts[account].balance, newBalance );
676                         accounts[account].balance = newBalance;
677                         emit Transfer(account, address(0), _diff);
678                     }
679 
680                     accounts[account].lastRound = round;
681                     // Writting last round in wich user got dividends
682                     return accounts[account].balance;
683                     // returns new balance
684                 }
685             }
686         }
687     }
688 
689     // Returns current multipl. based on round
690     // Returns current multiplier based on round
691     function current_mul() internal view returns(uint _current_mul){
692         return mul[round-1];
693     }
694     // Removes burned values 123 -> 120  
695     // Returns fixed
696     function fix_amount(uint amount) public view returns(uint fixed_amount){
697         return ( amount / current_mul() ) * current_mul();
698     }
699     // Returns rest
700     function get_rest(uint amount) internal view returns(uint fixed_amount){
701         return amount % current_mul();
702     }
703 
704 
705 
706     // ------------------------------------------------------------------------
707     // ERC20 totalSupply: 
708     //-------------------------------------------------------------------------
709     function totalSupply() public view returns (uint) {
710         return _totalSupply;
711     }
712     // ------------------------------------------------------------------------
713     // ERC20 balanceOf: Get the token balance for account `tokenOwner`
714     // ------------------------------------------------------------------------
715     function balanceOf(address tokenOwner) public constant returns (uint balance) {
716         return accounts[tokenOwner].balance;
717     }
718     // ------------------------------------------------------------------------
719     // ERC20 allowance:
720     // Returns the amount of tokens approved by the owner that can be
721     // transferred to the spender's account
722     // ------------------------------------------------------------------------
723     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
724         return allowed[tokenOwner][spender];
725     }
726     // ------------------------------------------------------------------------
727     // ERC20 transfer:
728     // Transfer the balance from token owner's account to `to` account
729     // - Owner's account must have sufficient balance to transfer
730     // - 0 value transfers are allowed
731     // ------------------------------------------------------------------------
732     function transfer(address to, uint tokens) public returns (bool success) {
733         require(frozen == false); 
734         require(to != address(0));
735         require(bitmask_check(to, 1024) == false); // banned == false
736 
737         //Fixing amount, deleting burned decimals
738         tokens = fix_amount(tokens);
739         // Checking if greater then 0
740         require(tokens>0);
741 
742         //Refreshing accs, payng dividends
743         updateAccount(to);
744         updateAccount(msg.sender);
745 
746         uint fromOldBal = accounts[msg.sender].balance;
747         uint toOldBal = accounts[to].balance;
748 
749         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(tokens);
750         accounts[to].balance = accounts[to].balance.add(tokens);
751 
752         require(renewDec(fromOldBal, accounts[msg.sender].balance));
753         require(renewDec(toOldBal, accounts[to].balance));
754 
755         emit Transfer(msg.sender, to, tokens);
756         return true;
757     }
758 
759 
760     // ------------------------------------------------------------------------
761     // ERC20 approve:
762     // Token owner can approve for `spender` to transferFrom(...) `tokens`
763     // from the token owner's account
764     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
765     // recommends that there are no checks for the approval double-spend attack
766     // as this should be implemented in user interfaces 
767     // ------------------------------------------------------------------------
768     function approve(address spender, uint tokens) public returns (bool success) {
769         require(frozen == false); 
770         require(bitmask_check(msg.sender, 1024) == false); // banned == false
771         allowed[msg.sender][spender] = tokens;
772         emit Approval(msg.sender, spender, tokens);
773         return true;
774     }
775     // ------------------------------------------------------------------------
776     // ERC20 transferFrom:
777     // Transfer `tokens` from the `from` account to the `to` account
778     // The calling account must already have sufficient tokens approve(...)-d
779     // for spending from the `from` account and
780     // - From account must have sufficient balance to transfer
781     // - Spender must have sufficient allowance to transfer
782     // - 0 value transfers are allowed
783     // ------------------------------------------------------------------------
784     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
785         require(frozen == false); 
786         require(bitmask_check(to, 1024) == false); // banned == false
787         updateAccount(from);
788         updateAccount(to);
789 
790         uint fromOldBal = accounts[from].balance;
791         uint toOldBal = accounts[to].balance;
792 
793         accounts[from].balance = accounts[from].balance.sub(tokens);
794         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
795         accounts[to].balance = accounts[to].balance.add(tokens);
796 
797         require(renewDec(fromOldBal, accounts[from].balance));
798         require(renewDec(toOldBal, accounts[to].balance));
799 
800         emit Transfer(from, to, tokens);
801         return true; 
802     }
803     // ------------------------------------------------------------------------
804     // Token owner can approve for `spender` to transferFrom(...) `tokens`
805     // from the token owner's account. The `spender` contract function
806     // `receiveApproval(...)` is then executed
807     // ------------------------------------------------------------------------
808     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
809         require(frozen == false); 
810         require(bitmask_check(msg.sender, 1024) == false); // banned == false
811         allowed[msg.sender][spender] = tokens;
812         emit Approval(msg.sender, spender, tokens);
813         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
814         return true;
815     }
816     // ------------------------------------------------------------------------
817     // Don't accept ETH https://github.com/ConsenSys/Ethereum-Development-Best-Practices/wiki/Fallback-functions-and-the-fundamental-limitations-of-using-send()-in-Ethereum-&-Solidity
818     // ------------------------------------------------------------------------
819     function () public payable {
820         revert();
821     } // OR function() payable { } to accept ETH 
822 
823     // ------------------------------------------------------------------------
824     // Owner can transfer out any accidentally sent ERC20 tokens
825     // ------------------------------------------------------------------------
826     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
827         require(frozen == false); 
828         return ERC20Interface(tokenAddress).transfer(owner, tokens);
829     }
830 
831 
832 
833 
834 } // © Musqogees Tech 2018, Redenom ™