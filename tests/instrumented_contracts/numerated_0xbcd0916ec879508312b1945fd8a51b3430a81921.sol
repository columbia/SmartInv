1 pragma solidity ^0.4.19;
2 
3 contract IGold {
4      function balanceOf(address _owner) constant returns (uint256);
5      function issueTokens(address _who, uint _tokens);
6      function burnTokens(address _who, uint _tokens);
7 }
8 
9 // StdToken inheritance is commented, because no 'totalSupply' needed
10 contract IMNTP { /*is StdToken */
11      function balanceOf(address _owner) constant returns (uint256);
12 // Additional methods that MNTP contract provides
13      function lockTransfer(bool _lock);
14      function issueTokens(address _who, uint _tokens);
15      function burnTokens(address _who, uint _tokens);
16 }
17 
18 contract SafeMath {
19     function safeAdd(uint a, uint b) internal returns (uint) {
20         uint c = a + b;
21         assert(c>=a && c>=b);
22         return c;
23      }
24 
25     function safeSub(uint a, uint b) internal returns (uint) {
26         assert(b <= a);
27         return a - b;
28     }
29 }
30 
31 contract CreatorEnabled {
32      address public creator = 0x0;
33 
34      modifier onlyCreator() { require(msg.sender == creator); _; }
35 
36      function changeCreator(address _to) public onlyCreator {
37           creator = _to;
38      }
39 }
40 
41 contract StringMover {
42      function stringToBytes32(string s) constant returns(bytes32){
43           bytes32 out;
44           assembly {
45                out := mload(add(s, 32))
46           }
47           return out;
48      }
49 
50      function stringToBytes64(string s) constant returns(bytes32,bytes32){
51           bytes32 out;
52           bytes32 out2;
53 
54           assembly {
55                out := mload(add(s, 32))
56                out2 := mload(add(s, 64))
57           }
58           return (out,out2);
59      }
60 
61      function bytes32ToString(bytes32 x) constant returns (string) {
62           bytes memory bytesString = new bytes(32);
63           uint charCount = 0;
64           for (uint j = 0; j < 32; j++) {
65                byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
66                if (char != 0) {
67                     bytesString[charCount] = char;
68                     charCount++;
69                }
70           }
71           bytes memory bytesStringTrimmed = new bytes(charCount);
72           for (j = 0; j < charCount; j++) {
73                bytesStringTrimmed[j] = bytesString[j];
74           }
75           return string(bytesStringTrimmed);
76      }
77 
78      function bytes64ToString(bytes32 x, bytes32 y) constant returns (string) {
79           bytes memory bytesString = new bytes(64);
80           uint charCount = 0;
81 
82           for (uint j = 0; j < 32; j++) {
83                byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
84                if (char != 0) {
85                     bytesString[charCount] = char;
86                     charCount++;
87                }
88           }
89           for (j = 0; j < 32; j++) {
90                char = byte(bytes32(uint(y) * 2 ** (8 * j)));
91                if (char != 0) {
92                     bytesString[charCount] = char;
93                     charCount++;
94                }
95           }
96 
97           bytes memory bytesStringTrimmed = new bytes(charCount);
98           for (j = 0; j < charCount; j++) {
99                bytesStringTrimmed[j] = bytesString[j];
100           }
101           return string(bytesStringTrimmed);
102      }
103 }
104 
105 
106 contract Storage is SafeMath, StringMover {
107      function Storage() public {
108           controllerAddress = msg.sender;
109      }
110 
111      address public controllerAddress = 0x0;
112      modifier onlyController() { require(msg.sender==controllerAddress); _; }
113 
114      function setControllerAddress(address _newController) onlyController {
115           controllerAddress = _newController;
116      }
117 
118      address public hotWalletAddress = 0x0;
119 
120      function setHotWalletAddress(address _address) onlyController {
121          hotWalletAddress = _address;
122      }
123 
124 // Fields - 1
125      mapping(uint => string) docs;
126      uint public docCount = 0;
127 
128 // Fields - 2 
129      mapping(string => mapping(uint => int)) fiatTxs;
130      mapping(string => uint) fiatBalancesCents;
131      mapping(string => uint) fiatTxCounts;
132      uint fiatTxTotal = 0;
133 
134 // Fields - 3 
135      mapping(string => mapping(uint => int)) goldTxs;
136      mapping(string => uint) goldHotBalances;
137      mapping(string => uint) goldTxCounts;
138      uint goldTxTotal = 0;
139 
140 // Fields - 4 
141      struct Request {
142           address sender;
143           string userId;
144           string requestHash;
145           bool buyRequest;         // otherwise - sell
146 
147           // 0 - init
148           // 1 - processed
149           // 2 - cancelled
150           uint8 state;
151      }
152      
153      mapping (uint=>Request) requests;
154      uint public requestsCount = 0;
155 
156 ///////
157      function addDoc(string _ipfsDocLink) public onlyController returns(uint) {
158           docs[docCount] = _ipfsDocLink;
159           uint out = docCount;
160           docCount++;
161 
162           return out;
163      }
164 
165      function getDocCount() public constant returns (uint) {
166           return docCount; 
167      }
168 
169      function getDocAsBytes64(uint _index) public constant returns (bytes32,bytes32) {
170           require(_index < docCount);
171           return stringToBytes64(docs[_index]);
172      }
173 
174      function addFiatTransaction(string _userId, int _amountCents) public onlyController returns(uint) {
175           require(0 != _amountCents);
176 
177           uint c = fiatTxCounts[_userId];
178 
179           fiatTxs[_userId][c] = _amountCents;
180         
181           if (_amountCents > 0) {
182               fiatBalancesCents[_userId] = safeAdd(fiatBalancesCents[_userId], uint(_amountCents));
183           } else {
184               fiatBalancesCents[_userId] = safeSub(fiatBalancesCents[_userId], uint(-_amountCents));
185           }
186 
187           fiatTxCounts[_userId] = safeAdd(fiatTxCounts[_userId], 1);
188 
189           fiatTxTotal++;
190           return c;
191      }
192 
193      function getFiatTransactionsCount(string _userId) public constant returns (uint) {
194           return fiatTxCounts[_userId];
195      }
196      
197      function getAllFiatTransactionsCount() public constant returns (uint) {
198           return fiatTxTotal;
199      }
200 
201      function getFiatTransaction(string _userId, uint _index) public constant returns(int) {
202           require(_index < fiatTxCounts[_userId]);
203           return fiatTxs[_userId][_index];
204      }
205 
206      function getUserFiatBalance(string _userId) public constant returns(uint) {
207           return fiatBalancesCents[_userId];
208      }
209 
210     function addGoldTransaction(string _userId, int _amount) public onlyController returns(uint) {
211           require(0 != _amount);
212 
213           uint c = goldTxCounts[_userId];
214 
215           goldTxs[_userId][c] = _amount;
216 
217           if (_amount > 0) {
218               goldHotBalances[_userId] = safeAdd(goldHotBalances[_userId], uint(_amount));
219           } else {
220               goldHotBalances[_userId] = safeSub(goldHotBalances[_userId], uint(-_amount));
221           }
222 
223           goldTxCounts[_userId] = safeAdd(goldTxCounts[_userId], 1);
224 
225           goldTxTotal++;
226           return c;
227      }
228 
229      function getGoldTransactionsCount(string _userId) public constant returns (uint) {
230           return goldTxCounts[_userId];
231      }
232      
233      function getAllGoldTransactionsCount() public constant returns (uint) {
234           return goldTxTotal;
235      }
236 
237      function getGoldTransaction(string _userId, uint _index) public constant returns(int) {
238           require(_index < goldTxCounts[_userId]);
239           return goldTxs[_userId][_index];
240      }
241 
242      function getUserHotGoldBalance(string _userId) public constant returns(uint) {
243           return goldHotBalances[_userId];
244      }
245 
246      function addBuyTokensRequest(address _who, string _userId, string _requestHash) public onlyController returns(uint) {
247           Request memory r;
248           r.sender = _who;
249           r.userId = _userId;
250           r.requestHash = _requestHash;
251           r.buyRequest = true;
252           r.state = 0;
253 
254           requests[requestsCount] = r;
255           uint out = requestsCount;
256           requestsCount++;
257           return out;
258      }
259 
260      function addSellTokensRequest(address _who, string _userId, string _requestHash) onlyController returns(uint) {
261           Request memory r;
262           r.sender = _who;
263           r.userId = _userId;
264           r.requestHash = _requestHash;
265           r.buyRequest = false;
266           r.state = 0;
267 
268           requests[requestsCount] = r;
269           uint out = requestsCount;
270           requestsCount++;
271           return out;
272      }
273 
274      function getRequestsCount() public constant returns(uint) {
275           return requestsCount;
276      }
277 
278      function getRequest(uint _index) public constant returns(
279           address a, 
280           bytes32 userId, 
281           bytes32 hashA, bytes32 hashB, 
282           bool buy, uint8 state)
283      {
284           require(_index < requestsCount);
285 
286           Request memory r = requests[_index];
287 
288           bytes32 userBytes = stringToBytes32(r.userId);
289           var (out1, out2) = stringToBytes64(r.requestHash);
290 
291           return (r.sender, userBytes, out1, out2, r.buyRequest, r.state);
292      }
293 
294      function cancelRequest(uint _index) onlyController public {
295           require(_index < requestsCount);
296           require(0==requests[_index].state);
297 
298           requests[_index].state = 2;
299      }
300      
301      function setRequestProcessed(uint _index) onlyController public {
302           requests[_index].state = 1;
303      }
304 }
305 
306 contract GoldFiatFee is CreatorEnabled, StringMover {
307      string gmUserId = "";
308 
309 // Functions: 
310      function GoldFiatFee(string _gmUserId) {
311           creator = msg.sender;
312           gmUserId = _gmUserId;
313      }
314 
315      function getGoldmintFeeAccount() public constant returns(bytes32) {
316           bytes32 userBytes = stringToBytes32(gmUserId);
317           return userBytes;
318      }
319 
320      function setGoldmintFeeAccount(string _gmUserId) public onlyCreator {
321           gmUserId = _gmUserId;
322      }
323      
324      function calculateBuyGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint) {
325           return 0;
326      }
327 
328      function calculateSellGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint) {
329           // If the sender holds 0 MNTP, then the transaction fee is 3% fiat, 
330           // If the sender holds at least 10 MNTP, then the transaction fee is 2% fiat,
331           // If the sender holds at least 1000 MNTP, then the transaction fee is 1.5% fiat,
332           // If the sender holds at least 10000 MNTP, then the transaction fee is 1% fiat,
333           if (_mntpBalance >= (10000 * 1 ether)) {
334                return (75 * _goldValue / 10000);
335           }
336 
337           if (_mntpBalance >= (1000 * 1 ether)) {
338                return (15 * _goldValue / 1000);
339           }
340 
341           if (_mntpBalance >= (10 * 1 ether)) {
342                return (25 * _goldValue / 1000);
343           }
344           
345           // 3%
346           return (3 * _goldValue / 100);
347      }
348 }
349 
350 contract IGoldFiatFee {
351      function getGoldmintFeeAccount()public constant returns(bytes32);
352      function calculateBuyGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint);
353      function calculateSellGoldFee(uint _mntpBalance, uint _goldValue) public constant returns(uint);
354 }
355 
356 contract StorageController is SafeMath, CreatorEnabled, StringMover {
357      Storage public stor;
358      IMNTP public mntpToken;
359      IGold public goldToken;
360      IGoldFiatFee public fiatFee;
361 
362      event NewTokenBuyRequest(address indexed _from, string indexed _userId);
363      event NewTokenSellRequest(address indexed _from, string indexed _userId);
364      event RequestCancelled(uint indexed _reqId);
365      event RequestProcessed(uint indexed _reqId);
366 
367      function StorageController(address _mntpContractAddress, address _goldContractAddress, address _storageAddress, address _fiatFeeContract) {
368           creator = msg.sender;
369 
370           if (0 != _storageAddress) {
371                // use existing storage
372                stor = Storage(_storageAddress);
373           } else {
374                stor = new Storage();
375           }
376 
377           require(0x0!=_mntpContractAddress);
378           require(0x0!=_goldContractAddress);
379           require(0x0!=_fiatFeeContract);
380 
381           mntpToken = IMNTP(_mntpContractAddress);
382           goldToken = IGold(_goldContractAddress);
383           fiatFee = IGoldFiatFee(_fiatFeeContract);
384      }
385 
386 
387      // Only old controller can call setControllerAddress
388      function changeController(address _newController) public onlyCreator {
389           stor.setControllerAddress(_newController);
390      }
391 
392      function setHotWalletAddress(address _hotWalletAddress) public onlyCreator {
393          stor.setHotWalletAddress(_hotWalletAddress);
394      }
395 
396      function getHotWalletAddress() public constant returns (address) {
397           return stor.hotWalletAddress();
398      }
399 
400      function changeFiatFeeContract(address _newFiatFee) public onlyCreator {
401           fiatFee = IGoldFiatFee(_newFiatFee);
402      }
403 
404      // 1
405      function addDoc(string _ipfsDocLink) public onlyCreator returns(uint) {
406           return stor.addDoc(_ipfsDocLink);
407      }
408 
409      function getDocCount() public constant returns (uint) {
410           return stor.docCount(); 
411      }
412 
413      function getDoc(uint _index) public constant returns (string) {
414           var (x, y) = stor.getDocAsBytes64(_index);
415           return bytes64ToString(x,y);
416      }
417 
418 // 2
419      // _amountCents can be negative
420      // returns index in user array
421      function addFiatTransaction(string _userId, int _amountCents) public onlyCreator returns(uint) {
422           return stor.addFiatTransaction(_userId, _amountCents);
423      }
424 
425      function getFiatTransactionsCount(string _userId) public constant returns (uint) {
426           return stor.getFiatTransactionsCount(_userId);
427      }
428      
429      function getAllFiatTransactionsCount() public constant returns (uint) {
430           return stor.getAllFiatTransactionsCount();
431      }
432 
433      function getFiatTransaction(string _userId, uint _index) public constant returns(int) {
434           return stor.getFiatTransaction(_userId, _index);
435      }
436 
437      function getUserFiatBalance(string _userId) public constant returns(uint) {
438           return stor.getUserFiatBalance(_userId);
439      }
440 
441 // 3
442 
443      function addGoldTransaction(string _userId, int _amount) public onlyCreator returns(uint) {
444           return stor.addGoldTransaction(_userId, _amount);
445      }
446 
447      function getGoldTransactionsCount(string _userId) public constant returns (uint) {
448           return stor.getGoldTransactionsCount(_userId);
449      }
450      
451      function getAllGoldTransactionsCount() public constant returns (uint) {
452           return stor.getAllGoldTransactionsCount();
453      }
454 
455      function getGoldTransaction(string _userId, uint _index) public constant returns(int) {
456           return stor.getGoldTransaction(_userId, _index);
457      }
458 
459      function getUserHotGoldBalance(string _userId) public constant returns(uint) {
460           return stor.getUserHotGoldBalance(_userId);
461      }
462 
463 // 4:
464      function addBuyTokensRequest(string _userId, string _requestHash) public returns(uint) {
465           NewTokenBuyRequest(msg.sender, _userId); 
466           return stor.addBuyTokensRequest(msg.sender, _userId, _requestHash);
467      }
468 
469      function addSellTokensRequest(string _userId, string _requestHash) public returns(uint) {
470           NewTokenSellRequest(msg.sender, _userId);
471 		return stor.addSellTokensRequest(msg.sender, _userId, _requestHash);
472      }
473 
474      function getRequestsCount() public constant returns(uint) {
475           return stor.getRequestsCount();
476      }
477 
478      function getRequest(uint _index) public constant returns(address, string, string, bool, uint8) {
479           var (sender, userIdBytes, hashA, hashB, buy, state) = stor.getRequest(_index);
480 
481           string memory userId = bytes32ToString(userIdBytes);
482           string memory hash = bytes64ToString(hashA, hashB);
483 
484           return (sender, userId, hash, buy, state);
485      }
486 
487      function cancelRequest(uint _index) onlyCreator public {
488           RequestCancelled(_index);
489           stor.cancelRequest(_index);
490      }
491      
492      function processRequest(uint _index, uint _amountCents, uint _centsPerGold) onlyCreator public {
493           require(_index < getRequestsCount());
494 
495           var (sender, userId, hash, isBuy, state) = getRequest(_index);
496           require(0 == state);
497 
498           if (isBuy) {
499                processBuyRequest(userId, sender, _amountCents, _centsPerGold);
500           } else {
501                processSellRequest(userId, sender, _amountCents, _centsPerGold);
502           }
503 
504           // 3 - update state
505           stor.setRequestProcessed(_index);
506 
507           // 4 - send event
508           RequestProcessed(_index);
509      }
510 
511      function processBuyRequest(string _userId, address _userAddress, uint _amountCents, uint _centsPerGold) internal {
512           uint userFiatBalance = getUserFiatBalance(_userId);
513           require(userFiatBalance > 0);
514 
515           if (_amountCents > userFiatBalance) {
516                _amountCents = userFiatBalance;
517           }
518 
519           uint userMntpBalance = mntpToken.balanceOf(_userAddress);
520           uint fee = fiatFee.calculateBuyGoldFee(userMntpBalance, _amountCents);
521           require(_amountCents > fee);  
522 
523           // 1 - issue tokens minus fee
524           uint amountMinusFee = _amountCents;
525           if (fee > 0) { 
526                amountMinusFee = safeSub(_amountCents, fee);
527           }
528 
529           require(amountMinusFee > 0);
530 
531           uint tokens = (uint(amountMinusFee) * 1 ether) / _centsPerGold;
532           issueGoldTokens(_userAddress, tokens);
533         
534           // request from hot wallet
535           if (isHotWallet(_userAddress)) {
536             addGoldTransaction(_userId, int(tokens));
537           }
538 
539           // 2 - add fiat tx
540           // negative for buy (total amount including fee!)
541           addFiatTransaction(_userId, - int(_amountCents));
542 
543           // 3 - send fee to Goldmint
544           // positive for sell 
545           if (fee > 0) {
546                string memory gmAccount = bytes32ToString(fiatFee.getGoldmintFeeAccount());
547                addFiatTransaction(gmAccount, int(fee));
548           }
549      }
550 
551      function processSellRequest(string _userId, address _userAddress, uint _amountCents, uint _centsPerGold) internal {
552           uint tokens = (uint(_amountCents) * 1 ether) / _centsPerGold;
553           uint tokenBalance = goldToken.balanceOf(_userAddress);
554 
555           if (isHotWallet(_userAddress)) {
556               tokenBalance = getUserHotGoldBalance(_userId);
557           }
558 
559           if (tokenBalance < tokens) {
560                tokens = tokenBalance;
561                _amountCents = uint((tokens * _centsPerGold) / 1 ether);
562           }
563 
564           burnGoldTokens(_userAddress, tokens);
565 
566           // request from hot wallet
567           if (isHotWallet(_userAddress)) {
568             addGoldTransaction(_userId, - int(tokens));
569           }
570 
571           // 2 - add fiat tx
572           uint userMntpBalance = mntpToken.balanceOf(_userAddress);
573           uint fee = fiatFee.calculateSellGoldFee(userMntpBalance, _amountCents);
574           require(_amountCents > fee);  
575 
576           uint amountMinusFee = _amountCents;
577 
578           if (fee > 0) { 
579                amountMinusFee = safeSub(_amountCents, fee);
580           }
581 
582           require(amountMinusFee > 0);
583           // positive for sell 
584           addFiatTransaction(_userId, int(amountMinusFee));
585 
586           // 3 - send fee to Goldmint
587           if (fee > 0) {
588                string memory gmAccount = bytes32ToString(fiatFee.getGoldmintFeeAccount());
589                addFiatTransaction(gmAccount, int(fee));
590           }
591      }
592      
593 //////// INTERNAL REQUESTS FROM HOT WALLET
594 
595     function processInternalRequest(string _userId, bool _isBuy, uint _amountCents, uint _centsPerGold) onlyCreator public {
596         if (_isBuy) {
597             processBuyRequest(_userId, getHotWalletAddress(), _amountCents, _centsPerGold);
598         } else {
599             processSellRequest(_userId, getHotWalletAddress(), _amountCents, _centsPerGold);
600         }
601     }
602 
603     function transferGoldFromHotWallet(address _to, uint _value, string _userId) onlyCreator public {
604         
605         uint balance = getUserHotGoldBalance(_userId);
606         require(balance >= _value);
607 
608         goldToken.burnTokens(getHotWalletAddress(), _value);
609         goldToken.issueTokens(_to, _value);
610 
611         addGoldTransaction(_userId, -int(_value));
612     }
613 
614 ////////
615      function issueGoldTokens(address _userAddress, uint _tokenAmount) internal {
616           require(0!=_tokenAmount);
617           goldToken.issueTokens(_userAddress, _tokenAmount);
618      }
619 
620      function burnGoldTokens(address _userAddress, uint _tokenAmount) internal {
621           require(0!=_tokenAmount);
622           goldToken.burnTokens(_userAddress, _tokenAmount);
623      }
624 
625      function isHotWallet(address _address) internal returns(bool) {
626          return _address == getHotWalletAddress();
627      }
628 }