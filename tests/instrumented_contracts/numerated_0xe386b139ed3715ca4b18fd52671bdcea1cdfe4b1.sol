1 pragma solidity ^ 0.4.13;
2 
3 contract MigrationAgent {
4     function migrateFrom(address _from, uint256 _value);
5 }
6 
7 contract PreZeusToken {
8     function balanceOf(address _owner) constant returns(uint256 balance);
9 }
10 
11 contract Owned {
12 
13     address public owner;
14     address public newOwner;
15     address public oracle;
16     address public btcOracle;
17 
18     function Owned() payable {
19         owner = msg.sender;
20     }
21 
22     modifier onlyOwner {
23         require(owner == msg.sender);
24         _;
25     }
26 
27     modifier onlyOwnerOrOracle {
28         require(owner == msg.sender || oracle == msg.sender);
29         _;
30     }
31 
32     modifier onlyOwnerOrBtcOracle {
33         require(owner == msg.sender || btcOracle == msg.sender);
34         _;
35     }
36 
37     function changeOwner(address _owner) onlyOwner external {
38         require(_owner != 0);
39         newOwner = _owner;
40     }
41 
42     function confirmOwner() external {
43         require(newOwner == msg.sender);
44         owner = newOwner;
45         delete newOwner;
46     }
47 
48     function changeOracle(address _oracle) onlyOwner external {
49         require(_oracle != 0);
50         oracle = _oracle;
51     }
52 
53     function changeBtcOracle(address _btcOracle) onlyOwner external {
54         require(_btcOracle != 0);
55         btcOracle = _btcOracle;
56     }
57 }
58 
59 contract KnownContract {
60     function transfered(address _sender, uint256 _value, bytes32[] _data) external;
61 }
62 
63 contract ERC20 {
64     uint public totalSupply;
65 
66     function balanceOf(address who) constant returns(uint);
67 
68     function transfer(address to, uint value);
69 
70     function allowance(address owner, address spender) constant returns(uint);
71 
72     function transferFrom(address from, address to, uint value);
73 
74     function approve(address spender, uint value);
75     event Approval(address indexed owner, address indexed spender, uint value);
76     event Transfer(address indexed from, address indexed to, uint value);
77 }
78 
79 contract Stateful {
80     enum State {
81         Initial,
82         PrivateSale,
83         PreSale,
84         WaitingForSale,
85         Sale,
86         CrowdsaleCompleted,
87         SaleFailed
88     }
89     State public state = State.Initial;
90 
91     event StateChanged(State oldState, State newState);
92 
93     function setState(State newState) internal {
94         State oldState = state;
95         state = newState;
96         StateChanged(oldState, newState);
97     }
98 }
99 
100 contract Crowdsale is Owned, Stateful {
101 
102     uint public etherPriceUSDWEI;
103     address public beneficiary;
104     uint public totalLimitUSDWEI;
105     uint public minimalSuccessUSDWEI;
106     uint public collectedUSDWEI;
107 
108     uint public crowdsaleStartTime;
109     uint public crowdsaleFinishTime;
110 
111     struct Investor {
112         uint amountTokens;
113         uint amountWei;
114     }
115 
116     struct BtcDeposit {
117         uint amountBTCWEI;
118         uint btcPriceUSDWEI;
119         address investor;
120     }
121 
122     mapping(bytes32 => BtcDeposit) public btcDeposits;
123 
124     mapping(address => Investor) public investors;
125     mapping(uint => address) public investorsIter;
126     uint public numberOfInvestors;
127 
128     mapping(uint => address) public investorsToWithdrawIter;
129     uint public numberOfInvestorsToWithdraw;
130 
131     function Crowdsale() payable Owned() {}
132 
133     //abstract methods
134     function emitTokens(address _investor, uint _tokenPriceUSDWEI, uint _usdwei) internal returns(uint tokensToEmit);
135 
136     function emitAdditionalTokens() internal;
137 
138     function burnTokens(address _address, uint _amount) internal;
139 
140     function() payable crowdsaleState limitNotExceeded {
141         uint valueWEI = msg.value;
142         uint valueUSDWEI = valueWEI * etherPriceUSDWEI / 1 ether;
143         uint tokenPriceUSDWEI = getTokenPriceUSDWEI(valueUSDWEI);
144 
145         if (collectedUSDWEI + valueUSDWEI > totalLimitUSDWEI) { // don't need so much ether
146             valueUSDWEI = totalLimitUSDWEI - collectedUSDWEI;
147             valueWEI = valueUSDWEI * 1 ether / etherPriceUSDWEI;
148             uint weiToReturn = msg.value - valueWEI;
149             bool isSent = msg.sender.call.gas(3000000).value(weiToReturn)();
150             require(isSent);
151             collectedUSDWEI = totalLimitUSDWEI; // to be sure!                                                   
152         } else {
153             collectedUSDWEI += valueUSDWEI;
154         }
155         emitTokensFor(msg.sender, tokenPriceUSDWEI, valueUSDWEI, valueWEI);
156 
157     }
158 
159     function depositUSD(address _to, uint _amountUSDWEI) external onlyOwner crowdsaleState limitNotExceeded {
160         uint tokenPriceUSDWEI = getTokenPriceUSDWEI(_amountUSDWEI);
161         collectedUSDWEI += _amountUSDWEI;
162         emitTokensFor(_to, tokenPriceUSDWEI, _amountUSDWEI, 0);
163     }
164 
165     function depositBTC(address _to, uint _amountBTCWEI, uint _btcPriceUSDWEI, bytes32 _btcTxId) external onlyOwnerOrBtcOracle crowdsaleState limitNotExceeded {
166         uint valueUSDWEI = _amountBTCWEI * _btcPriceUSDWEI / 1 ether;
167         uint tokenPriceUSDWEI = getTokenPriceUSDWEI(valueUSDWEI);
168         BtcDeposit storage btcDep = btcDeposits[_btcTxId];
169         require(btcDep.amountBTCWEI == 0);
170         btcDep.amountBTCWEI = _amountBTCWEI;
171         btcDep.btcPriceUSDWEI = _btcPriceUSDWEI;
172         btcDep.investor = _to;
173         collectedUSDWEI += valueUSDWEI;
174         emitTokensFor(_to, tokenPriceUSDWEI, valueUSDWEI, 0);
175     }
176 
177     function emitTokensFor(address _investor, uint _tokenPriceUSDWEI, uint _valueUSDWEI, uint _valueWEI) internal {
178         var emittedTokens = emitTokens(_investor, _tokenPriceUSDWEI, _valueUSDWEI);
179         Investor storage inv = investors[_investor];
180         if (inv.amountTokens == 0) { // new investor
181             investorsIter[numberOfInvestors++] = _investor;
182         }
183         inv.amountTokens += emittedTokens;
184         if (state == State.Sale) {
185             inv.amountWei += _valueWEI;
186         }
187     }
188 
189     function getTokenPriceUSDWEI(uint _valueUSDWEI) internal returns(uint tokenPriceUSDWEI) {
190         tokenPriceUSDWEI = 0;
191         if (state == State.PrivateSale) {
192             tokenPriceUSDWEI = 6000000000000000;
193         }
194         if (state == State.PreSale) {
195             require(now < crowdsaleFinishTime);
196             tokenPriceUSDWEI = 7000000000000000;
197         }
198         if (state == State.Sale) {
199             require(now < crowdsaleFinishTime);
200             if (now < crowdsaleStartTime + 1 days) {
201                 if (_valueUSDWEI > 30000 * 1 ether) {
202                     tokenPriceUSDWEI = 7500000000000000;
203                 } else {
204                     tokenPriceUSDWEI = 8500000000000000;
205                 }
206             } else if (now < crowdsaleStartTime + 1 weeks) {
207                 tokenPriceUSDWEI = 9000000000000000;
208             } else if (now < crowdsaleStartTime + 2 weeks) {
209                 tokenPriceUSDWEI = 9500000000000000;
210             } else {
211                 tokenPriceUSDWEI = 10000000000000000;
212             }
213         }
214     }
215 
216     function startPrivateSale(address _beneficiary, uint _etherPriceUSDWEI, uint _totalLimitUSDWEI) external onlyOwner {
217         require(state == State.Initial);
218         beneficiary = _beneficiary;
219         etherPriceUSDWEI = _etherPriceUSDWEI;
220         totalLimitUSDWEI = _totalLimitUSDWEI;
221         crowdsaleStartTime = now;
222         setState(State.PrivateSale);
223     }
224 
225     function finishPrivateSaleAndStartPreSale(
226         address _beneficiary,
227         uint _etherPriceUSDWEI,
228         uint _totalLimitUSDWEI,
229         uint _crowdsaleDurationDays) public onlyOwner {
230         require(state == State.PrivateSale);
231 
232         bool isSent = beneficiary.call.gas(3000000).value(this.balance)();
233         require(isSent);
234 
235         crowdsaleStartTime = now;
236         beneficiary = _beneficiary;
237         etherPriceUSDWEI = _etherPriceUSDWEI;
238         totalLimitUSDWEI = _totalLimitUSDWEI;
239         crowdsaleFinishTime = now + _crowdsaleDurationDays * 1 days;
240         collectedUSDWEI = 0;
241         setState(State.PreSale);
242     }
243 
244 
245     function finishPreSale() public onlyOwner {
246         require(state == State.PreSale);
247         bool isSent = beneficiary.call.gas(3000000).value(this.balance)();
248         require(isSent);
249         setState(State.WaitingForSale);
250     }
251 
252     function startSale(
253         address _beneficiary,
254         uint _etherPriceUSDWEI,
255         uint _totalLimitUSDWEI,
256         uint _crowdsaleDurationDays,
257         uint _minimalSuccessUSDWEI) external onlyOwner {
258 
259         require(state == State.WaitingForSale);
260         crowdsaleStartTime = now;
261         beneficiary = _beneficiary;
262         etherPriceUSDWEI = _etherPriceUSDWEI;
263         totalLimitUSDWEI = _totalLimitUSDWEI;
264         crowdsaleFinishTime = now + _crowdsaleDurationDays * 1 days;
265         minimalSuccessUSDWEI = _minimalSuccessUSDWEI;
266         collectedUSDWEI = 0;
267         setState(State.Sale);
268     }
269 
270     function failSale(uint _investorsToProcess) public {
271         require(state == State.Sale);
272         require(now >= crowdsaleFinishTime && collectedUSDWEI < minimalSuccessUSDWEI);
273         while (_investorsToProcess > 0 && numberOfInvestors > 0) {
274             address addr = investorsIter[--numberOfInvestors];
275             Investor memory inv = investors[addr];
276             burnTokens(addr, inv.amountTokens);
277             --_investorsToProcess;
278             delete investorsIter[numberOfInvestors];
279 
280             investorsToWithdrawIter[numberOfInvestorsToWithdraw] = addr;
281             numberOfInvestorsToWithdraw++;
282         }
283         if (numberOfInvestors > 0) {
284             return;
285         }
286         setState(State.SaleFailed);
287     }
288 
289     function completeSale(uint _investorsToProcess) public onlyOwner {
290         require(state == State.Sale);
291         require(collectedUSDWEI >= minimalSuccessUSDWEI);
292 
293         while (_investorsToProcess > 0 && numberOfInvestors > 0) {
294             --numberOfInvestors;
295             --_investorsToProcess;
296             delete investors[investorsIter[numberOfInvestors]];
297             delete investorsIter[numberOfInvestors];
298         }
299 
300         if (numberOfInvestors > 0) {
301             return;
302         }
303 
304         emitAdditionalTokens();
305 
306         bool isSent = beneficiary.call.gas(3000000).value(this.balance)();
307         require(isSent);
308         setState(State.CrowdsaleCompleted);
309     }
310 
311 
312     function setEtherPriceUSDWEI(uint _etherPriceUSDWEI) external onlyOwnerOrOracle {
313         etherPriceUSDWEI = _etherPriceUSDWEI;
314     }
315 
316     function setBeneficiary(address _beneficiary) external onlyOwner {
317         require(_beneficiary != 0);
318         beneficiary = _beneficiary;
319     }
320 
321     // This function must be called by token holder in case of crowdsale failed
322     function withdrawBack() external saleFailedState {
323         returnInvestmentsToInternal(msg.sender);
324     }
325 
326     function returnInvestments(uint _investorsToProcess) public saleFailedState {
327         while (_investorsToProcess > 0 && numberOfInvestorsToWithdraw > 0) {
328             address addr = investorsToWithdrawIter[--numberOfInvestorsToWithdraw];
329             delete investorsToWithdrawIter[numberOfInvestorsToWithdraw];
330             --_investorsToProcess;
331             returnInvestmentsToInternal(addr);
332         }
333     }
334 
335     function returnInvestmentsTo(address _to) public saleFailedState {
336         returnInvestmentsToInternal(_to);
337     }
338 
339     function returnInvestmentsToInternal(address _to) internal {
340         Investor memory inv = investors[_to];
341         uint value = inv.amountWei;
342         if (value > 0) {
343             delete investors[_to];
344             require(_to.call.gas(3000000).value(value)());
345         }
346     }
347 
348     function withdrawFunds(uint _value) public onlyOwner {
349         require(state == State.PrivateSale || state == State.PreSale || (state == State.Sale && collectedUSDWEI > minimalSuccessUSDWEI));
350         if (_value == 0) {
351             _value = this.balance;
352         }
353         bool isSent = beneficiary.call.gas(3000000).value(_value)();
354         require(isSent);
355     }
356 
357     modifier limitNotExceeded {
358         require(collectedUSDWEI < totalLimitUSDWEI);
359         _;
360     }
361 
362     modifier crowdsaleState {
363         require(state == State.PrivateSale || state == State.PreSale || state == State.Sale);
364         _;
365     }
366 
367     modifier saleFailedState {
368         require(state == State.SaleFailed);
369         _;
370     }
371 
372     modifier completedSaleState {
373         require(state == State.CrowdsaleCompleted);
374         _;
375     }
376 }
377 
378 contract Token is Crowdsale, ERC20 {
379 
380     mapping(address => uint) internal balances;
381     mapping(address => mapping(address => uint)) public allowed;
382     uint8 public constant decimals = 8;
383 
384     function Token() payable Crowdsale() {}
385 
386     function balanceOf(address who) constant returns(uint) {
387         return balances[who];
388     }
389 
390     function transfer(address _to, uint _value) public completedSaleState onlyPayloadSize(2 * 32) {
391         require(balances[msg.sender] >= _value);
392         require(balances[_to] + _value >= balances[_to]); // overflow
393         balances[msg.sender] -= _value;
394         balances[_to] += _value;
395         Transfer(msg.sender, _to, _value);
396     }
397 
398     function transferFrom(address _from, address _to, uint _value) public completedSaleState onlyPayloadSize(3 * 32) {
399         require(balances[_from] >= _value);
400         require(balances[_to] + _value >= balances[_to]); // overflow
401         require(allowed[_from][msg.sender] >= _value);
402         balances[_from] -= _value;
403         balances[_to] += _value;
404         allowed[_from][msg.sender] -= _value;
405         Transfer(_from, _to, _value);
406     }
407 
408     function approve(address _spender, uint _value) public completedSaleState {
409         allowed[msg.sender][_spender] = _value;
410         Approval(msg.sender, _spender, _value);
411     }
412 
413     function allowance(address _owner, address _spender) public constant completedSaleState returns(uint remaining) {
414         return allowed[_owner][_spender];
415     }
416 
417     modifier onlyPayloadSize(uint size) {
418         require(msg.data.length >= size + 4);
419         _;
420     }
421 }
422 
423 contract MigratableToken is Token {
424 
425     function MigratableToken() payable Token() {}
426 
427     address public migrationAgent;
428     uint public totalMigrated;
429     address public migrationHost;
430     mapping(address => bool) migratedInvestors;
431 
432     event Migrated(address indexed from, address indexed to, uint value);
433 
434     function setMigrationHost(address _address) external onlyOwner {
435         require(_address != 0);
436         migrationHost = _address;
437     }
438 
439     //manual migration by owner
440     function migrateInvestorFromHost(address _address) external onlyOwner {
441         require(migrationHost != 0 && state != State.SaleFailed && migratedInvestors[_address] == false);
442         PreZeusToken preZeus = PreZeusToken(migrationHost);
443         uint tokensToTransfer = preZeus.balanceOf(_address);
444         require(tokensToTransfer > 0);
445 
446         balances[_address] = tokensToTransfer;
447         totalSupply += tokensToTransfer;
448         migratedInvestors[_address] = true;
449 
450         if (state != State.CrowdsaleCompleted) {
451             Investor storage inv = investors[_address];
452             investorsIter[numberOfInvestors++] = _address;
453             inv.amountTokens += tokensToTransfer;
454         }
455 
456         Transfer(this, _address, tokensToTransfer);
457     }
458 
459     //migration by investor
460     function migrate() external {
461         require(migrationAgent != 0);
462         uint value = balances[msg.sender];
463         balances[msg.sender] -= value;
464         Transfer(msg.sender, this, value);
465         totalSupply -= value;
466         totalMigrated += value;
467         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
468         Migrated(msg.sender, migrationAgent, value);
469     }
470 
471     function setMigrationAgent(address _agent) external onlyOwner {
472         require(migrationAgent == 0);
473         migrationAgent = _agent;
474     }
475 }
476 
477 contract ZeusToken is MigratableToken {
478 
479     string public constant symbol = "ZST";
480 
481     string public constant name = "Zeus Token";
482 
483     mapping(address => bool) public allowedContracts;
484 
485     function ZeusToken() payable MigratableToken() {}
486 
487     function emitTokens(address _investor, uint _tokenPriceUSDWEI, uint _valueUSDWEI) internal returns(uint tokensToEmit) {
488         tokensToEmit = (_valueUSDWEI * (10 ** uint(decimals))) / _tokenPriceUSDWEI;
489         require(balances[_investor] + tokensToEmit > balances[_investor]); // overflow
490         require(tokensToEmit > 0);
491         balances[_investor] += tokensToEmit;
492         totalSupply += tokensToEmit;
493         Transfer(this, _investor, tokensToEmit);
494     }
495 
496     function emitAdditionalTokens() internal {
497         uint tokensToEmit = totalSupply * 1000 / 705 - totalSupply;
498         require(balances[beneficiary] + tokensToEmit > balances[beneficiary]); // overflow
499         require(tokensToEmit > 0);
500         balances[beneficiary] += tokensToEmit;
501         totalSupply += tokensToEmit;
502         Transfer(this, beneficiary, tokensToEmit);
503     }
504 
505     function burnTokens(address _address, uint _amount) internal {
506         balances[_address] -= _amount;
507         totalSupply -= _amount;
508         Transfer(_address, this, _amount);
509     }
510 
511     function addAllowedContract(address _address) external onlyOwner {
512         require(_address != 0);
513         allowedContracts[_address] = true;
514     }
515 
516     function removeAllowedContract(address _address) external onlyOwner {
517         require(_address != 0);
518         delete allowedContracts[_address];
519     }
520 
521     function transferToKnownContract(address _to, uint256 _value, bytes32[] _data) external onlyAllowedContracts(_to) {
522         var knownContract = KnownContract(_to);
523         transfer(_to, _value);
524         knownContract.transfered(msg.sender, _value, _data);
525     }
526 
527     modifier onlyAllowedContracts(address _address) {
528         require(allowedContracts[_address] == true);
529         _;
530     }
531 }