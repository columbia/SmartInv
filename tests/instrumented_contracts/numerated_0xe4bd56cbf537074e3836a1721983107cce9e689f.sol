1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title PullPayment
51  * @dev Base contract supporting async send for pull payments. Inherit from this
52  * contract and use asyncSend instead of send or transfer.
53  */
54 contract PullPayment {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) public payments;
58   uint256 public totalPayments;
59 
60   /**
61   * @dev Withdraw accumulated balance, called by payee.
62   */
63   function withdrawPayments() public {
64     address payee = msg.sender;
65     uint256 payment = payments[payee];
66 
67     require(payment != 0);
68     require(address(this).balance >= payment);
69 
70     totalPayments = totalPayments.sub(payment);
71     payments[payee] = 0;
72 
73     payee.transfer(payment);
74   }
75 
76   /**
77   * @dev Called by the payer to store the sent amount as credit to be pulled.
78   * @param dest The destination address of the funds.
79   * @param amount The amount to transfer.
80   */
81   function asyncSend(address dest, uint256 amount) internal {
82     payments[dest] = payments[dest].add(amount);
83     totalPayments = totalPayments.add(amount);
84   }
85 
86   // Called by children of this contract to remove value from an account
87   function asyncDebit(address dest, uint256 amount) internal {
88     payments[dest] = payments[dest].sub(amount);
89     totalPayments = totalPayments.sub(amount);
90   }
91 }
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     require(newOwner != address(0));
125     emit OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 }
129 
130 /**
131  * Sorted list of sales for use in the marketplace. Sorting is maintained by linked list.
132  */
133 library SaleListLib {
134   address public constant nullAddress = address(0);
135 
136   struct SaleList {
137     address head;
138 
139     mapping(address => address) sellerListMapping;
140     mapping(address => uint) sellerToPrice;
141   }
142 
143   function getBest(SaleList storage self) public view returns (address, uint) {
144     address head = self.head;
145     return (head, self.sellerToPrice[head]);
146   }
147 
148   function addSale(SaleList storage self, address seller, uint price) public {
149     require(price != 0);
150     require(seller != nullAddress);
151 
152     if (_contains(self, seller)) {
153       removeSale(self, seller);
154     }
155 
156     self.sellerToPrice[seller] = price;
157     if (self.head == nullAddress || price <= self.sellerToPrice[self.head]) {
158       self.sellerListMapping[seller] = self.head;
159       self.head = seller;
160     } else {
161       address prev = self.head;
162       address cur = self.sellerListMapping[prev];
163 
164       while (cur != nullAddress) {
165         if (price <= self.sellerToPrice[cur]) {
166           self.sellerListMapping[prev] = seller;
167           self.sellerListMapping[seller] = cur;
168 
169           break;
170         }
171 
172         prev = cur;
173         cur = self.sellerListMapping[cur];
174       }
175 
176       // Insert value greater than all values in list
177       if (cur == nullAddress) {
178         self.sellerListMapping[prev] = seller;
179       }
180     }
181   }
182 
183   function removeSale(SaleList storage self, address seller) public returns (bool) {
184     require(seller != nullAddress);
185 
186     if (!_contains(self, seller)) {
187       return false;
188     }
189 
190     if (seller == self.head) {
191       self.head = self.sellerListMapping[seller];
192       _remove(self, seller);
193     } else {
194       address prev = self.head;
195       address cur = self.sellerListMapping[prev];
196 
197       // TODO: Make SURE that initialized mapping with address vals initializes those vals to address(0)
198       // NOTE: Redundant check (prev != seller)
199       while (cur != nullAddress && prev != seller) {
200         if (cur == seller) {
201           self.sellerListMapping[prev] = self.sellerListMapping[seller];
202           _remove(self, seller);
203 
204           break;
205         }
206 
207         prev = cur;
208         cur = self.sellerListMapping[cur];
209       }
210 
211       // NOTE: Redundant check
212       if (cur == nullAddress) {
213         return false;
214       }
215     }
216 
217     return true;
218   }
219 
220   // NOTE: This is a purely internal method that *only* zeros out sellerListMapping and sellerToPrice
221   function _remove(SaleList storage self, address seller) internal {
222     self.sellerToPrice[seller] = 0;
223     self.sellerListMapping[seller] = nullAddress;
224   }
225 
226   function _contains(SaleList storage self, address seller) view internal returns (bool) {
227     return self.sellerToPrice[seller] != 0;
228   }
229 }
230 
231 contract SaleRegistry is Ownable {
232   using SafeMath for uint256;
233 
234   /////////
235   // Events
236   /////////
237 
238   event SalePosted(
239     address indexed _seller,
240     bytes32 indexed _sig,
241     uint256 _price
242   );
243 
244   event SaleCancelled(
245     address indexed _seller,
246     bytes32 indexed _sig
247   );
248 
249   ////////
250   // State
251   ////////
252 
253   mapping(bytes32 => SaleListLib.SaleList) _sigToSortedSales;
254 
255   mapping(address => mapping(bytes32 => uint256)) _addressToSigToSalePrice;
256 
257   // NOTE: Rules are different for contract owner. Can run many sales at a time, all at a single price. This
258   // allows multi-sale at genesis time
259   mapping(bytes32 => uint256) _ownerSigToNumSales;
260 
261   mapping(bytes32 => uint256) public sigToNumSales;
262 
263   /////////////
264   // User views
265   /////////////
266 
267   // Returns (seller, price) tuple
268   function getBestSale(bytes32 sig) public view returns (address, uint256) {
269     return SaleListLib.getBest(_sigToSortedSales[sig]);
270   }
271 
272   // Returns price that the sender is selling the current sig for (or 0 if not)
273   function getMySalePrice(bytes32 sig) public view returns (uint256) {
274     return _addressToSigToSalePrice[msg.sender][sig];
275   }
276 
277   ///////////////
278   // User actions
279   ///////////////
280 
281   // Convenience method used *only* at genesis sale time
282   function postGenesisSales(bytes32 sig, uint256 price, uint256 numSales) internal onlyOwner {
283     SaleListLib.addSale(_sigToSortedSales[sig], owner, price);
284     _addressToSigToSalePrice[owner][sig] = price;
285 
286     _ownerSigToNumSales[sig] = _ownerSigToNumSales[sig].add(numSales);
287     sigToNumSales[sig] = sigToNumSales[sig].add(numSales);
288 
289     emit SalePosted(owner, sig, price);
290   }
291 
292   // Admin method for re-listing all genesis sales
293   function relistGenesisSales(bytes32 sig, uint256 newPrice) external onlyOwner {
294     SaleListLib.addSale(_sigToSortedSales[sig], owner, newPrice);
295     _addressToSigToSalePrice[owner][sig] = newPrice;
296 
297     emit SalePosted(owner, sig, newPrice);
298   }
299 
300   // NOTE: Only allows 1 active sale per address per sig, unless owner
301   function postSale(address seller, bytes32 sig, uint256 price) internal {
302     SaleListLib.addSale(_sigToSortedSales[sig], seller, price);
303     _addressToSigToSalePrice[seller][sig] = price;
304 
305     sigToNumSales[sig] = sigToNumSales[sig].add(1);
306 
307     if (seller == owner) {
308       _ownerSigToNumSales[sig] = _ownerSigToNumSales[sig].add(1);
309     }
310 
311     emit SalePosted(seller, sig, price);
312   }
313 
314   // NOTE: Special remove logic for contract owner's sale!
315   function cancelSale(address seller, bytes32 sig) internal {
316     if (seller == owner) {
317       _ownerSigToNumSales[sig] = _ownerSigToNumSales[sig].sub(1);
318 
319       if (_ownerSigToNumSales[sig] == 0) {
320         SaleListLib.removeSale(_sigToSortedSales[sig], seller);
321         _addressToSigToSalePrice[seller][sig] = 0;
322       }
323     } else {
324       SaleListLib.removeSale(_sigToSortedSales[sig], seller);
325       _addressToSigToSalePrice[seller][sig] = 0;
326     }
327     sigToNumSales[sig] = sigToNumSales[sig].sub(1);
328 
329     emit SaleCancelled(seller, sig);
330   }
331 }
332 
333 contract OwnerRegistry {
334   using SafeMath for uint256;
335 
336   /////////
337   // Events
338   /////////
339 
340   event CardCreated(
341     bytes32 indexed _sig,
342     uint256 _numAdded
343   );
344 
345   event CardsTransferred(
346     bytes32 indexed _sig,
347     address indexed _oldOwner,
348     address indexed _newOwner,
349     uint256 _count
350   );
351 
352   ////////
353   // State
354   ////////
355 
356   bytes32[] _allSigs;
357   mapping(address => mapping(bytes32 => uint256)) _ownerToSigToCount;
358   mapping(bytes32 => uint256) _sigToCount;
359 
360   ////////////////
361   // Admin actions
362   ////////////////
363 
364   function addCardToRegistry(address owner, bytes32 sig, uint256 numToAdd) internal {
365     // Only allow adding cards that haven't already been added
366     require(_sigToCount[sig] == 0);
367 
368     _allSigs.push(sig);
369     _ownerToSigToCount[owner][sig] = numToAdd;
370     _sigToCount[sig] = numToAdd;
371 
372     emit CardCreated(sig, numToAdd);
373   }
374 
375   /////////////
376   // User views
377   /////////////
378 
379   function getAllSigs() public view returns (bytes32[]) {
380     return _allSigs;
381   }
382 
383   function getNumSigsOwned(bytes32 sig) public view returns (uint256) {
384     return _ownerToSigToCount[msg.sender][sig];
385   }
386 
387   function getNumSigs(bytes32 sig) public view returns (uint256) {
388     return _sigToCount[sig];
389   }
390 
391   ///////////////////
392   // Transfer actions
393   ///////////////////
394 
395   function registryTransfer(address oldOwner, address newOwner, bytes32 sig, uint256 count) internal {
396     // Must be transferring at least one card!
397     require(count > 0);
398 
399     // Don't allow a transfer when the old owner doesn't enough of the card
400     require(_ownerToSigToCount[oldOwner][sig] >= count);
401 
402     _ownerToSigToCount[oldOwner][sig] = _ownerToSigToCount[oldOwner][sig].sub(count);
403     _ownerToSigToCount[newOwner][sig] = _ownerToSigToCount[newOwner][sig].add(count);
404 
405     emit CardsTransferred(sig, oldOwner, newOwner, count);
406   }
407 }
408 
409 contract ArtistRegistry {
410   using SafeMath for uint256;
411 
412   mapping(bytes32 => address) _sigToArtist;
413 
414   // fee tuple is of form (txFeePercent, genesisSalePercent)
415   mapping(bytes32 => uint256[2]) _sigToFeeTuple;
416 
417   function addArtistToRegistry(bytes32 sig,
418                                address artist,
419                                uint256 txFeePercent,
420                                uint256 genesisSalePercent) internal {
421     // Must be a valid artist address!
422     require(artist != address(0));
423 
424     // Only allow 1 sig per artist!
425     require(_sigToArtist[sig] == address(0));
426 
427     _sigToArtist[sig] = artist;
428     _sigToFeeTuple[sig] = [txFeePercent, genesisSalePercent];
429   }
430 
431   function computeArtistTxFee(bytes32 sig, uint256 txFee) internal view returns (uint256) {
432     uint256 feePercent = _sigToFeeTuple[sig][0];
433     return (txFee.mul(feePercent)).div(100);
434   }
435 
436   function computeArtistGenesisSaleFee(bytes32 sig, uint256 genesisSaleProfit) internal view returns (uint256) {
437     uint256 feePercent = _sigToFeeTuple[sig][1];
438     return (genesisSaleProfit.mul(feePercent)).div(100);
439   }
440 
441   function getArtist(bytes32 sig) internal view returns (address) {
442     return _sigToArtist[sig];
443   }
444 }
445 
446 contract PepeCore is PullPayment, OwnerRegistry, SaleRegistry, ArtistRegistry {
447   using SafeMath for uint256;
448 
449   uint256 constant public totalTxFeePercent = 4;
450 
451   ////////////////////
452   // Shareholder stuff
453   ////////////////////
454 
455   // Only 3 equal shareholders max allowed on this contract representing the three equal-partner founders
456   // involved in its inception
457   address public shareholder1;
458   address public shareholder2;
459   address public shareholder3;
460 
461   // 0 -> 3 depending on contract state. I only use uint256 so that I can use SafeMath...
462   uint256 public numShareholders = 0;
463 
464   // Used to set initial shareholders
465   function addShareholderAddress(address newShareholder) external onlyOwner {
466     // Don't let shareholder be address(0)
467     require(newShareholder != address(0));
468 
469     // Contract owner can't be a shareholder
470     require(newShareholder != owner);
471 
472     // Must be an open shareholder spot!
473     require(shareholder1 == address(0) || shareholder2 == address(0) || shareholder3 == address(0));
474 
475     if (shareholder1 == address(0)) {
476       shareholder1 = newShareholder;
477       numShareholders = numShareholders.add(1);
478     } else if (shareholder2 == address(0)) {
479       shareholder2 = newShareholder;
480       numShareholders = numShareholders.add(1);
481     } else if (shareholder3 == address(0)) {
482       shareholder3 = newShareholder;
483       numShareholders = numShareholders.add(1);
484     }
485   }
486 
487   // Splits the amount specified among shareholders equally
488   function payShareholders(uint256 amount) internal {
489     // If no shareholders, shareholder fees will be held in contract to be withdrawable by owner
490     if (numShareholders > 0) {
491       uint256 perShareholderFee = amount.div(numShareholders);
492 
493       if (shareholder1 != address(0)) {
494         asyncSend(shareholder1, perShareholderFee);
495       }
496 
497       if (shareholder2 != address(0)) {
498         asyncSend(shareholder2, perShareholderFee);
499       }
500 
501       if (shareholder3 != address(0)) {
502         asyncSend(shareholder3, perShareholderFee);
503       }
504     }
505   }
506 
507   ////////////////
508   // Admin actions
509   ////////////////
510 
511   function withdrawContractBalance() external onlyOwner {
512     uint256 contractBalance = address(this).balance;
513     uint256 withdrawableBalance = contractBalance.sub(totalPayments);
514 
515     // No withdrawal necessary if <= 0 balance
516     require(withdrawableBalance > 0);
517 
518     msg.sender.transfer(withdrawableBalance);
519   }
520 
521   function addCard(bytes32 sig,
522                    address artist,
523                    uint256 txFeePercent,
524                    uint256 genesisSalePercent,
525                    uint256 numToAdd,
526                    uint256 startingPrice) external onlyOwner {
527     addCardToRegistry(owner, sig, numToAdd);
528 
529     addArtistToRegistry(sig, artist, txFeePercent, genesisSalePercent);
530 
531     postGenesisSales(sig, startingPrice, numToAdd);
532   }
533 
534   ///////////////
535   // User actions
536   ///////////////
537 
538   function createSale(bytes32 sig, uint256 price) external {
539     // Can't sell a card for 0... May want other limits in the future
540     require(price > 0);
541 
542     // Can't sell a card you don't own
543     require(getNumSigsOwned(sig) > 0);
544 
545     // Can't post a sale if you have one posted already! Unless you're the contract owner
546     require(msg.sender == owner || _addressToSigToSalePrice[msg.sender][sig] == 0);
547 
548     postSale(msg.sender, sig, price);
549   }
550 
551   function removeSale(bytes32 sig) public {
552     // Can't cancel a sale that doesn't exist
553     require(_addressToSigToSalePrice[msg.sender][sig] > 0);
554 
555     cancelSale(msg.sender, sig);
556   }
557 
558   function computeTxFee(uint256 price) private pure returns (uint256) {
559     return (price * totalTxFeePercent) / 100;
560   }
561 
562   // If card is held by contract owner, split among artist + shareholders
563   function paySellerFee(bytes32 sig, address seller, uint256 sellerProfit) private {
564     if (seller == owner) {
565       address artist = getArtist(sig);
566       uint256 artistFee = computeArtistGenesisSaleFee(sig, sellerProfit);
567       asyncSend(artist, artistFee);
568 
569       payShareholders(sellerProfit.sub(artistFee));
570     } else {
571       asyncSend(seller, sellerProfit);
572     }
573   }
574 
575   // Simply pay out tx fees appropriately
576   function payTxFees(bytes32 sig, uint256 txFee) private {
577     uint256 artistFee = computeArtistTxFee(sig, txFee);
578     address artist = getArtist(sig);
579     asyncSend(artist, artistFee);
580 
581     payShareholders(txFee.sub(artistFee));
582   }
583 
584   // Handle wallet debit if necessary, pay out fees, pay out seller profit, cancel sale, transfer card
585   function buy(bytes32 sig) external payable {
586     address seller;
587     uint256 price;
588     (seller, price) = getBestSale(sig);
589 
590     // There must be a valid sale for the card
591     require(price > 0 && seller != address(0));
592 
593     // Buyer must have enough Eth via wallet and payment to cover posted price
594     uint256 availableEth = msg.value.add(payments[msg.sender]);
595     require(availableEth >= price);
596 
597     // Debit wallet if msg doesn't have enough value to cover price
598     if (msg.value < price) {
599       asyncDebit(msg.sender, price.sub(msg.value));
600     }
601 
602     // Split out fees + seller profit
603     uint256 txFee = computeTxFee(price);
604     uint256 sellerProfit = price.sub(txFee);
605 
606     // Pay out seller (special logic for seller == owner)
607     paySellerFee(sig, seller, sellerProfit);
608 
609     // Pay out tx fees
610     payTxFees(sig, txFee);
611 
612     // Cancel sale
613     cancelSale(seller, sig);
614 
615     // Transfer single sig ownership in registry
616     registryTransfer(seller, msg.sender, sig, 1);
617   }
618 
619   // Can also be used in airdrops, etc.
620   function transferSig(bytes32 sig, uint256 count, address newOwner) external {
621     uint256 numOwned = getNumSigsOwned(sig);
622 
623     // Can't transfer cards you don't own
624     require(numOwned >= count);
625 
626     // If transferring from contract owner, cancel the proper number of sales if necessary
627     if (msg.sender == owner) {
628       uint256 remaining = numOwned.sub(count);
629 
630       if (remaining < _ownerSigToNumSales[sig]) {
631         uint256 numSalesToCancel = _ownerSigToNumSales[sig].sub(remaining);
632 
633         for (uint256 i = 0; i < numSalesToCancel; i++) {
634           removeSale(sig);
635         }
636       }
637     } else {
638       // Remove existing sale if transferring all owned cards
639       if (numOwned == count && _addressToSigToSalePrice[msg.sender][sig] > 0) {
640         removeSale(sig);
641       }
642     }
643 
644     // Transfer in registry
645     registryTransfer(msg.sender, newOwner, sig, count);
646   }
647 }