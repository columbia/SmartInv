1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract IStorage {
6   function processPreSaleBonus(uint minTotalUsdAmountInCents, uint bonusPercent, uint _start, uint _limit) external returns(uint);
7   function checkNeedProcessPreSaleBonus(uint minTotalUsdAmountInCents) external view returns(bool);
8   function getCountNeedProcessPreSaleBonus(uint minTotalUsdAmountInCents, uint start, uint limit) external view returns(uint);
9   function reCountUserPreSaleBonus(uint uId, uint minTotalUsdAmountInCents, uint bonusPercent, uint maxPayTime) external returns(uint, uint);
10   function getContributorIndexes(uint index) external view returns(uint);
11   function checkNeedSendSHPC(bool proc) external view returns(bool);
12   function getCountNeedSendSHPC(uint start, uint limit) external view returns(uint);
13   function checkETHRefund(bool proc) external view returns(bool);
14   function getCountETHRefund(uint start, uint limit) external view returns(uint);
15   function addPayment(address _addr, string pType, uint _value, uint usdAmount, uint currencyUSD, uint tokenWithoutBonus, uint tokenBonus, uint bonusPercent, uint payId) public returns(bool);
16   function addPayment(uint uId, string pType, uint _value, uint usdAmount, uint currencyUSD, uint tokenWithoutBonus, uint tokenBonus, uint bonusPercent, uint payId) public returns(bool);
17   function checkUserIdExists(uint uId) public view returns(bool);
18   function getContributorAddressById(uint uId) public view returns(address);
19   function editPaymentByUserId(uint uId, uint payId, uint _payValue, uint _usdAmount, uint _currencyUSD, uint _totalToken, uint _tokenWithoutBonus, uint _tokenBonus, uint _bonusPercent) public returns(bool);
20   function getUserPaymentById(uint uId, uint payId) public view returns(uint time, bytes32 pType, uint currencyUSD, uint bonusPercent, uint payValue, uint totalToken, uint tokenBonus, uint tokenWithoutBonus, uint usdAbsRaisedInCents, bool refund);
21   function checkWalletExists(address addr) public view returns(bool result);
22   function checkReceivedCoins(address addr) public view returns(bool);
23   function getContributorId(address addr) public view returns(uint);
24   function getTotalCoin(address addr) public view returns(uint);
25   function setReceivedCoin(uint uId) public returns(bool);
26   function checkPreSaleReceivedBonus(address addr) public view returns(bool);
27   function checkRefund(address addr) public view returns(bool);
28   function setRefund(uint uId) public returns(bool);
29   function getEthPaymentContributor(address addr) public view returns(uint);
30   function refundPaymentByUserId(uint uId, uint payId) public returns(bool);
31   function changeSupportChangeMainWallet(bool support) public returns(bool);
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
45     // benefit is lost if 'b' is also tested.
46     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47     if (a == 0) {
48       return 0;
49     }
50 
51     c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   /**
57   * @dev Integer division of two numbers, truncating the quotient.
58   */
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     // uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return a / b;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   /**
75   * @dev Adds two numbers, throws on overflow.
76   */
77   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
78     c = a + b;
79     assert(c >= a);
80     return c;
81   }
82 }
83 
84 /**
85  * @title String
86  * @dev ConcatenationString, uintToString, stringsEqual, stringToBytes32, bytes32ToString
87  */
88 contract String {
89 
90   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string memory) {
91     bytes memory _ba = bytes(_a);
92     bytes memory _bb = bytes(_b);
93     bytes memory _bc = bytes(_c);
94     bytes memory _bd = bytes(_d);
95     bytes memory _be = bytes(_e);
96     bytes memory abcde = bytes(new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length));
97     uint k = 0;
98     uint i;
99     for (i = 0; i < _ba.length; i++) {
100       abcde[k++] = _ba[i];
101     }
102     for (i = 0; i < _bb.length; i++) {
103       abcde[k++] = _bb[i];
104     }
105     for (i = 0; i < _bc.length; i++) {
106       abcde[k++] = _bc[i];
107     }
108     for (i = 0; i < _bd.length; i++) {
109       abcde[k++] = _bd[i];
110     }
111     for (i = 0; i < _be.length; i++) {
112       abcde[k++] = _be[i];
113     }
114     return string(abcde);
115   }
116 
117   function strConcat(string _a, string _b, string _c, string _d) internal pure returns(string) {
118     return strConcat(_a, _b, _c, _d, "");
119   }
120 
121   function strConcat(string _a, string _b, string _c) internal pure returns(string) {
122     return strConcat(_a, _b, _c, "", "");
123   }
124 
125   function strConcat(string _a, string _b) internal pure returns(string) {
126     return strConcat(_a, _b, "", "", "");
127   }
128 
129   function uint2str(uint i) internal pure returns(string) {
130     if (i == 0) {
131       return "0";
132     }
133     uint j = i;
134     uint length;
135     while (j != 0) {
136       length++;
137       j /= 10;
138     }
139     bytes memory bstr = new bytes(length);
140     uint k = length - 1;
141     while (i != 0) {
142       bstr[k--] = byte(uint8(48 + i % 10));
143       i /= 10;
144     }
145     return string(bstr);
146   }
147 
148   function stringsEqual(string memory _a, string memory _b) internal pure returns(bool) {
149     bytes memory a = bytes(_a);
150     bytes memory b = bytes(_b);
151 
152     if (a.length != b.length)
153       return false;
154 
155     for (uint i = 0; i < a.length; i++) {
156       if (a[i] != b[i]) {
157         return false;
158       }
159     }
160 
161     return true;
162   }
163 
164   function stringToBytes32(string memory source) internal pure returns(bytes32 result) {
165     bytes memory _tmp = bytes(source);
166     if (_tmp.length == 0) {
167       return 0x0;
168     }
169     assembly {
170       result := mload(add(source, 32))
171     }
172   }
173 
174   function bytes32ToString(bytes32 x) internal pure returns (string) {
175     bytes memory bytesString = new bytes(32);
176     uint charCount = 0;
177     uint j;
178     for (j = 0; j < 32; j++) {
179       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
180       if (char != 0) {
181         bytesString[charCount] = char;
182         charCount++;
183       }
184     }
185     bytes memory bytesStringTrimmed = new bytes(charCount);
186     for (j = 0; j < charCount; j++) {
187       bytesStringTrimmed[j] = bytesString[j];
188     }
189     return string(bytesStringTrimmed);
190   }
191 
192   function inArray(string[] _array, string _value) internal pure returns(bool result) {
193     if (_array.length == 0 || bytes(_value).length == 0) {
194       return false;
195     }
196     result = false;
197     for (uint i = 0; i < _array.length; i++) {
198       if (stringsEqual(_array[i],_value)) {
199         result = true;
200         return true;
201       }
202     }
203   }
204 }
205 
206 /**
207  * @title Ownable
208  * @dev The Ownable contract has an owner address, and provides basic authorization control
209  * functions, this simplifies the implementation of "user permissions".
210  */
211 contract Ownable {
212   address public owner;
213 
214 
215   event OwnershipRenounced(address indexed previousOwner);
216   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217 
218 
219   /**
220    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
221    * account.
222    */
223   constructor () public {
224     owner = msg.sender;
225   }
226 
227   /**
228    * @dev Throws if called by any account other than the owner.
229    */
230   modifier onlyOwner() {
231     require(msg.sender == owner);
232     _;
233   }
234 
235   /**
236    * @dev Allows the current owner to transfer control of the contract to a newOwner.
237    * @param newOwner The address to transfer ownership to.
238    */
239   function transferOwnership(address newOwner) public onlyOwner {
240     require(newOwner != address(0));
241     emit OwnershipTransferred(owner, newOwner);
242     owner = newOwner;
243   }
244 
245   /**
246    * @dev Allows the current owner to relinquish control of the contract.
247    */
248   function renounceOwnership() public onlyOwner {
249     emit OwnershipRenounced(owner);
250     owner = address(0);
251   }
252 }
253 
254 /**
255  * @title MultiOwnable
256  * @dev The MultiOwnable contract has an owner address[], and provides basic authorization control
257  */
258 contract MultiOwnable is Ownable {
259 
260   struct Types {
261     mapping (address => bool) access;
262   }
263   mapping (uint => Types) private multiOwnersTypes;
264 
265   event AddOwner(uint _type, address addr);
266   event AddOwner(uint[] types, address addr);
267   event RemoveOwner(uint _type, address addr);
268 
269   modifier onlyMultiOwnersType(uint _type) {
270     require(multiOwnersTypes[_type].access[msg.sender] || msg.sender == owner, "403");
271     _;
272   }
273 
274   function onlyMultiOwnerType(uint _type, address _sender) public view returns(bool) {
275     if (multiOwnersTypes[_type].access[_sender] || _sender == owner) {
276       return true;
277     }
278     return false;
279   }
280 
281   function addMultiOwnerType(uint _type, address _owner) public onlyOwner returns(bool) {
282     require(_owner != address(0));
283     multiOwnersTypes[_type].access[_owner] = true;
284     emit AddOwner(_type, _owner);
285     return true;
286   }
287   
288   function addMultiOwnerTypes(uint[] types, address _owner) public onlyOwner returns(bool) {
289     require(_owner != address(0));
290     require(types.length > 0);
291     for (uint i = 0; i < types.length; i++) {
292       multiOwnersTypes[types[i]].access[_owner] = true;
293     }
294     emit AddOwner(types, _owner);
295     return true;
296   }
297 
298   function removeMultiOwnerType(uint types, address _owner) public onlyOwner returns(bool) {
299     require(_owner != address(0));
300     multiOwnersTypes[types].access[_owner] = false;
301     emit RemoveOwner(types, _owner);
302     return true;
303   }
304 }
305 
306 /**
307  * @title Whitelist
308  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
309  * @dev This simplifies the implementation of "user permissions".
310  */
311 contract ShipCoinStorage is IStorage, MultiOwnable, String {
312   using SafeMath for uint256;
313 
314   /* Events */
315   event WhitelistAddressAdded(address addr);
316   event WhitelistAddressRemoved(address addr);
317   event AddPayment(address addr);
318   event GotPreSaleBonus(address addr);
319   event EditUserPayments(address addr, uint payId);
320   event RefundPayment(address addr, uint payId);
321   event ReceivedCoin(address addr);
322   event Refund(address addr);
323   event ChangeMainWallet(address addr);
324 
325   struct PaymentData {
326     uint time;
327     bytes32 pType;
328     uint currencyUSD;
329     uint payValue;
330     uint totalToken;
331     uint tokenWithoutBonus;
332     uint tokenBonus;
333     uint bonusPercent;
334     uint usdAbsRaisedInCents;
335   }
336 
337   struct StorageData {
338     bool active;
339     mapping(bytes32 => uint) payInCurrency;
340     uint totalToken;
341     uint tokenWithoutBonus;
342     uint tokenBonus;
343     uint usdAbsRaisedInCents;
344     mapping(uint => PaymentData) paymentInfo;
345     address mainWallet;
346     address[] wallet;
347   }
348   // uId = { }
349   mapping(uint => StorageData) private contributorList;
350   // wallet = uId
351   mapping(address => uint) private contributorIds;
352   // i++ = uId
353   mapping(uint => uint) private contributorIndexes;
354   //uId = payIds
355   mapping(uint => uint[]) private contributorPayIds;
356   uint public nextContributorIndex;
357 
358   bytes32[] private currencyTicker;
359   // uId
360   mapping(uint => uint) private receivedPreSaleBonus;
361   // uId
362   mapping(uint => bool) private receivedCoin;
363   //payIds
364   mapping(uint => bool) private payIds;
365   //payIds
366   mapping(uint => bool) private refundPayIds;
367   //uId
368   mapping(uint => bool) private refundUserIds;
369 
370   uint private startGenId = 100000;
371 
372   bool public supportChangeMainWallet = true;
373 
374   /**
375    * @dev Calculate contributors appoint presale bonus
376    */
377   function processPreSaleBonus(uint minTotalUsdAmountInCents, uint bonusPercent, uint _start, uint _limit) external onlyMultiOwnersType(12) returns(uint) {
378     require(minTotalUsdAmountInCents > 10000);
379     require(bonusPercent > 20 && bonusPercent < 50);
380     require(_limit >= 10);
381 
382     uint start = _start;
383     uint limit = _limit;
384     uint bonusTokenAll = 0;
385     for (uint i = start; i < limit; i++) {
386       uint uId = contributorIndexes[i];
387       if (contributorList[uId].active && !checkPreSaleReceivedBonus(uId) && contributorList[uId].usdAbsRaisedInCents >= minTotalUsdAmountInCents) {
388         uint bonusToken = contributorList[uId].tokenWithoutBonus.mul(bonusPercent).div(100);
389 
390         contributorList[uId].totalToken += bonusToken;
391         contributorList[uId].tokenBonus = bonusToken;
392         receivedPreSaleBonus[uId] = bonusToken;
393         bonusTokenAll += bonusToken;
394         emit GotPreSaleBonus(contributorList[uId].mainWallet);
395       }
396     }
397 
398     return bonusTokenAll;
399   }
400 
401   /**
402    * @dev Checks contributors who have not received their presale bonuses
403    */
404   function checkNeedProcessPreSaleBonus(uint minTotalUsdAmountInCents) external view returns(bool) {
405     require(minTotalUsdAmountInCents > 10000);
406     bool processed = false;
407     for (uint i = 0; i < nextContributorIndex; i++) {
408       if (processed) {
409         break;
410       }
411       uint uId = contributorIndexes[i];
412       if (contributorList[uId].active && !refundUserIds[uId] && !checkPreSaleReceivedBonus(uId) && contributorList[uId].usdAbsRaisedInCents >= minTotalUsdAmountInCents) {
413         processed = true;
414       }
415     }
416     return processed;
417   }
418 
419   /**
420    * @dev Returns the number of contributors who have not received their presale bonuses
421    */
422   function getCountNeedProcessPreSaleBonus(uint minTotalUsdAmountInCents, uint start, uint limit) external view returns(uint) {
423     require(minTotalUsdAmountInCents > 10000);
424     require(start >= 0 && limit >= 10);
425     uint processed = 0;
426     for (uint i = start; i < (limit > nextContributorIndex ? nextContributorIndex : limit); i++) {
427       uint uId = contributorIndexes[i];
428       if (contributorList[uId].active && !refundUserIds[uId] && !checkPreSaleReceivedBonus(uId) && contributorList[uId].usdAbsRaisedInCents >= minTotalUsdAmountInCents) {
429         processed++;
430       }
431     }
432     return processed;
433   }
434 
435   /**
436    * @dev Checks contributors who have not received their SHPC
437    */
438   function checkNeedSendSHPC(bool proc) external view returns(bool) {
439     bool processed = false;
440     if (proc) {
441       for (uint i = 0; i < nextContributorIndex; i++) {
442         if (processed) {
443           break;
444         }
445         uint uId = contributorIndexes[i];
446         if (contributorList[uId].active && !refundUserIds[uId] && !checkReceivedCoins(uId) && contributorList[uId].totalToken > 0) {
447           processed = true;
448         }
449       }
450     }
451     return processed;
452   }
453 
454   /**
455    * @dev Returns the number of contributors who have not received their SHPC
456    */
457   function getCountNeedSendSHPC(uint start, uint limit) external view returns(uint) {
458     require(start >= 0 && limit >= 10);
459     uint processed = 0;
460     for (uint i = start; i < (limit > nextContributorIndex ? nextContributorIndex : limit); i++) {
461       uint uId = contributorIndexes[i];
462       if (contributorList[uId].active && !refundUserIds[uId] && !checkReceivedCoins(uId) && contributorList[uId].totalToken > 0) {
463         processed++;
464       }
465     }
466     return processed;
467   }
468 
469   /**
470    * @dev Checks contributors who have not received their ETH when refund
471    */
472   function checkETHRefund(bool proc) external view returns(bool) {
473     bool processed = false;
474     if (proc) {
475       for (uint i = 0; i < nextContributorIndex; i++) {
476         if (processed) {
477           break;
478         }
479         uint uId = contributorIndexes[i];
480         if (contributorList[uId].active && !refundUserIds[uId] && getEthPaymentContributor(uId) > 0) {
481           processed = true;
482         }
483       }
484     }
485     return processed;
486   }
487 
488   /**
489    * @dev Returns the number of contributors who have not received their ETH when refund
490    */
491   function getCountETHRefund(uint start, uint limit) external view returns(uint) {
492     require(start >= 0 && limit >= 10);
493     uint processed = 0;
494     for (uint i = start; i < (limit > nextContributorIndex ? nextContributorIndex : limit); i++) {
495       uint uId = contributorIndexes[i];
496       if (contributorList[uId].active && !refundUserIds[uId] && getEthPaymentContributor(uId) > 0) {
497         processed++;
498       }
499     }
500     return processed;
501   }
502 
503   /**
504    * @dev Returns uId by index;
505    */
506   function getContributorIndexes(uint index) external onlyMultiOwnersType(7) view returns(uint) {
507     return contributorIndexes[index];
508   }
509 
510   /**
511    * @dev Recalculation contributors presale bonus
512    */
513   function reCountUserPreSaleBonus(uint _uId, uint minTotalUsdAmountInCents, uint bonusPercent, uint maxPayTime) external onlyMultiOwnersType(13) returns(uint, uint) {
514     require(_uId > 0);
515     require(contributorList[_uId].active);
516     require(!refundUserIds[_uId]);
517     require(minTotalUsdAmountInCents > 10000);
518     require(bonusPercent > 20 && bonusPercent < 50);
519     uint bonusToken = 0;
520     uint uId = _uId;
521     uint beforeBonusToken = receivedPreSaleBonus[uId];
522 
523     if (beforeBonusToken > 0) {
524       contributorList[uId].totalToken -= beforeBonusToken;
525       contributorList[uId].tokenBonus -= beforeBonusToken;
526       receivedPreSaleBonus[uId] = 0;
527     }
528 
529     if (contributorList[uId].usdAbsRaisedInCents >= minTotalUsdAmountInCents) {
530       if (maxPayTime > 0) {
531         for (uint i = 0; i < contributorPayIds[uId].length; i++) {
532           PaymentData memory _payment = contributorList[uId].paymentInfo[contributorPayIds[uId][i]];
533           if (!refundPayIds[contributorPayIds[uId][i]] && _payment.bonusPercent == 0 && _payment.time < maxPayTime) {
534             bonusToken += _payment.tokenWithoutBonus.mul(bonusPercent).div(100);
535           }
536         }
537       } else {
538         bonusToken = contributorList[uId].tokenWithoutBonus.mul(bonusPercent).div(100);
539       }
540 
541       if (bonusToken > 0) {
542         contributorList[uId].totalToken += bonusToken;
543         contributorList[uId].tokenBonus += bonusToken;
544         receivedPreSaleBonus[uId] = bonusToken;
545         emit GotPreSaleBonus(contributorList[uId].mainWallet);
546       }
547     }
548     return (beforeBonusToken, bonusToken);
549   }
550 
551   /**
552    * @dev add user and wallet to whitelist
553    */
554   function addWhiteList(uint uId, address addr) public onlyMultiOwnersType(1) returns(bool success) {
555     require(addr != address(0), "1");
556     require(uId > 0, "2");
557     require(!refundUserIds[uId]);
558 
559     if (contributorIds[addr] > 0 && contributorIds[addr] != uId) {
560       success = false;
561       revert("3");
562     }
563 
564     if (contributorList[uId].active != true) {
565       contributorList[uId].active = true;
566       contributorIndexes[nextContributorIndex] = uId;
567       nextContributorIndex++;
568       contributorList[uId].mainWallet = addr;
569     }
570 
571     if (inArray(contributorList[uId].wallet, addr) != true && contributorList[uId].wallet.length < 3) {
572       contributorList[uId].wallet.push(addr);
573       contributorIds[addr] = uId;
574       emit WhitelistAddressAdded(addr);
575       success = true;
576     } else {
577       success = false;
578     }
579   }
580 
581   /**
582    * @dev remove user wallet from whitelist
583    */
584   function removeWhiteList(uint uId, address addr) public onlyMultiOwnersType(2) returns(bool success) {
585     require(contributorList[uId].active, "1");
586     require(addr != address(0), "2");
587     require(uId > 0, "3");
588     require(inArray(contributorList[uId].wallet, addr));
589 
590     if (contributorPayIds[uId].length > 0 || contributorList[uId].mainWallet == addr) {
591       success = false;
592       revert("5");
593     }
594 
595 
596     contributorList[uId].wallet = removeValueFromArray(contributorList[uId].wallet, addr);
597     delete contributorIds[addr];
598 
599     emit WhitelistAddressRemoved(addr);
600     success = true;
601   }
602 
603   /**
604    * @dev Change contributor mainWallet
605    */
606   function changeMainWallet(uint uId, address addr) public onlyMultiOwnersType(3) returns(bool) {
607     require(supportChangeMainWallet);
608     require(addr != address(0));
609     require(uId > 0);
610     require(contributorList[uId].active);
611     require(!refundUserIds[uId]);
612     require(inArray(contributorList[uId].wallet, addr));
613 
614     contributorList[uId].mainWallet = addr;
615     emit ChangeMainWallet(addr);
616     return true;
617   }
618 
619   /**
620    * @dev Change the right to change mainWallet
621    */
622   function changeSupportChangeMainWallet(bool support) public onlyMultiOwnersType(21) returns(bool) {
623     supportChangeMainWallet = support;
624     return supportChangeMainWallet;
625   }
626 
627   /**
628    * @dev Returns all contributor info by uId
629    */
630   function getContributionInfoById(uint _uId) public onlyMultiOwnersType(4) view returns(
631       bool active,
632       string payInCurrency,
633       uint totalToken,
634       uint tokenWithoutBonus,
635       uint tokenBonus,
636       uint usdAbsRaisedInCents,
637       uint[] paymentInfoIds,
638       address mainWallet,
639       address[] wallet,
640       uint preSaleReceivedBonus,
641       bool receivedCoins,
642       bool refund
643     )
644   {
645     uint uId = _uId;
646     return getContributionInfo(contributorList[uId].mainWallet);
647   }
648 
649   /**
650    * @dev Returns all contributor info by address
651    */
652   function getContributionInfo(address _addr)
653     public
654     view
655     returns(
656       bool active,
657       string payInCurrency,
658       uint totalToken,
659       uint tokenWithoutBonus,
660       uint tokenBonus,
661       uint usdAbsRaisedInCents,
662       uint[] paymentInfoIds,
663       address mainWallet,
664       address[] wallet,
665       uint preSaleReceivedBonus,
666       bool receivedCoins,
667       bool refund
668     )
669   {
670 
671     address addr = _addr;
672     StorageData memory storData = contributorList[contributorIds[addr]];
673 
674     (preSaleReceivedBonus, receivedCoins, refund) = getInfoAdditionl(addr);
675 
676     return(
677     storData.active,
678     (contributorPayIds[contributorIds[addr]].length > 0 ? getContributorPayInCurrency(contributorIds[addr]) : "[]"),
679     storData.totalToken,
680     storData.tokenWithoutBonus,
681     storData.tokenBonus,
682     storData.usdAbsRaisedInCents,
683     contributorPayIds[contributorIds[addr]],
684     storData.mainWallet,
685     storData.wallet,
686     preSaleReceivedBonus,
687     receivedCoins,
688     refund
689     );
690   }
691 
692   /**
693    * @dev Returns contributor id by address
694    */
695   function getContributorId(address addr) public onlyMultiOwnersType(5) view returns(uint) {
696     return contributorIds[addr];
697   }
698 
699   /**
700    * @dev Returns contributors address by uId
701    */
702   function getContributorAddressById(uint uId) public onlyMultiOwnersType(6) view returns(address) {
703     require(uId > 0);
704     require(contributorList[uId].active);
705     return contributorList[uId].mainWallet;
706   }
707 
708   /**
709    * @dev Check wallet exists by address
710    */
711   function checkWalletExists(address addr) public view returns(bool result) {
712     result = false;
713     if (contributorList[contributorIds[addr]].wallet.length > 0) {
714       result = inArray(contributorList[contributorIds[addr]].wallet, addr);
715     }
716   }
717 
718   /**
719    * @dev Check userId is exists
720    */
721   function checkUserIdExists(uint uId) public onlyMultiOwnersType(8) view returns(bool) {
722     return contributorList[uId].active;
723   }
724 
725   /**
726    * @dev Add payment by address
727    */
728   function addPayment(
729     address _addr,
730     string pType,
731     uint _value,
732     uint usdAmount,
733     uint currencyUSD,
734     uint tokenWithoutBonus,
735     uint tokenBonus,
736     uint bonusPercent,
737     uint payId
738   )
739   public
740   onlyMultiOwnersType(9)
741   returns(bool)
742   {
743     require(_value > 0);
744     require(usdAmount > 0);
745     require(tokenWithoutBonus > 0);
746     require(bytes(pType).length > 0);
747     assert((payId == 0 && stringsEqual(pType, "ETH")) || (payId > 0 && !payIds[payId]));
748 
749     address addr = _addr;
750     uint uId = contributorIds[addr];
751 
752     assert(addr != address(0));
753     assert(checkWalletExists(addr));
754     assert(uId > 0);
755     assert(contributorList[uId].active);
756     assert(!refundUserIds[uId]);
757     assert(!receivedCoin[uId]);
758 
759     if (payId == 0) {
760       payId = genId(addr, _value, 0);
761     }
762 
763     bytes32 _pType = stringToBytes32(pType);
764     PaymentData memory userPayment;
765     uint totalToken = tokenWithoutBonus.add(tokenBonus);
766 
767     //userPayment.payId = payId;
768     userPayment.time = block.timestamp;
769     userPayment.pType = _pType;
770     userPayment.currencyUSD = currencyUSD;
771     userPayment.payValue = _value;
772     userPayment.totalToken = totalToken;
773     userPayment.tokenWithoutBonus = tokenWithoutBonus;
774     userPayment.tokenBonus = tokenBonus;
775     userPayment.bonusPercent = bonusPercent;
776     userPayment.usdAbsRaisedInCents = usdAmount;
777 
778     if (!inArray(currencyTicker, _pType)) {
779       currencyTicker.push(_pType);
780     }
781     if (payId > 0) {
782       payIds[payId] = true;
783     }
784 
785     contributorList[uId].usdAbsRaisedInCents += usdAmount;
786     contributorList[uId].totalToken += totalToken;
787     contributorList[uId].tokenWithoutBonus += tokenWithoutBonus;
788     contributorList[uId].tokenBonus += tokenBonus;
789 
790     contributorList[uId].payInCurrency[_pType] += _value;
791     contributorList[uId].paymentInfo[payId] = userPayment;
792     contributorPayIds[uId].push(payId);
793 
794     emit AddPayment(addr);
795     return true;
796   }
797 
798   /**
799    * @dev Add payment by uId
800    */
801   function addPayment(
802     uint uId,
803     string pType,
804     uint _value,
805     uint usdAmount,
806     uint currencyUSD,
807     uint tokenWithoutBonus,
808     uint tokenBonus,
809     uint bonusPercent,
810     uint payId
811   )
812   public
813   returns(bool)
814   {
815     require(contributorList[uId].active);
816     require(contributorList[uId].mainWallet != address(0));
817     return addPayment(contributorList[uId].mainWallet, pType, _value, usdAmount, currencyUSD, tokenWithoutBonus, tokenBonus, bonusPercent, payId);
818   }
819 
820   /**
821    * @dev Edit user payment info
822    */
823   function editPaymentByUserId(
824     uint uId,
825     uint payId,
826     uint _payValue,
827     uint _usdAmount,
828     uint _currencyUSD,
829     uint _totalToken,
830     uint _tokenWithoutBonus,
831     uint _tokenBonus,
832     uint _bonusPercent
833   )
834   public
835   onlyMultiOwnersType(10)
836   returns(bool)
837   {
838     require(contributorList[uId].active);
839     require(inArray(contributorPayIds[uId], payId));
840     require(!refundPayIds[payId]);
841     require(!refundUserIds[uId]);
842     require(!receivedCoin[uId]);
843 
844     PaymentData memory oldPayment = contributorList[uId].paymentInfo[payId];
845 
846     contributorList[uId].usdAbsRaisedInCents -= oldPayment.usdAbsRaisedInCents;
847     contributorList[uId].totalToken -= oldPayment.totalToken;
848     contributorList[uId].tokenWithoutBonus -= oldPayment.tokenWithoutBonus;
849     contributorList[uId].tokenBonus -= oldPayment.tokenBonus;
850     contributorList[uId].payInCurrency[oldPayment.pType] -= oldPayment.payValue;
851 
852     contributorList[uId].paymentInfo[payId] = PaymentData(
853       oldPayment.time,
854       oldPayment.pType,
855       _currencyUSD,
856       _payValue,
857       _totalToken,
858       _tokenWithoutBonus,
859       _tokenBonus,
860       _bonusPercent,
861       _usdAmount
862     );
863 
864     contributorList[uId].usdAbsRaisedInCents += _usdAmount;
865     contributorList[uId].totalToken += _totalToken;
866     contributorList[uId].tokenWithoutBonus += _tokenWithoutBonus;
867     contributorList[uId].tokenBonus += _tokenBonus;
868     contributorList[uId].payInCurrency[oldPayment.pType] += _payValue;
869 
870     emit EditUserPayments(contributorList[uId].mainWallet, payId);
871 
872     return true;
873   }
874 
875   /**
876    * @dev Refund user payment
877    */
878   function refundPaymentByUserId(uint uId, uint payId) public onlyMultiOwnersType(20) returns(bool) {
879     require(contributorList[uId].active);
880     require(inArray(contributorPayIds[uId], payId));
881     require(!refundPayIds[payId]);
882     require(!refundUserIds[uId]);
883     require(!receivedCoin[uId]);
884 
885     PaymentData memory oldPayment = contributorList[uId].paymentInfo[payId];
886 
887     assert(oldPayment.pType != stringToBytes32("ETH"));
888 
889     contributorList[uId].usdAbsRaisedInCents -= oldPayment.usdAbsRaisedInCents;
890     contributorList[uId].totalToken -= oldPayment.totalToken;
891     contributorList[uId].tokenWithoutBonus -= oldPayment.tokenWithoutBonus;
892     contributorList[uId].tokenBonus -= oldPayment.tokenBonus;
893     contributorList[uId].payInCurrency[oldPayment.pType] -= oldPayment.payValue;
894 
895     refundPayIds[payId] = true;
896 
897     emit RefundPayment(contributorList[uId].mainWallet, payId);
898 
899     return true;
900   }
901 
902   /**
903    * @dev Reutrns user payment info by uId and paymentId
904    */
905   function getUserPaymentById(uint _uId, uint _payId) public onlyMultiOwnersType(11) view returns(
906     uint time,
907     bytes32 pType,
908     uint currencyUSD,
909     uint bonusPercent,
910     uint payValue,
911     uint totalToken,
912     uint tokenBonus,
913     uint tokenWithoutBonus,
914     uint usdAbsRaisedInCents,
915     bool refund
916   )
917   {
918     uint uId = _uId;
919     uint payId = _payId;
920     require(contributorList[uId].active);
921     require(inArray(contributorPayIds[uId], payId));
922 
923     PaymentData memory payment = contributorList[uId].paymentInfo[payId];
924 
925     return (
926       payment.time,
927       payment.pType,
928       payment.currencyUSD,
929       payment.bonusPercent,
930       payment.payValue,
931       payment.totalToken,
932       payment.tokenBonus,
933       payment.tokenWithoutBonus,
934       payment.usdAbsRaisedInCents,
935       refundPayIds[payId] ? true : false
936     );
937   }
938 
939   /**
940    * @dev Reutrns user payment info by address and payment id
941    */
942   function getUserPayment(address addr, uint _payId) public view returns(
943     uint time,
944     string pType,
945     uint currencyUSD,
946     uint bonusPercent,
947     uint payValue,
948     uint totalToken,
949     uint tokenBonus,
950     uint tokenWithoutBonus,
951     uint usdAbsRaisedInCents,
952     bool refund
953   )
954   {
955     address _addr = addr;
956     require(contributorList[contributorIds[_addr]].active);
957     require(inArray(contributorPayIds[contributorIds[_addr]], _payId));
958 
959     uint payId = _payId;
960 
961     PaymentData memory payment = contributorList[contributorIds[_addr]].paymentInfo[payId];
962 
963     return (
964       payment.time,
965       bytes32ToString(payment.pType),
966       payment.currencyUSD,
967       payment.bonusPercent,
968       payment.payValue,
969       payment.totalToken,
970       payment.tokenBonus,
971       payment.tokenWithoutBonus,
972       payment.usdAbsRaisedInCents,
973       refundPayIds[payId] ? true : false
974     );
975   }
976 
977   /**
978    * @dev Returns payment in ETH from address
979    */
980   function getEthPaymentContributor(address addr) public view returns(uint) {
981     return contributorList[contributorIds[addr]].payInCurrency[stringToBytes32("ETH")];
982   }
983 
984   /**
985    * @dev Returns SHPC from address
986    */
987   function getTotalCoin(address addr) public view returns(uint) {
988     return contributorList[contributorIds[addr]].totalToken;
989   }
990 
991   /**
992    * @dev Check user get pre sale bonus by address
993    */
994   function checkPreSaleReceivedBonus(address addr) public view returns(bool) {
995     return receivedPreSaleBonus[contributorIds[addr]] > 0 ? true : false;
996   }
997 
998   /**
999    * @dev Check payment refund by payment id
1000    */
1001   function checkPaymentRefund(uint payId) public view returns(bool) {
1002     return refundPayIds[payId];
1003   }
1004 
1005   /**
1006    * @dev Check user refund by address
1007    */
1008   function checkRefund(address addr) public view returns(bool) {
1009     return refundUserIds[contributorIds[addr]];
1010   }
1011 
1012   /**
1013    * @dev Set start number generate payment id when user pay in eth
1014    */
1015   function setStartGenId(uint startId) public onlyMultiOwnersType(14) {
1016     require(startId > 0);
1017     startGenId = startId;
1018   }
1019 
1020   /**
1021    * @dev Set contributer got SHPC
1022    */
1023   function setReceivedCoin(uint uId) public onlyMultiOwnersType(15) returns(bool) {
1024     require(contributorList[uId].active);
1025     require(!refundUserIds[uId]);
1026     require(!receivedCoin[uId]);
1027     receivedCoin[uId] = true;
1028     emit ReceivedCoin(contributorList[uId].mainWallet);
1029     return true;
1030   }
1031 
1032   /**
1033    * @dev Set contributer got refund ETH
1034    */
1035   function setRefund(uint uId) public onlyMultiOwnersType(16) returns(bool) {
1036     require(contributorList[uId].active);
1037     require(!refundUserIds[uId]);
1038     require(!receivedCoin[uId]);
1039     refundUserIds[uId] = true;
1040     emit Refund(contributorList[uId].mainWallet);
1041     return true;
1042   }
1043 
1044   /**
1045    * @dev Check contributor got SHPC
1046    */
1047   function checkReceivedCoins(address addr) public view returns(bool) {
1048     return receivedCoin[contributorIds[addr]];
1049   }
1050 
1051   /**
1052    * @dev Check contributor got ETH
1053    */
1054   function checkReceivedEth(address addr) public view returns(bool) {
1055     return refundUserIds[contributorIds[addr]];
1056   }
1057 
1058   /**
1059    * @dev Returns all contributor currency amount in json
1060    */
1061   function getContributorPayInCurrency(uint uId) private view returns(string) {
1062     require(uId > 0);
1063     require(contributorList[uId].active);
1064     string memory payInCurrency = "{";
1065     for (uint i = 0; i < currencyTicker.length; i++) {
1066       payInCurrency = strConcat(payInCurrency, strConcat("\"", bytes32ToString(currencyTicker[i]), "\":\""), uint2str(contributorList[uId].payInCurrency[currencyTicker[i]]), (i+1 < currencyTicker.length) ? "\"," : "\"}");
1067     }
1068     return payInCurrency;
1069   }
1070 
1071   /**
1072    * @dev Check receives presale bonud by uId
1073    */
1074   function checkPreSaleReceivedBonus(uint uId) private view returns(bool) {
1075     return receivedPreSaleBonus[uId] > 0 ? true : false;
1076   }
1077 
1078   /**
1079    * @dev Check refund by uId
1080    */
1081   function checkRefund(uint uId) private view returns(bool) {
1082     return refundUserIds[uId];
1083   }
1084 
1085   /**
1086    * @dev  Check received SHPC by uI
1087    */
1088   function checkReceivedCoins(uint id) private view returns(bool) {
1089     return receivedCoin[id];
1090   }
1091 
1092   /**
1093    * @dev Check received eth by uId
1094    */
1095   function checkReceivedEth(uint id) private view returns(bool) {
1096     return refundUserIds[id];
1097   }
1098 
1099   /**
1100    * @dev Returns new uniq payment id
1101    */
1102   function genId(address addr, uint ammount, uint rand) private view returns(uint) {
1103     uint id = startGenId + uint8(keccak256(abi.encodePacked(addr, blockhash(block.number), ammount, rand))) + contributorPayIds[contributorIds[addr]].length;
1104     if (!payIds[id]) {
1105       return id;
1106     } else {
1107       return genId(addr, ammount, id);
1108     }
1109   }
1110 
1111   /**
1112    * @dev Returns payment in ETH from uid
1113    */
1114   function getEthPaymentContributor(uint uId) private view returns(uint) {
1115     return contributorList[uId].payInCurrency[stringToBytes32("ETH")];
1116   }
1117 
1118   /**
1119    * @dev Returns adittional info by contributor address
1120    */
1121   function getInfoAdditionl(address addr) private view returns(uint, bool, bool) {
1122     return(receivedPreSaleBonus[contributorIds[addr]], receivedCoin[contributorIds[addr]], refundUserIds[contributorIds[addr]]);
1123   }
1124 
1125   /**
1126    * @dev Returns payments info by userId in json
1127    */
1128   function getArrayjsonPaymentInfo(uint uId) private view returns (string) {
1129     string memory _array = "{";
1130     for (uint i = 0; i < contributorPayIds[uId].length; i++) {
1131       _array = strConcat(_array, getJsonPaymentInfo(contributorList[uId].paymentInfo[contributorPayIds[uId][i]], contributorPayIds[uId][i]), (i+1 == contributorPayIds[uId].length) ? "}" : ",");
1132     }
1133     return _array;
1134   }
1135 
1136   /**
1137    * @dev Returns payment info by payment data in json
1138    */
1139   function getJsonPaymentInfo(PaymentData memory _obj, uint payId) private view returns (string) {
1140     return strConcat(
1141       strConcat("\"", uint2str(payId), "\":{", strConcat("\"", "time", "\":"), uint2str(_obj.time)),
1142       strConcat(",\"pType\":\"", bytes32ToString(_obj.pType), "\",\"currencyUSD\":", uint2str(_obj.currencyUSD), ",\"payValue\":\""),
1143       strConcat(uint2str(_obj.payValue), "\",\"totalToken\":\"", uint2str(_obj.totalToken), "\",\"tokenWithoutBonus\":\"", uint2str(_obj.tokenWithoutBonus)),
1144       strConcat("\",\"tokenBonus\":\"", uint2str(_obj.tokenBonus), "\",\"bonusPercent\":", uint2str(_obj.bonusPercent)),
1145       strConcat(",\"usdAbsRaisedInCents\":\"", uint2str(_obj.usdAbsRaisedInCents), "\",\"refund\":\"", (refundPayIds[payId] ? "1" : "0"), "\"}")
1146     );
1147   }
1148 
1149   /**
1150    * @dev Check if value contains array
1151    */
1152   function inArray(address[] _array, address _value) private pure returns(bool result) {
1153     if (_array.length == 0 || _value == address(0)) {
1154       return false;
1155     }
1156     result = false;
1157     for (uint i = 0; i < _array.length; i++) {
1158       if (_array[i] == _value) {
1159         result = true;
1160         return true;
1161       }
1162     }
1163   }
1164 
1165   /**
1166    * @dev Check if value contains array
1167    */
1168   function inArray(uint[] _array, uint _value) private pure returns(bool result) {
1169     if (_array.length == 0 || _value == 0) {
1170       return false;
1171     }
1172     result = false;
1173     for (uint i = 0; i < _array.length; i++) {
1174       if (_array[i] == _value) {
1175         result = true;
1176         return true;
1177       }
1178     }
1179   }
1180 
1181   /**
1182    * @dev Check if value contains array
1183    */
1184   function inArray(bytes32[] _array, bytes32 _value) private pure returns(bool result) {
1185     if (_array.length == 0 || _value.length == 0) {
1186       return false;
1187     }
1188     result = false;
1189     for (uint i = 0; i < _array.length; i++) {
1190       if (_array[i] == _value) {
1191         result = true;
1192         return true;
1193       }
1194     }
1195   }
1196 
1197   /**
1198    * @dev Remove value from arary
1199    */
1200   function removeValueFromArray(address[] _array, address _value) private pure returns(address[]) {
1201     address[] memory arrayNew = new address[](_array.length-1);
1202     if (arrayNew.length == 0) {
1203       return arrayNew;
1204     }
1205     uint i1 = 0;
1206     for (uint i = 0; i < _array.length; i++) {
1207       if (_array[i] != _value) {
1208         arrayNew[i1++] = _array[i];
1209       }
1210     }
1211     return arrayNew;
1212   }
1213 
1214 }