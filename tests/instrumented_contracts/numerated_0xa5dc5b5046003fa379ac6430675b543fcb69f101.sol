1 pragma solidity ^0.4.19;
2 
3 contract IGold {
4 
5     function balanceOf(address _owner) public constant returns (uint256);
6     function issueTokens(address _who, uint _tokens) public;
7     function burnTokens(address _who, uint _tokens) public;
8 }
9 
10 // StdToken inheritance is commented, because no 'totalSupply' needed
11 contract IMNTP { /*is StdToken */
12 
13     function balanceOf(address _owner) public constant returns (uint256);
14 
15     // Additional methods that MNTP contract provides
16     function lockTransfer(bool _lock) public;
17     function issueTokens(address _who, uint _tokens) public;
18     function burnTokens(address _who, uint _tokens) public;
19 }
20 
21 contract SafeMath {
22 
23     function safeAdd(uint a, uint b) internal returns (uint) {
24         uint c = a + b;
25         assert(c>=a && c>=b);
26         return c;
27      }
28 
29     function safeSub(uint a, uint b) internal returns (uint) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34    function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
35         if (a == 0) {
36             return 0;
37         }
38         c = a * b;
39         assert(c / a == b);
40 
41         return c;
42     }
43 
44   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
45         // assert(b > 0); // Solidity automatically throws when dividing by 0
46         // uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48         return a / b;
49     }
50 }
51 
52 contract CreatorEnabled {
53 
54     address public creator = 0x0;
55 
56     modifier onlyCreator() { require(msg.sender == creator); _; }
57 
58     function changeCreator(address _to) public onlyCreator {
59         creator = _to;
60     }
61 }
62 
63 contract StringMover {
64 
65     function stringToBytes32(string s) public constant returns(bytes32){
66         bytes32 out;
67         assembly {
68              out := mload(add(s, 32))
69         }
70         return out;
71     }
72 
73     function stringToBytes64(string s) public constant returns(bytes32,bytes32){
74         bytes32 out;
75         bytes32 out2;
76 
77         assembly {
78              out := mload(add(s, 32))
79              out2 := mload(add(s, 64))
80         }
81         return (out,out2);
82     }
83 
84     function bytes32ToString(bytes32 x) public constant returns (string) {
85         bytes memory bytesString = new bytes(32);
86         uint charCount = 0;
87         for (uint j = 0; j < 32; j++) {
88              byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
89              if (char != 0) {
90                   bytesString[charCount] = char;
91                   charCount++;
92              }
93         }
94         bytes memory bytesStringTrimmed = new bytes(charCount);
95         for (j = 0; j < charCount; j++) {
96              bytesStringTrimmed[j] = bytesString[j];
97         }
98         return string(bytesStringTrimmed);
99     }
100 
101     function bytes64ToString(bytes32 x, bytes32 y) public constant returns (string) {
102         bytes memory bytesString = new bytes(64);
103         uint charCount = 0;
104 
105         for (uint j = 0; j < 32; j++) {
106              byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
107              if (char != 0) {
108                   bytesString[charCount] = char;
109                   charCount++;
110              }
111         }
112         for (j = 0; j < 32; j++) {
113              char = byte(bytes32(uint(y) * 2 ** (8 * j)));
114              if (char != 0) {
115                   bytesString[charCount] = char;
116                   charCount++;
117              }
118         }
119 
120         bytes memory bytesStringTrimmed = new bytes(charCount);
121         for (j = 0; j < charCount; j++) {
122              bytesStringTrimmed[j] = bytesString[j];
123         }
124         return string(bytesStringTrimmed);
125     }
126 }
127 
128 
129 contract Storage is SafeMath, StringMover {
130 
131     function Storage() public {
132         controllerAddress = msg.sender;
133     }
134 
135     address public controllerAddress = 0x0;
136     modifier onlyController() { require(msg.sender==controllerAddress); _; }
137 
138     function setControllerAddress(address _newController) public onlyController {
139         controllerAddress = _newController;
140     }
141 
142     address public hotWalletAddress = 0x0;
143 
144     function setHotWalletAddress(address _address) public onlyController {
145        hotWalletAddress = _address;
146     }
147 
148 
149     // Fields - 1
150     mapping(uint => string) docs;
151     uint public docCount = 0;
152 
153     // Fields - 2
154     mapping(string => mapping(uint => int)) fiatTxs;
155     mapping(string => uint) fiatBalancesCents;
156     mapping(string => uint) fiatTxCounts;
157     uint fiatTxTotal = 0;
158 
159     // Fields - 3
160     mapping(string => mapping(uint => int)) goldTxs;
161     mapping(string => uint) goldHotBalances;
162     mapping(string => uint) goldTxCounts;
163     uint goldTxTotal = 0;
164 
165     // Fields - 4
166     struct Request {
167         address sender;
168         string userId;
169         uint reference;
170         bool buyRequest;         // otherwise - sell
171         uint inputAmount;
172         // 0 - init
173         // 1 - processed
174         // 2 - cancelled
175         uint8 state;
176         uint outputAmount;
177     }
178 
179     mapping (uint=>Request) requests;
180     uint public requestsCount = 0;
181 
182     ///////
183     function addDoc(string _ipfsDocLink) public onlyController returns(uint) {
184         docs[docCount] = _ipfsDocLink;
185         uint out = docCount;
186         docCount++;
187 
188         return out;
189     }
190 
191     function getDocCount() public constant returns (uint) {
192         return docCount;
193     }
194 
195     function getDocAsBytes64(uint _index) public constant returns (bytes32,bytes32) {
196         require(_index < docCount);
197         return stringToBytes64(docs[_index]);
198     }
199 
200     function addFiatTransaction(string _userId, int _amountCents) public onlyController returns(uint) {
201         require(0 != _amountCents);
202 
203         uint c = fiatTxCounts[_userId];
204 
205         fiatTxs[_userId][c] = _amountCents;
206 
207         if (_amountCents > 0) {
208             fiatBalancesCents[_userId] = safeAdd(fiatBalancesCents[_userId], uint(_amountCents));
209         } else {
210             fiatBalancesCents[_userId] = safeSub(fiatBalancesCents[_userId], uint(-_amountCents));
211         }
212 
213         fiatTxCounts[_userId] = safeAdd(fiatTxCounts[_userId], 1);
214 
215         fiatTxTotal++;
216         return c;
217     }
218 
219     function getFiatTransactionsCount(string _userId) public constant returns (uint) {
220         return fiatTxCounts[_userId];
221     }
222 
223     function getAllFiatTransactionsCount() public constant returns (uint) {
224         return fiatTxTotal;
225     }
226 
227     function getFiatTransaction(string _userId, uint _index) public constant returns(int) {
228         require(_index < fiatTxCounts[_userId]);
229         return fiatTxs[_userId][_index];
230     }
231 
232     function getUserFiatBalance(string _userId) public constant returns(uint) {
233         return fiatBalancesCents[_userId];
234     }
235 
236     function addGoldTransaction(string _userId, int _amount) public onlyController returns(uint) {
237         require(0 != _amount);
238 
239         uint c = goldTxCounts[_userId];
240 
241         goldTxs[_userId][c] = _amount;
242 
243         if (_amount > 0) {
244             goldHotBalances[_userId] = safeAdd(goldHotBalances[_userId], uint(_amount));
245         } else {
246             goldHotBalances[_userId] = safeSub(goldHotBalances[_userId], uint(-_amount));
247         }
248 
249         goldTxCounts[_userId] = safeAdd(goldTxCounts[_userId], 1);
250 
251         goldTxTotal++;
252         return c;
253     }
254 
255     function getGoldTransactionsCount(string _userId) public constant returns (uint) {
256         return goldTxCounts[_userId];
257     }
258 
259     function getAllGoldTransactionsCount() public constant returns (uint) {
260         return goldTxTotal;
261     }
262 
263     function getGoldTransaction(string _userId, uint _index) public constant returns(int) {
264         require(_index < goldTxCounts[_userId]);
265         return goldTxs[_userId][_index];
266     }
267 
268     function getUserHotGoldBalance(string _userId) public constant returns(uint) {
269         return goldHotBalances[_userId];
270     }
271 
272     function addBuyTokensRequest(address _who, string _userId, uint _reference, uint _amount) public onlyController returns(uint) {
273 
274         Request memory r;
275         r.sender = _who;
276         r.userId = _userId;
277         r.reference = _reference;
278         r.buyRequest = true;
279         r.inputAmount = _amount;
280         r.state = 0;
281 
282         requests[requestsCount] = r;
283         uint out = requestsCount;
284         requestsCount++;
285         return out;
286     }
287 
288     function addSellTokensRequest(address _who, string _userId, uint _reference, uint _amount) public onlyController returns(uint) {
289         Request memory r;
290         r.sender = _who;
291         r.userId = _userId;
292         r.reference = _reference;
293         r.buyRequest = false;
294         r.inputAmount = _amount;
295         r.state = 0;
296 
297         requests[requestsCount] = r;
298         uint out = requestsCount;
299         requestsCount++;
300         return out;
301     }
302 
303     function getRequestsCount() public constant returns(uint) {
304         return requestsCount;
305     }
306 
307     function getRequest(uint _index) public constant returns(address, bytes32, uint, bool, uint8, uint) {
308         require(_index < requestsCount);
309 
310         Request memory r = requests[_index];
311 
312         bytes32 userBytes = stringToBytes32(r.userId);
313 
314         return (r.sender, userBytes, r.reference, r.buyRequest, r.state, r.inputAmount);
315     }
316     
317     function getRequestBaseInfo(uint _index) public constant returns(address, uint8, uint, uint) {
318         require(_index < requestsCount);
319 
320         Request memory r = requests[_index];
321 
322         return (r.sender, r.state, r.inputAmount, r.outputAmount);
323     }
324 
325     function cancelRequest(uint _index) onlyController public {
326         require(_index < requestsCount);
327         require(0==requests[_index].state);
328 
329         requests[_index].state = 2;
330     }
331 
332     function setRequestFailed(uint _index) onlyController public {
333         require(_index < requestsCount);
334         require(0==requests[_index].state);
335 
336         requests[_index].state = 3;
337     }
338 
339     function setRequestProcessed(uint _index, uint _outputAmount) onlyController public {
340         require(_index < requestsCount);
341         require(0==requests[_index].state);
342 
343         requests[_index].state = 1;
344         requests[_index].outputAmount = _outputAmount;
345     }
346 }
347 
348 contract GoldIssueBurnFee is CreatorEnabled, StringMover {
349 
350     string gmUserId = "";
351 
352     // Functions:
353     function GoldIssueBurnFee(string _gmUserId) public {
354         creator = msg.sender;
355         gmUserId = _gmUserId;
356     }
357 
358     function getGoldmintFeeAccount() public constant returns(bytes32) {
359         bytes32 userBytes = stringToBytes32(gmUserId);
360         return userBytes;
361     }
362 
363     function setGoldmintFeeAccount(string _gmUserId) public onlyCreator {
364         gmUserId = _gmUserId;
365     }
366 
367     function calculateIssueGoldFee(uint _mntpBalance, uint _value, bool _forFiat) public constant returns(uint) {
368         return 0;
369     }
370 
371     function calculateBurnGoldFee(uint _mntpBalance, uint _value, bool _forFiat) public constant returns(uint) {
372 
373         // if burn is for crypocurrencies, then fee is 0.1%
374         if (!_forFiat) return (1 * _value / 1000);
375 
376 
377         // If the sender holds 0 MNTP, then the fee is 3%,
378         // If the sender holds at least 10 MNTP, then the fee is 2%,
379         // If the sender holds at least 1000 MNTP, then the fee is 1.5%,
380         // If the sender holds at least 10000 MNTP, then the fee is 1%,
381         if (_mntpBalance >= (10000 * 1 ether)) {
382              return (75 * _value / 10000);
383         }
384 
385         if (_mntpBalance >= (1000 * 1 ether)) {
386              return (15 * _value / 1000);
387         }
388 
389         if (_mntpBalance >= (10 * 1 ether)) {
390              return (25 * _value / 1000);
391         }
392 
393         // 3%
394         return (3 * _value / 100);
395     }
396 }
397 
398 contract IGoldIssueBurnFee {
399 
400     function getGoldmintFeeAccount()public constant returns(bytes32);
401     function calculateIssueGoldFee(uint _mntpBalance, uint _goldValue, bool _forFiat) public constant returns(uint);
402     function calculateBurnGoldFee(uint _mntpBalance, uint _goldValue, bool _forFiat) public constant returns(uint);
403 }
404 
405 contract StorageController is SafeMath, CreatorEnabled, StringMover {
406 
407     Storage public stor;
408     IMNTP public mntpToken;
409     IGold public goldToken;
410     IGoldIssueBurnFee public goldIssueBurnFee;
411 
412     address public managerAddress = 0x0;
413 
414     event TokenBuyRequest(address _from, string _userId, uint _reference, uint _amount, uint indexed _index);
415     event TokenSellRequest(address _from, string _userId, uint _reference, uint _amount, uint indexed _index);
416     event RequestCancelled(uint indexed _index);
417     event RequestProcessed(uint indexed _index);
418     event RequestFailed(uint indexed _index);
419 
420     modifier onlyManagerOrCreator() { require(msg.sender == managerAddress || msg.sender == creator); _; }
421 
422     function StorageController(address _mntpContractAddress, address _goldContractAddress, address _storageAddress, address _goldIssueBurnFeeContract) public {
423         creator = msg.sender;
424 
425         if (0 != _storageAddress) {
426              // use existing storage
427              stor = Storage(_storageAddress);
428         } else {
429              stor = new Storage();
430         }
431 
432         require(0x0!=_mntpContractAddress);
433         require(0x0!=_goldContractAddress);
434         require(0x0!=_goldIssueBurnFeeContract);
435 
436         mntpToken = IMNTP(_mntpContractAddress);
437         goldToken = IGold(_goldContractAddress);
438         goldIssueBurnFee = IGoldIssueBurnFee(_goldIssueBurnFeeContract);
439     }
440 
441     function setManagerAddress(address _address) public onlyCreator {
442        managerAddress = _address;
443     }
444 
445     // Only old controller can call setControllerAddress
446     function changeController(address _newController) public onlyCreator {
447         stor.setControllerAddress(_newController);
448     }
449 
450     function setHotWalletAddress(address _hotWalletAddress) public onlyCreator {
451        stor.setHotWalletAddress(_hotWalletAddress);
452     }
453 
454     function getHotWalletAddress() public constant returns (address) {
455         return stor.hotWalletAddress();
456     }
457 
458     function changeGoldIssueBurnFeeContract(address _goldIssueBurnFeeAddress) public onlyCreator {
459         goldIssueBurnFee = IGoldIssueBurnFee(_goldIssueBurnFeeAddress);
460     }
461 
462     function addDoc(string _ipfsDocLink) public onlyManagerOrCreator returns(uint) {
463         return stor.addDoc(_ipfsDocLink);
464     }
465 
466     function getDocCount() public constant returns (uint) {
467         return stor.getDocCount();
468     }
469 
470     function getDoc(uint _index) public constant returns (string) {
471         bytes32 x;
472         bytes32 y;
473         (x, y) = stor.getDocAsBytes64(_index);
474         return bytes64ToString(x,y);
475     }
476 
477 
478     function addGoldTransaction(string _userId, int _amount) public onlyManagerOrCreator returns(uint) {
479         return stor.addGoldTransaction(_userId, _amount);
480     }
481 
482     function getGoldTransactionsCount(string _userId) public constant returns (uint) {
483         return stor.getGoldTransactionsCount(_userId);
484     }
485 
486     function getAllGoldTransactionsCount() public constant returns (uint) {
487         return stor.getAllGoldTransactionsCount();
488     }
489 
490     function getGoldTransaction(string _userId, uint _index) public constant returns(int) {
491         require(keccak256(_userId) != keccak256(""));
492 
493         return stor.getGoldTransaction(_userId, _index);
494     }
495 
496     function getUserHotGoldBalance(string _userId) public constant returns(uint) {
497         require(keccak256(_userId) != keccak256(""));
498 
499         return stor.getUserHotGoldBalance(_userId);
500     }
501 
502     function addBuyTokensRequest(string _userId, uint _reference) public payable returns(uint) {
503         require(keccak256(_userId) != keccak256(""));
504         require(msg.value > 0);
505 
506         uint reqIndex = stor.addBuyTokensRequest(msg.sender, _userId, _reference, msg.value);
507 
508         TokenBuyRequest(msg.sender, _userId, _reference, msg.value, reqIndex);
509 
510         return reqIndex;
511     }
512 
513     function addSellTokensRequest(string _userId, uint _reference, uint _amount) public returns(uint) {
514         require(keccak256(_userId) != keccak256(""));
515         require(_amount > 0);
516 
517         uint tokenBalance = goldToken.balanceOf(msg.sender);
518 
519         require(tokenBalance >= _amount);
520 
521         burnGoldTokens(msg.sender, _amount);
522 
523         uint reqIndex = stor.addSellTokensRequest(msg.sender, _userId, _reference, _amount);
524 
525         TokenSellRequest(msg.sender, _userId, _reference, _amount, reqIndex);
526 
527         return reqIndex;
528     }
529 
530     function getRequestsCount() public constant returns(uint) {
531         return stor.getRequestsCount();
532     }
533 
534     function getRequest(uint _index) public constant returns(address, string, uint, bool, uint8, uint) {
535         address sender;
536         bytes32 userIdBytes;
537         uint reference;
538         bool buy;
539         uint8 state;
540         uint inputAmount;
541 
542         (sender, userIdBytes, reference, buy, state, inputAmount) = stor.getRequest(_index);
543 
544         string memory userId = bytes32ToString(userIdBytes);
545         
546         return (sender, userId, reference, buy, state, inputAmount);
547     }
548     
549     function getRequestBaseInfo(uint _index) public constant returns(address, uint8, uint, uint) {
550         return stor.getRequestBaseInfo(_index);
551     }
552 
553     function cancelRequest(uint _index) onlyManagerOrCreator public {
554 
555         address sender;
556         string memory userId;
557         uint reference;
558         bool isBuy;
559         uint state;
560         uint inputAmount;
561         (sender, userId, reference, isBuy, state, inputAmount) = getRequest(_index);
562         require(0 == state);
563 
564         if (isBuy) {
565             sender.transfer(inputAmount);
566         } else {
567             goldToken.issueTokens(sender, inputAmount);
568         }
569 
570         stor.cancelRequest(_index);
571 
572         RequestCancelled(_index);
573     }
574 
575     function processRequest(uint _index, uint _weiPerGold, uint _discountPercent) onlyManagerOrCreator public returns(bool) {
576         require(_index < getRequestsCount());
577 
578         address sender;
579         string memory userId;
580         uint reference;
581         bool isBuy;
582         uint state;
583         uint inputAmount;
584         
585         (sender, userId, reference, isBuy, state, inputAmount) = getRequest(_index);
586         require(0 == state);
587 
588         bool processResult = false;
589         uint outputAmount = 0;
590 
591         if (isBuy) {
592             (processResult, outputAmount) = processBuyRequest(userId, sender, inputAmount, _weiPerGold, false, _discountPercent);
593         } else {
594             (processResult, outputAmount) = processSellRequest(userId, sender, inputAmount, _weiPerGold, false);
595         }
596 
597         if (processResult) {
598             stor.setRequestProcessed(_index, outputAmount);
599             RequestProcessed(_index);
600         } else {
601             stor.setRequestFailed(_index);
602             RequestFailed(_index);
603         }
604 
605         return processResult;
606     }
607 
608     function processBuyRequestFiat(string _userId, uint _reference, address _userAddress, uint _amountCents, uint _centsPerGold) onlyManagerOrCreator public returns(bool) {
609       
610       uint reqIndex = stor.addBuyTokensRequest(_userAddress, _userId, _reference, _amountCents);
611 
612       bool processResult = false;
613       uint outputAmount = 0;
614         
615       (processResult, outputAmount) = processBuyRequest(_userId, _userAddress, _amountCents * 1 ether, _centsPerGold * 1 ether, true, 0);
616 
617       if (processResult) {
618         stor.setRequestProcessed(reqIndex, outputAmount);
619         RequestProcessed(reqIndex);
620       } else {
621         stor.setRequestFailed(reqIndex);
622         RequestFailed(reqIndex);
623       }
624 
625       return processResult;
626     }
627 
628     function processSellRequestFiat(uint _index, uint _centsPerGold) onlyManagerOrCreator public returns(bool) {
629         require(_index < getRequestsCount());
630 
631         address sender;
632         string memory userId;
633         uint reference;
634         bool isBuy;
635         uint state;
636         uint inputAmount;
637         (sender, userId, reference, isBuy, state, inputAmount) = getRequest(_index);
638         require(0 == state);
639 
640         
641         // fee
642         uint userMntpBalance = mntpToken.balanceOf(sender);
643         uint fee = goldIssueBurnFee.calculateBurnGoldFee(userMntpBalance, inputAmount, true);
644 
645         require(inputAmount > fee);
646 
647         if (fee > 0) {
648              inputAmount = safeSub(inputAmount, fee);
649         }
650 
651         require(inputAmount > 0);
652 
653         uint resultAmount = inputAmount * _centsPerGold / 1 ether;
654         
655         stor.setRequestProcessed(_index, resultAmount);
656         RequestProcessed(_index);
657         
658         return true;
659     }
660 
661     function processBuyRequest(string _userId, address _userAddress, uint _amountWei, uint _weiPerGold, bool _isFiat, uint _discountPercent) internal returns(bool, uint) {
662         require(keccak256(_userId) != keccak256(""));
663 
664         uint userMntpBalance = mntpToken.balanceOf(_userAddress);
665         uint fee = goldIssueBurnFee.calculateIssueGoldFee(userMntpBalance, _amountWei, _isFiat);
666         require(_amountWei > fee);
667 
668         // issue tokens minus fee
669         uint amountWeiMinusFee = _amountWei;
670         if (fee > 0) {
671             amountWeiMinusFee = safeSub(_amountWei, fee);
672         }
673 
674         require(amountWeiMinusFee > 0);
675 
676         uint tokensWei = safeDiv(uint(amountWeiMinusFee) * 1 ether, _weiPerGold);
677         
678         //discount
679         tokensWei = SafeMath.safeAdd(tokensWei, calcPercent(tokensWei, _discountPercent));
680 
681         issueGoldTokens(_userAddress, tokensWei);
682 
683         // request from hot wallet
684         if (isHotWallet(_userAddress)) {
685             addGoldTransaction(_userId, int(tokensWei));
686         }
687 
688         return (true, tokensWei);
689     }
690 
691     function processSellRequest(string _userId, address _userAddress, uint _amountWei, uint _weiPerGold, bool _isFiat) internal returns(bool, uint) {
692         require(keccak256(_userId) != keccak256(""));
693 
694         uint amountWei = safeMul(_amountWei, _weiPerGold) / 1 ether;
695 
696         require(amountWei > 0);
697         // request from hot wallet
698         if (isHotWallet(_userAddress)) {
699             // TODO: overflow
700             addGoldTransaction(_userId, - int(_amountWei));
701         }
702 
703         // fee
704         uint userMntpBalance = mntpToken.balanceOf(_userAddress);
705         uint fee = goldIssueBurnFee.calculateBurnGoldFee(userMntpBalance, amountWei, _isFiat);
706 
707         require(amountWei > fee);
708 
709         uint amountWeiMinusFee = amountWei;
710 
711         if (fee > 0) {
712              amountWeiMinusFee = safeSub(amountWei, fee);
713         }
714 
715         require(amountWeiMinusFee > 0);
716 
717         if (amountWeiMinusFee > this.balance) {
718             issueGoldTokens(_userAddress, _amountWei);
719             return (false, 0);
720         }
721 
722         _userAddress.transfer(amountWeiMinusFee);
723 
724         return (true, amountWeiMinusFee);
725     }
726 
727 
728 
729     //////// INTERNAL REQUESTS FROM HOT WALLET
730     function processInternalRequest(string _userId, bool _isBuy, uint _amountCents, uint _centsPerGold, uint _discountPercent) onlyManagerOrCreator public {
731       if (_isBuy) {
732           processBuyRequest(_userId, getHotWalletAddress(), _amountCents, _centsPerGold, true, _discountPercent);
733       } else {
734           processSellRequest(_userId, getHotWalletAddress(), _amountCents, _centsPerGold, true);
735       }
736     }
737 
738     function transferGoldFromHotWallet(address _to, uint _value, string _userId) onlyManagerOrCreator public {
739       require(keccak256(_userId) != keccak256(""));
740 
741       uint balance = getUserHotGoldBalance(_userId);
742       require(balance >= _value);
743 
744       goldToken.burnTokens(getHotWalletAddress(), _value);
745       goldToken.issueTokens(_to, _value);
746 
747       addGoldTransaction(_userId, -int(_value));
748     }
749 
750 
751     function withdrawEth(address _userAddress, uint _value) onlyManagerOrCreator public {
752         require(_value >= 0.1 * 1 ether);
753 
754         if (this.balance < _value) _value = this.balance;
755 
756         _userAddress.transfer(_value);
757     }
758 
759     function withdrawTokens(address _userAddress, uint _value) onlyManagerOrCreator public {
760         burnGoldTokens(address(this), _value);
761 
762         issueGoldTokens(_userAddress, _value);
763     }
764 
765     ////////
766     function issueGoldTokens(address _userAddress, uint _tokenAmount) internal {
767         require(0!=_tokenAmount);
768         goldToken.issueTokens(_userAddress, _tokenAmount);
769     }
770 
771     function burnGoldTokens(address _userAddress, uint _tokenAmount) internal {
772         require(0!=_tokenAmount);
773         goldToken.burnTokens(_userAddress, _tokenAmount);
774     }
775 
776     function isHotWallet(address _address) internal returns(bool) {
777        return _address == getHotWalletAddress();
778     }
779     
780     function calcPercent(uint256 amount, uint256 percent) public pure returns(uint256) {
781         return SafeMath.safeDiv(SafeMath.safeMul(SafeMath.safeDiv(amount, 100), percent), 1 ether);
782     }
783 
784          // Default fallback function
785     function() payable {
786     }
787 }