1 // текущая версия - 9 тестовая для развертывания в Rinkeby
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
13 
14 //- Лимиты по объему 0.4 ETH = 2 000 токенов
15 //- Лимиты по времени 1 СУТКИ 
16 //- Пауза между стадиями - 1 сутки 
17 //* МИНИМАЛЬНЫЙ ПЛАТЕЖ НА PRESALE 0.1 ETH 
18 //* МАКСИМАЛЬНЫЙ ПЛАТЕЖ НА PREICO 0.1 ETH
19 // Всего выпущено = 50 000 токенов
20 // HardCap 40% = 20 000 токенов = 4 ETH
21 
22 
23 
24 pragma solidity ^0.4.23;
25 
26 
27 contract ERC20Basic {
28     function totalSupply() public view returns (uint256);
29     function balanceOf(address who) public view returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender)
36         public view returns (uint256);
37 
38     function transferFrom(address from, address to, uint256 value)
39         public returns (bool);
40 
41     function approve(address spender, uint256 value) public returns (bool);
42     event Approval(
43     address indexed owner,
44     address indexed spender,
45     uint256 value
46     );
47 }
48 
49 
50 
51 library SafeMath {
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
54         if (a == 0) {
55             return 0;
56         }
57         c = a * b;
58         assert(c / a == b);
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a / b;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
72         c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 }
77 
78 
79 
80 contract BasicToken is ERC20Basic {
81     using SafeMath for uint256;
82 
83     mapping(address => uint256) balances;
84 
85     uint256 totalSupply_;
86 
87     function totalSupply() public view returns (uint256) {
88         return totalSupply_;
89     }
90 
91     function transfer(address _to, uint256 _value) public returns (bool) {
92         require(_to != address(0));
93         require(_value <= balances[msg.sender]);
94 
95         balances[msg.sender] = balances[msg.sender].sub(_value);
96         balances[_to] = balances[_to].add(_value);
97         emit Transfer(msg.sender, _to, _value);
98         return true;
99     }
100   
101     function balanceOf(address _owner) public view returns (uint256) {
102         return balances[_owner];
103     }
104 
105 }
106 
107 
108 contract StandardToken is ERC20, BasicToken {
109 
110     mapping (address => mapping (address => uint256)) internal allowed;
111 
112     function transferFrom(
113         address _from,
114         address _to,
115         uint256 _value
116     )
117         public
118         returns (bool)
119     {
120         require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123 
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         emit Transfer(_from, _to, _value);
128         return true;
129     }
130 
131 
132     function approve(address _spender, uint256 _value) public returns (bool) {
133         allowed[msg.sender][_spender] = _value;
134         emit Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138 
139     function allowance(
140         address _owner,
141         address _spender
142     )
143     public
144     view
145     returns (uint256)
146     {
147         return allowed[_owner][_spender];
148     }
149 
150 
151     function increaseApproval(
152         address _spender,
153         uint _addedValue
154     )
155     public
156     returns (bool)
157     {
158         allowed[msg.sender][_spender] = (
159         allowed[msg.sender][_spender].add(_addedValue));
160         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161         return true;
162     }
163 
164 
165     function decreaseApproval(
166         address _spender,
167         uint _subtractedValue
168     )
169         public
170         returns (bool)
171     {
172         uint oldValue = allowed[msg.sender][_spender];
173         if (_subtractedValue > oldValue) {
174             allowed[msg.sender][_spender] = 0;
175         } else {
176             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177         }
178         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179         return true;
180     }
181 
182 }
183 
184 
185 contract CRYPTToken is StandardToken {
186     string public constant name = "CRYPT Test Token";
187     string public constant symbol = "CRTT";
188     uint32 public constant decimals = 18;
189     uint256 public INITIAL_SUPPLY = 50000 * 1 ether;
190     address public CrowdsaleAddress;
191     bool public lockTransfers = false;
192 
193     constructor(address _CrowdsaleAddress) public {
194     
195         CrowdsaleAddress = _CrowdsaleAddress;
196         totalSupply_ = INITIAL_SUPPLY;
197         balances[msg.sender] = INITIAL_SUPPLY;      
198     }
199   
200     modifier onlyOwner() {
201         // only Crowdsale contract
202         require(msg.sender == CrowdsaleAddress);
203         _;
204     }
205 
206      // Override
207     function transfer(address _to, uint256 _value) public returns(bool){
208         if (msg.sender != CrowdsaleAddress){
209             require(!lockTransfers, "Transfers are prohibited in ICO and Crowdsale period");
210         }
211         return super.transfer(_to,_value);
212     }
213 
214      // Override
215     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
216         if (msg.sender != CrowdsaleAddress){
217             require(!lockTransfers, "Transfers are prohibited in ICO and Crowdsale period");
218         }
219         return super.transferFrom(_from,_to,_value);
220     }
221      
222     function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){
223         require (balances[_from] >= _value);
224         balances[_from] = balances[_from].sub(_value);
225         balances[CrowdsaleAddress] = balances[CrowdsaleAddress].add(_value);
226         emit Transfer(_from, CrowdsaleAddress, _value);
227         return true;
228     }
229 
230     function lockTransfer(bool _lock) public onlyOwner {
231         lockTransfers = _lock;
232     }
233 
234 
235 
236     function() external payable {
237         // The token contract don`t receive ether
238         revert();
239     }  
240 }
241 
242 
243 contract Ownable {
244     address public owner;
245     address candidate;
246 
247     constructor() public {
248         owner = msg.sender;
249     }
250 
251     modifier onlyOwner() {
252         require(msg.sender == owner);
253         _;
254     }
255 
256 
257     function transferOwnership(address newOwner) public onlyOwner {
258         require(newOwner != address(0));
259         candidate = newOwner;
260     }
261 
262     function confirmOwnership() public {
263         require(candidate == msg.sender);
264         owner = candidate;
265         delete candidate;
266     }
267 
268 }
269 
270 contract HoldProgectAddress {
271     //Address where stored command tokens- 50%
272     //Withdraw tokens allowed only after 1 year
273     function() external payable {
274         // The contract don`t receive ether
275         revert();
276     } 
277 }
278 
279 contract HoldBountyAddress {
280     //Address where stored bounty tokens- 1%
281     //Withdraw tokens allowed only after 40 days
282     function() external payable {
283         // The contract don`t receive ether
284         revert();
285     } 
286 }
287 
288 contract HoldAdvisorsAddress {
289     //Address where stored advisors tokens- 1%
290     //Withdraw tokens allowed only after 40 days
291     function() external payable {
292         // The contract don`t receive ether
293         revert();
294     } 
295 }
296 
297 contract HoldAdditionalAddress {
298     //Address where stored additional tokens- 8%
299     function() external payable {
300         // The contract don`t receive ether
301         revert();
302     } 
303 }
304 
305 contract Crowdsale is Ownable {
306     using SafeMath for uint; 
307     event LogStateSwitch(State newState);
308     event Withdraw(address indexed from, address indexed to, uint256 amount);
309     event Refunding(address indexed to, uint256 amount);
310     mapping(address => uint) public crowdsaleBalances;
311 
312     address myAddress = this;
313     uint64 preSaleStartTime = 0;
314     uint64 preICOStartTime = 0;
315     uint64 crowdSaleStartTime = 0;
316     uint public  saleRate = 5000;  //tokens for 1 ether
317     uint256 public soldTokens = 0;
318 
319     // 50 000 000 sold tokens limit for Pre-Sale
320     uint public constant RPESALE_TOKEN_SUPPLY_LIMIT = 2000 * 1 ether;
321 
322 
323     // 100 000 000 sold tokens limit for Pre-ICO
324     uint public constant RPEICO_TOKEN_SUPPLY_LIMIT = 4000 * 1 ether;
325 
326     // 40 000 000 tokens soft cap (otherwise - refund)
327     // equal 8 000 eth
328 
329 
330     uint public constant TOKEN_SOFT_CAP = 2000 * 1 ether;
331 
332     
333     CRYPTToken public token = new CRYPTToken(myAddress);
334     
335     // New address for hold tokens
336     HoldProgectAddress public holdAddress1 = new HoldProgectAddress();
337     HoldBountyAddress public holdAddress2 = new HoldBountyAddress();
338     HoldAdvisorsAddress public holdAddress3 = new HoldAdvisorsAddress();
339     HoldAdditionalAddress public holdAddress4 = new HoldAdditionalAddress();
340 
341     // Create state of contract
342     enum State { 
343         Init,    
344         PreSale, 
345         PreICO,  
346         CrowdSale,
347         Refunding,
348         WorkTime
349     }
350         
351     State public currentState = State.Init;
352 
353     modifier onlyInState(State state){ 
354         require(state==currentState); 
355         _; 
356     }
357 
358     constructor() public {
359         uint256 TotalTokens = token.INITIAL_SUPPLY().div(1 ether);
360         // distribute tokens
361         // Transer tokens to project address.  (50%)
362         giveTokens(address(holdAddress1), TotalTokens.div(2));
363         // Transer tokens to bounty address.  (1%)
364         giveTokens(address(holdAddress2), TotalTokens.div(100));
365         // Transer tokens to advisors address. (1%)
366         giveTokens(address(holdAddress3), TotalTokens.div(100));
367         // Transer tokens to additional address. (8%)
368         giveTokens(address(holdAddress4), TotalTokens.div(100).mul(8));
369         
370     }
371 
372     function returnTokensFromHoldProgectAddress(uint256 _value) internal returns(bool){
373         // the function take tokens from HoldProgectAddress to contract
374         // only after 1 year
375         // the sum is entered in whole tokens (1 = 1 token)
376         uint256 value = _value;
377         require (value >= 1);
378         value = value.mul(1 ether);
379         require (now >= preSaleStartTime + 1 days, "only after 1 year");
380         token.acceptTokens(address(holdAddress1), value); 
381         return true;
382     } 
383 
384     function returnTokensFromHoldBountyAddress(uint256 _value) internal returns(bool){
385         // the function take tokens from HoldBountyAddress to contract
386         // only after 40 days
387         // the sum is entered in whole tokens (1 = 1 token)
388         uint256 value = _value;
389         require (value >= 1);
390         value = value.mul(1 ether);
391         require (now >= preSaleStartTime + 1 days, "only after 40 days");
392         token.acceptTokens(address(holdAddress2), value);    
393         return true;
394     } 
395     
396     function returnTokensFromHoldAdvisorsAddress(uint256 _value) internal returns(bool){
397         // the function take tokens from HoldAdvisorsAddress to contract
398         // only after 40 days
399         // the sum is entered in whole tokens (1 = 1 token)
400         uint256 value = _value;
401         require (value >= 1);
402         value = value.mul(1 ether);
403         require (now >= preSaleStartTime + 1 days, "only after 40 days");
404         token.acceptTokens(address(holdAddress3), value);    
405         return true;
406     } 
407     
408     function returnTokensFromHoldAdditionalAddress(uint256 _value) internal returns(bool){
409         // the function take tokens from HoldAdditionalAddress to contract
410         // the sum is entered in whole tokens (1 = 1 token)
411         uint256 value = _value;
412         require (value >= 1);
413         value = value.mul(1 ether);
414         token.acceptTokens(address(holdAddress4), value);    
415         return true;
416     }     
417     
418     function giveTokens(address _newInvestor, uint256 _value) internal {
419         require (_newInvestor != address(0));
420         require (_value >= 1);
421         uint256 value = _value;
422         value = value.mul(1 ether);
423         token.transfer(_newInvestor, value);
424     }  
425     
426     function giveBountyTokens(address _newInvestor, uint256 _value) public onlyOwner {
427         // the sum is entered in whole tokens (1 = 1 token)
428         if (returnTokensFromHoldBountyAddress(_value)){
429             giveTokens(_newInvestor, _value);
430         }
431     }
432 
433     function giveProgectTokens(address _newInvestor, uint256 _value) public onlyOwner {
434         // the sum is entered in whole tokens (1 = 1 token)
435         if (returnTokensFromHoldProgectAddress(_value)){
436             giveTokens(_newInvestor, _value);
437         }
438     }
439 
440     function giveAdvisorsTokens(address _newInvestor, uint256 _value) public onlyOwner {
441         // the sum is entered in whole tokens (1 = 1 token)
442         if (returnTokensFromHoldAdvisorsAddress(_value)){
443             giveTokens(_newInvestor, _value);
444         }
445     }
446 
447     function giveAdditionalTokens(address _newInvestor, uint256 _value) public onlyOwner {
448         // the sum is entered in whole tokens (1 = 1 token)
449         if (returnTokensFromHoldAdditionalAddress(_value)){
450             giveTokens(_newInvestor, _value);
451         }
452     }
453 
454     function setState(State _state) internal {
455         currentState = _state;
456         emit LogStateSwitch(_state);
457     }
458 
459     function startPreSale() public onlyOwner onlyInState(State.Init) {
460         setState(State.PreSale);
461         preSaleStartTime = uint64(now);
462         token.lockTransfer(true);
463     }
464 
465     function startPreICO() public onlyOwner onlyInState(State.PreSale) {
466         // PreSale minimum 10 days
467         require (now >= preSaleStartTime + 1 days, "Mimimum period Pre-Sale is 10 days");
468         setState(State.PreICO);
469         preICOStartTime = uint64(now);
470     }
471      
472     function startCrowdSale() public onlyOwner onlyInState(State.PreICO) {
473         // Pre-ICO minimum 15 days
474         require (now >= preICOStartTime + 1 days, "Mimimum period Pre-ICO is 15 days");
475         setState(State.CrowdSale);
476         crowdSaleStartTime = uint64(now);
477     }
478     
479     function finishCrowdSale() public onlyOwner onlyInState(State.CrowdSale) {
480         // CrowdSale minimum 30 days
481         // Attention - function not have reverse!
482 
483         require (now >= crowdSaleStartTime + 1 days, "Mimimum period CrowdSale is 30 days");
484         // test coftcap
485         if (soldTokens < TOKEN_SOFT_CAP) {
486             // softcap don"t accessable - refunding
487             setState(State.Refunding);
488         } else {
489             // All right! CrowdSale is passed. WithdrawProfit is accessable
490             setState(State.WorkTime);
491             token.lockTransfer(false);
492         }
493     }
494 
495 
496     function blockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){
497         //Blocking all external token transfer for dividends calculations
498         require (token.lockTransfers() == false);
499         token.lockTransfer(true);
500     }
501 
502     function unBlockExternalTransfer() public onlyOwner onlyInState (State.WorkTime){
503         //Unblocking all external token transfer
504         require (token.lockTransfers() == true);
505         token.lockTransfer(false);
506     }
507 
508 
509     function calcBonus () public view returns(uint256) {
510         // calculation bonus
511         uint256 actualBonus = 0;
512         if (currentState == State.PreSale){
513             actualBonus = 20;
514         }
515         if (currentState == State.PreICO){
516             actualBonus = 10;
517         }
518         return actualBonus;
519     }
520 
521  
522     function saleTokens() internal {
523         require(currentState != State.Init, "Contract is init, do not accept ether."); 
524         require(currentState != State.Refunding, "Contract is refunding, do not accept ether.");
525         //calculation length of periods, pauses, auto set next stage
526         if (currentState == State.PreSale) {
527             if ((uint64(now) > preSaleStartTime + 1 days) && (uint64(now) <= preSaleStartTime + 2 days)){
528                 require (false, "It is pause after PreSale stage - contract do not accept ether");
529             }
530             if (uint64(now) > preSaleStartTime + 2 days){
531                 setState(State.PreICO);
532                 preICOStartTime = uint64(now);
533             }
534         }
535 
536         if (currentState == State.PreICO) {
537             if ((uint64(now) > preICOStartTime + 1 days) && (uint64(now) <= preICOStartTime + 2 days)){
538                 require (false, "It is pause after PreICO stage - contract do not accept ether");
539             }
540             if (uint64(now) > preICOStartTime + 2 days){
541                 setState(State.CrowdSale);
542                 crowdSaleStartTime = uint64(now);
543             }
544         }        
545         
546         if (currentState == State.CrowdSale) {
547             if ((uint64(now) > crowdSaleStartTime + 1 days) && (uint64(now) <= crowdSaleStartTime + 2 days)){
548                 require (false, "It is pause after CrowdSale stage - contract do not accept ether");
549             }
550             if (uint64(now) > crowdSaleStartTime + 2 days){
551                 // autofinish CrowdSale stage
552                 if (soldTokens < TOKEN_SOFT_CAP) {
553                     // softcap don"t accessable - refunding
554                     setState(State.Refunding);
555                 } else {
556                     // All right! CrowdSale is passed. WithdrawProfit is accessable
557                     setState(State.WorkTime);
558                     token.lockTransfer(false);
559                 }
560             }
561         }        
562         
563         if (currentState == State.PreSale) {
564             require (RPESALE_TOKEN_SUPPLY_LIMIT > soldTokens, "HardCap of Pre-Sale is passed."); 
565             require (msg.value >= 1 ether / 10, "Minimum 20 ether for transaction all Pre-Sale period");
566         }
567         if (currentState == State.PreICO) {
568             require (RPEICO_TOKEN_SUPPLY_LIMIT > soldTokens, "HardCap of Pre-ICO is passed.");
569             if (now < preICOStartTime + 1 days){
570                 require (msg.value <= 1 ether / 10, "Maximum is 20 ether for transaction in first day of Pre-ICO");
571             }
572         }
573         crowdsaleBalances[msg.sender] = crowdsaleBalances[msg.sender].add(msg.value);
574         uint tokens = saleRate.mul(msg.value);
575         tokens = tokens.add(tokens.mul(calcBonus()).div(100));
576         token.transfer(msg.sender, tokens);
577         soldTokens = soldTokens.add(tokens);
578     }
579  
580     function refund() public payable{
581         require(currentState == State.Refunding, "Only for Refunding stage.");
582         // refund ether to investors
583         uint value = crowdsaleBalances[msg.sender]; 
584         crowdsaleBalances[msg.sender] = 0; 
585         msg.sender.transfer(value);
586         emit Refunding(msg.sender, value);
587     }
588     
589     function withdrawProfit (address _to, uint256 _value) public onlyOwner payable {
590     // withdrawProfit - only if coftcap passed
591         require (currentState == State.WorkTime, "Contract is not at WorkTime stage. Access denied.");
592         require (myAddress.balance >= _value);
593         require(_to != address(0));
594         _to.transfer(_value);
595         emit Withdraw(msg.sender, _to, _value);
596     }
597 
598 
599     function() external payable {
600         saleTokens();
601     }    
602 
603 
604 }