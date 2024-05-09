1 pragma solidity ^0.4.24;/**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (_a == 0) {
15       return 0;
16     }
17 
18     c = _a * _b;
19     assert(c / _a == _b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
27     // assert(_b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = _a / _b;
29     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
30     return _a / _b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     assert(_b <= _a);
38     return _a - _b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
45     c = _a + _b;
46     assert(c >= _a);
47     return c;
48   }
49 }/**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * See https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address _who) public view returns (uint256);
57   function transfer(address _to, uint256 _value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }/**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address _owner, address _spender)
65     public view returns (uint256);
66 
67   function transferFrom(address _from, address _to, uint256 _value)
68     public returns (bool);
69 
70   function approve(address _spender, uint256 _value) public returns (bool);
71   event Approval(
72     address indexed owner,
73     address indexed spender,
74     uint256 value
75   );
76 }/**
77  * @title Ownable
78  * @dev The Ownable contract has an owner address, and provides basic authorization control
79  * functions, this simplifies the implementation of "user permissions".
80  */
81 contract Ownable {
82   address public owner;
83 
84 
85   event OwnershipRenounced(address indexed previousOwner);
86   event OwnershipTransferred(
87     address indexed previousOwner,
88     address indexed newOwner
89   );
90 
91 
92   /**
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94    * account.
95    */
96   constructor() public {
97     owner = msg.sender;
98   }
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to relinquish control of the contract.
110    * @notice Renouncing to ownership will leave the contract without an owner.
111    * It will not be possible to call the functions with the `onlyOwner`
112    * modifier anymore.
113    */
114   function renounceOwnership() public onlyOwner {
115     emit OwnershipRenounced(owner);
116     owner = address(0);
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param _newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address _newOwner) public onlyOwner {
124     _transferOwnership(_newOwner);
125   }
126 
127   /**
128    * @dev Transfers control of the contract to a newOwner.
129    * @param _newOwner The address to transfer ownership to.
130    */
131   function _transferOwnership(address _newOwner) internal {
132     require(_newOwner != address(0));
133     emit OwnershipTransferred(owner, _newOwner);
134     owner = _newOwner;
135   }
136 }/**
137  * @title Pausable
138  * @dev Base contract which allows children to implement an emergency stop mechanism.
139  */
140 contract Pausable is Ownable {
141   event Pause();
142   event Unpause();
143 
144   bool public paused = false;
145 
146 
147   /**
148    * @dev Modifier to make a function callable only when the contract is not paused.
149    */
150   modifier whenNotPaused() {
151     require(!paused);
152     _;
153   }
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is paused.
157    */
158   modifier whenPaused() {
159     require(paused);
160     _;
161   }
162 
163   /**
164    * @dev called by the owner to pause, triggers stopped state
165    */
166   function pause() public onlyOwner whenNotPaused {
167     paused = true;
168     emit Pause();
169   }
170 
171   /**
172    * @dev called by the owner to unpause, returns to normal state
173    */
174   function unpause() public onlyOwner whenPaused {
175     paused = false;
176     emit Unpause();
177   }
178 }// SPDX-License-Identifier: MIT
179 
180 
181 
182 
183 
184 contract GovManager is Pausable {
185     address public GovernerContract;
186 
187     modifier onlyOwnerOrGov() {
188         require(msg.sender == owner || msg.sender == GovernerContract, "Authorization Error");
189         _;
190     }
191 
192     function setGovernerContract(address _address) external onlyOwnerOrGov{
193         GovernerContract = _address;
194     }
195 
196     constructor() public {
197         GovernerContract = address(0);
198     }
199 }// SPDX-License-Identifier: MIT
200 
201 
202 
203 
204 
205 
206 
207 contract ERC20Helper is GovManager {
208     event TransferOut(uint256 Amount, address To, address Token);
209     event TransferIn(uint256 Amount, address From, address Token);
210     modifier TestAllownce(
211         address _token,
212         address _owner,
213         uint256 _amount
214     ) {
215         require(
216             ERC20(_token).allowance(_owner, address(this)) >= _amount,
217             "no allowance"
218         );
219         _;
220     }
221 
222     function TransferToken(
223         address _Token,
224         address _Reciver,
225         uint256 _Amount
226     ) internal {
227         uint256 OldBalance = CheckBalance(_Token, address(this));
228         emit TransferOut(_Amount, _Reciver, _Token);
229         ERC20(_Token).transfer(_Reciver, _Amount);
230         require(
231             (SafeMath.add(CheckBalance(_Token, address(this)), _Amount)) == OldBalance
232                 ,
233             "recive wrong amount of tokens"
234         );
235     }
236 
237     function CheckBalance(address _Token, address _Subject)
238         internal
239         view
240         returns (uint256)
241     {
242         return ERC20(_Token).balanceOf(_Subject);
243     }
244 
245     function TransferInToken(
246         address _Token,
247         address _Subject,
248         uint256 _Amount
249     ) internal TestAllownce(_Token, _Subject, _Amount) {
250         require(_Amount > 0);
251         uint256 OldBalance = CheckBalance(_Token, address(this));
252         ERC20(_Token).transferFrom(_Subject, address(this), _Amount);
253         emit TransferIn(_Amount, _Subject, _Token);
254         require(
255             (SafeMath.add(OldBalance, _Amount)) ==
256                 CheckBalance(_Token, address(this)),
257             "recive wrong amount of tokens"
258         );
259     }
260 }// SPDX-License-Identifier: MIT
261 
262 
263 
264 //True POZ Token will have this, 
265 interface IPOZBenefit {
266     function IsPOZHolder(address _Subject) external view returns(bool);
267 }// SPDX-License-Identifier: MIT
268 
269 
270 
271 
272 
273 
274 contract PozBenefit is ERC20Helper {
275     constructor() public {
276         PozFee = 15; // *10000
277         PozTimer = 1000; // *10000
278     
279        // POZ_Address = address(0x0);
280        // POZBenefit_Address = address(0x0);
281     }
282 
283     uint256 public PozFee; // the fee for the first part of the pool
284     uint256 public PozTimer; //the timer for the first part fo the pool
285     
286     modifier PercentCheckOk(uint256 _percent) {
287         if (_percent < 10000) _;
288         else revert("Not in range");
289     }
290     modifier LeftIsBigger(uint256 _left, uint256 _right) {
291         if (_left > _right) _;
292         else revert("Not bigger");
293     }
294 
295     function SetPozTimer(uint256 _pozTimer)
296         public
297         onlyOwnerOrGov
298         PercentCheckOk(_pozTimer)
299     {
300         PozTimer = _pozTimer;
301     }
302 
303     
304 }// SPDX-License-Identifier: MIT
305 
306 
307 
308 
309 
310 contract ETHHelper is PozBenefit {
311     constructor() public {
312         IsPayble = false;
313     }
314 
315     modifier ReceivETH(uint256 msgValue, address msgSender, uint256 _MinETHInvest) {
316         require(msgValue >= _MinETHInvest, "Send ETH to invest");
317         emit TransferInETH(msgValue, msgSender);
318         _;
319     }
320 
321     //@dev not/allow contract to receive funds
322     function() public payable {
323         if (!IsPayble) revert();
324     }
325 
326     event TransferOutETH(uint256 Amount, address To);
327     event TransferInETH(uint256 Amount, address From);
328 
329     bool public IsPayble;
330  
331     function SwitchIsPayble() public onlyOwner {
332         IsPayble = !IsPayble;
333     }
334 
335     function TransferETH(address _Reciver, uint256 _ammount) internal {
336         emit TransferOutETH(_ammount, _Reciver);
337         uint256 beforeBalance = address(_Reciver).balance;
338         _Reciver.transfer(_ammount);
339         require(
340             SafeMath.add(beforeBalance, _ammount) == address(_Reciver).balance,
341             "The transfer did not complite"
342         );
343     }
344  
345 }// SPDX-License-Identifier: MIT
346 
347 
348 
349 //For whitelist, 
350 interface IWhiteList {
351     function Check(address _Subject, uint256 _Id) external view returns(uint);
352     function Register(address _Subject,uint256 _Id,uint256 _Amount) external;
353     function IsNeedRegister(uint256 _Id) external view returns(bool);
354 }// SPDX-License-Identifier: MIT
355 
356 
357 
358 
359 
360 
361 contract Manageable is ETHHelper {
362     constructor() public {
363         Fee = 20; // *10000
364         //MinDuration = 0; //need to set
365         //PoolPrice = 0; // Price for create a pool
366         MaxDuration = 60 * 60 * 24 * 30 * 6; // half year
367         MinETHInvest = 10000; // for percent calc
368         MaxETHInvest = 100 * 10**18; // 100 eth per wallet
369         //WhiteList_Address = address(0x0);
370     }
371 
372     mapping(address => uint256) FeeMap;
373     //@dev for percent use uint16
374     uint256 public Fee; //the fee for the pool
375     uint256 public MinDuration; //the minimum duration of a pool, in seconds
376     uint256 public MaxDuration; //the maximum duration of a pool from the creation, in seconds
377     uint256 public PoolPrice;
378     uint256 public MinETHInvest;
379     uint256 public MaxETHInvest;
380     address public WhiteList_Address; //The address of the Whitelist contract
381 
382     bool public IsTokenFilterOn;
383     uint256 public TokenWhitelistId;
384     uint256 public MCWhitelistId; // Main Coin WhiteList ID
385 
386     function SwapTokenFilter() public onlyOwner {
387         IsTokenFilterOn = !IsTokenFilterOn;
388     }
389 
390     function setTokenWhitelistId(uint256 _whiteListId) external onlyOwnerOrGov{
391         TokenWhitelistId = _whiteListId;
392     }
393 
394     function setMCWhitelistId(uint256 _whiteListId) external onlyOwnerOrGov{
395         MCWhitelistId = _whiteListId;
396     }
397 
398     function IsValidToken(address _address) public view returns (bool) {
399         return !IsTokenFilterOn || (IWhiteList(WhiteList_Address).Check(_address, TokenWhitelistId) > 0);
400     }
401 
402     function IsERC20Maincoin(address _address) public view returns (bool) {
403         return !IsTokenFilterOn || IWhiteList(WhiteList_Address).Check(_address, MCWhitelistId) > 0;
404     }
405     
406     function SetWhiteList_Address(address _WhiteList_Address) public onlyOwnerOrGov {
407         WhiteList_Address = _WhiteList_Address;
408     }
409 
410     function SetMinMaxETHInvest(uint256 _MinETHInvest, uint256 _MaxETHInvest)
411         public
412         onlyOwnerOrGov
413     {
414         MinETHInvest = _MinETHInvest;
415         MaxETHInvest = _MaxETHInvest;
416     }
417 
418     function SetMinMaxDuration(uint256 _minDuration, uint256 _maxDuration)
419         public
420         onlyOwnerOrGov
421     {
422         MinDuration = _minDuration;
423         MaxDuration = _maxDuration;
424     }
425 
426     function SetPoolPrice(uint256 _PoolPrice) public onlyOwnerOrGov {
427         PoolPrice = _PoolPrice;
428     }
429 
430     function SetFee(uint256 _fee)
431         public
432         onlyOwnerOrGov
433         PercentCheckOk(_fee)
434         LeftIsBigger(_fee, PozFee)
435     {
436         Fee = _fee;
437     }
438 
439     function SetPOZFee(uint256 _fee)
440         public
441         onlyOwnerOrGov
442         PercentCheckOk(_fee)
443         LeftIsBigger(Fee, _fee)
444     {
445         PozFee = _fee;
446     }
447 
448     
449 }// SPDX-License-Identifier: MIT
450 
451 
452 
453 
454 
455 
456 contract Pools is Manageable {
457     event NewPool(address token, uint256 id);
458     event FinishPool(uint256 id);
459     event PoolUpdate(uint256 id);
460 
461     constructor() public {
462         //  poolsCount = 0; //Start with 0
463     }
464 
465     uint256 public poolsCount; // the ids of the pool
466     mapping(uint256 => Pool) public pools; //the id of the pool with the data
467     mapping(address => uint256[]) public poolsMap; //the address and all of the pools id's
468     struct Pool {
469         PoolBaseData BaseData;
470         PoolMoreData MoreData;
471     }
472     struct PoolBaseData {
473         address Token; //the address of the erc20 toke for sale
474         address Creator; //the project owner
475         uint256 FinishTime; //Until what time the pool is active
476         uint256 Rate; //for eth Wei, in token, by the decemal. the cost of 1 token
477         uint256 POZRate; //the rate for the until OpenForAll, if the same as Rate , OpenForAll = StartTime .
478         address Maincoin; // on adress.zero = ETH
479         uint256 StartAmount; //The total amount of the tokens for sale
480     }
481     struct PoolMoreData {
482         uint64 LockedUntil; // true - the investors getting the tokens after the FinishTime. false - intant deal
483         uint256 Lefttokens; // the ammount of tokens left for sale
484         uint256 StartTime; // the time the pool open //TODO Maybe Delete this?
485         uint256 OpenForAll; // The Time that all investors can invest
486         uint256 UnlockedTokens; //for locked pools
487         uint256 WhiteListId; // 0 is turn off, the Id of the whitelist from the contract.
488         bool TookLeftOvers; //The Creator took the left overs after the pool finished
489         bool Is21DecimalRate; //If true, the rate will be rate*10^-21
490     }
491 
492     function isPoolLocked(uint256 _id) public view returns(bool){
493         return pools[_id].MoreData.LockedUntil > now;
494     }
495 
496     //create a new pool
497     function CreatePool(
498         address _Token, //token to sell address
499         uint256 _FinishTime, //Until what time the pool will work
500         uint256 _Rate, //the rate of the trade
501         uint256 _POZRate, //the rate for POZ Holders, how much each token = main coin
502         uint256 _StartAmount, //Total amount of the tokens to sell in the pool
503         uint64 _LockedUntil, //False = DSP or True = TLP
504         address _MainCoin, // address(0x0) = ETH, address of main token
505         bool _Is21Decimal, //focus the for smaller tokens.
506         uint256 _Now, //Start Time - can be 0 to not change current flow
507         uint256 _WhiteListId // the Id of the Whitelist contract, 0 For turn-off
508     ) public payable whenNotPaused {
509         require(msg.value >= PoolPrice, "Need to pay for the pool");
510         require(IsValidToken(_Token), "Need Valid ERC20 Token"); //check if _Token is ERC20
511         require(
512             _MainCoin == address(0x0) || IsERC20Maincoin(_MainCoin),
513             "Main coin not in list"
514         );
515         require(_FinishTime  < SafeMath.add(MaxDuration, now), "Pool duration can't be that long");
516         require(_LockedUntil < SafeMath.add(MaxDuration, now) , "Locked value can't be that long");
517         require(
518             _Rate <= _POZRate,
519             "POZ holders need to have better price (or the same)"
520         );
521         require(_POZRate > 0, "It will not work");
522         if (_Now < now) _Now = now;
523         require(
524             SafeMath.add(now, MinDuration) <= _FinishTime,
525             "Need more then MinDuration"
526         ); // check if the time is OK
527         TransferInToken(_Token, msg.sender, _StartAmount);
528         uint256 Openforall =
529             (_WhiteListId == 0) 
530                 ? _Now //and this
531                 : SafeMath.add(
532                     SafeMath.div(
533                         SafeMath.mul(SafeMath.sub(_FinishTime, _Now), PozTimer),
534                         10000
535                     ),
536                     _Now
537                 );
538         //register the pool
539         pools[poolsCount] = Pool(
540             PoolBaseData(
541                 _Token,
542                 msg.sender,
543                 _FinishTime,
544                 _Rate,
545                 _POZRate,
546                 _MainCoin,
547                 _StartAmount
548             ),
549             PoolMoreData(
550                 _LockedUntil,
551                 _StartAmount,
552                 _Now,
553                 Openforall,
554                 0,
555                 _WhiteListId,
556                 false,
557                 _Is21Decimal
558             )
559         );
560         poolsMap[msg.sender].push(poolsCount);
561         emit NewPool(_Token, poolsCount);
562         poolsCount = SafeMath.add(poolsCount, 1); //joke - overflowfrom 0 on int256 = 1.16E77
563     }
564 }// SPDX-License-Identifier: MIT
565 
566 
567 
568 
569 contract PoolsData is Pools {
570     enum PoolStatus {Created, Open, PreMade, OutOfstock, Finished, Close} //the status of the pools
571 
572     modifier PoolId(uint256 _id) {
573         require(_id < poolsCount, "Wrong pool id, Can't get Status");
574         _;
575     }
576 
577     function GetMyPoolsId() public view returns (uint256[]) {
578         return poolsMap[msg.sender];
579     }
580 
581     function GetPoolBaseData(uint256 _Id)
582         public
583         view
584         PoolId(_Id)
585         returns (
586             address,
587             address,
588             uint256,
589             uint256,
590             uint256,
591             uint256
592         )
593     {
594         return (
595             pools[_Id].BaseData.Token,
596             pools[_Id].BaseData.Creator,
597             pools[_Id].BaseData.FinishTime,
598             pools[_Id].BaseData.Rate,
599             pools[_Id].BaseData.POZRate,
600             pools[_Id].BaseData.StartAmount
601         );
602     }
603 
604     function GetPoolMoreData(uint256 _Id)
605         public
606         view
607         PoolId(_Id)
608         returns (
609             uint64,
610             uint256,
611             uint256,
612             uint256,
613             uint256,
614             bool
615         )
616     {
617         return (
618             pools[_Id].MoreData.LockedUntil,
619             pools[_Id].MoreData.Lefttokens,
620             pools[_Id].MoreData.StartTime,
621             pools[_Id].MoreData.OpenForAll,
622             pools[_Id].MoreData.UnlockedTokens,
623             pools[_Id].MoreData.Is21DecimalRate
624         );
625     }
626 
627     function GetPoolExtraData(uint256 _Id)
628         public
629         view
630         PoolId(_Id)
631         returns (
632             bool,
633             uint256,
634             address
635         )
636     {
637         return (
638             pools[_Id].MoreData.TookLeftOvers,
639             pools[_Id].MoreData.WhiteListId,
640             pools[_Id].BaseData.Maincoin
641         );
642     }
643 
644     function IsReadyWithdrawLeftOvers(uint256 _PoolId)
645         public
646         view
647         PoolId(_PoolId)
648         returns (bool)
649     {
650         return
651             pools[_PoolId].BaseData.FinishTime <= now &&
652             pools[_PoolId].MoreData.Lefttokens > 0 &&
653             !pools[_PoolId].MoreData.TookLeftOvers;
654     }
655 
656     //@dev no use of revert to make sure the loop will work
657     function WithdrawLeftOvers(uint256 _PoolId) public PoolId(_PoolId) returns (bool) {
658         //pool is finished + got left overs + did not took them
659         if (IsReadyWithdrawLeftOvers(_PoolId)) {
660             pools[_PoolId].MoreData.TookLeftOvers = true;
661             TransferToken(
662                 pools[_PoolId].BaseData.Token,
663                 pools[_PoolId].BaseData.Creator,
664                 pools[_PoolId].MoreData.Lefttokens
665             );
666             return true;
667         }
668         return false;
669     }
670 
671     //calculate the status of a pool
672     function GetPoolStatus(uint256 _id)
673         public
674         view
675         PoolId(_id)
676         returns (PoolStatus)
677     {
678         //Don't like the logic here - ToDo Boolean checks (truth table)
679         if (now < pools[_id].MoreData.StartTime) return PoolStatus.PreMade;
680         if (
681             now < pools[_id].MoreData.OpenForAll &&
682             pools[_id].MoreData.Lefttokens > 0
683         ) {
684             //got tokens + only poz investors
685             return (PoolStatus.Created);
686         }
687         if (
688             now >= pools[_id].MoreData.OpenForAll &&
689             pools[_id].MoreData.Lefttokens > 0 &&
690             now < pools[_id].BaseData.FinishTime
691         ) {
692             //got tokens + all investors
693             return (PoolStatus.Open);
694         }
695         if (
696             pools[_id].MoreData.Lefttokens == 0 &&
697             isPoolLocked(_id) &&
698             now < pools[_id].BaseData.FinishTime
699         ) //no tokens on locked pool, got time
700         {
701             return (PoolStatus.OutOfstock);
702         }
703         if (
704             pools[_id].MoreData.Lefttokens == 0 && !isPoolLocked(_id)
705         ) //no tokens on direct pool
706         {
707             return (PoolStatus.Close);
708         }
709         if (
710             now >= pools[_id].BaseData.FinishTime &&
711             !isPoolLocked(_id)
712         ) {
713             // After finish time - not locked
714             if (pools[_id].MoreData.TookLeftOvers) return (PoolStatus.Close);
715             return (PoolStatus.Finished);
716         }
717         if (
718             (pools[_id].MoreData.TookLeftOvers ||
719                 pools[_id].MoreData.Lefttokens == 0) &&
720             (pools[_id].MoreData.UnlockedTokens +
721                 pools[_id].MoreData.Lefttokens ==
722                 pools[_id].BaseData.StartAmount)
723         ) return (PoolStatus.Close);
724         return (PoolStatus.Finished);
725     }
726 }// SPDX-License-Identifier: MIT
727 
728 
729 
730 
731 
732 contract Invest is PoolsData {
733     event NewInvestorEvent(uint256 Investor_ID, address Investor_Address);
734 
735     modifier CheckTime(uint256 _Time) {
736         require(now >= _Time, "Pool not open yet");
737         _;
738     }
739 
740     //using SafeMath for uint256;
741     constructor() public {
742         //TotalInvestors = 0;
743     }
744 
745     //Investorsr Data
746     uint256 internal TotalInvestors;
747     mapping(uint256 => Investor) Investors;
748     mapping(address => uint256[]) InvestorsMap;
749     struct Investor {
750         uint256 Poolid; //the id of the pool, he got the rate info and the token, check if looked pool
751         address InvestorAddress; //
752         uint256 MainCoin; //the amount of the main coin invested (eth/dai), calc with rate
753         uint256 TokensOwn; //the amount of Tokens the investor needto get from the contract
754         uint256 InvestTime; //the time that investment made
755     }
756 
757     function getTotalInvestor() external view returns(uint256){
758         return TotalInvestors;
759     }
760     
761     //@dev Send in wei
762     function InvestETH(uint256 _PoolId)
763         external
764         payable
765         ReceivETH(msg.value, msg.sender, MinETHInvest)
766         whenNotPaused
767         CheckTime(pools[_PoolId].MoreData.StartTime)
768     {
769         require(_PoolId < poolsCount, "Wrong pool id, InvestETH fail");
770         require(pools[_PoolId].BaseData.Maincoin == address(0x0), "Pool is not for ETH");
771         require(
772             msg.value >= MinETHInvest && msg.value <= MaxETHInvest,
773             "Investment amount not valid"
774         );
775         require(
776             msg.sender == tx.origin && !isContract(msg.sender),
777             "Some thing wrong with the msgSender"
778         );
779         uint256 ThisInvestor = NewInvestor(msg.sender, msg.value, _PoolId);
780         uint256 Tokens = CalcTokens(_PoolId, msg.value, msg.sender);
781         
782         TokenAllocate(_PoolId, ThisInvestor, Tokens);
783 
784         uint256 EthMinusFee =
785             SafeMath.div(
786                 SafeMath.mul(msg.value, SafeMath.sub(10000, CalcFee(_PoolId))),
787                 10000
788             );
789         // send money to project owner - the fee stays on contract
790         TransferETH(pools[_PoolId].BaseData.Creator, EthMinusFee); 
791         RegisterInvest(_PoolId, Tokens);
792     }
793 
794     function InvestERC20(uint256 _PoolId, uint256 _Amount)
795         external
796         whenNotPaused
797         CheckTime(pools[_PoolId].MoreData.StartTime)
798     {
799         require(_PoolId < poolsCount, "Wrong pool id, InvestERC20 fail");
800         require(
801             pools[_PoolId].BaseData.Maincoin != address(0x0),
802             "Pool is for ETH, use InvetETH"
803         );
804         require(_Amount > 10000, "Need invest more then 10000");
805         require(
806             msg.sender == tx.origin && !isContract(msg.sender),
807             "Some thing wrong with the msgSender"
808         );
809         TransferInToken(pools[_PoolId].BaseData.Maincoin, msg.sender, _Amount);
810         uint256 ThisInvestor = NewInvestor(msg.sender, _Amount, _PoolId);
811         uint256 Tokens = CalcTokens(_PoolId, _Amount, msg.sender);
812 
813         TokenAllocate(_PoolId, ThisInvestor, Tokens);
814 
815         uint256 RegularFeePay =
816             SafeMath.div(SafeMath.mul(_Amount, CalcFee(_PoolId)), 10000);
817 
818         uint256 RegularPaymentMinusFee = SafeMath.sub(_Amount, RegularFeePay);
819         FeeMap[pools[_PoolId].BaseData.Maincoin] = SafeMath.add(
820             FeeMap[pools[_PoolId].BaseData.Maincoin],
821             RegularFeePay
822         );
823         TransferToken(
824             pools[_PoolId].BaseData.Maincoin,
825             pools[_PoolId].BaseData.Creator,
826             RegularPaymentMinusFee
827         ); // send money to project owner - the fee stays on contract
828         RegisterInvest(_PoolId, Tokens);
829     }
830 
831     function TokenAllocate(uint256 _PoolId, uint256 _ThisInvestor, uint256 _Tokens) internal {
832         if (isPoolLocked(_PoolId)) {
833             Investors[_ThisInvestor].TokensOwn = SafeMath.add(
834                 Investors[_ThisInvestor].TokensOwn,
835                 _Tokens
836             );
837         } else {
838             // not locked, will transfer the tokens
839             TransferToken(pools[_PoolId].BaseData.Token, Investors[_ThisInvestor].InvestorAddress, _Tokens);
840         }
841     }
842 
843     function RegisterInvest(uint256 _PoolId, uint256 _Tokens) internal {
844         require(
845             _Tokens <= pools[_PoolId].MoreData.Lefttokens,
846             "Not enough tokens in the pool"
847         );
848         pools[_PoolId].MoreData.Lefttokens = SafeMath.sub(
849             pools[_PoolId].MoreData.Lefttokens,
850             _Tokens
851         );
852         if (pools[_PoolId].MoreData.Lefttokens == 0) emit FinishPool(_PoolId);
853         else emit PoolUpdate(_PoolId);
854     }
855 
856     function NewInvestor(
857         address _Sender,
858         uint256 _Amount,
859         uint256 _Pid
860     ) internal returns (uint256) {
861         Investors[TotalInvestors] = Investor(
862             _Pid,
863             _Sender,
864             _Amount,
865             0,
866             block.timestamp
867         );
868         InvestorsMap[msg.sender].push(TotalInvestors);
869         emit NewInvestorEvent(TotalInvestors, _Sender);
870         TotalInvestors = SafeMath.add(TotalInvestors, 1);
871         return SafeMath.sub(TotalInvestors, 1);
872     }
873 
874     function CalcTokens(
875         uint256 _Pid,
876         uint256 _Amount,
877         address _Sender
878     ) internal returns (uint256) {
879         uint256 msgValue = _Amount;
880         uint256 result = 0;
881         if (GetPoolStatus(_Pid) == PoolStatus.Created) {
882             IsWhiteList(_Sender, pools[_Pid].MoreData.WhiteListId, _Amount);
883             result = SafeMath.mul(msgValue, pools[_Pid].BaseData.POZRate);
884         }
885         if (GetPoolStatus(_Pid) == PoolStatus.Open) {
886             result = SafeMath.mul(msgValue, pools[_Pid].BaseData.Rate);
887         }
888         if (result >= 10**21) {
889             if (pools[_Pid].MoreData.Is21DecimalRate) {
890                 result = SafeMath.div(result, 10**21);
891             }
892             return result;
893         }
894         revert("Wrong pool status to CalcTokens");
895     }
896 
897     function CalcFee(uint256 _Pid) internal view returns (uint256) {
898         if (GetPoolStatus(_Pid) == PoolStatus.Created) {
899             return PozFee;
900         }
901         if (GetPoolStatus(_Pid) == PoolStatus.Open) {
902             return Fee;
903         }
904         //will not get here, will fail on CalcTokens
905     }
906 
907     //@dev use it with  require(msg.sender == tx.origin)
908     function isContract(address _addr) internal view returns (bool) {
909         uint32 size;
910         assembly {
911             size := extcodesize(_addr)
912         }
913         return (size > 0);
914     }
915 
916     //  no need register - will return true or false base on Check
917     //  if need register - revert or true
918     function IsWhiteList(
919         address _Investor,
920         uint256 _Id,
921         uint256 _Amount
922     ) internal returns (bool) {
923         if (_Id == 0) return true; //turn-off
924         IWhiteList(WhiteList_Address).Register(_Investor, _Id, _Amount); //will revert if fail
925         return true;
926     }
927 }// SPDX-License-Identifier: MIT
928 
929 
930 
931 
932 
933 contract InvestorData is Invest {
934     function IsReadyWithdrawInvestment(uint256 _id) public view returns (bool) {
935         return
936             _id <= TotalInvestors &&
937             Investors[_id].TokensOwn > 0 &&
938             pools[Investors[_id].Poolid].MoreData.LockedUntil <= now;
939     }
940 
941     function WithdrawInvestment(uint256 _id) public returns (bool) {
942         if (IsReadyWithdrawInvestment(_id)) {
943             uint256 temp = Investors[_id].TokensOwn;
944             Investors[_id].TokensOwn = 0;
945             TransferToken(
946                 pools[Investors[_id].Poolid].BaseData.Token,
947                 Investors[_id].InvestorAddress,
948                 temp
949             );
950             pools[Investors[_id].Poolid].MoreData.UnlockedTokens = SafeMath.add(
951                 pools[Investors[_id].Poolid].MoreData.UnlockedTokens,
952                 temp
953             );
954 
955             return true;
956         }
957         return false;
958     }
959 
960     //Give all the id's of the investment  by sender address
961     function GetMyInvestmentIds() public view returns (uint256[]) {
962         return InvestorsMap[msg.sender];
963     }
964 
965     function GetInvestmentData(uint256 _id)
966         public
967         view
968         returns (
969             uint256,
970             address,
971             uint256,
972             uint256,
973             uint256
974         )
975     {
976         return (
977             Investors[_id].Poolid,
978             Investors[_id].InvestorAddress,
979             Investors[_id].MainCoin,
980             Investors[_id].TokensOwn,
981             Investors[_id].InvestTime
982         );
983     }
984 }// SPDX-License-Identifier: MIT
985 
986 
987 
988 
989 contract ThePoolz is InvestorData {
990     constructor() public {    }
991 
992     function WithdrawETHFee(address _to) public onlyOwner {
993         _to.transfer(address(this).balance); // keeps only fee eth on contract //To Do need to take 16% to burn!!!
994     }
995 
996     function WithdrawERC20Fee(address _Token, address _to) public onlyOwner {
997         uint256 temp = FeeMap[_Token];
998         FeeMap[_Token] = 0;
999         TransferToken(_Token, _to, temp);
1000     }
1001     
1002 }