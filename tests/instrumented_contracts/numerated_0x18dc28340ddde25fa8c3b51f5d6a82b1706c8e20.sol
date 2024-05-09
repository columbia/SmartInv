1 pragma solidity ^0.4.19;
2 // last compiled with v0.4.19+commit.c4cbbb05;
3 
4 contract SafeMath {
5   //internals
6 
7   function safeMul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     require(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeSub(uint a, uint b) internal pure returns (uint) {
14     require(b <= a);
15     return a - b;
16   }
17 
18   function safeAdd(uint a, uint b) internal pure returns (uint) {
19     uint c = a + b;
20     require(c>=a && c>=b);
21     return c;
22   }
23 }
24 
25 contract Token {
26 
27   /// @return total amount of tokens
28   function totalSupply() public constant returns (uint256 supply) {}
29 
30   /// @param _owner The address from which the balance will be retrieved
31   /// @return The balance
32   function balanceOf(address _owner) public constant returns (uint256 balance) {}
33 
34   /// @notice send `_value` token to `_to` from `msg.sender`
35   /// @param _to The address of the recipient
36   /// @param _value The amount of token to be transferred
37   /// @return Whether the transfer was successful or not
38   function transfer(address _to, uint256 _value) public returns (bool success) {}
39 
40   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
41   /// @param _from The address of the sender
42   /// @param _to The address of the recipient
43   /// @param _value The amount of token to be transferred
44   /// @return Whether the transfer was successful or not
45   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
46 
47   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
48   /// @param _spender The address of the account able to transfer the tokens
49   /// @param _value The amount of wei to be approved for transfer
50   /// @return Whether the approval was successful or not
51   function approve(address _spender, uint256 _value) public returns (bool success) {}
52 
53   /// @param _owner The address of the account owning tokens
54   /// @param _spender The address of the account able to transfer the tokens
55   /// @return Amount of remaining tokens allowed to spent
56   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
57 
58   event Transfer(address indexed _from, address indexed _to, uint256 _value);
59   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61 }
62 
63 contract StandardToken is Token {
64 
65   function transfer(address _to, uint256 _value) public returns (bool success) {
66     //Default assumes totalSupply can't be over max (2^256 - 1).
67     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
68     //Replace the if with this one instead.
69     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70     //if (balances[msg.sender] >= _value && _value > 0) {
71       balances[msg.sender] -= _value;
72       balances[_to] += _value;
73       Transfer(msg.sender, _to, _value);
74       return true;
75     } else { return false; }
76   }
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79     //same as above. Replace this line with the following if you want to protect against wrapping uints.
80     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82       balances[_to] += _value;
83       balances[_from] -= _value;
84       allowed[_from][msg.sender] -= _value;
85       Transfer(_from, _to, _value);
86       return true;
87     } else { return false; }
88   }
89 
90   function balanceOf(address _owner) public constant returns (uint256 balance) {
91     return balances[_owner];
92   }
93 
94   function approve(address _spender, uint256 _value) public returns (bool success) {
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
101     return allowed[_owner][_spender];
102   }
103 
104   mapping(address => uint256) public balances;
105 
106   mapping (address => mapping (address => uint256)) public allowed;
107 
108   uint256 public totalSupply;
109 
110 }
111 
112 contract ReserveToken is StandardToken, SafeMath {
113   string public name;
114   string public symbol;
115   uint public decimals = 18;
116   address public minter;
117 
118   event Create(address account, uint amount);
119   event Destroy(address account, uint amount);
120 
121   function ReserveToken(string name_, string symbol_) public {
122     name = name_;
123     symbol = symbol_;
124     minter = msg.sender;
125   }
126 
127   function create(address account, uint amount) public {
128     require(msg.sender == minter);
129     balances[account] = safeAdd(balances[account], amount);
130     totalSupply = safeAdd(totalSupply, amount);
131     Create(account, amount);
132   }
133 
134   function destroy(address account, uint amount) public {
135     require(msg.sender == minter);
136     require(balances[account] >= amount);
137     balances[account] = safeSub(balances[account], amount);
138     totalSupply = safeSub(totalSupply, amount);
139     Destroy(account, amount);
140   }
141 }
142 
143 contract Challenge is SafeMath {
144 
145   uint public fee = 10 * (10 ** 16); // fee percentage (100% = 10 ** 18)
146   uint public blockPeriod = 6000; // period of blocks for waiting until certain transactions can be sent
147   uint public blockNumber; // block number when this challenge was initiated
148   bool public funded; // has the initial challenger funded the contract?
149   address public witnessJury; // the WitnessJury smart contract
150   address public token; // the token of the prize pool
151   address public user1; // the initial challenger
152   address public user2; // the responding challenger
153   string public key1; // something to identify the initial challenger
154   string public key2; // something to identify the responding challenger
155   uint public amount; // the amount each challenger committed to prize pool
156   address public host; // the witness who agreed to host
157   string public hostKey; // something to identify the host
158   string public witnessJuryKey; // something the host used to identify the challenge specifics
159   uint public witnessJuryRequestNum; // the WitnessJury request number (in the WitnessJury smart contract)
160   uint public winner; // the winner (1 or 2)
161   bool public rescued; // has the contract been rescued?
162   bool public juryCalled; // has the jury been called?
163   address public referrer; // the referrer of the person who created the challenge (splits reward with host)
164 
165   event NewChallenge(uint amount, address user1, string key1);
166   event Fund();
167   event Respond(address user2, string key2);
168   event Host(address host, string hostKey);
169   event SetWitnessJuryKey(uint witnessJuryRequestNum, string witnessJuryKey);
170   event RequestJury();
171   event Resolve(uint winner, bool wasContested, uint winnerAmount, uint hostAmount, uint witnessJuryAmount);
172   event Rescue();
173 
174   function Challenge(address witnessJury_, address token_, uint amount_, address user1_, string key1_, uint blockPeriod_, address referrer_) public {
175     require(amount_ > 0);
176     blockPeriod = blockPeriod_;
177     witnessJury = witnessJury_;
178     token = token_;
179     user1 = user1_;
180     key1 = key1_;
181     amount = amount_;
182     referrer = referrer_;
183     blockNumber = block.number;
184     NewChallenge(amount, user1, key1);
185   }
186 
187   function fund() public {
188     // remember to call approve() on the token first...
189     require(!funded);
190     require(!rescued);
191     require(msg.sender == user1);
192     require(Token(token).transferFrom(user1, this, amount));
193     funded = true;
194     blockNumber = block.number;
195     Fund();
196   }
197 
198   function respond(address user2_, string key2_) public {
199     // remember to call approve() on the token first...
200     require(user2 == 0x0);
201     require(msg.sender == user2_);
202     require(funded);
203     require(!rescued);
204     user2 = user2_;
205     key2 = key2_;
206     blockNumber = block.number;
207     require(Token(token).transferFrom(user2, this, amount));
208     Respond(user2, key2);
209   }
210 
211   function host(string hostKey_) public {
212     require(host == 0x0);
213     require(!rescued);
214     host = msg.sender;
215     hostKey = hostKey_;
216     blockNumber = block.number;
217     Host(host, hostKey);
218   }
219 
220   function setWitnessJuryKey(string witnessJuryKey_) public {
221     require(witnessJuryRequestNum == 0);
222     require(msg.sender == host);
223     require(!rescued);
224     witnessJuryRequestNum = WitnessJury(witnessJury).numRequests() + 1;
225     witnessJuryKey = witnessJuryKey_;
226     blockNumber = block.number;
227     WitnessJury(witnessJury).newRequest(witnessJuryKey, this);
228     SetWitnessJuryKey(witnessJuryRequestNum, witnessJuryKey);
229   }
230 
231   function requestJury() public {
232     require(!juryCalled);
233     require(msg.sender == user1 || msg.sender == user2);
234     require(!rescued);
235     require(winner == 0);
236     require(WitnessJury(witnessJury).getWinner1(witnessJuryRequestNum) != 0 && WitnessJury(witnessJury).getWinner2(witnessJuryRequestNum) != 0);
237     juryCalled = true;
238     blockNumber = block.number;
239     WitnessJury(witnessJury).juryNeeded(witnessJuryRequestNum);
240     RequestJury();
241   }
242 
243   function resolve(uint witnessJuryRequestNum_, bool juryContested, address[] majorityJurors, uint winner_, address witness1, address witness2, uint witnessJuryRewardPercentage) public {
244     require(winner == 0);
245     require(witnessJuryRequestNum_ == witnessJuryRequestNum);
246     require(msg.sender == witnessJury);
247     require(winner_ == 1 || winner_ == 2);
248     require(!rescued);
249     require(block.number > blockNumber + blockPeriod);
250     uint totalFee = safeMul(safeMul(amount, 2), fee) / (1 ether);
251     uint winnerAmount = safeSub(safeMul(amount, 2), totalFee);
252     uint witnessJuryAmount = safeMul(totalFee, witnessJuryRewardPercentage) / (1 ether);
253     uint hostAmount = safeSub(totalFee, witnessJuryAmount);
254     uint flipWinner = winner_ == 1 ? 2 : 1;
255     winner = juryContested ? flipWinner : winner_;
256     if (winnerAmount > 0) {
257       require(Token(token).transfer(winner == 1 ? user1 : user2, winnerAmount));
258     }
259     if (referrer != 0x0 && hostAmount / 2 > 0) {
260       require(Token(token).transfer(host, hostAmount / 2));
261       require(Token(token).transfer(referrer, hostAmount / 2));
262     } else if (referrer == 0 && hostAmount > 0) {
263       require(Token(token).transfer(host, hostAmount));
264     }
265     if (!juryContested && witnessJuryAmount / 2 > 0) {
266       require(Token(token).transfer(witness1, witnessJuryAmount / 2));
267       require(Token(token).transfer(witness2, witnessJuryAmount / 2));
268     } else if (juryContested && witnessJuryAmount / majorityJurors.length > 0) {
269       for (uint i = 0; i < majorityJurors.length; i++) {
270         require(Token(token).transfer(majorityJurors[i], witnessJuryAmount / majorityJurors.length));
271       }
272     }
273     uint excessBalance = Token(token).balanceOf(this);
274     if (excessBalance > 0) {
275       require(Token(token).transfer(0x0, excessBalance));
276     }
277     Resolve(winner, juryContested, winnerAmount, hostAmount, witnessJuryAmount);
278   }
279 
280   function rescue() public {
281     require(!rescued);
282     require(funded);
283     require(block.number > blockNumber + blockPeriod * 10);
284     require(msg.sender == user1 || msg.sender == user2);
285     require(winner == 0);
286     rescued = true;
287     if (user2 != 0x0) {
288       require(Token(token).transfer(user1, amount));
289       require(Token(token).transfer(user2, amount));
290     } else {
291       require(Token(token).transfer(user1, amount));
292     }
293     Rescue();
294   }
295 
296 }
297 
298 contract ChallengeFactory is SafeMath {
299 
300   address witnessJury;
301   address token;
302 
303   mapping(uint => Challenge) public challenges;
304   uint numChallenges;
305 
306   event NewChallenge(address addr, uint amount, address user, string key);
307 
308   function ChallengeFactory(address witnessJury_, address token_) public {
309     witnessJury = witnessJury_;
310     token = token_;
311   }
312 
313   function newChallenge(uint amount, address user, string key, address referrer) public {
314     numChallenges = safeAdd(numChallenges, 1);
315     uint blockPeriod = 6000;
316     challenges[numChallenges] = new Challenge(witnessJury, token, amount, user, key, blockPeriod, referrer);
317     NewChallenge(address(challenges[numChallenges]), amount, user, key);
318   }
319 
320 }
321 
322 contract WitnessJury is SafeMath {
323   mapping(address => uint) public balances; // mapping of witness address to witness balance
324   uint public limit = 10 ** 16; // 1% = the max percentage of the overall witness pool one person can have
325   uint public numWitnessesBeforeLimit = 100; // the number of witnesses before the limit starts kicking in
326   uint public totalBalance; // the total of all witness balances
327   uint public numWitnesses; // count of total witnesses with non-zero balances
328   uint public blockPeriod = 6000; // 1 day at 14.4 seconds per block
329   uint public desiredWitnesses = 2; // desired number of witnesses to fulfill a request (witness a match)
330   uint public desiredJurors = 3; // desired number of jurors
331   uint public penalty = 50 * (10 ** 16); // penalty for witnesses if jury votes yes (penalty is sent back to the witnesses)
332   address public token; // the token being staked by witnesses
333   mapping(uint => Request) public requests; // mapping of requests that are partially or completely filled
334   uint public numRequests; // count of total number of partially or completely filled requests
335   mapping(uint => uint) public requestsPerBlockGroup; // map of number of requests per block group
336   uint public drmVolumeCap = 10000; // after this many matches per block group, fee stops increasing
337   uint public drmMinFee = 25 * (10 ** 16); // minimum witness reward percentage (100% = 10 ** 18)
338   uint public drmMaxFee = 50 * (10 ** 16); // maximum witness reward percentage (100% = 10 ** 18)
339   mapping(uint => bool) public juryNeeded; // mapping of requestNum to whether the jury is needed
340   mapping(uint => mapping(address => bool)) public juryVoted; // mapping of requestNum to juror addresses who already voted
341   mapping(uint => uint) public juryYesCount; // mapping of requestNum to number of yes votes
342   mapping(uint => uint) public juryNoCount; // mapping of requestNum to number of no votes
343   mapping(uint => address[]) public juryYesVoters; // mapping of requestNum to array of yes voters
344   mapping(uint => address[]) public juryNoVoters; // mapping of requestNum to array of no voters
345 
346   struct Request {
347     string key; // the key, which should contain details about the request (for example, match ID)
348     address witness1; // the first witness
349     address witness2; // the second witness
350     string answer1; // the first witness' answer
351     string answer2; // the second witness' answer
352     uint winner1; // the first witness' winner
353     uint winner2; // the second witness' winner
354     uint fee; // percentage of match fee that will go to witness / jury pool (100% = 10 ** 18)
355     address challenge; // challenge smart contract
356     uint blockNumber; // block number when request was made
357   }
358 
359   event Deposit(uint amount);
360   event Withdraw(uint amount);
361   event ReduceToLimit(address witness, uint amount);
362   event Report(uint requestNum, string answer, uint winner);
363   event NewRequest(uint requestNum, string key);
364   event JuryNeeded(uint requestNum);
365   event JuryVote(uint requestNum, address juror, bool vote);
366   event Resolve(uint requestNum);
367   event JuryContested(uint requestNum);
368 
369   function WitnessJury(address token_) public {
370     token = token_;
371   }
372 
373   function balanceOf(address user) public constant returns(uint) {
374     return balances[user];
375   }
376 
377   function reduceToLimit(address witness) public {
378     require(witness == msg.sender);
379     uint amount = balances[witness];
380     uint limitAmount = safeMul(totalBalance, limit) / (1 ether);
381     if (amount > limitAmount && numWitnesses > numWitnessesBeforeLimit) {
382       uint excess = safeSub(amount, limitAmount);
383       balances[witness] = safeSub(amount, excess);
384       totalBalance = safeSub(totalBalance, excess);
385       require(Token(token).transfer(witness, excess));
386       ReduceToLimit(witness, excess);
387     }
388   }
389 
390   function deposit(uint amount) public {
391     // remember to call approve() on the token first...
392     require(amount > 0);
393     if (balances[msg.sender] == 0) {
394       numWitnesses = safeAdd(numWitnesses, 1);
395     }
396     balances[msg.sender] = safeAdd(balances[msg.sender], amount);
397     totalBalance = safeAdd(totalBalance, amount);
398     require(Token(token).transferFrom(msg.sender, this, amount));
399     Deposit(amount);
400   }
401 
402   function withdraw(uint amount) public {
403     require(amount > 0);
404     require(amount <= balances[msg.sender]);
405     balances[msg.sender] = safeSub(balances[msg.sender], amount);
406     totalBalance = safeSub(totalBalance, amount);
407     if (balances[msg.sender] == 0) {
408       numWitnesses = safeSub(numWitnesses, 1);
409     }
410     require(Token(token).transfer(msg.sender, amount));
411     Withdraw(amount);
412   }
413 
414   function isWitness(uint requestNum, address witness) public constant returns(bool) {
415     //random number from 0-999999999
416     bytes32 hash = sha256(this, requestNum, requests[requestNum].key);
417     uint rand = uint(sha256(requestNum, hash, witness)) % 1000000000;
418     return (
419       rand * totalBalance < 1000000000 * desiredWitnesses * balances[witness] ||
420       block.number > requests[requestNum].blockNumber + blockPeriod
421     );
422   }
423 
424   function isJuror(uint requestNum, address juror) public constant returns(bool) {
425     //random number from 0-999999999
426     bytes32 hash = sha256(1, this, requestNum, requests[requestNum].key);
427     uint rand = uint(sha256(requestNum, hash, juror)) % 1000000000;
428     return (
429       rand * totalBalance < 1000000000 * desiredWitnesses * balances[juror]
430     );
431   }
432 
433   function newRequest(string key, address challenge) public {
434     numRequests = safeAdd(numRequests, 1);
435     require(requests[numRequests].challenge == 0x0);
436     requests[numRequests].blockNumber = block.number;
437     requests[numRequests].challenge = challenge;
438     requests[numRequests].key = key;
439     requestsPerBlockGroup[block.number / blockPeriod] = safeAdd(requestsPerBlockGroup[block.number / blockPeriod], 1);
440     uint recentNumRequests = requestsPerBlockGroup[block.number / blockPeriod];
441     if (recentNumRequests < drmVolumeCap) {
442       requests[numRequests].fee = safeAdd(safeMul(safeMul(recentNumRequests, recentNumRequests), safeSub(drmMaxFee, drmMinFee)) / safeMul(drmVolumeCap, drmVolumeCap), drmMinFee);
443     } else {
444       requests[numRequests].fee = drmMaxFee;
445     }
446     NewRequest(numRequests, key);
447   }
448 
449   function report(uint requestNum, string answer, uint winner) public {
450     require(requests[requestNum].challenge != 0x0);
451     require(requests[requestNum].witness1 == 0x0 || requests[requestNum].witness2 == 0x0);
452     require(requests[requestNum].witness1 != msg.sender);
453     require(isWitness(requestNum, msg.sender));
454     reportLogic(requestNum, answer, winner);
455     Report(requestNum, answer, winner);
456   }
457 
458   function reportLogic(uint requestNum, string answer, uint winner) private {
459     reduceToLimit(msg.sender);
460     if (requests[requestNum].witness1 == 0x0) {
461       requests[requestNum].witness1 = msg.sender;
462       requests[requestNum].answer1 = answer;
463       requests[requestNum].winner1 = winner;
464     } else if (requests[requestNum].witness2 == 0x0) {
465       requests[requestNum].witness2 = msg.sender;
466       requests[requestNum].answer2 = answer;
467       requests[requestNum].winner2 = winner;
468     }
469   }
470 
471   function juryNeeded(uint requestNum) public {
472     require(msg.sender == requests[requestNum].challenge);
473     require(!juryNeeded[requestNum]);
474     juryNeeded[requestNum] = true;
475     JuryNeeded(requestNum);
476   }
477 
478   function juryVote(uint requestNum, bool vote) public {
479     require(!juryVoted[requestNum][msg.sender]);
480     require(juryNeeded[requestNum]);
481     require(safeAdd(juryYesCount[requestNum], juryNoCount[requestNum]) < desiredJurors);
482     require(isJuror(requestNum, msg.sender));
483     juryVoted[requestNum][msg.sender] = true;
484     if (vote) {
485       juryYesCount[requestNum] = safeAdd(juryYesCount[requestNum], 1);
486       juryYesVoters[requestNum].push(msg.sender);
487     } else {
488       juryNoCount[requestNum] = safeAdd(juryNoCount[requestNum], 1);
489       juryNoVoters[requestNum].push(msg.sender);
490     }
491     JuryVote(requestNum, msg.sender, vote);
492   }
493 
494   function resolve(uint requestNum) public {
495     bool juryContested = juryYesCount[requestNum] > juryNoCount[requestNum] && safeAdd(juryYesCount[requestNum], juryNoCount[requestNum]) == desiredJurors;
496     Challenge(requests[requestNum].challenge).resolve(
497       requestNum,
498       juryContested,
499       juryYesCount[requestNum] > juryNoCount[requestNum] ? juryYesVoters[requestNum] : juryNoVoters[requestNum],
500       requests[requestNum].winner1,
501       requests[requestNum].witness1,
502       requests[requestNum].witness2,
503       requests[requestNum].fee
504     );
505     if (juryContested) {
506       uint penalty1 = safeMul(balances[requests[requestNum].witness1], penalty) / (1 ether);
507       uint penalty2 = safeMul(balances[requests[requestNum].witness2], penalty) / (1 ether);
508       balances[requests[requestNum].witness1] = safeSub(balances[requests[requestNum].witness1], penalty1);
509       balances[requests[requestNum].witness2] = safeSub(balances[requests[requestNum].witness2], penalty2);
510       require(Token(token).transfer(requests[requestNum].witness1, penalty1));
511       require(Token(token).transfer(requests[requestNum].witness2, penalty2));
512       JuryContested(requestNum);
513     }
514     Resolve(requestNum);
515   }
516 
517   function getWinner1(uint requestNum) public constant returns(uint) {
518     return requests[requestNum].winner1;
519   }
520 
521   function getWinner2(uint requestNum) public constant returns(uint) {
522     return requests[requestNum].winner2;
523   }
524 
525   function getRequest(uint requestNum) public constant returns(string, address, address, string, string, uint, address) {
526     return (requests[requestNum].key,
527             requests[requestNum].witness1,
528             requests[requestNum].witness2,
529             requests[requestNum].answer1,
530             requests[requestNum].answer2,
531             requests[requestNum].fee,
532             requests[requestNum].challenge);
533   }
534 }