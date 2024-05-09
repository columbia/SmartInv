1 pragma solidity ^0.4.8;
2 
3 contract ERC20 {
4     // Standard interface
5     function totalSupply() public constant returns(uint256 _totalSupply);
6     function balanceOf(address who) public constant returns(uint256 balance);
7     function transfer(address to, uint value) public returns(bool success);
8     function transferFrom(address from, address to, uint value) public returns(bool success);
9     function approve(address spender, uint value) public returns(bool success);
10     function allowance(address owner, address spender) public constant returns(uint remaining);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract SMSCoin is ERC20 {
16     string public constant name = "Speed Mining Service";
17     string public constant symbol = "SMS";
18     uint256 public constant decimals = 3;
19 
20     uint256 public constant UNIT = 10 ** decimals;
21 
22     uint public totalSupply = 0; // (initial with 0), targeted 2.9 Million SMS
23 
24     uint tokenSaleLot1 = 150000 * UNIT;
25     uint reservedBonusLot1 = 45000 * UNIT; // 45,000 tokens are the maximum possible bonus from 30% of 150,000 tokens in the bonus phase
26     uint tokenSaleLot2 = 50000 * UNIT;
27     uint tokenSaleLot3 = 50000 * UNIT;
28 
29     struct BonusStruct {
30         uint8 ratio1;
31         uint8 ratio2;
32         uint8 ratio3;
33         uint8 ratio4;
34     }
35     BonusStruct bonusRatio;
36 
37     uint public saleCounter = 0;
38 
39     uint public limitedSale = 0;
40 
41     uint public sentBonus = 0;
42 
43     uint public soldToken = 0;
44 
45     mapping(address => uint) balances;
46 
47     mapping(address => mapping(address => uint)) allowed;
48 
49     address[] addresses;
50 
51     mapping(address => address) private userStructs;
52 
53     address owner;
54 
55     address mint = address(this);   // Contract address as a minter
56     
57     address genesis = 0x0;
58 
59     //uint256 public tokenPrice = 0.001 ether; // Test
60     uint256 public tokenPrice = 0.8 ether;
61 
62     event Log(uint e);
63 
64     event TOKEN(string e);
65 
66     bool icoOnPaused = false;
67 
68     uint256 startDate;
69 
70     uint256 endDate;
71 
72     uint currentPhase = 0;
73 
74     bool needToBurn = false;
75 
76     modifier onlyOwner() {
77         if (msg.sender != owner) {
78             revert();
79         }
80         _;
81     }
82 
83     function SMSCoin() public {
84         owner = msg.sender;
85     }
86 
87     /**
88      * Divide with safety check
89      */
90     function safeDiv(uint a, uint b) pure internal returns(uint) {
91         //overflow check; b must not be 0
92         assert(b > 0);
93         uint c = a / b;
94         assert(a == b * c + a % b);
95         return c;
96     }
97 
98     /**
99      * Multiplication with safety check
100      */
101     function safeMul(uint a, uint b) pure internal returns(uint) {
102         uint c = a * b;
103         //check result should not be other wise until a=0
104         assert(a == 0 || c / a == b);
105         return c;
106     }
107 
108     /**
109      * Add with safety check
110      */
111     function safeAdd(uint a, uint b) pure internal returns (uint) {
112         assert (a + b >= a);
113         return a + b;
114     }
115 
116     function setBonus(uint8 ratio1, uint8 ratio2, uint8 ratio3, uint8 ratio4) private {
117         bonusRatio.ratio1 = ratio1;
118         bonusRatio.ratio2 = ratio2;
119         bonusRatio.ratio3 = ratio3;
120         bonusRatio.ratio4 = ratio4;
121     }
122 
123     function calcBonus(uint256 sendingSMSToken) view private returns(uint256) {
124         uint256 sendingSMSBonus;
125 
126         // Calculating bonus
127         if (sendingSMSToken < (10 * UNIT)) {            // 0-9
128             sendingSMSBonus = (sendingSMSToken * bonusRatio.ratio1) / 100;
129         } else if (sendingSMSToken < (50 * UNIT)) {     // 10-49
130             sendingSMSBonus = (sendingSMSToken * bonusRatio.ratio2) / 100;
131         } else if (sendingSMSToken < (100 * UNIT)) {    // 50-99
132             sendingSMSBonus = (sendingSMSToken * bonusRatio.ratio3) / 100;
133         } else {                                        // 100+
134             sendingSMSBonus = (sendingSMSToken * bonusRatio.ratio4) / 100;
135         }
136 
137         return sendingSMSBonus;
138     }
139 
140     // Selling SMS token
141     function () public payable {
142         uint256 receivedETH = 0;
143         uint256 sendingSMSToken = 0;
144         uint256 sendingSMSBonus = 0;
145         Log(msg.value);
146 
147         // Only for selling to investors
148         if (!icoOnPaused && msg.sender != owner) {
149             if (now <= endDate) {
150                 // All the phases
151                 Log(currentPhase);
152 
153                 // Calculating SMS
154                 receivedETH = (msg.value * UNIT);
155                 sendingSMSToken = safeDiv(receivedETH, tokenPrice);
156                 Log(sendingSMSToken);
157 
158                 // Calculating Bonus
159                 if (currentPhase == 1 || currentPhase == 2 || currentPhase == 3) {
160                     // Phase 1-3 with Bonus 1
161                     sendingSMSBonus = calcBonus(sendingSMSToken);
162                     Log(sendingSMSBonus);
163                 }
164 
165                 // Giving SMS + Bonus (if any)
166                 Log(sendingSMSToken);
167                 if (!transferTokens(msg.sender, sendingSMSToken, sendingSMSBonus))
168                     revert();
169             } else {
170                 revert();
171             }
172 
173         } else {
174             revert();
175         }
176     }
177 
178     // ======== Bonus Period 1 ========
179     // --- Bonus ---
180     // 0-9 SMS -> 5%
181     // 10-49 SMS -> 10%
182     // 50-99 SMS -> 20%
183     // 100~ SMS -> 30%
184     // --- Time --- (2 days 9 hours 59 minutes 59 seconds )
185     // From 27 Oct 2017, 14:00 PM JST (27 Oct 2017, 5:00 AM GMT)
186     // To   29 Oct 2017, 23:59 PM JST (29 Oct 2017, 14:59 PM GMT)
187     function start1BonusPeriod1() external onlyOwner {
188         // Supply setting (only once)
189         if (currentPhase == 0) {
190             balances[owner] = tokenSaleLot1; // Start balance for SpeedMining Co., Ltd.
191             balances[address(this)] = tokenSaleLot1;  // Start balance for SMSCoin (for investors)
192             totalSupply = balances[owner] + balances[address(this)];
193             saleCounter = 0;
194             limitedSale = tokenSaleLot1;
195 
196             // Add owner address into the list as the first wallet who own token(s)
197             addAddress(owner);
198 
199             // Send owner account the initial tokens (rather than only a contract address)
200             Transfer(address(this), owner, balances[owner]);
201 
202             // Set burning is needed
203             needToBurn = true;
204         }
205 
206         // ICO stage init
207         icoOnPaused = false;
208         currentPhase = 1;
209         startDate = block.timestamp;
210         endDate = startDate + 2 days + 9 hours + 59 minutes + 59 seconds;
211 
212         // Bonus setting 
213         setBonus(5, 10, 20, 30);
214     }
215 
216     // ======== Bonus Period 2 ========
217     // --- Bonus ---
218     // 0-9 SMS -> 3%
219     // 10-49 SMS -> 5%
220     // 50-99 SMS -> 10%
221     // 100~ SMS -> 15%
222     // --- Time --- (11 days 9 hours 59 minutes 59 seconds)
223     // From 30 Oct 2017, 14:00 PM JST (30 Oct 2017, 5:00 AM GMT)
224     // To   10 Nov 2017, 23:59 PM JST (10 Nov 2017, 14:59 PM GMT)
225     function start2BonusPeriod2() external onlyOwner {
226         // ICO stage init
227         icoOnPaused = false;
228         currentPhase = 2;
229         startDate = block.timestamp;
230         endDate = startDate + 11 days + 9 hours + 59 minutes + 59 seconds;
231 
232         // Bonus setting 
233         setBonus(3, 5, 10, 15);
234     }
235 
236     // ======== Bonus Period 3 ========
237     // --- Bonus ---
238     // 0-9 SMS -> 1%
239     // 10-49 SMS -> 3%
240     // 50-99 SMS -> 5%
241     // 100~ SMS -> 8%
242     // --- Time --- (51 days)
243     // From 11 Nov 2017, 00:00 AM JST (10 Nov 2017, 15:00 PM GMT)
244     // To   31 Dec 2017, 23:59 PM JST (31 Dec 2017, 14:59 PM GMT)
245     function start3BonusPeriod3() external onlyOwner {
246         // ICO stage init
247         icoOnPaused = false;
248         currentPhase = 3;
249         startDate = block.timestamp;
250         endDate = startDate + 51 days;
251 
252         // Bonus setting 
253         setBonus(1, 3, 5, 8);
254     }
255 
256     // ======== Normal Period 1 (2018) ========
257     // --- Time --- (31 days)
258     // From 1 Jan 2018, 00:00 AM JST (31 Dec 2017, 15:00 PM GMT)
259     // To   31 Jan 2018, 23:59 PM JST (31 Jan 2018, 14:59 PM GMT)
260     function start4NormalPeriod() external onlyOwner {
261         // ICO stage init
262         icoOnPaused = false;
263         currentPhase = 4;
264         startDate = block.timestamp;
265         endDate = startDate + 31 days;
266 
267         // Reset bonus
268         setBonus(0, 0, 0, 0);
269     }
270 
271     // ======== Normal Period 2 (2020) ========
272     // --- Bonus ---
273     // 3X
274     // --- Time --- (7 days)
275     // From 2 Jan 2020, 00:00 AM JST (1 Jan 2020, 15:00 PM GMT)
276     // To   8 Jan 2020, 23:59 PM JST (8 Oct 2020, 14:59 PM GMT)
277     function start5Phase2020() external onlyOwner {
278         // Supply setting (only after phase 4)
279         if (currentPhase == 4) {
280             // Burn SMS if it was not done yet
281             if (needToBurn)
282                 burnSMSProcess();
283                 
284             balances[address(this)] = tokenSaleLot2;
285             totalSupply = 3 * totalSupply;
286             totalSupply += balances[address(this)];
287             saleCounter = 0;
288             limitedSale = tokenSaleLot2;
289 
290             // Bonus
291             x3Token(); // 3X distributions to token holders
292 
293             // Mint new tokens for 2020
294             Transfer(mint, address(this), balances[address(this)]);
295 
296             // Set burning is needed
297             needToBurn = true;
298         }
299 
300         // ICO stage init
301         icoOnPaused = false;
302         currentPhase = 5;
303         startDate = block.timestamp;
304         endDate = startDate + 7 days;
305     }
306 
307     // ======== Normal Period 3 (2025) ========
308     // --- Bonus ---
309     // 3X
310     // --- Time --- (7 days)
311     // From 2 Jan 2025, 00:00 AM JST (1 Jan 2025, 15:00 PM GMT)
312     // To   8 Jan 2025, 23:59 PM JST (8 Oct 2025, 14:59 PM GMT)
313     function start6Phase2025() external onlyOwner {
314         // Supply setting (only after phase 5)
315         if (currentPhase == 5) {
316             // Burn SMS if it was not done yet
317             if (needToBurn)
318                 burnSMSProcess();
319 
320             balances[address(this)] = tokenSaleLot3;
321             totalSupply = 3 * totalSupply;
322             totalSupply += balances[address(this)];
323             saleCounter = 0;
324             limitedSale = tokenSaleLot3;
325             
326             // Bonus
327             x3Token(); // 3X distributions to token holders
328 
329             // Mint new tokens for 2025
330             Transfer(mint, address(this), balances[address(this)]);
331 
332             // Set burning is needed
333             needToBurn = true;
334         }
335         
336         // ICO stage init
337         icoOnPaused = false;
338         currentPhase = 6;
339         startDate = block.timestamp;
340         endDate = startDate + 7 days;
341     }
342 
343     function x3Token() private {
344         // Multiply token by 3 to all the current addresses
345         for (uint i = 0; i < addresses.length; i++) {
346             uint curr1XBalance = balances[addresses[i]];
347             // In total 3X, then also calculate value to balances
348             balances[addresses[i]] = 3 * curr1XBalance;
349             // Transfer 2X from Mint to add with the existing 1X
350             Transfer(mint, addresses[i], 2 * curr1XBalance);
351             // To keep tracking bonus distribution
352             sentBonus += (2 * curr1XBalance);
353         }
354     }
355 
356     // Called by the owner, to emergency pause the current phase
357     function pausePhase() external onlyOwner {
358         icoOnPaused = true;
359     }
360 
361     // Called by the owner, to resumes the paused phase
362     function resumePhase() external onlyOwner {
363         icoOnPaused = false;
364     }
365 
366     // Standard interface
367     function totalSupply() public constant returns(uint256 _totalSupply) {
368         return totalSupply;
369     }
370 
371     function balanceOf(address sender) public constant returns(uint256 balance) {
372         return balances[sender];
373     }
374 
375     function soldToken() public constant returns(uint256 _soldToken) {
376         return soldToken;
377     }
378 
379     function sentBonus() public constant returns(uint256 _sentBonus) {
380         return sentBonus;
381     }
382 
383     function saleCounter() public constant returns(uint256 _saleCounter) {
384         return saleCounter;
385     }
386 
387     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success) {
388         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
389                 
390             balances[_from] -= _amount;
391             allowed[_from][msg.sender] -= _amount;
392             balances[_to] += _amount;
393             Transfer(_from, _to, _amount);
394             return true;
395         } else {
396             return false;
397         }
398     }
399 
400     // Price should be entered in multiple of 10000's
401     // E.g. for .0001 ether enter 1, for 5 ether price enter 50000 
402     function setTokenPrice(uint ethRate) external onlyOwner {
403         tokenPrice = (ethRate * 10 ** 18) / 10000; // (Convert to ether unit then make 4 decimals)
404     }
405 
406     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
407     // If this function is called again it overwrites the current allowance with _value.
408     function approve(address _spender, uint256 _amount) public returns(bool success) {
409         allowed[msg.sender][_spender] = _amount;
410         Approval(msg.sender, _spender, _amount);
411         return true;
412     }
413 
414     function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
415         return allowed[_owner][_spender];
416     }
417 
418     // Transfer the balance from caller's wallet address to investor's wallet address
419     function transfer(address _to, uint256 _amount) public returns(bool success) {
420         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
421 
422             balances[msg.sender] -= _amount;
423             balances[_to] += _amount;
424             Transfer(msg.sender, _to, _amount);
425 
426             // Add destination wallet address to the list
427             addAddress(_to);
428 
429             return true;
430         } else {
431             return false;
432         }
433     }
434 
435     // Transfer the balance from SMS's contract address to an investor's wallet account
436     function transferTokens(address _to, uint256 _amount, uint256 _bonus) private returns(bool success) {
437         if (_amount > 0 && balances[address(this)] >= _amount && balances[address(this)] - _amount >= 0 && soldToken + _amount > soldToken && saleCounter + _amount <= limitedSale && balances[_to] + _amount > balances[_to]) {
438             
439             // Transfer token from contract to target
440             balances[address(this)] -= _amount;
441             soldToken += _amount;
442             saleCounter += _amount;
443             balances[_to] += _amount;
444             Transfer(address(this), _to, _amount);
445             
446             // Transfer bonus token from owner to target
447             if (currentPhase <= 3 && _bonus > 0 && balances[owner] - _bonus >= 0 && sentBonus + _bonus > sentBonus && sentBonus + _bonus <= reservedBonusLot1 && balances[_to] + _bonus > balances[_to]) {
448 
449                 // Transfer with bonus
450                 balances[owner] -= _bonus;
451                 sentBonus += _bonus;
452                 balances[_to] += _bonus;
453                 Transfer(owner, _to, _bonus);
454             }
455 
456             // Add investor wallet address to the list
457             addAddress(_to);
458 
459             return true;
460         } else {
461             return false;
462         }
463     }
464 
465     // Add wallet address with existing check
466     function addAddress(address _to) private {
467         if (addresses.length > 0) {
468             if (userStructs[_to] != _to) {
469                 userStructs[_to] = _to;
470                 addresses.push(_to);
471             }
472         } else {
473             userStructs[_to] = _to;
474             addresses.push(_to);
475         }
476     }
477 
478     // Drain all the available ETH from the contract back to owner's wallet
479     function drainETH() external onlyOwner {
480         owner.transfer(this.balance);
481     }
482 
483     // Burn all the available SMS from the contract and from owner to make it equal to investors
484     // This will burn only the available token up to the current phase
485     // A burning function 
486     function burnSMSProcess() private {
487         // Allow to burn left SMS only on phase 4, 5, 6
488         if (currentPhase >= 4) {
489             // Burn all available tokens
490             // From SMS contract
491             if (balances[address(this)] > 0) {
492                 uint toBeBurnedFromContract = balances[address(this)];
493                 Transfer(address(this), genesis, toBeBurnedFromContract);
494                 balances[address(this)] = 0;
495                 totalSupply -= toBeBurnedFromContract;
496 
497                 // Burn from owner wallet only in phase 4
498                 if (currentPhase == 4) {
499                     if (balances[owner] > soldToken) {
500                         uint toBeBurnedFromOwner = balances[owner] - soldToken;
501                         Transfer(owner, genesis, toBeBurnedFromOwner);
502                         balances[owner] = balances[owner] - toBeBurnedFromOwner;
503                         totalSupply -= toBeBurnedFromOwner;
504                     }
505                 }
506 
507                 // Clear burning status
508                 needToBurn = false;
509             }
510         }
511     }
512 
513     // Function used in Reward contract to know address of token holder
514     function getAddress(uint i) public constant returns(address) {
515         return addresses[i];
516     }
517 
518     // Function used in Reward contract to get to know the address array length
519     function getAddressSize() public constant returns(uint) {
520         return addresses.length;
521 
522     }
523 }