1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     /**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15     function Ownable() {
16         owner = msg.sender;
17     }
18 
19 
20     /**
21      * @dev Throws if called by any account other than the owner.
22      */
23     modifier onlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27 
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address newOwner) onlyOwner {
34         if (newOwner != address(0)) {
35             owner = newOwner;
36         }
37     }
38 }
39 
40 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
41 
42 contract LoggedERC20 is Ownable {
43     /* Structures */
44     struct LogValueBlock {
45     uint256 value;
46     uint256 block;
47     }
48 
49     /* Public variables of the token */
50     string public standard = 'LogValueBlockToken 0.1';
51     string public name;
52     string public symbol;
53     uint8 public decimals;
54     LogValueBlock[] public loggedTotalSupply;
55 
56     bool public locked;
57 
58     uint256 public creationBlock;
59 
60     /* This creates an array with all balances */
61     mapping (address => LogValueBlock[]) public loggedBalances;
62     mapping (address => mapping (address => uint256)) public allowance;
63 
64     /* This generates a public event on the blockchain that will notify clients */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     mapping (address => bool) public frozenAccount;
68 
69     /* This generates a public event on the blockchain that will notify clients */
70     event FrozenFunds(address target, bool frozen);
71 
72     /* Initializes contract with initial supply tokens to the creator of the contract */
73     function LoggedERC20(
74     uint256 initialSupply,
75     string tokenName,
76     uint8 decimalUnits,
77     string tokenSymbol,
78     bool transferAllSupplyToOwner,
79     bool _locked
80     ) {
81         LogValueBlock memory valueBlock = LogValueBlock(initialSupply, block.number);
82 
83         loggedTotalSupply.push(valueBlock);
84 
85         if(transferAllSupplyToOwner) {
86             loggedBalances[msg.sender].push(valueBlock);
87         }
88         else {
89             loggedBalances[this].push(valueBlock);
90         }
91 
92         name = tokenName;                                   // Set the name for display purposes
93         symbol = tokenSymbol;                               // Set the symbol for display purposes
94         decimals = decimalUnits;                            // Amount of decimals for display purposes
95         locked = _locked;
96     }
97 
98     function valueAt(LogValueBlock [] storage valueBlocks, uint256 block) internal returns (uint256) {
99         if(valueBlocks.length == 0) {
100             return 0;
101         }
102 
103         LogValueBlock memory prevLogValueBlock;
104 
105         for(uint256 i = 0; i < valueBlocks.length; i++) {
106 
107             LogValueBlock memory valueBlock = valueBlocks[i];
108 
109             if(valueBlock.block > block) {
110                 return prevLogValueBlock.value;
111             }
112 
113             prevLogValueBlock = valueBlock;
114         }
115 
116         return prevLogValueBlock.value;
117     }
118 
119     function setBalance(address _address, uint256 value) internal {
120         loggedBalances[_address].push(LogValueBlock(value, block.number));
121     }
122 
123     function totalSupply() returns (uint256) {
124         return valueAt(loggedTotalSupply, block.number);
125     }
126 
127     function balanceOf(address _address) returns (uint256) {
128         return valueAt(loggedBalances[_address], block.number);
129     }
130 
131     function transferInternal(address _from, address _to, uint256 value) internal returns (bool success) {
132         uint256 balanceFrom = valueAt(loggedBalances[msg.sender], block.number);
133         uint256 balanceTo = valueAt(loggedBalances[_to], block.number);
134 
135         if(value == 0) {
136             return false;
137         }
138 
139         if(frozenAccount[_from] == true) {
140             return false;
141         }
142 
143         if(balanceFrom < value) {
144             return false;
145         }
146 
147         if(balanceTo + value <= balanceTo) {
148             return false;
149         }
150 
151         loggedBalances[_from].push(LogValueBlock(balanceFrom - value, block.number));
152         loggedBalances[_to].push(LogValueBlock(balanceTo + value, block.number));
153 
154         Transfer(_from, _to, value);
155 
156         return true;
157     }
158 
159     /* Send coins */
160     function transfer(address _to, uint256 _value) {
161         require(locked == false);
162 
163         bool status = transferInternal(msg.sender, _to, _value);
164 
165         require(status == true);
166     }
167 
168     /* Allow another contract to spend some tokens in your behalf */
169     function approve(address _spender, uint256 _value) returns (bool success) {
170         if(locked) {
171             return false;
172         }
173 
174         allowance[msg.sender][_spender] = _value;
175         return true;
176     }
177 
178     /* Approve and then communicate the approved contract in a single tx */
179     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
180         if(locked) {
181             return false;
182         }
183 
184         tokenRecipient spender = tokenRecipient(_spender);
185         if (approve(_spender, _value)) {
186             spender.receiveApproval(msg.sender, _value, this, _extraData);
187             return true;
188         }
189     }
190 
191     /* A contract attempts to get the coins */
192     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
193         if(locked) {
194             return false;
195         }
196 
197         bool _success = transferInternal(_from, _to, _value);
198 
199         if(_success) {
200             allowance[_from][msg.sender] -= _value;
201         }
202 
203         return _success;
204     }
205 }
206 
207 contract LoggedDividend is Ownable, LoggedERC20 {
208     /* Structs */
209     struct Dividend {
210     uint256 id;
211 
212     uint256 block;
213     uint256 time;
214     uint256 amount;
215 
216     uint256 claimedAmount;
217     uint256 transferedBack;
218 
219     uint256 totalSupply;
220     uint256 recycleTime;
221 
222     bool recycled;
223 
224     mapping (address => bool) claimed;
225     }
226 
227     /* variables */
228     Dividend [] public dividends;
229 
230     mapping (address => uint256) dividendsClaimed;
231 
232     /* Events */
233     event DividendTransfered(uint256 id, address indexed _address, uint256 _block, uint256 _amount, uint256 _totalSupply);
234     event DividendClaimed(uint256 id, address indexed _address, uint256 _claim);
235     event UnclaimedDividendTransfer(uint256 id, uint256 _value);
236     event DividendRecycled(uint256 id, address indexed _recycler, uint256 _blockNumber, uint256 _amount, uint256 _totalSupply);
237 
238     function LoggedDividend(
239     uint256 initialSupply,
240     string tokenName,
241     uint8 decimalUnits,
242     string tokenSymbol,
243     bool transferAllSupplyToOwner,
244     bool _locked
245     ) LoggedERC20(initialSupply, tokenName, decimalUnits, tokenSymbol, transferAllSupplyToOwner, _locked) {
246 
247     }
248 
249     function addDividend(uint256 recycleTime) payable onlyOwner {
250         require(msg.value > 0);
251 
252         uint256 id = dividends.length;
253         uint256 _totalSupply = valueAt(loggedTotalSupply, block.number);
254 
255         dividends.push(
256         Dividend(
257         id,
258         block.number,
259         now,
260         msg.value,
261         0,
262         0,
263         _totalSupply,
264         recycleTime,
265         false
266         )
267         );
268 
269         DividendTransfered(id, msg.sender, block.number, msg.value, _totalSupply);
270     }
271 
272     function claimDividend(uint256 dividendId) public returns (bool) {
273         if(dividends.length - 1 < dividendId) {
274             return false;
275         }
276 
277         Dividend storage dividend = dividends[dividendId];
278 
279         if(dividend.claimed[msg.sender] == true) {
280             return false;
281         }
282 
283         if(dividend.recycled == true) {
284             return false;
285         }
286 
287         if(now >= dividend.time + dividend.recycleTime) {
288             return false;
289         }
290 
291         uint256 balance = valueAt(loggedBalances[msg.sender], dividend.block);
292 
293         if(balance == 0) {
294             return false;
295         }
296 
297         uint256 claim = balance * dividend.amount / dividend.totalSupply;
298 
299         dividend.claimed[msg.sender] = true;
300 
301         dividend.claimedAmount = dividend.claimedAmount + claim;
302 
303         if (claim > 0) {
304             msg.sender.transfer(claim);
305             DividendClaimed(dividendId, msg.sender, claim);
306 
307             return true;
308         }
309 
310         return false;
311     }
312 
313     function claimDividends() public {
314         require(dividendsClaimed[msg.sender] < dividends.length);
315         for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
316             if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
317                 dividendsClaimed[msg.sender] = i + 1;
318                 claimDividend(i);
319             }
320         }
321     }
322 
323     function recycleDividend(uint256 dividendId) public onlyOwner returns (bool success) {
324         if(dividends.length - 1 < dividendId) {
325             return false;
326         }
327 
328         Dividend storage dividend = dividends[dividendId];
329 
330         if(dividend.recycled) {
331             return false;
332         }
333 
334         dividend.recycled = true;
335 
336         return true;
337     }
338 
339     function refundUnclaimedEthers(uint256 dividendId) public onlyOwner returns (bool success) {
340         if(dividends.length - 1 < dividendId) {
341             return false;
342         }
343 
344         Dividend storage dividend = dividends[dividendId];
345 
346         if(dividend.recycled == false) {
347             if(now < dividend.time + dividend.recycleTime) {
348                 return false;
349             }
350         }
351 
352         uint256 claimedBackAmount = dividend.amount - dividend.claimedAmount;
353 
354         dividend.transferedBack = claimedBackAmount;
355 
356         if(claimedBackAmount > 0) {
357             owner.transfer(claimedBackAmount);
358 
359             UnclaimedDividendTransfer(dividendId, claimedBackAmount);
360 
361             return true;
362         }
363 
364         return false;
365     }
366 }
367 
368 contract LoggedPhaseICO is LoggedDividend {
369     uint256 public icoSince;
370     uint256 public icoTill;
371 
372     uint256 public collectedEthers;
373 
374     Phase[] public phases;
375 
376     struct Phase {
377     uint256 price;
378     uint256 maxAmount;
379     }
380 
381     function LoggedPhaseICO(
382     uint256 _icoSince,
383     uint256 _icoTill,
384     uint256 initialSupply,
385     string tokenName,
386     string tokenSymbol,
387     uint8 precision,
388     bool transferAllSupplyToOwner,
389     bool _locked
390     ) LoggedDividend(initialSupply, tokenName, precision, tokenSymbol, transferAllSupplyToOwner, _locked) {
391         standard = 'LoggedPhaseICO 0.1';
392 
393         icoSince = _icoSince;
394         icoTill = _icoTill;
395     }
396 
397     function getIcoTokensAmount(uint256 collectedEthers, uint256 value) returns (uint256) {
398         uint256 amount;
399 
400         uint256 newCollectedEthers = collectedEthers;
401         uint256 remainingValue = value;
402 
403         for (uint i = 0; i < phases.length; i++) {
404             Phase storage phase = phases[i];
405 
406             if(phase.maxAmount > newCollectedEthers) {
407                 if (newCollectedEthers + remainingValue > phase.maxAmount) {
408                     uint256 diff = phase.maxAmount - newCollectedEthers;
409 
410                     amount += diff * 1 ether / phase.price;
411 
412                     remainingValue -= diff;
413                     newCollectedEthers += diff;
414                 }
415                 else {
416                     amount += remainingValue * 1 ether / phase.price;
417 
418                     newCollectedEthers += remainingValue;
419 
420                     remainingValue = 0;
421                 }
422             }
423 
424             if (remainingValue == 0) {
425                 break;
426             }
427         }
428 
429         if (remainingValue > 0) {
430             return 0;
431         }
432 
433         return amount;
434     }
435 
436     function buy(address _address, uint256 time, uint256 value) internal returns (bool) {
437         if (locked == true) {
438             return false;
439         }
440 
441         if (time < icoSince) {
442             return false;
443         }
444 
445         if (time > icoTill) {
446             return false;
447         }
448 
449         if (value == 0) {
450             return false;
451         }
452 
453         uint256 amount = getIcoTokensAmount(collectedEthers, value);
454 
455         if(amount == 0) {
456             return false;
457         }
458 
459         uint256 selfBalance = valueAt(loggedBalances[this], block.number);
460         uint256 holderBalance = valueAt(loggedBalances[_address], block.number);
461 
462         if (selfBalance < amount) {
463             return false;
464         }
465 
466         if (holderBalance + amount < holderBalance) {
467             return false;
468         }
469 
470         setBalance(_address, holderBalance + amount);
471         setBalance(this, selfBalance - amount);
472 
473         collectedEthers += value;
474 
475         Transfer(this, _address, amount);
476 
477         return true;
478     }
479 
480     function () payable {
481         bool status = buy(msg.sender, now, msg.value);
482 
483         require(status == true);
484     }
485 }
486 
487 contract Cajutel is LoggedPhaseICO {
488     function Cajutel(
489     uint256 initialSupply,
490     string tokenName,
491     string tokenSymbol,
492     address founder1,
493     address founder2,
494     address marketing,
495     uint256 icoSince,
496     uint256 icoTill
497     ) LoggedPhaseICO(icoSince, icoTill, initialSupply, tokenName, tokenSymbol, 18, false, false) {
498         standard = 'Cajutel 0.1';
499 
500         phases.push(Phase(0.05 ether, 500 ether));
501         phases.push(Phase(0.075 ether, 750 ether + 500 ether));
502         phases.push(Phase(0.1 ether, 10000 ether + 750 ether + 500 ether));
503         phases.push(Phase(0.15 ether, 30000 ether + 10000 ether + 750 ether + 500 ether));
504         phases.push(Phase(0.2 ether, 80000 ether + 30000 ether + 10000 ether + 750 ether + 500 ether));
505 
506         uint256 founder1Tokens = 900000000000000000000000;
507         uint256 founder2Tokens = 100000000000000000000000;
508         uint256 marketingTokens = 60000000000000000000000;
509 
510         setBalance(founder1, founder1Tokens);
511 
512         Transfer(this, founder1, founder1Tokens);
513 
514         setBalance(founder2, founder2Tokens);
515 
516         Transfer(this, founder2, founder2Tokens);
517 
518         setBalance(marketing, marketingTokens);
519 
520         Transfer(this, marketing, marketingTokens);
521 
522         setBalance(this, initialSupply - founder1Tokens - founder2Tokens - marketingTokens);
523     }
524 
525     function transferEthers() onlyOwner {
526         owner.transfer(this.balance);
527     }
528 
529     function setLocked(bool _locked) onlyOwner {
530         locked = _locked;
531     }
532 
533     function setIcoDates(uint256 _icoSince, uint256 _icoTill) onlyOwner {
534         icoSince = _icoSince;
535         icoTill = _icoTill;
536     }
537 }