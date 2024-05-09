1 // текущая версия - 12 тестовая. уменьшены объемы!!!!
2 // добавлены комменты в require
3 // исправлена ф-ия refund
4 // блокировки переводов сделаны на весь период ICO и Crowdsale
5 // добавлен лог в refund
6 // добавлены функции блокировки\разблокировки внешних переводов в рабочем режиме контракта
7 // для возможности расчета дивидендов
8 // CRYPT Token = > CRYPT
9 // CRTT => CRT
10 // изменены ф-ции раздачи токенов. бесплатно раздать токены можно только с 4-х зарезервированных адресов
11 // в fallback функцию добавлен блок расчета длительности периодов, пауз между периодами 
12 // и автоматической смены периодов по окончании контрольного времени (пауза=30 суток)
13 // изменен порядок расчета лимита при приеме средств - учитываются входящие средства
14 // изменен порядок расчет лимита в первые сутки Pre-ICO - лимит идет не на транзакцию, а на баланс пользователя плюс его платеж
15 // отключена возможность приема средств и продажи токенов по окончанию Crowdsale(на стадии WorkTime)
16 // добавлена функция вывода всех токенов с баланса контракта на адрес собственника по окончании Crowdsale.
17 
18 //- Лимиты по объему 0.4 ETH = 2 000 токенов
19 //- Лимиты по времени 1 СУТКИ 
20 //- Пауза между стадиями - 1 сутки 
21 //* МИНИМАЛЬНЫЙ ПЛАТЕЖ НА PRESALE 0.1 ETH 
22 //* МАКСИМАЛЬНЫЙ ПЛАТЕЖ НА PREICO 0.1 ETH
23 // Всего выпущено = 50 000 токенов
24 // HardCap 40% = 20 000 токенов = 4 ETH
25 
26 pragma solidity ^0.4.23;
27 
28 
29 contract ERC20Basic {
30     function totalSupply() public view returns (uint256);
31     function balanceOf(address who) public view returns (uint256);
32     function transfer(address to, uint256 value) public returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37     function allowance(address owner, address spender)
38         public view returns (uint256);
39 
40     function transferFrom(address from, address to, uint256 value)
41         public returns (bool);
42 
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(
45     address indexed owner,
46     address indexed spender,
47     uint256 value
48     );
49 }
50 
51 
52 
53 library SafeMath {
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
56         if (a == 0) {
57             return 0;
58         }
59         c = a * b;
60         assert(c / a == b);
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return a / b;
66     }
67 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         assert(b <= a);
70         return a - b;
71     }
72 
73     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74         c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 }
79 
80 
81 
82 contract BasicToken is ERC20Basic {
83     using SafeMath for uint256;
84 
85     mapping(address => uint256) balances;
86 
87     uint256 totalSupply_;
88 
89     function totalSupply() public view returns (uint256) {
90         return totalSupply_;
91     }
92 
93     function transfer(address _to, uint256 _value) public returns (bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         emit Transfer(msg.sender, _to, _value);
100         return true;
101     }
102   
103     function balanceOf(address _owner) public view returns (uint256) {
104         return balances[_owner];
105     }
106 
107 }
108 
109 
110 contract StandardToken is ERC20, BasicToken {
111 
112     mapping (address => mapping (address => uint256)) internal allowed;
113 
114     function transferFrom(
115         address _from,
116         address _to,
117         uint256 _value
118     )
119         public
120         returns (bool)
121     {
122         require(_to != address(0));
123         require(_value <= balances[_from]);
124         require(_value <= allowed[_from][msg.sender]);
125 
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         emit Transfer(_from, _to, _value);
130         return true;
131     }
132 
133 
134     function approve(address _spender, uint256 _value) public returns (bool) {
135         allowed[msg.sender][_spender] = _value;
136         emit Approval(msg.sender, _spender, _value);
137         return true;
138     }
139 
140 
141     function allowance(
142         address _owner,
143         address _spender
144     )
145     public
146     view
147     returns (uint256)
148     {
149         return allowed[_owner][_spender];
150     }
151 
152 
153     function increaseApproval(
154         address _spender,
155         uint _addedValue
156     )
157     public
158     returns (bool)
159     {
160         allowed[msg.sender][_spender] = (
161         allowed[msg.sender][_spender].add(_addedValue));
162         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164     }
165 
166 
167     function decreaseApproval(
168         address _spender,
169         uint _subtractedValue
170     )
171         public
172         returns (bool)
173     {
174         uint oldValue = allowed[msg.sender][_spender];
175         if (_subtractedValue > oldValue) {
176             allowed[msg.sender][_spender] = 0;
177         } else {
178             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179         }
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184 }
185 
186 
187 contract CRYPTToken is StandardToken {
188     string public constant name = "CRYPT";
189     string public constant symbol = "CRT";
190     uint32 public constant decimals = 18;
191     uint256 public INITIAL_SUPPLY = 50000 * 1 ether;
192     address public CrowdsaleAddress;
193     bool public lockTransfers = false;
194 
195     constructor(address _CrowdsaleAddress) public {
196     
197         CrowdsaleAddress = _CrowdsaleAddress;
198         totalSupply_ = INITIAL_SUPPLY;
199         balances[msg.sender] = INITIAL_SUPPLY;      
200     }
201   
202     modifier onlyOwner() {
203         // only Crowdsale contract
204         require(msg.sender == CrowdsaleAddress);
205         _;
206     }
207 
208      // Override
209     function transfer(address _to, uint256 _value) public returns(bool){
210         if (msg.sender != CrowdsaleAddress){
211             require(!lockTransfers, "Transfers are prohibited in ICO and Crowdsale period");
212         }
213         return super.transfer(_to,_value);
214     }
215 
216      // Override
217     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
218         if (msg.sender != CrowdsaleAddress){
219             require(!lockTransfers, "Transfers are prohibited in ICO and Crowdsale period");
220         }
221         return super.transferFrom(_from,_to,_value);
222     }
223      
224     function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){
225         require (balances[_from] >= _value);
226         balances[_from] = balances[_from].sub(_value);
227         balances[CrowdsaleAddress] = balances[CrowdsaleAddress].add(_value);
228         emit Transfer(_from, CrowdsaleAddress, _value);
229         return true;
230     }
231 
232     function lockTransfer(bool _lock) public onlyOwner {
233         lockTransfers = _lock;
234     }
235 
236 
237 
238     function() external payable {
239         // The token contract don`t receive ether
240         revert();
241     }  
242 }
243 
244 
245 contract Ownable {
246     address public owner;
247     address candidate;
248 
249     constructor() public {
250         owner = msg.sender;
251     }
252 
253     modifier onlyOwner() {
254         require(msg.sender == owner);
255         _;
256     }
257 
258 
259     function transferOwnership(address newOwner) public onlyOwner {
260         require(newOwner != address(0));
261         candidate = newOwner;
262     }
263 
264     function confirmOwnership() public {
265         require(candidate == msg.sender);
266         owner = candidate;
267         delete candidate;
268     }
269 
270 }
271 
272 contract HoldProjectAddress {
273     //Address where stored command tokens- 50%
274     //Withdraw tokens allowed only after 1 year
275     function() external payable {
276         // The contract don`t receive ether
277         revert();
278     } 
279 }
280 
281 contract HoldBountyAddress {
282     //Address where stored bounty tokens- 1%
283     //Withdraw tokens allowed only after 40 days
284     function() external payable {
285         // The contract don`t receive ether
286         revert();
287     } 
288 }
289 
290 contract HoldAdvisorsAddress {
291     //Address where stored advisors tokens- 1%
292     //Withdraw tokens allowed only after 40 days
293     function() external payable {
294         // The contract don`t receive ether
295         revert();
296     } 
297 }
298 
299 contract HoldAdditionalAddress {
300     //Address where stored additional tokens- 8%
301     function() external payable {
302         // The contract don`t receive ether
303         revert();
304     } 
305 }
306 
307 contract Crowdsale is Ownable {
308     using SafeMath for uint; 
309     event LogStateSwitch(State newState);
310     event Withdraw(address indexed from, address indexed to, uint256 amount);
311     event Refunding(address indexed to, uint256 amount);
312     mapping(address => uint) public crowdsaleBalances;
313 
314     address myAddress = this;
315     uint64 preSaleStartTime = 0;
316     uint64 preICOStartTime = 0;
317     uint64 crowdSaleStartTime = 0;
318     uint public  saleRate = 5000;  //tokens for 1 ether
319     uint256 public soldTokens = 0;
320 
321     // 50 000 000 sold tokens limit for Pre-Sale
322     uint public constant RPESALE_TOKEN_SUPPLY_LIMIT = 2000 * 1 ether;
323 
324 
325     // 100 000 000 sold tokens limit for Pre-ICO
326     uint public constant RPEICO_TOKEN_SUPPLY_LIMIT = 4000 * 1 ether;
327 
328     // 40 000 000 tokens soft cap (otherwise - refund)
329     // equal 8 000 eth
330 
331 
332     uint public constant TOKEN_SOFT_CAP = 2000 * 1 ether;
333 
334     
335     CRYPTToken public token = new CRYPTToken(myAddress);
336     
337     // New address for hold tokens
338     HoldProjectAddress public holdAddress1 = new HoldProjectAddress();
339     HoldBountyAddress public holdAddress2 = new HoldBountyAddress();
340     HoldAdvisorsAddress public holdAddress3 = new HoldAdvisorsAddress();
341     HoldAdditionalAddress public holdAddress4 = new HoldAdditionalAddress();
342 
343     // Create state of contract
344     enum State { 
345         Init,    
346         PreSale, 
347         PreICO,  
348         CrowdSale,
349         Refunding,
350         WorkTime
351     }
352         
353     State public currentState = State.Init;
354 
355     modifier onlyInState(State state){ 
356         require(state==currentState); 
357         _; 
358     }
359 
360     constructor() public {
361         uint256 TotalTokens = token.INITIAL_SUPPLY().div(1 ether);
362         // distribute tokens
363         // Transer tokens to project address.  (50%)
364         giveTokens(address(holdAddress1), TotalTokens.div(2));
365         // Transer tokens to bounty address.  (1%)
366         giveTokens(address(holdAddress2), TotalTokens.div(100));
367         // Transer tokens to advisors address. (1%)
368         giveTokens(address(holdAddress3), TotalTokens.div(100));
369         // Transer tokens to additional address. (8%)
370         giveTokens(address(holdAddress4), TotalTokens.div(100).mul(8));
371         
372     }
373 
374     function returnTokensFromHoldProjectAddress(uint256 _value) internal returns(bool){
375         // the function take tokens from HoldProjectAddress to contract
376         // only after 1 year
377         // the sum is entered in whole tokens (1 = 1 token)
378         uint256 value = _value;
379         require (value >= 1);
380         value = value.mul(1 ether);
381         require (now >= preSaleStartTime + 1 days, "only after 1 year");
382         token.acceptTokens(address(holdAddress1), value); 
383         return true;
384     } 
385 
386     function returnTokensFromHoldBountyAddress(uint256 _value) internal returns(bool){
387         // the function take tokens from HoldBountyAddress to contract
388         // only after 40 days
389         // the sum is entered in whole tokens (1 = 1 token)
390         uint256 value = _value;
391         require (value >= 1);
392         value = value.mul(1 ether);
393         require (now >= preSaleStartTime + 1 days, "only after 40 days");
394         token.acceptTokens(address(holdAddress2), value);    
395         return true;
396     } 
397     
398     function returnTokensFromHoldAdvisorsAddress(uint256 _value) internal returns(bool){
399         // the function take tokens from HoldAdvisorsAddress to contract
400         // only after 40 days
401         // the sum is entered in whole tokens (1 = 1 token)
402         uint256 value = _value;
403         require (value >= 1);
404         value = value.mul(1 ether);
405         require (now >= preSaleStartTime + 1 days, "only after 40 days");
406         token.acceptTokens(address(holdAddress3), value);    
407         return true;
408     } 
409     
410     function returnTokensFromHoldAdditionalAddress(uint256 _value) internal returns(bool){
411         // the function take tokens from HoldAdditionalAddress to contract
412         // the sum is entered in whole tokens (1 = 1 token)
413         uint256 value = _value;
414         require (value >= 1);
415         value = value.mul(1 ether);
416         token.acceptTokens(address(holdAddress4), value);    
417         return true;
418     }     
419     
420     function giveTokens(address _newInvestor, uint256 _value) internal {
421         require (_newInvestor != address(0));
422         require (_value >= 1);
423         uint256 value = _value;
424         value = value.mul(1 ether);
425         token.transfer(_newInvestor, value);
426     }  
427     
428     function giveBountyTokens(address _newInvestor, uint256 _value) public onlyOwner {
429         // the sum is entered in whole tokens (1 = 1 token)
430         if (returnTokensFromHoldBountyAddress(_value)){
431             giveTokens(_newInvestor, _value);
432         }
433     }
434 
435     function giveProjectTokens(address _newInvestor, uint256 _value) public onlyOwner {
436         // the sum is entered in whole tokens (1 = 1 token)
437 
438         if (returnTokensFromHoldProjectAddress(_value)){
439             giveTokens(_newInvestor, _value);
440         }
441     }
442 
443     function giveAdvisorsTokens(address _newInvestor, uint256 _value) public onlyOwner {
444         // the sum is entered in whole tokens (1 = 1 token)
445         if (returnTokensFromHoldAdvisorsAddress(_value)){
446             giveTokens(_newInvestor, _value);
447         }
448     }
449 
450     function giveAdditionalTokens(address _newInvestor, uint256 _value) public onlyOwner {
451         // the sum is entered in whole tokens (1 = 1 token)
452         if (returnTokensFromHoldAdditionalAddress(_value)){
453             giveTokens(_newInvestor, _value);
454         }
455     }
456 
457     function withdrawAllTokensFromBalance() public onlyOwner {
458         require(currentState == State.WorkTime || currentState == State.Refunding,"This function is accessable only in WorkTime or Refunding");
459         uint value = token.balanceOf(myAddress);
460         token.transfer(msg.sender, value);
461     }
462 
463     function setState(State _state) internal {
464         currentState = _state;
465         emit LogStateSwitch(_state);
466     }
467 
468     function startPreSale() public onlyOwner onlyInState(State.Init) {
469         setState(State.PreSale);
470         preSaleStartTime = uint64(now);
471         token.lockTransfer(true);
472     }
473 
474     function startPreICO() public onlyOwner onlyInState(State.PreSale) {
475         // PreSale minimum 10 days
476         require (now >= preSaleStartTime + 1 days, "Mimimum period Pre-Sale is 10 days");
477         setState(State.PreICO);
478         preICOStartTime = uint64(now);
479     }
480      
481     function startCrowdSale() public onlyOwner onlyInState(State.PreICO) {
482         // Pre-ICO minimum 15 days
483         require (now >= preICOStartTime + 1 days, "Mimimum period Pre-ICO is 15 days");
484         setState(State.CrowdSale);
485         crowdSaleStartTime = uint64(now);
486     }
487     
488     function finishCrowdSale() public onlyOwner onlyInState(State.CrowdSale) {
489         // CrowdSale minimum 30 days
490         // Attention - function not have reverse!
491 
492         require (now >= crowdSaleStartTime + 1 days, "Mimimum period CrowdSale is 30 days");
493         // test coftcap
494         if (soldTokens < TOKEN_SOFT_CAP) {
495             // softcap don"t accessable - refunding
496             setState(State.Refunding);
497         } else {
498             // All right! CrowdSale is passed. WithdrawProfit is accessable
499             setState(State.WorkTime);
500             token.lockTransfer(false);
501         }
502     }
503 
504 
505     function blockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){
506         //Blocking all external token transfer for dividends calculations
507         require (token.lockTransfers() == false);
508         token.lockTransfer(true);
509     }
510 
511     function unBlockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){
512         //Unblocking all external token transfer
513         require (token.lockTransfers() == true);
514         token.lockTransfer(false);
515     }
516 
517 
518     function calcBonus () public view returns(uint256) {
519         // calculation bonus
520         uint256 actualBonus = 0;
521         if (currentState == State.PreSale){
522             actualBonus = 20;
523         }
524         if (currentState == State.PreICO){
525             actualBonus = 10;
526         }
527         return actualBonus;
528     }
529 
530  
531     function saleTokens() internal {
532         require(currentState != State.Init, "Contract is init, do not accept ether."); 
533         require(currentState != State.Refunding, "Contract is refunding, do not accept ether.");
534         require(currentState != State.WorkTime, "Contract is WorkTime, do not accept ether.");
535         //calculation length of periods, pauses, auto set next stage
536         if (currentState == State.PreSale) {
537             if ((uint64(now) > preSaleStartTime + 1 days) && (uint64(now) <= preSaleStartTime + 2 days)){
538                 require (false, "It is pause after PreSale stage - contract do not accept ether");
539             }
540             if (uint64(now) > preSaleStartTime + 2 days){
541                 setState(State.PreICO);
542                 preICOStartTime = uint64(now);
543             }
544         }
545 
546         if (currentState == State.PreICO) {
547             if ((uint64(now) > preICOStartTime + 1 days) && (uint64(now) <= preICOStartTime + 2 days)){
548                 require (false, "It is pause after PreICO stage - contract do not accept ether");
549             }
550             if (uint64(now) > preICOStartTime + 2 days){
551                 setState(State.CrowdSale);
552                 crowdSaleStartTime = uint64(now);
553             }
554         }        
555         
556         if (currentState == State.CrowdSale) {
557             if ((uint64(now) > crowdSaleStartTime + 1 days) && (uint64(now) <= crowdSaleStartTime + 2 days)){
558                 require (false, "It is pause after CrowdSale stage - contract do not accept ether");
559             }
560             if (uint64(now) > crowdSaleStartTime + 2 days){
561                 // autofinish CrowdSale stage
562                 if (soldTokens < TOKEN_SOFT_CAP) {
563                     // softcap don"t accessable - refunding
564                     setState(State.Refunding);
565                 } else {
566                     // All right! CrowdSale is passed. WithdrawProfit is accessable
567                     setState(State.WorkTime);
568                     token.lockTransfer(false);
569                 }
570             }
571         }        
572         
573         uint tokens = saleRate.mul(msg.value);
574         if (currentState == State.PreSale) {
575             require (RPESALE_TOKEN_SUPPLY_LIMIT > soldTokens.add(tokens), "HardCap of Pre-Sale is excedded."); 
576             require (msg.value >= 1 ether / 10, "Minimum 20 ether for transaction all Pre-Sale period");
577         }
578         if (currentState == State.PreICO) {
579             require (RPEICO_TOKEN_SUPPLY_LIMIT > soldTokens.add(tokens), "HardCap of Pre-ICO is excedded.");
580             if (uint64(now) < preICOStartTime + 1 days){
581                 uint limitPerUser = crowdsaleBalances[msg.sender] + msg.value;
582                 require (limitPerUser <= 1 ether / 10, "Maximum is 20 ether for user in first day of Pre-ICO");
583             }
584         }
585         tokens = tokens.add(tokens.mul(calcBonus()).div(100));
586         crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(msg.value);
587         token.transfer(msg.sender, tokens);
588         soldTokens = soldTokens.add(tokens);
589     }
590  
591     function refund() public payable{
592         require(currentState == State.Refunding, "Only for Refunding stage.");
593         // refund ether to investors
594         uint value = crowdsaleBalances[msg.sender]; 
595         crowdsaleBalances[msg.sender] = 0; 
596         msg.sender.transfer(value);
597         emit Refunding(msg.sender, value);
598     }
599     
600     function withdrawProfit (address _to, uint256 _value) public onlyOwner payable {
601     // withdrawProfit - only if coftcap passed
602         require (currentState == State.WorkTime, "Contract is not at WorkTime stage. Access denied.");
603         require (myAddress.balance >= _value);
604         require(_to != address(0));
605         _to.transfer(_value);
606         emit Withdraw(msg.sender, _to, _value);
607     }
608 
609 
610     function() external payable {
611         saleTokens();
612     }    
613  
614 }