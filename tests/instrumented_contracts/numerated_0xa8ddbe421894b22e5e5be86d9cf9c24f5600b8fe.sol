1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address newOwner) public onlyOwner {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54  //We have to specify what version of the compiler this code will use
55 
56 /**
57  * @title SafeMath
58  * @dev Math operations with safety checks that throw on error
59  */
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66     if (a == 0) {
67       return 0;
68     }
69     uint256 c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers, truncating the quotient.
76   */
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   /**
93   * @dev Adds two numbers, throws on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 contract ERC20 is ERC20Basic {
152   function allowance(address owner, address spender) public view returns (uint256);
153   function transferFrom(address from, address to, uint256 value) public returns (bool);
154   function approve(address spender, uint256 value) public returns (bool);
155   event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 /**
159  * @title Standard ERC20 token
160  *
161  * @dev Implementation of the basic standard token.
162  * @dev https://github.com/ethereum/EIPs/issues/20
163  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177     require(_to != address(0));
178     require(_value <= balances[_from]);
179     require(_value <= allowed[_from][msg.sender]);
180 
181     balances[_from] = balances[_from].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184     Transfer(_from, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _value The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _value) public returns (bool) {
199     allowed[msg.sender][_spender] = _value;
200     Approval(msg.sender, _spender, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Increase the amount of tokens that an owner allowed to a spender.
216    *
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _addedValue The amount of tokens to increase the allowance by.
223    */
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    *
233    * approve should be called when allowed[_spender] == 0. To decrement
234    * allowed value is better to use this function to avoid 2 calls (and wait until
235    * the first transaction is mined)
236    * From MonolithDAO Token.sol
237    * @param _spender The address which will spend the funds.
238    * @param _subtractedValue The amount of tokens to decrease the allowance by.
239    */
240   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241     uint oldValue = allowed[msg.sender][_spender];
242     if (_subtractedValue > oldValue) {
243       allowed[msg.sender][_spender] = 0;
244     } else {
245       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246     }
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251 }
252 
253 contract QIUToken is StandardToken,Ownable {
254     string public name = 'QIUToken';
255     string public symbol = 'QIU';
256     uint8 public decimals = 0;
257     uint public INITIAL_SUPPLY = 5000000000;
258     uint public eth2qiuRate = 10000;
259 
260     function() public payable { } // make this contract to receive ethers
261 
262     function QIUToken() public {
263         totalSupply_ = INITIAL_SUPPLY;
264         balances[owner] = INITIAL_SUPPLY / 10;
265         balances[this] = INITIAL_SUPPLY - balances[owner];
266     }
267 
268     function getOwner() public view returns (address) {
269         return owner;
270     }  
271     
272     /**
273     * @dev Transfer tokens from one address to another, only owner can do this super-user operate
274     * @param _from address The address which you want to send tokens from
275     * @param _to address The address which you want to transfer to
276     * @param _value uint256 the amount of tokens to be transferred
277     */
278     function ownerTransferFrom(address _from, address _to, uint256 _value) public returns (bool) {
279         require(tx.origin == owner); // only the owner can call the method.
280         require(_to != address(0));
281         require(_value <= balances[_from]);
282 
283         balances[_from] = balances[_from].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285         Transfer(_from, _to, _value);
286         return true;
287     }
288 
289       /**
290     * @dev transfer token for a specified address,but different from transfer is replace msg.sender with tx.origin
291     * @param _to The address to transfer to.
292     * @param _value The amount to be transferred.
293     */
294     function originTransfer(address _to, uint256 _value) public returns (bool) {
295         require(_to != address(0));
296         require(_value <= balances[tx.origin]);
297 
298         // SafeMath.sub will throw if there is not enough balance.
299         balances[tx.origin] = balances[tx.origin].sub(_value);
300         balances[_to] = balances[_to].add(_value);
301         Transfer(tx.origin, _to, _value);
302         return true;
303     }
304 
305     event ExchangeForETH(address fromAddr,address to,uint qiuAmount,uint ethAmount);
306     function exchangeForETH(uint qiuAmount) public returns (bool){
307         uint ethAmount = qiuAmount * 1000000000000000000 / eth2qiuRate; // only accept multiple of 100
308         require(this.balance >= ethAmount);
309         balances[this] = balances[this].add(qiuAmount);
310         balances[msg.sender] = balances[msg.sender].sub(qiuAmount);
311         msg.sender.transfer(ethAmount);
312         ExchangeForETH(this,msg.sender,qiuAmount,ethAmount);
313         return true;
314     }
315 
316     event ExchangeForQIU(address fromAddr,address to,uint qiuAmount,uint ethAmount);
317     function exchangeForQIU() payable public returns (bool){
318         uint qiuAmount = msg.value * eth2qiuRate / 1000000000000000000;
319         require(qiuAmount <= balances[this]);
320         balances[this] = balances[this].sub(qiuAmount);
321         balances[msg.sender] = balances[msg.sender].add(qiuAmount);
322         ExchangeForQIU(this,msg.sender,qiuAmount,msg.value);
323         return true;
324     }
325 
326     /*
327     // transfer out method
328     function ownerETHCashout(address account) public onlyOwner {
329         account.transfer(this.balance);
330     }*/
331     function getETHBalance() public view returns (uint) {
332         return this.balance; // balance is "inherited" from the address type
333     }
334 }
335 
336 contract SoccerGamblingV_QIU is Ownable {
337 
338     using SafeMath for uint;
339 
340     struct BettingInfo {
341         uint id;
342         address bettingOwner;
343         bool buyHome;
344         bool buyAway;
345         bool buyDraw;
346         uint bettingAmount;
347     }
348     
349     struct GamblingPartyInfo {
350         uint id;
351         address dealerAddress; // The address of the inital founder
352         uint homePayRate;
353         uint awayPayRate;
354         uint drawPayRate;
355         uint payRateScale;
356         uint bonusPool; // count by wei
357         uint baseBonusPool;
358         int finalScoreHome;
359         int finalScoreAway;
360         bool isEnded;
361         bool isLockedForBet;
362         BettingInfo[] bettingsInfo;
363     }
364 
365     mapping (uint => GamblingPartyInfo) public gamblingPartiesInfo;
366     mapping (uint => uint[]) public matchId2PartyId;
367     uint private _nextGamblingPartyId;
368     uint private _nextBettingInfoId;
369     QIUToken public _internalToken;
370 
371     uint private _commissionNumber;
372     uint private _commissionScale;
373     
374 
375     function SoccerGamblingV_QIU(QIUToken _tokenAddress) public {
376         _nextGamblingPartyId = 0;
377         _nextBettingInfoId = 0;
378         _internalToken = _tokenAddress;
379         _commissionNumber = 2;
380         _commissionScale = 100;
381     }
382 
383     function modifyCommission(uint number,uint scale) public onlyOwner returns(bool){
384         _commissionNumber = number;
385         _commissionScale = scale;
386         return true;
387     }
388 
389     function _availableBetting(uint gamblingPartyId,uint8 buySide,uint bettingAmount) private view returns(bool) {
390         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
391         uint losePay = 0;
392         if (buySide==0)
393             losePay = losePay.add((gpInfo.homePayRate.mul(bettingAmount)).div(gpInfo.payRateScale));
394         else if (buySide==1)
395             losePay = losePay.add((gpInfo.awayPayRate.mul(bettingAmount)).div(gpInfo.payRateScale));
396         else if (buySide==2)
397             losePay = losePay.add((gpInfo.drawPayRate.mul(bettingAmount)).div(gpInfo.payRateScale));
398         uint mostPay = 0;
399         for (uint idx = 0; idx<gpInfo.bettingsInfo.length; idx++) {
400             BettingInfo storage bInfo = gpInfo.bettingsInfo[idx];
401             if (bInfo.buyHome && (buySide==0))
402                 mostPay = mostPay.add((gpInfo.homePayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale));
403             else if (bInfo.buyAway && (buySide==1))
404                 mostPay = mostPay.add((gpInfo.awayPayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale));
405             else if (bInfo.buyDraw && (buySide==2))
406                 mostPay = mostPay.add((gpInfo.drawPayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale));
407         }
408         if (mostPay + losePay > gpInfo.bonusPool)
409             return false;
410         else 
411             return true;
412     }
413 
414     event NewBettingSucceed(address fromAddr,uint newBettingInfoId);
415     function betting(uint gamblingPartyId,uint8 buySide,uint bettingAmount) public {
416         require(bettingAmount > 0);
417         require(_internalToken.balanceOf(msg.sender) >= bettingAmount);
418         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
419         require(gpInfo.isEnded == false);
420         require(gpInfo.isLockedForBet == false);
421         require(_availableBetting(gamblingPartyId, buySide, bettingAmount));
422         BettingInfo memory bInfo;
423         bInfo.id = _nextBettingInfoId;
424         bInfo.bettingOwner = msg.sender;
425         bInfo.buyHome = false;
426         bInfo.buyAway = false;
427         bInfo.buyDraw = false;
428         bInfo.bettingAmount = bettingAmount;
429         if (buySide == 0)
430             bInfo.buyHome = true;
431         if (buySide == 1)
432             bInfo.buyAway = true;
433         if (buySide == 2)
434             bInfo.buyDraw = true;
435         _internalToken.originTransfer(this,bettingAmount);
436         gpInfo.bettingsInfo.push(bInfo);
437         _nextBettingInfoId++;
438         gpInfo.bonusPool = gpInfo.bonusPool.add(bettingAmount);
439         NewBettingSucceed(msg.sender,bInfo.id);
440     }
441 
442     function remainingBettingFor(uint gamblingPartyId) public view returns
443         (uint remainingAmountHome,
444          uint remainingAmountAway,
445          uint remainingAmountDraw
446         ) {
447         for (uint8 buySide = 0;buySide<3;buySide++){
448             GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
449             uint bonusPool = gpInfo.bonusPool;
450             for (uint idx = 0; idx<gpInfo.bettingsInfo.length; idx++) {
451                 BettingInfo storage bInfo = gpInfo.bettingsInfo[idx];
452                 if (bInfo.buyHome && (buySide==0))
453                     bonusPool = bonusPool.sub((gpInfo.homePayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale));
454                 else if (bInfo.buyAway && (buySide==1))
455                     bonusPool = bonusPool.sub((gpInfo.awayPayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale));
456                 else if (bInfo.buyDraw && (buySide==2))
457                     bonusPool = bonusPool.sub((gpInfo.drawPayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale));
458             }
459             if (buySide == 0)
460                 remainingAmountHome = (bonusPool.mul(gpInfo.payRateScale)).div(gpInfo.homePayRate);
461             else if (buySide == 1)
462                 remainingAmountAway = (bonusPool.mul(gpInfo.payRateScale)).div(gpInfo.awayPayRate);
463             else if (buySide == 2)
464                 remainingAmountDraw = (bonusPool.mul(gpInfo.payRateScale)).div(gpInfo.drawPayRate);
465         }
466     }
467 
468     event MatchAllGPsLock(address fromAddr,uint matchId,bool isLocked);
469     function lockUnlockMatchGPForBetting(uint matchId,bool lock) public {
470         uint[] storage gamblingPartyIds = matchId2PartyId[matchId];
471         for (uint idx = 0;idx < gamblingPartyIds.length;idx++) {
472             lockUnlockGamblingPartyForBetting(gamblingPartyIds[idx],lock);
473         }
474         MatchAllGPsLock(msg.sender,matchId,lock);        
475     }
476 
477     function lockUnlockGamblingPartyForBetting(uint gamblingPartyId,bool lock) public onlyOwner {
478         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
479         gpInfo.isLockedForBet = lock;
480     }
481 
482     function getGamblingPartyInfo(uint gamblingPartyId) public view returns (uint gpId,
483                                                                             address dealerAddress,
484                                                                             uint homePayRate,
485                                                                             uint awayPayRate,
486                                                                             uint drawPayRate,
487                                                                             uint payRateScale,
488                                                                             uint bonusPool,
489                                                                             int finalScoreHome,
490                                                                             int finalScoreAway,
491                                                                             bool isEnded) 
492     {
493 
494         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
495         gpId = gpInfo.id;
496         dealerAddress = gpInfo.dealerAddress; // The address of the inital founder
497         homePayRate = gpInfo.homePayRate;
498         awayPayRate = gpInfo.awayPayRate;
499         drawPayRate = gpInfo.drawPayRate;
500         payRateScale = gpInfo.payRateScale;
501         bonusPool = gpInfo.bonusPool; // count by wei
502         finalScoreHome = gpInfo.finalScoreHome;
503         finalScoreAway = gpInfo.finalScoreAway;
504         isEnded = gpInfo.isEnded;
505     }
506 
507     //in this function, I removed the extra return value to fix the compiler exception caused by solidity limitation 
508     //exception is: CompilerError: Stack too deep, try removing local variables.
509     //to get the extra value for the gambingParty , need to invoke the method getGamblingPartyInfo
510     function getGamblingPartySummarizeInfo(uint gamblingPartyId) public view returns(
511         uint gpId,
512         //uint salesAmount,
513         uint homeSalesAmount,
514         int  homeSalesEarnings,
515         uint awaySalesAmount,
516         int  awaySalesEarnings,
517         uint drawSalesAmount,
518         int  drawSalesEarnings,
519         int  dealerEarnings,
520         uint baseBonusPool
521     ){
522         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
523         gpId = gpInfo.id;
524         baseBonusPool = gpInfo.baseBonusPool;
525         for (uint idx = 0; idx < gpInfo.bettingsInfo.length; idx++) {
526             BettingInfo storage bInfo = gpInfo.bettingsInfo[idx];
527             if (bInfo.buyHome){
528                 homeSalesAmount += bInfo.bettingAmount;
529                 if (gpInfo.isEnded && (gpInfo.finalScoreHome > gpInfo.finalScoreAway)){
530                     homeSalesEarnings = homeSalesEarnings - int(bInfo.bettingAmount*gpInfo.homePayRate/gpInfo.payRateScale);
531                 }else
532                     homeSalesEarnings += int(bInfo.bettingAmount);
533             } else if (bInfo.buyAway){
534                 awaySalesAmount += bInfo.bettingAmount;
535                 if (gpInfo.isEnded && (gpInfo.finalScoreHome < gpInfo.finalScoreAway)){
536                     awaySalesEarnings = awaySalesEarnings - int(bInfo.bettingAmount*gpInfo.awayPayRate/gpInfo.payRateScale);
537                 }else
538                     awaySalesEarnings += int(bInfo.bettingAmount);
539             } else if (bInfo.buyDraw){
540                 drawSalesAmount += bInfo.bettingAmount;
541                 if (gpInfo.isEnded && (gpInfo.finalScoreHome == gpInfo.finalScoreAway)){
542                     drawSalesEarnings = drawSalesEarnings - int(bInfo.bettingAmount*gpInfo.drawPayRate/gpInfo.payRateScale);
543                 }else
544                     drawSalesEarnings += int(bInfo.bettingAmount);
545             }
546         }
547         int commission;    
548         if(gpInfo.isEnded){
549             dealerEarnings = int(gpInfo.bonusPool);
550         }else{
551             dealerEarnings = int(gpInfo.bonusPool);
552             return;
553         }
554         if (homeSalesEarnings > 0){
555             commission = homeSalesEarnings * int(_commissionNumber) / int(_commissionScale);
556             homeSalesEarnings -= commission;
557         }
558         if (awaySalesEarnings > 0){
559             commission = awaySalesEarnings * int(_commissionNumber) / int(_commissionScale);
560             awaySalesEarnings -= commission;
561         }
562         if (drawSalesEarnings > 0){
563             commission = drawSalesEarnings * int(_commissionNumber) / int(_commissionScale);
564             drawSalesEarnings -= commission;
565         }
566         if (homeSalesEarnings < 0)
567             dealerEarnings = int(gpInfo.bonusPool) + homeSalesEarnings;
568         if (awaySalesEarnings < 0)
569             dealerEarnings = int(gpInfo.bonusPool) + awaySalesEarnings;
570         if (drawSalesEarnings < 0)
571             dealerEarnings = int(gpInfo.bonusPool) + drawSalesEarnings;
572         commission = dealerEarnings * int(_commissionNumber) / int(_commissionScale);
573         dealerEarnings -= commission;
574     }
575 
576     function getMatchSummarizeInfo(uint matchId) public view returns (
577                                                             uint mSalesAmount,
578                                                             uint mHomeSalesAmount,
579                                                             uint mAwaySalesAmount,
580                                                             uint mDrawSalesAmount,
581                                                             int mDealerEarnings,
582                                                             uint mBaseBonusPool
583                                                         )
584     {
585         for (uint idx = 0; idx<matchId2PartyId[matchId].length; idx++) {
586             uint gamblingPartyId = matchId2PartyId[matchId][idx];
587             var (,homeSalesAmount,,awaySalesAmount,,drawSalesAmount,,dealerEarnings,baseBonusPool) = getGamblingPartySummarizeInfo(gamblingPartyId);
588             mHomeSalesAmount += homeSalesAmount;
589             mAwaySalesAmount += awaySalesAmount;
590             mDrawSalesAmount += drawSalesAmount;
591             mSalesAmount += homeSalesAmount + awaySalesAmount + drawSalesAmount;
592             mDealerEarnings += dealerEarnings;
593             mBaseBonusPool = baseBonusPool;
594         }
595     }
596 
597     function getSumOfGamblingPartiesBonusPool(uint matchId) public view returns (uint) {
598         uint sum = 0;
599         for (uint idx = 0; idx<matchId2PartyId[matchId].length; idx++) {
600             uint gamblingPartyId = matchId2PartyId[matchId][idx];
601             GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
602             sum += gpInfo.bonusPool;
603         }
604         return sum;
605     }
606 
607     function getWinLoseAmountByBettingOwnerInGamblingParty(uint gamblingPartyId,address bettingOwner) public view returns (int) {
608         int winLose = 0;
609         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
610         require(gpInfo.isEnded);
611         for (uint idx = 0; idx < gpInfo.bettingsInfo.length; idx++) {
612             BettingInfo storage bInfo = gpInfo.bettingsInfo[idx];
613             if (bInfo.bettingOwner == bettingOwner) {
614                 if ((gpInfo.finalScoreHome > gpInfo.finalScoreAway) && (bInfo.buyHome)) {
615                     winLose += int(gpInfo.homePayRate * bInfo.bettingAmount / gpInfo.payRateScale);
616                 } else if ((gpInfo.finalScoreHome < gpInfo.finalScoreAway) && (bInfo.buyAway)) {
617                     winLose += int(gpInfo.awayPayRate * bInfo.bettingAmount / gpInfo.payRateScale);
618                 } else if ((gpInfo.finalScoreHome == gpInfo.finalScoreAway) && (bInfo.buyDraw)) {
619                     winLose += int(gpInfo.drawPayRate * bInfo.bettingAmount / gpInfo.payRateScale);
620                 } else {
621                     winLose -= int(bInfo.bettingAmount);
622                 }
623             }
624         }   
625         if (winLose > 0){
626             int commission = winLose * int(_commissionNumber) / int(_commissionScale);
627             winLose -= commission;
628         }
629         return winLose;
630     }
631 
632     function getWinLoseAmountByBettingIdInGamblingParty(uint gamblingPartyId,uint bettingId) public view returns (int) {
633         int winLose = 0;
634         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
635         require(gpInfo.isEnded);
636         for (uint idx = 0; idx < gpInfo.bettingsInfo.length; idx++) {
637             BettingInfo storage bInfo = gpInfo.bettingsInfo[idx];
638             if (bInfo.id == bettingId) {
639                 if ((gpInfo.finalScoreHome > gpInfo.finalScoreAway) && (bInfo.buyHome)) {
640                     winLose += int(gpInfo.homePayRate * bInfo.bettingAmount / gpInfo.payRateScale);
641                 } else if ((gpInfo.finalScoreHome < gpInfo.finalScoreAway) && (bInfo.buyAway)) {
642                     winLose += int(gpInfo.awayPayRate * bInfo.bettingAmount / gpInfo.payRateScale);
643                 } else if ((gpInfo.finalScoreHome == gpInfo.finalScoreAway) && (bInfo.buyDraw)) {
644                     winLose += int(gpInfo.drawPayRate * bInfo.bettingAmount / gpInfo.payRateScale);
645                 } else {
646                     winLose -= int(bInfo.bettingAmount);
647                 }
648                 break;
649             }
650         }   
651         if (winLose > 0){
652             int commission = winLose * int(_commissionNumber) / int(_commissionScale);
653             winLose -= commission;
654         }
655         return winLose;
656     }
657 
658     event NewGamblingPartyFounded(address fromAddr,uint newGPId);
659     function foundNewGamblingParty(
660         uint matchId,
661         uint homePayRate,
662         uint awayPayRate,
663         uint drawPayRate,
664         uint payRateScale,
665         uint basePool
666         ) public
667         {
668         address sender = msg.sender;
669         require(basePool > 0);
670         require(_internalToken.balanceOf(sender) >= basePool);
671         uint newId = _nextGamblingPartyId;
672         gamblingPartiesInfo[newId].id = newId;
673         gamblingPartiesInfo[newId].dealerAddress = sender;
674         gamblingPartiesInfo[newId].homePayRate = homePayRate;
675         gamblingPartiesInfo[newId].awayPayRate = awayPayRate;
676         gamblingPartiesInfo[newId].drawPayRate = drawPayRate;
677         gamblingPartiesInfo[newId].payRateScale = payRateScale;
678         gamblingPartiesInfo[newId].bonusPool = basePool;
679         gamblingPartiesInfo[newId].baseBonusPool = basePool;
680         gamblingPartiesInfo[newId].finalScoreHome = -1;
681         gamblingPartiesInfo[newId].finalScoreAway = -1;
682         gamblingPartiesInfo[newId].isEnded = false;
683         gamblingPartiesInfo[newId].isLockedForBet = false;
684         _internalToken.originTransfer(this,basePool);
685         matchId2PartyId[matchId].push(gamblingPartiesInfo[newId].id);
686         _nextGamblingPartyId++;
687         NewGamblingPartyFounded(sender,newId);//fire event
688     }
689 
690     event MatchAllGPsEnded(address fromAddr,uint matchId);
691     function endMatch(uint matchId,int homeScore,int awayScore) public {
692         uint[] storage gamblingPartyIds = matchId2PartyId[matchId];
693         for (uint idx = 0;idx < gamblingPartyIds.length;idx++) {
694             endGamblingParty(gamblingPartyIds[idx],homeScore,awayScore);
695         }
696         MatchAllGPsEnded(msg.sender,matchId);        
697     }
698 
699     event GamblingPartyEnded(address fromAddr,uint gamblingPartyId);
700     function endGamblingParty(uint gamblingPartyId,int homeScore,int awayScore) public onlyOwner {
701         GamblingPartyInfo storage gpInfo = gamblingPartiesInfo[gamblingPartyId];
702         require(!gpInfo.isEnded);
703         gpInfo.finalScoreHome = homeScore;
704         gpInfo.finalScoreAway = awayScore;
705         gpInfo.isEnded = true;
706         int flag = -1;
707         if (homeScore > awayScore)
708             flag = 0;
709         else if (homeScore < awayScore)
710             flag = 1;
711         else
712             flag = 2;
713         uint commission; // variable for commission caculation.
714         uint bonusPool = gpInfo.bonusPool;
715         for (uint idx = 0; idx < gpInfo.bettingsInfo.length; idx++) {
716             BettingInfo storage bInfo = gpInfo.bettingsInfo[idx];
717             uint transferAmount = 0;
718             if (flag == 0 && bInfo.buyHome)
719                 transferAmount = (gpInfo.homePayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale);
720             if (flag == 1 && bInfo.buyAway)
721                 transferAmount = (gpInfo.awayPayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale);
722             if (flag == 2 && bInfo.buyDraw)
723                 transferAmount = (gpInfo.drawPayRate.mul(bInfo.bettingAmount)).div(gpInfo.payRateScale);
724             if (transferAmount != 0) {
725                 bonusPool = bonusPool.sub(transferAmount);
726                 commission = (transferAmount.mul(_commissionNumber)).div(_commissionScale);
727                 transferAmount = transferAmount.sub(commission);
728                 _internalToken.ownerTransferFrom(this,bInfo.bettingOwner,transferAmount);
729                 _internalToken.ownerTransferFrom(this,owner,commission);
730             }
731         }    
732         if (bonusPool > 0) {
733             uint amount = bonusPool;
734             // subs the commission
735             commission = (amount.mul(_commissionNumber)).div(_commissionScale);
736             amount = amount.sub(commission);
737             _internalToken.ownerTransferFrom(this,gpInfo.dealerAddress,amount);
738             _internalToken.ownerTransferFrom(this,owner,commission);
739         }
740         GamblingPartyEnded(msg.sender,gpInfo.id);
741     }
742 
743     function getETHBalance() public view returns (uint) {
744         return this.balance; // balance is "inherited" from the address type
745     }
746 }