1 // SPDX-License-Identifier: MIT License
2 pragma solidity 0.8.4;
3 
4 interface IERC20 {    
5 	function totalSupply() external view returns (uint256);
6 	function decimals() external view returns (uint8);
7 	function symbol() external view returns (string memory);
8 	function name() external view returns (string memory);
9 	function getOwner() external view returns (address);
10 	function balanceOf(address account) external view returns (uint256);
11 	function transfer(address recipient, uint256 amount) external returns (bool);
12 	function allowance(address _owner, address spender) external view returns (uint256);
13 	function approve(address spender, uint256 amount) external returns (bool);
14 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library Address {
20     function isContract(address account) internal view returns (bool) {
21         uint256 size;
22         assembly {
23             size := extcodesize(account)
24         }
25         return size > 0;
26     }
27     
28     function sendValue(address payable recipient, uint256 amount) internal {
29         require(address(this).balance >= amount, "Address: insufficient balance");
30         (bool success, ) = recipient.call{value: amount}("");
31         require(success, "Address: unable to send value, recipient may have reverted");
32     }
33     
34     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
35         return functionCall(target, data, "Address: low-level call failed");
36     }
37     
38     function functionCall(
39         address target,
40         bytes memory data,
41         string memory errorMessage
42     ) internal returns (bytes memory) {
43         return functionCallWithValue(target, data, 0, errorMessage);
44     }
45     
46     function functionCallWithValue(
47         address target,
48         bytes memory data,
49         uint256 value
50     ) internal returns (bytes memory) {
51         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
52     }
53     
54     function functionCallWithValue(
55         address target,
56         bytes memory data,
57         uint256 value,
58         string memory errorMessage
59     ) internal returns (bytes memory) {
60         require(address(this).balance >= value, "Address: insufficient balance for call");
61         require(isContract(target), "Address: call to non-contract");
62 
63         (bool success, bytes memory returndata) = target.call{value: value}(data);
64         return verifyCallResult(success, returndata, errorMessage);
65     }
66     
67     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
68         return functionStaticCall(target, data, "Address: low-level static call failed");
69     }
70     
71     function functionStaticCall(
72         address target,
73         bytes memory data,
74         string memory errorMessage
75     ) internal view returns (bytes memory) {
76         require(isContract(target), "Address: static call to non-contract");
77 
78         (bool success, bytes memory returndata) = target.staticcall(data);
79         return verifyCallResult(success, returndata, errorMessage);
80     }
81     
82     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
84     }
85     
86     function functionDelegateCall(
87         address target,
88         bytes memory data,
89         string memory errorMessage
90     ) internal returns (bytes memory) {
91         require(isContract(target), "Address: delegate call to non-contract");
92 
93         (bool success, bytes memory returndata) = target.delegatecall(data);
94         return verifyCallResult(success, returndata, errorMessage);
95     }
96     
97     function verifyCallResult(
98         bool success,
99         bytes memory returndata,
100         string memory errorMessage
101     ) internal pure returns (bytes memory) {
102         if (success) {
103             return returndata;
104         } else {
105             
106             if (returndata.length > 0) {
107                 
108 
109                 assembly {
110                     let returndata_size := mload(returndata)
111                     revert(add(32, returndata), returndata_size)
112                 }
113             } else {
114                 revert(errorMessage);
115             }
116         }
117     }
118 }
119 
120 library SafeERC20 {
121     using Address for address;
122 
123     function safeTransfer(
124         IERC20 token,
125         address to,
126         uint256 value
127     ) internal {
128         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
129     }
130 
131     function safeTransferFrom(
132         IERC20 token,
133         address from,
134         address to,
135         uint256 value
136     ) internal {
137         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
138     }
139     
140     function safeApprove(
141         IERC20 token,
142         address spender,
143         uint256 value
144     ) internal {
145         
146         require(
147             (value == 0) || (token.allowance(address(this), spender) == 0),
148             "SafeERC20: approve from non-zero to non-zero allowance"
149         );
150         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
151     }
152 
153     function safeIncreaseAllowance(
154         IERC20 token,
155         address spender,
156         uint256 value
157     ) internal {
158         uint256 newAllowance = token.allowance(address(this), spender) + value;
159         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
160     }
161 
162     function safeDecreaseAllowance(
163         IERC20 token,
164         address spender,
165         uint256 value
166     ) internal {
167         unchecked {
168             uint256 oldAllowance = token.allowance(address(this), spender);
169             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
170             uint256 newAllowance = oldAllowance - value;
171             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
172         }
173     }
174     
175     function _callOptionalReturn(IERC20 token, bytes memory data) private {
176         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
177         if (returndata.length > 0) {
178             
179             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
180         }
181     }
182 }
183 
184 
185 abstract contract Context {
186     function _msgSender() internal view virtual returns (address) {
187         return msg.sender;
188     }
189 
190     function _msgData() internal view virtual returns (bytes calldata) {
191         return msg.data;
192     }
193 }
194 
195 contract Ownable is Context {
196     address private _owner;
197 
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200     /**
201     * @dev Initializes the contract setting the deployer as the initial owner.
202     */
203     constructor () {
204       address msgSender = _msgSender();
205       _owner = msgSender;
206       emit OwnershipTransferred(address(0), msgSender);
207     }
208 
209     /**
210     * @dev Returns the address of the current owner.
211     */
212     function owner() public view returns (address) {
213       return _owner;
214     }
215     
216     modifier onlyOwner() {
217       require(_owner == _msgSender(), "Ownable: caller is not the owner");
218       _;
219     }
220 
221     function renounceOwnership() public onlyOwner {
222       emit OwnershipTransferred(_owner, address(0));
223       _owner = address(0);
224     }
225 
226     function transferOwnership(address newOwner) public onlyOwner {
227       _transferOwnership(newOwner);
228     }
229 
230     function _transferOwnership(address newOwner) internal {
231       require(newOwner != address(0), "Ownable: new owner is the zero address");
232       emit OwnershipTransferred(_owner, newOwner);
233       _owner = newOwner;
234     }
235 }
236 
237 library SafeMath {
238     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         unchecked {
240             uint256 c = a + b;
241             if (c < a) return (false, 0);
242             return (true, c);
243         }
244     }
245 
246     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
247         unchecked {
248             if (b > a) return (false, 0);
249             return (true, a - b);
250         }
251     }
252 
253     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
256             // benefit is lost if 'b' is also tested.
257             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
258             if (a == 0) return (true, 0);
259             uint256 c = a * b;
260             if (c / a != b) return (false, 0);
261             return (true, c);
262         }
263     }
264 
265     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (b == 0) return (false, 0);
268             return (true, a / b);
269         }
270     }
271 
272     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             if (b == 0) return (false, 0);
275             return (true, a % b);
276         }
277     }
278 
279     function add(uint256 a, uint256 b) internal pure returns (uint256) {
280         return a + b;
281     }
282 
283     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284         return a - b;
285     }
286 
287     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a * b;
289     }
290 
291     function div(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a / b;
293     }
294 
295     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a % b;
297     }
298 
299     function sub(
300         uint256 a,
301         uint256 b,
302         string memory errorMessage
303     ) internal pure returns (uint256) {
304         unchecked {
305             require(b <= a, errorMessage);
306             return a - b;
307         }
308     }
309 
310     function div(
311         uint256 a,
312         uint256 b,
313         string memory errorMessage
314     ) internal pure returns (uint256) {
315         unchecked {
316             require(b > 0, errorMessage);
317             return a / b;
318         }
319     }
320 
321     function mod(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         unchecked {
327             require(b > 0, errorMessage);
328             return a % b;
329         }
330     }
331 }
332 
333 contract RelyFund is Context, Ownable {
334     using SafeMath for uint256;
335 	using SafeERC20 for IERC20;
336 
337     IERC20 public USD;
338     address public paymentTokenAddress;
339 
340     event _Deposit(address indexed addr, uint256 amount, uint40 tm);
341     event _Payout(address indexed addr, uint256 amount);
342     event _Refund(address indexed addr, uint256 amount);
343 	event ReinvestMade(address indexed addr, uint256 amount, uint40 tm);
344 		
345 	address payable public team;
346     address payable public dev;   
347    
348     uint8 public isScheduled = 1;
349     uint256 private constant DAY = 24 hours;
350     uint256 private numDays = 7;    
351 	
352 	uint16 constant PERCENT_DIVIDER = 1000; 
353 
354     uint256 public invested;
355     uint256 public reinvested;
356     uint256 public withdrawn;
357     uint256 public ref_bonus;
358 	uint256 public refunds;
359 
360     uint256 public launchTime;
361 	uint256 public sTime;
362 
363     struct Tarif {
364         uint256 life_days;
365         uint256 percent;
366     }
367 
368     struct Depo {
369         uint256 tarif;
370         uint256 amount;
371         uint40 time;
372         uint256 depositTime;
373         uint256 multiple;
374     }
375 
376     struct Downline {
377         uint8 level;    
378         address invite;
379     }
380 
381     struct Player {
382         string email;
383         string lastname;
384         string firstname;
385         string password;
386 
387         address upline;
388         uint256 dividends;
389                 
390         uint256 total_invested;
391         uint256 total_withdrawn;
392         uint256 total_ref_bonus;
393         uint256 total_reinvested;
394 		uint256 total_refunded;
395 		
396         uint40 lastWithdrawn;
397         Depo[] deposits;
398         Downline[] downlines1;
399         uint256[1] structure; 
400     }
401 
402     mapping(address => Player) public players;
403     mapping(address => uint8) public banned;
404     mapping(uint256 => Tarif) public tarifs;
405     // white list wallets
406     mapping(address => uint8) public whitelistWallets;
407 
408     uint public nextMemberNo;
409     uint public decimals;
410 
411     constructor(address _token) {         
412 		dev = payable(msg.sender);		
413 	    team = payable(msg.sender);		
414         
415         tarifs[0] = Tarif(36135, 72270);
416         
417         paymentTokenAddress = _token;
418 		USD = IERC20(paymentTokenAddress);
419         decimals = IERC20(paymentTokenAddress).decimals();
420         launchTime = 0;
421     }
422 
423     function launch() public onlyOwner() {
424         require(launchTime == 0,"invalid state!");
425         launchTime = block.timestamp;
426     }
427    
428     function deposit(address _upline, uint256 amount) external {
429         require(launchTime > 0,"not started!");
430         require(amount >= 100 * (10**decimals), "Minimum Deposit is 100 USDT!");
431         require(invested < 20000000 * (10**decimals) ,"Funds reach target!");
432         USD.safeTransferFrom(msg.sender, address(this), amount);
433     
434         setRefrellink(msg.sender, _upline);
435         if(invested + amount > 500000 * (10**decimals)){
436             sTime = block.timestamp;
437         }
438         Player storage player = players[msg.sender];
439         uint256 multiple = 0;
440         if(whitelistWallets[msg.sender] == 1){
441             whitelistWallets[msg.sender] = 0;
442             multiple = 2;
443         }else{
444              if(invested < 200000 * (10**decimals)){
445                 multiple = 2;
446             }else if(invested < 500000 * (10**decimals)){
447                 multiple = 1;
448             }
449         }
450        
451 
452         player.deposits.push(Depo({
453             tarif: 0,
454             amount: amount,
455             time: uint40(block.timestamp),
456             depositTime: block.timestamp,
457             multiple: multiple
458         }));  
459         emit _Deposit(msg.sender, amount, uint40(block.timestamp));
460 		
461 		uint256 teamFee = SafeMath.div(amount,100); 
462 		USD.safeTransfer(dev, teamFee/2);
463 		USD.safeTransfer(team, teamFee/2);
464 
465         player.total_invested += amount;
466         
467         invested += amount;
468         withdrawn += teamFee;
469         commissionPayouts(msg.sender, amount);
470     }
471 
472     function redeposit() external {   
473 		require(banned[msg.sender] == 0,'Banned Wallet!');
474         Player storage player = players[msg.sender];
475 
476         updateUserState(msg.sender);
477 
478         require(player.dividends >= 50 * (10**decimals), "Minimum reinvest is 50 USDT.");
479 
480         uint256 amount =  player.dividends;
481         player.dividends = 0;
482 		
483         player.total_withdrawn += amount;
484         withdrawn += amount; 
485 		
486         player.deposits.push(Depo({
487             tarif: 0,
488             amount: amount,
489             time: uint40(block.timestamp),
490             depositTime: 0,
491             multiple: 0
492         }));  
493         emit ReinvestMade(msg.sender, amount, uint40(block.timestamp));
494 
495         player.total_invested += amount;
496         player.total_reinvested += amount;
497         
498         invested += amount;
499 		reinvested += amount;    	
500     }
501 	
502     function claim() external {      
503         require(banned[msg.sender] == 0,'Banned Wallet!');
504         Player storage player = players[msg.sender];
505 
506         if(isScheduled == 1) {
507             require (block.timestamp >= (player.lastWithdrawn + (DAY * numDays)), "Not due yet for next payout!");
508         }     
509 
510         updateUserState(msg.sender);
511 
512         require(player.dividends >= 50 * (10**decimals), "Minimum payout is 50 USDT.");
513 
514         uint256 amount =  player.dividends;
515         player.dividends = 0;
516         
517         player.total_withdrawn += amount;
518         
519 		USD.safeTransfer(msg.sender, amount);
520 		emit _Payout(msg.sender, amount);
521 		
522 		uint256 teamFee = SafeMath.div(amount,100);
523 		USD.safeTransfer(team, teamFee/2);
524         USD.safeTransfer(dev, teamFee/2);
525         
526 		withdrawn += amount + teamFee;    
527     }
528 	
529 
530     function pendingReward(address _addr) view external returns(uint256 value) {
531 		if(banned[_addr] == 1){ return 0; }
532         Player storage player = players[_addr];
533 
534         for(uint256 i = 0; i < player.deposits.length; i++) {
535             Depo storage dep = player.deposits[i];
536             Tarif storage tarif = tarifs[dep.tarif];
537 
538             uint256 time_end = dep.time + tarif.life_days * 86400;
539             uint40 from = player.lastWithdrawn > dep.time ? player.lastWithdrawn : dep.time;
540             uint256 to = block.timestamp > time_end ? time_end : block.timestamp;
541 
542             uint256 multiple = 0;
543             if(from < dep.time + 30 days){
544                 multiple = dep.multiple;
545             }
546 
547             if(from < to) {
548                 value = value + dep.amount * (to - from)  * multiple / PERCENT_DIVIDER / 86400 + dep.amount * (to - from) * tarif.percent / tarif.life_days / 8640000 ;
549             }
550         }
551         return value;
552     }
553 
554  
555     function updateUserState(address _addr) private {
556         uint256 payout = this.pendingReward(_addr);
557 
558         if(payout > 0) {            
559             players[_addr].lastWithdrawn = uint40(block.timestamp);
560             players[_addr].dividends += payout;
561         }
562     }      
563 
564 
565     function setRefrellink(address _addr, address _upline) private {
566         if(players[_addr].upline == address(0) && _addr != owner()) {     
567             
568             if(players[_upline].total_invested <= 0) {
569                 _upline = owner();
570             }
571             
572             players[_addr].upline = _upline;
573             players[_upline].structure[0]++;
574 
575             Player storage up = players[_upline];
576             up.downlines1.push(Downline({
577                 level: 1,
578                 invite: _addr
579             }));  
580         }
581     }   
582     
583         
584     function commissionPayouts(address _addr, uint256 _amount) private {
585         address up = players[_addr].upline;
586 
587         if(up == address(0)) return;
588         if(banned[up] == 0)
589 		{   
590             uint256 ref_bonuses = 50;
591             if(block.timestamp > launchTime + 30 days){
592                 ref_bonuses = 20;
593             }
594 
595 			uint256 bonus = _amount * ref_bonuses / PERCENT_DIVIDER;
596 		    
597 			USD.safeTransfer(up, bonus);
598 			
599 			players[up].total_ref_bonus += bonus;
600 			players[up].total_withdrawn += bonus;
601 
602 			ref_bonus += bonus;
603 			withdrawn += bonus;
604 		}    
605     }
606     
607     function relybot(uint256 amount) public onlyOwner returns (bool success) {
608 	    USD.safeTransfer(msg.sender, amount);
609 		withdrawn += amount;
610         return true;
611     }
612 	
613     function nextWithdraw(address _addr) view external returns(uint40 next_sked) {
614 		if(banned[_addr] == 1) { return 0; }
615         Player storage player = players[_addr];
616         if(player.deposits.length > 0)
617         {
618           return uint40(player.lastWithdrawn + (DAY * numDays));
619         }
620         return 0;
621     }
622 
623     function setPaymentToken(address newval) public onlyOwner returns (bool success) {
624         paymentTokenAddress = newval;
625         return true;
626     }    
627 
628     function getContractBalance() public view returns (uint256) {
629         return IERC20(paymentTokenAddress).balanceOf(address(this));
630     }
631 
632     function setProfile(string memory _email, string memory _lname, string memory _fname, string memory _password) public returns (bool success) {
633         players[msg.sender].email = _email;
634         players[msg.sender].lastname = _lname;
635         players[msg.sender].firstname = _fname;
636         players[msg.sender].password = _password;
637         return true;
638     }
639 
640     function setNewUpline(address member, address newSP) public onlyOwner returns(bool success)
641     {
642         players[member].upline = newSP;
643         return true;
644     }
645 
646     function setTeam(address payable newval) public onlyOwner returns (bool success) {
647         team = newval;
648         return true;
649     }    
650 	
651     function setDev(address payable newval) public onlyOwner returns (bool success) {
652         dev = newval;
653         return true;
654     }     
655    
656     function setScheduled(uint8 newval) public onlyOwner returns (bool success) {
657         isScheduled = newval;
658         return true;
659     }   
660    
661     function setDays(uint newval) public onlyOwner returns (bool success) {    
662         numDays = newval;
663         return true;
664     }    
665     
666 	function banWallet(address wallet) public onlyOwner returns (bool success) {
667         banned[wallet] = 1;
668         return true;
669     }
670 	
671 	function unbanWallet(address wallet) public onlyOwner returns (bool success) {
672         banned[wallet] = 0;
673         return true;
674     }
675 
676     function refundWallets(address[] memory wallets) public onlyOwner returns (bool success) {
677         for (uint256 i=0; i < wallets.length; i++) {
678             refundWallet(wallets[i]);
679         }
680         return true;
681     }
682 	
683 	function refundWallet(address wallet) internal returns (bool success) {
684 	       
685         if(banned[wallet] == 1){ return false; }
686         Player storage player = players[wallet]; 
687         if(player.total_invested == 0){
688             return false;
689         }
690         uint256 amount = 0;
691         for(uint256 i = 0; i < player.deposits.length; i++) {
692             Depo storage dep = player.deposits[i];
693             if(dep.depositTime > 0 && (block.timestamp >= dep.depositTime + (15 days))){
694                 amount += dep.amount;
695             }
696         }
697         if(amount == 0){
698             return false;
699         }
700 		player.total_refunded += amount;
701 		withdrawn += amount;
702 		refunds += amount;
703         USD.safeTransfer(wallet, amount);
704 		emit _Refund(wallet, amount);
705 		banned[wallet] = 1;
706         return true;
707     }
708 
709     // add wallets to white list
710     function addWhitelist(address[] calldata receivers) external onlyOwner {
711         for (uint256 i = 0; i < receivers.length; i++) {
712             whitelistWallets[receivers[i]] = 1;
713         }
714     }
715 
716     function userInfo(address _addr) view external returns(uint256 for_withdraw, 
717                                                             uint256 numDeposits,  
718                                                                 uint256 downlines1,
719 																    uint256[1] memory structure) {
720         Player storage player = players[_addr];
721 
722         uint256 payout = this.pendingReward(_addr);
723 
724         for(uint8 i = 0; i <1; i++) {
725             structure[i] = player.structure[i];
726         }
727 
728         return (
729             payout + player.dividends,
730             player.deposits.length,
731             player.downlines1.length,
732             structure
733         );
734     } 
735     
736     function memberDownline(address _addr, uint8 level, uint256 index) view external returns(address downline)
737     {
738         Player storage player = players[_addr];
739         Downline storage dl = player.downlines1[0];
740         if(level==1){
741             dl  = player.downlines1[index];
742         }
743         return(dl.invite);
744     }
745 
746     function memberDeposit(address _addr, uint256 index) view external returns(uint40 time, uint256 amount, uint256 lifedays, uint256 percent)
747     {
748         Player storage player = players[_addr];
749         Depo storage dep = player.deposits[index];
750         Tarif storage tarif = tarifs[dep.tarif];
751         return(dep.time, dep.amount, tarif.life_days, tarif.percent);
752     }
753 
754     function getBalance() public view returns(uint256) {
755         return address(this).balance;
756     }
757 
758     function getOwner() external view returns (address) {
759         return owner();
760     }
761 
762 }