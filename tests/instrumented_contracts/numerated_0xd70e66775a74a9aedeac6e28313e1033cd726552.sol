1 pragma solidity ^0.4.16;
2 
3 
4 
5 contract TokenERC20 {
6 
7   /* Begin Owned Contract Members */
8   // An array of owners
9   mapping (address => bool) public owners;
10 
11   // Has the next action been authorised by another owner
12   bool public nextActionIsAuthorised = false;
13   address public actionAuthorisedBy;
14   // Does an owner-only action have to be authorised by another owner
15   bool public requireAuthorisation = true;
16 
17 
18 
19   function isOwner(address addressToCheck) view public returns (bool) {
20     return owners[addressToCheck];
21   }
22 
23 
24 
25   modifier onlyOwners {
26     require(isOwner(msg.sender));
27     if (requireAuthorisation) {
28       checkActionIsAuthorisedAndReset();
29     }
30     _;
31   }
32 
33 
34 
35   function authoriseNextAction() public {
36     require(isOwner(msg.sender));
37     require(requireAuthorisation);
38     require(!nextActionIsAuthorised);
39     nextActionIsAuthorised = true;
40     actionAuthorisedBy = msg.sender;
41   }
42 
43 
44 
45   function checkActionIsAuthorisedAndReset() public {
46     require(isOwner(msg.sender));
47     bool isValidAuthorisationRequest = (nextActionIsAuthorised && actionAuthorisedBy != msg.sender);
48     require(isValidAuthorisationRequest);
49     nextActionIsAuthorised = false;
50   }
51 
52 
53 
54   function setRequireAuthorisation(bool _requireAuthorisation) onlyOwners public {
55     requireAuthorisation = _requireAuthorisation;
56   }
57   /* End Owned Contract Members */
58 
59 
60   // Public variables of the token
61   bool public tokenInitialised = false;
62   string public name;
63   string public symbol;
64   uint8 public decimals = 18;
65   uint256 public totalSupply;
66   uint256 public sellPrice;
67   address public currentSeller;
68 
69   // Are users currently allowed to...
70   bool public allowTransfers = false; // transfer their tokens
71   bool public allowBurns = false;     // burn their tokens
72   bool public allowBuying = false;    // buy tokens
73 
74   // This creates an array with...
75   mapping (address => uint256) public balanceOf;    // all balances
76   mapping (address => uint256) public etherSpent;   // how much an addeess has spent
77   mapping (address => bool) public frozenAccounts;  // frozen accounts
78   address[] investors;
79   uint64 public investorCount;
80 
81 
82 
83   /*** Begin ICO Variables ***/
84 
85   // Unit lenghts for week, month and year
86   uint256 constant public weekLength = 60 * 60 * 24 * 7;
87   uint256 constant public monthLength = 2627856; // (60 * 60 * 24 * 30.415) As to not have to re-adjust for different month lengths
88   uint256 constant public yearLength = 60 * 60 * 24 * 7 * 52;
89 
90   uint256 public icoBeginDate;
91   uint256 public icoEndDate;
92   bool public icoParametersSet = false;
93 
94   uint256 public tokensSoldAtIco = 0;
95   uint256 public minimumTokenThreshold;
96   bool public etherHasBeenReturnedToInvestors = false;
97   uint256 public softCap;
98   uint256 public runTimeAfterSoftCapReached;
99   uint256 public dateSoftCapWasReached = 0;
100 
101   uint256 public maxFundsThatCanBeWithdrawnByOwners = 0;
102   uint256 public fundsWithdrawnByOwners = 0;
103 
104   uint8 immediateAllowancePercentage;
105   uint8 firstYearAllowancePercentage;
106   uint8 secondYearAllowancePercentage;
107 
108   mapping (uint8 => uint8) public weekBonuses; // Bonus of 20% is stored as 120, 10% as 110 etc.
109 
110 
111 
112   modifier onlyWhenIcoParametersAreSet {
113     require(icoParametersSet);
114     _;
115   }
116 
117 
118 
119   modifier onlyWhenIcoParametersAreNotSet {
120     require(!icoParametersSet);
121     _;
122   }
123 
124 
125 
126   modifier onlyDuringIco {
127     require(icoParametersSet);
128     updateContract();
129     require(isIcoRunning());
130     _;
131   }
132   /*** End ICO Variables ***/
133 
134 
135 
136   /*** Begin ICO Setters ***/
137   function setIcoParametersSet(bool set) onlyWhenIcoParametersAreNotSet onlyOwners public {
138     icoParametersSet = set;
139   }
140 
141 
142 
143   function setIcoBeginDate(uint256 beginDate) onlyWhenIcoParametersAreNotSet onlyOwners public {
144     icoBeginDate = beginDate;
145   }
146 
147 
148 
149   function setIcoEndDate (uint256 endDate) onlyWhenIcoParametersAreNotSet onlyOwners public {
150     icoEndDate = endDate;
151   }
152 
153 
154 
155   function setSoftCap (uint256 cap) onlyWhenIcoParametersAreNotSet onlyOwners public {
156     softCap = cap;
157   }
158 
159 
160 
161   function setRunTimeAfterSoftCapReached (uint256 runTime) onlyWhenIcoParametersAreNotSet onlyOwners public {
162     runTimeAfterSoftCapReached = runTime;
163   }
164 
165 
166 
167   function setImmediateAllowancePercentage(uint8 allowancePercentage) onlyWhenIcoParametersAreNotSet onlyOwners public {
168     immediateAllowancePercentage = allowancePercentage;
169   }
170 
171 
172 
173   function setFirstYearAllowancePercentage(uint8 allowancePercentage) onlyWhenIcoParametersAreNotSet onlyOwners public {
174     firstYearAllowancePercentage = allowancePercentage;
175   }
176 
177 
178 
179   function setSecondYearAllowancePercentage(uint8 allowancePercentage) onlyWhenIcoParametersAreNotSet onlyOwners public {
180     secondYearAllowancePercentage = allowancePercentage;
181   }
182 
183 
184 
185   function initialiseToken() public {
186     require(!tokenInitialised);
187     name = "BaraToken";
188     symbol = "BRT";
189     totalSupply = 160000000 * 10 ** uint256(decimals);
190     balanceOf[msg.sender] = totalSupply;
191     currentSeller = msg.sender;
192     owners[msg.sender] = true;
193     owners[0x1434e028b12D196AcBE5304A94d0a5F816eb5d55] = true;
194     tokenInitialised = true;
195   }
196 
197 
198 
199   function() payable public {
200     buyTokens();
201   }
202 
203 
204 
205   function updateContract() onlyWhenIcoParametersAreSet public {
206     if (hasSoftCapBeenReached() && dateSoftCapWasReached == 0) {
207       dateSoftCapWasReached = now;
208       bool reachingSoftCapWillExtendIco = (dateSoftCapWasReached + runTimeAfterSoftCapReached > icoEndDate);
209       if (!reachingSoftCapWillExtendIco)
210         icoEndDate = dateSoftCapWasReached + runTimeAfterSoftCapReached;
211     }
212     if (!isBeforeIco())
213       updateOwnersWithdrawAllowance();
214   }
215 
216 
217 
218   function isBeforeIco() onlyWhenIcoParametersAreSet internal view returns (bool) {
219     return (now <= icoBeginDate);
220   }
221 
222 
223 
224   function isIcoRunning() onlyWhenIcoParametersAreSet internal view returns (bool) {
225     bool reachingSoftCapWillExtendIco = (dateSoftCapWasReached + runTimeAfterSoftCapReached) > icoEndDate;
226     bool afterBeginDate = now > icoBeginDate;
227     bool beforeEndDate = now < icoEndDate;
228     if (hasSoftCapBeenReached() && !reachingSoftCapWillExtendIco)
229       beforeEndDate = now < (dateSoftCapWasReached + runTimeAfterSoftCapReached);
230     bool running = afterBeginDate && beforeEndDate;
231     return running;
232   }
233 
234 
235 
236   function isAfterIco() onlyWhenIcoParametersAreSet internal view returns (bool) {
237     return (now > icoEndDate);
238   }
239 
240 
241 
242 
243   function hasSoftCapBeenReached() onlyWhenIcoParametersAreSet internal view returns (bool) {
244     return (tokensSoldAtIco >= softCap && softCap != 0);
245   }
246 
247 
248 
249   // In the first week of the ICO, there will be a bonus, say 20%, then the second week 10%,
250   // of tokens. This retrieves that bonus. 20% is stored as 120, 10% as 110, etc.
251   function getWeekBonus(uint256 amountPurchased) onlyWhenIcoParametersAreSet internal view returns (uint256) {
252     uint256 weekBonus = uint256(weekBonuses[getWeeksPassedSinceStartOfIco()]);
253     if (weekBonus != 0)
254       return (amountPurchased * weekBonus) / 100;
255     return amountPurchased;
256   }
257 
258 
259 
260   function getTimeSinceEndOfIco() onlyWhenIcoParametersAreSet internal view returns (uint256) {
261     require(now > icoEndDate);
262     uint256 timeSinceEndOfIco = now - icoEndDate;
263     return timeSinceEndOfIco;
264   }
265 
266 
267 
268   function getWeeksPassedSinceStartOfIco() onlyWhenIcoParametersAreSet internal view returns (uint8) {
269     require(!isBeforeIco());
270     uint256 timeSinceIco = now - icoBeginDate;
271     uint8 weeksPassedSinceIco = uint8(timeSinceIco / weekLength);
272     return weeksPassedSinceIco;
273   }
274 
275 
276 
277   // Update how much the owners can withdraw based on how much time has passed
278   // since the end of the ICO
279   function updateOwnersWithdrawAllowance() onlyWhenIcoParametersAreSet internal {
280     if (isAfterIco()) {
281       uint256 totalFunds = this.balance;
282       maxFundsThatCanBeWithdrawnByOwners = 0;
283       uint256 immediateAllowance = (totalFunds * immediateAllowancePercentage) / 100;
284       bool secondYear = now - icoEndDate >= yearLength;
285       uint8 monthsPassedSinceIco = getMonthsPassedEndOfSinceIco();
286       if (secondYear) {
287         uint256 monthsPassedInSecondYear = monthsPassedSinceIco - 12;
288         // (monthsPassed / 12) * (allowancePercentage / 100) i.e. (monthsPassed * allowancePercentage / 1200)
289         // all multiplied by the totalFunds available to be withdrwan
290         // They're multiplied in one line to ensure not losing any information since we don't have floats
291         // The minimum a person can buy is 1/10^12 tokens and we have 18 decimals, meaning always at least
292         // 6 decimals to hold information done in multiplication/division
293         uint256 secondYearAllowance = ((totalFunds * secondYearAllowancePercentage * monthsPassedInSecondYear) / 1200);
294       }
295       uint8 monthsPassedInFirstYear = monthsPassedSinceIco;
296       if (secondYear)
297         monthsPassedInFirstYear = 12;
298       uint256 firstYearAllowance = ((totalFunds * firstYearAllowancePercentage * monthsPassedInFirstYear) / 1200);
299       maxFundsThatCanBeWithdrawnByOwners = immediateAllowance + firstYearAllowance + secondYearAllowance;
300     }
301   }
302 
303 
304 
305   function getMonthsPassedEndOfSinceIco() onlyWhenIcoParametersAreSet internal view returns (uint8) {
306     uint256 timePassedSinceIco = now - icoEndDate;
307     uint8 monthsPassedSinceIco = uint8(timePassedSinceIco / weekLength);
308     return monthsPassedSinceIco + 1;
309   }
310 
311 
312 
313   // Check if the amount the owners are attempting to withdraw is within their current allowance
314   function amountIsWithinOwnersAllowance(uint256 amountToWithdraw) internal view returns (bool) {
315     if (now - icoEndDate >= yearLength * 2)
316       return true;
317     uint256 totalFundsWithdrawnAfterThisTransaction = fundsWithdrawnByOwners + amountToWithdraw;
318     bool withinAllowance = totalFundsWithdrawnAfterThisTransaction <= maxFundsThatCanBeWithdrawnByOwners;
319     return withinAllowance;
320   }
321 
322 
323 
324   function buyTokens() onlyDuringIco payable public {
325     require(allowBuying);
326     require(!frozenAccounts[msg.sender]);
327     require(msg.value > 0);
328     uint256 numberOfTokensPurchased = msg.value / sellPrice;
329     require(numberOfTokensPurchased >= 10 ** 6);
330     numberOfTokensPurchased = getWeekBonus(numberOfTokensPurchased);
331     _transfer(currentSeller, msg.sender, numberOfTokensPurchased);
332     tokensSoldAtIco += numberOfTokensPurchased;
333     if (!(etherSpent[msg.sender] > 0)) {
334       investors[investorCount] = msg.sender;
335       investorCount++;
336     }
337     etherSpent[msg.sender] += msg.value;
338   }
339 
340 
341 
342   /* These generate a public event on the blockchain that will notify clients */
343   event Transfer(address indexed from, address indexed to, uint256 value);
344   event Burn(address indexed from, uint256 value);
345   event FrozenFunds(address target, bool frozen);
346   event NewSellPrice(uint256 _sellPrice);
347 
348 
349 
350   function setTokenName(string tokenName) onlyOwners public {
351     name = tokenName;
352   }
353 
354 
355 
356   function setTokenSymbol(string tokenSymbol) onlyOwners public {
357     symbol = tokenSymbol;
358   }
359 
360 
361 
362   function setAllowTransfers(bool allow) onlyOwners public {
363     allowTransfers = allow;
364   }
365 
366 
367 
368   function setAllowBurns(bool allow) onlyOwners public {
369     allowBurns = allow;
370   }
371 
372 
373 
374   function setAllowBuying(bool allow) onlyOwners public {
375     allowBuying = allow;
376   }
377 
378 
379 
380   function setSellPrice(uint256 _sellPrice) onlyOwners public {
381     sellPrice = _sellPrice;
382     NewSellPrice(_sellPrice);
383   }
384 
385 
386 
387   function setCurrentSeller(address newSeller) onlyOwners public {
388     currentSeller = newSeller;
389   }
390 
391 
392 
393   function ownersTransfer(address _to, uint256 _amount) onlyOwners public {
394     _transfer(msg.sender, _to, _amount);
395   }
396 
397 
398 
399   function transfer(address _to, uint256 _value) public {
400     require(allowTransfers && !isOwner(msg.sender));
401     _transfer(msg.sender, _to, _value);
402   }
403 
404 
405 
406   function _transfer(address _from, address _to, uint _value) internal {
407     require (_to != 0x0);
408     require (balanceOf[_from] >= _value);
409     require (balanceOf[_to] + _value > balanceOf[_to]);
410     require(!frozenAccounts[_from]);
411     require(!frozenAccounts[_to]);
412     balanceOf[_from] -= _value;
413     balanceOf[_to] += _value;
414     Transfer(_from, _to, _value);
415   }
416 
417 
418 
419   function mintToken(address target, uint256 mintedAmount) onlyOwners public {
420     balanceOf[target] += mintedAmount;
421     totalSupply += mintedAmount;
422     Transfer(0, this, mintedAmount);
423     Transfer(this, target, mintedAmount);
424   }
425 
426 
427 
428   function burn(uint256 amount) public {
429     require(allowBurns && !isOwner(msg.sender));
430     require(balanceOf[msg.sender] >= amount);
431     balanceOf[msg.sender] -= amount;
432     totalSupply -= amount;
433     Burn(msg.sender, amount);
434   }
435 
436 
437 
438   function burnFrom(address from, uint256 amount) onlyOwners public {
439     require (balanceOf[from] >= amount);
440     balanceOf[from] -= amount;
441     totalSupply -= amount;
442     Burn(from, amount);
443   }
444 
445 
446 
447   function freezeAccount(address target, bool freeze) onlyOwners public {
448     frozenAccounts[target] = freeze;
449     FrozenFunds(target, freeze);
450   }
451 
452 
453 
454   function addOwner(address owner) onlyOwners public {
455     owners[owner] = true;
456   }
457 
458 
459 
460   function removeOwner(address owner) onlyOwners public {
461     owners[owner] = false;
462   }
463 
464 
465 
466   function sendContractFundsToAddress(uint256 amount, address recipient) onlyOwners public {
467     require(icoParametersSet);
468     require(isAfterIco());
469     require(tokensSoldAtIco >= minimumTokenThreshold);
470     require(amount <= this.balance);
471     updateContract();
472     require(amountIsWithinOwnersAllowance(amount));
473     recipient.transfer(amount);
474   }
475 
476 
477 
478   function returnEtherToInvestors() onlyOwners onlyWhenIcoParametersAreSet public {
479     require(isAfterIco());
480     require(!etherHasBeenReturnedToInvestors);
481     require(tokensSoldAtIco < minimumTokenThreshold);
482     for (uint64 investorNumber; investorNumber < investorCount; investorNumber++) {
483       address investor = investors[investorNumber];
484       uint256 amountToSend = etherSpent[investor];
485       investor.transfer(amountToSend);
486     }
487     etherHasBeenReturnedToInvestors = true;
488   }
489 
490 
491 
492   function getContractBalance() public view returns (uint256) {
493     return this.balance;
494   }
495 
496 
497 
498 
499 }