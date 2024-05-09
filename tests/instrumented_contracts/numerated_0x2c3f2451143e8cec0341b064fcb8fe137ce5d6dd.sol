1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Maths
5  * A library to make working with numbers in Solidity hurt your brain less.
6  */
7 library Maths {
8   /**
9    * @dev Adds two addends together, returns the sum
10    * @param addendA the first addend
11    * @param addendB the second addend
12    * @return sum the sum of the equation (e.g. addendA + addendB)
13    */
14   function plus(
15     uint256 addendA,
16     uint256 addendB
17   ) public pure returns (uint256 sum) {
18     sum = addendA + addendB;
19   }
20 
21   /**
22    * @dev Subtracts the minuend from the subtrahend, returns the difference
23    * @param minuend the minuend
24    * @param subtrahend the subtrahend
25    * @return difference the difference (e.g. minuend - subtrahend)
26    */
27   function minus(
28     uint256 minuend,
29     uint256 subtrahend
30   ) public pure returns (uint256 difference) {
31     assert(minuend >= subtrahend);
32     difference = minuend - subtrahend;
33   }
34 
35   /**
36    * @dev Multiplies two factors, returns the product
37    * @param factorA the first factor
38    * @param factorB the second factor
39    * @return product the product of the equation (e.g. factorA * factorB)
40    */
41   function mul(
42     uint256 factorA,
43     uint256 factorB
44   ) public pure returns (uint256 product) {
45     if (factorA == 0 || factorB == 0) return 0;
46     product = factorA * factorB;
47     assert(product / factorA == factorB);
48   }
49 
50   /**
51    * @dev Multiplies two factors, returns the product
52    * @param factorA the first factor
53    * @param factorB the second factor
54    * @return product the product of the equation (e.g. factorA * factorB)
55    */
56   function times(
57     uint256 factorA,
58     uint256 factorB
59   ) public pure returns (uint256 product) {
60     return mul(factorA, factorB);
61   }
62 
63   /**
64    * @dev Divides the dividend by divisor, returns the truncated quotient
65    * @param dividend the dividend
66    * @param divisor the divisor
67    * @return quotient the quotient of the equation (e.g. dividend / divisor)
68    */
69   function div(
70     uint256 dividend,
71     uint256 divisor
72   ) public pure returns (uint256 quotient) {
73     quotient = dividend / divisor;
74     assert(quotient * divisor == dividend);
75   }
76 
77   /**
78    * @dev Divides the dividend by divisor, returns the truncated quotient
79    * @param dividend the dividend
80    * @param divisor the divisor
81    * @return quotient the quotient of the equation (e.g. dividend / divisor)
82    */
83   function dividedBy(
84     uint256 dividend,
85     uint256 divisor
86   ) public pure returns (uint256 quotient) {
87     return div(dividend, divisor);
88   }
89 
90   /**
91    * @dev Divides the dividend by divisor, returns the quotient and remainder
92    * @param dividend the dividend
93    * @param divisor the divisor
94    * @return quotient the quotient of the equation (e.g. dividend / divisor)
95    * @return remainder the remainder of the equation (e.g. dividend % divisor)
96    */
97   function divideSafely(
98     uint256 dividend,
99     uint256 divisor
100   ) public pure returns (uint256 quotient, uint256 remainder) {
101     quotient = div(dividend, divisor);
102     remainder = dividend % divisor;
103   }
104 
105   /**
106    * @dev Returns the lesser of two values.
107    * @param a the first value
108    * @param b the second value
109    * @return result the lesser of the two values
110    */
111   function min(
112     uint256 a,
113     uint256 b
114   ) public pure returns (uint256 result) {
115     result = a <= b ? a : b;
116   }
117 
118   /**
119    * @dev Returns the greater of two values.
120    * @param a the first value
121    * @param b the second value
122    * @return result the greater of the two values
123    */
124   function max(
125     uint256 a,
126     uint256 b
127   ) public pure returns (uint256 result) {
128     result = a >= b ? a : b;
129   }
130 
131   /**
132    * @dev Determines whether a value is less than another.
133    * @param a the first value
134    * @param b the second value
135    * @return isTrue whether a is less than b
136    */
137   function isLessThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
138     isTrue = a < b;
139   }
140 
141   /**
142    * @dev Determines whether a value is equal to or less than another.
143    * @param a the first value
144    * @param b the second value
145    * @return isTrue whether a is less than or equal to b
146    */
147   function isAtMost(uint256 a, uint256 b) public pure returns (bool isTrue) {
148     isTrue = a <= b;
149   }
150 
151   /**
152    * @dev Determines whether a value is greater than another.
153    * @param a the first value
154    * @param b the second value
155    * @return isTrue whether a is greater than b
156    */
157   function isGreaterThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
158     isTrue = a > b;
159   }
160 
161   /**
162    * @dev Determines whether a value is equal to or greater than another.
163    * @param a the first value
164    * @param b the second value
165    * @return isTrue whether a is less than b
166    */
167   function isAtLeast(uint256 a, uint256 b) public pure returns (bool isTrue) {
168     isTrue = a >= b;
169   }
170 }
171 
172 /**
173  * @title Manageable
174  */
175 contract Manageable {
176   address public owner;
177   address public manager;
178 
179   event OwnershipChanged(address indexed previousOwner, address indexed newOwner);
180   event ManagementChanged(address indexed previousManager, address indexed newManager);
181 
182   /**
183    * @dev The Manageable constructor sets the original `owner` of the contract to the sender
184    * account.
185    */
186   function Manageable() public {
187     owner = msg.sender;
188     manager = msg.sender;
189   }
190 
191   /**
192    * @dev Throws if called by any account other than the owner or manager.
193    */
194   modifier onlyManagement() {
195     require(msg.sender == owner || msg.sender == manager);
196     _;
197   }
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) public onlyOwner {
212     require(newOwner != address(0));
213     OwnershipChanged(owner, newOwner);
214     owner = newOwner;
215   }
216 
217   /**
218    * @dev Allows the owner or manager to replace the current manager
219    * @param newManager The address to give contract management rights.
220    */
221   function replaceManager(address newManager) public onlyManagement {
222     require(newManager != address(0));
223     ManagementChanged(manager, newManager);
224     manager = newManager;
225   }
226 }
227 
228 contract ERC20 {
229   function allowance(address owner, address spender) public view returns (uint256);
230   function approve(address spender, uint256 value) public returns (bool);
231   function balanceOf(address who) public view returns (uint256);
232   function transfer(address to, uint256 value) public returns (bool);
233   function transferFrom(address from, address to, uint256 value) public returns (bool);
234   function totalSupply() public view returns (uint256);
235 }
236 
237 contract MythereumERC20Token is ERC20 {
238   function burn(address burner, uint256 amount) public returns (bool);
239   function mint(address to, uint256 amount) public returns (bool);
240 }
241 
242 contract MythereumCardToken {
243   function balanceOf(address _owner) public view returns (uint256 _balance);
244   function ownerOf(uint256 _tokenId) public view returns (address _owner);
245   function exists(uint256 _tokenId) public view returns (bool _exists);
246 
247   function approve(address _to, uint256 _tokenId) public;
248   function getApproved(uint256 _tokenId) public view returns (address _operator);
249 
250   function setApprovalForAll(address _operator, bool _approved) public;
251   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
252 
253   function transferFrom(address _from, address _to, uint256 _tokenId) public;
254   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
255   function safeTransferFrom(
256     address _from,
257     address _to,
258     uint256 _tokenId,
259     bytes _data
260   ) public;
261 
262   function isEditionAvailable(uint8 _editionNumber) public view returns (bool);
263   function cloneCard(address _owner, uint256 _tokenId) public returns (bool);
264   function mintRandomCards(
265     address _owner,
266     uint8 _editionNumber,
267     uint8 _numCards
268   ) public returns (bool);
269   function improveCard(
270     uint256 _tokenId,
271     uint256 _addedDamage,
272     uint256 _addedShield
273   ) public returns (bool);
274   function destroyCard(uint256 _tokenId) public returns (bool);
275 }
276 
277 contract Mythereum is Manageable {
278   using Maths for uint256;
279 
280   struct Edition {
281     string  name;
282     uint256 sales;
283     uint256 maxSales;
284     uint8   packSize;
285     uint256 packPrice;
286     uint256 packPriceIncrease;
287   }
288 
289   mapping (uint8 => Edition) public editions;
290   mapping (address => bool) public isVIP;
291   mapping (address => bool) public isTokenAccepted;
292   mapping (address => uint256) public tokenCostPerPack;
293 
294   mapping (uint256 => uint256) public mythexCostPerUpgradeLevel;
295   mapping (uint256 => uint256) public cardDamageUpgradeLevel;
296   mapping (uint256 => uint256) public cardShieldUpgradeLevel;
297   uint256 public maxCardUpgradeLevel = 30;
298 
299   address public cardTokenAddress;
300   address public xpTokenAddress;
301   address public mythexTokenAddress;
302   address public gameHostAddress;
303 
304   /* data related to shared ownership */
305   uint256 public totalShares = 0;
306   uint256 public totalReleased = 0;
307   mapping(address => uint256) public shares;
308   mapping(address => uint256) public released;
309 
310   event CardsPurchased(uint256 editionNumber, uint256 packSize, address buyer);
311   event CardUpgraded(uint256 cardId, uint256 addedDamage, uint256 addedShield);
312 
313   modifier onlyHosts() {
314     require(
315       msg.sender == owner ||
316       msg.sender == manager ||
317       msg.sender == gameHostAddress
318     );
319     _;
320   }
321 
322   function Mythereum() public {
323     editions[0] = Edition({
324       name: "Genesis",
325       sales: 3999,
326       maxSales: 5000,
327       packSize: 7,
328       packPrice: 100 finney,
329       packPriceIncrease: 1 finney
330     });
331 
332     editions[1] = Edition({
333       name: "Survivor",
334       sales: 20,
335       maxSales: 1000000,
336       packSize: 10,
337       packPrice: 0,
338       packPriceIncrease: 0
339     });
340 
341     isVIP[msg.sender] = true;
342   }
343 
344   /**
345    * @dev Disallow funds being sent directly to the contract since we can't know
346    *  which edition they'd intended to purchase.
347    */
348   function () public payable {
349     revert();
350   }
351 
352   function buyPack(
353     uint8 _editionNumber
354   ) public payable {
355     uint256 packPrice = isVIP[msg.sender] ? 0 : editions[_editionNumber].packPrice;
356 
357     require(msg.value.isAtLeast(packPrice));
358     if (msg.value.isGreaterThan(packPrice)) {
359       msg.sender.transfer(msg.value.minus(packPrice));
360     }
361 
362     _deliverPack(msg.sender, _editionNumber);
363   }
364 
365   function buyPackWithERC20Tokens(
366     uint8   _editionNumber,
367     address _tokenAddress
368   ) public {
369     require(isTokenAccepted[_tokenAddress]);
370     _processERC20TokenPackPurchase(_editionNumber, _tokenAddress, msg.sender);
371   }
372 
373   function upgradeCardDamage(uint256 _cardId) public {
374     require(cardDamageUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
375     uint256 costOfUpgrade = 32 * (cardDamageUpgradeLevel[_cardId] + 1);
376 
377     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
378     require(mythexContract.balanceOf(msg.sender).isAtLeast(costOfUpgrade));
379     burnMythexTokens(msg.sender, costOfUpgrade);
380 
381     cardDamageUpgradeLevel[_cardId]++;
382     _improveCard(_cardId, 1, 0);
383   }
384 
385   function upgradeCardShield(uint256 _cardId) public {
386     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
387     uint256 costOfUpgrade = 32 * (cardShieldUpgradeLevel[_cardId] + 1);
388 
389     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
390     require(mythexContract.balanceOf(msg.sender).isAtLeast(costOfUpgrade));
391     burnMythexTokens(msg.sender, costOfUpgrade);
392 
393     cardShieldUpgradeLevel[_cardId]++;
394     _improveCard(_cardId, 0, 1);
395   }
396 
397   function improveCard(
398     uint256 _cardId,
399     uint256 _addedDamage,
400     uint256 _addedShield
401   ) public onlyManagement {
402     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
403     _improveCard(_cardId, _addedDamage, _addedShield);
404   }
405 
406   function _improveCard(
407     uint256 _cardId,
408     uint256 _addedDamage,
409     uint256 _addedShield
410   ) internal {
411     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
412     require(cardToken.improveCard(_cardId, _addedDamage, _addedShield));
413     CardUpgraded(_cardId, _addedDamage, _addedShield);
414   }
415 
416   function receiveApproval(
417     address _sender,
418     uint256 _value,
419     address _tokenContract,
420     bytes _extraData
421   ) public {
422     require(isTokenAccepted[_tokenContract]);
423 
424     uint8 editionNumber = 0;
425     if (_extraData.length != 0) editionNumber = uint8(_extraData[0]);
426 
427     _processERC20TokenPackPurchase(editionNumber, _tokenContract, _sender);
428   }
429 
430   function _processERC20TokenPackPurchase(
431     uint8   _editionNumber,
432     address _tokenAddress,
433     address _buyer
434   ) internal {
435     require(isTokenAccepted[_tokenAddress]);
436     ERC20 tokenContract = ERC20(_tokenAddress);
437     uint256 costPerPack = tokenCostPerPack[_tokenAddress];
438 
439     uint256 ourBalanceBefore = tokenContract.balanceOf(address(this));
440     tokenContract.transferFrom(_buyer, address(this), costPerPack);
441 
442     uint256 ourBalanceAfter = tokenContract.balanceOf(address(this));
443     require(ourBalanceAfter.isAtLeast(ourBalanceBefore.plus(costPerPack)));
444 
445     _deliverPack(_buyer, _editionNumber);
446   }
447 
448   function burnMythexTokens(address _burner, uint256 _amount) public onlyHosts {
449     require(_burner != address(0));
450     MythereumERC20Token(mythexTokenAddress).burn(_burner, _amount);
451   }
452 
453   function burnXPTokens(address _burner, uint256 _amount) public onlyHosts {
454     require(_burner != address(0));
455     MythereumERC20Token(xpTokenAddress).burn(_burner, _amount);
456   }
457 
458   function grantMythexTokens(address _recipient, uint256 _amount) public onlyHosts {
459     require(_recipient != address(0));
460     MythereumERC20Token(mythexTokenAddress).mint(_recipient, _amount);
461   }
462 
463   function grantXPTokens(address _recipient, uint256 _amount) public onlyHosts {
464     require(_recipient != address(0));
465     MythereumERC20Token(xpTokenAddress).mint(_recipient, _amount);
466   }
467 
468   function grantPromoPack(
469     address _recipient,
470     uint8 _editionNumber
471   ) public onlyManagement {
472     _deliverPack(_recipient, _editionNumber);
473   }
474 
475   function setTokenAcceptanceRate(
476     address _token,
477     uint256 _costPerPack
478   ) public onlyManagement {
479     if (_costPerPack > 0) {
480       isTokenAccepted[_token] = true;
481       tokenCostPerPack[_token] = _costPerPack;
482     } else {
483       isTokenAccepted[_token] = false;
484       tokenCostPerPack[_token] = 0;
485     }
486   }
487 
488   function transferERC20Tokens(
489     address _token,
490     address _recipient,
491     uint256 _amount
492   ) public onlyManagement {
493     require(ERC20(_token).transfer(_recipient, _amount));
494   }
495 
496   function addVIP(address _vip) public onlyManagement {
497     isVIP[_vip] = true;
498   }
499 
500   function removeVIP(address _vip) public onlyManagement {
501     isVIP[_vip] = false;
502   }
503 
504   function setEditionName(
505     uint8 _editionNumber,
506     string _name
507   ) public onlyManagement {
508     editions[_editionNumber].name = _name;
509   }
510 
511   function setEditionSales(
512     uint8 _editionNumber,
513     uint256 _numSales
514   ) public onlyManagement {
515     editions[_editionNumber].sales = _numSales;
516   }
517 
518   function setEditionMaxSales(
519     uint8 _editionNumber,
520     uint256 _maxSales
521   ) public onlyManagement {
522     editions[_editionNumber].maxSales = _maxSales;
523   }
524 
525   function setEditionPackPrice(
526     uint8 _editionNumber,
527     uint256 _newPrice
528   ) public onlyManagement {
529     editions[_editionNumber].packPrice = _newPrice;
530   }
531 
532   function setEditionPackPriceIncrease(
533     uint8 _editionNumber,
534     uint256 _increase
535   ) public onlyManagement {
536     editions[_editionNumber].packPriceIncrease = _increase;
537   }
538 
539   function setEditionPackSize(
540     uint8 _editionNumber,
541     uint8 _newSize
542   ) public onlyManagement {
543     editions[_editionNumber].packSize = _newSize;
544   }
545 
546   function setCardTokenAddress(address _addr) public onlyManagement {
547     require(_addr != address(0));
548     cardTokenAddress = _addr;
549   }
550 
551   function setXPTokenAddress(address _addr) public onlyManagement {
552     require(_addr != address(0));
553     xpTokenAddress = _addr;
554   }
555 
556   function setMythexTokenAddress(address _addr) public onlyManagement {
557     require(_addr != address(0));
558     mythexTokenAddress = _addr;
559   }
560 
561   function setGameHostAddress(address _addr) public onlyManagement {
562     require(_addr != address(0));
563     gameHostAddress = _addr;
564   }
565 
566   function claim() public {
567     _claim(msg.sender);
568   }
569 
570   function addShareholder(address _payee, uint256 _shares) public onlyOwner {
571     require(_payee != address(0));
572     require(_shares.isAtLeast(1));
573     require(shares[_payee] == 0);
574 
575     shares[_payee] = _shares;
576     totalShares = totalShares.plus(_shares);
577   }
578 
579   function removeShareholder(address _payee) public onlyOwner {
580     require(shares[_payee] != 0);
581     _claim(_payee);
582     _forfeitShares(_payee, shares[_payee]);
583   }
584 
585   function grantAdditionalShares(
586     address _payee,
587     uint256 _shares
588   ) public onlyOwner {
589     require(shares[_payee] != 0);
590     require(_shares.isAtLeast(1));
591 
592     shares[_payee] = shares[_payee].plus(_shares);
593     totalShares = totalShares.plus(_shares);
594   }
595 
596   function forfeitShares(uint256 _numShares) public {
597     _forfeitShares(msg.sender, _numShares);
598   }
599 
600   function transferShares(address _to, uint256 _numShares) public {
601     require(_numShares.isAtLeast(1));
602     require(shares[msg.sender].isAtLeast(_numShares));
603 
604     shares[msg.sender] = shares[msg.sender].minus(_numShares);
605     shares[_to] = shares[_to].plus(_numShares);
606   }
607 
608   function transferEntireStake(address _to) public {
609     transferShares(_to, shares[msg.sender]);
610   }
611 
612   function _claim(address payee) internal {
613     require(shares[payee].isAtLeast(1));
614 
615     uint256 totalReceived = address(this).balance.plus(totalReleased);
616     uint256 payment = totalReceived.times(shares[payee]).dividedBy(totalShares).minus(released[payee]);
617 
618     require(payment != 0);
619     require(address(this).balance.isAtLeast(payment));
620 
621     released[payee] = released[payee].plus(payment);
622     totalReleased = totalReleased.plus(payment);
623 
624     payee.transfer(payment);
625   }
626 
627   function _forfeitShares(address payee, uint256 numShares) internal {
628     require(shares[payee].isAtLeast(numShares));
629     shares[payee] = shares[payee].minus(numShares);
630     totalShares = totalShares.minus(numShares);
631   }
632 
633   function _deliverPack(address recipient, uint8 editionNumber) internal {
634     Edition storage edition = editions[editionNumber];
635     require(edition.sales.isLessThan(edition.maxSales.plus(edition.packSize)));
636 
637     edition.sales = edition.sales.plus(edition.packSize);
638     edition.packPrice = edition.packPrice.plus(edition.packPriceIncrease);
639 
640     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
641     cardToken.mintRandomCards(recipient, editionNumber, edition.packSize);
642 
643     CardsPurchased(editionNumber, edition.packSize, recipient);
644   }
645 }