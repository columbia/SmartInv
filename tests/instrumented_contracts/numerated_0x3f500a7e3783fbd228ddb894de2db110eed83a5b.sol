1 pragma solidity ^ 0.4.13;
2 
3 contract MigrationAgent {
4     function migrateFrom(address _from, uint256 _value);
5 }
6 
7 contract PreArtexToken {
8     function balanceOf(address _owner) constant returns(uint256 balance);
9     mapping(address => uint) public deposits;
10     uint public tokenPriceUSDWEI;
11 }
12 
13 contract Owned {
14 
15     address public owner;
16     address public newOwner;
17     address public oracle;
18     address public btcOracle;
19 
20     function Owned() payable {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         require(owner == msg.sender);
26         _;
27     }
28 
29     modifier onlyOwnerOrOracle {
30         require(owner == msg.sender || oracle == msg.sender);
31         _;
32     }
33 
34     modifier onlyOwnerOrBtcOracle {
35         require(owner == msg.sender || btcOracle == msg.sender);
36         _;
37     }
38 
39     function changeOwner(address _owner) onlyOwner external {
40         require(_owner != 0);
41         newOwner = _owner;
42     }
43 
44     function confirmOwner() external {
45         require(newOwner == msg.sender);
46         owner = newOwner;
47         delete newOwner;
48     }
49 
50     function changeOracle(address _oracle) onlyOwner external {
51         require(_oracle != 0);
52         oracle = _oracle;
53     }
54 
55     function changeBtcOracle(address _btcOracle) onlyOwner external {
56         require(_btcOracle != 0);
57         btcOracle = _btcOracle;
58     }
59 }
60 
61 contract KnownContract {
62     function transfered(address _sender, uint256 _value, bytes32[] _data) external;
63 }
64 
65 contract ERC20 {
66     uint public totalSupply;
67 
68     function balanceOf(address who) constant returns(uint);
69 
70     function transfer(address to, uint value);
71 
72     function allowance(address owner, address spender) constant returns(uint);
73 
74     function transferFrom(address from, address to, uint value);
75 
76     function approve(address spender, uint value);
77 
78     event Approval(address indexed owner, address indexed spender, uint value);
79 
80     event Transfer(address indexed from, address indexed to, uint value);
81 }
82 
83 contract Stateful {
84     enum State {
85         Initial,
86         PreSale,
87         WaitingForSale,
88         Sale,
89         CrowdsaleCompleted,
90         SaleFailed
91     }
92 
93     State public state = State.Initial;
94 
95     event StateChanged(State oldState, State newState);
96 
97     function setState(State newState) internal {
98         State oldState = state;
99         state = newState;
100         StateChanged(oldState, newState);
101     }
102 }
103 
104 contract Crowdsale is Owned, Stateful {
105 
106     uint public etherPriceUSDWEI;
107     address public beneficiary;
108     uint public totalLimitUSDWEI;
109     uint public minimalSuccessUSDWEI;
110     uint public collectedUSDWEI;
111 
112     uint public crowdsaleStartTime;
113     uint public crowdsaleFinishTime;
114 
115     struct Investor {
116         uint amountTokens;
117         uint amountWei;
118     }
119 
120     struct BtcDeposit {
121         uint amountBTCWEI;
122         uint btcPriceUSDWEI;
123         address investor;
124     }
125 
126     mapping(bytes32 => BtcDeposit) public btcDeposits;
127 
128     mapping(address => Investor) public investors;
129     mapping(uint => address) public investorsIter;
130     uint public numberOfInvestors;
131 
132     mapping(uint => address) public investorsToWithdrawIter;
133     uint public numberOfInvestorsToWithdraw;
134 
135     function Crowdsale() payable Owned() {}
136 
137     //abstract methods
138     function emitTokens(address _investor, uint _tokenPriceUSDWEI, uint _usdwei) internal returns(uint tokensToEmit);
139 
140     function emitAdditionalTokens() internal;
141 
142     function burnTokens(address _address, uint _amount) internal;
143 
144     function() payable crowdsaleState limitNotExceeded crowdsaleNotFinished {
145         uint valueWEI = msg.value;
146         uint valueUSDWEI = valueWEI * etherPriceUSDWEI / 1 ether;
147         uint tokenPriceUSDWEI = getTokenPriceUSDWEI();
148         if (collectedUSDWEI + valueUSDWEI > totalLimitUSDWEI) { // don't need so much ether
149             valueUSDWEI = totalLimitUSDWEI - collectedUSDWEI;
150             valueWEI = valueUSDWEI * 1 ether / etherPriceUSDWEI;
151             uint weiToReturn = msg.value - valueWEI;
152             bool isSent = msg.sender.call.gas(3000000).value(weiToReturn)();
153             require(isSent);
154             collectedUSDWEI = totalLimitUSDWEI; // to be sure!                                              
155         } else {
156             collectedUSDWEI += valueUSDWEI;
157         }
158         emitTokensFor(msg.sender, tokenPriceUSDWEI, valueUSDWEI, valueWEI);
159     }
160 
161     function depositUSD(address _to, uint _amountUSDWEI) external onlyOwner crowdsaleState limitNotExceeded crowdsaleNotFinished {
162         uint tokenPriceUSDWEI = getTokenPriceUSDWEI();
163         collectedUSDWEI += _amountUSDWEI;
164         emitTokensFor(_to, tokenPriceUSDWEI, _amountUSDWEI, 0);
165     }
166 
167     function depositBTC(address _to, uint _amountBTCWEI, uint _btcPriceUSDWEI, bytes32 _btcTxId) external onlyOwnerOrBtcOracle crowdsaleState limitNotExceeded crowdsaleNotFinished {
168         uint valueUSDWEI = _amountBTCWEI * _btcPriceUSDWEI / 1 ether;
169         uint tokenPriceUSDWEI = getTokenPriceUSDWEI();
170         BtcDeposit storage btcDep = btcDeposits[_btcTxId];
171         require(btcDep.amountBTCWEI == 0);
172         btcDep.amountBTCWEI = _amountBTCWEI;
173         btcDep.btcPriceUSDWEI = _btcPriceUSDWEI;
174         btcDep.investor = _to;
175         collectedUSDWEI += valueUSDWEI;
176         emitTokensFor(_to, tokenPriceUSDWEI, valueUSDWEI, 0);
177     }
178 
179     function emitTokensFor(address _investor, uint _tokenPriceUSDWEI, uint _valueUSDWEI, uint _valueWEI) internal {
180         var emittedTokens = emitTokens(_investor, _tokenPriceUSDWEI, _valueUSDWEI);
181         Investor storage inv = investors[_investor];
182         if (inv.amountTokens == 0) { // new investor
183             investorsIter[numberOfInvestors++] = _investor;
184         }
185         inv.amountTokens += emittedTokens;
186         if (state == State.Sale) {
187             inv.amountWei += _valueWEI;
188         }
189     }
190 
191     function getTokenPriceUSDWEI() internal returns(uint tokenPriceUSDWEI) {
192         tokenPriceUSDWEI = 0;
193         if (state == State.PreSale) {
194             tokenPriceUSDWEI = 76923076923076900;
195         }
196         if (state == State.Sale) {
197             if (now < crowdsaleStartTime + 1 days) {
198                 tokenPriceUSDWEI = 86956521730000000;
199             } else if (now < crowdsaleStartTime + 1 weeks) {
200                 tokenPriceUSDWEI = 90909090900000000;
201             } else if (now < crowdsaleStartTime + 2 weeks) {
202                 tokenPriceUSDWEI = 95238095230000000;
203             } else {
204                 tokenPriceUSDWEI = 100000000000000000;
205             }
206         }
207     }
208 
209     function startPreSale(
210         address _beneficiary,
211         uint _etherPriceUSDWEI,
212         uint _totalLimitUSDWEI,
213         uint _crowdsaleDurationDays) external onlyOwner {
214         require(state == State.Initial);
215         crowdsaleStartTime = now;
216         beneficiary = _beneficiary;
217         etherPriceUSDWEI = _etherPriceUSDWEI;
218         totalLimitUSDWEI = _totalLimitUSDWEI;
219         crowdsaleFinishTime = now + _crowdsaleDurationDays * 1 days;
220         collectedUSDWEI = 0;
221         setState(State.PreSale);
222     }
223 
224     function finishPreSale() public onlyOwner {
225         require(state == State.PreSale);
226         bool isSent = beneficiary.call.gas(3000000).value(this.balance)();
227         require(isSent);
228         setState(State.WaitingForSale);
229     }
230 
231     function startSale(
232         address _beneficiary,
233         uint _etherPriceUSDWEI,
234         uint _totalLimitUSDWEI,
235         uint _crowdsaleDurationDays,
236         uint _minimalSuccessUSDWEI) external onlyOwner {
237 
238         require(state == State.WaitingForSale);
239         crowdsaleStartTime = now;
240         beneficiary = _beneficiary;
241         etherPriceUSDWEI = _etherPriceUSDWEI;
242         totalLimitUSDWEI = _totalLimitUSDWEI;
243         crowdsaleFinishTime = now + _crowdsaleDurationDays * 1 days;
244         minimalSuccessUSDWEI = _minimalSuccessUSDWEI;
245         collectedUSDWEI = 0;
246         setState(State.Sale);
247     }
248 
249     function failSale(uint _investorsToProcess) public {
250         require(state == State.Sale);
251         require(now >= crowdsaleFinishTime && collectedUSDWEI < minimalSuccessUSDWEI);
252         while (_investorsToProcess > 0 && numberOfInvestors > 0) {
253             address addr = investorsIter[--numberOfInvestors];
254             Investor memory inv = investors[addr];
255             burnTokens(addr, inv.amountTokens);
256             --_investorsToProcess;
257             delete investorsIter[numberOfInvestors];
258 
259             investorsToWithdrawIter[numberOfInvestorsToWithdraw] = addr;
260             numberOfInvestorsToWithdraw++;
261         }
262         if (numberOfInvestors > 0) {
263             return;
264         }
265         setState(State.SaleFailed);
266     }
267 
268     function completeSale(uint _investorsToProcess) public onlyOwner {
269         require(state == State.Sale);
270         require(collectedUSDWEI >= minimalSuccessUSDWEI);
271 
272         while (_investorsToProcess > 0 && numberOfInvestors > 0) {
273             --numberOfInvestors;
274             --_investorsToProcess;
275             delete investors[investorsIter[numberOfInvestors]];
276             delete investorsIter[numberOfInvestors];
277         }
278 
279         if (numberOfInvestors > 0) {
280             return;
281         }
282 
283         emitAdditionalTokens();
284 
285         bool isSent = beneficiary.call.gas(3000000).value(this.balance)();
286         require(isSent);
287         setState(State.CrowdsaleCompleted);
288     }
289 
290     function setEtherPriceUSDWEI(uint _etherPriceUSDWEI) external onlyOwnerOrOracle {
291         etherPriceUSDWEI = _etherPriceUSDWEI;
292     }
293 
294     function setBeneficiary(address _beneficiary) external onlyOwner() {
295         require(_beneficiary != 0);
296         beneficiary = _beneficiary;
297     }
298 
299     // This function must be called by token holder in case of crowdsale failed
300     function withdrawBack() external saleFailedState {
301         returnInvestmentsToInternal(msg.sender);
302     }
303 
304     function returnInvestments(uint _investorsToProcess) public saleFailedState {
305         while (_investorsToProcess > 0 && numberOfInvestorsToWithdraw > 0) {
306             address addr = investorsToWithdrawIter[--numberOfInvestorsToWithdraw];
307             delete investorsToWithdrawIter[numberOfInvestorsToWithdraw];
308             --_investorsToProcess;
309             returnInvestmentsToInternal(addr);
310         }
311     }
312 
313     function returnInvestmentsTo(address _to) public saleFailedState {
314         returnInvestmentsToInternal(_to);
315     }
316 
317     function returnInvestmentsToInternal(address _to) internal {
318         Investor memory inv = investors[_to];
319         uint value = inv.amountWei;
320         if (value > 0) {
321             delete investors[_to];
322             require(_to.call.gas(3000000).value(value)());
323         }
324     }
325 
326     function withdrawFunds(uint _value) public onlyOwner {
327         require(state == State.PreSale || (state == State.Sale && collectedUSDWEI > minimalSuccessUSDWEI));
328         if (_value == 0) {
329             _value = this.balance;
330         }
331         bool isSent = beneficiary.call.gas(3000000).value(_value)();
332         require(isSent);
333     }
334 
335     modifier crowdsaleNotFinished {
336         require(now < crowdsaleFinishTime);
337         _;
338     }
339 
340     modifier limitNotExceeded {
341         require(collectedUSDWEI < totalLimitUSDWEI);
342         _;
343     }
344 
345     modifier crowdsaleState {
346         require(state == State.PreSale || state == State.Sale);
347         _;
348     }
349 
350     modifier saleFailedState {
351         require(state == State.SaleFailed);
352         _;
353     }
354 
355     modifier completedSaleState {
356         require(state == State.CrowdsaleCompleted);
357         _;
358     }
359 }
360 
361 contract Token is Crowdsale, ERC20 {
362 
363     mapping(address => uint) internal balances;
364     mapping(address => mapping(address => uint)) public allowed;
365     uint8 public constant decimals = 8;
366 
367 
368     function Token() payable Crowdsale() {}
369 
370     function balanceOf(address who) constant returns(uint) {
371         return balances[who];
372     }
373 
374     function transfer(address _to, uint _value) public completedSaleState onlyPayloadSize(2 * 32) {
375         require(balances[msg.sender] >= _value);
376         require(balances[_to] + _value >= balances[_to]); // overflow
377         balances[msg.sender] -= _value;
378         balances[_to] += _value;
379         Transfer(msg.sender, _to, _value);
380     }
381 
382     function transferFrom(address _from, address _to, uint _value) public completedSaleState onlyPayloadSize(3 * 32) {
383         require(balances[_from] >= _value);
384         require(balances[_to] + _value >= balances[_to]); // overflow
385         require(allowed[_from][msg.sender] >= _value);
386         balances[_from] -= _value;
387         balances[_to] += _value;
388         allowed[_from][msg.sender] -= _value;
389         Transfer(_from, _to, _value);
390     }
391 
392     function approve(address _spender, uint _value) public completedSaleState {
393         allowed[msg.sender][_spender] = _value;
394         Approval(msg.sender, _spender, _value);
395     }
396 
397     function allowance(address _owner, address _spender) public constant completedSaleState returns(uint remaining) {
398         return allowed[_owner][_spender];
399     }
400 
401     modifier onlyPayloadSize(uint size) {
402         require(msg.data.length >= size + 4);
403         _;
404     }
405 }
406 
407 contract MigratableToken is Token {
408 
409     function MigratableToken() payable Token() {}
410 
411     address public migrationAgent;
412     uint public totalMigrated;
413     address public migrationHost;
414     mapping(address => bool) migratedInvestors;
415 
416     event Migrated(address indexed from, address indexed to, uint value);
417 
418     function setMigrationHost(address _address) external onlyOwner {
419         require(_address != 0);
420         migrationHost = _address;
421     }
422 
423     //manual migration by owner
424     function migrateInvestorFromHost(address _address) external onlyOwner {
425         require(migrationHost != 0 &&
426             state != State.SaleFailed &&
427             etherPriceUSDWEI != 0 &&
428             migratedInvestors[_address] == false);
429 
430         PreArtexToken preArtex = PreArtexToken(migrationHost);
431         uint tokensDecimals = preArtex.balanceOf(_address);
432         require(tokensDecimals > 0);
433         uint depositWEI = preArtex.deposits(_address);
434         uint preArtexTokenPriceUSDWEI = preArtex.tokenPriceUSDWEI();
435         uint tokensToTransfer = 0;
436 
437         if (tokensDecimals != 0 && depositWEI == 0) {
438             tokensToTransfer = tokensDecimals * 140 / 130;
439         } else {
440             var preArtexEtherPriceUSDWEI = ((tokensDecimals * preArtexTokenPriceUSDWEI * 1 ether) / (depositWEI * (10 ** uint(decimals))));
441             if (etherPriceUSDWEI > preArtexEtherPriceUSDWEI) {
442                 tokensToTransfer = (tokensDecimals * etherPriceUSDWEI * 140) / (preArtexEtherPriceUSDWEI * 130);
443             } else {
444                 tokensToTransfer = tokensDecimals * 140 / 130;
445             }
446         }
447 
448         balances[_address] = tokensToTransfer;
449         totalSupply += tokensToTransfer;
450         migratedInvestors[_address] = true;
451 
452         if (state != State.CrowdsaleCompleted) {
453             Investor storage inv = investors[_address];
454             investorsIter[numberOfInvestors++] = _address;
455             inv.amountTokens += tokensToTransfer;
456         }
457 
458         Transfer(this, _address, tokensToTransfer);
459     }
460 
461     //migration by investor
462     function migrate() external {
463         require(migrationAgent != 0);
464         uint value = balances[msg.sender];
465         balances[msg.sender] -= value;
466         Transfer(msg.sender, this, value);
467         totalSupply -= value;
468         totalMigrated += value;
469         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
470         Migrated(msg.sender, migrationAgent, value);
471     }
472 
473     function setMigrationAgent(address _agent) external onlyOwner {
474         require(migrationAgent == 0);
475         migrationAgent = _agent;
476     }
477 }
478 
479 contract ArtexToken is MigratableToken {
480 
481     string public constant symbol = "ART";
482 
483     string public constant name = "Artex Token";
484 
485     mapping(address => bool) public allowedContracts;
486 
487     function ArtexToken() payable MigratableToken() {}
488 
489     function emitTokens(address _investor, uint _tokenPriceUSDWEI, uint _valueUSDWEI) internal returns(uint tokensToEmit) {
490         tokensToEmit = (_valueUSDWEI * (10 ** uint(decimals))) / _tokenPriceUSDWEI;
491         require(balances[_investor] + tokensToEmit > balances[_investor]); // overflow
492         require(tokensToEmit > 0);
493         balances[_investor] += tokensToEmit;
494         totalSupply += tokensToEmit;
495         Transfer(this, _investor, tokensToEmit);
496     }
497 
498     function emitAdditionalTokens() internal {
499         uint tokensToEmit = totalSupply * 100 / 74 - totalSupply;
500         require(balances[beneficiary] + tokensToEmit > balances[beneficiary]); // overflow
501         require(tokensToEmit > 0);
502         balances[beneficiary] += tokensToEmit;
503         totalSupply += tokensToEmit;
504         Transfer(this, beneficiary, tokensToEmit);
505     }
506 
507     function burnTokens(address _address, uint _amount) internal {
508         balances[_address] -= _amount;
509         totalSupply -= _amount;
510         Transfer(_address, this, _amount);
511     }
512 
513     function addAllowedContract(address _address) external onlyOwner {
514         require(_address != 0);
515         allowedContracts[_address] = true;
516     }
517 
518     function removeAllowedContract(address _address) external onlyOwner {
519         require(_address != 0);
520         delete allowedContracts[_address];
521     }
522 
523     function transferToKnownContract(address _to, uint256 _value, bytes32[] _data) external onlyAllowedContracts(_to) {
524         var knownContract = KnownContract(_to);
525         transfer(_to, _value);
526         knownContract.transfered(msg.sender, _value, _data);
527     }
528 
529     modifier onlyAllowedContracts(address _address) {
530         require(allowedContracts[_address] == true);
531         _;
532     }
533 }