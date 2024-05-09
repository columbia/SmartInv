1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract ICurrency {
6   function getUsdAbsRaisedInCents() external view returns(uint);
7   function getCoinRaisedBonusInWei() external view returns(uint);
8   function getCoinRaisedInWei() public view returns(uint);
9   function getUsdFromETH(uint ethWei) public view returns(uint);
10   function getTokenFromETH(uint ethWei) public view returns(uint);
11   function getCurrencyRate(string _ticker) public view returns(uint);
12   function addPay(string _ticker, uint value, uint usdAmount, uint coinRaised, uint coinRaisedBonus) public returns(bool);
13   function checkTickerExists(string ticker) public view returns(bool);
14   function getUsdFromCurrency(string ticker, uint value) public view returns(uint);
15   function getUsdFromCurrency(string ticker, uint value, uint usd) public view returns(uint);
16   function getUsdFromCurrency(bytes32 ticker, uint value) public view returns(uint);
17   function getUsdFromCurrency(bytes32 ticker, uint value, uint usd) public view returns(uint);
18   function getTokenWeiFromUSD(uint usdCents) public view returns(uint);
19   function editPay(bytes32 ticker, uint currencyValue, uint currencyUsdRaised, uint _usdAbsRaisedInCents, uint _coinRaisedInWei, uint _coinRaisedBonusInWei) public returns(bool);
20   function getCurrencyList(string ticker) public view returns(bool active, uint usd, uint devision, uint raised, uint usdRaised, uint usdRaisedExchangeRate, uint counter, uint lastUpdate);
21   function getCurrencyList(bytes32 ticker) public view returns(bool active, uint usd, uint devision, uint raised, uint usdRaised, uint usdRaisedExchangeRate, uint counter, uint lastUpdate);
22   function getTotalUsdRaisedInCents() public view returns(uint);
23   function getAllCurrencyTicker() public view returns(string);
24   function getCoinUSDRate() public view  returns(uint);
25   function addPreSaleBonus(uint bonusToken) public returns(bool);
26   function editPreSaleBonus(uint beforeBonus, uint afterBonus) public returns(bool);
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 /**
80  * @title String
81  * @dev ConcatenationString, uintToString, stringsEqual, stringToBytes32, bytes32ToString
82  */
83 contract String {
84 
85   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string memory) {
86     bytes memory _ba = bytes(_a);
87     bytes memory _bb = bytes(_b);
88     bytes memory _bc = bytes(_c);
89     bytes memory _bd = bytes(_d);
90     bytes memory _be = bytes(_e);
91     bytes memory abcde = bytes(new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length));
92     uint k = 0;
93     uint i;
94     for (i = 0; i < _ba.length; i++) {
95       abcde[k++] = _ba[i];
96     }
97     for (i = 0; i < _bb.length; i++) {
98       abcde[k++] = _bb[i];
99     }
100     for (i = 0; i < _bc.length; i++) {
101       abcde[k++] = _bc[i];
102     }
103     for (i = 0; i < _bd.length; i++) {
104       abcde[k++] = _bd[i];
105     }
106     for (i = 0; i < _be.length; i++) {
107       abcde[k++] = _be[i];
108     }
109     return string(abcde);
110   }
111 
112   function strConcat(string _a, string _b, string _c, string _d) internal pure returns(string) {
113     return strConcat(_a, _b, _c, _d, "");
114   }
115 
116   function strConcat(string _a, string _b, string _c) internal pure returns(string) {
117     return strConcat(_a, _b, _c, "", "");
118   }
119 
120   function strConcat(string _a, string _b) internal pure returns(string) {
121     return strConcat(_a, _b, "", "", "");
122   }
123 
124   function uint2str(uint i) internal pure returns(string) {
125     if (i == 0) {
126       return "0";
127     }
128     uint j = i;
129     uint length;
130     while (j != 0) {
131       length++;
132       j /= 10;
133     }
134     bytes memory bstr = new bytes(length);
135     uint k = length - 1;
136     while (i != 0) {
137       bstr[k--] = byte(uint8(48 + i % 10));
138       i /= 10;
139     }
140     return string(bstr);
141   }
142 
143   function stringsEqual(string memory _a, string memory _b) internal pure returns(bool) {
144     bytes memory a = bytes(_a);
145     bytes memory b = bytes(_b);
146 
147     if (a.length != b.length)
148       return false;
149 
150     for (uint i = 0; i < a.length; i++) {
151       if (a[i] != b[i]) {
152         return false;
153       }
154     }
155 
156     return true;
157   }
158 
159   function stringToBytes32(string memory source) internal pure returns(bytes32 result) {
160     bytes memory _tmp = bytes(source);
161     if (_tmp.length == 0) {
162       return 0x0;
163     }
164     assembly {
165       result := mload(add(source, 32))
166     }
167   }
168 
169   function bytes32ToString(bytes32 x) internal pure returns (string) {
170     bytes memory bytesString = new bytes(32);
171     uint charCount = 0;
172     uint j;
173     for (j = 0; j < 32; j++) {
174       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
175       if (char != 0) {
176         bytesString[charCount] = char;
177         charCount++;
178       }
179     }
180     bytes memory bytesStringTrimmed = new bytes(charCount);
181     for (j = 0; j < charCount; j++) {
182       bytesStringTrimmed[j] = bytesString[j];
183     }
184     return string(bytesStringTrimmed);
185   }
186 
187   function inArray(string[] _array, string _value) internal pure returns(bool result) {
188     if (_array.length == 0 || bytes(_value).length == 0) {
189       return false;
190     }
191     result = false;
192     for (uint i = 0; i < _array.length; i++) {
193       if (stringsEqual(_array[i],_value)) {
194         result = true;
195         return true;
196       }
197     }
198   }
199 }
200 
201 /**
202  * @title Ownable
203  * @dev The Ownable contract has an owner address, and provides basic authorization control
204  * functions, this simplifies the implementation of "user permissions".
205  */
206 contract Ownable {
207   address public owner;
208 
209 
210   event OwnershipRenounced(address indexed previousOwner);
211   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213 
214   /**
215    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
216    * account.
217    */
218   constructor () public {
219     owner = msg.sender;
220   }
221 
222   /**
223    * @dev Throws if called by any account other than the owner.
224    */
225   modifier onlyOwner() {
226     require(msg.sender == owner);
227     _;
228   }
229 
230   /**
231    * @dev Allows the current owner to transfer control of the contract to a newOwner.
232    * @param newOwner The address to transfer ownership to.
233    */
234   function transferOwnership(address newOwner) public onlyOwner {
235     require(newOwner != address(0));
236     emit OwnershipTransferred(owner, newOwner);
237     owner = newOwner;
238   }
239 
240   /**
241    * @dev Allows the current owner to relinquish control of the contract.
242    */
243   function renounceOwnership() public onlyOwner {
244     emit OwnershipRenounced(owner);
245     owner = address(0);
246   }
247 }
248 
249 /**
250  * @title MultiOwnable
251  * @dev The MultiOwnable contract has an owner address[], and provides basic authorization control
252  */
253 contract MultiOwnable is Ownable {
254 
255   struct Types {
256     mapping (address => bool) access;
257   }
258   mapping (uint => Types) private multiOwnersTypes;
259 
260   event AddOwner(uint _type, address addr);
261   event AddOwner(uint[] types, address addr);
262   event RemoveOwner(uint _type, address addr);
263 
264   modifier onlyMultiOwnersType(uint _type) {
265     require(multiOwnersTypes[_type].access[msg.sender] || msg.sender == owner, "403");
266     _;
267   }
268 
269   function onlyMultiOwnerType(uint _type, address _sender) public view returns(bool) {
270     if (multiOwnersTypes[_type].access[_sender] || _sender == owner) {
271       return true;
272     }
273     return false;
274   }
275 
276   function addMultiOwnerType(uint _type, address _owner) public onlyOwner returns(bool) {
277     require(_owner != address(0));
278     multiOwnersTypes[_type].access[_owner] = true;
279     emit AddOwner(_type, _owner);
280     return true;
281   }
282   
283   function addMultiOwnerTypes(uint[] types, address _owner) public onlyOwner returns(bool) {
284     require(_owner != address(0));
285     require(types.length > 0);
286     for (uint i = 0; i < types.length; i++) {
287       multiOwnersTypes[types[i]].access[_owner] = true;
288     }
289     emit AddOwner(types, _owner);
290     return true;
291   }
292 
293   function removeMultiOwnerType(uint types, address _owner) public onlyOwner returns(bool) {
294     require(_owner != address(0));
295     multiOwnersTypes[types].access[_owner] = false;
296     emit RemoveOwner(types, _owner);
297     return true;
298   }
299 }
300 
301 /**
302  * @title Convert eth,btc,eur,amb to usd and storage payment from currency
303  */
304 contract ShipCoinCurrency is ICurrency, MultiOwnable, String {
305   using SafeMath for uint256;
306 
307   uint private coinUSDRate = 12; // in wei 0.12$
308   uint private currVolPercent = 5; // 5% currency volatility
309 
310   // Amount of wei raised SHPC
311   uint256 private coinRaisedInWei = 0;
312   // Amount of cents raised USD at the time of payment
313   uint private usdAbsRaisedInCents = 0;
314   uint private coinRaisedBonusInWei = 0;
315 
316   struct CurrencyData {
317     bool active;
318     uint usd;
319     uint devision;
320     uint raised;
321     uint usdRaised;
322     uint counter;
323     uint lastUpdate;
324   }
325 
326   mapping(bytes32 => CurrencyData) private currencyList;
327 
328   bytes32[] private currencyTicker;
329 
330   /* Events */
331   event ChangeCoinUSDRate(uint oldPrice, uint newPrice);
332   event ChangeCurrVolPercent(uint oldPercent, uint newPercent);
333   event ChangeCurrency();
334   event AddPay();
335   event EditPay();
336 
337   /**
338    * @dev constructor 50328,655575,116
339    * @param _ethPrice in cents example 58710 = 587.10$
340    * @param _btcPrice in cents example 772301 = 7723.01$
341    * @param _eurPrice in cents example 117 = 1.17$
342    * @param _ambPrice in cents example 18 = 0.18$
343    */
344   constructor(uint _ethPrice, uint _btcPrice, uint _eurPrice, uint _ambPrice) public {
345 
346     require(addUpdateCurrency("ETH", _ethPrice, (1 ether)));
347     require(addUpdateCurrency("BTC", _btcPrice, (10**8)));
348     require(addUpdateCurrency("USD", 1, 1));
349     require(addUpdateCurrency("EUR", _eurPrice, 100));
350     require(addUpdateCurrency("AMB", _ambPrice, (1 ether)));
351 
352   }
353 
354   /**
355    * @dev Returns the collected amount in dollars. Summarize at the rate when the payment was made.
356    */
357   function getUsdAbsRaisedInCents() external view returns(uint) {
358     return usdAbsRaisedInCents;
359   }
360 
361   /**
362    * @dev Return the amount of SHPC sold as a bonus.
363    */
364   function getCoinRaisedBonusInWei() external view returns(uint) {
365     return coinRaisedBonusInWei;
366   }
367 
368   /**
369    * @dev Add or Update currency
370    */
371   function addUpdateCurrency(string _ticker, uint _usd, uint _devision) public returns(bool) {
372     return addUpdateCurrency(_ticker, _usd, _devision, 0, 0);
373   }
374 
375   /**
376    * @dev Add or Update currency
377    */
378   function addUpdateCurrency(string _ticker, uint _usd) public returns(bool) {
379     return addUpdateCurrency(_ticker, _usd, 0, 0, 0);
380   }
381 
382   /**
383    * @dev Add or Update currency
384    * @param _ticker string
385    * @param _usd uint rate in cents
386    * @param _devision uint
387    * @param _raised uint
388    * @param _usdRaised uint raised in usd cents
389    */
390   function addUpdateCurrency(string _ticker, uint _usd, uint _devision, uint _raised, uint _usdRaised) public onlyMultiOwnersType(1) returns(bool) {
391     require(_usd > 0, "1");
392 
393     bytes32 ticker = stringToBytes32(_ticker);
394 
395     if (!currencyList[ticker].active) {
396       currencyTicker.push(ticker);
397     }
398     currencyList[ticker] = CurrencyData({
399       active : true,
400       usd : _usd,
401       devision : (_devision == 0) ? currencyList[ticker].devision : _devision,
402       raised : currencyList[ticker].raised > 0 ? currencyList[ticker].raised : _raised,
403       usdRaised: currencyList[ticker].usdRaised > 0 ? currencyList[ticker].usdRaised : _usdRaised,
404       counter: currencyList[ticker].counter > 0 ? currencyList[ticker].counter : 0,
405       lastUpdate: block.timestamp
406     });
407 
408     return true;
409   }
410 
411   /**
412    * @dev Set SHPC price in cents
413    */
414   function setCoinUSDRate(uint _value) public onlyOwner returns(bool) {
415     require(_value > 0);
416     uint oldCoinUSDRate = coinUSDRate;
417     coinUSDRate = _value;
418     emit ChangeCoinUSDRate(oldCoinUSDRate, coinUSDRate);
419     return true;
420   }
421 
422   /**
423    * @dev Percent deducted from the amount raised getTotalUsdRaisedInCents
424    */
425   function setCurrVolPercent(uint _value) public onlyOwner returns(bool) {
426     require(_value > 0 && _value <= 10);
427     uint oldCurrVolPercent = currVolPercent;
428     currVolPercent = _value;
429     emit ChangeCurrVolPercent(oldCurrVolPercent, currVolPercent);
430     return true;
431   }
432 
433   /**
434    * @dev Returns the number of SHPC from USD
435    * @param usdCents amount of dollars in cents example 100$ = 10000
436    * @return SHPC in wei
437    */
438   function getTokenWeiFromUSD(uint usdCents) public view returns(uint) {
439     return usdCents.mul(1 ether).div(coinUSDRate); // (100.00$ * (10**18)) / 0.12$ = 833333333333333333333 SHPC wei = 833.33 SHPC
440   }
441 
442   /**
443    * @dev Returns the number of SHPC in wei
444    * @param ethWei eth в wei
445    * @return SHPC in wei
446    */
447   function getTokenFromETH(uint ethWei) public view returns(uint) {
448     return ethWei.mul(currencyList["ETH"].usd).div(coinUSDRate); // (1 ETH * 587.10$) / 0.12$ =  4892500000000000000000 SHPC wei = 4892.50 SHPC
449   }
450 
451   /**
452    * @dev Returns the amount of USD from ETH
453    * @param ethWei ETH в wei
454    * @return USD in cents
455    */
456   function getUsdFromETH(uint ethWei) public view returns(uint) {
457     return ethWei.mul(currencyList["ETH"].usd).div(1 ether);
458   }
459 
460   /**
461    * @dev Add payment data to currency
462    * @param _ticker string
463    * @param value uint
464    * @param usdAmount uint in cents
465    * @param coinRaised uint in wei
466    * @param coinRaisedBonus uint in wei (optional field)
467    */
468   function addPay(string _ticker, uint value, uint usdAmount, uint coinRaised, uint coinRaisedBonus) public onlyMultiOwnersType(2) returns(bool) {
469     require(value > 0);
470     require(usdAmount > 0);
471     require(coinRaised > 0);
472 
473     bytes32 ticker = stringToBytes32(_ticker);
474     assert(currencyList[ticker].active);
475 
476     coinRaisedInWei += coinRaised;
477     coinRaisedBonusInWei += coinRaisedBonus;
478     usdAbsRaisedInCents += usdAmount;
479 
480     currencyList[ticker].usdRaised += usdAmount;
481     currencyList[ticker].raised += value;
482     currencyList[ticker].counter++;
483 
484     emit AddPay();
485     return true;
486   }
487 
488   /**
489    * @dev Chacnge currency data when change contributor payment
490    * @param ticker bytes32
491    * @param currencyValue uint
492    * @param currencyUsdRaised uint in cents
493    * @param _usdAbsRaisedInCents uint in cents
494    * @param _coinRaisedInWei uint in wei
495    * @param _coinRaisedBonusInWei uint in wei (optional field)
496    */
497   function editPay(
498     bytes32 ticker,
499     uint currencyValue,
500     uint currencyUsdRaised,
501     uint _usdAbsRaisedInCents,
502     uint _coinRaisedInWei,
503     uint _coinRaisedBonusInWei
504   )
505   public
506   onlyMultiOwnersType(3)
507   returns(bool)
508   {
509     require(currencyValue > 0);
510     require(currencyUsdRaised > 0);
511     require(_usdAbsRaisedInCents > 0);
512     require(_coinRaisedInWei > 0);
513     assert(currencyList[ticker].active);
514 
515     coinRaisedInWei = _coinRaisedInWei;
516     coinRaisedBonusInWei = _coinRaisedBonusInWei;
517     usdAbsRaisedInCents = _usdAbsRaisedInCents;
518 
519     currencyList[ticker].usdRaised = currencyUsdRaised;
520     currencyList[ticker].raised = currencyValue;
521 
522 
523     emit EditPay();
524 
525     return true;
526   }
527 
528   /**
529    * @dev Add bonus SHPC
530    */
531   function addPreSaleBonus(uint bonusToken) public onlyMultiOwnersType(4) returns(bool) {
532     coinRaisedInWei += bonusToken;
533     coinRaisedBonusInWei += bonusToken;
534     emit EditPay();
535     return true;
536   }
537 
538   /**
539    * @dev Change bonus SHPC
540    */
541   function editPreSaleBonus(uint beforeBonus, uint afterBonus) public onlyMultiOwnersType(5) returns(bool) {
542     coinRaisedInWei -= beforeBonus;
543     coinRaisedBonusInWei -= beforeBonus;
544 
545     coinRaisedInWei += afterBonus;
546     coinRaisedBonusInWei += afterBonus;
547     emit EditPay();
548     return true;
549   }
550 
551   /**
552    * @dev Returns the sum of investments with conversion to dollars at the current rate with a deduction of interest.
553    */
554   function getTotalUsdRaisedInCents() public view returns(uint) {
555     uint totalUsdAmount = 0;
556     if (currencyTicker.length > 0) {
557       for (uint i = 0; i < currencyTicker.length; i++) {
558         if (currencyList[currencyTicker[i]].raised > 0) {
559           totalUsdAmount += getUsdFromCurrency(currencyTicker[i], currencyList[currencyTicker[i]].raised);
560         }
561       }
562     }
563     return subPercent(totalUsdAmount, currVolPercent);
564   }
565 
566   /**
567    * @dev Converts to dollars
568    */
569   function getUsdFromCurrency(string ticker, uint value) public view returns(uint) {
570     return getUsdFromCurrency(stringToBytes32(ticker), value);
571   }
572 
573   /**
574    * @dev Converts to dollars
575    */
576   function getUsdFromCurrency(string ticker, uint value, uint usd) public view returns(uint) {
577     return getUsdFromCurrency(stringToBytes32(ticker), value, usd);
578   }
579 
580   /**
581    * @dev Converts to dollars
582    */
583   function getUsdFromCurrency(bytes32 ticker, uint value) public view returns(uint) {
584     return getUsdFromCurrency(ticker, value, 0);
585   }
586 
587   /**
588    * @dev Converts to dollars
589    */
590   function getUsdFromCurrency(bytes32 ticker, uint value, uint usd) public view returns(uint) {
591     if (currencyList[ticker].active && value > 0) {
592       return value.mul(usd > 0 ? usd : currencyList[ticker].usd).div(currencyList[ticker].devision);
593     }
594     return 0;
595   }
596 
597   /**
598    * @dev Returns information about available currencies in json format
599    */
600   function getAllCurrencyTicker() public view returns(string) {
601     string memory _tickers = "{";
602     for (uint i = 0; i < currencyTicker.length; i++) {
603       _tickers = strConcat(_tickers, strConcat("\"", bytes32ToString(currencyTicker[i]), "\":"), uint2str(currencyList[currencyTicker[i]].usd), (i+1 < currencyTicker.length) ? "," : "}");
604     }
605     return _tickers;
606   }
607 
608   /**
609    * @dev Update currency rate.
610    */
611   function updateCurrency(string ticker, uint value) public onlyMultiOwnersType(6) returns(bool) {
612     bytes32 _ticker = stringToBytes32(ticker);
613     require(currencyList[_ticker].active);
614     require(value > 0);
615 
616     currencyList[_ticker].usd = value;
617     currencyList[_ticker].lastUpdate = block.timestamp;
618     emit ChangeCurrency();
619     return true;
620   }
621 
622   /**
623    * @dev Check currency is available.
624    */
625   function checkTickerExists(string ticker) public view returns(bool) {
626     return currencyList[stringToBytes32(ticker)].active;
627   }
628 
629   /**
630    * @dev Returns currency info.
631    */
632   function getCurrencyList(string ticker)
633     public
634     view
635     returns(
636       bool active,
637       uint usd,
638       uint devision,
639       uint raised,
640       uint usdRaised,
641       uint usdRaisedExchangeRate,
642       uint counter,
643       uint lastUpdate
644     )
645   {
646     return getCurrencyList(stringToBytes32(ticker));
647   }
648 
649   /**
650    * @dev Return curency info.
651    */
652   function getCurrencyList(bytes32 ticker)
653     public
654     view
655     returns(
656       bool active,
657       uint usd,
658       uint devision,
659       uint raised,
660       uint usdRaised,
661       uint usdRaisedExchangeRate,
662       uint counter,
663       uint lastUpdate
664     )
665   {
666     CurrencyData memory _obj = currencyList[ticker];
667     uint _usdRaisedExchangeRate = getUsdFromCurrency(ticker, _obj.raised);
668     return (
669       _obj.active,
670       _obj.usd,
671       _obj.devision,
672       _obj.raised,
673       _obj.usdRaised,
674       _usdRaisedExchangeRate,
675       _obj.counter,
676       _obj.lastUpdate
677     );
678   }
679 
680   function getCurrencyRate(string _ticker) public view returns(uint) {
681     return currencyList[stringToBytes32(_ticker)].usd;
682   }
683 
684   /**
685    * @dev Return all currency data in json.
686    */
687   function getCurrencyData() public view returns(string) {
688     string memory _array = "{";
689 
690     if (currencyTicker.length > 0) {
691       for (uint i = 0; i < currencyTicker.length; i++) {
692         if (currencyList[currencyTicker[i]].active) {
693           _array = strConcat(_array, strConcat("\"", bytes32ToString(currencyTicker[i]), "\":"), getJsonCurrencyData(currencyList[currencyTicker[i]]), (i+1 == currencyTicker.length) ? "}" : ",");
694         }
695       }
696     } else {
697       return "[]";
698     }
699 
700     return _array;
701   }
702 
703   /**
704    * @dev Returns the number of SHPC sold
705    */
706   function getCoinRaisedInWei() public view returns(uint) {
707     return coinRaisedInWei;
708   }
709 
710   /**
711    * @dev Returns SHPC price in cents
712    */
713   function getCoinUSDRate() public view returns(uint) {
714     return coinUSDRate;
715   }
716 
717   /**
718    * @dev Returns percent.
719    */
720   function getCurrVolPercent() public view returns(uint) {
721     return currVolPercent;
722   }
723 
724   /**
725    * @dev Returns json info from currency
726    */
727   function getJsonCurrencyData(CurrencyData memory _obj) private pure returns (string) {
728     return strConcat(
729       strConcat("{\"usd\":", uint2str(_obj.usd), ",\"devision\":", uint2str(_obj.devision), ",\"raised\":\""),
730       strConcat(uint2str(_obj.raised), "\",\"usdRaised\":", uint2str(_obj.usdRaised), ",\"usdRaisedCurrency\":", uint2str((_obj.raised.mul(_obj.usd).div(_obj.devision)))),
731       strConcat(",\"counter\":", uint2str(_obj.counter), ",\"lastUpdate\":", uint2str(_obj.lastUpdate), "}")
732     );
733   }
734 
735   /**
736    * @dev Calculate the percentage of the amount
737    * example: 100 - 5% = 95
738    */
739   function subPercent(uint a, uint b) private pure returns(uint) {
740     uint c = (a / 100) * b;
741     assert(c <= a);
742     return a - c;
743   }
744 
745 }