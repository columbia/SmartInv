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
19     assert(sum - addendB == addendA);
20     return sum;
21   }
22 
23   /**
24    * @dev Subtracts the minuend from the subtrahend, returns the difference
25    * @param minuend the minuend
26    * @param subtrahend the subtrahend
27    * @return difference the difference (e.g. minuend - subtrahend)
28    */
29   function minus(
30     uint256 minuend,
31     uint256 subtrahend
32   ) public pure returns (uint256 difference) {
33     assert(minuend >= subtrahend);
34     difference = minuend - subtrahend;
35     return difference;
36   }
37 
38   /**
39    * @dev Multiplies two factors, returns the product
40    * @param factorA the first factor
41    * @param factorB the second factor
42    * @return product the product of the equation (e.g. factorA * factorB)
43    */
44   function mul(
45     uint256 factorA,
46     uint256 factorB
47   ) public pure returns (uint256 product) {
48     if (factorA == 0 || factorB == 0) return 0;
49     product = factorA * factorB;
50     assert(product / factorA == factorB);
51     return product;
52   }
53 
54   /**
55    * @dev Multiplies two factors, returns the product
56    * @param factorA the first factor
57    * @param factorB the second factor
58    * @return product the product of the equation (e.g. factorA * factorB)
59    */
60   function times(
61     uint256 factorA,
62     uint256 factorB
63   ) public pure returns (uint256 product) {
64     return mul(factorA, factorB);
65   }
66 
67   /**
68    * @dev Divides the dividend by divisor, returns the truncated quotient
69    * @param dividend the dividend
70    * @param divisor the divisor
71    * @return quotient the quotient of the equation (e.g. dividend / divisor)
72    */
73   function div(
74     uint256 dividend,
75     uint256 divisor
76   ) public pure returns (uint256 quotient) {
77     quotient = dividend / divisor;
78     assert(quotient * divisor == dividend);
79     return quotient;
80   }
81 
82   /**
83    * @dev Divides the dividend by divisor, returns the truncated quotient
84    * @param dividend the dividend
85    * @param divisor the divisor
86    * @return quotient the quotient of the equation (e.g. dividend / divisor)
87    */
88   function dividedBy(
89     uint256 dividend,
90     uint256 divisor
91   ) public pure returns (uint256 quotient) {
92     return div(dividend, divisor);
93   }
94 
95   /**
96    * @dev Divides the dividend by divisor, returns the quotient and remainder
97    * @param dividend the dividend
98    * @param divisor the divisor
99    * @return quotient the quotient of the equation (e.g. dividend / divisor)
100    * @return remainder the remainder of the equation (e.g. dividend % divisor)
101    */
102   function divideSafely(
103     uint256 dividend,
104     uint256 divisor
105   ) public pure returns (uint256 quotient, uint256 remainder) {
106     quotient = div(dividend, divisor);
107     remainder = dividend % divisor;
108   }
109 
110   /**
111    * @dev Returns the lesser of two values.
112    * @param a the first value
113    * @param b the second value
114    * @return result the lesser of the two values
115    */
116   function min(
117     uint256 a,
118     uint256 b
119   ) public pure returns (uint256 result) {
120     result = a <= b ? a : b;
121     return result;
122   }
123 
124   /**
125    * @dev Returns the greater of two values.
126    * @param a the first value
127    * @param b the second value
128    * @return result the greater of the two values
129    */
130   function max(
131     uint256 a,
132     uint256 b
133   ) public pure returns (uint256 result) {
134     result = a >= b ? a : b;
135     return result;
136   }
137 
138   /**
139    * @dev Determines whether a value is less than another.
140    * @param a the first value
141    * @param b the second value
142    * @return isTrue whether a is less than b
143    */
144   function isLessThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
145     isTrue = a < b;
146     return isTrue;
147   }
148 
149   /**
150    * @dev Determines whether a value is equal to or less than another.
151    * @param a the first value
152    * @param b the second value
153    * @return isTrue whether a is less than or equal to b
154    */
155   function isAtMost(uint256 a, uint256 b) public pure returns (bool isTrue) {
156     isTrue = a <= b;
157     return isTrue;
158   }
159 
160   /**
161    * @dev Determines whether a value is greater than another.
162    * @param a the first value
163    * @param b the second value
164    * @return isTrue whether a is greater than b
165    */
166   function isGreaterThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
167     isTrue = a > b;
168     return isTrue;
169   }
170 
171   /**
172    * @dev Determines whether a value is equal to or greater than another.
173    * @param a the first value
174    * @param b the second value
175    * @return isTrue whether a is less than b
176    */
177   function isAtLeast(uint256 a, uint256 b) public pure returns (bool isTrue) {
178     isTrue = a >= b;
179     return isTrue;
180   }
181 }
182 
183 /**
184  * @title Manageable
185  */
186 contract Manageable {
187   address public owner;
188   address public manager;
189 
190   event OwnershipChanged(address indexed previousOwner, address indexed newOwner);
191   event ManagementChanged(address indexed previousManager, address indexed newManager);
192 
193   /**
194    * @dev The Manageable constructor sets the original `owner` of the contract to the sender
195    * account.
196    */
197   function Manageable() public {
198     owner = msg.sender;
199     manager = msg.sender;
200   }
201 
202   /**
203    * @dev Throws if called by any account other than the owner or manager.
204    */
205   modifier onlyManagement() {
206     require(msg.sender == owner || msg.sender == manager);
207     _;
208   }
209 
210   /**
211    * @dev Throws if called by any account other than the owner.
212    */
213   modifier onlyOwner() {
214     require(msg.sender == owner);
215     _;
216   }
217 
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address newOwner) public onlyOwner {
223     require(newOwner != address(0));
224     OwnershipChanged(owner, newOwner);
225     owner = newOwner;
226   }
227 
228   /**
229    * @dev Allows the owner or manager to replace the current manager
230    * @param newManager The address to give contract management rights.
231    */
232   function replaceManager(address newManager) public onlyManagement {
233     require(newManager != address(0));
234     ManagementChanged(manager, newManager);
235     manager = newManager;
236   }
237 }
238 
239 contract ERC20 {
240   function allowance(address owner, address spender) public view returns (uint256);
241   function approve(address spender, uint256 value) public returns (bool);
242   function balanceOf(address who) public view returns (uint256);
243   function transfer(address to, uint256 value) public returns (bool);
244   function transferFrom(address from, address to, uint256 value) public returns (bool);
245   function totalSupply() public view returns (uint256);
246 }
247 
248 contract MythereumERC20Token is ERC20 {
249   function burn(address burner, uint256 amount) public returns (bool);
250   function mint(address to, uint256 amount) public returns (bool);
251 }
252 
253 contract MythereumCardToken {
254   function balanceOf(address _owner) public view returns (uint256 _balance);
255   function ownerOf(uint256 _tokenId) public view returns (address _owner);
256   function exists(uint256 _tokenId) public view returns (bool _exists);
257 
258   function approve(address _to, uint256 _tokenId) public;
259   function getApproved(uint256 _tokenId) public view returns (address _operator);
260 
261   function setApprovalForAll(address _operator, bool _approved) public;
262   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
263 
264   function transferFrom(address _from, address _to, uint256 _tokenId) public;
265   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
266   function safeTransferFrom(
267     address _from,
268     address _to,
269     uint256 _tokenId,
270     bytes _data
271   ) public;
272 
273   function isEditionAvailable(uint8 _editionNumber) public view returns (bool);
274   function cloneCard(address _owner, uint256 _tokenId) public returns (bool);
275   function mintRandomCards(
276     address _owner,
277     uint8 _editionNumber,
278     uint8 _numCards
279   ) public returns (bool);
280   function improveCard(
281     uint256 _tokenId,
282     uint256 _addedDamage,
283     uint256 _addedShield
284   ) public returns (bool);
285   function destroyCard(uint256 _tokenId) public returns (bool);
286 }
287 
288 contract Mythereum is Manageable {
289   using Maths for uint256;
290 
291   struct Edition {
292     string  name;
293     uint256 sales;
294     uint256 maxSales;
295     uint8   packSize;
296     uint256 packPrice;
297     uint256 packPriceIncrease;
298   }
299 
300   mapping (uint8 => Edition) public editions;
301   mapping (address => bool) public isVIP;
302   mapping (address => bool) public isTokenAccepted;
303   mapping (address => uint256) public tokenCostPerPack;
304 
305   mapping (uint256 => uint256) public mythexCostPerUpgradeLevel;
306   mapping (uint256 => uint256) public cardDamageUpgradeLevel;
307   mapping (uint256 => uint256) public cardShieldUpgradeLevel;
308   uint256 public maxCardUpgradeLevel = 30;
309 
310   address public cardTokenAddress;
311   address public xpTokenAddress;
312   address public mythexTokenAddress;
313   address public gameHostAddress;
314 
315   /* data related to shared ownership */
316   uint256 public totalShares = 0;
317   uint256 public totalReleased = 0;
318   mapping(address => uint256) public shares;
319   mapping(address => uint256) public released;
320 
321   event CardsPurchased(uint256 editionNumber, uint256 packSize, address buyer);
322   event CardUpgraded(uint256 cardId, uint256 addedDamage, uint256 addedShield);
323 
324   modifier onlyHosts() {
325     require(
326       msg.sender == owner ||
327       msg.sender == manager ||
328       msg.sender == gameHostAddress
329     );
330     _;
331   }
332 
333   function Mythereum() public {
334     editions[0] = Edition({
335       name: "Genesis",
336       sales: 3999,
337       maxSales: 5000,
338       packSize: 7,
339       packPrice: 100 finney,
340       packPriceIncrease: 1 finney
341     });
342 
343     editions[1] = Edition({
344       name: "Survivor",
345       sales: 20,
346       maxSales: 1000000,
347       packSize: 10,
348       packPrice: 0,
349       packPriceIncrease: 0
350     });
351 
352     isVIP[msg.sender] = true;
353   }
354 
355   /**
356    * @dev Disallow funds being sent directly to the contract since we can't know
357    *  which edition they'd intended to purchase.
358    */
359   function () public payable {
360     revert();
361   }
362 
363   function buyPack(
364     uint8 _editionNumber
365   ) public payable {
366     uint256 packPrice = isVIP[msg.sender] ? 0 : editions[_editionNumber].packPrice;
367 
368     require(msg.value.isAtLeast(packPrice));
369     if (msg.value.isGreaterThan(packPrice)) {
370       msg.sender.transfer(msg.value.minus(packPrice));
371     }
372 
373     _deliverPack(msg.sender, _editionNumber);
374   }
375 
376   function buyPackWithERC20Tokens(
377     uint8   _editionNumber,
378     address _tokenAddress
379   ) public {
380     require(isTokenAccepted[_tokenAddress]);
381     _processERC20TokenPackPurchase(_editionNumber, _tokenAddress, msg.sender);
382   }
383 
384   function upgradeCardDamage(uint256 _cardId) public {
385     require(cardDamageUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
386     uint256 costOfUpgrade = 32 * (cardDamageUpgradeLevel[_cardId] + 1);
387 
388     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
389     require(mythexContract.burn(msg.sender, costOfUpgrade));
390 
391     cardDamageUpgradeLevel[_cardId]++;
392     _improveCard(_cardId, 1, 0);
393   }
394 
395   function upgradeCardShield(uint256 _cardId) public {
396     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
397     uint256 costOfUpgrade = 32 * (cardShieldUpgradeLevel[_cardId] + 1);
398 
399     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
400     require(mythexContract.burn(msg.sender, costOfUpgrade));
401 
402     cardShieldUpgradeLevel[_cardId]++;
403     _improveCard(_cardId, 0, 1);
404   }
405 
406   function improveCard(
407     uint256 _cardId,
408     uint256 _addedDamage,
409     uint256 _addedShield
410   ) public onlyManagement {
411     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
412     _improveCard(_cardId, _addedDamage, _addedShield);
413   }
414 
415   function _improveCard(
416     uint256 _cardId,
417     uint256 _addedDamage,
418     uint256 _addedShield
419   ) internal {
420     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
421     require(cardToken.improveCard(_cardId, _addedDamage, _addedShield));
422     CardUpgraded(_cardId, _addedDamage, _addedShield);
423   }
424 
425   function receiveApproval(
426     address _sender,
427     uint256 _value,
428     address _tokenContract,
429     bytes _extraData
430   ) public {
431     require(isTokenAccepted[_tokenContract]);
432 
433     uint8 editionNumber = 0;
434     if (_extraData.length != 0) editionNumber = uint8(_extraData[0]);
435 
436     _processERC20TokenPackPurchase(editionNumber, _tokenContract, _sender);
437   }
438 
439   function _processERC20TokenPackPurchase(
440     uint8   _editionNumber,
441     address _tokenAddress,
442     address _buyer
443   ) internal {
444     require(isTokenAccepted[_tokenAddress]);
445     ERC20 tokenContract = ERC20(_tokenAddress);
446     uint256 costPerPack = tokenCostPerPack[_tokenAddress];
447 
448     uint256 ourBalanceBefore = tokenContract.balanceOf(address(this));
449     tokenContract.transferFrom(_buyer, address(this), costPerPack);
450 
451     uint256 ourBalanceAfter = tokenContract.balanceOf(address(this));
452     require(ourBalanceAfter.isAtLeast(ourBalanceBefore.plus(costPerPack)));
453 
454     _deliverPack(_buyer, _editionNumber);
455   }
456 
457   function burnMythexTokens(address _burner, uint256 _amount) public onlyHosts {
458     require(_burner != address(0));
459     MythereumERC20Token(mythexTokenAddress).burn(_burner, _amount);
460   }
461 
462   function burnXPTokens(address _burner, uint256 _amount) public onlyHosts {
463     require(_burner != address(0));
464     MythereumERC20Token(xpTokenAddress).burn(_burner, _amount);
465   }
466 
467   function grantMythexTokens(address _recipient, uint256 _amount) public onlyHosts {
468     require(_recipient != address(0));
469     MythereumERC20Token(mythexTokenAddress).mint(_recipient, _amount);
470   }
471 
472   function grantXPTokens(address _recipient, uint256 _amount) public onlyHosts {
473     require(_recipient != address(0));
474     MythereumERC20Token(xpTokenAddress).mint(_recipient, _amount);
475   }
476 
477   function grantPromoPack(
478     address _recipient,
479     uint8 _editionNumber
480   ) public onlyManagement {
481     _deliverPack(_recipient, _editionNumber);
482   }
483 
484   function setTokenAcceptanceRate(
485     address _token,
486     uint256 _costPerPack
487   ) public onlyManagement {
488     if (_costPerPack > 0) {
489       isTokenAccepted[_token] = true;
490       tokenCostPerPack[_token] = _costPerPack;
491     } else {
492       isTokenAccepted[_token] = false;
493       tokenCostPerPack[_token] = 0;
494     }
495   }
496 
497   function transferERC20Tokens(
498     address _token,
499     address _recipient,
500     uint256 _amount
501   ) public onlyManagement {
502     require(ERC20(_token).transfer(_recipient, _amount));
503   }
504 
505   function addVIP(address _vip) public onlyManagement {
506     isVIP[_vip] = true;
507   }
508 
509   function removeVIP(address _vip) public onlyManagement {
510     isVIP[_vip] = false;
511   }
512 
513   function setEditionName(
514     uint8 _editionNumber,
515     string _name
516   ) public onlyManagement {
517     editions[_editionNumber].name = _name;
518   }
519 
520   function setEditionSales(
521     uint8 _editionNumber,
522     uint256 _numSales
523   ) public onlyManagement {
524     editions[_editionNumber].sales = _numSales;
525   }
526 
527   function setEditionMaxSales(
528     uint8 _editionNumber,
529     uint256 _maxSales
530   ) public onlyManagement {
531     editions[_editionNumber].maxSales = _maxSales;
532   }
533 
534   function setEditionPackPrice(
535     uint8 _editionNumber,
536     uint256 _newPrice
537   ) public onlyManagement {
538     editions[_editionNumber].packPrice = _newPrice;
539   }
540 
541   function setEditionPackPriceIncrease(
542     uint8 _editionNumber,
543     uint256 _increase
544   ) public onlyManagement {
545     editions[_editionNumber].packPriceIncrease = _increase;
546   }
547 
548   function setEditionPackSize(
549     uint8 _editionNumber,
550     uint8 _newSize
551   ) public onlyManagement {
552     editions[_editionNumber].packSize = _newSize;
553   }
554 
555   function setCardUpgradeLevels(
556     uint256 _cardId,
557     uint256 _damageUpgradeLevel,
558     uint256 _shieldUpgradeLevel
559   ) public onlyManagement {
560     cardDamageUpgradeLevel[_cardId] = _damageUpgradeLevel;
561     cardShieldUpgradeLevel[_cardId] = _shieldUpgradeLevel;
562   }
563 
564   function setCardTokenAddress(address _addr) public onlyManagement {
565     require(_addr != address(0));
566     cardTokenAddress = _addr;
567   }
568 
569   function setXPTokenAddress(address _addr) public onlyManagement {
570     require(_addr != address(0));
571     xpTokenAddress = _addr;
572   }
573 
574   function setMythexTokenAddress(address _addr) public onlyManagement {
575     require(_addr != address(0));
576     mythexTokenAddress = _addr;
577   }
578 
579   function setGameHostAddress(address _addr) public onlyManagement {
580     require(_addr != address(0));
581     gameHostAddress = _addr;
582   }
583 
584   function claim() public {
585     _claim(msg.sender);
586   }
587 
588   function deposit() public payable {
589     // this is for crediting funds to the contract - only meant for internal use
590   }
591 
592   function addShareholder(address _payee, uint256 _shares) public onlyOwner {
593     require(_payee != address(0));
594     require(_shares.isAtLeast(1));
595     require(shares[_payee] == 0);
596 
597     shares[_payee] = _shares;
598     totalShares = totalShares.plus(_shares);
599   }
600 
601   function removeShareholder(address _payee) public onlyOwner {
602     require(shares[_payee] != 0);
603     _claim(_payee);
604     _forfeitShares(_payee, shares[_payee]);
605   }
606 
607   function grantAdditionalShares(
608     address _payee,
609     uint256 _shares
610   ) public onlyOwner {
611     require(shares[_payee] != 0);
612     require(_shares.isAtLeast(1));
613 
614     shares[_payee] = shares[_payee].plus(_shares);
615     totalShares = totalShares.plus(_shares);
616   }
617 
618   function forfeitShares(uint256 _numShares) public {
619     _forfeitShares(msg.sender, _numShares);
620   }
621 
622   function transferShares(address _to, uint256 _numShares) public {
623     require(_numShares.isAtLeast(1));
624     require(shares[msg.sender].isAtLeast(_numShares));
625 
626     shares[msg.sender] = shares[msg.sender].minus(_numShares);
627     shares[_to] = shares[_to].plus(_numShares);
628   }
629 
630   function transferEntireStake(address _to) public {
631     transferShares(_to, shares[msg.sender]);
632   }
633 
634   function _claim(address payee) internal {
635     require(shares[payee].isAtLeast(1));
636 
637     uint256 totalReceived = address(this).balance.plus(totalReleased);
638     uint256 payment = totalReceived.times(shares[payee]).dividedBy(totalShares).minus(released[payee]);
639 
640     require(payment != 0);
641     require(address(this).balance.isAtLeast(payment));
642 
643     released[payee] = released[payee].plus(payment);
644     totalReleased = totalReleased.plus(payment);
645 
646     payee.transfer(payment);
647   }
648 
649   function _forfeitShares(address payee, uint256 numShares) internal {
650     require(shares[payee].isAtLeast(numShares));
651     shares[payee] = shares[payee].minus(numShares);
652     totalShares = totalShares.minus(numShares);
653   }
654 
655   function _deliverPack(address recipient, uint8 editionNumber) internal {
656     Edition storage edition = editions[editionNumber];
657     require(edition.sales.isLessThan(edition.maxSales.plus(edition.packSize)));
658 
659     edition.sales = edition.sales.plus(edition.packSize);
660     edition.packPrice = edition.packPrice.plus(edition.packPriceIncrease);
661 
662     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
663     cardToken.mintRandomCards(recipient, editionNumber, edition.packSize);
664 
665     CardsPurchased(editionNumber, edition.packSize, recipient);
666   }
667 }