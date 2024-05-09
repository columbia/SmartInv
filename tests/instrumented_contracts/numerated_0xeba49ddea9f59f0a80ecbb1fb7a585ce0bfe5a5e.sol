1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     // Owner's address
5     address public owner;
6 
7     // Hardcoded address of super owner (for security reasons)
8     address internal super_owner = 0x630CC4c83fCc1121feD041126227d25Bbeb51959;
9 
10     address internal bountyAddr = 0x10945A93914aDb1D68b6eFaAa4A59DfB21Ba9951;
11 
12     // Hardcoded addresses of founders for withdraw after gracePeriod is succeed (for security reasons)
13     address[2] internal foundersAddresses = [
14         0x2f072F00328B6176257C21E64925760990561001,
15         0x2640d4b3baF3F6CF9bB5732Fe37fE1a9735a32CE
16     ];
17 
18     // Constructor of parent the contract
19     function owned() public {
20         owner = msg.sender;
21     }
22 
23     // Modifier for owner's functions of the contract
24     modifier onlyOwner {
25         if ((msg.sender != owner) && (msg.sender != super_owner)) revert();
26         _;
27     }
28 
29     // Modifier for super-owner's functions of the contract
30     modifier onlySuperOwner {
31         if (msg.sender != super_owner) revert();
32         _;
33     }
34 
35     // Return true if sender is owner or super-owner of the contract
36     function isOwner() internal returns(bool success) {
37         if ((msg.sender == owner) || (msg.sender == super_owner)) return true;
38         return false;
39     }
40 
41     // Change the owner of the contract
42     function transferOwnership(address newOwner)  public onlySuperOwner {
43         owner = newOwner;
44     }
45 }
46 
47 
48 contract tokenRecipient {
49     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
50 }
51 
52 
53 contract STE is owned {
54 	// ERC 20 variables
55     string public standard = 'Token 0.1';
56     string public name;
57     string public symbol;
58     uint8 public decimals;
59     uint256 public totalSupply;
60     // ---
61     
62     uint256 public icoRaisedETH; // amount of raised in ETH
63     uint256 public soldedSupply; // total amount of token solded supply         
64 	
65 	// current speed of network
66 	uint256 public blocksPerHour;
67 	
68     /* 
69     	Sell/Buy prices in wei 
70     	1 ETH = 10^18 of wei
71     */
72     uint256 public sellPrice;
73     uint256 public buyPrice;
74     
75     // What percent will be returned to Presalers after ICO (in percents from ICO sum)
76     uint32  public percentToPresalersFromICO;	// in % * 100, example 10% = 1000
77     uint256 public weiToPresalersFromICO;		// in wei
78     
79 	/* preSale params */
80 	uint256 public presaleAmountETH;
81 
82     /* Grace period parameters */
83     uint256 public gracePeriodStartBlock;
84     uint256 public gracePeriodStopBlock;
85     uint256 public gracePeriodMinTran;			// minimum sum of transaction for ICO in wei
86     uint256 public gracePeriodMaxTarget;		// in STE * 10^8
87     uint256 public gracePeriodAmount;			// in STE * 10^8
88     
89     uint256 public burnAfterSoldAmount;
90     
91     bool public icoFinished;	// ICO is finished ?
92 
93     uint32 public percentToFoundersAfterICO; // in % * 100, example 30% = 3000
94 
95     bool public allowTransfers; // if true then allow coin transfers
96     mapping (address => bool) public transferFromWhiteList;
97 
98     /* Array with all balances */
99     mapping(address => uint256) public balanceOf;
100 
101     /* Presale investors list */
102     mapping (address => uint256) public presaleInvestorsETH;
103     mapping (address => uint256) public presaleInvestors;
104 
105     /* Ico Investors list */
106     mapping (address => uint256) public icoInvestors;
107 
108     // Dividends variables
109     uint32 public dividendsRound; // round number of dividends    
110     uint256 public dividendsSum; // sum for dividends in current round (in wei)
111     uint256 public dividendsBuffer; // sum for dividends in current round (in wei)
112 
113     /* Paid dividends */
114     mapping(address => mapping(uint32 => uint256)) public paidDividends;
115 	
116 	/* Trusted accounts list */
117     mapping(address => mapping(address => uint256)) public allowance;
118         
119     /* Events of token */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121     event Burn(address indexed from, uint256 value);
122 
123 
124     /* Token constructor */
125     function STE(string _tokenName, string _tokenSymbol) public {
126         // Initial supply of token
127         // We set only 70m of supply because after ICO was finished, founders get additional 30% of token supply
128         totalSupply = 70000000 * 100000000;
129 
130         balanceOf[this] = totalSupply;
131 
132         // Initial sum of solded supply during preSale
133         soldedSupply = 1651900191227993;
134         presaleAmountETH = 15017274465709181875863;
135 
136         name = _tokenName;
137         symbol = _tokenSymbol;
138         decimals = 8;
139 
140         icoRaisedETH = 0;
141         
142         blocksPerHour = 260;
143 
144         // % of company cost transfer to founders after ICO * 100, 30% = 3000
145         percentToFoundersAfterICO = 3000;
146 
147         // % to presalers after ICO * 100, 10% = 1000
148         percentToPresalersFromICO = 1000;
149 
150         // GracePeriod and ICO finished flags
151         icoFinished = false;
152 
153         // Allow transfers token BEFORE ICO and PRESALE ends
154         allowTransfers = false;
155 
156         // INIT VALUES FOR ICO START
157         buyPrice = 20000000; // 0.002 ETH for 1 STE
158         gracePeriodStartBlock = 4615918;
159         gracePeriodStopBlock = gracePeriodStartBlock + blocksPerHour * 8; // + 8 hours
160         gracePeriodAmount = 0;
161         gracePeriodMaxTarget = 5000000 * 100000000; // 5,000,000 STE for grace period
162         gracePeriodMinTran = 100000000000000000; // 0.1 ETH
163         burnAfterSoldAmount = 30000000;
164         // -----------------------------------------
165     }
166 
167     /* Transfer coins */
168     function transfer(address _to, uint256 _value) public {
169         if (_to == 0x0) revert();
170         if (balanceOf[msg.sender] < _value) revert(); // Check if the sender has enough
171         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
172         // Cancel transfer transactions before ICO was finished
173         if ((!icoFinished) && (msg.sender != bountyAddr) && (!allowTransfers)) revert();
174         // Calc dividends for _from and for _to addresses
175         uint256 divAmount_from = 0;
176         uint256 divAmount_to = 0;
177         if ((dividendsRound != 0) && (dividendsBuffer > 0)) {
178             divAmount_from = calcDividendsSum(msg.sender);
179             if ((divAmount_from == 0) && (paidDividends[msg.sender][dividendsRound] == 0)) paidDividends[msg.sender][dividendsRound] = 1;
180             divAmount_to = calcDividendsSum(_to);
181             if ((divAmount_to == 0) && (paidDividends[_to][dividendsRound] == 0)) paidDividends[_to][dividendsRound] = 1;
182         }
183         // End of calc dividends
184 
185         balanceOf[msg.sender] -= _value; // Subtract from the sender
186         balanceOf[_to] += _value; // Add the same to the recipient
187 
188         if (divAmount_from > 0) {
189             if (!msg.sender.send(divAmount_from)) revert();
190         }
191         if (divAmount_to > 0) {
192             if (!_to.send(divAmount_to)) revert();
193         }
194 
195         /* Notify anyone listening that this transfer took place */
196         Transfer(msg.sender, _to, _value);
197     }
198 
199     /* Allow another contract to spend some tokens */
200     function approve(address _spender, uint256 _value) public returns(bool success) {
201         allowance[msg.sender][_spender] = _value;
202         return true;
203     }
204 
205     /* Approve and then communicate the approved contract in a single tx */
206     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
207         tokenRecipient spender = tokenRecipient(_spender);
208         if (approve(_spender, _value)) {
209             spender.receiveApproval(msg.sender, _value, this, _extraData);
210             return true;
211         }
212     }
213 
214     function calcDividendsSum(address _for) private returns(uint256 dividendsAmount) {
215         if (dividendsRound == 0) return 0;
216         if (dividendsBuffer == 0) return 0;
217         if (balanceOf[_for] == 0) return 0;
218         if (paidDividends[_for][dividendsRound] != 0) return 0;
219         uint256 divAmount = 0;
220         divAmount = (dividendsSum * ((balanceOf[_for] * 10000000000000000) / totalSupply)) / 10000000000000000;
221         // Do not calc dividends less or equal than 0.0001 ETH
222         if (divAmount < 100000000000000) {
223             paidDividends[_for][dividendsRound] = 1;
224             return 0;
225         }
226         if (divAmount > dividendsBuffer) {
227             divAmount = dividendsBuffer;
228             dividendsBuffer = 0;
229         } else dividendsBuffer -= divAmount;
230         paidDividends[_for][dividendsRound] += divAmount;
231         return divAmount;
232     }
233 
234     /* A contract attempts to get the coins */
235     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
236         if (_to == 0x0) revert();
237         if (balanceOf[_from] < _value) revert(); // Check if the sender has enough
238         if ((balanceOf[_to] + _value) < balanceOf[_to]) revert(); // Check for overflows        
239         if (_value > allowance[_from][msg.sender]) revert(); // Check allowance
240         // Cancel transfer transactions before Ico and gracePeriod was finished
241         if ((!icoFinished) && (_from != bountyAddr) && (!transferFromWhiteList[_from]) && (!allowTransfers)) revert();
242 
243         // Calc dividends for _from and for _to addresses
244         uint256 divAmount_from = 0;
245         uint256 divAmount_to = 0;
246         if ((dividendsRound != 0) && (dividendsBuffer > 0)) {
247             divAmount_from = calcDividendsSum(_from);
248             if ((divAmount_from == 0) && (paidDividends[_from][dividendsRound] == 0)) paidDividends[_from][dividendsRound] = 1;
249             divAmount_to = calcDividendsSum(_to);
250             if ((divAmount_to == 0) && (paidDividends[_to][dividendsRound] == 0)) paidDividends[_to][dividendsRound] = 1;
251         }
252         // End of calc dividends
253 
254         balanceOf[_from] -= _value; // Subtract from the sender
255         balanceOf[_to] += _value; // Add the same to the recipient
256         allowance[_from][msg.sender] -= _value;
257 
258         if (divAmount_from > 0) {
259             if (!_from.send(divAmount_from)) revert();
260         }
261         if (divAmount_to > 0) {
262             if (!_to.send(divAmount_to)) revert();
263         }
264 
265         Transfer(_from, _to, _value);
266         return true;
267     }
268     
269     /* Admin function for transfer coins */
270     function transferFromAdmin(address _from, address _to, uint256 _value) public onlyOwner returns(bool success) {
271         if (_to == 0x0) revert();
272         if (balanceOf[_from] < _value) revert(); // Check if the sender has enough
273         if ((balanceOf[_to] + _value) < balanceOf[_to]) revert(); // Check for overflows        
274 
275         // Calc dividends for _from and for _to addresses
276         uint256 divAmount_from = 0;
277         uint256 divAmount_to = 0;
278         if ((dividendsRound != 0) && (dividendsBuffer > 0)) {
279             divAmount_from = calcDividendsSum(_from);
280             if ((divAmount_from == 0) && (paidDividends[_from][dividendsRound] == 0)) paidDividends[_from][dividendsRound] = 1;
281             divAmount_to = calcDividendsSum(_to);
282             if ((divAmount_to == 0) && (paidDividends[_to][dividendsRound] == 0)) paidDividends[_to][dividendsRound] = 1;
283         }
284         // End of calc dividends
285 
286         balanceOf[_from] -= _value; // Subtract from the sender
287         balanceOf[_to] += _value; // Add the same to the recipient
288 
289         if (divAmount_from > 0) {
290             if (!_from.send(divAmount_from)) revert();
291         }
292         if (divAmount_to > 0) {
293             if (!_to.send(divAmount_to)) revert();
294         }
295 
296         Transfer(_from, _to, _value);
297         return true;
298     }
299     
300     // This function is called when anyone send ETHs to this token
301     function buy() public payable {
302         if (isOwner()) {
303 
304         } else {
305             uint256 amount = 0;
306             amount = msg.value / buyPrice; // calculates the amount of STE
307 
308             uint256 amountToPresaleInvestor = 0;
309 
310             // GracePeriod if current timestamp between gracePeriodStartBlock and gracePeriodStopBlock
311             if ( (block.number >= gracePeriodStartBlock) && (block.number <= gracePeriodStopBlock) ) {
312                 if ( (msg.value < gracePeriodMinTran) || (gracePeriodAmount > gracePeriodMaxTarget) ) revert();
313                 gracePeriodAmount += amount;
314                 icoRaisedETH += msg.value;
315                 icoInvestors[msg.sender] += amount;
316                 balanceOf[this] -= amount * 10 / 100;
317                 balanceOf[bountyAddr] += amount * 10 / 100;
318                 soldedSupply += amount + amount * 10 / 100;
319 
320             // Payment to presellers when ICO was finished
321 	        } else if ((icoFinished) && (presaleInvestorsETH[msg.sender] > 0) && (weiToPresalersFromICO > 0)) {
322                 amountToPresaleInvestor = msg.value + (presaleInvestorsETH[msg.sender] * 100000000 / presaleAmountETH) * icoRaisedETH * percentToPresalersFromICO / (100000000 * 10000);
323                 if (amountToPresaleInvestor > weiToPresalersFromICO) {
324                     amountToPresaleInvestor = weiToPresalersFromICO;
325                     weiToPresalersFromICO = 0;
326                 } else {
327                     weiToPresalersFromICO -= amountToPresaleInvestor;
328                 }
329             }
330 
331 			if (buyPrice > 0) {
332 				if (balanceOf[this] < amount) revert();				// checks if it has enough to sell
333 				balanceOf[this] -= amount;							// subtracts amount from token balance    		    
334 				balanceOf[msg.sender] += amount;					// adds the amount to buyer's balance    		    
335 			} else if ( amountToPresaleInvestor == 0 ) revert();	// Revert if buyPrice = 0 and b
336 			
337 			if (amountToPresaleInvestor > 0) {
338 				presaleInvestorsETH[msg.sender] = 0;
339 				if ( !msg.sender.send(amountToPresaleInvestor) ) revert(); // Send amountToPresaleInvestor to presaleer after Ico
340 			}
341 			Transfer(this, msg.sender, amount);					// execute an event reflecting the change
342         }
343     }
344 
345     function sell(uint256 amount) public {
346         if (sellPrice == 0) revert();
347         if (balanceOf[msg.sender] < amount) revert();	// checks if the sender has enough to sell
348         uint256 ethAmount = amount * sellPrice;			// amount of ETH for sell
349         balanceOf[msg.sender] -= amount;				// subtracts the amount from seller's balance
350         balanceOf[this] += amount;						// adds the amount to token balance
351         if (!msg.sender.send(ethAmount)) revert();		// sends ether to the seller.
352         Transfer(msg.sender, this, amount);
353     }
354 
355 
356     /* 
357     	Set params of ICO
358     	
359     	_auctionsStartBlock, _auctionsStopBlock - block number of start and stop of Ico
360     	_auctionsMinTran - minimum transaction amount for Ico in wei
361     */
362     function setICOParams(uint256 _gracePeriodPrice, uint32 _gracePeriodStartBlock, uint32 _gracePeriodStopBlock, uint256 _gracePeriodMaxTarget, uint256 _gracePeriodMinTran, bool _resetAmount) public onlyOwner {
363     	gracePeriodStartBlock = _gracePeriodStartBlock;
364         gracePeriodStopBlock = _gracePeriodStopBlock;
365         gracePeriodMaxTarget = _gracePeriodMaxTarget;
366         gracePeriodMinTran = _gracePeriodMinTran;
367         
368         buyPrice = _gracePeriodPrice;    	
369     	
370         icoFinished = false;        
371 
372         if (_resetAmount) icoRaisedETH = 0;
373     }
374 
375     // Initiate dividends round ( owner can transfer ETH to contract and initiate dividends round )
376     // aDividendsRound - is integer value of dividends period such as YYYYMM example 201712 (year 2017, month 12)
377     function setDividends(uint32 _dividendsRound) public payable onlyOwner {
378         if (_dividendsRound > 0) {
379             if (msg.value < 1000000000000000) revert();
380             dividendsSum = msg.value;
381             dividendsBuffer = msg.value;
382         } else {
383             dividendsSum = 0;
384             dividendsBuffer = 0;
385         }
386         dividendsRound = _dividendsRound;
387     }
388 
389     // Get dividends
390     function getDividends() public {
391         if (dividendsBuffer == 0) revert();
392         if (balanceOf[msg.sender] == 0) revert();
393         if (paidDividends[msg.sender][dividendsRound] != 0) revert();
394         uint256 divAmount = calcDividendsSum(msg.sender);
395         if (divAmount >= 100000000000000) {
396             if (!msg.sender.send(divAmount)) revert();
397         }
398     }
399 
400     // Set sell and buy prices for token
401     function setPrices(uint256 _buyPrice, uint256 _sellPrice) public onlyOwner {
402         buyPrice = _buyPrice;
403         sellPrice = _sellPrice;
404     }
405 
406 
407     // Set sell and buy prices for token
408     function setAllowTransfers(bool _allowTransfers) public onlyOwner {
409         allowTransfers = _allowTransfers;
410     }
411 
412     // Stop gracePeriod
413     function stopGracePeriod() public onlyOwner {
414         gracePeriodStopBlock = block.number;
415         buyPrice = 0;
416         sellPrice = 0;
417     }
418 
419     // Stop ICO
420     function stopICO() public onlyOwner {
421         if ( gracePeriodStopBlock > block.number ) gracePeriodStopBlock = block.number;
422         
423         icoFinished = true;
424 
425         weiToPresalersFromICO = icoRaisedETH * percentToPresalersFromICO / 10000;
426 
427         if (soldedSupply >= (burnAfterSoldAmount * 100000000)) {
428 
429             uint256 companyCost = soldedSupply * 1000000 * 10000;
430             companyCost = companyCost / (10000 - percentToFoundersAfterICO) / 1000000;
431             
432             uint256 amountToFounders = companyCost - soldedSupply;
433 
434             // Burn extra coins if current balance of token greater than amountToFounders 
435             if (balanceOf[this] > amountToFounders) {
436                 Burn(this, (balanceOf[this]-amountToFounders));
437                 balanceOf[this] = 0;
438                 totalSupply = companyCost;
439             } else {
440                 totalSupply += amountToFounders - balanceOf[this];
441             }
442 
443             balanceOf[owner] += amountToFounders;
444             balanceOf[this] = 0;
445             Transfer(this, owner, amountToFounders);
446         }
447 
448         buyPrice = 0;
449         sellPrice = 0;
450     }
451     
452     
453     // Withdraw ETH to founders 
454     function withdrawToFounders(uint256 amount) public onlyOwner {
455     	uint256 amount_to_withdraw = amount * 1000000000000000; // 0.001 ETH
456         if ((this.balance - weiToPresalersFromICO) < amount_to_withdraw) revert();
457         amount_to_withdraw = amount_to_withdraw / foundersAddresses.length;
458         uint8 i = 0;
459         uint8 errors = 0;
460         
461         for (i = 0; i < foundersAddresses.length; i++) {
462 			if (!foundersAddresses[i].send(amount_to_withdraw)) {
463 				errors++;
464 			}
465 		}
466     }
467     
468     function setBlockPerHour(uint256 _blocksPerHour) public onlyOwner {
469     	blocksPerHour = _blocksPerHour;
470     }
471     
472     function setBurnAfterSoldAmount(uint256 _burnAfterSoldAmount)  public onlyOwner {
473     	burnAfterSoldAmount = _burnAfterSoldAmount;
474     }
475     
476     function setTransferFromWhiteList(address _from, bool _allow) public onlyOwner {
477     	transferFromWhiteList[_from] = _allow;
478     }
479     
480     function addPresaleInvestor(address _addr, uint256 _amountETH, uint256 _amountSTE ) public onlyOwner {    	
481 	    presaleInvestors[_addr] += _amountSTE;
482 	    balanceOf[this] -= _amountSTE;
483 		balanceOf[_addr] += _amountSTE;
484 	    
485 	    if ( _amountETH > 0 ) {
486 	    	presaleInvestorsETH[_addr] += _amountETH;
487 			balanceOf[this] -= _amountSTE / 10;
488 			balanceOf[bountyAddr] += _amountSTE / 10;
489 			//presaleAmountETH += _amountETH;
490 		}
491 		
492 	    Transfer(this, _addr, _amountSTE);
493     }
494     
495     /**/    
496         
497     // BURN coins in HELL! (sender balance)
498     function burn(uint256 amount) public {
499         if (balanceOf[msg.sender] < amount) revert(); // Check if the sender has enough
500         balanceOf[msg.sender] -= amount; // Subtract from the sender
501         totalSupply -= amount; // Updates totalSupply
502         Burn(msg.sender, amount);
503     }
504 
505     // BURN coins of token in HELL!
506     function burnContractCoins(uint256 amount) public onlySuperOwner {
507         if (balanceOf[this] < amount) revert(); // Check if the sender has enough
508         balanceOf[this] -= amount; // Subtract from the contract balance
509         totalSupply -= amount; // Updates totalSupply
510         Burn(this, amount);
511     }
512 
513     /* This unnamed function is called whenever someone tries to send ether to it */
514     function() internal payable {
515         buy();
516     }
517 }