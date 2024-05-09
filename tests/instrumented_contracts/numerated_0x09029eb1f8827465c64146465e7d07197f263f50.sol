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
153     event VotingOff(uint indexed winner);
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
283         require(frozen == false);
284 
285         for (uint p = 0; p < projects.length; p++){
286             if(projects[p].id == _id && projects[p].active == true){
287                 projects[p].votesWeight += sqrt(accounts[msg.sender].balance);
288                 accounts[msg.sender].lastVotedBallotId = curentBallotId;
289             }
290         }
291         emit Vote(msg.sender, _id, accounts[msg.sender].balance, curentBallotId);
292 
293         return true;
294     }
295 
296     // Shows currently winning proj 
297     function winningProject() public constant returns (uint _winningProject){
298         uint winningVoteWeight = 0;
299         for (uint p = 0; p < projects.length; p++) {
300             if (projects[p].votesWeight > winningVoteWeight && projects[p].active == true) {
301                 winningVoteWeight = projects[p].votesWeight;
302                 _winningProject = projects[p].id;
303             }
304         }
305     }
306 
307     // Activates voting
308     // Clears projects
309     function enableVoting() public onlyAdmin returns(uint ballotId){ 
310         require(votingActive == false);
311         require(frozen == false);
312 
313         curentBallotId++;
314         votingActive = true;
315 
316         delete projects;
317 
318         emit VotingOn(curentBallotId);
319         return curentBallotId;
320     }
321 
322     // Deactivates voting
323     function disableVoting() public onlyAdmin returns(uint winner){
324         require(votingActive == true);
325         require(frozen == false);
326         votingActive = false;
327 
328         curentWinner = winningProject();
329         addWinner(curentWinner);
330         
331         emit VotingOff(curentWinner);
332         return curentWinner;
333     }
334 
335 
336     // sqrt root func
337     function sqrt(uint x) internal pure returns (uint y) {
338         uint z = (x + 1) / 2;
339         y = x;
340         while (z < y) {
341             y = z;
342             z = (x / z + z) / 2;
343         }
344     }
345 
346     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
347 
348 
349 
350 
351     ///////////////////////////////////////////////////////////////////////////////////////////////////////
352     // NOM token emission functions
353     ///////////////////////////////////////////////////////////////////////////////////////////////////////
354 
355     // Pays 1.00000000 from epoch_fund to KYC-passed user
356     // Uses payout(), bitmask_check(), bitmask_add()
357     // adds 4 to bitmask
358     function pay1(address to) public onlyAdmin returns(bool success){
359         require(bitmask_check(to, 4) == false);
360         uint new_amount = 100000000;
361         payout(to,new_amount);
362         bitmask_add(to, 4);
363         return true;
364     }
365 
366     // Pays .555666XX from epoch_fund to user approved phone;
367     // Uses payout(), bitmask_check(), bitmask_add()
368     // adds 2 to bitmask
369     function pay055(address to) public onlyAdmin returns(bool success){
370         require(bitmask_check(to, 2) == false);
371         uint new_amount = 55566600 + (block.timestamp%100);       
372         payout(to,new_amount);
373         bitmask_add(to, 2);
374         return true;
375     }
376 
377     // Pays .555666XX from epoch_fund to KYC user in new epoch;
378     // Uses payout(), bitmask_check(), bitmask_add()
379     // adds 2 to bitmask
380     function pay055loyal(address to) public onlyAdmin returns(bool success){
381         require(epoch > 1);
382         require(bitmask_check(to, 4) == true);
383         uint new_amount = 55566600 + (block.timestamp%100);       
384         payout(to,new_amount);
385         return true;
386     }
387 
388     // Pays random number from epoch_fund
389     // Uses payout()
390     function payCustom(address to, uint amount) public onlyOwner returns(bool success){
391         payout(to,amount);
392         return true;
393     }
394 
395     // Pays [amount] of money to [to] account from epoch_fund
396     // Counts amount +30% +10%
397     // Updating _totalSupply
398     // Pays to balance and 2 funds
399     // Refreshes dec[]
400     // Emits event
401     function payout(address to, uint amount) private returns (bool success){
402         require(to != address(0));
403         require(amount>=current_mul());
404         require(bitmask_check(to, 1024) == false); // banned == false
405         require(frozen == false); 
406         
407         //Update account balance
408         updateAccount(to);
409         //fix amount
410         uint fixedAmount = fix_amount(amount);
411 
412         renewDec( accounts[to].balance, accounts[to].balance.add(fixedAmount) );
413 
414         uint team_part = (fixedAmount/100)*16;
415         uint dao_part = (fixedAmount/10)*6;
416         uint total = fixedAmount.add(team_part).add(dao_part);
417 
418         epoch_fund = epoch_fund.sub(total);
419         team_fund = team_fund.add(team_part);
420         redenom_dao_fund = redenom_dao_fund.add(dao_part);
421         accounts[to].balance = accounts[to].balance.add(fixedAmount);
422         _totalSupply = _totalSupply.add(total);
423 
424         emit Transfer(address(0), to, fixedAmount);
425         return true;
426     }
427     ///////////////////////////////////////////////////////////////////////////////////////////////////////
428 
429 
430 
431 
432     ///////////////////////////////////////////////////////////////////////////////////////////////////////
433 
434     // Withdraw amount from team_fund to given address
435     function withdraw_team_fund(address to, uint amount) public onlyOwner returns(bool success){
436         require(amount <= team_fund);
437         accounts[to].balance = accounts[to].balance.add(amount);
438         team_fund = team_fund.sub(amount);
439         return true;
440     }
441     // Withdraw amount from redenom_dao_fund to given address
442     function withdraw_dao_fund(address to, uint amount) public onlyOwner returns(bool success){
443         require(amount <= redenom_dao_fund);
444         accounts[to].balance = accounts[to].balance.add(amount);
445         redenom_dao_fund = redenom_dao_fund.sub(amount);
446         return true;
447     }
448 
449     function freeze_contract() public onlyOwner returns(bool success){
450         require(frozen == false);
451         frozen = true;
452         return true;
453     }
454     function unfreeze_contract() public onlyOwner returns(bool success){
455         require(frozen == true);
456         frozen = false;
457         return true;
458     }
459     ///////////////////////////////////////////////////////////////////////////////////////////////////////
460 
461 
462     // Run this on every change of user balance
463     // Refreshes dec[] array
464     // Takes initial and new ammount
465     // while transaction must be called for each acc.
466     function renewDec(uint initSum, uint newSum) internal returns(bool success){
467 
468         if(round < 9){
469             uint tempInitSum = initSum; 
470             uint tempNewSum = newSum; 
471             uint cnt = 1;
472 
473             while( (tempNewSum > 0 || tempInitSum > 0) && cnt <= decimals ){
474 
475                 uint lastInitSum = tempInitSum%10; // 0.0000000 (0)
476                 tempInitSum = tempInitSum/10; // (0.0000000) 0
477 
478                 uint lastNewSum = tempNewSum%10; // 1.5556664 (5)
479                 tempNewSum = tempNewSum/10; // (1.5556664) 5
480 
481                 if(cnt >= round){
482                     if(lastNewSum >= lastInitSum){
483                         // If new is bigger
484                         dec[decimals-cnt] = dec[decimals-cnt].add(lastNewSum - lastInitSum);
485                     }else{
486                         // If new is smaller
487                         dec[decimals-cnt] = dec[decimals-cnt].sub(lastInitSum - lastNewSum);
488                     }
489                 }
490 
491                 cnt = cnt+1;
492             }
493         }//if(round < 9){
494 
495         return true;
496     }
497 
498 
499 
500     ////////////////////////////////////////// BITMASK /////////////////////////////////////////////////////
501     // Adding bit to bitmask
502     // checks if already set
503     function bitmask_add(address user, uint _bit) internal returns(bool success){ //todo privat?
504         require(bitmask_check(user, _bit) == false);
505         accounts[user].bitmask = accounts[user].bitmask.add(_bit);
506         return true;
507     }
508     // Removes bit from bitmask
509     // checks if already set
510     function bitmask_rm(address user, uint _bit) internal returns(bool success){
511         require(bitmask_check(user, _bit) == true);
512         accounts[user].bitmask = accounts[user].bitmask.sub(_bit);
513         return true;
514     }
515     // Checks whether some bit is present in BM
516     function bitmask_check(address user, uint _bit) public view returns (bool status){
517         bool flag;
518         accounts[user].bitmask & _bit == 0 ? flag = false : flag = true;
519         return flag;
520     }
521     ///////////////////////////////////////////////////////////////////////////////////////////////////////
522 
523     function ban_user(address user) public onlyAdmin returns(bool success){
524         bitmask_add(user, 1024);
525         return true;
526     }
527     function unban_user(address user) public onlyAdmin returns(bool success){
528         bitmask_rm(user, 1024);
529         return true;
530     }
531     function is_banned(address user) public view onlyAdmin returns (bool result){
532         return bitmask_check(user, 1024);
533     }
534     ///////////////////////////////////////////////////////////////////////////////////////////////////////
535 
536 
537 
538     //Redenominates 
539     function redenominate() public onlyAdmin returns(uint current_round){
540         require(frozen == false); 
541         require(round<9); // Round must be < 9
542 
543         // Deleting funds rest from TS
544         _totalSupply = _totalSupply.sub( team_fund%mul[round] ).sub( redenom_dao_fund%mul[round] ).sub( dec[8-round]*mul[round-1] );
545 
546         // Redenominating 3 vars: _totalSupply team_fund redenom_dao_fund
547         _totalSupply = ( _totalSupply / mul[round] ) * mul[round];
548         team_fund = ( team_fund / mul[round] ) * mul[round]; // Redenominates team_fund
549         redenom_dao_fund = ( redenom_dao_fund / mul[round] ) * mul[round]; // Redenominates redenom_dao_fund
550 
551         if(round>1){
552             // decimals burned in last round and not distributed
553             uint superold = dec[(8-round)+1]; 
554 
555             // Returning them to epoch_fund
556             epoch_fund = epoch_fund.add(superold * mul[round-2]);
557             dec[(8-round)+1] = 0;
558         }
559 
560         
561         if(round<8){ // if round between 1 and 7 
562 
563             uint unclimed = dec[8-round]; // total sum of burned decimal
564             //[23,32,43,34,34,54,34, ->46<- ]
565             uint total_current = dec[8-1-round]; // total sum of last active decimal
566             //[23,32,43,34,34,54, ->34<-, 46]
567 
568             // security check
569             if(total_current==0){
570                 current_toadd = [0,0,0,0,0,0,0,0,0]; 
571                 round++;
572                 emit Redenomination(round);
573                 return round;
574             }
575 
576             // Counting amounts to add on every digit
577             uint[9] memory numbers  =[uint(1),2,3,4,5,6,7,8,9]; // 
578             uint[9] memory ke9  =[uint(0),0,0,0,0,0,0,0,0]; // 
579             uint[9] memory k2e9  =[uint(0),0,0,0,0,0,0,0,0]; // 
580 
581             uint k05summ = 0;
582 
583                 for (uint k = 0; k < ke9.length; k++) {
584                      
585                     ke9[k] = numbers[k]*1e9/total_current;
586                     if(k<5) k05summ += ke9[k];
587                 }             
588                 for (uint k2 = 5; k2 < k2e9.length; k2++) {
589                     k2e9[k2] = uint(ke9[k2])+uint(k05summ)*uint(weight[k2])/uint(100);
590                 }
591                 for (uint n = 5; n < current_toadd.length; n++) {
592                     current_toadd[n] = k2e9[n]*unclimed/10/1e9;
593                 }
594                 // current_toadd now contains all digits
595                 
596         }else{
597             if(round==8){
598                 // Returns last burned decimals to epoch_fund
599                 epoch_fund = epoch_fund.add(dec[0] * 10000000); //1e7
600                 dec[0] = 0;
601             }
602             
603         }
604 
605         round++;
606         emit Redenomination(round);
607         return round;
608     }
609 
610 
611     function actual_balance(address user) public constant returns(uint actual_balance){
612         if(epoch > 1 && accounts[user].lastEpoch < epoch){
613             return (accounts[user].balance/100000000)*100000000;
614         }else{
615             return (accounts[user].balance/current_mul())*current_mul();
616         }
617     }
618    
619     // Refresh user acc
620     // Pays dividends if any
621     function updateAccount(address account) public returns(uint new_balance){
622         require(frozen == false); 
623         require(round<=9);
624         require(bitmask_check(account, 1024) == false); // banned == false
625 
626         if(epoch > 1 && accounts[account].lastEpoch < epoch){
627             uint entire = accounts[account].balance/100000000;
628             accounts[account].balance = entire*100000000;
629             return accounts[account].balance;
630         }
631 
632         if(round > accounts[account].lastRound){
633 
634             if(round >1 && round <=8){
635 
636 
637                 // Splits user bal by current multiplier
638                 uint tempDividedBalance = accounts[account].balance/current_mul();
639                 // [1.5556663] 4  (r2)
640                 uint newFixedBalance = tempDividedBalance*current_mul();
641                 // [1.55566630]  (r2)
642                 uint lastActiveDigit = tempDividedBalance%10;
643                  // 1.555666 [3] 4  (r2)
644                 uint diff = accounts[account].balance - newFixedBalance;
645                 // 1.5556663 [4] (r2)
646 
647                 if(diff > 0){
648                     accounts[account].balance = newFixedBalance;
649                     emit Transfer(account, address(0), diff);
650                 }
651 
652                 uint toBalance = 0;
653                 if(lastActiveDigit>0 && current_toadd[lastActiveDigit-1]>0){
654                     toBalance = current_toadd[lastActiveDigit-1] * current_mul();
655                 }
656 
657 
658                 if(toBalance > 0 && toBalance < dec[8-round+1]){ // Not enough
659 
660                     renewDec( accounts[account].balance, accounts[account].balance.add(toBalance) );
661                     emit Transfer(address(0), account, toBalance);
662                     // Refreshing dec arr
663                     accounts[account].balance = accounts[account].balance.add(toBalance);
664                     // Adding to ball
665                     dec[8-round+1] = dec[8-round+1].sub(toBalance);
666                     // Taking from burned decimal
667                     _totalSupply = _totalSupply.add(toBalance);
668                     // Add dividend to _totalSupply
669                 }
670 
671                 accounts[account].lastRound = round;
672                 // Writting last round in wich user got dividends
673                 if(accounts[account].lastEpoch != epoch){
674                     accounts[account].lastEpoch = epoch;
675                 }
676 
677 
678                 return accounts[account].balance;
679                 // returns new balance
680             }else{
681                 if( round == 9){ //100000000 = 9 mul (mul8)
682 
683                     uint newBalance = fix_amount(accounts[account].balance);
684                     uint _diff = accounts[account].balance.sub(newBalance);
685 
686                     if(_diff > 0){
687                         renewDec( accounts[account].balance, newBalance );
688                         accounts[account].balance = newBalance;
689                         emit Transfer(account, address(0), _diff);
690                     }
691 
692                     accounts[account].lastRound = round;
693                     // Writting last round in wich user got dividends
694                     if(accounts[account].lastEpoch != epoch){
695                         accounts[account].lastEpoch = epoch;
696                     }
697 
698 
699                     return accounts[account].balance;
700                     // returns new balance
701                 }
702             }
703         }
704     }
705 
706     // Returns current multipl. based on round
707     // Returns current multiplier based on round
708     function current_mul() internal view returns(uint _current_mul){
709         return mul[round-1];
710     }
711     // Removes burned values 123 -> 120  
712     // Returns fixed
713     function fix_amount(uint amount) public view returns(uint fixed_amount){
714         return ( amount / current_mul() ) * current_mul();
715     }
716     // Returns rest
717     function get_rest(uint amount) internal view returns(uint fixed_amount){
718         return amount % current_mul();
719     }
720 
721 
722 
723     // ------------------------------------------------------------------------
724     // ERC20 totalSupply: 
725     //-------------------------------------------------------------------------
726     function totalSupply() public view returns (uint) {
727         return _totalSupply;
728     }
729     // ------------------------------------------------------------------------
730     // ERC20 balanceOf: Get the token balance for account `tokenOwner`
731     // ------------------------------------------------------------------------
732     function balanceOf(address tokenOwner) public constant returns (uint balance) {
733         return accounts[tokenOwner].balance;
734     }
735     // ------------------------------------------------------------------------
736     // ERC20 allowance:
737     // Returns the amount of tokens approved by the owner that can be
738     // transferred to the spender's account
739     // ------------------------------------------------------------------------
740     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
741         return allowed[tokenOwner][spender];
742     }
743     // ------------------------------------------------------------------------
744     // ERC20 transfer:
745     // Transfer the balance from token owner's account to `to` account
746     // - Owner's account must have sufficient balance to transfer
747     // - 0 value transfers are allowed
748     // ------------------------------------------------------------------------
749     function transfer(address to, uint tokens) public returns (bool success) {
750         require(frozen == false); 
751         require(to != address(0));
752         require(bitmask_check(to, 1024) == false); // banned == false
753 
754         //Fixing amount, deleting burned decimals
755         tokens = fix_amount(tokens);
756         // Checking if greater then 0
757         require(tokens>0);
758 
759         //Refreshing accs, payng dividends
760         updateAccount(to);
761         updateAccount(msg.sender);
762 
763         uint fromOldBal = accounts[msg.sender].balance;
764         uint toOldBal = accounts[to].balance;
765 
766         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(tokens);
767         accounts[to].balance = accounts[to].balance.add(tokens);
768 
769         require(renewDec(fromOldBal, accounts[msg.sender].balance));
770         require(renewDec(toOldBal, accounts[to].balance));
771 
772         emit Transfer(msg.sender, to, tokens);
773         return true;
774     }
775 
776 
777     // ------------------------------------------------------------------------
778     // ERC20 approve:
779     // Token owner can approve for `spender` to transferFrom(...) `tokens`
780     // from the token owner's account
781     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
782     // recommends that there are no checks for the approval double-spend attack
783     // as this should be implemented in user interfaces 
784     // ------------------------------------------------------------------------
785     function approve(address spender, uint tokens) public returns (bool success) {
786         require(frozen == false); 
787         require(bitmask_check(msg.sender, 1024) == false); // banned == false
788         allowed[msg.sender][spender] = tokens;
789         emit Approval(msg.sender, spender, tokens);
790         return true;
791     }
792     // ------------------------------------------------------------------------
793     // ERC20 transferFrom:
794     // Transfer `tokens` from the `from` account to the `to` account
795     // The calling account must already have sufficient tokens approve(...)-d
796     // for spending from the `from` account and
797     // - From account must have sufficient balance to transfer
798     // - Spender must have sufficient allowance to transfer
799     // - 0 value transfers are allowed
800     // ------------------------------------------------------------------------
801     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
802         require(frozen == false); 
803         require(bitmask_check(to, 1024) == false); // banned == false
804         updateAccount(from);
805         updateAccount(to);
806 
807         uint fromOldBal = accounts[from].balance;
808         uint toOldBal = accounts[to].balance;
809 
810         accounts[from].balance = accounts[from].balance.sub(tokens);
811         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
812         accounts[to].balance = accounts[to].balance.add(tokens);
813 
814         require(renewDec(fromOldBal, accounts[from].balance));
815         require(renewDec(toOldBal, accounts[to].balance));
816 
817         emit Transfer(from, to, tokens);
818         return true; 
819     }
820     // ------------------------------------------------------------------------
821     // Token owner can approve for `spender` to transferFrom(...) `tokens`
822     // from the token owner's account. The `spender` contract function
823     // `receiveApproval(...)` is then executed
824     // ------------------------------------------------------------------------
825     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
826         require(frozen == false); 
827         require(bitmask_check(msg.sender, 1024) == false); // banned == false
828         allowed[msg.sender][spender] = tokens;
829         emit Approval(msg.sender, spender, tokens);
830         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
831         return true;
832     }
833     // ------------------------------------------------------------------------
834     // Don't accept ETH https://github.com/ConsenSys/Ethereum-Development-Best-Practices/wiki/Fallback-functions-and-the-fundamental-limitations-of-using-send()-in-Ethereum-&-Solidity
835     // ------------------------------------------------------------------------
836     function () public payable {
837         revert();
838     } // OR function() payable { } to accept ETH 
839 
840     // ------------------------------------------------------------------------
841     // Owner can transfer out any accidentally sent ERC20 tokens
842     // ------------------------------------------------------------------------
843     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
844         require(frozen == false); 
845         return ERC20Interface(tokenAddress).transfer(owner, tokens);
846     }
847 
848 
849 
850 
851 } // © Musqogees Tech 2018, Redenom ™