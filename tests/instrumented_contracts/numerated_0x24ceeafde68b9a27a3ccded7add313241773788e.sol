1 pragma solidity ^0.4.24;
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
34   function isPositive(Fraction memory fraction) internal pure returns (bool) {
35     return fraction.numerator > 0 && fraction.denominator > 0;
36   }
37 
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 r) {
39     r = a * b;
40     require((a == 0) || (r / a == b));
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256 r) {
44     r = a / b;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256 r) {
48     require((r = a - b) <= a);
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256 r) {
52     require((r = a + b) >= a);
53   }
54 
55   function min(uint256 x, uint256 y) internal pure returns (uint256 r) {
56     return x <= y ? x : y;
57   }
58 
59   function max(uint256 x, uint256 y) internal pure returns (uint256 r) {
60     return x >= y ? x : y;
61   }
62 
63   function mulDiv(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
64     r = value * m;
65     if (r / value == m) {
66       r /= d;
67     } else {
68       r = mul(value / d, m);
69     }
70   }
71 
72   function mulDivCeil(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
73     r = value * m;
74     if (r / value == m) {
75       if (r % d == 0) {
76         r /= d;
77       } else {
78         r = (r / d) + 1;
79       }
80     } else {
81       r = mul(value / d, m);
82       if (value % d != 0) {
83         r += 1;
84       }
85     }
86   }
87 
88   function mul(uint256 x, Fraction memory f) internal pure returns (uint256) {
89     return mulDiv(x, f.numerator, f.denominator);
90   }
91 
92   function mulCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
93     return mulDivCeil(x, f.numerator, f.denominator);
94   }
95 
96   function div(uint256 x, Fraction memory f) internal pure returns (uint256) {
97     return mulDiv(x, f.denominator, f.numerator);
98   }
99 
100   function divCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
101     return mulDivCeil(x, f.denominator, f.numerator);
102   }
103 
104   function mul(Fraction memory x, Fraction memory y) internal pure returns (Math.Fraction) {
105     return Math.Fraction({
106       numerator: mul(x.numerator, y.numerator),
107       denominator: mul(x.denominator, y.denominator)
108     });
109   }
110 }
111 
112 contract FsTKAuthority {
113 
114   function isAuthorized(address sender, address _contract, bytes data) public view returns (bool);
115   function isApproved(bytes32 hash, uint256 approveTime, bytes approveToken) public view returns (bool);
116   function validate() public pure returns (bytes4);
117 }
118 
119 contract Authorizable {
120 
121   event SetFsTKAuthority(FsTKAuthority indexed _address);
122 
123   modifier onlyFsTKAuthorized {
124     require(fstkAuthority.isAuthorized(msg.sender, this, msg.data));
125     _;
126   }
127   modifier onlyFsTKApproved(bytes32 hash, uint256 approveTime, bytes approveToken) {
128     require(fstkAuthority.isApproved(hash, approveTime, approveToken));
129     _;
130   }
131 
132   FsTKAuthority internal fstkAuthority;
133 
134   constructor(FsTKAuthority _fstkAuthority) internal {
135     fstkAuthority = _fstkAuthority;
136   }
137 
138   function setFsTKAuthority(FsTKAuthority _fstkAuthority) public onlyFsTKAuthorized {
139     require(_fstkAuthority.validate() == _fstkAuthority.validate.selector);
140     emit SetFsTKAuthority(fstkAuthority = _fstkAuthority);
141   }
142 }
143 
144 contract IssuerContract {
145   using AddressExtension for address;
146 
147   event SetIssuer(address indexed _address);
148 
149   modifier onlyIssuer {
150     require(issuer == msg.sender);
151     _;
152   }
153 
154   address public issuer;
155   address public newIssuer;
156 
157   constructor(address _issuer) internal {
158     issuer = _issuer;
159   }
160 
161   function setIssuer(address _address) public onlyIssuer {
162     newIssuer = _address;
163   }
164 
165   function confirmSetIssuer() public {
166     require(newIssuer == msg.sender);
167     emit SetIssuer(issuer = newIssuer);
168     delete newIssuer;
169   }
170 }
171 
172 contract ERC20 {
173 
174   event Transfer(address indexed from, address indexed to, uint256 value);
175   event Approval(address indexed owner, address indexed spender, uint256 value);
176 
177   function balanceOf(address owner) public view returns (uint256);
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transfer(address to, uint256 value) public returns (bool);
180   function transferFrom(address from, address to, uint256 value) public returns (bool);
181   function approve(address spender, uint256 value) public returns (bool);
182 }
183 
184 contract SecureERC20 is ERC20 {
185 
186   event SetERC20ApproveChecking(bool approveChecking);
187 
188   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool);
189   function increaseAllowance(address spender, uint256 value) public returns (bool);
190   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool);
191   function setERC20ApproveChecking(bool approveChecking) public;
192 }
193 
194 contract FsTKToken {
195 
196   enum DelegateMode { PublicMsgSender, PublicTxOrigin, PrivateMsgSender, PrivateTxOrigin }
197 
198   event Consume(address indexed from, uint256 value, bytes32 challenge);
199   event IncreaseNonce(address indexed from, uint256 nonce);
200   event SetupDirectDebit(address indexed debtor, address indexed receiver, DirectDebitInfo info);
201   event TerminateDirectDebit(address indexed debtor, address indexed receiver);
202   event WithdrawDirectDebitFailure(address indexed debtor, address indexed receiver);
203 
204   event SetMetadata(string metadata);
205   event SetLiquid(bool liquidity);
206   event SetDelegate(bool isDelegateEnable);
207   event SetDirectDebit(bool isDirectDebitEnable);
208 
209   struct DirectDebitInfo {
210     uint256 amount;
211     uint256 startTime;
212     uint256 interval;
213   }
214   struct DirectDebit {
215     DirectDebitInfo info;
216     uint256 epoch;
217   }
218   struct Instrument {
219     uint256 allowance;
220     DirectDebit directDebit;
221   }
222   struct Account {
223     uint256 balance;
224     uint256 nonce;
225     mapping (address => Instrument) instruments;
226   }
227 
228   function spendableAllowance(address owner, address spender) public view returns (uint256);
229   function transfer(uint256[] data) public returns (bool);
230   function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool);
231 
232   function nonceOf(address owner) public view returns (uint256);
233   function increaseNonce() public returns (bool);
234   function delegateTransferAndCall(
235     uint256 nonce,
236     uint256 fee,
237     uint256 gasAmount,
238     address to,
239     uint256 value,
240     bytes data,
241     DelegateMode mode,
242     uint8 v,
243     bytes32 r,
244     bytes32 s
245   ) public returns (bool);
246 
247   function directDebit(address debtor, address receiver) public view returns (DirectDebit);
248   function setupDirectDebit(address receiver, DirectDebitInfo info) public returns (bool);
249   function terminateDirectDebit(address receiver) public returns (bool);
250   function withdrawDirectDebit(address debtor) public returns (bool);
251   function withdrawDirectDebit(address[] debtors, bool strict) public returns (bool);
252 }
253 
254 contract ERC20Like is SecureERC20, FsTKToken {
255   using AddressExtension for address;
256   using Math for uint256;
257 
258   modifier liquid {
259     require(isLiquid);
260      _;
261   }
262   modifier canUseDirectDebit {
263     require(isDirectDebitEnable);
264      _;
265   }
266   modifier canDelegate {
267     require(isDelegateEnable);
268      _;
269   }
270 
271   bool public erc20ApproveChecking;
272   bool public isLiquid = true;
273   bool public isDelegateEnable;
274   bool public isDirectDebitEnable;
275   string public metadata;
276   mapping(address => Account) internal accounts;
277 
278   constructor(string _metadata) public {
279     metadata = _metadata;
280   }
281 
282   function balanceOf(address owner) public view returns (uint256) {
283     return accounts[owner].balance;
284   }
285 
286   function allowance(address owner, address spender) public view returns (uint256) {
287     return accounts[owner].instruments[spender].allowance;
288   }
289 
290   function transfer(address to, uint256 value) public liquid returns (bool) {
291     Account storage senderAccount = accounts[msg.sender];
292 
293     senderAccount.balance = senderAccount.balance.sub(value);
294     accounts[to].balance += value;
295 
296     emit Transfer(msg.sender, to, value);
297     return true;
298   }
299 
300   function transferFrom(address from, address to, uint256 value) public liquid returns (bool) {
301     Account storage fromAccount = accounts[from];
302     Instrument storage senderInstrument = fromAccount.instruments[msg.sender];
303 
304     fromAccount.balance = fromAccount.balance.sub(value);
305     senderInstrument.allowance = senderInstrument.allowance.sub(value);
306     accounts[to].balance += value;
307 
308     emit Transfer(from, to, value);
309     return true;
310   }
311 
312   function approve(address spender, uint256 value) public returns (bool) {
313     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
314     if (erc20ApproveChecking) {
315       require((value == 0) || (spenderInstrument.allowance == 0));
316     }
317 
318     emit Approval(
319       msg.sender,
320       spender,
321       spenderInstrument.allowance = value
322     );
323     return true;
324   }
325 
326   function setERC20ApproveChecking(bool approveChecking) public {
327     emit SetERC20ApproveChecking(erc20ApproveChecking = approveChecking);
328   }
329 
330   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool) {
331     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
332     require(spenderInstrument.allowance == expectedValue);
333 
334     emit Approval(
335       msg.sender,
336       spender,
337       spenderInstrument.allowance = newValue
338     );
339     return true;
340   }
341 
342   function increaseAllowance(address spender, uint256 value) public returns (bool) {
343     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
344 
345     emit Approval(
346       msg.sender,
347       spender,
348       spenderInstrument.allowance = spenderInstrument.allowance.add(value)
349     );
350     return true;
351   }
352 
353   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool) {
354     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
355 
356     uint256 currentValue = spenderInstrument.allowance;
357     uint256 newValue;
358     if (strict) {
359       newValue = currentValue.sub(value);
360     } else if (value < currentValue) {
361       newValue = currentValue - value;
362     }
363 
364     emit Approval(
365       msg.sender,
366       spender,
367       spenderInstrument.allowance = newValue
368     );
369     return true;
370   }
371 
372   function setMetadata0(string _metadata) internal {
373     emit SetMetadata(metadata = _metadata);
374   }
375 
376   function setLiquid0(bool liquidity) internal {
377     emit SetLiquid(isLiquid = liquidity);
378   }
379 
380   function setDelegate(bool delegate) public {
381     emit SetDelegate(isDelegateEnable = delegate);
382   }
383 
384   function setDirectDebit(bool directDebit) public {
385     emit SetDirectDebit(isDirectDebitEnable = directDebit);
386   }
387 
388   function spendableAllowance(address owner, address spender) public view returns (uint256) {
389     Account storage ownerAccount = accounts[owner];
390     return Math.min(
391       ownerAccount.instruments[spender].allowance,
392       ownerAccount.balance
393     );
394   }
395 
396   function transfer(uint256[] data) public liquid returns (bool) {
397     Account storage senderAccount = accounts[msg.sender];
398     uint256 totalValue;
399 
400     for (uint256 i = 0; i < data.length; i++) {
401       address receiver = address(data[i] >> 96);
402       uint256 value = data[i] & 0xffffffffffffffffffffffff;
403 
404       totalValue = totalValue.add(value);
405       accounts[receiver].balance += value;
406 
407       emit Transfer(msg.sender, receiver, value);
408     }
409 
410     senderAccount.balance = senderAccount.balance.sub(totalValue);
411 
412     return true;
413   }
414 
415   function transferAndCall(
416     address to,
417     uint256 value,
418     bytes data
419   )
420     public
421     payable
422     liquid
423     returns (bool)
424   {
425     require(
426       to != address(this) &&
427       data.length >= 68 &&
428       transfer(to, value)
429     );
430     assembly {
431         mstore(add(data, 36), value)
432         mstore(add(data, 68), caller)
433     }
434     require(to.call.value(msg.value)(data));
435     return true;
436   }
437 
438   function nonceOf(address owner) public view returns (uint256) {
439     return accounts[owner].nonce;
440   }
441 
442   function increaseNonce() public returns (bool) {
443     emit IncreaseNonce(msg.sender, accounts[msg.sender].nonce += 1);
444   }
445 
446   function delegateTransferAndCall(
447     uint256 nonce,
448     uint256 fee,
449     uint256 gasAmount,
450     address to,
451     uint256 value,
452     bytes data,
453     DelegateMode mode,
454     uint8 v,
455     bytes32 r,
456     bytes32 s
457   )
458     public
459     liquid
460     canDelegate
461     returns (bool)
462   {
463     require(to != address(this));
464     address signer;
465     address relayer;
466     if (mode == DelegateMode.PublicMsgSender) {
467       signer = ecrecover(
468         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, address(0))),
469         v,
470         r,
471         s
472       );
473       relayer = msg.sender;
474     } else if (mode == DelegateMode.PublicTxOrigin) {
475       signer = ecrecover(
476         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, address(0))),
477         v,
478         r,
479         s
480       );
481       relayer = tx.origin;
482     } else if (mode == DelegateMode.PrivateMsgSender) {
483       signer = ecrecover(
484         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, msg.sender)),
485         v,
486         r,
487         s
488       );
489       relayer = msg.sender;
490     } else if (mode == DelegateMode.PrivateTxOrigin) {
491       signer = ecrecover(
492         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, tx.origin)),
493         v,
494         r,
495         s
496       );
497       relayer = tx.origin;
498     } else {
499       revert();
500     }
501 
502     Account storage signerAccount = accounts[signer];
503     require(nonce == signerAccount.nonce);
504     emit IncreaseNonce(signer, signerAccount.nonce += 1);
505 
506     signerAccount.balance = signerAccount.balance.sub(value.add(fee));
507     accounts[to].balance += value;
508     if (fee != 0) {
509       accounts[relayer].balance += fee;
510       emit Transfer(signer, relayer, fee);
511     }
512 
513     if (!to.isAccount() && data.length >= 68) {
514       assembly {
515         mstore(add(data, 36), value)
516         mstore(add(data, 68), signer)
517       }
518       if (to.call.gas(gasAmount)(data)) {
519         emit Transfer(signer, to, value);
520       } else {
521         signerAccount.balance += value;
522         accounts[to].balance -= value;
523       }
524     } else {
525       emit Transfer(signer, to, value);
526     }
527 
528     return true;
529   }
530 
531   function directDebit(address debtor, address receiver) public view returns (DirectDebit) {
532     return accounts[debtor].instruments[receiver].directDebit;
533   }
534 
535   function setupDirectDebit(
536     address receiver,
537     DirectDebitInfo info
538   )
539     public
540     returns (bool)
541   {
542     accounts[msg.sender].instruments[receiver].directDebit = DirectDebit({
543       info: info,
544       epoch: 0
545     });
546 
547     emit SetupDirectDebit(msg.sender, receiver, info);
548     return true;
549   }
550 
551   function terminateDirectDebit(address receiver) public returns (bool) {
552     delete accounts[msg.sender].instruments[receiver].directDebit;
553 
554     emit TerminateDirectDebit(msg.sender, receiver);
555     return true;
556   }
557 
558   function withdrawDirectDebit(address debtor) public liquid canUseDirectDebit returns (bool) {
559     Account storage debtorAccount = accounts[debtor];
560     DirectDebit storage debit = debtorAccount.instruments[msg.sender].directDebit;
561     uint256 epoch = (block.timestamp.sub(debit.info.startTime) / debit.info.interval).add(1);
562     uint256 amount = epoch.sub(debit.epoch).mul(debit.info.amount);
563     require(amount > 0);
564     debtorAccount.balance = debtorAccount.balance.sub(amount);
565     accounts[msg.sender].balance += amount;
566     debit.epoch = epoch;
567 
568     emit Transfer(debtor, msg.sender, amount);
569     return true;
570   }
571 
572   function withdrawDirectDebit(address[] debtors, bool strict) public liquid canUseDirectDebit returns (bool result) {
573     Account storage receiverAccount = accounts[msg.sender];
574     result = true;
575     uint256 total;
576 
577     for (uint256 i = 0; i < debtors.length; i++) {
578       address debtor = debtors[i];
579       Account storage debtorAccount = accounts[debtor];
580       DirectDebit storage debit = debtorAccount.instruments[msg.sender].directDebit;
581       uint256 epoch = (block.timestamp.sub(debit.info.startTime) / debit.info.interval).add(1);
582       uint256 amount = epoch.sub(debit.epoch).mul(debit.info.amount);
583       require(amount > 0);
584       uint256 debtorBalance = debtorAccount.balance;
585 
586       if (amount > debtorBalance) {
587         if (strict) {
588           revert();
589         }
590         result = false;
591         emit WithdrawDirectDebitFailure(debtor, msg.sender);
592       } else {
593         debtorAccount.balance = debtorBalance - amount;
594         total += amount;
595         debit.epoch = epoch;
596 
597         emit Transfer(debtor, msg.sender, amount);
598       }
599     }
600 
601     receiverAccount.balance += total;
602   }
603 }
604 
605 contract SmartToken is Authorizable, IssuerContract, ERC20Like {
606 
607   string public name;
608   string public symbol;
609   uint256 public totalSupply;
610   uint8 public constant decimals = 18;
611 
612   constructor(
613     address _issuer,
614     FsTKAuthority _fstkAuthority,
615     string _name,
616     string _symbol,
617     uint256 _totalSupply,
618     string _metadata
619   )
620     Authorizable(_fstkAuthority)
621     IssuerContract(_issuer)
622     ERC20Like(_metadata)
623     public
624   {
625     name = _name;
626     symbol = _symbol;
627     totalSupply = _totalSupply;
628 
629     accounts[_issuer].balance = _totalSupply;
630     emit Transfer(address(0), _issuer, _totalSupply);
631   }
632 
633   function setERC20ApproveChecking(bool approveChecking) public onlyIssuer {
634     super.setERC20ApproveChecking(approveChecking);
635   }
636 
637   function setDelegate(bool delegate) public onlyIssuer {
638     super.setDelegate(delegate);
639   }
640 
641   function setDirectDebit(bool directDebit) public onlyIssuer {
642     super.setDirectDebit(directDebit);
643   }
644 
645   function setMetadata(
646     string infoUrl,
647     uint256 approveTime,
648     bytes approveToken
649   )
650     public
651     onlyIssuer
652     onlyFsTKApproved(keccak256(abi.encodePacked(approveTime, this, msg.sig, infoUrl)), approveTime, approveToken)
653   {
654     setMetadata0(infoUrl);
655   }
656 
657   function setLiquid(
658     bool liquidity,
659     uint256 approveTime,
660     bytes approveToken
661   )
662     public
663     onlyIssuer
664     onlyFsTKApproved(keccak256(abi.encodePacked(approveTime, this, msg.sig, liquidity)), approveTime, approveToken)
665   {
666     setLiquid0(liquidity);
667   }
668 }