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
378     require(mythexContract.burn(msg.sender, costOfUpgrade));
379 
380     cardDamageUpgradeLevel[_cardId]++;
381     _improveCard(_cardId, 1, 0);
382   }
383 
384   function upgradeCardShield(uint256 _cardId) public {
385     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
386     uint256 costOfUpgrade = 32 * (cardShieldUpgradeLevel[_cardId] + 1);
387 
388     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
389     require(mythexContract.burn(msg.sender, costOfUpgrade));
390 
391     cardShieldUpgradeLevel[_cardId]++;
392     _improveCard(_cardId, 0, 1);
393   }
394 
395   function improveCard(
396     uint256 _cardId,
397     uint256 _addedDamage,
398     uint256 _addedShield
399   ) public onlyManagement {
400     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
401     _improveCard(_cardId, _addedDamage, _addedShield);
402   }
403 
404   function _improveCard(
405     uint256 _cardId,
406     uint256 _addedDamage,
407     uint256 _addedShield
408   ) internal {
409     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
410     require(cardToken.improveCard(_cardId, _addedDamage, _addedShield));
411     CardUpgraded(_cardId, _addedDamage, _addedShield);
412   }
413 
414   function receiveApproval(
415     address _sender,
416     uint256 _value,
417     address _tokenContract,
418     bytes _extraData
419   ) public {
420     require(isTokenAccepted[_tokenContract]);
421 
422     uint8 editionNumber = 0;
423     if (_extraData.length != 0) editionNumber = uint8(_extraData[0]);
424 
425     _processERC20TokenPackPurchase(editionNumber, _tokenContract, _sender);
426   }
427 
428   function _processERC20TokenPackPurchase(
429     uint8   _editionNumber,
430     address _tokenAddress,
431     address _buyer
432   ) internal {
433     require(isTokenAccepted[_tokenAddress]);
434     ERC20 tokenContract = ERC20(_tokenAddress);
435     uint256 costPerPack = tokenCostPerPack[_tokenAddress];
436 
437     uint256 ourBalanceBefore = tokenContract.balanceOf(address(this));
438     tokenContract.transferFrom(_buyer, address(this), costPerPack);
439 
440     uint256 ourBalanceAfter = tokenContract.balanceOf(address(this));
441     require(ourBalanceAfter.isAtLeast(ourBalanceBefore.plus(costPerPack)));
442 
443     _deliverPack(_buyer, _editionNumber);
444   }
445 
446   function burnMythexTokens(address _burner, uint256 _amount) public onlyHosts {
447     require(_burner != address(0));
448     MythereumERC20Token(mythexTokenAddress).burn(_burner, _amount);
449   }
450 
451   function burnXPTokens(address _burner, uint256 _amount) public onlyHosts {
452     require(_burner != address(0));
453     MythereumERC20Token(xpTokenAddress).burn(_burner, _amount);
454   }
455 
456   function grantMythexTokens(address _recipient, uint256 _amount) public onlyHosts {
457     require(_recipient != address(0));
458     MythereumERC20Token(mythexTokenAddress).mint(_recipient, _amount);
459   }
460 
461   function grantXPTokens(address _recipient, uint256 _amount) public onlyHosts {
462     require(_recipient != address(0));
463     MythereumERC20Token(xpTokenAddress).mint(_recipient, _amount);
464   }
465 
466   function grantPromoPack(
467     address _recipient,
468     uint8 _editionNumber
469   ) public onlyManagement {
470     _deliverPack(_recipient, _editionNumber);
471   }
472 
473   function setTokenAcceptanceRate(
474     address _token,
475     uint256 _costPerPack
476   ) public onlyManagement {
477     if (_costPerPack > 0) {
478       isTokenAccepted[_token] = true;
479       tokenCostPerPack[_token] = _costPerPack;
480     } else {
481       isTokenAccepted[_token] = false;
482       tokenCostPerPack[_token] = 0;
483     }
484   }
485 
486   function transferERC20Tokens(
487     address _token,
488     address _recipient,
489     uint256 _amount
490   ) public onlyManagement {
491     require(ERC20(_token).transfer(_recipient, _amount));
492   }
493 
494   function addVIP(address _vip) public onlyManagement {
495     isVIP[_vip] = true;
496   }
497 
498   function removeVIP(address _vip) public onlyManagement {
499     isVIP[_vip] = false;
500   }
501 
502   function setEditionName(
503     uint8 _editionNumber,
504     string _name
505   ) public onlyManagement {
506     editions[_editionNumber].name = _name;
507   }
508 
509   function setEditionSales(
510     uint8 _editionNumber,
511     uint256 _numSales
512   ) public onlyManagement {
513     editions[_editionNumber].sales = _numSales;
514   }
515 
516   function setEditionMaxSales(
517     uint8 _editionNumber,
518     uint256 _maxSales
519   ) public onlyManagement {
520     editions[_editionNumber].maxSales = _maxSales;
521   }
522 
523   function setEditionPackPrice(
524     uint8 _editionNumber,
525     uint256 _newPrice
526   ) public onlyManagement {
527     editions[_editionNumber].packPrice = _newPrice;
528   }
529 
530   function setEditionPackPriceIncrease(
531     uint8 _editionNumber,
532     uint256 _increase
533   ) public onlyManagement {
534     editions[_editionNumber].packPriceIncrease = _increase;
535   }
536 
537   function setEditionPackSize(
538     uint8 _editionNumber,
539     uint8 _newSize
540   ) public onlyManagement {
541     editions[_editionNumber].packSize = _newSize;
542   }
543 
544   function setCardTokenAddress(address _addr) public onlyManagement {
545     require(_addr != address(0));
546     cardTokenAddress = _addr;
547   }
548 
549   function setXPTokenAddress(address _addr) public onlyManagement {
550     require(_addr != address(0));
551     xpTokenAddress = _addr;
552   }
553 
554   function setMythexTokenAddress(address _addr) public onlyManagement {
555     require(_addr != address(0));
556     mythexTokenAddress = _addr;
557   }
558 
559   function setGameHostAddress(address _addr) public onlyManagement {
560     require(_addr != address(0));
561     gameHostAddress = _addr;
562   }
563 
564   function claim() public {
565     _claim(msg.sender);
566   }
567 
568   function deposit() public payable {
569     // this is for crediting funds to the contract - only meant for internal use
570   }
571 
572   function addShareholder(address _payee, uint256 _shares) public onlyOwner {
573     require(_payee != address(0));
574     require(_shares.isAtLeast(1));
575     require(shares[_payee] == 0);
576 
577     shares[_payee] = _shares;
578     totalShares = totalShares.plus(_shares);
579   }
580 
581   function removeShareholder(address _payee) public onlyOwner {
582     require(shares[_payee] != 0);
583     _claim(_payee);
584     _forfeitShares(_payee, shares[_payee]);
585   }
586 
587   function grantAdditionalShares(
588     address _payee,
589     uint256 _shares
590   ) public onlyOwner {
591     require(shares[_payee] != 0);
592     require(_shares.isAtLeast(1));
593 
594     shares[_payee] = shares[_payee].plus(_shares);
595     totalShares = totalShares.plus(_shares);
596   }
597 
598   function forfeitShares(uint256 _numShares) public {
599     _forfeitShares(msg.sender, _numShares);
600   }
601 
602   function transferShares(address _to, uint256 _numShares) public {
603     require(_numShares.isAtLeast(1));
604     require(shares[msg.sender].isAtLeast(_numShares));
605 
606     shares[msg.sender] = shares[msg.sender].minus(_numShares);
607     shares[_to] = shares[_to].plus(_numShares);
608   }
609 
610   function transferEntireStake(address _to) public {
611     transferShares(_to, shares[msg.sender]);
612   }
613 
614   function _claim(address payee) internal {
615     require(shares[payee].isAtLeast(1));
616 
617     uint256 totalReceived = address(this).balance.plus(totalReleased);
618     uint256 payment = totalReceived.times(shares[payee]).dividedBy(totalShares).minus(released[payee]);
619 
620     require(payment != 0);
621     require(address(this).balance.isAtLeast(payment));
622 
623     released[payee] = released[payee].plus(payment);
624     totalReleased = totalReleased.plus(payment);
625 
626     payee.transfer(payment);
627   }
628 
629   function _forfeitShares(address payee, uint256 numShares) internal {
630     require(shares[payee].isAtLeast(numShares));
631     shares[payee] = shares[payee].minus(numShares);
632     totalShares = totalShares.minus(numShares);
633   }
634 
635   function _deliverPack(address recipient, uint8 editionNumber) internal {
636     Edition storage edition = editions[editionNumber];
637     require(edition.sales.isLessThan(edition.maxSales.plus(edition.packSize)));
638 
639     edition.sales = edition.sales.plus(edition.packSize);
640     edition.packPrice = edition.packPrice.plus(edition.packPriceIncrease);
641 
642     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
643     cardToken.mintRandomCards(recipient, editionNumber, edition.packSize);
644 
645     CardsPurchased(editionNumber, edition.packSize, recipient);
646   }
647 }