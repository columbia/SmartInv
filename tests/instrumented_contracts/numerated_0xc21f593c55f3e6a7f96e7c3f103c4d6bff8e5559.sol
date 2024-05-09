1 pragma solidity ^0.4.23;
2 pragma experimental "v0.5.0";
3 pragma experimental ABIEncoderV2;
4 
5 library AddressExtension {
6 
7   function isValid(address _address) internal pure returns (bool) {
8     return 0 != _address;
9   }
10 
11   function isAccount(address _address) internal view returns (bool result) {
12     assembly {
13       result := iszero(extcodesize(_address))
14     }
15   }
16 
17   function toBytes(address _address) internal pure returns (bytes b) {
18    assembly {
19       let m := mload(0x40)
20       mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, _address))
21       mstore(0x40, add(m, 52))
22       b := m
23     }
24   }
25 }
26 
27 library Math {
28 
29   struct Fraction {
30     uint256 numerator;
31     uint256 denominator;
32   }
33 
34   function mul(uint256 a, uint256 b) internal pure returns (uint256 r) {
35     r = a * b;
36     require((a == 0) || (r / a == b));
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256 r) {
40     r = a / b;
41   }
42 
43   function sub(uint256 a, uint256 b) internal pure returns (uint256 r) {
44     require((r = a - b) <= a);
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256 r) {
48     require((r = a + b) >= a);
49   }
50 
51   function min(uint256 x, uint256 y) internal pure returns (uint256 r) {
52     return x <= y ? x : y;
53   }
54 
55   function max(uint256 x, uint256 y) internal pure returns (uint256 r) {
56     return x >= y ? x : y;
57   }
58 
59   function mulDiv(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
60     r = value * m;
61     if (r / value == m) {
62       r /= d;
63     } else {
64       r = mul(value / d, m);
65     }
66   }
67 
68   function mulDivCeil(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
69     r = value * m;
70     if (r / value == m) {
71       r /= d;
72       if (r % d != 0) {
73         r += 1;
74       }
75     } else {
76       r = mul(value / d, m);
77       if (value % d != 0) {
78         r += 1;
79       }
80     }
81   }
82 
83   function mul(uint256 x, Fraction memory f) internal pure returns (uint256) {
84     return mulDiv(x, f.numerator, f.denominator);
85   }
86 
87   function mulCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
88     return mulDivCeil(x, f.numerator, f.denominator);
89   }
90 
91   function div(uint256 x, Fraction memory f) internal pure returns (uint256) {
92     return mulDiv(x, f.denominator, f.numerator);
93   }
94 
95   function divCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
96     return mulDivCeil(x, f.denominator, f.numerator);
97   }
98 }
99 
100 contract FsTKAuthority {
101 
102   function isAuthorized(address sender, address _contract, bytes data) public view returns (bool);
103   function isApproved(bytes32 hash, uint256 approveTime, bytes approveToken) public view returns (bool);
104   function validate() public pure returns (bool);
105 }
106 
107 contract ERC20 {
108 
109   event Transfer(address indexed from, address indexed to, uint256 value);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111 
112   function balanceOf(address owner) public view returns (uint256);
113   function allowance(address owner, address spender) public view returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117 }
118 
119 contract SecureERC20 is ERC20 {
120 
121   event SetERC20ApproveChecking(bool approveChecking);
122 
123   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool);
124   function increaseAllowance(address spender, uint256 value) public returns (bool);
125   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool);
126   function setERC20ApproveChecking(bool approveChecking) public;
127 }
128 
129 contract FsTKToken {
130 
131   event SetupDirectDebit(address indexed debtor, address indexed receiver, DirectDebitInfo info);
132   event TerminateDirectDebit(address indexed debtor, address indexed receiver);
133   event WithdrawDirectDebitFailure(address indexed debtor, address indexed receiver);
134 
135   event SetMetadata(string metadata);
136   event SetLiquid(bool liquidity);
137   event SetDelegate(bool isDelegateEnable);
138   event SetDirectDebit(bool isDirectDebitEnable);
139 
140   struct DirectDebitInfo {
141     uint256 amount;
142     uint256 startTime;
143     uint256 interval;
144   }
145   struct DirectDebit {
146     DirectDebitInfo info;
147     uint256 epoch;
148   }
149   struct Instrument {
150     uint256 allowance;
151     DirectDebit directDebit;
152   }
153   struct Account {
154     uint256 balance;
155     uint256 nonce;
156     mapping (address => Instrument) instruments;
157   }
158 
159   function spendableAllowance(address owner, address spender) public view returns (uint256);
160   function transfer(uint256[] data) public returns (bool);
161   function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool);
162   function delegateTransferAndCall(
163     uint256 nonce,
164     uint256 gasAmount,
165     address to,
166     uint256 value,
167     bytes data,
168     uint8 v,
169     bytes32 r,
170     bytes32 s
171   ) public returns (bool);
172 
173   function directDebitOf(address debtor, address receiver) public view returns (DirectDebit);
174   function setupDirectDebit(address receiver, DirectDebitInfo info) public returns (bool);
175   function terminateDirectDebit(address receiver) public returns (bool);
176   function withdrawDirectDebit(address debtor) public returns (bool);
177   function withdrawDirectDebit(address[] debtors, bool strict) public returns (bool result);
178 }
179 
180 contract AbstractToken is SecureERC20, FsTKToken {
181   using AddressExtension for address;
182   using Math for uint256;
183 
184   modifier liquid {
185     require(isLiquid);
186      _;
187   }
188   modifier canUseDirectDebit {
189     require(isDirectDebitEnable);
190      _;
191   }
192 
193   bool public erc20ApproveChecking;
194   bool public isLiquid = true;
195   bool public isDelegateEnable;
196   bool public isDirectDebitEnable;
197   string public metadata;
198   mapping(address => Account) internal accounts;
199 
200   constructor(string _metadata) public {
201     metadata = _metadata;
202   }
203 
204   function balanceOf(address owner) public view returns (uint256) {
205     return accounts[owner].balance;
206   }
207 
208   function allowance(address owner, address spender) public view returns (uint256) {
209     return accounts[owner].instruments[spender].allowance;
210   }
211 
212   function transfer(address to, uint256 value) public liquid returns (bool) {
213     Account storage senderAccount = accounts[msg.sender];
214     uint256 senderBalance = senderAccount.balance;
215     require(value <= senderBalance);
216 
217     senderAccount.balance = senderBalance - value;
218     accounts[to].balance += value;
219 
220     emit Transfer(msg.sender, to, value);
221     return true;
222   }
223 
224   function transferFrom(address from, address to, uint256 value) public liquid returns (bool) {
225     Account storage fromAccount = accounts[from];
226     uint256 fromBalance = fromAccount.balance;
227     Instrument storage senderInstrument = fromAccount.instruments[msg.sender];
228     uint256 senderAllowance = senderInstrument.allowance;
229     require(value <= fromBalance);
230     require(value <= senderAllowance);
231 
232     fromAccount.balance = fromBalance - value;
233     senderInstrument.allowance = senderAllowance - value;
234     accounts[to].balance += value;
235 
236     emit Transfer(from, to, value);
237     return true;
238   }
239 
240   function approve(address spender, uint256 value) public returns (bool) {
241     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
242     if (erc20ApproveChecking) {
243       require((value == 0) || (spenderInstrument.allowance == 0));
244     }
245     spenderInstrument.allowance = value;
246 
247     emit Approval(msg.sender, spender, value);
248     return true;
249   }
250 
251   function setERC20ApproveChecking(bool approveChecking) public {
252     emit SetERC20ApproveChecking(erc20ApproveChecking = approveChecking);
253   }
254 
255   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool) {
256     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
257     require(spenderInstrument.allowance == expectedValue);
258 
259     spenderInstrument.allowance = newValue;
260 
261     emit Approval(msg.sender, spender, newValue);
262     return true;
263   }
264 
265   function increaseAllowance(address spender, uint256 value) public returns (bool) {
266     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
267 
268     uint256 newValue = spenderInstrument.allowance.add(value);
269     spenderInstrument.allowance = newValue;
270 
271     emit Approval(msg.sender, spender, newValue);
272     return true;
273   }
274 
275   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool) {
276     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
277 
278     uint256 currentValue = spenderInstrument.allowance;
279     uint256 newValue;
280     if (strict) {
281       newValue = currentValue.sub(value);
282     } else if (value < currentValue) {
283       newValue = currentValue - value;
284     }
285     spenderInstrument.allowance = newValue;
286 
287     emit Approval(msg.sender, spender, newValue);
288     return true;
289   }
290 
291   function setMetadata0(string _metadata) internal {
292     emit SetMetadata(metadata = _metadata);
293   }
294 
295   function setLiquid0(bool liquidity) internal {
296     emit SetLiquid(isLiquid = liquidity);
297   }
298 
299   function setDelegate(bool delegate) public {
300     emit SetDelegate(isDelegateEnable = delegate);
301   }
302 
303   function setDirectDebit(bool directDebit) public {
304     emit SetDirectDebit(isDirectDebitEnable = directDebit);
305   }
306 
307   function spendableAllowance(address owner, address spender) public view returns (uint256) {
308     Account storage ownerAccount = accounts[owner];
309     return Math.min(
310       ownerAccount.instruments[spender].allowance,
311       ownerAccount.balance
312     );
313   }
314 
315   function transfer(uint256[] data) public liquid returns (bool) {
316     Account storage senderAccount = accounts[msg.sender];
317     uint256 totalValue;
318     for (uint256 i = 0; i < data.length; i++) {
319       address receiver = address(data[i] >> 96);
320       uint256 value = data[i] & 0xffffffffffffffffffffffff;
321 
322       totalValue = totalValue.add(value);
323       accounts[receiver].balance += value;
324 
325       emit Transfer(msg.sender, receiver, value);
326     }
327 
328     uint256 senderBalance = senderAccount.balance;
329     require(totalValue <= senderBalance);
330     senderAccount.balance = senderBalance - totalValue;
331 
332     return true;
333   }
334 
335   function transferAndCall(address to, uint256 value, bytes data) public payable liquid returns (bool) {
336     require(to != address(this));
337     require(transfer(to, value));
338     require(data.length >= 68);
339     assembly {
340         mstore(add(data, 36), value)
341         mstore(add(data, 68), caller)
342     }
343     require(to.call.value(msg.value)(data));
344     return true;
345   }
346 
347   function delegateTransferAndCall(
348     uint256 nonce,
349     uint256 gasAmount,
350     address to,
351     uint256 value,
352     bytes data,
353     uint8 v,
354     bytes32 r,
355     bytes32 s
356   )
357     public
358     liquid
359     returns (bool)
360   {
361     require(isDelegateEnable);
362     require(to != address(this));
363 
364     address signer = ecrecover(
365       keccak256(nonce, gasAmount, to, value, data),
366       v,
367       r,
368       s
369     );
370     Account storage signerAccount = accounts[signer];
371     require(nonce == signerAccount.nonce);
372     signerAccount.nonce = nonce.add(1);
373     uint256 signerBalance = signerAccount.balance;
374     uint256 total = value.add(gasAmount);
375     require(total <= signerBalance);
376 
377     signerAccount.balance = signerBalance - total;
378     accounts[to].balance += value;
379     emit Transfer(signer, to, value);
380     accounts[msg.sender].balance += gasAmount;
381     emit Transfer(signer, msg.sender, gasAmount);
382 
383     if (!to.isAccount()) {
384       require(data.length >= 68);
385       assembly {
386         mstore(add(data, 36), value)
387         mstore(add(data, 68), signer)
388       }
389       require(to.call(data));
390     }
391 
392     return true;
393   }
394 
395   function directDebitOf(address debtor, address receiver) public view returns (DirectDebit) {
396     return accounts[debtor].instruments[receiver].directDebit;
397   }
398 
399   function setupDirectDebit(
400     address receiver,
401     DirectDebitInfo info
402   )
403     public
404     returns (bool)
405   {
406     accounts[msg.sender].instruments[receiver].directDebit = DirectDebit({
407       info: info,
408       epoch: 0
409     });
410 
411     emit SetupDirectDebit(msg.sender, receiver, info);
412     return true;
413   }
414 
415   function terminateDirectDebit(address receiver) public returns (bool) {
416     delete accounts[msg.sender].instruments[receiver].directDebit;
417 
418     emit TerminateDirectDebit(msg.sender, receiver);
419     return true;
420   }
421 
422   function calculateTotalDirectDebitAmount(uint256 amount, uint256 epochNow, uint256 epochLast) pure private returns (uint256) {
423     require(amount > 0);
424     require(epochNow > epochLast);
425     return (epochNow - epochLast).mul(amount);
426   }
427 
428   function withdrawDirectDebit(address debtor) public liquid canUseDirectDebit returns (bool) {
429     Account storage debtorAccount = accounts[debtor];
430     uint256 debtorBalance = debtorAccount.balance;
431     DirectDebit storage directDebit = debtorAccount.instruments[msg.sender].directDebit;
432     uint256 epoch = block.timestamp.sub(directDebit.info.startTime) / directDebit.info.interval + 1;
433     uint256 amount = calculateTotalDirectDebitAmount(directDebit.info.amount, epoch, directDebit.epoch);
434     require(amount <= debtorBalance);
435 
436     debtorAccount.balance = debtorBalance - amount;
437     accounts[msg.sender].balance += amount;
438     directDebit.epoch = epoch;
439 
440     emit Transfer(debtor, msg.sender, amount);
441     return true;
442   }
443 
444   function withdrawDirectDebit(address[] debtors, bool strict) public liquid canUseDirectDebit returns (bool result) {
445     Account storage receiverAccount = accounts[msg.sender];
446     result = true;
447 
448     for (uint256 i = 0; i < debtors.length; i++) {
449       address debtor = debtors[i];
450       Account storage debtorAccount = accounts[debtor];
451       uint256 debtorBalance = debtorAccount.balance;
452       DirectDebit storage directDebit = debtorAccount.instruments[msg.sender].directDebit;
453       uint256 epoch = block.timestamp.sub(directDebit.info.startTime) / directDebit.info.interval + 1;
454       uint256 amount = calculateTotalDirectDebitAmount(directDebit.info.amount, epoch, directDebit.epoch);
455 
456       if (amount > debtorBalance) {
457         if (strict) {
458           revert();
459         }
460         result = false;
461         emit WithdrawDirectDebitFailure(debtor, msg.sender);
462       } else {
463         debtorAccount.balance = debtorBalance - amount;
464         receiverAccount.balance += amount;
465         directDebit.epoch = epoch;
466 
467         emit Transfer(debtor, msg.sender, amount);
468       }
469     }
470   }
471 }
472 
473 contract Authorizable {
474 
475   event SetFsTKAuthority(FsTKAuthority indexed _address);
476 
477   modifier onlyFsTKAuthorized {
478     require(fstkAuthority.isAuthorized(msg.sender, this, msg.data));
479     _;
480   }
481   modifier onlyFsTKApproved(bytes32 hash, uint256 approveTime, bytes approveToken) {
482     require(fstkAuthority.isApproved(hash, approveTime, approveToken));
483     _;
484   }
485 
486   FsTKAuthority internal fstkAuthority;
487 
488   constructor(FsTKAuthority _fstkAuthority) internal {
489     fstkAuthority = _fstkAuthority;
490   }
491 
492   function setFsTKAuthority(FsTKAuthority _fstkAuthority) public onlyFsTKAuthorized {
493     require(_fstkAuthority.validate());
494     emit SetFsTKAuthority(fstkAuthority = _fstkAuthority);
495   }
496 }
497 
498 contract IssuerContract {
499   using AddressExtension for address;
500 
501   event SetIssuer(address indexed _address);
502 
503   modifier onlyIssuer {
504     require(issuer == msg.sender);
505     _;
506   }
507 
508   address public issuer;
509 
510   constructor(address _issuer) internal {
511     issuer = _issuer;
512   }
513 
514   function setIssuer(address _address) public onlyIssuer {
515     emit SetIssuer(issuer = _address);
516   }
517 }
518 
519 contract SmartToken is AbstractToken, IssuerContract, Authorizable {
520 
521   string public name;
522   string public symbol;
523   uint256 public totalSupply;
524   uint8 public constant decimals = 18;
525 
526   constructor(
527     address _issuer,
528     FsTKAuthority _fstkAuthority,
529     string _name,
530     string _symbol,
531     uint256 _totalSupply,
532     string _metadata
533   )
534     AbstractToken(_metadata)
535     IssuerContract(_issuer)
536     Authorizable(_fstkAuthority)
537     public
538   {
539     name = _name;
540     symbol = _symbol;
541     totalSupply = _totalSupply;
542 
543     accounts[_issuer].balance = _totalSupply;
544     emit Transfer(address(0), _issuer, _totalSupply);
545   }
546 
547   function setERC20ApproveChecking(bool approveChecking) public onlyIssuer {
548     AbstractToken.setERC20ApproveChecking(approveChecking);
549   }
550 
551   function setDelegate(bool delegate) public onlyIssuer {
552     AbstractToken.setDelegate(delegate);
553   }
554 
555   function setDirectDebit(bool directDebit) public onlyIssuer {
556     AbstractToken.setDirectDebit(directDebit);
557   }
558 
559   function setMetadata(
560     string infoUrl,
561     uint256 approveTime,
562     bytes approveToken
563   )
564     public
565     onlyIssuer
566     onlyFsTKApproved(keccak256(approveTime, this, msg.sig, infoUrl), approveTime, approveToken)
567   {
568     setMetadata0(infoUrl);
569   }
570 
571   function setLiquid(
572     bool liquidity,
573     uint256 approveTime,
574     bytes approveToken
575   )
576     public
577     onlyIssuer
578     onlyFsTKApproved(keccak256(approveTime, this, msg.sig, liquidity), approveTime, approveToken)
579   {
580     setLiquid0(liquidity);
581   }
582 }