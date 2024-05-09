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
136         uint lastVotedEpoch; // Last epoch user voted
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
151     event VotingOn(address indexed initiator);
152     event VotingOff(address indexed initiator);
153     event Vote(address indexed voter, uint indexed propId, uint voterBalance, uint indexed voteEpoch);
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
186         delete projects;
187 
188         emit Epoch(epoch);
189         return true;
190     }
191 
192 
193 
194 
195     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
196 
197     //Is voting active?
198     bool public votingActive = false;
199 
200     // Voter requirements:
201     modifier onlyVoter {
202         require(votingActive == true);
203         require(bitmask_check(msg.sender, 4) == true); //passed KYC
204         //require((accounts[msg.sender].balance >= 100000000), "must have >= 1 NOM");
205         require((accounts[msg.sender].lastVotedEpoch < epoch));
206         require(bitmask_check(msg.sender, 1024) == false); // banned == false
207         _;
208     }
209 
210     // This is a type for a single Project.
211     struct Project {
212         uint id;   // Project id
213         uint votesWeight; // total weight
214         bool active; //active status.
215     }
216 
217     // A dynamically-sized array of `Project` structs.
218     Project[] public projects;
219 
220     // Add prop. with id: _id
221     function addProject(uint _id) public onlyAdmin {
222         projects.push(Project({
223             id: _id,
224             votesWeight: 0,
225             active: true
226         }));
227     }
228 
229     // Turns project ON and OFF
230     function swapProject(uint _id) public onlyAdmin {
231         for (uint p = 0; p < projects.length; p++){
232             if(projects[p].id == _id){
233                 if(projects[p].active == true){
234                     projects[p].active = false;
235                 }else{
236                     projects[p].active = true;
237                 }
238             }
239         }
240     }
241 
242     // Returns proj. weight
243     function projectWeight(uint _id) public constant returns(uint PW){
244         for (uint p = 0; p < projects.length; p++){
245             if(projects[p].id == _id){
246                 return projects[p].votesWeight;
247             }
248         }
249     }
250 
251     // Returns proj. status
252     function projectActive(uint _id) public constant returns(bool PA){
253         for (uint p = 0; p < projects.length; p++){
254             if(projects[p].id == _id){
255                 return projects[p].active;
256             }
257         }
258     }
259 
260     // Vote for proj. using id: _id
261     function vote(uint _id) public onlyVoter returns(bool success){
262         require(frozen == false);
263 
264         //todo updateAccount
265         for (uint p = 0; p < projects.length; p++){
266             if(projects[p].id == _id && projects[p].active == true){
267                 projects[p].votesWeight += sqrt(accounts[msg.sender].balance);
268                 accounts[msg.sender].lastVotedEpoch = epoch;
269             }
270         }
271         emit Vote(msg.sender, _id, accounts[msg.sender].balance, epoch);
272 
273         return true;
274     }
275 
276     // Shows currently winning proj 
277     function winningProject() public constant returns (uint _winningProject){
278         uint winningVoteWeight = 0;
279         for (uint p = 0; p < projects.length; p++) {
280             if (projects[p].votesWeight > winningVoteWeight && projects[p].active == true) {
281                 winningVoteWeight = projects[p].votesWeight;
282                 _winningProject = projects[p].id;
283             }
284         }
285     }
286 
287     // Activates voting
288     // requires round = 9
289     function enableVoting() public onlyAdmin returns(bool succ){ 
290         require(votingActive == false);
291         require(frozen == false);
292         require(round == 9);
293 
294         votingActive = true;
295         emit VotingOn(msg.sender);
296         return true;
297 
298     }
299 
300     // Deactivates voting
301     function disableVoting() public onlyAdmin returns(bool succ){
302         require(votingActive == true);
303         require(frozen == false);
304         votingActive = false;
305 
306         emit VotingOff(msg.sender);
307         return true;
308     }
309 
310     // sqrt root func
311     function sqrt(uint x) internal pure returns (uint y) {
312         uint z = (x + 1) / 2;
313         y = x;
314         while (z < y) {
315             y = z;
316             z = (x / z + z) / 2;
317         }
318     }
319 
320     ///////////////////////////////////////////B A L L O T////////////////////////////////////////////
321 
322 
323 
324 
325     ///////////////////////////////////////////////////////////////////////////////////////////////////////
326     // NOM token emission functions
327     ///////////////////////////////////////////////////////////////////////////////////////////////////////
328 
329     // Pays 1.00000000 from epoch_fund to KYC-passed user
330     // Uses payout(), bitmask_check(), bitmask_add()
331     // adds 4 to bitmask
332     function pay1(address to) public onlyAdmin returns(bool success){
333         require(bitmask_check(to, 4) == false);
334         uint new_amount = 100000000;
335         payout(to,new_amount);
336         bitmask_add(to, 4);
337         return true;
338     }
339 
340     // Pays .555666XX from epoch_fund to user approved phone;
341     // Uses payout(), bitmask_check(), bitmask_add()
342     // adds 2 to bitmask
343     function pay055(address to) public onlyAdmin returns(bool success){
344         require(bitmask_check(to, 2) == false);
345         uint new_amount = 55566600 + (block.timestamp%100);       
346         payout(to,new_amount);
347         bitmask_add(to, 2);
348         return true;
349     }
350 
351     // Pays .555666XX from epoch_fund to KYC user in new epoch;
352     // Uses payout(), bitmask_check(), bitmask_add()
353     // adds 2 to bitmask
354     function pay055loyal(address to) public onlyAdmin returns(bool success){
355         require(epoch > 1);
356         require(bitmask_check(to, 4) == true);
357         uint new_amount = 55566600 + (block.timestamp%100);       
358         payout(to,new_amount);
359         return true;
360     }
361 
362     // Pays random number from epoch_fund
363     // Uses payout()
364     function payCustom(address to, uint amount) public onlyOwner returns(bool success){
365         payout(to,amount);
366         return true;
367     }
368 
369     // Pays [amount] of money to [to] account from epoch_fund
370     // Counts amount +30% +10%
371     // Updating _totalSupply
372     // Pays to balance and 2 funds
373     // Refreshes dec[]
374     // Emits event
375     function payout(address to, uint amount) private returns (bool success){
376         require(to != address(0));
377         require(amount>=current_mul());
378         require(bitmask_check(to, 1024) == false); // banned == false
379         require(frozen == false); 
380         
381         //Update account balance
382         updateAccount(to);
383         //fix amount
384         uint fixedAmount = fix_amount(amount);
385 
386         renewDec( accounts[to].balance, accounts[to].balance.add(fixedAmount) );
387 
388         uint team_part = (fixedAmount/100)*10;
389         uint dao_part = (fixedAmount/100)*30;
390         uint total = fixedAmount.add(team_part).add(dao_part);
391 
392         epoch_fund = epoch_fund.sub(total);
393         team_fund = team_fund.add(team_part);
394         redenom_dao_fund = redenom_dao_fund.add(dao_part);
395         accounts[to].balance = accounts[to].balance.add(fixedAmount);
396         _totalSupply = _totalSupply.add(total);
397 
398         emit Transfer(address(0), to, fixedAmount);
399         return true;
400     }
401     ///////////////////////////////////////////////////////////////////////////////////////////////////////
402 
403 
404 
405 
406     ///////////////////////////////////////////////////////////////////////////////////////////////////////
407 
408     // Withdraw amount from team_fund to given address
409     function withdraw_team_fund(address to, uint amount) public onlyOwner returns(bool success){
410         require(amount <= team_fund);
411         accounts[to].balance = accounts[to].balance.add(amount);
412         team_fund = team_fund.sub(amount);
413         return true;
414     }
415     // Withdraw amount from redenom_dao_fund to given address
416     function withdraw_dao_fund(address to, uint amount) public onlyOwner returns(bool success){
417         require(amount <= redenom_dao_fund);
418         accounts[to].balance = accounts[to].balance.add(amount);
419         redenom_dao_fund = redenom_dao_fund.sub(amount);
420         return true;
421     }
422 
423     function freeze_contract() public onlyOwner returns(bool success){
424         require(frozen == false);
425         frozen = true;
426         return true;
427     }
428     function unfreeze_contract() public onlyOwner returns(bool success){
429         require(frozen == true);
430         frozen = false;
431         return true;
432     }
433     ///////////////////////////////////////////////////////////////////////////////////////////////////////
434 
435 
436     // Run this on every change of user balance
437     // Refreshes dec[] array
438     // Takes initial and new ammount
439     // while transaction must be called for each acc.
440     function renewDec(uint initSum, uint newSum) internal returns(bool success){
441 
442         if(round < 9){
443             uint tempInitSum = initSum; 
444             uint tempNewSum = newSum; 
445             uint cnt = 1;
446 
447             while( (tempNewSum > 0 || tempInitSum > 0) && cnt <= decimals ){
448 
449                 uint lastInitSum = tempInitSum%10; // 0.0000000 (0)
450                 tempInitSum = tempInitSum/10; // (0.0000000) 0
451 
452                 uint lastNewSum = tempNewSum%10; // 1.5556664 (5)
453                 tempNewSum = tempNewSum/10; // (1.5556664) 5
454 
455                 if(cnt >= round){
456                     if(lastNewSum >= lastInitSum){
457                         // If new is bigger
458                         dec[decimals-cnt] = dec[decimals-cnt].add(lastNewSum - lastInitSum);
459                     }else{
460                         // If new is smaller
461                         dec[decimals-cnt] = dec[decimals-cnt].sub(lastInitSum - lastNewSum);
462                     }
463                 }
464 
465                 cnt = cnt+1;
466             }
467         }//if(round < 9){
468 
469         return true;
470     }
471 
472 
473 
474     ////////////////////////////////////////// BITMASK /////////////////////////////////////////////////////
475     // Adding bit to bitmask
476     // checks if already set
477     function bitmask_add(address user, uint _bit) internal returns(bool success){ //todo privat?
478         require(bitmask_check(user, _bit) == false);
479         accounts[user].bitmask = accounts[user].bitmask.add(_bit);
480         return true;
481     }
482     // Removes bit from bitmask
483     // checks if already set
484     function bitmask_rm(address user, uint _bit) internal returns(bool success){
485         require(bitmask_check(user, _bit) == true);
486         accounts[user].bitmask = accounts[user].bitmask.sub(_bit);
487         return true;
488     }
489     // Checks whether some bit is present in BM
490     function bitmask_check(address user, uint _bit) internal view returns (bool status){
491         bool flag;
492         accounts[user].bitmask & _bit == 0 ? flag = false : flag = true;
493         return flag;
494     }
495     ///////////////////////////////////////////////////////////////////////////////////////////////////////
496 
497     function ban_user(address user) public onlyAdmin returns(bool success){
498         bitmask_add(user, 1024);
499         return true;
500     }
501     function unban_user(address user) public onlyAdmin returns(bool success){
502         bitmask_rm(user, 1024);
503         return true;
504     }
505     function is_banned(address user) public view onlyAdmin returns (bool result){
506         return bitmask_check(user, 1024);
507     }
508     ///////////////////////////////////////////////////////////////////////////////////////////////////////
509 
510 
511 
512     //Redenominates 
513     function redenominate() public onlyAdmin returns(uint current_round){
514         require(frozen == false); 
515         require(round<9); // Round must be < 9
516 
517         // Deleting funds rest from TS
518         _totalSupply = _totalSupply.sub( team_fund%mul[round] ).sub( redenom_dao_fund%mul[round] ).sub( dec[8-round]*mul[round-1] );
519 
520         // Redenominating 3 vars: _totalSupply team_fund redenom_dao_fund
521         _totalSupply = ( _totalSupply / mul[round] ) * mul[round];
522         team_fund = ( team_fund / mul[round] ) * mul[round]; // Redenominates team_fund
523         redenom_dao_fund = ( redenom_dao_fund / mul[round] ) * mul[round]; // Redenominates redenom_dao_fund
524 
525         if(round>1){
526             // decimals burned in last round and not distributed
527             uint superold = dec[(8-round)+1]; 
528 
529             // Returning them to epoch_fund
530             epoch_fund = epoch_fund.add(superold * mul[round-2]);
531             dec[(8-round)+1] = 0;
532         }
533 
534         
535         if(round<8){ // if round between 1 and 7 
536 
537             uint unclimed = dec[8-round]; // total sum of burned decimal
538             //[23,32,43,34,34,54,34, ->46<- ]
539             uint total_current = dec[8-1-round]; // total sum of last active decimal
540             //[23,32,43,34,34,54, ->34<-, 46]
541 
542             // security check
543             if(total_current==0){
544                 current_toadd = [0,0,0,0,0,0,0,0,0]; 
545                 round++;
546                 return round;
547             }
548 
549             // Counting amounts to add on every digit
550             uint[9] memory numbers  =[uint(1),2,3,4,5,6,7,8,9]; // 
551             uint[9] memory ke9  =[uint(0),0,0,0,0,0,0,0,0]; // 
552             uint[9] memory k2e9  =[uint(0),0,0,0,0,0,0,0,0]; // 
553 
554             uint k05summ = 0;
555 
556                 for (uint k = 0; k < ke9.length; k++) {
557                      
558                     ke9[k] = numbers[k]*1e9/total_current;
559                     if(k<5) k05summ += ke9[k];
560                 }             
561                 for (uint k2 = 5; k2 < k2e9.length; k2++) {
562                     k2e9[k2] = uint(ke9[k2])+uint(k05summ)*uint(weight[k2])/uint(100);
563                 }
564                 for (uint n = 5; n < current_toadd.length; n++) {
565                     current_toadd[n] = k2e9[n]*unclimed/10/1e9;
566                 }
567                 // current_toadd now contains all digits
568                 
569         }else{
570             if(round==8){
571                 // Returns last burned decimals to epoch_fund
572                 epoch_fund = epoch_fund.add(dec[0] * 10000000); //1e7
573                 dec[0] = 0;
574             }
575             
576         }
577 
578         round++;
579         emit Redenomination(round);
580         return round;
581     }
582 
583    
584     // Refresh user acc
585     // Pays dividends if any
586     function updateAccount(address account) public returns(uint new_balance){
587         require(frozen == false); 
588         require(round<=9);
589         require(bitmask_check(account, 1024) == false); // banned == false
590 
591         if(round > accounts[account].lastRound){
592 
593             if(round >1 && round <=8){
594 
595 
596                 // Splits user bal by current multiplier
597                 uint tempDividedBalance = accounts[account].balance/current_mul();
598                 // [1.5556663] 4  (r2)
599                 uint newFixedBalance = tempDividedBalance*current_mul();
600                 // [1.55566630]  (r2)
601                 uint lastActiveDigit = tempDividedBalance%10;
602                  // 1.555666 [3] 4  (r2)
603                 uint diff = accounts[account].balance - newFixedBalance;
604                 // 1.5556663 [4] (r2)
605 
606                 if(diff > 0){
607                     accounts[account].balance = newFixedBalance;
608                     emit Transfer(account, address(0), diff);
609                 }
610 
611                 uint toBalance = 0;
612                 if(lastActiveDigit>0 && current_toadd[lastActiveDigit-1]>0){
613                     toBalance = current_toadd[lastActiveDigit-1] * current_mul();
614                 }
615 
616 
617                 if(toBalance > 0 && toBalance < dec[8-round+1]){ // Not enough
618 
619                     renewDec( accounts[account].balance, accounts[account].balance.add(toBalance) );
620                     emit Transfer(address(0), account, toBalance);
621                     // Refreshing dec arr
622                     accounts[account].balance = accounts[account].balance.add(toBalance);
623                     // Adding to ball
624                     dec[8-round+1] = dec[8-round+1].sub(toBalance);
625                     // Taking from burned decimal
626                     _totalSupply = _totalSupply.add(toBalance);
627                     // Add dividend to _totalSupply
628                 }
629 
630                 accounts[account].lastRound = round;
631                 // Writting last round in wich user got dividends
632                 return accounts[account].balance;
633                 // returns new balance
634             }else{
635                 if( round == 9){ //100000000 = 9 mul (mul8)
636 
637                     uint newBalance = fix_amount(accounts[account].balance);
638                     uint _diff = accounts[account].balance.sub(newBalance);
639 
640                     if(_diff > 0){
641                         renewDec( accounts[account].balance, newBalance );
642                         accounts[account].balance = newBalance;
643                         emit Transfer(account, address(0), _diff);
644                     }
645 
646                     accounts[account].lastRound = round;
647                     // Writting last round in wich user got dividends
648                     return accounts[account].balance;
649                     // returns new balance
650                 }
651             }
652         }
653     }
654 
655     // Returns current multipl. based on round
656     // Returns current multiplier based on round
657     function current_mul() internal view returns(uint _current_mul){
658         return mul[round-1];
659     }
660     // Removes burned values 123 -> 120  
661     // Returns fixed
662     function fix_amount(uint amount) public view returns(uint fixed_amount){
663         return ( amount / current_mul() ) * current_mul();
664     }
665     // Returns rest
666     function get_rest(uint amount) internal view returns(uint fixed_amount){
667         return amount % current_mul();
668     }
669 
670 
671 
672     // ------------------------------------------------------------------------
673     // ERC20 totalSupply: 
674     //-------------------------------------------------------------------------
675     function totalSupply() public view returns (uint) {
676         return _totalSupply;
677     }
678     // ------------------------------------------------------------------------
679     // ERC20 balanceOf: Get the token balance for account `tokenOwner`
680     // ------------------------------------------------------------------------
681     function balanceOf(address tokenOwner) public constant returns (uint balance) {
682         return accounts[tokenOwner].balance;
683     }
684     // ------------------------------------------------------------------------
685     // ERC20 allowance:
686     // Returns the amount of tokens approved by the owner that can be
687     // transferred to the spender's account
688     // ------------------------------------------------------------------------
689     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
690         return allowed[tokenOwner][spender];
691     }
692     // ------------------------------------------------------------------------
693     // ERC20 transfer:
694     // Transfer the balance from token owner's account to `to` account
695     // - Owner's account must have sufficient balance to transfer
696     // - 0 value transfers are allowed
697     // ------------------------------------------------------------------------
698     function transfer(address to, uint tokens) public returns (bool success) {
699         require(frozen == false); 
700         require(to != address(0));
701         require(bitmask_check(to, 1024) == false); // banned == false
702 
703         //Fixing amount, deleting burned decimals
704         tokens = fix_amount(tokens);
705         // Checking if greater then 0
706         require(tokens>0);
707 
708         //Refreshing accs, payng dividends
709         updateAccount(to);
710         updateAccount(msg.sender);
711 
712         uint fromOldBal = accounts[msg.sender].balance;
713         uint toOldBal = accounts[to].balance;
714 
715         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(tokens);
716         accounts[to].balance = accounts[to].balance.add(tokens);
717 
718         require(renewDec(fromOldBal, accounts[msg.sender].balance));
719         require(renewDec(toOldBal, accounts[to].balance));
720 
721         emit Transfer(msg.sender, to, tokens);
722         return true;
723     }
724 
725 
726     // ------------------------------------------------------------------------
727     // ERC20 approve:
728     // Token owner can approve for `spender` to transferFrom(...) `tokens`
729     // from the token owner's account
730     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
731     // recommends that there are no checks for the approval double-spend attack
732     // as this should be implemented in user interfaces 
733     // ------------------------------------------------------------------------
734     function approve(address spender, uint tokens) public returns (bool success) {
735         require(frozen == false); 
736         require(bitmask_check(msg.sender, 1024) == false); // banned == false
737         allowed[msg.sender][spender] = tokens;
738         emit Approval(msg.sender, spender, tokens);
739         return true;
740     }
741     // ------------------------------------------------------------------------
742     // ERC20 transferFrom:
743     // Transfer `tokens` from the `from` account to the `to` account
744     // The calling account must already have sufficient tokens approve(...)-d
745     // for spending from the `from` account and
746     // - From account must have sufficient balance to transfer
747     // - Spender must have sufficient allowance to transfer
748     // - 0 value transfers are allowed
749     // ------------------------------------------------------------------------
750     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
751         require(frozen == false); 
752         require(bitmask_check(to, 1024) == false); // banned == false
753         updateAccount(from);
754         updateAccount(to);
755 
756         uint fromOldBal = accounts[from].balance;
757         uint toOldBal = accounts[to].balance;
758 
759         accounts[from].balance = accounts[from].balance.sub(tokens);
760         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
761         accounts[to].balance = accounts[to].balance.add(tokens);
762 
763         require(renewDec(fromOldBal, accounts[from].balance));
764         require(renewDec(toOldBal, accounts[to].balance));
765 
766         emit Transfer(from, to, tokens);
767         return true; 
768     }
769     // ------------------------------------------------------------------------
770     // Token owner can approve for `spender` to transferFrom(...) `tokens`
771     // from the token owner's account. The `spender` contract function
772     // `receiveApproval(...)` is then executed
773     // ------------------------------------------------------------------------
774     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
775         require(frozen == false); 
776         require(bitmask_check(msg.sender, 1024) == false); // banned == false
777         allowed[msg.sender][spender] = tokens;
778         emit Approval(msg.sender, spender, tokens);
779         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
780         return true;
781     }
782     // ------------------------------------------------------------------------
783     // Don't accept ETH https://github.com/ConsenSys/Ethereum-Development-Best-Practices/wiki/Fallback-functions-and-the-fundamental-limitations-of-using-send()-in-Ethereum-&-Solidity
784     // ------------------------------------------------------------------------
785     function () public payable {
786         revert();
787     } // OR function() payable { } to accept ETH 
788 
789     // ------------------------------------------------------------------------
790     // Owner can transfer out any accidentally sent ERC20 tokens
791     // ------------------------------------------------------------------------
792     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
793         require(frozen == false); 
794         return ERC20Interface(tokenAddress).transfer(owner, tokens);
795     }
796 
797 
798 
799 
800 } // © Musqogees Tech 2018, Redenom ™