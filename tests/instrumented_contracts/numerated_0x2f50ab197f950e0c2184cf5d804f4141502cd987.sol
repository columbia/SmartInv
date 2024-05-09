1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     function Ownable() {
17         owner = msg.sender;
18     }
19 
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner {
35         if (newOwner != address(0)) {
36             owner = newOwner;
37         }
38     }
39 }
40 
41 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
42 
43 contract LoggedERC20 is Ownable {
44     /* Structures */
45     struct LogValueBlock {
46     uint256 value;
47     uint256 block;
48     }
49 
50     /* Public variables of the token */
51     string public standard = 'LogValueBlockToken 0.1';
52     string public name;
53     string public symbol;
54     uint8 public decimals;
55     LogValueBlock[] public loggedTotalSupply;
56 
57     bool public locked;
58 
59     uint256 public creationBlock;
60 
61     /* This creates an array with all balances */
62     mapping (address => LogValueBlock[]) public loggedBalances;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     /* This generates a public event on the blockchain that will notify clients */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     mapping (address => bool) public frozenAccount;
69 
70     /* This generates a public event on the blockchain that will notify clients */
71     event FrozenFunds(address target, bool frozen);
72 
73     /* Initializes contract with initial supply tokens to the creator of the contract */
74     function LoggedERC20(
75     uint256 initialSupply,
76     string tokenName,
77     uint8 decimalUnits,
78     string tokenSymbol,
79     bool transferAllSupplyToOwner,
80     bool _locked
81     ) {
82         LogValueBlock memory valueBlock = LogValueBlock(initialSupply, block.number);
83 
84         loggedTotalSupply.push(valueBlock);
85 
86         if(transferAllSupplyToOwner) {
87             loggedBalances[msg.sender].push(valueBlock);
88         }
89         else {
90             loggedBalances[this].push(valueBlock);
91         }
92 
93         name = tokenName;                                   // Set the name for display purposes
94         symbol = tokenSymbol;                               // Set the symbol for display purposes
95         decimals = decimalUnits;                            // Amount of decimals for display purposes
96         locked = _locked;
97     }
98 
99     function valueAt(LogValueBlock [] storage valueBlocks, uint256 block) internal returns (uint256) {
100         if(valueBlocks.length == 0) {
101             return 0;
102         }
103 
104         LogValueBlock memory prevLogValueBlock;
105 
106         for(uint256 i = 0; i < valueBlocks.length; i++) {
107 
108             LogValueBlock memory valueBlock = valueBlocks[i];
109 
110             if(valueBlock.block > block) {
111                 return prevLogValueBlock.value;
112             }
113 
114             prevLogValueBlock = valueBlock;
115         }
116 
117         return prevLogValueBlock.value;
118     }
119 
120     function setBalance(address _address, uint256 value) internal {
121         loggedBalances[_address].push(LogValueBlock(value, block.number));
122     }
123 
124     function totalSupply() returns (uint256) {
125         return valueAt(loggedTotalSupply, block.number);
126     }
127 
128     function balanceOf(address _address) returns (uint256) {
129         return valueAt(loggedBalances[_address], block.number);
130     }
131 
132     function transferInternal(address _from, address _to, uint256 value) internal returns (bool success) {
133         uint256 balanceFrom = valueAt(loggedBalances[_from], block.number);
134         uint256 balanceTo = valueAt(loggedBalances[_to], block.number);
135 
136         if(value == 0) {
137             return false;
138         }
139 
140         if(frozenAccount[_from] == true) {
141             return false;
142         }
143 
144         if(balanceFrom < value) {
145             return false;
146         }
147 
148         if(balanceTo + value <= balanceTo) {
149             return false;
150         }
151 
152         loggedBalances[_from].push(LogValueBlock(balanceFrom - value, block.number));
153         loggedBalances[_to].push(LogValueBlock(balanceTo + value, block.number));
154 
155         Transfer(_from, _to, value);
156 
157         return true;
158     }
159 
160     /* Send coins */
161     function transfer(address _to, uint256 _value) {
162         require(locked == false);
163 
164         bool status = transferInternal(msg.sender, _to, _value);
165 
166         require(status == true);
167     }
168 
169     /* Allow another contract to spend some tokens in your behalf */
170     function approve(address _spender, uint256 _value) returns (bool success) {
171         if(locked) {
172             return false;
173         }
174 
175         allowance[msg.sender][_spender] = _value;
176         return true;
177     }
178 
179     /* Approve and then communicate the approved contract in a single tx */
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
181         if(locked) {
182             return false;
183         }
184 
185         tokenRecipient spender = tokenRecipient(_spender);
186         if (approve(_spender, _value)) {
187             spender.receiveApproval(msg.sender, _value, this, _extraData);
188             return true;
189         }
190     }
191 
192     /* A contract attempts to get the coins */
193     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
194         if(locked) {
195             return false;
196         }
197 
198         if(allowance[_from][msg.sender] < _value) {
199             return false;
200         }
201 
202         bool _success = transferInternal(_from, _to, _value);
203 
204         if(_success) {
205             allowance[_from][msg.sender] -= _value;
206         }
207 
208         return _success;
209     }
210 }
211 
212 contract LoggedDividend is Ownable, LoggedERC20 {
213     /* Structs */
214     struct Dividend {
215     uint256 id;
216 
217     uint256 block;
218     uint256 time;
219     uint256 amount;
220 
221     uint256 claimedAmount;
222     uint256 transferedBack;
223 
224     uint256 totalSupply;
225     uint256 recycleTime;
226 
227     bool recycled;
228 
229     mapping (address => bool) claimed;
230     }
231 
232     /* variables */
233     Dividend [] public dividends;
234 
235     mapping (address => uint256) dividendsClaimed;
236 
237     /* Events */
238     event DividendTransfered(uint256 id, address indexed _address, uint256 _block, uint256 _amount, uint256 _totalSupply);
239     event DividendClaimed(uint256 id, address indexed _address, uint256 _claim);
240     event UnclaimedDividendTransfer(uint256 id, uint256 _value);
241     event DividendRecycled(uint256 id, address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply);
242 
243     function LoggedDividend(
244     uint256 initialSupply,
245     string tokenName,
246     uint8 decimalUnits,
247     string tokenSymbol,
248     bool transferAllSupplyToOwner,
249     bool _locked
250     ) LoggedERC20(initialSupply, tokenName, decimalUnits, tokenSymbol, transferAllSupplyToOwner, _locked) {
251 
252     }
253 
254     function addDividend(uint256 recycleTime) payable onlyOwner {
255         require(msg.value > 0);
256 
257         uint256 id = dividends.length;
258         uint256 _totalSupply = valueAt(loggedTotalSupply, block.number);
259 
260         dividends.push(
261         Dividend(
262         id,
263         block.number,
264         now,
265         msg.value,
266         0,
267         0,
268         _totalSupply,
269         recycleTime,
270         false
271         )
272         );
273 
274         DividendTransfered(id, msg.sender, block.number, msg.value, _totalSupply);
275     }
276 
277     function claimDividend(uint256 dividendId) public returns (bool) {
278         if(dividends.length - 1 < dividendId) {
279             return false;
280         }
281 
282         Dividend storage dividend = dividends[dividendId];
283 
284         if(dividend.claimed[msg.sender] == true) {
285             return false;
286         }
287 
288         if(dividend.recycled == true) {
289             return false;
290         }
291 
292         if(now >= dividend.time + dividend.recycleTime) {
293             return false;
294         }
295 
296         uint256 balance = valueAt(loggedBalances[msg.sender], dividend.block);
297 
298         if(balance == 0) {
299             return false;
300         }
301 
302         uint256 claim = balance * dividend.amount / dividend.totalSupply;
303 
304         dividend.claimed[msg.sender] = true;
305 
306         dividend.claimedAmount = dividend.claimedAmount + claim;
307 
308         if (claim > 0) {
309             msg.sender.transfer(claim);
310             DividendClaimed(dividendId, msg.sender, claim);
311 
312             return true;
313         }
314 
315         return false;
316     }
317 
318     function claimDividends() public {
319         require(dividendsClaimed[msg.sender] < dividends.length);
320         for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
321             if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
322                 dividendsClaimed[msg.sender] = i + 1;
323                 claimDividend(i);
324             }
325         }
326     }
327 
328     function recycleDividend(uint256 dividendId) public onlyOwner returns (bool success) {
329         if(dividends.length - 1 < dividendId) {
330             return false;
331         }
332 
333         Dividend storage dividend = dividends[dividendId];
334 
335         if(dividend.recycled) {
336             return false;
337         }
338 
339         dividend.recycled = true;
340 
341         return true;
342     }
343 
344     function refundUnclaimedEthers(uint256 dividendId) public onlyOwner returns (bool success) {
345         if(dividends.length - 1 < dividendId) {
346             return false;
347         }
348 
349         Dividend storage dividend = dividends[dividendId];
350 
351         if(dividend.recycled == false) {
352             if(now < dividend.time + dividend.recycleTime) {
353                 return false;
354             }
355         }
356 
357         uint256 claimedBackAmount = dividend.amount - dividend.claimedAmount;
358 
359         dividend.transferedBack = claimedBackAmount;
360 
361         if(claimedBackAmount > 0) {
362             owner.transfer(claimedBackAmount);
363 
364             UnclaimedDividendTransfer(dividendId, claimedBackAmount);
365 
366             return true;
367         }
368 
369         return false;
370     }
371 }
372 
373 contract LoggedPhaseICO is LoggedDividend {
374     uint256 public icoSince;
375     uint256 public icoTill;
376 
377     uint256 public collectedEthers;
378 
379     Phase[] public phases;
380 
381     struct Phase {
382     uint256 price;
383     uint256 maxAmount;
384     }
385 
386     function LoggedPhaseICO(
387     uint256 _icoSince,
388     uint256 _icoTill,
389     uint256 initialSupply,
390     string tokenName,
391     string tokenSymbol,
392     uint8 precision,
393     bool transferAllSupplyToOwner,
394     bool _locked
395     ) LoggedDividend(initialSupply, tokenName, precision, tokenSymbol, transferAllSupplyToOwner, _locked) {
396         standard = 'LoggedPhaseICO 0.1';
397 
398         icoSince = _icoSince;
399         icoTill = _icoTill;
400     }
401 
402     function getIcoTokensAmount(uint256 collectedEthers, uint256 value) returns (uint256) {
403         uint256 amount;
404 
405         uint256 newCollectedEthers = collectedEthers;
406         uint256 remainingValue = value;
407 
408         for (uint i = 0; i < phases.length; i++) {
409             Phase storage phase = phases[i];
410 
411             if(phase.maxAmount > newCollectedEthers) {
412                 if (newCollectedEthers + remainingValue > phase.maxAmount) {
413                     uint256 diff = phase.maxAmount - newCollectedEthers;
414 
415                     amount += diff * 1 ether / phase.price;
416 
417                     remainingValue -= diff;
418                     newCollectedEthers += diff;
419                 }
420                 else {
421                     amount += remainingValue * 1 ether / phase.price;
422 
423                     newCollectedEthers += remainingValue;
424 
425                     remainingValue = 0;
426                 }
427             }
428 
429             if (remainingValue == 0) {
430                 break;
431             }
432         }
433 
434         if (remainingValue > 0) {
435             return 0;
436         }
437 
438         return amount;
439     }
440 
441     function buy(address _address, uint256 time, uint256 value) internal returns (bool) {
442         if (locked == true) {
443             return false;
444         }
445 
446         if (time < icoSince) {
447             return false;
448         }
449 
450         if (time > icoTill) {
451             return false;
452         }
453 
454         if (value == 0) {
455             return false;
456         }
457 
458         uint256 amount = getIcoTokensAmount(collectedEthers, value);
459 
460         if(amount == 0) {
461             return false;
462         }
463 
464         uint256 selfBalance = valueAt(loggedBalances[this], block.number);
465         uint256 holderBalance = valueAt(loggedBalances[_address], block.number);
466 
467         if (selfBalance < amount) {
468             return false;
469         }
470 
471         if (holderBalance + amount < holderBalance) {
472             return false;
473         }
474 
475         setBalance(_address, holderBalance + amount);
476         setBalance(this, selfBalance - amount);
477 
478         collectedEthers += value;
479 
480         Transfer(this, _address, amount);
481 
482         return true;
483     }
484 
485     function () payable {
486         bool status = buy(msg.sender, now, msg.value);
487 
488         require(status == true);
489     }
490 }
491 
492 contract Cajutel is LoggedPhaseICO {
493     function Cajutel(
494     uint256 initialSupply,
495     string tokenName,
496     string tokenSymbol,
497     address founder1,
498     address founder2,
499     address marketing,
500     uint256 icoSince,
501     uint256 icoTill
502     ) LoggedPhaseICO(icoSince, icoTill, initialSupply, tokenName, tokenSymbol, 18, false, false) {
503         standard = 'Cajutel 0.1';
504 
505         phases.push(Phase(0.05 ether, 500 ether));
506         phases.push(Phase(0.075 ether, 750 ether + 500 ether));
507         phases.push(Phase(0.1 ether, 10000 ether + 750 ether + 500 ether));
508         phases.push(Phase(0.15 ether, 30000 ether + 10000 ether + 750 ether + 500 ether));
509         phases.push(Phase(0.2 ether, 80000 ether + 30000 ether + 10000 ether + 750 ether + 500 ether));
510 
511         uint256 founder1Tokens = 900000000000000000000000;
512         uint256 founder2Tokens = 100000000000000000000000;
513         uint256 marketingTokens = 60000000000000000000000;
514 
515         setBalance(founder1, founder1Tokens);
516 
517         Transfer(this, founder1, founder1Tokens);
518 
519         setBalance(founder2, founder2Tokens);
520 
521         Transfer(this, founder2, founder2Tokens);
522 
523         setBalance(marketing, marketingTokens);
524 
525         Transfer(this, marketing, marketingTokens);
526 
527         setBalance(this, initialSupply - founder1Tokens - founder2Tokens - marketingTokens);
528     }
529 
530     function transferEthers() onlyOwner {
531         owner.transfer(this.balance);
532     }
533 
534     function setLocked(bool _locked) onlyOwner {
535         locked = _locked;
536     }
537 
538     function setIcoDates(uint256 _icoSince, uint256 _icoTill) onlyOwner {
539         icoSince = _icoSince;
540         icoTill = _icoTill;
541     }
542 }