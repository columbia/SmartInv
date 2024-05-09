1 /*
2     Gold Reserve [XGR]
3     1.0.0
4     
5     Rajci 'iFA' Andor @ ifa@fusionwallet.io
6 */
7 pragma solidity 0.4.18;
8 
9 contract SafeMath {
10     /* Internals */
11     function safeAdd(uint256 a, uint256 b) internal pure returns(uint256) {
12         if ( b > 0 ) {
13             assert( a + b > a );
14         }
15         return a + b;
16     }
17     function safeSub(uint256 a, uint256 b) internal pure returns(uint256) {
18         if ( b > 0 ) {
19             assert( a - b < a );
20         }
21         return a - b;
22     }
23     function safeMul(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28     function safeDiv(uint256 a, uint256 b) internal pure returns(uint256) {
29         return a / b;
30     }
31 }
32 
33 contract Owned {
34     /* Variables */
35     address public owner = msg.sender;
36     /* Externals */
37     function replaceOwner(address newOwner) external returns(bool success) {
38         require( isOwner() );
39         owner = newOwner;
40         return true;
41     }
42     /* Internals */
43     function isOwner() internal view returns(bool) {
44         return owner == msg.sender;
45     }
46     /* Modifiers */
47     modifier onlyForOwner {
48         require( isOwner() );
49         _;
50     }
51 }
52 
53 contract Token is SafeMath, Owned {
54     /**
55     * @title Gold Reserve [XGR] token
56     */
57     /* Variables */
58     string  public name = "GoldReserve";
59     string  public symbol = "XGR";
60     uint8   public decimals = 8;
61     uint256 public transactionFeeRate   = 20; // 0.02 %
62     uint256 public transactionFeeRateM  = 1e3; // 1000
63     uint256 public transactionFeeMin    =   2000000; // 0.2 XGR
64     uint256 public transactionFeeMax    = 200000000; // 2.0 XGR
65     address public databaseAddress;
66     address public depositsAddress;
67     address public forkAddress;
68     address public libAddress;
69     /* Constructor */
70     function Token(address newDatabaseAddress, address newDepositAddress, address newFrokAddress, address newLibAddress) public {
71         databaseAddress = newDatabaseAddress;
72         depositsAddress = newDepositAddress;
73         forkAddress = newFrokAddress;
74         libAddress = newLibAddress;
75     }
76     /* Fallback */
77     function () {
78         revert();
79     }
80     /* Externals */
81     function changeDataBaseAddress(address newDatabaseAddress) external onlyForOwner {
82         databaseAddress = newDatabaseAddress;
83     }
84     function changeDepositsAddress(address newDepositsAddress) external onlyForOwner {
85         depositsAddress = newDepositsAddress;
86     }
87     function changeForkAddress(address newForkAddress) external onlyForOwner {
88         forkAddress = newForkAddress;
89     }
90     function changeLibAddress(address newLibAddress) external onlyForOwner {
91         libAddress = newLibAddress;
92     }
93     function changeFees(uint256 rate, uint256 rateMultiplier, uint256 min, uint256 max) external onlyForOwner {
94         transactionFeeRate = rate;
95         transactionFeeRateM = rateMultiplier;
96         transactionFeeMin = min;
97         transactionFeeMax = max;
98     }
99     /**
100      * @notice `msg.sender` approves `spender` to spend `amount` tokens on its behalf.
101      * @param spender The address of the account able to transfer the tokens
102      * @param amount The amount of tokens to be approved for transfer
103      * @param nonce The transaction count of the authorised address
104      * @return True if the approval was successful
105      */
106     function approve(address spender, uint256 amount, uint256 nonce) external returns (bool success) {
107         address _trg = libAddress;
108         assembly {
109             let m := mload(0x20)
110             calldatacopy(m, 0, calldatasize)
111             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
112             switch success case 0 {
113                 invalid
114             } default {
115                 return(m, 0x20)
116             }
117         }
118     }
119     /**
120      * @notice `msg.sender` approves `spender` to spend `amount` tokens on its behalf and notify the spender from your approve with your `extraData` data.
121      * @param spender The address of the account able to transfer the tokens
122      * @param amount The amount of tokens to be approved for transfer
123      * @param nonce The transaction count of the authorised address
124      * @param extraData Data to give forward to the receiver
125      * @return True if the approval was successful
126      */
127     function approveAndCall(address spender, uint256 amount, uint256 nonce, bytes extraData) external returns (bool success) {
128         address _trg = libAddress;
129         assembly {
130             let m := mload(0x20)
131             calldatacopy(m, 0, calldatasize)
132             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
133             switch success case 0 {
134                 invalid
135             } default {
136                 return(m, 0x20)
137             }
138         }
139     }
140     /**
141      * @notice Send `amount` tokens to `to` from `msg.sender`
142      * @param to The address of the recipient
143      * @param amount The amount of tokens to be transferred
144      * @return Whether the transfer was successful or not
145      */
146     function transfer(address to, uint256 amount) external returns (bool success) {
147         address _trg = libAddress;
148         assembly {
149             let m := mload(0x20)
150             calldatacopy(m, 0, calldatasize)
151             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
152             switch success case 0 {
153                 invalid
154             } default {
155                 return(m, 0x20)
156             }
157         }
158     }
159     /**
160      * @notice Send `amount` tokens to `to` from `from` on the condition it is approved by `from`
161      * @param from The address holding the tokens being transferred
162      * @param to The address of the recipient
163      * @param amount The amount of tokens to be transferred
164      * @return True if the transfer was successful
165      */
166     function transferFrom(address from, address to, uint256 amount) external returns (bool success) {
167         address _trg = libAddress;
168         assembly {
169             let m := mload(0x20)
170             calldatacopy(m, 0, calldatasize)
171             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
172             switch success case 0 {
173                 invalid
174             } default {
175                 return(m, 0x20)
176             }
177         }
178     }
179     /**
180      * @notice Send `amount` tokens to `to` from `msg.sender` and notify the receiver from your transaction with your `extraData` data
181      * @param to The contract address of the recipient
182      * @param amount The amount of tokens to be transferred
183      * @param extraData Data to give forward to the receiver
184      * @return Whether the transfer was successful or not
185      */
186     function transfer(address to, uint256 amount, bytes extraData) external returns (bool success) {
187         address _trg = libAddress;
188         assembly {
189             let m := mload(0x20)
190             calldatacopy(m, 0, calldatasize)
191             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
192             switch success case 0 {
193                 invalid
194             } default {
195                 return(m, 0x20)
196             }
197         }
198     }
199     function mint(address owner, uint256 value) external returns (bool success) {
200         address _trg = libAddress;
201         assembly {
202             let m := mload(0x20)
203             calldatacopy(m, 0, calldatasize)
204             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
205             switch success case 0 {
206                 invalid
207             } default {
208                 return(m, 0x20)
209             }
210         }
211     }
212     /* Internals */
213     /* Constants */
214     function allowance(address owner, address spender) public constant returns (uint256 remaining, uint256 nonce) {
215         address _trg = libAddress;
216         assembly {
217             let m := mload(0x20)
218             calldatacopy(m, 0, calldatasize)
219             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
220             switch success case 0 {
221                 invalid
222             } default {
223                 return(m, 0x40)
224             }
225         }
226     }
227     function getTransactionFee(uint256 value) public constant returns (bool success, uint256 fee) {
228         address _trg = libAddress;
229         assembly {
230             let m := mload(0x20)
231             calldatacopy(m, 0, calldatasize)
232             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
233             switch success case 0 {
234                 invalid
235             } default {
236                 return(m, 0x40)
237             }
238         }
239     }
240     function balanceOf(address owner) public constant returns (uint256 value) {
241         address _trg = libAddress;
242         assembly {
243             let m := mload(0x20)
244             calldatacopy(m, 0, calldatasize)
245             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
246             switch success case 0 {
247                 invalid
248             } default {
249                 return(m, 0x20)
250             }
251         }
252     }
253     function balancesOf(address owner) public constant returns (uint256 balance, uint256 lockedAmount) {
254         address _trg = libAddress;
255         assembly {
256             let m := mload(0x20)
257             calldatacopy(m, 0, calldatasize)
258             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
259             switch success case 0 {
260                 invalid
261             } default {
262                 return(m, 0x40)
263             }
264         }
265     }
266     function totalSupply() public constant returns (uint256 value) {
267         address _trg = libAddress;
268         assembly {
269             let m := mload(0x20)
270             calldatacopy(m, 0, calldatasize)
271             let success := delegatecall(gas, _trg, m, calldatasize, m, 0x20)
272             switch success case 0 {
273                 invalid
274             } default {
275                 return(m, 0x20)
276             }
277         }
278     }
279     /* Events */
280     event AllowanceUsed(address indexed spender, address indexed owner, uint256 indexed value);
281     event Mint(address indexed addr, uint256 indexed value);
282     event Burn(address indexed addr, uint256 indexed value);
283     event Approval(address indexed _owner, address indexed _spender, uint _value);
284     event Transfer(address indexed _from, address indexed _to, uint _value);
285     event Transfer2(address indexed from, address indexed to, uint256 indexed value, bytes data);
286 }
287 
288 contract TokenDB is SafeMath, Owned {
289     /* Structures */
290     struct allowance_s {
291         uint256 amount;
292         uint256 nonce;
293     }
294     struct deposits_s {
295         address addr;
296         uint256 amount;
297         uint256 start;
298         uint256 end;
299         uint256 interestOnEnd;
300         uint256 interestBeforeEnd;
301         uint256 interestFee;
302         uint256 interestMultiplier;
303         bool    closeable;
304         bool    valid;
305     }
306     /* Variables */
307     mapping(address => mapping(address => allowance_s)) public allowance;
308     mapping(address => uint256) public balanceOf;
309     mapping(uint256 => deposits_s) private deposits;
310     mapping(address => uint256) public lockedBalances;
311     address public tokenAddress;
312     address public depositsAddress;
313     uint256 public depositsCounter;
314     uint256 public totalSupply;
315     /* Constructor */
316     /* Externals */
317     function changeTokenAddress(address newTokenAddress) external onlyForOwner {
318         tokenAddress = newTokenAddress;
319     }
320     function changeDepositsAddress(address newDepositsAddress) external onlyForOwner {
321         depositsAddress = newDepositsAddress;
322     }
323     function openDeposit(address addr, uint256 amount, uint256 end, uint256 interestOnEnd,
324         uint256 interestBeforeEnd, uint256 interestFee, uint256 multiplier, bool closeable) external onlyForDeposits returns(bool success, uint256 DID) {
325         depositsCounter += 1;
326         DID = depositsCounter;
327         lockedBalances[addr] = safeAdd(lockedBalances[addr], amount);
328         deposits[DID] = deposits_s(
329             addr,
330             amount,
331             block.number,
332             end,
333             interestOnEnd,
334             interestBeforeEnd,
335             interestFee,
336             multiplier,
337             closeable,
338             true
339         );
340         return (true, DID);
341     }
342     function closeDeposit(uint256 DID) external onlyForDeposits returns (bool success) {
343         require( deposits[DID].valid );
344         delete deposits[DID].valid;
345         lockedBalances[deposits[DID].addr] = safeSub(lockedBalances[deposits[DID].addr], deposits[DID].amount);
346         return true;
347     }
348     function transfer(address from, address to, uint256 amount, uint256 fee) external onlyForToken returns(bool success) {
349         balanceOf[from] = safeSub(balanceOf[from], safeAdd(amount, fee));
350         balanceOf[to] = safeAdd(balanceOf[to], amount);
351         totalSupply = safeSub(totalSupply, fee);
352         return true;
353     }
354     function increase(address owner, uint256 value) external onlyForToken returns(bool success) {
355         balanceOf[owner] = safeAdd(balanceOf[owner], value);
356         totalSupply = safeAdd(totalSupply, value);
357         return true;
358     }
359     function decrease(address owner, uint256 value) external onlyForToken returns(bool success) {
360         require( safeSub(balanceOf[owner], safeAdd(lockedBalances[owner], value)) >= 0 );
361         balanceOf[owner] = safeSub(balanceOf[owner], value);
362         totalSupply = safeSub(totalSupply, value);
363         return true;
364     }
365     function setAllowance(address owner, address spender, uint256 amount, uint256 nonce) external onlyForToken returns(bool success) {
366         allowance[owner][spender].amount = amount;
367         allowance[owner][spender].nonce = nonce;
368         return true;
369     }
370     /* Constants */
371     function getAllowance(address owner, address spender) public constant returns(bool success, uint256 remaining, uint256 nonce) {
372         return ( true, allowance[owner][spender].amount, allowance[owner][spender].nonce );
373     }
374     function getDeposit(uint256 UID) public constant returns(address addr, uint256 amount, uint256 start,
375         uint256 end, uint256 interestOnEnd, uint256 interestBeforeEnd, uint256 interestFee, uint256 interestMultiplier, bool closeable, bool valid) {
376         addr = deposits[UID].addr;
377         amount = deposits[UID].amount;
378         start = deposits[UID].start;
379         end = deposits[UID].end;
380         interestOnEnd = deposits[UID].interestOnEnd;
381         interestBeforeEnd = deposits[UID].interestBeforeEnd;
382         interestFee = deposits[UID].interestFee;
383         interestMultiplier = deposits[UID].interestMultiplier;
384         closeable = deposits[UID].closeable;
385         valid = deposits[UID].valid;
386     }
387     /* Modifiers */
388     modifier onlyForToken {
389         require( msg.sender == tokenAddress );
390         _;
391     }
392     modifier onlyForDeposits {
393         require( msg.sender == depositsAddress );
394         _;
395     }
396 }
397 
398 contract TokenLib is SafeMath, Owned {
399     /**
400     * @title Gold Reserve [XGR] token
401     */
402     /* Variables */
403     string  public name = "GoldReserve";
404     string  public symbol = "XGR";
405     uint8   public decimals = 8;
406     uint256 public transactionFeeRate   = 20; // 0.02 %
407     uint256 public transactionFeeRateM  = 1e3; // 1000
408     uint256 public transactionFeeMin    =   2000000; // 0.2 XGR
409     uint256 public transactionFeeMax    = 200000000; // 2.0 XGR
410     address public databaseAddress;
411     address public depositsAddress;
412     address public forkAddress;
413     address public libAddress;
414     /* Constructor */
415     function TokenLib(address newDatabaseAddress, address newDepositAddress, address newFrokAddress, address newLibAddress) public {
416         databaseAddress = newDatabaseAddress;
417         depositsAddress = newDepositAddress;
418         forkAddress = newFrokAddress;
419         libAddress = newLibAddress;
420     }
421     /* Fallback */
422     function () public {
423         revert();
424     }
425     /* Externals */
426     function changeDataBaseAddress(address newDatabaseAddress) external onlyForOwner {
427         databaseAddress = newDatabaseAddress;
428     }
429     function changeDepositsAddress(address newDepositsAddress) external onlyForOwner {
430         depositsAddress = newDepositsAddress;
431     }
432     function changeForkAddress(address newForkAddress) external onlyForOwner {
433         forkAddress = newForkAddress;
434     }
435     function changeLibAddress(address newLibAddress) external onlyForOwner {
436         libAddress = newLibAddress;
437     }
438     function changeFees(uint256 rate, uint256 rateMultiplier, uint256 min, uint256 max) external onlyForOwner {
439         transactionFeeRate = rate;
440         transactionFeeRateM = rateMultiplier;
441         transactionFeeMin = min;
442         transactionFeeMax = max;
443     }
444     function approve(address spender, uint256 amount, uint256 nonce) external returns (bool success) {
445         _approve(spender, amount, nonce);
446         return true;
447     }
448     function approveAndCall(address spender, uint256 amount, uint256 nonce, bytes extraData) external returns (bool success) {
449         _approve(spender, amount, nonce);
450         require( checkContract(spender) );
451         require( SampleContract(spender).approvedToken(msg.sender, amount, extraData) );
452         return true;
453     }
454     function transfer(address to, uint256 amount) external returns (bool success) {
455         bytes memory _data;
456         _transfer(msg.sender, to, amount, true, _data);
457         return true;
458     }
459     function transferFrom(address from, address to, uint256 amount) external returns (bool success) {
460         if ( from != msg.sender ) {
461             var (_success, _reamining, _nonce) = TokenDB(databaseAddress).getAllowance(from, msg.sender);
462             require( _success );
463             _reamining = safeSub(_reamining, amount);
464             _nonce = safeAdd(_nonce, 1);
465             require( TokenDB(databaseAddress).setAllowance(from, msg.sender, _reamining, _nonce) );
466             AllowanceUsed(msg.sender, from, amount);
467         }
468         bytes memory _data;
469         _transfer(from, to, amount, true, _data);
470         return true;
471     }
472     function transfer(address to, uint256 amount, bytes extraData) external returns (bool success) {
473         _transfer(msg.sender, to, amount, true, extraData);
474         return true;
475     }
476     function mint(address owner, uint256 value) external returns (bool success) {
477         require( msg.sender == forkAddress || msg.sender == depositsAddress );
478         _mint(owner, value);
479         return true;
480     }
481     /* Internals */
482     function _transfer(address from, address to, uint256 amount, bool fee, bytes extraData) internal {
483         bool _success;
484         uint256 _fee;
485         uint256 _payBack;
486         uint256 _amount = amount;
487         require( from != 0x00 && to != 0x00 );
488         if( fee ) {
489             (_success, _fee) = getTransactionFee(amount);
490             require( _success );
491             if ( TokenDB(databaseAddress).balanceOf(from) == amount ) {
492                 _amount = safeSub(amount, _fee);
493             }
494         }
495         if ( fee ) {
496             Burn(from, _fee);
497         }
498         Transfer(from, to, _amount);
499         Transfer2(from, to, _amount, extraData);
500         require( TokenDB(databaseAddress).transfer(from, to, _amount, _fee) );
501         if ( isContract(to) ) {
502             require( checkContract(to) );
503             (_success, _payBack) = SampleContract(to).receiveToken(from, amount, extraData);
504             require( _success );
505             require( amount > _payBack );
506             if ( _payBack > 0 ) {
507                 bytes memory _data;
508                 Transfer(to, from, _payBack);
509                 Transfer2(to, from, _payBack, _data);
510                 require( TokenDB(databaseAddress).transfer(to, from, _payBack, 0) );
511             }
512         }
513     }
514     function _mint(address owner, uint256 value) internal {
515         require( TokenDB(databaseAddress).increase(owner, value) );
516         Mint(owner, value);
517     }
518     function _approve(address spender, uint256 amount, uint256 nonce) internal {
519         require( msg.sender != spender );
520         var (_success, _remaining, _nonce) = TokenDB(databaseAddress).getAllowance(msg.sender, spender);
521         require( _success && ( _nonce == nonce ) );
522         require( TokenDB(databaseAddress).setAllowance(msg.sender, spender, amount, nonce) );
523         Approval(msg.sender, spender, amount);
524     }
525     function isContract(address addr) internal view returns (bool success) {
526         uint256 _codeLength;
527         assembly {
528             _codeLength := extcodesize(addr)
529         }
530         return _codeLength > 0;
531     }
532     function checkContract(address addr) internal view returns (bool appropriate) {
533         return SampleContract(addr).XGRAddress() == address(this);
534     }
535     /* Constants */
536     function allowance(address owner, address spender) public constant returns (uint256 remaining, uint256 nonce) {
537         var (_success, _remaining, _nonce) = TokenDB(databaseAddress).getAllowance(owner, spender);
538         require( _success );
539         return (_remaining, _nonce);
540     }
541     function getTransactionFee(uint256 value) public constant returns (bool success, uint256 fee) {
542         fee = safeMul(value, transactionFeeRate) / transactionFeeRateM / 100;
543         if ( fee > transactionFeeMax ) { fee = transactionFeeMax; }
544         else if ( fee < transactionFeeMin ) { fee = transactionFeeMin; }
545         return (true, fee);
546     }
547     function balanceOf(address owner) public constant returns (uint256 value) {
548         return TokenDB(databaseAddress).balanceOf(owner);
549     }
550     function balancesOf(address owner) public constant returns (uint256 balance, uint256 lockedAmount) {
551         return (TokenDB(databaseAddress).balanceOf(owner), TokenDB(databaseAddress).lockedBalances(owner));
552     }
553     function totalSupply() public constant returns (uint256 value) {
554         return TokenDB(databaseAddress).totalSupply();
555     }
556     /* Events */
557     event AllowanceUsed(address indexed spender, address indexed owner, uint256 indexed value);
558     event Mint(address indexed addr, uint256 indexed value);
559     event Burn(address indexed addr, uint256 indexed value);
560     event Approval(address indexed _owner, address indexed _spender, uint _value);
561     event Transfer(address indexed _from, address indexed _to, uint _value);
562     event Transfer2(address indexed from, address indexed to, uint256 indexed value, bytes data);
563 }
564 
565 contract Deposits is Owned, SafeMath {
566     /* Structures */
567     struct depositTypes_s {
568         uint256 blockDelay;
569         uint256 baseFunds;
570         uint256 interestRateOnEnd;
571         uint256 interestRateBeforeEnd;
572         uint256 interestFee;
573         bool closeable;
574         bool valid;
575     }
576     struct deposits_s {
577         address addr;
578         uint256 amount;
579         uint256 start;
580         uint256 end;
581         uint256 interestOnEnd;
582         uint256 interestBeforeEnd;
583         uint256 interestFee;
584         uint256 interestMultiplier;
585         bool    closeable;
586         bool    valid;
587     }
588     /* Variables */
589     mapping(uint256 => depositTypes_s) public depositTypes;
590     uint256 public depositTypesCounter;
591     address public tokenAddress;
592     address public databaseAddress;
593     address public founderAddress;
594     uint256 public interestMultiplier = 1e4;
595     /* Externals */
596     function changeDataBaseAddress(address newDatabaseAddress) external onlyForOwner {
597         databaseAddress = newDatabaseAddress;
598     }
599     function changeTokenAddress(address newTokenAddress) external onlyForOwner {
600         tokenAddress = newTokenAddress;
601     }
602     function changeFounderAddresss(address newFounderAddress) external onlyForOwner {
603         founderAddress = newFounderAddress;
604     }
605     function addDepositType(uint256 blockDelay, uint256 baseFunds, uint256 interestRateOnEnd,
606         uint256 interestRateBeforeEnd, uint256 interestFee, bool closeable) external onlyForOwner {
607         depositTypesCounter += 1;
608         uint256 DTID = depositTypesCounter;
609         depositTypes[DTID] = depositTypes_s(
610             blockDelay,
611             baseFunds,
612             interestRateOnEnd,
613             interestRateBeforeEnd,
614             interestFee,
615             closeable,
616             true
617         );
618         EventNewDepositType(
619             DTID,
620             blockDelay,
621             baseFunds,
622             interestRateOnEnd,
623             interestRateBeforeEnd,
624             interestFee,
625             closeable
626         );
627     }
628     function rekoveDepositType(uint256 DTID) external onlyForOwner {
629         depositTypes[DTID].valid = false;
630     }
631     function placeDeposit(uint256 amount, uint256 depositType) external checkSelf {
632         require( depositTypes[depositType].valid );
633         require( depositTypes[depositType].baseFunds <= amount );
634         uint256 balance = TokenDB(databaseAddress).balanceOf(msg.sender);
635         uint256 locked = TokenDB(databaseAddress).lockedBalances(msg.sender);
636         require( safeSub(balance, locked) >= amount );
637         var (success, DID) = TokenDB(databaseAddress).openDeposit(
638             msg.sender,
639             amount,
640             safeAdd(block.number, depositTypes[depositType].blockDelay),
641             depositTypes[depositType].interestRateOnEnd,
642             depositTypes[depositType].interestRateBeforeEnd,
643             depositTypes[depositType].interestFee,
644             interestMultiplier,
645             depositTypes[depositType].closeable
646         );
647         require( success );
648         EventNewDeposit(DID);
649     }
650     function closeDeposit(address beneficary, uint256 DID) external checkSelf {
651         address _beneficary = beneficary;
652         if ( _beneficary == 0x00 ) {
653             _beneficary = msg.sender;
654         }
655         var (addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee,
656             interestM, closeable, valid) = TokenDB(databaseAddress).getDeposit(DID);
657         _closeDeposit(_beneficary, DID, deposits_s(addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee, interestM, closeable, valid));
658     }
659     /* Internals */
660     function _closeDeposit(address beneficary, uint256 DID, deposits_s data) internal {
661         require( data.valid && data.addr == msg.sender );
662         var (interest, interestFee) = _calculateInterest(data);
663         if ( interest > 0 ) {
664             require( Token(tokenAddress).mint(beneficary, interest) );
665         }
666         if ( interestFee > 0 ) {
667             require( Token(tokenAddress).mint(founderAddress, interestFee) );
668         }
669         require( TokenDB(databaseAddress).closeDeposit(DID) );
670         EventDepositClosed(DID, interest, interestFee);
671     }
672     function _calculateInterest(deposits_s data) internal view returns (uint256 interest, uint256 interestFee) {
673         if ( ! data.valid || data.amount <= 0 || data.end <= data.start || block.number <= data.start ) { return (0, 0); }
674         uint256 rate;
675         uint256 delay;
676         if ( data.end <= block.number ) {
677             rate = data.interestOnEnd;
678             delay = safeSub(data.end, data.start);
679         } else {
680             require( data.closeable );
681             rate = data.interestBeforeEnd;
682             delay = safeSub(block.number, data.start);
683         }
684         if ( rate == 0 ) { return (0, 0); }
685         interest = safeDiv(safeMul(safeDiv(safeDiv(safeMul(data.amount, rate), 100), data.interestMultiplier), delay), safeSub(data.end, data.start));
686         if ( data.interestFee > 0 && interest > 0) {
687             interestFee = safeDiv(safeDiv(safeMul(interest, data.interestFee), 100), data.interestMultiplier);
688         }
689         if ( interestFee > 0 ) {
690             interest = safeSub(interest, interestFee);
691         }
692     }
693     /* Constants */
694     function calculateInterest(uint256 DID) public view returns(uint256, uint256) {
695         var (addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee,
696             interestM, closeable, valid) = TokenDB(databaseAddress).getDeposit(DID);
697         return _calculateInterest(deposits_s(addr, amount, start, end, interestOnEnd, interestBeforeEnd, interestFee, interestM, closeable, valid));
698     }
699     /* Modifiers */
700     modifier checkSelf {
701         require( TokenDB(databaseAddress).tokenAddress() == tokenAddress );
702         require( TokenDB(databaseAddress).depositsAddress() == address(this) );
703         _;
704     }
705     /* Events */
706     event EventNewDepositType(uint256 indexed DTID, uint256 blockDelay, uint256 baseFunds,
707         uint256 interestRateOnEnd, uint256 interestRateBeforeEnd, uint256 interestFee, bool closeable);
708     event EventRevokeDepositType(uint256 indexed DTID);
709     event EventNewDeposit(uint256 indexed DID);
710     event EventDepositClosed(uint256 indexed DID, uint256 indexed interest, uint256 indexed interestFee);
711 }
712 
713 contract Fork is Owned {
714     /* Variables */
715     address public uploader;
716     address public tokenAddress;
717     /* Constructor */
718     function Fork(address _uploader) public {
719         uploader = _uploader;
720     }
721     /* Externals */
722     function changeTokenAddress(address newTokenAddress) external onlyForOwner {
723         tokenAddress = newTokenAddress;
724     }
725     function upload(address[] addr, uint256[] amount) external onlyForUploader {
726         require( addr.length == amount.length );
727         for ( uint256 a=0 ; a<addr.length ; a++ ) {
728             require( Token(tokenAddress).mint(addr[a], amount[a]) );
729         }
730     }
731     /* Modifiers */
732     modifier onlyForUploader {
733         require( msg.sender == uploader );
734         _;
735     }
736 }
737 
738 contract SampleContract is Owned, SafeMath {
739     /* Variables */
740     mapping(address => uint256) public deposits; // Database of users balance
741     address public XGRAddress; // XGR Token address, please do not change this variable name!
742     /* Constructor */
743     function SampleContract(address newXGRTokenAddress) public {
744         /*
745             For the first time you need set the XGR token address.
746             The contract deployer would be also the owner.
747         */
748         XGRAddress = newXGRTokenAddress;
749     }
750     /* Externals */
751     function receiveToken(address addr, uint256 amount, bytes data) external onlyFromXGRToken returns(bool, uint256) {
752         /*
753             @addr has send @amount to ourself. The second return parameter is the refund amount.
754             If you don't need the whole amount, you can refund that for the address instantly.
755             Please do not change this function name and parameter!
756         */
757         incomingToken(addr, amount);
758         return (true, 0);
759     }
760     function approvedToken(address addr, uint256 amount, bytes data) external onlyFromXGRToken returns(bool) {
761         /*
762             @addr has allowed @amount for withdraw from her/his balance. We withdraw that to ourself.
763             Please do not change this function name and parameter!
764         */
765         require( Token(XGRAddress).transferFrom(addr, address(this), amount) );
766         incomingToken(addr, amount);
767         return true;
768     }
769     function changeTokenAddress(address newTokenAddress) external onlyForOwner {
770         /*
771             Maybe the XGR token contract becomes new address, you need maintenance this.
772         */
773         XGRAddress = newTokenAddress;
774     }
775     function killThisContract() external onlyForOwner {
776         var balance = Token(XGRAddress).balanceOf(address(this)); // get this contract XGR balance
777         require( Token(XGRAddress).transfer(msg.sender, balance) ); // send all XGR token to the caller
778         selfdestruct(msg.sender); // destruct the contract;
779     }
780     function withdraw(uint256 amount) external {
781         /*
782             Some users withdraw XGR token from this contract.
783             The contract must pay the XGR token fee, we need to reduce that from the amount;
784         */
785         var (success, fee) = Token(XGRAddress).getTransactionFee(amount); // Get the transfer fee from the contract
786         require( success );
787         withdrawToken(msg.sender, amount);
788         require( Token(XGRAddress).transfer(msg.sender, safeSub(amount, fee)) );
789     }
790     /* Internals */
791     function incomingToken(address addr, uint256 amount) internal {
792         deposits[addr] = safeAdd(deposits[addr], amount);
793     }
794     function withdrawToken(address addr, uint256 amount) internal {
795         deposits[addr] = safeSub(deposits[addr], amount);
796     }
797     /* Modifiers */
798     modifier onlyFromXGRToken {
799         require( msg.sender == XGRAddress );
800         _;
801     }
802 }