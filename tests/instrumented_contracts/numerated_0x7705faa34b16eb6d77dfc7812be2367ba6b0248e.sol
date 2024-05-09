1 pragma solidity ^ 0.4.13;
2 
3 contract MigrationAgent {
4     function migrateFrom(address _from, uint256 _value);
5 }
6 
7 contract PreArtexToken {
8     struct Investor {
9         uint amountTokens;
10         uint amountWei;
11     }
12 
13     uint public etherPriceUSDWEI;
14     address public beneficiary;
15     uint public totalLimitUSDWEI;
16     uint public minimalSuccessUSDWEI;
17     uint public collectedUSDWEI;
18 
19     uint public state;
20 
21     uint public crowdsaleStartTime;
22     uint public crowdsaleFinishTime;
23 
24     mapping(address => Investor) public investors;
25     mapping(uint => address) public investorsIter;
26     uint public numberOfInvestors;
27 }
28 
29 contract Owned {
30 
31     address public owner;
32     address public newOwner;
33     address public oracle;
34     address public btcOracle;
35 
36     function Owned() payable {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(owner == msg.sender);
42         _;
43     }
44 
45     modifier onlyOwnerOrOracle {
46         require(owner == msg.sender || oracle == msg.sender);
47         _;
48     }
49 
50     modifier onlyOwnerOrBtcOracle {
51         require(owner == msg.sender || btcOracle == msg.sender);
52         _;
53     }
54 
55     function changeOwner(address _owner) onlyOwner external {
56         require(_owner != 0);
57         newOwner = _owner;
58     }
59 
60     function confirmOwner() external {
61         require(newOwner == msg.sender);
62         owner = newOwner;
63         delete newOwner;
64     }
65 
66     function changeOracle(address _oracle) onlyOwner external {
67         require(_oracle != 0);
68         oracle = _oracle;
69     }
70 
71     function changeBtcOracle(address _btcOracle) onlyOwner external {
72         require(_btcOracle != 0);
73         btcOracle = _btcOracle;
74     }
75 }
76 
77 contract KnownContract {
78     function transfered(address _sender, uint256 _value, bytes32[] _data) external;
79 }
80 
81 contract ERC20 {
82     uint public totalSupply;
83 
84     function balanceOf(address who) constant returns(uint);
85 
86     function transfer(address to, uint value);
87 
88     function allowance(address owner, address spender) constant returns(uint);
89 
90     function transferFrom(address from, address to, uint value);
91 
92     function approve(address spender, uint value);
93 
94     event Approval(address indexed owner, address indexed spender, uint value);
95 
96     event Transfer(address indexed from, address indexed to, uint value);
97 }
98 
99 contract Stateful {
100     enum State {
101         Initial,
102         PreSale,
103         WaitingForSale,
104         Sale,
105         CrowdsaleCompleted,
106         SaleFailed
107     }
108 
109     State public state = State.Initial;
110 
111     event StateChanged(State oldState, State newState);
112 
113     function setState(State newState) internal {
114         State oldState = state;
115         state = newState;
116         StateChanged(oldState, newState);
117     }
118 }
119 
120 contract Crowdsale is Owned, Stateful {
121 
122     uint public etherPriceUSDWEI;
123     address public beneficiary;
124     uint public totalLimitUSDWEI;
125     uint public minimalSuccessUSDWEI;
126     uint public collectedUSDWEI;
127 
128     uint public crowdsaleStartTime;
129     uint public crowdsaleFinishTime;
130 
131     uint public tokenPriceUSDWEI = 100000000000000000;
132 
133     struct Investor {
134         uint amountTokens;
135         uint amountWei;
136     }
137 
138     struct BtcDeposit {
139         uint amountBTCWEI;
140         uint btcPriceUSDWEI;
141         address investor;
142     }
143 
144     mapping(bytes32 => BtcDeposit) public btcDeposits;
145 
146     mapping(address => Investor) public investors;
147     mapping(uint => address) public investorsIter;
148     uint public numberOfInvestors;
149 
150     mapping(uint => address) public investorsToWithdrawIter;
151     uint public numberOfInvestorsToWithdraw;
152 
153     function Crowdsale() payable Owned() {}
154 
155     //abstract methods
156     function emitTokens(address _investor, uint _usdwei) internal returns(uint tokensToEmit);
157 
158     function emitAdditionalTokens() internal;
159 
160     function burnTokens(address _address, uint _amount) internal;
161 
162     function() payable crowdsaleState limitNotExceeded crowdsaleNotFinished {
163         uint valueWEI = msg.value;
164         uint valueUSDWEI = valueWEI * etherPriceUSDWEI / 1 ether;
165         if (collectedUSDWEI + valueUSDWEI > totalLimitUSDWEI) { // don't need so much ether
166             valueUSDWEI = totalLimitUSDWEI - collectedUSDWEI;
167             valueWEI = valueUSDWEI * 1 ether / etherPriceUSDWEI;
168             uint weiToReturn = msg.value - valueWEI;
169             bool isSent = msg.sender.call.gas(3000000).value(weiToReturn)();
170             require(isSent);
171             collectedUSDWEI = totalLimitUSDWEI; // to be sure!                                              
172         } else {
173             collectedUSDWEI += valueUSDWEI;
174         }
175         emitTokensFor(msg.sender, valueUSDWEI, valueWEI);
176     }
177 
178     function depositUSD(address _to, uint _amountUSDWEI) external onlyOwner crowdsaleState limitNotExceeded crowdsaleNotFinished {
179         collectedUSDWEI += _amountUSDWEI;
180         emitTokensFor(_to, _amountUSDWEI, 0);
181     }
182 
183     function depositBTC(address _to, uint _amountBTCWEI, uint _btcPriceUSDWEI, bytes32 _btcTxId) external onlyOwnerOrBtcOracle crowdsaleState limitNotExceeded crowdsaleNotFinished {
184         uint valueUSDWEI = _amountBTCWEI * _btcPriceUSDWEI / 1 ether;
185         BtcDeposit storage btcDep = btcDeposits[_btcTxId];
186         require(btcDep.amountBTCWEI == 0);
187         btcDep.amountBTCWEI = _amountBTCWEI;
188         btcDep.btcPriceUSDWEI = _btcPriceUSDWEI;
189         btcDep.investor = _to;
190         collectedUSDWEI += valueUSDWEI;
191         emitTokensFor(_to, valueUSDWEI, 0);
192     }
193 
194     function emitTokensFor(address _investor, uint _valueUSDWEI, uint _valueWEI) internal {
195         var emittedTokens = emitTokens(_investor, _valueUSDWEI);
196         Investor storage inv = investors[_investor];
197         if (inv.amountTokens == 0) { // new investor
198             investorsIter[numberOfInvestors++] = _investor;
199         }
200         inv.amountTokens += emittedTokens;
201         if (state == State.Sale) {
202             inv.amountWei += _valueWEI;
203         }
204     }
205 
206     function startPreSale(
207         address _beneficiary,
208         uint _etherPriceUSDWEI,
209         uint _totalLimitUSDWEI,
210         uint _crowdsaleDurationDays) external onlyOwner {
211         require(state == State.Initial);
212         crowdsaleStartTime = now;
213         beneficiary = _beneficiary;
214         etherPriceUSDWEI = _etherPriceUSDWEI;
215         totalLimitUSDWEI = _totalLimitUSDWEI;
216         crowdsaleFinishTime = now + _crowdsaleDurationDays * 1 days;
217         collectedUSDWEI = 0;
218         setState(State.PreSale);
219     }
220 
221     function finishPreSale() public onlyOwner {
222         require(state == State.PreSale);
223         bool isSent = beneficiary.call.gas(3000000).value(this.balance)();
224         require(isSent);
225         setState(State.WaitingForSale);
226     }
227 
228     function startSale(
229         address _beneficiary,
230         uint _etherPriceUSDWEI,
231         uint _totalLimitUSDWEI,
232         uint _crowdsaleDurationDays,
233         uint _minimalSuccessUSDWEI) external onlyOwner {
234 
235         require(state == State.WaitingForSale);
236         crowdsaleStartTime = now;
237         beneficiary = _beneficiary;
238         etherPriceUSDWEI = _etherPriceUSDWEI;
239         totalLimitUSDWEI = _totalLimitUSDWEI;
240         crowdsaleFinishTime = now + _crowdsaleDurationDays * 1 days;
241         minimalSuccessUSDWEI = _minimalSuccessUSDWEI;
242         collectedUSDWEI = 0;
243         setState(State.Sale);
244     }
245 
246     function failSale(uint _investorsToProcess) public {
247         require(state == State.Sale);
248         require(now >= crowdsaleFinishTime && collectedUSDWEI < minimalSuccessUSDWEI);
249         while (_investorsToProcess > 0 && numberOfInvestors > 0) {
250             address addr = investorsIter[--numberOfInvestors];
251             Investor memory inv = investors[addr];
252             burnTokens(addr, inv.amountTokens);
253             --_investorsToProcess;
254             delete investorsIter[numberOfInvestors];
255 
256             investorsToWithdrawIter[numberOfInvestorsToWithdraw] = addr;
257             numberOfInvestorsToWithdraw++;
258         }
259         if (numberOfInvestors > 0) {
260             return;
261         }
262         setState(State.SaleFailed);
263     }
264 
265     function completeSale(uint _investorsToProcess) public onlyOwner {
266         require(state == State.Sale);
267         require(collectedUSDWEI >= minimalSuccessUSDWEI);
268 
269         while (_investorsToProcess > 0 && numberOfInvestors > 0) {
270             --numberOfInvestors;
271             --_investorsToProcess;
272             delete investors[investorsIter[numberOfInvestors]];
273             delete investorsIter[numberOfInvestors];
274         }
275 
276         if (numberOfInvestors > 0) {
277             return;
278         }
279 
280         emitAdditionalTokens();
281 
282         bool isSent = beneficiary.call.gas(3000000).value(this.balance)();
283         require(isSent);
284         setState(State.CrowdsaleCompleted);
285     }
286 
287     function setEtherPriceUSDWEI(uint _etherPriceUSDWEI) external onlyOwnerOrOracle {
288         etherPriceUSDWEI = _etherPriceUSDWEI;
289     }
290 
291     function setBeneficiary(address _beneficiary) external onlyOwner() {
292         require(_beneficiary != 0);
293         beneficiary = _beneficiary;
294     }
295 
296     // This function must be called by token holder in case of crowdsale failed
297     function withdrawBack() external saleFailedState {
298         returnInvestmentsToInternal(msg.sender);
299     }
300 
301     function returnInvestments(uint _investorsToProcess) public saleFailedState {
302         while (_investorsToProcess > 0 && numberOfInvestorsToWithdraw > 0) {
303             address addr = investorsToWithdrawIter[--numberOfInvestorsToWithdraw];
304             delete investorsToWithdrawIter[numberOfInvestorsToWithdraw];
305             --_investorsToProcess;
306             returnInvestmentsToInternal(addr);
307         }
308     }
309 
310     function returnInvestmentsTo(address _to) public saleFailedState {
311         returnInvestmentsToInternal(_to);
312     }
313 
314     function returnInvestmentsToInternal(address _to) internal {
315         Investor memory inv = investors[_to];
316         uint value = inv.amountWei;
317         if (value > 0) {
318             delete investors[_to];
319             require(_to.call.gas(3000000).value(value)());
320         }
321     }
322 
323     function withdrawFunds(uint _value) public onlyOwner {
324         require(state == State.PreSale || (state == State.Sale && collectedUSDWEI > minimalSuccessUSDWEI));
325         if (_value == 0) {
326             _value = this.balance;
327         }
328         bool isSent = beneficiary.call.gas(3000000).value(_value)();
329         require(isSent);
330     }
331 
332     modifier crowdsaleNotFinished {
333         require(now < crowdsaleFinishTime);
334         _;
335     }
336 
337     modifier limitNotExceeded {
338         require(collectedUSDWEI < totalLimitUSDWEI);
339         _;
340     }
341 
342     modifier crowdsaleState {
343         require(state == State.PreSale || state == State.Sale);
344         _;
345     }
346 
347     modifier saleFailedState {
348         require(state == State.SaleFailed);
349         _;
350     }
351 
352     modifier completedSaleState {
353         require(state == State.CrowdsaleCompleted);
354         _;
355     }
356 }
357 
358 contract Token is Crowdsale, ERC20 {
359 
360     mapping(address => uint) internal balances;
361     mapping(address => mapping(address => uint)) public allowed;
362     uint8 public constant decimals = 8;
363 
364     function Token() payable Crowdsale() {}
365 
366     function balanceOf(address who) constant returns(uint) {
367         return balances[who];
368     }
369 
370     function transfer(address _to, uint _value) public completedSaleState onlyPayloadSize(2 * 32) {
371         require(balances[msg.sender] >= _value);
372         require(balances[_to] + _value >= balances[_to]); // overflow
373         balances[msg.sender] -= _value;
374         balances[_to] += _value;
375         Transfer(msg.sender, _to, _value);
376     }
377 
378     function transferFrom(address _from, address _to, uint _value) public completedSaleState onlyPayloadSize(3 * 32) {
379         require(balances[_from] >= _value);
380         require(balances[_to] + _value >= balances[_to]); // overflow
381         require(allowed[_from][msg.sender] >= _value);
382         balances[_from] -= _value;
383         balances[_to] += _value;
384         allowed[_from][msg.sender] -= _value;
385         Transfer(_from, _to, _value);
386     }
387 
388     function approve(address _spender, uint _value) public completedSaleState {
389         allowed[msg.sender][_spender] = _value;
390         Approval(msg.sender, _spender, _value);
391     }
392 
393     function allowance(address _owner, address _spender) public constant completedSaleState returns(uint remaining) {
394         return allowed[_owner][_spender];
395     }
396 
397     modifier onlyPayloadSize(uint size) {
398         require(msg.data.length >= size + 4);
399         _;
400     }
401 }
402 
403 contract MigratableToken is Token {
404 
405     function MigratableToken() payable Token() {}
406 
407     bool stateMigrated = false;
408     address public migrationAgent;
409     uint public totalMigrated;
410     address public migrationHost;
411     mapping(address => bool) migratedInvestors;
412 
413     event Migrated(address indexed from, address indexed to, uint value);
414 
415     function setMigrationHost(address _address) external onlyOwner {
416         require(_address != 0);
417         migrationHost = _address;
418     }
419 
420     function migrateStateFromHost() external onlyOwner {
421         require(stateMigrated == false && migrationHost != 0);
422 
423         PreArtexToken preArtex = PreArtexToken(migrationHost);
424 
425         state = Stateful.State.PreSale;
426 
427         etherPriceUSDWEI = preArtex.etherPriceUSDWEI();
428         beneficiary = preArtex.beneficiary();
429         totalLimitUSDWEI = preArtex.totalLimitUSDWEI();
430         minimalSuccessUSDWEI = preArtex.minimalSuccessUSDWEI();
431         collectedUSDWEI = preArtex.collectedUSDWEI();
432 
433         crowdsaleStartTime = preArtex.crowdsaleStartTime();
434         crowdsaleFinishTime = preArtex.crowdsaleFinishTime();
435 
436         stateMigrated = true;
437     }
438 
439     function migrateInvestorsFromHost(uint batchSize) external onlyOwner {
440         require(migrationHost != 0);
441 
442         PreArtexToken preArtex = PreArtexToken(migrationHost);
443 
444         uint numberOfInvestorsToMigrate = preArtex.numberOfInvestors();
445         uint currentNumberOfInvestors = numberOfInvestors;
446 
447         require(currentNumberOfInvestors < numberOfInvestorsToMigrate);
448 
449         for (uint i = 0; i < batchSize; i++) {
450             uint index = currentNumberOfInvestors + i;
451             if (index < numberOfInvestorsToMigrate) {
452                 address investor = preArtex.investorsIter(index);
453                 migrateInvestorsFromHostInternal(investor, preArtex);                
454             }
455             else
456                 break;
457         }
458     }
459 
460     function migrateInvestorFromHost(address _address) external onlyOwner {
461         require(migrationHost != 0);
462 
463         PreArtexToken preArtex = PreArtexToken(migrationHost);
464 
465         migrateInvestorsFromHostInternal(_address, preArtex);
466     }
467 
468     function migrateInvestorsFromHostInternal(address _address, PreArtexToken preArtex) internal {
469         require(state != State.SaleFailed && migratedInvestors[_address] == false);
470 
471         var (tokensToTransfer, weiToTransfer) = preArtex.investors(_address);
472 
473         require(tokensToTransfer > 0);
474 
475         balances[_address] = tokensToTransfer;
476         totalSupply += tokensToTransfer;
477         migratedInvestors[_address] = true;
478 
479         if (state != State.CrowdsaleCompleted) {
480             Investor storage investor = investors[_address];
481             investorsIter[numberOfInvestors] = _address;
482             
483             numberOfInvestors++;
484 
485             investor.amountTokens += tokensToTransfer;
486             investor.amountWei += weiToTransfer;
487         }
488 
489         Transfer(this, _address, tokensToTransfer);
490     }
491 
492     //migration by investor
493     function migrate() external {
494         require(migrationAgent != 0);
495         uint value = balances[msg.sender];
496         balances[msg.sender] -= value;
497         Transfer(msg.sender, this, value);
498         totalSupply -= value;
499         totalMigrated += value;
500         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
501         Migrated(msg.sender, migrationAgent, value);
502     }
503 
504     function setMigrationAgent(address _agent) external onlyOwner {
505         require(migrationAgent == 0);
506         migrationAgent = _agent;
507     }
508 }
509 
510 contract ArtexToken is MigratableToken {
511 
512     string public constant symbol = "ARX";
513 
514     string public constant name = "Artex Token";
515 
516     mapping(address => bool) public allowedContracts;
517 
518     function ArtexToken() payable MigratableToken() {}
519 
520     function emitTokens(address _investor, uint _valueUSDWEI) internal returns(uint tokensToEmit) {
521         tokensToEmit = getTokensToEmit(_valueUSDWEI);
522         require(balances[_investor] + tokensToEmit > balances[_investor]); // overflow
523         require(tokensToEmit > 0);
524         balances[_investor] += tokensToEmit;
525         totalSupply += tokensToEmit;
526         Transfer(this, _investor, tokensToEmit);
527     }
528 
529     function getTokensToEmit(uint _valueUSDWEI) internal constant returns (uint) {
530         uint percentWithBonus;
531         if (state == State.PreSale) {
532             percentWithBonus = 130;
533         } else if (state == State.Sale) {
534             if (_valueUSDWEI < 1000 * 1 ether)
535                 percentWithBonus = 100;
536             else if (_valueUSDWEI < 5000 * 1 ether)
537                 percentWithBonus = 103;
538             else if (_valueUSDWEI < 10000 * 1 ether)
539                 percentWithBonus = 105;
540             else if (_valueUSDWEI < 50000 * 1 ether)
541                 percentWithBonus = 110;
542             else if (_valueUSDWEI < 100000 * 1 ether)
543                 percentWithBonus = 115;
544             else
545                 percentWithBonus = 120;
546         }
547 
548         return (_valueUSDWEI * percentWithBonus * (10 ** uint(decimals))) / (tokenPriceUSDWEI * 100);
549     }
550 
551     function emitAdditionalTokens() internal {
552         uint tokensToEmit = totalSupply * 100 / 74 - totalSupply;
553         require(balances[beneficiary] + tokensToEmit > balances[beneficiary]); // overflow
554         require(tokensToEmit > 0);
555         balances[beneficiary] += tokensToEmit;
556         totalSupply += tokensToEmit;
557         Transfer(this, beneficiary, tokensToEmit);
558     }
559 
560     function burnTokens(address _address, uint _amount) internal {
561         balances[_address] -= _amount;
562         totalSupply -= _amount;
563         Transfer(_address, this, _amount);
564     }
565 
566     function addAllowedContract(address _address) external onlyOwner {
567         require(_address != 0);
568         allowedContracts[_address] = true;
569     }
570 
571     function removeAllowedContract(address _address) external onlyOwner {
572         require(_address != 0);
573         delete allowedContracts[_address];
574     }
575 
576     function transferToKnownContract(address _to, uint256 _value, bytes32[] _data) external onlyAllowedContracts(_to) {
577         var knownContract = KnownContract(_to);
578         transfer(_to, _value);
579         knownContract.transfered(msg.sender, _value, _data);
580     }
581 
582     modifier onlyAllowedContracts(address _address) {
583         require(allowedContracts[_address] == true);
584         _;
585     }
586 }