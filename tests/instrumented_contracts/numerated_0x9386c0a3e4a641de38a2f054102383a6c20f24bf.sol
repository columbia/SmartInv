1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4 
5     address public owner;
6 
7     /**
8      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9      * account.
10      */
11     function Ownable() {
12         owner = msg.sender;
13     }
14 
15 
16     /**
17      * @dev Throws if called by any account other than the owner.
18      */
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24 
25     /**
26      * @dev Allows the current owner to transfer control of the contract to a newOwner.
27      * @param newOwner The address to transfer ownership to.
28      */
29     address newOwner;
30     function transferOwnership(address _newOwner) onlyOwner {
31         if (_newOwner != address(0)) {
32             newOwner = _newOwner;
33         }
34     }
35 
36     function acceptOwnership() {
37         if (msg.sender == newOwner) {
38             owner = newOwner;
39         }
40     }
41 }
42 
43 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
44 
45 contract ERC20 is Ownable {
46     /* Public variables of the token */
47     string public standard;
48 
49     string public name;
50 
51     string public symbol;
52 
53     uint8 public decimals;
54 
55     uint256 public initialSupply;
56 
57     bool public locked;
58 
59     uint256 public creationBlock;
60 
61     mapping (address => uint256) public balances;
62 
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     /* This generates a public event on the blockchain that will notify clients */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     modifier onlyPayloadSize(uint numwords) {
69         assert(msg.data.length == numwords * 32 + 4);
70         _;
71     }
72 
73     /* Initializes contract with initial supply tokens to the creator of the contract */
74     function ERC20(
75     uint256 _initialSupply,
76     string tokenName,
77     uint8 decimalUnits,
78     string tokenSymbol,
79     bool transferAllSupplyToOwner,
80     bool _locked
81     ) {
82         standard = 'ERC20 0.1';
83 
84         initialSupply = _initialSupply;
85 
86         if (transferAllSupplyToOwner) {
87             setBalance(msg.sender, initialSupply);
88         }
89         else {
90             setBalance(this, initialSupply);
91         }
92 
93         name = tokenName;
94         // Set the name for display purposes
95         symbol = tokenSymbol;
96         // Set the symbol for display purposes
97         decimals = decimalUnits;
98         // Amount of decimals for display purposes
99         locked = _locked;
100         creationBlock = block.number;
101     }
102 
103     /* internal balances */
104 
105     function setBalance(address holder, uint256 amount) internal {
106         balances[holder] = amount;
107     }
108 
109     function transferInternal(address _from, address _to, uint256 value) internal returns (bool success) {
110         if (value == 0) {
111             return true;
112         }
113 
114         if (balances[_from] < value) {
115             return false;
116         }
117 
118         if (balances[_to] + value <= balances[_to]) {
119             return false;
120         }
121 
122         setBalance(_from, balances[_from] - value);
123         setBalance(_to, balances[_to] + value);
124 
125         Transfer(_from, _to, value);
126 
127         return true;
128     }
129 
130     /* public methods */
131     function totalSupply() returns (uint256) {
132         return initialSupply;
133     }
134 
135     function balanceOf(address _address) returns (uint256) {
136         return balances[_address];
137     }
138 
139     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool) {
140         require(locked == false);
141 
142         bool status = transferInternal(msg.sender, _to, _value);
143 
144         require(status == true);
145 
146         return true;
147     }
148 
149     function approve(address _spender, uint256 _value) returns (bool success) {
150         if(locked) {
151             return false;
152         }
153 
154         allowance[msg.sender][_spender] = _value;
155 
156         return true;
157     }
158 
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
160         if (locked) {
161             return false;
162         }
163 
164         tokenRecipient spender = tokenRecipient(_spender);
165 
166         if (approve(_spender, _value)) {
167             spender.receiveApproval(msg.sender, _value, this, _extraData);
168             return true;
169         }
170     }
171 
172     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
173         if (locked) {
174             return false;
175         }
176 
177         if (allowance[_from][msg.sender] < _value) {
178             return false;
179         }
180 
181         bool _success = transferInternal(_from, _to, _value);
182 
183         if (_success) {
184             allowance[_from][msg.sender] -= _value;
185         }
186 
187         return _success;
188     }
189 
190 }
191 
192 contract MintingERC20 is ERC20 {
193 
194     mapping (address => bool) public minters;
195 
196     uint256 public maxSupply;
197 
198     function MintingERC20(
199     uint256 _initialSupply,
200     uint256 _maxSupply,
201     string _tokenName,
202     uint8 _decimals,
203     string _symbol,
204     bool _transferAllSupplyToOwner,
205     bool _locked
206     )
207     ERC20(_initialSupply, _tokenName, _decimals, _symbol, _transferAllSupplyToOwner, _locked)
208 
209     {
210         standard = "MintingERC20 0.1";
211         minters[msg.sender] = true;
212         maxSupply = _maxSupply;
213     }
214 
215 
216     function addMinter(address _newMinter) onlyOwner {
217         minters[_newMinter] = true;
218     }
219 
220 
221     function removeMinter(address _minter) onlyOwner {
222         minters[_minter] = false;
223     }
224 
225 
226     function mint(address _addr, uint256 _amount) onlyMinters returns (uint256) {
227         if (locked == true) {
228             return uint256(0);
229         }
230 
231         if (_amount == uint256(0)) {
232             return uint256(0);
233         }
234         if (initialSupply + _amount <= initialSupply){
235             return uint256(0);
236         }
237         if (initialSupply + _amount > maxSupply) {
238             return uint256(0);
239         }
240 
241         initialSupply += _amount;
242         balances[_addr] += _amount;
243         Transfer(this, _addr, _amount);
244         return _amount;
245     }
246 
247 
248     modifier onlyMinters () {
249         require(true == minters[msg.sender]);
250         _;
251     }
252 }
253 
254 contract Lamden is MintingERC20 {
255 
256 
257     uint8 public decimals = 18;
258 
259     string public tokenName = "Lamden Tau";
260 
261     string public tokenSymbol = "TAU";
262 
263     uint256 public  maxSupply = 500 * 10 ** 6 * uint(10) ** decimals; // 500,000,000
264 
265     // We block token transfers till ICO end.
266     bool public transferFrozen = true;
267 
268     function Lamden(
269     uint256 initialSupply,
270     bool _locked
271     ) MintingERC20(initialSupply, maxSupply, tokenName, decimals, tokenSymbol, false, _locked) {
272         standard = 'Lamden 0.1';
273     }
274 
275     function setLocked(bool _locked) onlyOwner {
276         locked = _locked;
277     }
278 
279     // Allow token transfer.
280     function freezing(bool _transferFrozen) onlyOwner {
281         transferFrozen = _transferFrozen;
282     }
283 
284     // ERC20 functions
285     // =========================
286 
287     function transfer(address _to, uint _value) returns (bool) {
288         require(!transferFrozen);
289         return super.transfer(_to, _value);
290 
291     }
292 
293     // should  not have approve/transferFrom
294     function approve(address, uint) returns (bool success)  {
295         require(false);
296         return false;
297         //        super.approve(_spender, _value);
298     }
299 
300     function approveAndCall(address, uint256, bytes) returns (bool success) {
301         require(false);
302         return false;
303     }
304 
305     function transferFrom(address, address, uint)  returns (bool success) {
306         require(false);
307         return false;
308         //        super.transferFrom(_from, _to, _value);
309     }
310 }
311 
312 contract LamdenTokenAllocation is Ownable {
313 
314     Lamden public tau;
315 
316     uint256 public constant LAMDEN_DECIMALS = 10 ** 18;
317 
318     uint256 allocatedTokens = 0;
319 
320     Allocation[] allocations;
321 
322     struct Allocation {
323     address _address;
324     uint256 amount;
325     }
326 
327 
328     function LamdenTokenAllocation(
329     address _tau,
330     address[] addresses
331     ){
332         require(uint8(addresses.length) == uint8(14));
333         allocations.push(Allocation(addresses[0], 20000000 * LAMDEN_DECIMALS)); //Stu
334         allocations.push(Allocation(addresses[1], 12500000 * LAMDEN_DECIMALS)); //Nick
335         allocations.push(Allocation(addresses[2], 8750000 * LAMDEN_DECIMALS)); //James
336         allocations.push(Allocation(addresses[3], 8750000 * LAMDEN_DECIMALS)); //Mario
337         allocations.push(Allocation(addresses[4], 250000 * LAMDEN_DECIMALS));     // Advisor
338         allocations.push(Allocation(addresses[5], 250000 * LAMDEN_DECIMALS));  // Advisor
339         allocations.push(Allocation(addresses[6], 250000 * LAMDEN_DECIMALS));  // Advisor
340         allocations.push(Allocation(addresses[7], 250000 * LAMDEN_DECIMALS));  // Advisor
341         allocations.push(Allocation(addresses[8], 250000 * LAMDEN_DECIMALS));  // Advisor
342         allocations.push(Allocation(addresses[9], 250000 * LAMDEN_DECIMALS));  // Advisor
343         allocations.push(Allocation(addresses[10], 250000 * LAMDEN_DECIMALS));  // Advisor
344         allocations.push(Allocation(addresses[11], 250000 * LAMDEN_DECIMALS));  // Advisor
345         allocations.push(Allocation(addresses[12], 48000000 * LAMDEN_DECIMALS));  // enterpriseCaseStudies
346         allocations.push(Allocation(addresses[13], 50000000  * LAMDEN_DECIMALS));  // AKA INNOVATION FUND
347         tau = Lamden(_tau);
348     }
349 
350     function allocateTokens(){
351         require(uint8(allocations.length) == uint8(14));
352         require(address(tau) != 0x0);
353         require(allocatedTokens == 0);
354         for (uint8 i = 0; i < allocations.length; i++) {
355             Allocation storage allocation = allocations[i];
356             uint256 mintedAmount = tau.mint(allocation._address, allocation.amount);
357             require(mintedAmount == allocation.amount);
358             allocatedTokens += allocation.amount;
359         }
360     }
361 
362     function setTau(address _tau) onlyOwner {
363         tau = Lamden(_tau);
364     }
365 }
366 
367 
368 contract LamdenPhases is Ownable {
369 
370     uint256 public constant LAMDEN_DECIMALS = 10 ** 18;
371 
372     uint256 public soldTokens;
373 
374     uint256 public collectedEthers;
375 
376     uint256 todayCollectedEthers;
377 
378     uint256 icoInitialThresholds;
379 
380     uint256 currentDay;
381 
382     Phase[] public phases;
383 
384     Lamden public tau;
385 
386     uint8 currentPhase;
387 
388     address etherHolder;
389 
390     address investor = 0x3669ad54675E94e14196528786645c858b8391F1;
391 
392     mapping(address => uint256) alreadyContributed;
393 
394     struct Phase {
395     uint256 price;
396     uint256 maxAmount;
397     uint256 since;
398     uint256 till;
399     uint256 soldTokens;
400     uint256 collectedEthers;
401     bool isFinished;
402     mapping (address => bool) whitelist;
403     }
404 
405     function LamdenPhases(
406     address _etherHolder,
407     address _tau,
408     uint256 _tokenPreIcoPrice,
409     uint256 _preIcoSince,
410     uint256 _preIcoTill,
411     uint256 preIcoMaxAmount, // 1,805,067.01326114 +   53,280,090
412     uint256 _tokenIcoPrice,
413     uint256 _icoSince,
414     uint256 _icoTill,
415     uint256 icoMaxAmount,
416     uint256 icoThresholds
417     )
418     {
419         phases.push(Phase(_tokenPreIcoPrice, preIcoMaxAmount, _preIcoSince, _preIcoTill, 0, 0, false));
420         phases.push(Phase(_tokenIcoPrice, icoMaxAmount, _icoSince, _icoTill, 0, 0, false));
421         etherHolder = _etherHolder;
422         icoInitialThresholds = icoThresholds;
423         tau = Lamden(_tau);
424     }
425 
426     // call add minter from TAU token after contract deploying
427     function sendTokensToInvestor() onlyOwner {
428         uint256 mintedAmount = mintInternal(investor, (1805067013261140000000000));
429         require(mintedAmount == uint256(1805067013261140000000000));
430     }
431 
432     function getIcoTokensAmount(uint256 value, uint256 time, address _address) returns (uint256) {
433         if (value == 0) {
434             return uint256(0);
435         }
436         uint256 amount = 0;
437 
438         for (uint8 i = 0; i < phases.length; i++) {
439             Phase storage phase = phases[i];
440 
441             if (phase.whitelist[_address] == false) {
442                 continue;
443             }
444 						
445             if(phase.isFinished){
446                 continue;
447             }
448 
449             if (phase.since > time) {
450                 continue;
451             }
452 
453             if (phase.till < time) {
454                 continue;
455             }
456             currentPhase = i;
457 
458             // should we be multiplying by 10 ** 18???
459             // 1 eth = 1000000000000000000 / 
460             uint256 phaseAmount = value * LAMDEN_DECIMALS / phase.price;
461             
462             amount += phaseAmount;
463 
464             if (phase.maxAmount < amount + soldTokens) {
465                 return uint256(0);
466             }
467             //            phase.soldTokens += amount;
468             phase.collectedEthers += value;
469         }
470         return amount;
471     }
472 
473     function() payable {
474         bool status = buy(msg.sender, msg.value);
475         require(status == true);
476     }
477 
478     function setInternalFinished(uint8 phaseId, bool _finished) internal returns (bool){
479         if (phases.length < phaseId) {
480             return false;
481         }
482 
483         Phase storage phase = phases[phaseId];
484 
485         if (phase.isFinished == true) {
486             return true;
487         }
488 
489         phase.isFinished = _finished;
490 
491         return true;
492     }
493 
494     function setFinished(uint8 phaseId, bool _finished) onlyOwner returns (bool){
495         return setInternalFinished(phaseId, _finished);
496     }
497 
498     function buy(address _address, uint256 _value) internal returns (bool) {
499         if (_value == 0) {
500             return false;
501         }
502 
503         if (phases.length < currentPhase) {
504             return false;
505         }
506         Phase storage icoPhase = phases[1];
507 
508         if (icoPhase.since <= now) {
509 
510             currentPhase = 1;
511             uint256 daysInterval = (now - icoPhase.since) / uint256(86400);
512             uint256 todayMaxEthers = icoInitialThresholds;
513 
514             if (daysInterval != currentDay) {
515                 currentDay = daysInterval;
516                 todayCollectedEthers = 0;
517             }
518 
519             todayMaxEthers = icoInitialThresholds * (2 ** daysInterval);
520 
521             if(alreadyContributed[_address] + _value > todayMaxEthers) {
522                 return false;
523             }
524 
525             alreadyContributed[_address] += _value;
526         }
527 
528         uint256 tokenAmount = getIcoTokensAmount(_value, now, _address);
529 
530         if (tokenAmount == 0) {
531             return false;
532         }
533 
534         uint256 mintedAmount = mintInternal(_address, tokenAmount);
535         require(mintedAmount == tokenAmount);
536 
537         collectedEthers += _value;
538 
539         Phase storage phase = phases[currentPhase];
540         if (soldTokens == phase.maxAmount) {
541             setInternalFinished(currentPhase, true);
542         }
543         return true;
544     }
545 
546     function setTau(address _tau) onlyOwner {
547         tau = Lamden(_tau);
548     }
549 
550     function setPhase(uint8 phaseId, uint256 since, uint256 till, uint256 price) onlyOwner returns (bool) {
551         if (phases.length <= phaseId) {
552             return false;
553         }
554 
555         if (price == 0) {
556             return false;
557         }
558         Phase storage phase = phases[phaseId];
559 
560         if (phase.isFinished == true) {
561             return false;
562         }
563         phase.since = since;
564         phase.till = till;
565 
566         phase.price = price;
567 
568         return true;
569     }
570 
571     function transferEthers() onlyOwner {
572         require(etherHolder != 0x0);
573         etherHolder.transfer(this.balance);
574     }
575 
576     function addToWhitelist(uint8 phaseId, address _address) onlyOwner {
577 
578         require(phases.length > phaseId);
579 
580         Phase storage phase = phases[phaseId];
581 
582         phase.whitelist[_address] = true;
583 
584     }
585 
586     function removeFromWhitelist(uint8 phaseId, address _address) onlyOwner {
587 
588         require(phases.length > phaseId);
589 
590         Phase storage phase = phases[phaseId];
591 
592         phase.whitelist[_address] = false;
593 
594     }
595 
596     function mint(address _address, uint256 tokenAmount) onlyOwner returns (uint256) {
597         return mintInternal(_address, tokenAmount);
598     }
599 
600     function mintInternal(address _address, uint256 tokenAmount) internal returns (uint256) {
601         require(address(tau) != 0x0);
602         uint256 mintedAmount = tau.mint(_address, tokenAmount);
603         require(mintedAmount == tokenAmount);
604 
605         require(phases.length > currentPhase);
606         Phase storage phase = phases[currentPhase];
607         phase.soldTokens += tokenAmount;
608         soldTokens += tokenAmount;
609         return tokenAmount;
610     }
611 
612     function getPhase(uint8 phaseId) returns (uint256, uint256, uint256, uint256, uint256, uint256, bool)
613     {
614 
615         require(phases.length > phaseId);
616 
617         Phase storage phase = phases[phaseId];
618 
619         return (phase.price, phase.maxAmount, phase.since, phase.till, phase.soldTokens, phase.collectedEthers, phase.isFinished);
620 
621     }
622 
623 }