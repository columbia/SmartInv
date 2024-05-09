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
240   function balanceOf(address who) public view returns (uint256);
241   function transfer(address to, uint256 value) public returns (bool);
242   function transferFrom(address from, address to, uint256 value) public returns (bool);
243 }
244 
245 contract AbnormalERC20 {
246   function transfer(address to, uint256 value) public;
247 }
248 
249 contract MythereumERC20Token is ERC20 {
250   function burn(address burner, uint256 amount) public returns (bool);
251   function mint(address to, uint256 amount) public returns (bool);
252 }
253 
254 contract MythereumCardToken {
255   function mintRandomCards(
256     address _owner,
257     uint8 _editionNumber,
258     uint8 _numCards
259   ) public returns (bool);
260   function improveCard(
261     uint256 _tokenId,
262     uint256 _addedDamage,
263     uint256 _addedShield
264   ) public returns (bool);
265 }
266 
267 contract Mythereum is Manageable {
268   using Maths for uint256;
269 
270   struct Edition {
271     string  name;
272     uint256 sales;
273     uint256 maxSales;
274     uint8   packSize;
275     uint256 packPrice;
276     uint256 packPriceIncrease;
277   }
278 
279   mapping (uint8 => Edition) public editions;
280   mapping (address => bool) public isVIP;
281   mapping (address => bool) public isTokenAccepted;
282   mapping (address => uint256) public tokenCostPerPack;
283 
284   mapping (uint256 => uint256) public mythexCostPerUpgradeLevel;
285   mapping (uint256 => uint256) public cardDamageUpgradeLevel;
286   mapping (uint256 => uint256) public cardShieldUpgradeLevel;
287   uint256 public maxCardUpgradeLevel = 30;
288 
289   address public cardTokenAddress;
290   address public xpTokenAddress;
291   address public mythexTokenAddress;
292   address public gameHostAddress;
293 
294   /* data related to shared ownership */
295   uint256 public totalShares = 0;
296   uint256 public totalReleased = 0;
297   mapping(address => uint256) public shares;
298   mapping(address => uint256) public released;
299 
300   event CardsPurchased(uint256 editionNumber, uint256 packSize, address buyer);
301   event CardUpgraded(uint256 cardId, uint256 addedDamage, uint256 addedShield);
302 
303   modifier onlyHosts() {
304     require(
305       msg.sender == owner ||
306       msg.sender == manager ||
307       msg.sender == gameHostAddress
308     );
309     _;
310   }
311 
312   function Mythereum() public {
313     editions[0] = Edition({
314       name: "Genesis",
315       sales: 4139,
316       maxSales: 5000,
317       packSize: 7,
318       packPrice: 177000000000000000,
319       packPriceIncrease: 1 finney
320     });
321 
322     editions[1] = Edition({
323       name: "Survivor",
324       sales: 20,
325       maxSales: 1000000,
326       packSize: 10,
327       packPrice: 0,
328       packPriceIncrease: 0
329     });
330 
331     isVIP[msg.sender] = true;
332   }
333 
334   /**
335    * @dev Disallow funds being sent directly to the contract since we can't know
336    *  which edition they'd intended to purchase.
337    */
338   function () public payable {
339     revert();
340   }
341 
342   function buyPack(
343     uint8 _editionNumber
344   ) public payable {
345     uint256 packPrice = isVIP[msg.sender] ? 0 : editions[_editionNumber].packPrice;
346 
347     require(msg.value.isAtLeast(packPrice));
348     if (msg.value.isGreaterThan(packPrice)) {
349       msg.sender.transfer(msg.value.minus(packPrice));
350     }
351 
352     _deliverPack(msg.sender, _editionNumber);
353   }
354 
355   function buyPackWithERC20Tokens(
356     uint8   _editionNumber,
357     address _tokenAddress
358   ) public {
359     require(isTokenAccepted[_tokenAddress]);
360     _processERC20TokenPackPurchase(_editionNumber, _tokenAddress, msg.sender);
361   }
362 
363   function upgradeCardDamage(uint256 _cardId) public {
364     require(cardDamageUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
365     uint256 costOfUpgrade = 32 * (cardDamageUpgradeLevel[_cardId] + 1);
366 
367     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
368     require(mythexContract.burn(msg.sender, costOfUpgrade));
369 
370     cardDamageUpgradeLevel[_cardId]++;
371     _improveCard(_cardId, 1, 0);
372   }
373 
374   function upgradeCardShield(uint256 _cardId) public {
375     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
376     uint256 costOfUpgrade = 32 * (cardShieldUpgradeLevel[_cardId] + 1);
377 
378     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
379     require(mythexContract.burn(msg.sender, costOfUpgrade));
380 
381     cardShieldUpgradeLevel[_cardId]++;
382     _improveCard(_cardId, 0, 1);
383   }
384 
385   function improveCard(
386     uint256 _cardId,
387     uint256 _addedDamage,
388     uint256 _addedShield
389   ) public onlyManagement {
390     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
391     _improveCard(_cardId, _addedDamage, _addedShield);
392   }
393 
394   function _improveCard(
395     uint256 _cardId,
396     uint256 _addedDamage,
397     uint256 _addedShield
398   ) internal {
399     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
400     require(cardToken.improveCard(_cardId, _addedDamage, _addedShield));
401     CardUpgraded(_cardId, _addedDamage, _addedShield);
402   }
403 
404   function receiveApproval(
405     address _sender,
406     uint256 _value,
407     address _tokenContract,
408     bytes _extraData
409   ) public {
410     require(isTokenAccepted[_tokenContract]);
411 
412     uint8 editionNumber = 0;
413     if (_extraData.length != 0) editionNumber = uint8(_extraData[0]);
414 
415     _processERC20TokenPackPurchase(editionNumber, _tokenContract, _sender);
416   }
417 
418   function _processERC20TokenPackPurchase(
419     uint8   _editionNumber,
420     address _tokenAddress,
421     address _buyer
422   ) internal {
423     require(isTokenAccepted[_tokenAddress]);
424     ERC20 tokenContract = ERC20(_tokenAddress);
425     uint256 costPerPack = tokenCostPerPack[_tokenAddress];
426 
427     uint256 ourBalanceBefore = tokenContract.balanceOf(address(this));
428     tokenContract.transferFrom(_buyer, address(this), costPerPack);
429 
430     uint256 ourBalanceAfter = tokenContract.balanceOf(address(this));
431     require(ourBalanceAfter.isAtLeast(ourBalanceBefore.plus(costPerPack)));
432 
433     _deliverPack(_buyer, _editionNumber);
434   }
435 
436   function burnMythexTokens(address _burner, uint256 _amount) public onlyHosts {
437     require(_burner != address(0));
438     MythereumERC20Token(mythexTokenAddress).burn(_burner, _amount);
439   }
440 
441   function burnXPTokens(address _burner, uint256 _amount) public onlyHosts {
442     require(_burner != address(0));
443     MythereumERC20Token(xpTokenAddress).burn(_burner, _amount);
444   }
445 
446   function grantMythexTokens(address _recipient, uint256 _amount) public onlyHosts {
447     require(_recipient != address(0));
448     MythereumERC20Token(mythexTokenAddress).mint(_recipient, _amount);
449   }
450 
451   function grantXPTokens(address _recipient, uint256 _amount) public onlyHosts {
452     require(_recipient != address(0));
453     MythereumERC20Token(xpTokenAddress).mint(_recipient, _amount);
454   }
455 
456   function grantPromoPack(
457     address _recipient,
458     uint8 _editionNumber
459   ) public onlyManagement {
460     _deliverPack(_recipient, _editionNumber);
461   }
462 
463   function setTokenAcceptanceRate(
464     address _token,
465     uint256 _costPerPack
466   ) public onlyManagement {
467     if (_costPerPack > 0) {
468       isTokenAccepted[_token] = true;
469       tokenCostPerPack[_token] = _costPerPack;
470     } else {
471       isTokenAccepted[_token] = false;
472       tokenCostPerPack[_token] = 0;
473     }
474   }
475 
476   function transferERC20Tokens(
477     address _token,
478     address _recipient,
479     uint256 _amount
480   ) public onlyManagement {
481     require(ERC20(_token).transfer(_recipient, _amount));
482   }
483 
484   function transferAbnormalERC20Tokens(
485     address _token,
486     address _recipient,
487     uint256 _amount
488   ) public onlyManagement {
489     // certain ERC20s don't return bool success flags :(
490     AbnormalERC20(_token).transfer(_recipient, _amount);
491   }
492 
493   function addVIP(address _vip) public onlyManagement {
494     isVIP[_vip] = true;
495   }
496 
497   function removeVIP(address _vip) public onlyManagement {
498     isVIP[_vip] = false;
499   }
500 
501   function setEditionName(
502     uint8 _editionNumber,
503     string _name
504   ) public onlyManagement {
505     editions[_editionNumber].name = _name;
506   }
507 
508   function setEditionSales(
509     uint8 _editionNumber,
510     uint256 _numSales
511   ) public onlyManagement {
512     editions[_editionNumber].sales = _numSales;
513   }
514 
515   function setEditionMaxSales(
516     uint8 _editionNumber,
517     uint256 _maxSales
518   ) public onlyManagement {
519     editions[_editionNumber].maxSales = _maxSales;
520   }
521 
522   function setEditionPackPrice(
523     uint8 _editionNumber,
524     uint256 _newPrice
525   ) public onlyManagement {
526     editions[_editionNumber].packPrice = _newPrice;
527   }
528 
529   function setEditionPackPriceIncrease(
530     uint8 _editionNumber,
531     uint256 _increase
532   ) public onlyManagement {
533     editions[_editionNumber].packPriceIncrease = _increase;
534   }
535 
536   function setEditionPackSize(
537     uint8 _editionNumber,
538     uint8 _newSize
539   ) public onlyManagement {
540     editions[_editionNumber].packSize = _newSize;
541   }
542 
543   function setCardUpgradeLevels(
544     uint256 _cardId,
545     uint256 _damageUpgradeLevel,
546     uint256 _shieldUpgradeLevel
547   ) public onlyManagement {
548     cardDamageUpgradeLevel[_cardId] = _damageUpgradeLevel;
549     cardShieldUpgradeLevel[_cardId] = _shieldUpgradeLevel;
550   }
551 
552   function setCardTokenAddress(address _addr) public onlyManagement {
553     require(_addr != address(0));
554     cardTokenAddress = _addr;
555   }
556 
557   function setXPTokenAddress(address _addr) public onlyManagement {
558     require(_addr != address(0));
559     xpTokenAddress = _addr;
560   }
561 
562   function setMythexTokenAddress(address _addr) public onlyManagement {
563     require(_addr != address(0));
564     mythexTokenAddress = _addr;
565   }
566 
567   function setGameHostAddress(address _addr) public onlyManagement {
568     require(_addr != address(0));
569     gameHostAddress = _addr;
570   }
571 
572   function claim() public {
573     _claim(msg.sender);
574   }
575 
576   function deposit() public payable {
577     // this is for crediting funds to the contract - only meant for internal use
578   }
579 
580   function addShareholder(address _payee, uint256 _shares) public onlyOwner {
581     require(_payee != address(0));
582     require(_shares.isAtLeast(1));
583     require(shares[_payee] == 0);
584 
585     shares[_payee] = _shares;
586     totalShares = totalShares.plus(_shares);
587   }
588 
589   function removeShareholder(address _payee) public onlyOwner {
590     require(shares[_payee] != 0);
591     _claim(_payee);
592     _forfeitShares(_payee, shares[_payee]);
593   }
594 
595   function grantAdditionalShares(
596     address _payee,
597     uint256 _shares
598   ) public onlyOwner {
599     require(shares[_payee] != 0);
600     require(_shares.isAtLeast(1));
601 
602     shares[_payee] = shares[_payee].plus(_shares);
603     totalShares = totalShares.plus(_shares);
604   }
605 
606   function forfeitShares(uint256 _numShares) public {
607     _forfeitShares(msg.sender, _numShares);
608   }
609 
610   function transferShares(address _to, uint256 _numShares) public {
611     require(_numShares.isAtLeast(1));
612     require(shares[msg.sender].isAtLeast(_numShares));
613 
614     shares[msg.sender] = shares[msg.sender].minus(_numShares);
615     shares[_to] = shares[_to].plus(_numShares);
616   }
617 
618   function _claim(address payee) internal {
619     require(shares[payee].isAtLeast(1));
620 
621     uint256 totalReceived = address(this).balance.plus(totalReleased);
622     uint256 payment = totalReceived.times(shares[payee]).dividedBy(totalShares).minus(released[payee]);
623 
624     require(payment != 0);
625     require(address(this).balance.isAtLeast(payment));
626 
627     released[payee] = released[payee].plus(payment);
628     totalReleased = totalReleased.plus(payment);
629 
630     payee.transfer(payment);
631   }
632 
633   function _forfeitShares(address payee, uint256 numShares) internal {
634     require(shares[payee].isAtLeast(numShares));
635     shares[payee] = shares[payee].minus(numShares);
636     totalShares = totalShares.minus(numShares);
637   }
638 
639   function _deliverPack(address recipient, uint8 editionNumber) internal {
640     Edition storage edition = editions[editionNumber];
641     require(edition.sales.isLessThan(edition.maxSales.plus(edition.packSize)));
642 
643     edition.sales = edition.sales.plus(edition.packSize);
644     edition.packPrice = edition.packPrice.plus(edition.packPriceIncrease);
645 
646     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
647     cardToken.mintRandomCards(recipient, editionNumber, edition.packSize);
648 
649     CardsPurchased(editionNumber, edition.packSize, recipient);
650   }
651 }