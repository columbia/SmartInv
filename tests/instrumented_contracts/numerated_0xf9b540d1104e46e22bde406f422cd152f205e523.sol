1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes  _extraData) external; 
5 }
6 
7 interface CitizenInterface {
8     function pushGametRefIncome(address _sender) external payable;
9     function pushGametRefIncomeToken(address _sender, uint256 _amount) external;
10     function addGameWinIncome(address _citizen, uint256 _value, bool _enough) external;
11     function addGameEthSpendWin(address _citizen, uint256 _value, uint256 _valuewin, bool _enough) external;
12 }
13 
14 library SafeMath {
15     int256 constant private INT256_MIN = -2**255;
16 
17     /**
18     * @dev Multiplies two unsigned integers, reverts on overflow.
19     */
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22         // benefit is lost if 'b' is also tested.
23         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b);
30 
31         return c;
32     }
33 
34     /**
35     * @dev Multiplies two signed integers, reverts on overflow.
36     */
37     function mul(int256 a, int256 b) internal pure returns (int256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
46 
47         int256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
67     */
68     function div(int256 a, int256 b) internal pure returns (int256) {
69         require(b != 0); // Solidity only automatically asserts when dividing by 0
70         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
71 
72         int256 c = a / b;
73 
74         return c;
75     }
76 
77     /**
78     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
79     */
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88     * @dev Subtracts two signed integers, reverts on overflow.
89     */
90     function sub(int256 a, int256 b) internal pure returns (int256) {
91         int256 c = a - b;
92         require((b >= 0 && c <= a) || (b < 0 && c > a));
93 
94         return c;
95     }
96 
97     /**
98     * @dev Adds two unsigned integers, reverts on overflow.
99     */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a);
103 
104         return c;
105     }
106 
107     /**
108     * @dev Adds two signed integers, reverts on overflow.
109     */
110     function add(int256 a, int256 b) internal pure returns (int256) {
111         int256 c = a + b;
112         require((b >= 0 && c >= a) || (b < 0 && c < a));
113 
114         return c;
115     }
116 
117     /**
118     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
119     * reverts when dividing by zero.
120     */
121     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b != 0);
123         return a % b;
124     }
125 }
126 
127 contract TokenDAA {
128     
129     modifier onlyCoreContract() {
130         require(isCoreContract[msg.sender], "admin required");
131         _;
132     }
133     
134     modifier onlyAdmin() {
135         require(msg.sender == devTeam1, "admin required");
136         _;
137     }
138     
139     using SafeMath for *;
140     // Public variables of the token
141     string public name;
142     string public symbol;
143     uint8 public decimals = 10;
144     uint256 public totalSupply;
145     uint256 public totalSupplyBurned;
146     uint256 public unitRate;
147     // This creates an array with all balances
148     mapping (address => uint256) public balanceOf;
149     mapping (address => uint256) public totalSupplyByAddress;
150     mapping (address => mapping (address => uint256)) public allowance;
151     
152     // Mining Token
153     uint256 public HARD_TOTAL_SUPPLY = 20000000;
154     uint256 public HARD_TOTAL_SUPPLY_BY_LEVEL = 200000;
155     uint8 public MAX_LEVEL = 9;
156     uint8 public MAX_ROUND = 10;
157     uint256[10] public ETH_WIN = [uint(55),60,65,70,75,80,85,90,95,100]; // take 3 demical rest is 15
158     uint256[10] public ETH_LOSE = [uint(50),55,60,65,70,75,80,85,90,95]; // take 3 demical rest is 15
159     uint8 public currentRound = 1;
160     uint8 public currentLevel = 0;
161     mapping (uint256 => mapping(uint256 =>uint256)) public totalSupplyByLevel;
162 
163     // Event
164     event Transfer(address indexed from, address indexed to, uint256 value);
165     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
166     event Burn(address indexed from, uint256 value, uint256 creationDate);
167     
168     // Contract
169     mapping (address => bool) public isCoreContract;
170     uint256 public coreContractSum;
171     address[] public coreContracts;
172     CitizenInterface CitizenContract;
173     address devTeam1;
174     address devTeam2;
175     address devTeam3;
176     address devTeam4;
177     
178     // Freeze Tokens
179     uint256 LIMIT_FREEZE_TOKEN = 10;
180  
181 
182     struct Profile{
183         uint256 citizenBalanceToken;
184         uint256 citizenBalanceEth;
185         mapping(uint256=>uint256) citizenFrozenBalance;
186         uint256 lastDividendPulledRound;
187     }
188 
189     uint256 public currentRoundDividend=1;
190     struct DividendRound{
191         uint256 totalEth;
192         uint256 totalEthCredit;
193         uint256 totalToken;
194         uint256 totalTokenCredit;
195         uint256 totalFrozenBalance;
196         uint256 endRoundTime;
197     }
198     uint8 public BURN_TOKEN_PERCENT = 50;
199     uint8 public DIVIDEND_FOR_CURRENT_PERCENT = 70;
200     uint8 public DIVIDEND_KEEP_NEXT_PERCENT = 30;
201     uint256 public NEXT_DEVIDEND_ROUND= 1209600; // 2 week = 1209600 seconds
202     uint256 public clockDevidend;
203     
204     mapping (uint256 => DividendRound) public dividendRound;
205     mapping (address => Profile) public citizen;
206     
207 
208     /**
209      * Constructor function
210      *
211      * Initializes contract with initial supply tokens to the creator of the contract
212      */
213      
214     constructor(address[4] _devTeam) public {
215         // totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
216         totalSupply = 0;
217         unitRate = 10 ** uint256(decimals);
218         HARD_TOTAL_SUPPLY = HARD_TOTAL_SUPPLY.mul(unitRate);
219         HARD_TOTAL_SUPPLY_BY_LEVEL = HARD_TOTAL_SUPPLY_BY_LEVEL.mul(unitRate);
220         LIMIT_FREEZE_TOKEN = LIMIT_FREEZE_TOKEN.mul(unitRate);
221         
222         for (uint i = 0; i < ETH_WIN.length; i++){
223             ETH_WIN[i] = ETH_WIN[i].mul(10 ** uint256(15));
224             ETH_LOSE[i]= ETH_LOSE[i].mul(10 ** uint256(15));
225         }
226         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
227         name = "DABANKING";                                   // Set the name for display purposes
228         symbol = "DAA";                               // Set the symbol for display purposes
229         clockDevidend = 1561899600;
230         
231         devTeam1 = _devTeam[0];
232         devTeam2 = _devTeam[1];
233         devTeam3 = _devTeam[2];
234         devTeam4 = _devTeam[3];
235     }
236     
237 
238     // DAAContract, TicketContract, CitizenContract 
239     function joinNetwork(address[3] _contract)
240         public
241     {
242         require(address(CitizenContract) == 0x0,"already setup");
243         CitizenContract = CitizenInterface(_contract[2]);
244         for(uint256 i =0; i<3; i++){
245             isCoreContract[_contract[i]]=true;
246             coreContracts.push(_contract[i]);
247         }
248         coreContractSum = 3;
249     }
250     
251     function changeDev4(address _address) public onlyAdmin(){
252         require(_address!=0x0,"Invalid address");
253         devTeam4 = _address;
254     }
255 
256     function addCoreContract(address _address) public  // [dev1]
257         onlyAdmin()
258     {
259         require(_address!=0x0,"Invalid address");
260         isCoreContract[_address] = true;
261         coreContracts.push(_address);
262         coreContractSum+=1;
263     }
264     
265     function balanceOf(address _sender) public view returns(uint256) {
266         return balanceOf[_sender] - citizen[_sender].citizenFrozenBalance[currentRoundDividend];
267     }  
268     
269     function getBalanceOf(address _sender) public view returns(uint256) {
270         return balanceOf[_sender] - citizen[_sender].citizenFrozenBalance[currentRoundDividend];
271     } 
272 
273     /**
274      * Internal transfer, only can be called by this contract
275      */
276     function _transfer(address _from, address _to, uint _value) internal {
277         // Prevent transfer to 0x0 address. Use burn() instead
278         require(_to != address(0x0));
279         // Check if the sender has enough
280         require(getBalanceOf(_from) >= _value);
281         // Check for overflows
282         require(balanceOf[_to] + _value >= balanceOf[_to]);
283         // Save this for an assertion in the future
284         uint previousBalances = balanceOf[_from] + balanceOf[_to];
285         // Subtract from the sender
286         balanceOf[_from] -= _value;
287         // Add the same to the recipient
288         balanceOf[_to] += _value;
289         if (_to == address(this)){
290             citizen[msg.sender].citizenBalanceToken += _value;
291         }
292 
293         emit Transfer(_from, _to, _value);
294         // Asserts are used to use static analysis to find bugs in your code. They should never fail
295         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
296     }
297 
298     function citizenFreeze(uint _value) public returns (bool success) {
299         require(balanceOf[msg.sender]-citizen[msg.sender].citizenFrozenBalance[currentRoundDividend]>= _value);
300         require(citizen[msg.sender].citizenFrozenBalance[currentRoundDividend] + _value >= LIMIT_FREEZE_TOKEN,"Must over than limit");
301         citizen[msg.sender].citizenFrozenBalance[currentRoundDividend] += _value;
302         dividendRound[currentRoundDividend].totalFrozenBalance += _value;
303         return true;
304     }
305     
306     function citizenUnfreeze() public returns (bool success) {
307         require(citizen[msg.sender].citizenFrozenBalance[currentRoundDividend]>0);
308         dividendRound[currentRoundDividend].totalFrozenBalance -= citizen[msg.sender].citizenFrozenBalance[currentRoundDividend];
309         citizen[msg.sender].citizenFrozenBalance[currentRoundDividend]=0;
310         return true;
311     }
312     
313     function getCitizenFreezing(address _sender) public view returns(uint256){
314         return citizen[_sender].citizenFrozenBalance[currentRoundDividend];
315     }    
316     
317     function getCitizenFreezingBuyRound(address _sender, uint256 _round) public view returns(uint256){
318         return citizen[_sender].citizenFrozenBalance[_round];
319     } 
320     
321     function getCitizenDevidendBuyRound(address _sender, uint256 _round) public view returns(uint256){
322         uint256 _totalEth = dividendRound[_round].totalEth;
323         if (dividendRound[_round].totalEthCredit==0&&dividendRound[_round].totalFrozenBalance>0){
324             return _totalEth*citizen[_sender].citizenFrozenBalance[_round]/dividendRound[_round].totalFrozenBalance;
325         }
326         return 0;
327     }
328     
329     function getDividendView(address _sender) public view returns(uint256){
330         uint256 _last_round = citizen[_sender].lastDividendPulledRound;
331         if (_last_round + 100 < currentRoundDividend) _last_round = currentRoundDividend - 100;
332         uint256 _sum;
333         uint256 _citizen_fronzen;
334         uint256 _totalEth;
335         for (uint256 i = _last_round;i<currentRoundDividend;i++){
336             _totalEth = dividendRound[i].totalEth;
337             if (dividendRound[i].totalEthCredit==0&&dividendRound[i].totalFrozenBalance>0){
338                 _citizen_fronzen = citizen[_sender].citizenFrozenBalance[i];
339                 _sum = _sum.add(_totalEth.mul(_citizen_fronzen).div(dividendRound[i].totalFrozenBalance));
340             }
341         }
342         return _sum;
343     }
344     
345     function getDividendPull(address _sender, uint256 _value) public returns(uint256){
346         uint256 _last_round = citizen[_sender].lastDividendPulledRound;
347         if (_last_round + 100 < currentRoundDividend) _last_round = currentRoundDividend - 100;
348         uint256 _sum;
349         uint256 _citizen_fronzen;
350         uint256 _totalEth;
351         for (uint256 i = _last_round;i<currentRoundDividend;i++){
352             _totalEth = dividendRound[i].totalEth;
353             if (dividendRound[i].totalEthCredit==0&&dividendRound[i].totalFrozenBalance>0){
354                 _citizen_fronzen = citizen[_sender].citizenFrozenBalance[i];
355                 _sum = _sum.add(_totalEth.mul(_citizen_fronzen).div(dividendRound[i].totalFrozenBalance));
356             }
357         }
358         if (_value.add(_sum)==0){
359             require(dividendRound[currentRoundDividend].totalEthCredit==0);   
360         }
361         if (citizen[_sender].citizenBalanceEth>0&&dividendRound[currentRoundDividend].totalEthCredit==0){
362             _sum = _sum.add(citizen[_sender].citizenBalanceEth);
363             citizen[_sender].citizenBalanceEth = 0;
364         }
365         _sender.transfer(_sum);
366         citizen[_sender].lastDividendPulledRound = currentRoundDividend;
367         return _sum;
368     }
369     
370     // automatic after 2 share 70% weeks keep 30% next round [dev4]
371     function endDividendRound() public {
372         require(msg.sender==devTeam4);
373         require(now>clockDevidend);
374         dividendRound[currentRoundDividend].endRoundTime = now;
375         uint256 _for_next_round;
376         if (dividendRound[currentRoundDividend].totalEthCredit>0){
377             // mean totalEth is <0
378             _for_next_round = dividendRound[currentRoundDividend].totalEth;
379            dividendRound[currentRoundDividend+1].totalEth = _for_next_round;
380            dividendRound[currentRoundDividend+1].totalEthCredit = dividendRound[currentRoundDividend].totalEthCredit;
381         }
382         else{
383             _for_next_round = dividendRound[currentRoundDividend].totalEth*DIVIDEND_KEEP_NEXT_PERCENT/100;
384             dividendRound[currentRoundDividend].totalEth = dividendRound[currentRoundDividend].totalEth*DIVIDEND_FOR_CURRENT_PERCENT/100;
385             dividendRound[currentRoundDividend+1].totalEth = _for_next_round;
386         }
387         if (dividendRound[currentRoundDividend].totalTokenCredit>0){
388             dividendRound[currentRoundDividend+1].totalToken = dividendRound[currentRoundDividend].totalToken;
389             dividendRound[currentRoundDividend+1].totalTokenCredit = dividendRound[currentRoundDividend].totalTokenCredit;
390         }
391         else{
392             // Burn 50% token
393             _for_next_round = dividendRound[currentRoundDividend].totalToken*BURN_TOKEN_PERCENT/100;
394             dividendRound[currentRoundDividend+1].totalToken = _for_next_round;
395             burnFrom(address(this),_for_next_round);
396             burnFrom(devTeam2,_for_next_round*4/6);
397             // balanceOf[address(this)] = balanceOf[address(this)].sub(_for_next_round);
398             // balanceOf[devTeam2] = balanceOf[devTeam2].sub();
399             // totalSupply = totalSupply.sub(_for_next_round*10/6);
400         }
401         currentRoundDividend+=1;
402         clockDevidend= clockDevidend.add(NEXT_DEVIDEND_ROUND);
403     }
404     
405     // share 100% dividen [dev 1]
406     function nextDividendRound() onlyAdmin() public {
407         require(dividendRound[currentRoundDividend].totalEth>0);
408         dividendRound[currentRoundDividend].endRoundTime = now;
409         currentRoundDividend+=1;
410         // clockDevidend = clockDevidend.add(NEXT_DEVIDEND_ROUND);
411     }
412     
413     
414     function citizenDeposit(uint _value) public returns (bool success) {
415         require(getBalanceOf(msg.sender)>=_value);
416         _transfer(msg.sender, address(this), _value);
417         return true;
418     }
419     
420     function citizenUseDeposit(address _citizen, uint _value) onlyCoreContract() public{
421         require(citizen[_citizen].citizenBalanceToken >= _value,"Not enough Token");
422         dividendRound[currentRoundDividend].totalToken += _value;
423         if (dividendRound[currentRoundDividend].totalToken>dividendRound[currentRoundDividend].totalTokenCredit&&dividendRound[currentRoundDividend].totalTokenCredit>0){
424             dividendRound[currentRoundDividend].totalToken = dividendRound[currentRoundDividend].totalToken.sub(dividendRound[currentRoundDividend].totalTokenCredit);
425             dividendRound[currentRoundDividend].totalTokenCredit=0;
426         }
427         citizen[_citizen].citizenBalanceToken-=_value;
428     }
429     
430     function pushDividend() public payable{
431         uint256 _value = msg.value;
432         dividendRound[currentRoundDividend].totalEth = dividendRound[currentRoundDividend].totalEth.add(_value);
433         if (dividendRound[currentRoundDividend].totalEth>dividendRound[currentRoundDividend].totalEthCredit&&dividendRound[currentRoundDividend].totalEthCredit>0){
434             dividendRound[currentRoundDividend].totalEth = dividendRound[currentRoundDividend].totalEth.sub(dividendRound[currentRoundDividend].totalEthCredit);
435             dividendRound[currentRoundDividend].totalEthCredit=0;
436         }
437     }
438     
439     function payOut(address _winner, uint256 _unit, uint256 _value, uint256 _valuebet) onlyCoreContract() public{
440         if (_unit==0){
441             citizenMintToken(_winner,_valuebet,1);
442             if (dividendRound[currentRoundDividend].totalEth<_value){
443                 // ghi no citizen 
444                 citizen[_winner].citizenBalanceEth+=_value;
445                 CitizenContract.addGameEthSpendWin(_winner, _valuebet, _value, false);
446                 dividendRound[currentRoundDividend].totalEthCredit+=_value;
447             }
448             else{
449                 _winner.transfer(_value);
450                 CitizenContract.addGameEthSpendWin(_winner, _valuebet, _value, true);
451                 dividendRound[currentRoundDividend].totalEth = dividendRound[currentRoundDividend].totalEth.sub(_value);
452             }
453         }
454         else{
455             if (dividendRound[currentRoundDividend].totalToken<_value){
456                 dividendRound[currentRoundDividend].totalTokenCredit += _value;
457                 citizen[_winner].citizenBalanceToken+=_value;
458             }
459             else {
460                 dividendRound[currentRoundDividend].totalToken -= _value;
461                 citizen[_winner].citizenBalanceToken+=_value;
462             }
463         }
464     }
465     
466     // Tomorrow
467     function pushGameRefIncome(address _sender,uint256 _unit, uint256 _value) public onlyCoreContract(){
468         if (_unit==1){
469             dividendRound[currentRoundDividend].totalEth = dividendRound[currentRoundDividend].totalEth.sub(_value);
470             CitizenContract.pushGametRefIncome.value(_value)(_sender);
471         }else{
472             CitizenContract.pushGametRefIncomeToken(_sender,_value);
473         }
474         
475     }
476 
477     function citizenWithdrawDeposit(uint _value) public returns (bool success){
478         require(citizen[msg.sender].citizenBalanceToken >=_value);
479         _transfer(address(this),msg.sender,_value);
480         citizen[msg.sender].citizenBalanceToken-=_value;
481         return true;
482     }
483     
484     function ethToToken(uint256 _ethAmount, int8 _is_win) private view returns(uint256){
485         if (_is_win==1) {
486             return uint256(_ethAmount) * unitRate / uint256(ETH_WIN[currentLevel]);}
487         return _ethAmount * unitRate / uint256(ETH_LOSE[currentLevel]) ;
488     }    
489 
490     function citizenMintToken(address _buyer, uint256 _buyPrice, int8 _is_win) public onlyCoreContract() returns(uint256) {
491         uint256 revTokens = ethToToken( _buyPrice, _is_win);
492 
493         if (revTokens*10/6 + totalSupplyByLevel[currentRound][currentLevel] > HARD_TOTAL_SUPPLY_BY_LEVEL){
494             uint256 revTokenCurrentLevel = HARD_TOTAL_SUPPLY_BY_LEVEL.sub(totalSupplyByLevel[currentRound][currentLevel]);
495             revTokenCurrentLevel = revTokenCurrentLevel*6/10;
496             balanceOf[_buyer]= balanceOf[_buyer].add(revTokenCurrentLevel);
497             emit Transfer(0x0, _buyer, revTokenCurrentLevel);
498             totalSupplyByAddress[_buyer] = totalSupplyByAddress[_buyer].add(revTokenCurrentLevel);
499             balanceOf[devTeam2] = balanceOf[devTeam2].add(revTokenCurrentLevel*4/6);
500             emit Transfer(0x0, devTeam2, revTokenCurrentLevel*4/6);
501             
502             totalSupply = totalSupply.add(revTokenCurrentLevel*10/6);
503             totalSupplyByLevel[currentRound][currentLevel] = HARD_TOTAL_SUPPLY_BY_LEVEL;
504             
505             // End round uplevel
506             if (currentLevel+1>MAX_LEVEL){
507                 if(currentRound+1>MAX_ROUND){
508                     return revTokenCurrentLevel;
509                 }
510                 currentRound+=1;
511                 currentLevel=0;
512             } else {
513                 currentLevel+=1;
514             }
515             
516             // Push pushDividend change to each 2 weeks
517             return revTokenCurrentLevel;
518         } else {
519             balanceOf[_buyer]= balanceOf[_buyer].add(revTokens);
520             emit Transfer(0x0, _buyer, revTokens);
521             totalSupplyByAddress[_buyer] = totalSupplyByAddress[_buyer].add(revTokens);
522             balanceOf[devTeam2] = balanceOf[devTeam2].add(revTokens*4/6);
523             emit Transfer(0x0, devTeam2, revTokens*4/6);
524             
525             totalSupply = totalSupply.add(revTokens*10/6);
526             totalSupplyByLevel[currentRound][currentLevel] = totalSupplyByLevel[currentRound][currentLevel].add(revTokens*10/6);
527             return revTokens;
528         }
529     }
530     
531     function getCitizenBalanceEth(address _sender) view public returns(uint256){
532         return citizen[_sender].citizenBalanceEth;
533     } 
534 
535     /**
536      * Transfer tokens
537      *
538      * Send `_value` tokens to `_to` from your account
539      *
540      * @param _to The address of the recipient
541      * @param _value the amount to send
542      */
543     function transfer(address _to, uint256 _value) public returns (bool success) {
544         _transfer(msg.sender, _to, _value);
545         return true;
546     }
547 
548     /**
549      * Transfer tokens from other address
550      *
551      * Send `_value` tokens to `_to` on behalf of `_from`
552      *
553      * @param _from The address of the sender
554      * @param _to The address of the recipient
555      * @param _value the amount to send
556      */
557     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
558         require(_value <= allowance[_from][msg.sender]);     // Check allowance
559         allowance[_from][msg.sender] -= _value;
560         _transfer(_from, _to, _value);
561         return true;
562     }
563 
564     /**
565      * Set allowance for other address
566      *
567      * Allows `_spender` to spend no more than `_value` tokens on your behalf
568      *
569      * @param _spender The address authorized to spend
570      * @param _value the max amount they can spend
571      */
572     function approve(address _spender, uint256 _value) public
573         returns (bool success) {
574         allowance[msg.sender][_spender] = _value;
575         // emit Approval(msg.sender, _spender, _value);
576         return true;
577     }
578 
579     /**
580      * Set allowance for other address and notify
581      *
582      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
583      *
584      * @param _spender The address authorized to spend
585      * @param _value the max amount they can spend
586      * @param _extraData some extra information to send to the approved contract
587      */
588     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
589         public
590         returns (bool success) {
591         tokenRecipient spender = tokenRecipient(_spender);
592         if (approve(_spender, _value)) {
593             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
594             return true;
595         }
596     }
597 
598     /**
599      * Destroy tokens
600      *
601      * Remove `_value` tokens from the system irreversibly
602      *
603      * @param _value the amount of money to burn
604      */
605     function burn(uint256 _value) public returns (bool success) {
606         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
607         balanceOf[msg.sender] -= _value;            // Subtract from the sender
608         totalSupply -= _value;                      // Updates totalSupply
609         emit Burn(msg.sender, _value, now);
610         return true;
611     }
612 
613     /**
614      * Destroy tokens from other account
615      *
616      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
617      *
618      * @param _from the address of the sender
619      * @param _value the amount of money to burn
620      */
621     function burnFrom(address _from, uint256 _value) public returns (bool success) {
622         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
623         // require(_value <= allowance[_from][msg.sender]);    // Check allowance
624         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
625         // allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
626         totalSupply -= _value;                              // Update totalSupply
627         totalSupplyBurned += _value;
628         emit Burn(_from, _value, now);
629         return true;
630     }
631 }