1 pragma solidity ^0.5.16;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6           return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19     
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract LockIdGen {
33 
34     uint256 public requestCount;
35 
36     constructor() public {
37         requestCount = 0;
38     }
39 
40     function generateLockId() internal returns (bytes32 lockId) {
41         return keccak256(abi.encodePacked(blockhash(block.number-1), address(this), ++requestCount));
42     }
43 }
44 /**
45  * @dev Collection of functions related to the address type
46  */
47 library Address {
48     /**
49      * @dev Returns true if `account` is a contract.
50      *
51      * This test is non-exhaustive, and there may be false-negatives: during the
52      * execution of a contract's constructor, its address will be reported as
53      * not containing a contract.
54      *
55      * IMPORTANT: It is unsafe to assume that an address for which this
56      * function returns false is an externally-owned account (EOA) and not a
57      * contract.
58      */
59     function isContract(address account) internal view returns (bool) {
60         // This method relies in extcodesize, which returns 0 for contracts in
61         // construction, since the code is only stored at the end of the
62         // constructor execution.
63 
64         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
65         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
66         // for accounts without code, i.e. `keccak256('')`
67         bytes32 codehash;
68         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
69         // solhint-disable-next-line no-inline-assembly
70         assembly { codehash := extcodehash(account) }
71         return (codehash != 0x0 && codehash != accountHash);
72     }
73 
74     /**
75      * @dev Converts an `address` into `address payable`. Note that this is
76      * simply a type cast: the actual underlying value is not changed.
77      *
78      * _Available since v2.4.0._
79      */
80     function toPayable(address account) internal pure returns (address payable) {
81         return address(uint160(account));
82     }
83 
84     /**
85      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
86      * `recipient`, forwarding all available gas and reverting on errors.
87      *
88      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
89      * of certain opcodes, possibly making contracts go over the 2300 gas limit
90      * imposed by `transfer`, making them unable to receive funds via
91      * `transfer`. {sendValue} removes this limitation.
92      *
93      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
94      *
95      * IMPORTANT: because control is transferred to `recipient`, care must be
96      * taken to not create reentrancy vulnerabilities. Consider using
97      * {ReentrancyGuard} or the
98      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
99      *
100      * _Available since v2.4.0._
101      */
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-call-value
106         (bool success, ) = recipient.call.value(amount)("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 }
110 
111 /**
112  * @title SafeERC20
113  * @dev Wrappers around ERC20 operations that throw on failure (when the token
114  * contract returns false). Tokens that return no value (and instead revert or
115  * throw on failure) are also supported, non-reverting calls are assumed to be
116  * successful.
117  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
118  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
119  */
120 library SafeERC20 {
121     using SafeMath for uint256;
122     using Address for address;
123 
124     function safeTransfer(StandardToken token, address to, uint256 value) internal {
125         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
126     }
127 
128     function safeTransferFrom(StandardToken token, address from, address to, uint256 value) internal {
129         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
130     }
131 
132     function safeApprove(StandardToken token, address spender, uint256 value) internal {
133         // safeApprove should only be called when setting an initial allowance,
134         // or when resetting it to zero. To increase and decrease it, use
135         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
136         // solhint-disable-next-line max-line-length
137         require((value == 0) || (token.allowance(address(this), spender) == 0),
138             "SafeERC20: approve from non-zero to non-zero allowance"
139         );
140         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
141     }
142 
143     function safeIncreaseAllowance(StandardToken token, address spender, uint256 value) internal {
144         uint256 newAllowance = token.allowance(address(this), spender).add(value);
145         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
146     }
147 
148     function safeDecreaseAllowance(StandardToken token, address spender, uint256 value) internal {
149         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
150         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
151     }
152 
153     /**
154      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
155      * on the return value: the return value is optional (but if data is returned, it must not be false).
156      * @param token The token targeted by the call.
157      * @param data The call data (encoded using abi.encode or one of its variants).
158      */
159     function callOptionalReturn(ERC20 token, bytes memory data) private {
160         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
161         // we're implementing it ourselves.
162 
163         // A Solidity high level call has three parts:
164         //  1. The target address is checked to verify it contains contract code
165         //  2. The call itself is made, and success asserted
166         //  3. The return value is decoded, which in turn checks the size of the returned data.
167         // solhint-disable-next-line max-line-length
168         require(address(token).isContract(), "SafeERC20: call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = address(token).call(data);
172         require(success, "SafeERC20: low-level call failed");
173 
174         if (returndata.length > 0) { // Return data is optional
175             // solhint-disable-next-line max-line-length
176             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
177         }
178     }
179 }
180 
181 contract ManagerUpgradeable is LockIdGen {
182 
183     struct ChangeRequest {
184         address proposedNew;
185         address proposedClear;
186     }
187 
188     // address public custodian;
189     mapping (address => address) public managers;
190 
191     mapping (bytes32 => ChangeRequest) public changeReqs;
192 
193     uint256     public    mancount  ;
194 
195     // CONSTRUCTOR
196     constructor(
197          address  [] memory _mans
198     )
199       LockIdGen()
200       public
201     {
202         uint256 numMans = _mans.length;
203         for (uint256 i = 0; i < numMans; i++) {
204           address pto = _mans[i];
205           require(pto != address(0));
206           managers[pto] = pto;
207         }
208         mancount = 0;
209     }
210 
211     modifier onlyManager {
212         require(msg.sender == managers[msg.sender]);
213         _;
214     }
215 
216     // for manager change
217     function requestChange(address _new,address _clear) public onlyManager returns (bytes32 lockId) {
218         require( _clear != address(0) || _new != address(0) );
219 
220         require( _clear == address(0) || managers[_clear] == _clear);
221 
222         lockId = generateLockId();
223 
224         changeReqs[lockId] = ChangeRequest({
225             proposedNew: _new,
226             proposedClear: _clear
227         });
228 
229         emit ChangeRequested(lockId, msg.sender, _new,_clear);
230     }
231 
232     event ChangeRequested(
233         bytes32 _lockId,
234         address _msgSender,
235         address _new,
236         address _clear
237     );
238 
239    function confirmChange(bytes32 _lockId) public onlyManager {
240         ChangeRequest storage changeRequest = changeReqs[_lockId];
241         require( changeRequest.proposedNew != address(0) || changeRequest.proposedClear != address(0));
242 
243         if(changeRequest.proposedNew != address(0))
244         {
245             managers[changeRequest.proposedNew] = changeRequest.proposedNew;
246             mancount = mancount + 1;
247         }
248 
249         if(changeRequest.proposedClear != address(0))
250         {
251             delete managers[changeRequest.proposedClear];
252             mancount = mancount - 1;
253         }
254 
255         delete changeReqs[_lockId];
256 
257         emit ChangeConfirmed(_lockId, changeRequest.proposedNew,changeRequest.proposedClear);
258     }
259     event ChangeConfirmed(bytes32 _lockId, address _newCustodian, address _clearCustodian);
260 
261     function sweepChange(bytes32 _lockId) public onlyManager {
262         ChangeRequest storage changeRequest=changeReqs[_lockId];
263         require((changeRequest.proposedNew != address(0) || changeRequest.proposedClear != address(0) ));
264         delete changeReqs[_lockId];
265         emit ChangeSweep(_lockId, msg.sender);
266     }
267     event ChangeSweep(bytes32 _lockId, address _sender);
268 
269 }
270 
271 contract ERC20Basic {
272     // events
273     event Transfer(address indexed from, address indexed to, uint256 value);
274 
275     // public functions
276     function totalSupply() public view returns (uint256);
277     function balanceOf(address addr) public view returns (uint256);
278     function transfer(address to, uint256 value) public returns (bool);
279 }
280 
281 contract ERC20 is ERC20Basic {
282     // events
283     event Approval(address indexed owner, address indexed agent, uint256 value);
284 
285     // public functions
286     function allowance(address owner, address agent) public view returns (uint256);
287     function transferFrom(address from, address to, uint256 value) public returns (bool);
288     function approve(address agent, uint256 value) public returns (bool);
289 
290 }
291 
292 contract DFK is ManagerUpgradeable {
293             
294     //liquidity +
295     function stakingDeposit(uint256 value) public payable returns (bool);
296 
297     //profit +
298     function profit2Staking(uint256 value)public  returns (bool success);
299     
300 	
301     function withdrawProfit(address to)public  returns (bool success);
302     
303 	
304     function withdrawStaking(address to,uint256 value)public  returns (bool success);
305     
306 	
307     function withdrawAll(address to)public  returns (bool success);
308 
309     
310 	
311     function totalMiners() public view returns (uint256);
312 
313     function totalStaking() public view returns (uint256);
314 
315 	
316     function poolBalance() public view returns (uint256);
317 
318 	
319     function minedBalance() public view returns (uint256);
320 
321 	
322     function stakingBalance(address miner) public view returns (uint256);
323 
324 
325     function profitBalance(address miner) public view returns (uint256);
326 
327     
328     
329     function pauseStaking()public  returns (bool success);
330     
331     
332     function resumeStaking()public  returns (bool success);
333 
334 }
335 
336 contract DFKProxy is DFK {
337             
338     DFK  public impl;
339 
340 
341     constructor(address [] memory _mans) public ManagerUpgradeable(_mans){
342         impl = DFK(0x0);
343     }
344 
345 
346     function requestImplChange(address _newDFK) public onlyManager returns (bytes32 ) {
347         require(_newDFK != address(0));
348         impl = DFK(_newDFK);
349     }
350 
351 
352 
353     function stakingDeposit(uint256 value) public payable returns (bool){
354         return impl.stakingDeposit(value);
355     }
356 
357 
358 
359     function profit2Staking(uint256 value)public  returns (bool success){
360         return impl.profit2Staking(value);
361     }
362 
363 
364     function withdrawProfit(address to)public  returns (bool success){
365         return impl.withdrawProfit(to);
366     }
367 
368 
369     function withdrawStaking(address to,uint256 value)public  returns (bool success){
370         return impl.withdrawStaking(to,value);
371     }
372     
373     
374     function withdrawAll(address to)public  returns (bool success){
375         return impl.withdrawAll(to);
376     }
377     
378 
379 
380     function totalMiners() public view returns (uint256)
381     {
382         return impl.totalMiners();
383     }
384 
385 
386     function totalStaking() public view returns (uint256)
387     {
388         return impl.totalStaking();
389     }
390 
391 
392     function poolBalance() public view returns (uint256)
393     {
394         return impl.poolBalance();
395     }
396 
397 
398     function minedBalance() public view returns (uint256)
399     {
400         return impl.minedBalance();
401     }
402 
403 
404     function stakingBalance(address miner) public view returns (uint256)
405     {
406         return impl.stakingBalance(miner);
407     }
408 
409 
410 
411     function profitBalance(address miner) public view returns (uint256)
412     {
413         return impl.profitBalance(miner);
414     }
415 
416 
417 
418     function pauseStaking()public  returns (bool success)
419     {
420         return impl.pauseStaking();
421     }
422     
423     
424     function resumeStaking()public  returns (bool success)
425     {
426         return impl.resumeStaking();
427     }
428 
429 }
430 
431 contract DFKImplement is DFK {
432 
433     using SafeMath for uint256;
434     using SafeERC20 for StandardToken;
435 
436     int public status; 
437 
438     struct StakingLog{
439         uint256   staking_time;
440         uint256   profit_time;
441         uint256   staking_value;
442         uint256   unstaking_value; 
443     }
444     mapping(address => StakingLog) public stakings;
445 
446     uint256  public cleanup_time;
447 
448     uint256  public profit_period;
449 
450     uint256  public period_bonus; 
451 
452     mapping(address => uint256) public balanceProfit;
453     mapping(address => uint256) public balanceStaking;
454 
455     StandardToken    public     dfkToken;
456 
457     uint256 public  _totalMiners;
458     uint256 public  _totalStaking; 
459     uint256 public  totalProfit;
460 
461     uint256 public  minePoolBalance; 
462 
463     modifier onStaking {
464         require(status == 1,"please start minner");
465         _;
466     }
467     event ProfitLog(
468         address indexed from,
469         uint256 profit_time, 
470         uint256 staking_value,
471         uint256 unstaking_value,
472         uint256 profit_times, 
473         uint256 profit
474     );
475 
476     constructor(address _dfkToken,int decimals,address  [] memory _mans) public ManagerUpgradeable(_mans){
477         status = 0;
478         cleanup_time = now;
479         profit_period = 24*3600; 
480         period_bonus = 100000*(10 ** uint256(decimals));
481         cleanup_time = now;
482         dfkToken = StandardToken(_dfkToken);
483     }
484 
485      
486     function addMinePool(uint256 stakevalue) public onStaking payable returns (uint256){
487         require(stakevalue>0);
488 
489         // user must call prove first.
490         dfkToken.safeTransferFrom(msg.sender,address(this),stakevalue);
491 
492         minePoolBalance = minePoolBalance.add(stakevalue);
493 
494         return minePoolBalance;
495     }
496 
497 
498       
499     function stakingDeposit(uint256 stakevalue) public onStaking payable returns (bool){
500         require(stakevalue>0,"stakevalue is gt zero");
501 
502         // user must call prove first.
503         dfkToken.transferFrom(msg.sender,address(this),stakevalue);
504 
505         _totalStaking = _totalStaking.add(stakevalue);
506          
507         return addMinerStaking(msg.sender,stakevalue);
508     }
509 
510 
511     function addMinerStaking(address miner,uint256 stakevalue) internal  returns (bool){
512         balanceStaking[miner] = balanceStaking[miner].add(stakevalue);
513         
514         StakingLog memory slog=stakings[miner];
515 
516         if(slog.profit_time < cleanup_time){ 
517             stakings[miner] = StakingLog({
518                 staking_time:now,
519                 profit_time:now,
520                 staking_value:0,
521                 unstaking_value:stakevalue
522             });
523             _totalMiners = _totalMiners.add(1);
524         }else if(now.sub(slog.profit_time) >= profit_period){ 
525             uint256   profit_times = now.sub(slog.profit_time).div(profit_period); 
526             
527             stakings[miner] = StakingLog({
528                 staking_time:now,
529                 profit_time:now,
530                 staking_value:slog.staking_value.add(slog.unstaking_value),
531                 unstaking_value:stakevalue
532             });
533             
534             
535             uint256   profit =  period_bonus.mul(stakings[miner].staking_value).mul(profit_times).div(_totalStaking);
536             emit ProfitLog(miner,stakings[miner].profit_time,stakings[miner].staking_value,stakings[miner].unstaking_value,profit_times,profit);
537             require(minePoolBalance>=profit,"minePoolBalance lt profit");
538             minePoolBalance = minePoolBalance.sub(profit);
539 
540              
541             balanceProfit[miner]=balanceProfit[miner].add(profit);
542             totalProfit = totalProfit.add(profit);
543 
544         }else { 
545             stakings[miner] = StakingLog({
546                 staking_time:now,
547                 profit_time:slog.profit_time,
548                 staking_value:slog.staking_value,
549                 unstaking_value:slog.unstaking_value.add(stakevalue)
550             });
551         }
552         return true;
553     }
554 
555 
556      
557     function profit2Staking(uint256 value)public onStaking returns (bool success){
558         
559         require(balanceProfit[msg.sender]>=value);
560         balanceProfit[msg.sender] = balanceProfit[msg.sender].sub(value);
561         return addMinerStaking(msg.sender,value);
562 
563     }
564 
565      
566     function withdrawProfit(address to)public  returns (bool success){
567         
568         require(to != address(0));
569 
570         addMinerStaking(msg.sender,0);
571 
572         uint256 profit = balanceProfit[msg.sender];
573         balanceProfit[msg.sender] = 0;
574 
575         require(dfkToken.transfer(to,profit));
576 
577         return true;
578 
579     }
580 
581      
582     function withdrawStaking(address to,uint256 value)public  returns (bool success){
583         require(value>0);
584         require(to != address(0));
585         require(balanceStaking[msg.sender]>=value);
586         require(_totalStaking>=value);
587         
588         _totalStaking=_totalStaking.sub(value);
589         
590         balanceStaking[msg.sender] = balanceStaking[msg.sender].sub(value);
591         StakingLog memory slog=stakings[msg.sender];
592         
593          
594         stakings[msg.sender] = StakingLog({
595             staking_time:now,
596             profit_time:slog.profit_time,
597             staking_value:0,
598             unstaking_value:balanceStaking[msg.sender]
599         });
600         
601         require(dfkToken.transfer(to,value));
602         
603         return true;
604     }
605 
606       
607     function withdrawAll(address to)public  returns (bool success){
608         require(to != address(0));
609         
610         addMinerStaking(msg.sender,0);
611         
612         _totalStaking=_totalStaking.sub(balanceStaking[msg.sender]);
613         
614         uint256 total=balanceStaking[msg.sender].add(balanceProfit[msg.sender]);
615 
616         balanceProfit[msg.sender]=0;
617         balanceStaking[msg.sender] = 0;
618          
619         stakings[msg.sender] = StakingLog({
620             staking_time:0,
621             profit_time:0,
622             staking_value:0,
623             unstaking_value:0
624         });
625         // _totalMiners=_totalMiners.sub(1);
626         require(dfkToken.transfer(to,total));
627         
628         return true;
629     }
630     
631     
632     function totalMiners() public view returns (uint256){
633         return _totalMiners;
634     }
635 
636      
637     function totalStaking() public view returns (uint256){
638         return _totalStaking;
639 
640     }
641      
642     function poolBalance() public view returns (uint256){
643         return minePoolBalance;
644     }
645 
646      
647     function minedBalance() public view returns (uint256){
648         return totalProfit;
649     }
650 
651      
652     function stakingBalance(address miner) public view returns (uint256){
653         return balanceStaking[miner];
654     }
655 
656 
657      
658     function profitBalance(address miner) public view returns (uint256){
659         return balanceProfit[miner];
660     }
661 
662      
663     function pauseStaking()public onlyManager  returns (bool ){
664         status = 0;
665     }
666     
667      
668     function resumeStaking()public onlyManager returns (bool ){
669        status = 1;
670     }
671 }
672 
673 contract BasicToken is ERC20Basic {
674   using SafeMath for uint256;
675 
676   // public variables
677   string public name;
678   string public symbol;
679   uint8 public decimals = 18;
680 
681   // internal variables
682   uint256 _totalSupply;
683   mapping(address => uint256) _balances;
684 
685   // events
686 
687   // public functions
688   function totalSupply() public view returns (uint256) {
689     return _totalSupply;
690   }
691 
692   function balanceOf(address addr) public view returns (uint256 balance) {
693     return _balances[addr];
694   }
695 
696   function transfer(address to, uint256 value) public returns (bool) {
697     require(to != address(0));
698     require(value <= _balances[msg.sender]);
699 
700     _balances[msg.sender] = _balances[msg.sender].sub(value);
701     _balances[to] = _balances[to].add(value);
702     emit Transfer(msg.sender, to, value);
703     return true;
704   }
705 
706   // internal functions
707 
708 }
709 
710 contract StandardToken is ERC20, BasicToken {
711   // public variables
712 
713   // internal variables
714   mapping (address => mapping (address => uint256)) _allowances;
715 
716   // events
717 
718   // public functions
719   function transferFrom(address from, address to, uint256 value) public returns (bool) {
720     require(to != address(0));
721     require(value <= _balances[from],"value lt from");
722     require(value <= _allowances[from][msg.sender],"value lt _allowances from ");
723 
724     _balances[from] = _balances[from].sub(value);
725     _balances[to] = _balances[to].add(value);
726     _allowances[from][msg.sender] = _allowances[from][msg.sender].sub(value);
727     emit Transfer(from, to, value);
728     return true;
729   }
730 
731   function approve(address agent, uint256 value) public returns (bool) {
732     _allowances[msg.sender][agent] = value;
733     emit Approval(msg.sender, agent, value);
734     return true;
735   }
736 
737   function allowance(address owner, address agent) public view returns (uint256) {
738     return _allowances[owner][agent];
739   }
740 
741   function increaseApproval(address agent, uint value) public returns (bool) {
742     _allowances[msg.sender][agent] = _allowances[msg.sender][agent].add(value);
743     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
744     return true;
745   }
746 
747   function decreaseApproval(address agent, uint value) public returns (bool) {
748     uint allowanceValue = _allowances[msg.sender][agent];
749     if (value > allowanceValue) {
750       _allowances[msg.sender][agent] = 0;
751     } else {
752       _allowances[msg.sender][agent] = allowanceValue.sub(value);
753     }
754     emit Approval(msg.sender, agent, _allowances[msg.sender][agent]);
755     return true;
756   }
757   // internal functions
758 }
759 
760 contract DFKToken is StandardToken {
761   // public variables
762   string public name = "Defiking";
763   string public symbol = "DFK";
764   uint8 public decimals = 18;
765 
766   // internal variables
767  
768   // events
769 
770   // public functions
771   constructor() public {
772     //init _totalSupply
773     _totalSupply = 1000000000 * (10 ** uint256(decimals));
774 
775     _balances[msg.sender] = _totalSupply;
776     emit Transfer(address(0x0), msg.sender, _totalSupply);
777   }
778 
779   // internal functions
780 }