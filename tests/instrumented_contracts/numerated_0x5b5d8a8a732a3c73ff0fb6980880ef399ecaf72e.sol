1 /*
2 This file is part of the PROOF Contract.
3 
4 The PROOF Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The PROOF Contract is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the PROOF Contract. If not, see <http://www.gnu.org/licenses/>.
16 
17 @author Ilya Svirin <i.svirin@nordavind.ru>
18 */
19 
20 pragma solidity ^0.4.0;
21 
22 contract owned {
23     address public owner;
24     address public newOwner;
25 
26     function owned() payable {
27         owner = msg.sender;
28     }
29     
30     modifier onlyOwner {
31         require(owner == msg.sender);
32         _;
33     }
34 
35     function changeOwner(address _owner) onlyOwner public {
36         require(_owner != 0);
37         newOwner = _owner;
38     }
39     
40     function confirmOwner() public {
41         require(newOwner == msg.sender);
42         owner = newOwner;
43         delete newOwner;
44     }
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 {
52     uint public totalSupply;
53     function balanceOf(address who) constant returns (uint);
54     function transfer(address to, uint value);
55     function allowance(address owner, address spender) constant returns (uint);
56     function transferFrom(address from, address to, uint value);
57     function approve(address spender, uint value);
58     event Approval(address indexed owner, address indexed spender, uint value);
59     event Transfer(address indexed from, address indexed to, uint value);
60 }
61 
62 contract ManualMigration is owned, ERC20 {
63     mapping (address => uint) internal balances;
64     address public migrationHost;
65 
66     function ManualMigration(address _migrationHost) payable owned() {
67         migrationHost = _migrationHost;
68         //balances[this] = ERC20(migrationHost).balanceOf(migrationHost);
69     }
70 
71     function migrateManual(address _tokensHolder) onlyOwner {
72         require(migrationHost != 0);
73         uint tokens = ERC20(migrationHost).balanceOf(_tokensHolder);
74         tokens = tokens * 125 / 100;
75         balances[_tokensHolder] = tokens;
76         totalSupply += tokens;
77         Transfer(migrationHost, _tokensHolder, tokens);
78     }
79     
80     function sealManualMigration() onlyOwner {
81         delete migrationHost;
82     }
83 }
84 
85 /**
86  * @title Crowdsale implementation
87  */
88 contract Crowdsale is ManualMigration {
89     uint    public etherPrice;
90     address public crowdsaleOwner;
91     uint    public totalLimitUSD;
92     uint    public minimalSuccessUSD;
93     uint    public collectedUSD;
94 
95     enum State { Disabled, PreICO, CompletePreICO, Crowdsale, Enabled, Migration }
96     event NewState(State state);
97     State   public state = State.Disabled;
98     uint    public crowdsaleStartTime;
99     uint    public crowdsaleFinishTime;
100 
101     modifier enabledState {
102         require(state == State.Enabled);
103         _;
104     }
105 
106     modifier enabledOrMigrationState {
107         require(state == State.Enabled || state == State.Migration);
108         _;
109     }
110 
111     struct Investor {
112         uint amountTokens;
113         uint amountWei;
114     }
115     mapping (address => Investor) public investors;
116     mapping (uint => address)     public investorsIter;
117     uint                          public numberOfInvestors;
118 
119     function Crowdsale(address _migrationHost)
120         payable ManualMigration(_migrationHost) {
121     }
122     
123     function () payable {
124         require(state == State.PreICO || state == State.Crowdsale);
125         require(now < crowdsaleFinishTime);
126         uint valueWei = msg.value;
127         uint valueUSD = valueWei * etherPrice / 1000000000000000000;
128         if (collectedUSD + valueUSD > totalLimitUSD) { // don't need so much ether
129             valueUSD = totalLimitUSD - collectedUSD;
130             valueWei = valueUSD * 1000000000000000000 / etherPrice;
131             require(msg.sender.call.gas(3000000).value(msg.value - valueWei)());
132             collectedUSD = totalLimitUSD; // to be sure!
133         } else {
134             collectedUSD += valueUSD;
135         }
136         mintTokens(msg.sender, valueUSD, valueWei);
137     }
138 
139     function depositUSD(address _who, uint _valueUSD) public onlyOwner {
140         require(state == State.PreICO || state == State.Crowdsale);
141         require(now < crowdsaleFinishTime);
142         require(collectedUSD + _valueUSD <= totalLimitUSD);
143         collectedUSD += _valueUSD;
144         mintTokens(_who, _valueUSD, 0);
145     }
146 
147     function mintTokens(address _who, uint _valueUSD, uint _valueWei) internal {
148         uint tokensPerUSD = 100;
149         if (state == State.PreICO) {
150             if (now < crowdsaleStartTime + 1 days && _valueUSD >= 50000) {
151                 tokensPerUSD = 150;
152             } else {
153                 tokensPerUSD = 125;
154             }
155         } else if (state == State.Crowdsale) {
156             if (now < crowdsaleStartTime + 1 days) {
157                 tokensPerUSD = 115;
158             } else if (now < crowdsaleStartTime + 1 weeks) {
159                 tokensPerUSD = 110;
160             }
161         }
162         uint tokens = tokensPerUSD * _valueUSD;
163         require(balances[_who] + tokens > balances[_who]); // overflow
164         require(tokens > 0);
165         Investor storage inv = investors[_who];
166         if (inv.amountTokens == 0) { // new investor
167             investorsIter[numberOfInvestors++] = _who;
168         }
169         inv.amountTokens += tokens;
170         inv.amountWei += _valueWei;
171         balances[_who] += tokens;
172         Transfer(this, _who, tokens);
173         totalSupply += tokens;
174     }
175     
176     function startTokensSale(
177             address _crowdsaleOwner,
178             uint    _crowdsaleDurationDays,
179             uint    _totalLimitUSD,
180             uint    _minimalSuccessUSD,
181             uint    _etherPrice) public onlyOwner {
182         require(state == State.Disabled || state == State.CompletePreICO);
183         crowdsaleStartTime = now;
184         crowdsaleOwner = _crowdsaleOwner;
185         etherPrice = _etherPrice;
186         delete numberOfInvestors;
187         delete collectedUSD;
188         crowdsaleFinishTime = now + _crowdsaleDurationDays * 1 days;
189         totalLimitUSD = _totalLimitUSD;
190         minimalSuccessUSD = _minimalSuccessUSD;
191         if (state == State.Disabled) {
192             state = State.PreICO;
193         } else {
194             state = State.Crowdsale;
195         }
196         NewState(state);
197     }
198     
199     function timeToFinishTokensSale() public constant returns(uint t) {
200         require(state == State.PreICO || state == State.Crowdsale);
201         if (now > crowdsaleFinishTime) {
202             t = 0;
203         } else {
204             t = crowdsaleFinishTime - now;
205         }
206     }
207     
208     function finishTokensSale(uint _investorsToProcess) public {
209         require(state == State.PreICO || state == State.Crowdsale);
210         require(now >= crowdsaleFinishTime || collectedUSD == totalLimitUSD ||
211             (collectedUSD >= minimalSuccessUSD && msg.sender == owner));
212         if (collectedUSD < minimalSuccessUSD) {
213             // Investors can get their ether calling withdrawBack() function
214             while (_investorsToProcess > 0 && numberOfInvestors > 0) {
215                 address addr = investorsIter[--numberOfInvestors];
216                 Investor memory inv = investors[addr];
217                 balances[addr] -= inv.amountTokens;
218                 totalSupply -= inv.amountTokens;
219                 Transfer(addr, this, inv.amountTokens);
220                 --_investorsToProcess;
221                 delete investorsIter[numberOfInvestors];
222             }
223             if (numberOfInvestors > 0) {
224                 return;
225             }
226             if (state == State.PreICO) {
227                 state = State.Disabled;
228             } else {
229                 state = State.CompletePreICO;
230             }
231         } else {
232             while (_investorsToProcess > 0 && numberOfInvestors > 0) {
233                 --numberOfInvestors;
234                 --_investorsToProcess;
235                 delete investors[investorsIter[numberOfInvestors]];
236                 delete investorsIter[numberOfInvestors];
237             }
238             if (numberOfInvestors > 0) {
239                 return;
240             }
241             if (state == State.PreICO) {
242                 require(crowdsaleOwner.call.gas(3000000).value(this.balance)());
243                 state = State.CompletePreICO;
244             } else {
245                 require(crowdsaleOwner.call.gas(3000000).value(minimalSuccessUSD * 1000000000000000000 / etherPrice)());
246                 // Create additional tokens for owner (30% of complete totalSupply)
247                 uint tokens = 3 * totalSupply / 7;
248                 balances[owner] = tokens;
249                 totalSupply += tokens;
250                 Transfer(this, owner, tokens);
251                 state = State.Enabled;
252             }
253         }
254         NewState(state);
255     }
256     
257     // This function must be called by token holder in case of crowdsale failed
258     function withdrawBack() public {
259         require(state == State.Disabled || state == State.CompletePreICO);
260         uint value = investors[msg.sender].amountWei;
261         if (value > 0) {
262             delete investors[msg.sender];
263             require(msg.sender.call.gas(3000000).value(value)());
264         }
265     }
266 }
267 
268 /**
269  * @title Abstract interface for PROOF operating from registered external controllers
270  */
271 contract Fund {
272     function transferFund(address _to, uint _value);
273 }
274 
275 /**
276  * @title Token PROOF implementation
277  */
278 contract Token is Crowdsale, Fund {
279     
280     string  public standard    = 'Token 0.1';
281     string  public name        = 'PROOF';
282     string  public symbol      = "PF";
283     uint8   public decimals    = 0;
284 
285     mapping (address => mapping (address => uint)) public allowed;
286     mapping (address => bool) public externalControllers;
287 
288     modifier onlyTokenHolders {
289         require(balances[msg.sender] != 0);
290         _;
291     }
292 
293     // Fix for the ERC20 short address attack
294     modifier onlyPayloadSize(uint size) {
295         require(msg.data.length >= size + 4);
296         _;
297     }
298 
299     modifier externalController {
300         require(externalControllers[msg.sender]);
301         _;
302     }
303 
304     function Token(address _migrationHost)
305         payable Crowdsale(_migrationHost) {}
306 
307     function balanceOf(address who) constant returns (uint) {
308         return balances[who];
309     }
310 
311     function transfer(address _to, uint _value)
312         public enabledState onlyPayloadSize(2 * 32) {
313         require(balances[msg.sender] >= _value);
314         require(balances[_to] + _value >= balances[_to]); // overflow
315         balances[msg.sender] -= _value;
316         balances[_to] += _value;
317         Transfer(msg.sender, _to, _value);
318     }
319     
320     function transferFrom(address _from, address _to, uint _value)
321         public enabledState onlyPayloadSize(3 * 32) {
322         require(balances[_from] >= _value);
323         require(balances[_to] + _value >= balances[_to]); // overflow
324         require(allowed[_from][msg.sender] >= _value);
325         balances[_from] -= _value;
326         balances[_to] += _value;
327         allowed[_from][msg.sender] -= _value;
328         Transfer(_from, _to, _value);
329     }
330 
331     function approve(address _spender, uint _value) public enabledState {
332         allowed[msg.sender][_spender] = _value;
333         Approval(msg.sender, _spender, _value);
334     }
335 
336     function allowance(address _owner, address _spender) public constant enabledState
337         returns (uint remaining) {
338         return allowed[_owner][_spender];
339     }
340 
341     function transferFund(address _to, uint _value) public externalController {
342         require(balances[this] >= _value);
343         require(balances[_to] + _value >= balances[_to]); // overflow
344         balances[this] -= _value;
345         balances[_to] += _value;
346         Transfer(this, _to, _value);
347     }
348 }
349 
350 contract ProofVote is Token {
351 
352     function ProofVote(address _migrationHost)
353         payable Token(_migrationHost) {}
354 
355     event VotingStarted(uint weiReqFund, VoteReason voteReason);
356     event Voted(address indexed voter, bool inSupport);
357     event VotingFinished(bool inSupport);
358 
359     enum Vote { NoVote, VoteYea, VoteNay }
360     enum VoteReason { Nothing, ReqFund, Migration, UpdateContract }
361 
362     uint public weiReqFund;
363     uint public votingDeadline;
364     uint public numberOfVotes;
365     uint public yea;
366     uint public nay;
367     VoteReason  voteReason;
368     mapping (address => Vote) public votes;
369     mapping (uint => address) public votesIter;
370 
371     address public migrationAgent;
372     address public migrationAgentCandidate;
373     address public externalControllerCandidate;
374 
375     function startVoting(uint _weiReqFund) public enabledOrMigrationState onlyOwner {
376         require(_weiReqFund > 0);
377         internalStartVoting(_weiReqFund, VoteReason.ReqFund, 7);
378     }
379 
380     function internalStartVoting(uint _weiReqFund, VoteReason _voteReason, uint _votingDurationDays) internal {
381         require(voteReason == VoteReason.Nothing && _weiReqFund <= this.balance);
382         weiReqFund = _weiReqFund;
383         votingDeadline = now + _votingDurationDays * 1 days;
384         voteReason = _voteReason;
385         delete yea;
386         delete nay;
387         VotingStarted(_weiReqFund, _voteReason);
388     }
389     
390     function votingInfo() public constant
391         returns(uint _weiReqFund, uint _timeToFinish, VoteReason _voteReason) {
392         _weiReqFund = weiReqFund;
393         _voteReason = voteReason;
394         if (votingDeadline <= now) {
395             _timeToFinish = 0;
396         } else {
397             _timeToFinish = votingDeadline - now;
398         }
399     }
400 
401     function vote(bool _inSupport) public onlyTokenHolders returns (uint voteId) {
402         require(voteReason != VoteReason.Nothing);
403         require(votes[msg.sender] == Vote.NoVote);
404         require(votingDeadline > now);
405         voteId = numberOfVotes++;
406         votesIter[voteId] = msg.sender;
407         if (_inSupport) {
408             votes[msg.sender] = Vote.VoteYea;
409         } else {
410             votes[msg.sender] = Vote.VoteNay;
411         }
412         Voted(msg.sender, _inSupport);
413         return voteId;
414     }
415 
416     function finishVoting(uint _votesToProcess) public returns (bool _inSupport) {
417         require(voteReason != VoteReason.Nothing);
418         require(now >= votingDeadline);
419 
420         while (_votesToProcess > 0 && numberOfVotes > 0) {
421             address voter = votesIter[--numberOfVotes];
422             Vote v = votes[voter];
423             uint voteWeight = balances[voter];
424             if (v == Vote.VoteYea) {
425                 yea += voteWeight;
426             } else if (v == Vote.VoteNay) {
427                 nay += voteWeight;
428             }
429             delete votes[voter];
430             delete votesIter[numberOfVotes];
431             --_votesToProcess;
432         }
433         if (numberOfVotes > 0) {
434             _inSupport = false;
435             return;
436         }
437 
438         _inSupport = (yea > nay);
439         uint weiForSend = weiReqFund;
440         delete weiReqFund;
441         delete votingDeadline;
442         delete numberOfVotes;
443 
444         if (_inSupport) {
445             if (voteReason == VoteReason.ReqFund) {
446                 require(owner.call.gas(3000000).value(weiForSend)());
447             } else if (voteReason == VoteReason.Migration) {
448                 migrationAgent = migrationAgentCandidate;
449                 require(migrationAgent.call.gas(3000000).value(this.balance)());
450                 delete migrationAgentCandidate;
451                 state = State.Migration;
452             } else if (voteReason == VoteReason.UpdateContract) {
453                 externalControllers[externalControllerCandidate] = true;
454                 delete externalControllerCandidate;
455             }
456         }
457 
458         delete voteReason;
459         VotingFinished(_inSupport);
460     }
461 }
462 
463 /**
464  * @title Migration agent intefrace for possibility of moving tokens
465  *        to another contract
466  */
467 contract MigrationAgent {
468     function migrateFrom(address _from, uint _value);
469 }
470 
471 /**
472  * @title Migration functionality for possibility of moving tokens
473  *        to another contract
474  */
475 contract TokenMigration is ProofVote {
476     
477     uint public totalMigrated;
478 
479     event Migrate(address indexed from, address indexed to, uint value);
480 
481     function TokenMigration(address _migrationHost) payable ProofVote(_migrationHost) {}
482 
483     // Migrate _value of tokens to the new token contract
484     function migrate() external {
485         require(state == State.Migration);
486         uint value = balances[msg.sender];
487         balances[msg.sender] -= value;
488         Transfer(msg.sender, this, value);
489         totalSupply -= value;
490         totalMigrated += value;
491         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
492         Migrate(msg.sender, migrationAgent, value);
493     }
494 
495     function setMigrationAgent(address _agent) external onlyOwner {
496         require(migrationAgent == 0 && _agent != 0);
497         migrationAgentCandidate = _agent;
498         internalStartVoting(0, VoteReason.Migration, 2);
499     }
500 }
501 
502 contract ProofFund is TokenMigration {
503 
504     function ProofFund(address _migrationHost)
505         payable TokenMigration(_migrationHost) {}
506 
507     function addExternalController(address _externalControllerCandidate) public onlyOwner {
508         require(_externalControllerCandidate != 0);
509         externalControllerCandidate = _externalControllerCandidate;
510         internalStartVoting(0, VoteReason.UpdateContract, 2);
511     }
512 
513     function removeExternalController(address _externalController) public onlyOwner {
514         delete externalControllers[_externalController];
515     }
516 }
517 
518 /**
519  * @title Proof interface
520  */
521 contract ProofAbstract {
522     function swypeCode(address _who) returns (uint16 _swype);
523     function setHash(address _who, uint16 _swype, bytes32 _hash);
524 }
525 
526 contract Proof is ProofFund {
527 
528     uint    public priceInTokens;
529     uint    public teamFee;
530     address public proofImpl;
531 
532     function Proof(address _migrationHost)
533         payable ProofFund(_migrationHost) {}
534 
535     function setPrice(uint _priceInTokens) public onlyOwner {
536         require(_priceInTokens >= 2);
537         teamFee = _priceInTokens / 10;
538         if (teamFee == 0) {
539             teamFee = 1;
540         }
541         priceInTokens = _priceInTokens - teamFee;
542     }
543 
544     function setProofImpl(address _proofImpl) public onlyOwner {
545         proofImpl = _proofImpl;
546     }
547 
548     function swypeCode() public returns (uint16 _swype) {
549         require(proofImpl != 0);
550         _swype = ProofAbstract(proofImpl).swypeCode(msg.sender);
551     }
552     
553     function setHash(uint16 _swype, bytes32 _hash) public {
554         require(proofImpl != 0);
555         transfer(owner, teamFee);
556         transfer(this, priceInTokens);
557         ProofAbstract(proofImpl).setHash(msg.sender, _swype, _hash);
558     }
559 }