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
16 */
17 
18 pragma solidity ^0.4.0;
19 
20 contract owned {
21 
22     address public owner;
23 
24     function owned() payable {
25         owner = msg.sender;
26     }
27     
28     modifier onlyOwner {
29         require(owner == msg.sender);
30         _;
31     }
32 
33     function changeOwner(address _owner) onlyOwner public {
34         require(_owner != 0);
35         owner = _owner;
36     }
37 }
38 
39 contract Crowdsale is owned {
40     
41     uint256 public totalSupply;
42     mapping (address => uint256) public balanceOf;
43 
44     uint    public etherPrice;
45     address public crowdsaleOwner;
46     uint    public totalLimitUSD;
47     uint    public minimalSuccessUSD;
48     uint    public collectedUSD;
49 
50     enum State { Disabled, PreICO, CompletePreICO, Crowdsale, Enabled, Migration }
51     event NewState(State state);
52     State   public state = State.Disabled;
53     uint    public crowdsaleStartTime;
54     uint    public crowdsaleFinishTime;
55 
56     modifier enabledState {
57         require(state == State.Enabled);
58         _;
59     }
60 
61     modifier enabledOrMigrationState {
62         require(state == State.Enabled || state == State.Migration);
63         _;
64     }
65 
66     struct Investor {
67         uint256 amountTokens;
68         uint    amountWei;
69     }
70     mapping (address => Investor) public investors;
71     mapping (uint => address)     public investorsIter;
72     uint                          public numberOfInvestors;
73     
74     function () payable {
75         require(state == State.PreICO || state == State.Crowdsale);
76         uint256 tokensPerUSD = 0;
77         if (state == State.PreICO) {
78             tokensPerUSD = 125;
79         } else if (state == State.Crowdsale) {
80             if (now < crowdsaleStartTime + 1 days) {
81                 tokensPerUSD = 115;
82             } else if (now < crowdsaleStartTime + 1 weeks) {
83                 tokensPerUSD = 110;
84             } else {
85                 tokensPerUSD = 100;
86             }
87         }
88         if (tokensPerUSD > 0) {
89             uint valueWei = msg.value;
90             uint valueUSD = valueWei * etherPrice / 1000000000000000000;
91             if (collectedUSD + valueUSD > totalLimitUSD) { // don't need so much ether
92                 valueUSD = totalLimitUSD - collectedUSD;
93                 valueWei = valueUSD * 1000000000000000000 / etherPrice;
94                 msg.sender.transfer(msg.value - valueWei);
95                 collectedUSD = totalLimitUSD; // to be sure!
96             } else {
97                 collectedUSD += valueUSD;
98             }
99             uint256 tokens = tokensPerUSD * valueUSD;
100             require(balanceOf[msg.sender] + tokens > balanceOf[msg.sender]); // overflow
101             require(tokens > 0);
102             
103             Investor storage inv = investors[msg.sender];
104             if (inv.amountWei == 0) { // new investor
105                 investorsIter[numberOfInvestors++] = msg.sender;
106             }
107             inv.amountTokens += tokens;
108             inv.amountWei += valueWei;
109             balanceOf[msg.sender] += tokens;
110             totalSupply += tokens;
111         }
112     }
113     
114     function startTokensSale(address _crowdsaleOwner, uint _etherPrice) public onlyOwner {
115         require(state == State.Disabled || state == State.CompletePreICO);
116         crowdsaleStartTime = now;
117         crowdsaleOwner = _crowdsaleOwner;
118         etherPrice = _etherPrice;
119         delete numberOfInvestors;
120         delete collectedUSD;
121         if (state == State.Disabled) {
122             crowdsaleFinishTime = now + 14 days;
123             state = State.PreICO;
124             totalLimitUSD = 300000;
125             minimalSuccessUSD = 300000;
126         } else {
127             crowdsaleFinishTime = now + 30 days;
128             state = State.Crowdsale;
129             totalLimitUSD = 5200000;
130             minimalSuccessUSD = 3600000;
131         }
132         NewState(state);
133     }
134     
135     function timeToFinishTokensSale() public constant returns(uint t) {
136         require(state == State.PreICO || state == State.Crowdsale);
137         if (now > crowdsaleFinishTime) {
138             t = 0;
139         } else {
140             t = crowdsaleFinishTime - now;
141         }
142     }
143     
144     function finishTokensSale(uint _investorsToProcess) public {
145         require(state == State.PreICO || state == State.Crowdsale);
146         require(now >= crowdsaleFinishTime || collectedUSD == totalLimitUSD);
147         if (collectedUSD < minimalSuccessUSD) {
148             // Investors can get their ether calling withdrawBack() function
149             while (_investorsToProcess > 0 && numberOfInvestors > 0) {
150                 address addr = investorsIter[--numberOfInvestors];
151                 Investor memory inv = investors[addr];
152                 balanceOf[addr] -= inv.amountTokens;
153                 totalSupply -= inv.amountTokens;
154                 --_investorsToProcess;
155                 delete investorsIter[numberOfInvestors];
156             }
157             if (numberOfInvestors > 0) {
158                 return;
159             }
160             if (state == State.PreICO) {
161                 state = State.Disabled;
162             } else {
163                 state = State.CompletePreICO;
164             }
165         } else {
166             while (_investorsToProcess > 0 && numberOfInvestors > 0) {
167                 --numberOfInvestors;
168                 --_investorsToProcess;
169                 delete investors[investorsIter[numberOfInvestors]];
170                 delete investorsIter[numberOfInvestors];
171             }
172             if (numberOfInvestors > 0) {
173                 return;
174             }
175             if (state == State.PreICO) {
176                 if (!crowdsaleOwner.send(this.balance)) throw;
177                 state = State.CompletePreICO;
178             } else {
179                 if (!crowdsaleOwner.send(1500000 * 1000000000000000000 / etherPrice)) throw;
180                 // Create additional tokens for owner (28% of complete totalSupply)
181                 balanceOf[owner] = totalSupply * 28 / 72;
182                 totalSupply += totalSupply * 28 / 72;
183                 state = State.Enabled;
184             }
185         }
186         NewState(state);
187     }
188     
189     // This function must be called by token holder in case of crowdsale failed
190     function withdrawBack() public {
191         require(state == State.Disabled || state == State.CompletePreICO);
192         uint value = investors[msg.sender].amountWei;
193         if (value > 0) {
194             delete investors[msg.sender];
195             msg.sender.transfer(value);
196         }
197     }
198 }
199 
200 contract Token is Crowdsale {
201     
202     string  public standard    = 'Token 0.1';
203     string  public name        = 'PROOF';
204     string  public symbol      = "PF";
205     uint8   public decimals    = 0;
206 
207     modifier onlyTokenHolders {
208         require(balanceOf[msg.sender] != 0);
209         _;
210     }
211 
212     mapping (address => mapping (address => uint256)) public allowed;
213 
214     event Transfer(address indexed from, address indexed to, uint256 value);
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 
217     function Token() payable Crowdsale() {}
218 
219     function transfer(address _to, uint256 _value) public enabledState {
220         require(balanceOf[msg.sender] >= _value);
221         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
222         balanceOf[msg.sender] -= _value;
223         balanceOf[_to] += _value;
224         Transfer(msg.sender, _to, _value);
225     }
226     
227     function transferFrom(address _from, address _to, uint256 _value) public enabledState {
228         require(balanceOf[_from] >= _value);
229         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
230         require(allowed[_from][msg.sender] >= _value);
231         balanceOf[_from] -= _value;
232         balanceOf[_to] += _value;
233         allowed[_from][msg.sender] -= _value;
234         Transfer(_from, _to, _value);
235     }
236 
237     function approve(address _spender, uint256 _value) public enabledState {
238         allowed[msg.sender][_spender] = _value;
239         Approval(msg.sender, _spender, _value);
240     }
241 
242     function allowance(address _owner, address _spender) public constant enabledState
243         returns (uint256 remaining) {
244         return allowed[_owner][_spender];
245     }
246 }
247 
248 contract MigrationAgent {
249     function migrateFrom(address _from, uint256 _value);
250 }
251 
252 contract TokenMigration is Token {
253     
254     address public migrationAgent;
255     uint256 public totalMigrated;
256 
257     event Migrate(address indexed from, address indexed to, uint256 value);
258 
259     function TokenMigration() payable Token() {}
260 
261     // Migrate _value of tokens to the new token contract
262     function migrate(uint256 _value) external {
263         require(state == State.Migration);
264         require(migrationAgent != 0);
265         require(_value != 0);
266         require(_value <= balanceOf[msg.sender]);
267         balanceOf[msg.sender] -= _value;
268         totalSupply -= _value;
269         totalMigrated += _value;
270         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
271         Migrate(msg.sender, migrationAgent, _value);
272     }
273 
274     function setMigrationAgent(address _agent) external onlyOwner {
275         require(migrationAgent == 0);
276         migrationAgent = _agent;
277         state = State.Migration;
278     }
279 }
280 
281 contract ProofTeamVote is TokenMigration {
282 
283     function ProofTeamVote() payable TokenMigration() {}
284 
285     event VotingStarted(uint weiReqFund);
286     event Voted(address indexed voter, bool inSupport);
287     event VotingFinished(bool inSupport);
288 
289     struct Vote {
290         bool inSupport;
291         bool voted;
292     }
293 
294     uint public weiReqFund;
295     uint public votingDeadline;
296     uint public numberOfVotes;
297     uint public yea;
298     uint public nay;
299     mapping (address => Vote) public votes;
300     mapping (uint => address) public votesIter;
301 
302     function startVoting(uint _weiReqFund) public enabledOrMigrationState onlyOwner {
303         require(weiReqFund == 0 && _weiReqFund > 0 && _weiReqFund <= this.balance);
304         weiReqFund = _weiReqFund;
305         votingDeadline = now + 7 days;
306         delete yea;
307         delete nay;
308         VotingStarted(_weiReqFund);
309     }
310     
311     function votingInfo() public constant enabledOrMigrationState
312         returns(uint _weiReqFund, uint _timeToFinish) {
313         _weiReqFund = weiReqFund;
314         if (votingDeadline <= now) {
315             _timeToFinish = 0;
316         } else {
317             _timeToFinish = votingDeadline - now;
318         }
319     }
320 
321     function vote(bool _inSupport) public onlyTokenHolders enabledOrMigrationState
322         returns (uint voteId) {
323         require(votes[msg.sender].voted != true);
324         require(votingDeadline > now);
325         voteId = numberOfVotes++;
326         votesIter[voteId] = msg.sender;
327         votes[msg.sender] = Vote({inSupport: _inSupport, voted: true});
328         Voted(msg.sender, _inSupport);
329         return voteId;
330     }
331 
332     function finishVoting(uint _votesToProcess) public enabledOrMigrationState
333         returns (bool _inSupport) {
334         require(now >= votingDeadline);
335 
336         while (_votesToProcess > 0 && numberOfVotes > 0) {
337             address voter = votesIter[--numberOfVotes];
338             Vote memory v = votes[voter];
339             uint voteWeight = balanceOf[voter];
340             if (v.inSupport) {
341                 yea += voteWeight;
342             } else {
343                 nay += voteWeight;
344             }
345             delete votes[voter];
346             delete votesIter[numberOfVotes];
347             --_votesToProcess;
348         }
349         if (numberOfVotes > 0) {
350             _inSupport = false;
351             return;
352         }
353 
354         _inSupport = (yea > nay);
355         uint weiForSend = weiReqFund;
356         delete weiReqFund;
357         delete votingDeadline;
358         delete numberOfVotes;
359 
360         if (_inSupport) {
361             if (migrationAgent == 0) {
362                 if (!owner.send(weiForSend)) throw;
363             } else {
364                 if (!migrationAgent.send(this.balance)) throw;
365             }
366         }
367 
368         VotingFinished(_inSupport);
369     }
370 }
371 
372 contract ProofPublicVote is ProofTeamVote {
373 
374     function ProofPublicVote() payable ProofTeamVote() {}
375 
376     event Deployed(address indexed projectOwner, uint proofReqFund, string urlInfo);
377     event Voted(address indexed projectOwner, address indexed voter, bool inSupport);
378     event VotingFinished(address indexed projectOwner, bool inSupport);
379 
380     struct Project {
381         uint   proofReqFund;
382         string urlInfo;
383         uint   votingDeadline;
384         uint   numberOfVotes;
385         uint   yea;
386         uint   nay;
387         mapping (address => Vote) votes;
388         mapping (uint => address) votesIter;
389     }
390     mapping (address => Project) public projects;
391 
392     function deployProject(uint _proofReqFund, string _urlInfo) public
393         onlyTokenHolders enabledOrMigrationState {
394         require(_proofReqFund > 0 && _proofReqFund <= balanceOf[this]);
395         require(_proofReqFund <= balanceOf[msg.sender] * 1000);
396         require(projects[msg.sender].proofReqFund == 0);
397         projects[msg.sender].proofReqFund = _proofReqFund;
398         projects[msg.sender].urlInfo = _urlInfo;
399         projects[msg.sender].votingDeadline = now + 7 days;
400         Deployed(msg.sender, _proofReqFund, _urlInfo);
401     }
402     
403     function projectInfo(address _projectOwner) enabledOrMigrationState constant public 
404         returns(uint _proofReqFund, string _urlInfo, uint _timeToFinish) {
405         _proofReqFund = projects[_projectOwner].proofReqFund;
406         _urlInfo = projects[_projectOwner].urlInfo;
407         if (projects[_projectOwner].votingDeadline <= now) {
408             _timeToFinish = 0;
409         } else {
410             _timeToFinish = projects[_projectOwner].votingDeadline - now;
411         }
412     }
413 
414     function vote(address _projectOwner, bool _inSupport) public
415         onlyTokenHolders enabledOrMigrationState returns (uint voteId) {
416         Project storage p = projects[_projectOwner];
417         require(p.proofReqFund > 0);
418         require(p.votes[msg.sender].voted != true);
419         require(p.votingDeadline > now);
420         voteId = p.numberOfVotes++;
421         p.votesIter[voteId] = msg.sender;
422         p.votes[msg.sender] = Vote({inSupport: _inSupport, voted: true});
423         Voted(_projectOwner, msg.sender, _inSupport); 
424         return voteId;
425     }
426 
427     function finishVoting(address _projectOwner, uint _votesToProcess) public
428         enabledOrMigrationState returns (bool _inSupport) {
429         Project storage p = projects[_projectOwner];
430         require(p.proofReqFund > 0);
431         require(now >= p.votingDeadline && p.proofReqFund <= balanceOf[this]);
432 
433         while (_votesToProcess > 0 && p.numberOfVotes > 0) {
434             address voter = p.votesIter[--p.numberOfVotes];
435             Vote memory v = p.votes[voter];
436             uint voteWeight = balanceOf[voter];
437             if (v.inSupport) {
438                 p.yea += voteWeight;
439             } else {
440                 p.nay += voteWeight;
441             }
442             delete p.votesIter[p.numberOfVotes];
443             delete p.votes[voter];
444             --_votesToProcess;
445         }
446         if (p.numberOfVotes > 0) {
447             _inSupport = false;
448             return;
449         }
450 
451         _inSupport = (p.yea > p.nay);
452 
453         uint proofReqFund = p.proofReqFund;
454         delete projects[_projectOwner];
455 
456         if (_inSupport) {
457             require(balanceOf[_projectOwner] + proofReqFund >= balanceOf[_projectOwner]); // overflow
458             balanceOf[this] -= proofReqFund;
459             balanceOf[_projectOwner] += proofReqFund;
460             Transfer(this, _projectOwner, proofReqFund);
461         }
462 
463         VotingFinished(_projectOwner, _inSupport);
464     }
465 }
466 
467 contract Proof is ProofPublicVote {
468 
469     struct Swype {
470         uint16  swype;
471         uint    timestampSwype;
472     }
473     
474     struct Video {
475         uint16  swype;
476         uint    timestampSwype;
477         uint    timestampHash;
478         address owner;
479     }
480 
481     mapping (address => Swype) public swypes;
482     mapping (bytes32 => Video) public videos;
483 
484     uint priceInTokens;
485     uint teamFee;
486 
487     function Proof() payable ProofPublicVote() {}
488 
489     function setPrice(uint _priceInTokens) public onlyOwner {
490         require(_priceInTokens >= 2);
491         teamFee = _priceInTokens / 10;
492         if (teamFee == 0) {
493             teamFee = 1;
494         }
495         priceInTokens = _priceInTokens - teamFee;
496     }
497 
498     function swypeCode() public enabledState returns (uint16 _swype) {
499         bytes32 blockHash = block.blockhash(block.number - 1);
500         bytes32 shaTemp = sha3(msg.sender, blockHash);
501         _swype = uint16(uint256(shaTemp) % 65536);
502         swypes[msg.sender] = Swype({swype: _swype, timestampSwype: now});
503     }
504     
505     function setHash(uint16 _swype, bytes32 _hash) public enabledState {
506         require(swypes[msg.sender].timestampSwype != 0);
507         require(swypes[msg.sender].swype == _swype);
508         transfer(owner, teamFee);
509         transfer(this, priceInTokens);
510         videos[_hash] = Video({swype: _swype, timestampSwype:swypes[msg.sender].timestampSwype, 
511             timestampHash: now, owner: msg.sender});
512         delete swypes[msg.sender];
513     }
514 }