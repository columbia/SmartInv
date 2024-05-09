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
311   event CardDamageUpgraded(uint256 cardId, uint256 newLevel, uint256 mythexCost);
312   event CardShieldUpgraded(uint256 cardId, uint256 newLevel, uint256 mythexCost);
313 
314   modifier onlyHosts() {
315     require(
316       msg.sender == owner ||
317       msg.sender == manager ||
318       msg.sender == gameHostAddress
319     );
320     _;
321   }
322 
323   function Mythereum() public {
324     editions[0] = Edition({
325       name: "Genesis",
326       sales: 0,
327       maxSales: 5000,
328       packSize: 7,
329       packPrice: 100 finney,
330       packPriceIncrease: 1 finney
331     });
332 
333     isVIP[msg.sender] = true;
334   }
335 
336   /**
337    * @dev Disallow funds being sent directly to the contract since we can't know
338    *  which edition they'd intended to purchase.
339    */
340   function () public payable {
341     revert();
342   }
343 
344   function buyPack(
345     uint8 _editionNumber
346   ) public payable {
347     uint256 packPrice = isVIP[msg.sender] ? 0 : editions[_editionNumber].packPrice;
348 
349     require(msg.value.isAtLeast(packPrice));
350     if (msg.value.isGreaterThan(packPrice)) {
351       msg.sender.transfer(msg.value.minus(packPrice));
352     }
353 
354     _deliverPack(msg.sender, _editionNumber);
355   }
356 
357   function buyPackWithERC20Tokens(
358     uint8   _editionNumber,
359     address _tokenAddress
360   ) public {
361     require(isTokenAccepted[_tokenAddress]);
362     _processERC20TokenPackPurchase(_editionNumber, _tokenAddress, msg.sender);
363   }
364 
365   function upgradeCardDamage(uint256 _cardId) public {
366     require(cardDamageUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
367     uint256 costOfUpgrade = 2 ** (cardDamageUpgradeLevel[_cardId] + 1);
368 
369     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
370     require(mythexContract.balanceOf(msg.sender).isAtLeast(costOfUpgrade));
371     burnMythexTokens(msg.sender, costOfUpgrade);
372 
373     cardDamageUpgradeLevel[_cardId]++;
374 
375     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
376     require(cardToken.improveCard(_cardId, cardDamageUpgradeLevel[_cardId], 0));
377 
378     CardDamageUpgraded(_cardId, cardDamageUpgradeLevel[_cardId], costOfUpgrade);
379   }
380 
381   function upgradeCardShield(uint256 _cardId) public {
382     require(cardShieldUpgradeLevel[_cardId].isLessThan(maxCardUpgradeLevel));
383     uint256 costOfUpgrade = 2 ** (cardShieldUpgradeLevel[_cardId] + 1);
384 
385     MythereumERC20Token mythexContract = MythereumERC20Token(mythexTokenAddress);
386     require(mythexContract.balanceOf(msg.sender).isAtLeast(costOfUpgrade));
387     burnMythexTokens(msg.sender, costOfUpgrade);
388 
389     cardShieldUpgradeLevel[_cardId]++;
390 
391     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
392     require(cardToken.improveCard(_cardId, 0, cardShieldUpgradeLevel[_cardId]));
393 
394     CardShieldUpgraded(_cardId, cardShieldUpgradeLevel[_cardId], costOfUpgrade);
395   }
396 
397   function receiveApproval(
398     address _sender,
399     uint256 _value,
400     address _tokenContract,
401     bytes _extraData
402   ) public {
403     require(isTokenAccepted[_tokenContract]);
404 
405     uint8 editionNumber = 0;
406     if (_extraData.length != 0) editionNumber = uint8(_extraData[0]);
407 
408     _processERC20TokenPackPurchase(editionNumber, _tokenContract, _sender);
409   }
410 
411   function _processERC20TokenPackPurchase(
412     uint8   _editionNumber,
413     address _tokenAddress,
414     address _buyer
415   ) internal {
416     require(isTokenAccepted[_tokenAddress]);
417     ERC20 tokenContract = ERC20(_tokenAddress);
418     uint256 costPerPack = tokenCostPerPack[_tokenAddress];
419 
420     uint256 ourBalanceBefore = tokenContract.balanceOf(address(this));
421     tokenContract.transferFrom(_buyer, address(this), costPerPack);
422 
423     uint256 ourBalanceAfter = tokenContract.balanceOf(address(this));
424     require(ourBalanceAfter.isAtLeast(ourBalanceBefore.plus(costPerPack)));
425 
426     _deliverPack(_buyer, _editionNumber);
427   }
428 
429   function burnMythexTokens(address _burner, uint256 _amount) public onlyHosts {
430     require(_burner != address(0));
431     MythereumERC20Token(mythexTokenAddress).burn(_burner, _amount);
432   }
433 
434   function burnXPTokens(address _burner, uint256 _amount) public onlyHosts {
435     require(_burner != address(0));
436     MythereumERC20Token(xpTokenAddress).burn(_burner, _amount);
437   }
438 
439   function grantMythexTokens(address _recipient, uint256 _amount) public onlyHosts {
440     require(_recipient != address(0));
441     MythereumERC20Token(mythexTokenAddress).mint(_recipient, _amount);
442   }
443 
444   function grantXPTokens(address _recipient, uint256 _amount) public onlyHosts {
445     require(_recipient != address(0));
446     MythereumERC20Token(xpTokenAddress).mint(_recipient, _amount);
447   }
448 
449   function grantPromoPack(
450     address _recipient,
451     uint8 _editionNumber
452   ) public onlyManagement {
453     _deliverPack(_recipient, _editionNumber);
454   }
455 
456   function setTokenAcceptanceRate(
457     address _token,
458     uint256 _costPerPack
459   ) public onlyManagement {
460     if (_costPerPack > 0) {
461       isTokenAccepted[_token] = true;
462       tokenCostPerPack[_token] = _costPerPack;
463     } else {
464       isTokenAccepted[_token] = false;
465       tokenCostPerPack[_token] = 0;
466     }
467   }
468 
469   function transferERC20Tokens(
470     address _token,
471     address _recipient,
472     uint256 _amount
473   ) public onlyManagement {
474     require(ERC20(_token).transfer(_recipient, _amount));
475   }
476 
477   function addVIP(address _vip) public onlyManagement {
478     isVIP[_vip] = true;
479   }
480 
481   function removeVIP(address _vip) public onlyManagement {
482     isVIP[_vip] = false;
483   }
484 
485   function setEditionSales(
486     uint8 _editionNumber,
487     uint256 _numSales
488   ) public onlyManagement {
489     editions[_editionNumber].sales = _numSales;
490   }
491 
492   function setEditionMaxSales(
493     uint8 _editionNumber,
494     uint256 _maxSales
495   ) public onlyManagement {
496     editions[_editionNumber].maxSales = _maxSales;
497   }
498 
499   function setEditionPackPrice(
500     uint8 _editionNumber,
501     uint256 _newPrice
502   ) public onlyManagement {
503     editions[_editionNumber].packPrice = _newPrice;
504   }
505 
506   function setEditionPackPriceIncrease(
507     uint8 _editionNumber,
508     uint256 _increase
509   ) public onlyManagement {
510     editions[_editionNumber].packPriceIncrease = _increase;
511   }
512 
513   function setEditionPackSize(
514     uint8 _editionNumber,
515     uint8 _newSize
516   ) public onlyManagement {
517     editions[_editionNumber].packSize = _newSize;
518   }
519 
520   function setCardTokenAddress(address _addr) public onlyManagement {
521     require(_addr != address(0));
522     cardTokenAddress = _addr;
523   }
524 
525   function setXPTokenAddress(address _addr) public onlyManagement {
526     require(_addr != address(0));
527     xpTokenAddress = _addr;
528   }
529 
530   function setMythexTokenAddress(address _addr) public onlyManagement {
531     require(_addr != address(0));
532     mythexTokenAddress = _addr;
533   }
534 
535   function setGameHostAddress(address _addr) public onlyManagement {
536     require(_addr != address(0));
537     gameHostAddress = _addr;
538   }
539 
540   function claim() public {
541     _claim(msg.sender);
542   }
543 
544   function addShareholder(address _payee, uint256 _shares) public onlyOwner {
545     require(_payee != address(0));
546     require(_shares.isAtLeast(1));
547     require(shares[_payee] == 0);
548 
549     shares[_payee] = _shares;
550     totalShares = totalShares.plus(_shares);
551   }
552 
553   function removeShareholder(address _payee) public onlyOwner {
554     require(shares[_payee] != 0);
555     _claim(_payee);
556     _forfeitShares(_payee, shares[_payee]);
557   }
558 
559   function grantAdditionalShares(
560     address _payee,
561     uint256 _shares
562   ) public onlyOwner {
563     require(shares[_payee] != 0);
564     require(_shares.isAtLeast(1));
565 
566     shares[_payee] = shares[_payee].plus(_shares);
567     totalShares = totalShares.plus(_shares);
568   }
569 
570   function forfeitShares(uint256 _numShares) public {
571     _forfeitShares(msg.sender, _numShares);
572   }
573 
574   function transferShares(address _to, uint256 _numShares) public {
575     require(_numShares.isAtLeast(1));
576     require(shares[msg.sender].isAtLeast(_numShares));
577 
578     shares[msg.sender] = shares[msg.sender].minus(_numShares);
579     shares[_to] = shares[_to].plus(_numShares);
580   }
581 
582   function transferEntireStake(address _to) public {
583     transferShares(_to, shares[msg.sender]);
584   }
585 
586   function _claim(address payee) internal {
587     require(shares[payee].isAtLeast(1));
588 
589     uint256 totalReceived = address(this).balance.plus(totalReleased);
590     uint256 payment = totalReceived.times(shares[payee]).dividedBy(totalShares).minus(released[payee]);
591 
592     require(payment != 0);
593     require(address(this).balance.isAtLeast(payment));
594 
595     released[payee] = released[payee].plus(payment);
596     totalReleased = totalReleased.plus(payment);
597 
598     payee.transfer(payment);
599   }
600 
601   function _forfeitShares(address payee, uint256 numShares) internal {
602     require(shares[payee].isAtLeast(numShares));
603     shares[payee] = shares[payee].minus(numShares);
604     totalShares = totalShares.minus(numShares);
605   }
606 
607   function _deliverPack(address recipient, uint8 editionNumber) internal {
608     Edition storage edition = editions[editionNumber];
609     require(edition.sales.isLessThan(edition.maxSales.plus(edition.packSize)));
610 
611     edition.sales = edition.sales.plus(edition.packSize);
612     edition.packPrice = edition.packPrice.plus(edition.packPriceIncrease);
613 
614     MythereumCardToken cardToken = MythereumCardToken(cardTokenAddress);
615     cardToken.mintRandomCards(recipient, editionNumber, edition.packSize);
616 
617     CardsPurchased(editionNumber, edition.packSize, recipient);
618   }
619 }