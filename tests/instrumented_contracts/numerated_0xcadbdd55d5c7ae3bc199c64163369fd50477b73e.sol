1 pragma solidity ^0.4.19;
2 
3 contract IGold {
4     function balanceOf(address _owner) constant returns (uint256);
5     function issueTokens(address _who, uint _tokens);
6     function burnTokens(address _who, uint _tokens);
7 }
8 
9 // StdToken inheritance is commented, because no 'totalSupply' needed
10 contract IMNTP { /*is StdToken */
11     function balanceOf(address _owner) constant returns (uint256);
12 
13     // Additional methods that MNTP contract provides
14     function lockTransfer(bool _lock);
15     function issueTokens(address _who, uint _tokens);
16     function burnTokens(address _who, uint _tokens);
17 }
18 
19 contract SafeMath {
20     function safeAdd(uint a, uint b) internal returns (uint) {
21         uint c = a + b;
22         assert(c>=a && c>=b);
23         return c;
24      }
25 
26     function safeSub(uint a, uint b) internal returns (uint) {
27         assert(b <= a);
28         return a - b;
29     }
30 }
31 
32 contract CreatorEnabled {
33     address public creator = 0x0;
34 
35     modifier onlyCreator() { require(msg.sender == creator); _; }
36 
37     function changeCreator(address _to) public onlyCreator {
38         creator = _to;
39     }
40 }
41 
42 contract StringMover {
43     function stringToBytes32(string s) constant returns(bytes32){
44         bytes32 out;
45         assembly {
46              out := mload(add(s, 32))
47         }
48         return out;
49     }
50 
51     function stringToBytes64(string s) constant returns(bytes32,bytes32){
52         bytes32 out;
53         bytes32 out2;
54 
55         assembly {
56              out := mload(add(s, 32))
57              out2 := mload(add(s, 64))
58         }
59         return (out,out2);
60     }
61 
62     function bytes32ToString(bytes32 x) constant returns (string) {
63         bytes memory bytesString = new bytes(32);
64         uint charCount = 0;
65         for (uint j = 0; j < 32; j++) {
66              byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
67              if (char != 0) {
68                   bytesString[charCount] = char;
69                   charCount++;
70              }
71         }
72         bytes memory bytesStringTrimmed = new bytes(charCount);
73         for (j = 0; j < charCount; j++) {
74              bytesStringTrimmed[j] = bytesString[j];
75         }
76         return string(bytesStringTrimmed);
77     }
78 
79     function bytes64ToString(bytes32 x, bytes32 y) constant returns (string) {
80         bytes memory bytesString = new bytes(64);
81         uint charCount = 0;
82 
83         for (uint j = 0; j < 32; j++) {
84              byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
85              if (char != 0) {
86                   bytesString[charCount] = char;
87                   charCount++;
88              }
89         }
90         for (j = 0; j < 32; j++) {
91              char = byte(bytes32(uint(y) * 2 ** (8 * j)));
92              if (char != 0) {
93                   bytesString[charCount] = char;
94                   charCount++;
95              }
96         }
97 
98         bytes memory bytesStringTrimmed = new bytes(charCount);
99         for (j = 0; j < charCount; j++) {
100              bytesStringTrimmed[j] = bytesString[j];
101         }
102         return string(bytesStringTrimmed);
103     }
104 }
105 
106 
107 contract Storage is SafeMath, StringMover {
108     function Storage() public {
109         controllerAddress = msg.sender;
110     }
111 
112     address public controllerAddress = 0x0;
113     modifier onlyController() { require(msg.sender==controllerAddress); _; }
114 
115     function setControllerAddress(address _newController) onlyController {
116         controllerAddress = _newController;
117     }
118 
119     address public hotWalletAddress = 0x0;
120 
121     function setHotWalletAddress(address _address) onlyController {
122        hotWalletAddress = _address;
123     }
124 
125 
126     // Fields - 1
127     mapping(uint => string) docs;
128     uint public docCount = 0;
129 
130     // Fields - 2
131     mapping(string => mapping(uint => int)) fiatTxs;
132     mapping(string => uint) fiatBalancesCents;
133     mapping(string => uint) fiatTxCounts;
134     uint fiatTxTotal = 0;
135 
136     // Fields - 3
137     mapping(string => mapping(uint => int)) goldTxs;
138     mapping(string => uint) goldHotBalances;
139     mapping(string => uint) goldTxCounts;
140     uint goldTxTotal = 0;
141 
142     // Fields - 4
143     struct Request {
144         address sender;
145         string userId;
146         string requestHash;
147         bool buyRequest;         // otherwise - sell
148 
149         // 0 - init
150         // 1 - processed
151         // 2 - cancelled
152         uint8 state;
153     }
154 
155     mapping (uint=>Request) requests;
156     uint public requestsCount = 0;
157 
158     ///////
159     function addDoc(string _ipfsDocLink) public onlyController returns(uint) {
160         docs[docCount] = _ipfsDocLink;
161         uint out = docCount;
162         docCount++;
163 
164         return out;
165     }
166 
167     function getDocCount() public constant returns (uint) {
168         return docCount;
169     }
170 
171     function getDocAsBytes64(uint _index) public constant returns (bytes32,bytes32) {
172         require(_index < docCount);
173         return stringToBytes64(docs[_index]);
174     }
175 
176     function addFiatTransaction(string _userId, int _amountCents) public onlyController returns(uint) {
177         require(0 != _amountCents);
178 
179         uint c = fiatTxCounts[_userId];
180 
181         fiatTxs[_userId][c] = _amountCents;
182 
183         if (_amountCents > 0) {
184             fiatBalancesCents[_userId] = safeAdd(fiatBalancesCents[_userId], uint(_amountCents));
185         } else {
186             fiatBalancesCents[_userId] = safeSub(fiatBalancesCents[_userId], uint(-_amountCents));
187         }
188 
189         fiatTxCounts[_userId] = safeAdd(fiatTxCounts[_userId], 1);
190 
191         fiatTxTotal++;
192         return c;
193     }
194 
195     function getFiatTransactionsCount(string _userId) public constant returns (uint) {
196         return fiatTxCounts[_userId];
197     }
198 
199     function getAllFiatTransactionsCount() public constant returns (uint) {
200         return fiatTxTotal;
201     }
202 
203     function getFiatTransaction(string _userId, uint _index) public constant returns(int) {
204         require(_index < fiatTxCounts[_userId]);
205         return fiatTxs[_userId][_index];
206     }
207 
208     function getUserFiatBalance(string _userId) public constant returns(uint) {
209         return fiatBalancesCents[_userId];
210     }
211 
212     function addGoldTransaction(string _userId, int _amount) public onlyController returns(uint) {
213         require(0 != _amount);
214 
215         uint c = goldTxCounts[_userId];
216 
217         goldTxs[_userId][c] = _amount;
218 
219         if (_amount > 0) {
220             goldHotBalances[_userId] = safeAdd(goldHotBalances[_userId], uint(_amount));
221         } else {
222             goldHotBalances[_userId] = safeSub(goldHotBalances[_userId], uint(-_amount));
223         }
224 
225         goldTxCounts[_userId] = safeAdd(goldTxCounts[_userId], 1);
226 
227         goldTxTotal++;
228         return c;
229     }
230 
231     function getGoldTransactionsCount(string _userId) public constant returns (uint) {
232         return goldTxCounts[_userId];
233     }
234 
235     function getAllGoldTransactionsCount() public constant returns (uint) {
236         return goldTxTotal;
237     }
238 
239     function getGoldTransaction(string _userId, uint _index) public constant returns(int) {
240         require(_index < goldTxCounts[_userId]);
241         return goldTxs[_userId][_index];
242     }
243 
244     function getUserHotGoldBalance(string _userId) public constant returns(uint) {
245         return goldHotBalances[_userId];
246     }
247 
248     function addBuyTokensRequest(address _who, string _userId, string _requestHash) public onlyController returns(uint) {
249         Request memory r;
250         r.sender = _who;
251         r.userId = _userId;
252         r.requestHash = _requestHash;
253         r.buyRequest = true;
254         r.state = 0;
255 
256         requests[requestsCount] = r;
257         uint out = requestsCount;
258         requestsCount++;
259         return out;
260     }
261 
262     function addSellTokensRequest(address _who, string _userId, string _requestHash) onlyController returns(uint) {
263         Request memory r;
264         r.sender = _who;
265         r.userId = _userId;
266         r.requestHash = _requestHash;
267         r.buyRequest = false;
268         r.state = 0;
269 
270         requests[requestsCount] = r;
271         uint out = requestsCount;
272         requestsCount++;
273         return out;
274     }
275 
276     function getRequestsCount() public constant returns(uint) {
277         return requestsCount;
278     }
279 
280     function getRequest(uint _index) public constant returns(
281         address a,
282         bytes32 userId,
283         bytes32 hashA, bytes32 hashB,
284         bool buy, uint8 state)
285     {
286         require(_index < requestsCount);
287 
288         Request memory r = requests[_index];
289 
290         bytes32 userBytes = stringToBytes32(r.userId);
291         var (out1, out2) = stringToBytes64(r.requestHash);
292 
293         return (r.sender, userBytes, out1, out2, r.buyRequest, r.state);
294     }
295 
296     function cancelRequest(uint _index) onlyController public {
297         require(_index < requestsCount);
298         require(0==requests[_index].state);
299 
300         requests[_index].state = 2;
301     }
302 
303     function setRequestProcessed(uint _index) onlyController public {
304         requests[_index].state = 1;
305     }
306 }
307 
308 contract GoldFiatFee is CreatorEnabled, StringMover {
309     string gmUserId = "";
310 
311     // Functions:
312     function GoldFiatFee(string _gmUserId) {
313         creator = msg.sender;
314         gmUserId = _gmUserId;
315     }
316 
317     function getGoldmintFeeAccount() public constant returns(bytes32) {
318         bytes32 userBytes = stringToBytes32(gmUserId);
319         return userBytes;
320     }
321 
322     function setGoldmintFeeAccount(string _gmUserId) public onlyCreator {
323         gmUserId = _gmUserId;
324     }
325 
326     function calculateBuyGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint) {
327         return 0;
328     }
329 
330     function calculateSellGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint) {
331         // If the sender holds 0 MNTP, then the transaction fee is 3% fiat,
332         // If the sender holds at least 10 MNTP, then the transaction fee is 2% fiat,
333         // If the sender holds at least 1000 MNTP, then the transaction fee is 1.5% fiat,
334         // If the sender holds at least 10000 MNTP, then the transaction fee is 1% fiat,
335         if (_mntpBalance >= (10000 * 1 ether)) {
336              return (75 * _goldValue / 10000);
337         }
338 
339         if (_mntpBalance >= (1000 * 1 ether)) {
340              return (15 * _goldValue / 1000);
341         }
342 
343         if (_mntpBalance >= (10 * 1 ether)) {
344              return (25 * _goldValue / 1000);
345         }
346 
347         // 3%
348         return (3 * _goldValue / 100);
349     }
350 }
351 
352 contract IGoldFiatFee {
353     function getGoldmintFeeAccount()public constant returns(bytes32);
354     function calculateBuyGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint);
355     function calculateSellGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint);
356 }
357 
358 contract StorageController is SafeMath, CreatorEnabled, StringMover {
359     Storage public stor;
360     IMNTP public mntpToken;
361     IGold public goldToken;
362     IGoldFiatFee public fiatFee;
363 
364     address public ethDepositAddress = 0x0;
365     address public managerAddress = 0x0;
366 
367     event NewTokenBuyRequest(address indexed _from, string indexed _userId);
368     event NewTokenSellRequest(address indexed _from, string indexed _userId);
369     event RequestCancelled(uint indexed _reqId);
370     event RequestProcessed(uint indexed _reqId);
371     event EthDeposited(uint indexed _requestId, address indexed _address, uint _ethValue);
372 
373     modifier onlyManagerOrCreator() { require(msg.sender == managerAddress || msg.sender == creator); _; }
374 
375     function StorageController(address _mntpContractAddress, address _goldContractAddress, address _storageAddress, address _fiatFeeContract) {
376         creator = msg.sender;
377 
378         if (0 != _storageAddress) {
379              // use existing storage
380              stor = Storage(_storageAddress);
381         } else {
382              stor = new Storage();
383         }
384 
385         require(0x0!=_mntpContractAddress);
386         require(0x0!=_goldContractAddress);
387         require(0x0!=_fiatFeeContract);
388 
389         mntpToken = IMNTP(_mntpContractAddress);
390         goldToken = IGold(_goldContractAddress);
391         fiatFee = IGoldFiatFee(_fiatFeeContract);
392     }
393 
394     function setEthDepositAddress(address _address) public onlyCreator {
395        ethDepositAddress = _address;
396     }
397 
398     function setManagerAddress(address _address) public onlyCreator {
399        managerAddress = _address;
400     }
401 
402     function getEthDepositAddress() public constant returns (address) {
403        return ethDepositAddress;
404     }
405 
406     // Only old controller can call setControllerAddress
407     function changeController(address _newController) public onlyCreator {
408         stor.setControllerAddress(_newController);
409     }
410 
411     function setHotWalletAddress(address _hotWalletAddress) public onlyCreator {
412        stor.setHotWalletAddress(_hotWalletAddress);
413     }
414 
415     function getHotWalletAddress() public constant returns (address) {
416         return stor.hotWalletAddress();
417     }
418 
419     function changeFiatFeeContract(address _newFiatFee) public onlyCreator {
420         fiatFee = IGoldFiatFee(_newFiatFee);
421     }
422 
423     function addDoc(string _ipfsDocLink) public onlyCreator returns(uint) {
424         return stor.addDoc(_ipfsDocLink);
425     }
426 
427     function getDocCount() public constant returns (uint) {
428         return stor.docCount();
429     }
430 
431     function getDoc(uint _index) public constant returns (string) {
432         var (x, y) = stor.getDocAsBytes64(_index);
433         return bytes64ToString(x,y);
434     }
435 
436 
437     // _amountCents can be negative
438     // returns index in user array
439     function addFiatTransaction(string _userId, int _amountCents) public onlyManagerOrCreator returns(uint) {
440         return stor.addFiatTransaction(_userId, _amountCents);
441     }
442 
443     function getFiatTransactionsCount(string _userId) public constant returns (uint) {
444         return stor.getFiatTransactionsCount(_userId);
445     }
446 
447     function getAllFiatTransactionsCount() public constant returns (uint) {
448         return stor.getAllFiatTransactionsCount();
449     }
450 
451     function getFiatTransaction(string _userId, uint _index) public constant returns(int) {
452         return stor.getFiatTransaction(_userId, _index);
453     }
454 
455     function getUserFiatBalance(string _userId) public constant returns(uint) {
456         return stor.getUserFiatBalance(_userId);
457     }
458 
459     function addGoldTransaction(string _userId, int _amount) public onlyManagerOrCreator returns(uint) {
460         return stor.addGoldTransaction(_userId, _amount);
461     }
462 
463     function getGoldTransactionsCount(string _userId) public constant returns (uint) {
464         return stor.getGoldTransactionsCount(_userId);
465     }
466 
467     function getAllGoldTransactionsCount() public constant returns (uint) {
468         return stor.getAllGoldTransactionsCount();
469     }
470 
471     function getGoldTransaction(string _userId, uint _index) public constant returns(int) {
472         require(keccak256(_userId) != keccak256(""));
473 
474         return stor.getGoldTransaction(_userId, _index);
475     }
476 
477     function getUserHotGoldBalance(string _userId) public constant returns(uint) {
478         require(keccak256(_userId) != keccak256(""));
479 
480         return stor.getUserHotGoldBalance(_userId);
481     }
482 
483 
484     function addBuyTokensRequest(string _userId, string _requestHash) public returns(uint) {
485         require(keccak256(_userId) != keccak256(""));
486 
487         NewTokenBuyRequest(msg.sender, _userId);
488         return stor.addBuyTokensRequest(msg.sender, _userId, _requestHash);
489     }
490 
491     function addSellTokensRequest(string _userId, string _requestHash) public returns(uint) {
492       require(keccak256(_userId) != keccak256(""));
493 
494       NewTokenSellRequest(msg.sender, _userId);
495 
496     return stor.addSellTokensRequest(msg.sender, _userId, _requestHash);
497     }
498 
499     function getRequestsCount() public constant returns(uint) {
500         return stor.getRequestsCount();
501     }
502 
503     function getRequest(uint _index) public constant returns(address, string, string, bool, uint8) {
504         var (sender, userIdBytes, hashA, hashB, buy, state) = stor.getRequest(_index);
505 
506         string memory userId = bytes32ToString(userIdBytes);
507         string memory hash = bytes64ToString(hashA, hashB);
508 
509         return (sender, userId, hash, buy, state);
510     }
511 
512     function cancelRequest(uint _index) onlyManagerOrCreator public {
513         RequestCancelled(_index);
514         stor.cancelRequest(_index);
515     }
516 
517     function processRequest(uint _index, uint _amountCents, uint _centsPerGold) onlyManagerOrCreator public {
518         require(_index < getRequestsCount());
519 
520         var (sender, userId, hash, isBuy, state) = getRequest(_index);
521         require(0 == state);
522 
523         if (isBuy) {
524              processBuyRequest(userId, sender, _amountCents, _centsPerGold);
525         } else {
526              processSellRequest(userId, sender, _amountCents, _centsPerGold);
527         }
528 
529         // 3 - update state
530         stor.setRequestProcessed(_index);
531 
532         // 4 - send event
533         RequestProcessed(_index);
534     }
535 
536     function processBuyRequest(string _userId, address _userAddress, uint _amountCents, uint _centsPerGold) internal {
537         require(keccak256(_userId) != keccak256(""));
538 
539         uint userFiatBalance = getUserFiatBalance(_userId);
540         require(userFiatBalance > 0);
541 
542         if (_amountCents > userFiatBalance) {
543              _amountCents = userFiatBalance;
544         }
545 
546         uint userMntpBalance = mntpToken.balanceOf(_userAddress);
547         uint fee = fiatFee.calculateBuyGoldFee(userMntpBalance, _amountCents);
548         require(_amountCents > fee);
549 
550         // 1 - issue tokens minus fee
551         uint amountMinusFee = _amountCents;
552         if (fee > 0) {
553              amountMinusFee = safeSub(_amountCents, fee);
554         }
555 
556         require(amountMinusFee > 0);
557 
558         uint tokens = (uint(amountMinusFee) * 1 ether) / _centsPerGold;
559         issueGoldTokens(_userAddress, tokens);
560 
561         // request from hot wallet
562         if (isHotWallet(_userAddress)) {
563           addGoldTransaction(_userId, int(tokens));
564         }
565 
566         // 2 - add fiat tx
567         // negative for buy (total amount including fee!)
568         addFiatTransaction(_userId, - int(_amountCents));
569 
570         // 3 - send fee to Goldmint
571         // positive for sell
572         if (fee > 0) {
573              string memory gmAccount = bytes32ToString(fiatFee.getGoldmintFeeAccount());
574              addFiatTransaction(gmAccount, int(fee));
575         }
576     }
577 
578     function processSellRequest(string _userId, address _userAddress, uint _amountCents, uint _centsPerGold) internal {
579         require(keccak256(_userId) != keccak256(""));
580 
581         uint tokens = (uint(_amountCents) * 1 ether) / _centsPerGold;
582         uint tokenBalance = goldToken.balanceOf(_userAddress);
583 
584         if (isHotWallet(_userAddress)) {
585             tokenBalance = getUserHotGoldBalance(_userId);
586         }
587 
588         if (tokenBalance < tokens) {
589              tokens = tokenBalance;
590              _amountCents = uint((tokens * _centsPerGold) / 1 ether);
591         }
592 
593         burnGoldTokens(_userAddress, tokens);
594 
595         // request from hot wallet
596         if (isHotWallet(_userAddress)) {
597           addGoldTransaction(_userId, - int(tokens));
598         }
599 
600         // 2 - add fiat tx
601         uint userMntpBalance = mntpToken.balanceOf(_userAddress);
602         uint fee = fiatFee.calculateSellGoldFee(userMntpBalance, _amountCents);
603         require(_amountCents > fee);
604 
605         uint amountMinusFee = _amountCents;
606 
607         if (fee > 0) {
608              amountMinusFee = safeSub(_amountCents, fee);
609         }
610 
611         require(amountMinusFee > 0);
612         // positive for sell
613         addFiatTransaction(_userId, int(amountMinusFee));
614 
615         // 3 - send fee to Goldmint
616         if (fee > 0) {
617              string memory gmAccount = bytes32ToString(fiatFee.getGoldmintFeeAccount());
618              addFiatTransaction(gmAccount, int(fee));
619         }
620     }
621 
622     //////// INTERNAL REQUESTS FROM HOT WALLET
623     function processInternalRequest(string _userId, bool _isBuy, uint _amountCents, uint _centsPerGold) onlyManagerOrCreator public {
624       if (_isBuy) {
625           processBuyRequest(_userId, getHotWalletAddress(), _amountCents, _centsPerGold);
626       } else {
627           processSellRequest(_userId, getHotWalletAddress(), _amountCents, _centsPerGold);
628       }
629     }
630 
631     function transferGoldFromHotWallet(address _to, uint _value, string _userId) onlyManagerOrCreator public {
632       require(keccak256(_userId) != keccak256(""));
633 
634       uint balance = getUserHotGoldBalance(_userId);
635       require(balance >= _value);
636 
637       goldToken.burnTokens(getHotWalletAddress(), _value);
638       goldToken.issueTokens(_to, _value);
639 
640       addGoldTransaction(_userId, -int(_value));
641     }
642 
643     ////////
644     function issueGoldTokens(address _userAddress, uint _tokenAmount) internal {
645         require(0!=_tokenAmount);
646         goldToken.issueTokens(_userAddress, _tokenAmount);
647     }
648 
649     function burnGoldTokens(address _userAddress, uint _tokenAmount) internal {
650         require(0!=_tokenAmount);
651         goldToken.burnTokens(_userAddress, _tokenAmount);
652     }
653 
654     function isHotWallet(address _address) internal returns(bool) {
655        return _address == getHotWalletAddress();
656     }
657 
658     ///////
659     function depositEth(uint _requestId) public payable {
660       require(ethDepositAddress != 0x0);
661       //min deposit is 0.01 ETH
662       require(msg.value >= 0.01 * 1 ether);
663 
664       ethDepositAddress.transfer(msg.value);
665 
666       EthDeposited(_requestId, msg.sender, msg.value);
667     }
668 
669     // do not allow to send money to this contract...
670     function() external payable {
671       revert();
672     }
673 }