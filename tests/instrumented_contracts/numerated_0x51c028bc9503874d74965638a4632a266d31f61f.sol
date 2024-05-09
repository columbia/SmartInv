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
144 contract ERC20 {
145 
146   event Transfer(address indexed from, address indexed to, uint256 value);
147   event Approval(address indexed owner, address indexed spender, uint256 value);
148 
149   function balanceOf(address owner) public view returns (uint256);
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transfer(address to, uint256 value) public returns (bool);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154 }
155 
156 contract SecureERC20 is ERC20 {
157 
158   event SetERC20ApproveChecking(bool approveChecking);
159 
160   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool);
161   function increaseAllowance(address spender, uint256 value) public returns (bool);
162   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool);
163   function setERC20ApproveChecking(bool approveChecking) public;
164 }
165 
166 contract FsTKToken {
167 
168   enum DelegateMode { PublicMsgSender, PublicTxOrigin, PrivateMsgSender, PrivateTxOrigin }
169 
170   event Consume(address indexed from, uint256 value, bytes32 challenge);
171   event IncreaseNonce(address indexed from, uint256 nonce);
172   event SetupDirectDebit(address indexed debtor, address indexed receiver, DirectDebitInfo info);
173   event TerminateDirectDebit(address indexed debtor, address indexed receiver);
174   event WithdrawDirectDebitFailure(address indexed debtor, address indexed receiver);
175 
176   event SetMetadata(string metadata);
177   event SetLiquid(bool liquidity);
178   event SetDelegate(bool isDelegateEnable);
179   event SetDirectDebit(bool isDirectDebitEnable);
180 
181   struct DirectDebitInfo {
182     uint256 amount;
183     uint256 startTime;
184     uint256 interval;
185   }
186   struct DirectDebit {
187     DirectDebitInfo info;
188     uint256 epoch;
189   }
190   struct Instrument {
191     uint256 allowance;
192     DirectDebit directDebit;
193   }
194   struct Account {
195     uint256 balance;
196     uint256 nonce;
197     mapping (address => Instrument) instruments;
198   }
199 
200   function spendableAllowance(address owner, address spender) public view returns (uint256);
201   function transfer(uint256[] data) public returns (bool);
202   function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool);
203 
204   function nonceOf(address owner) public view returns (uint256);
205   function increaseNonce() public returns (bool);
206   function delegateTransferAndCall(
207     uint256 nonce,
208     uint256 fee,
209     uint256 gasAmount,
210     address to,
211     uint256 value,
212     bytes data,
213     DelegateMode mode,
214     uint8 v,
215     bytes32 r,
216     bytes32 s
217   ) public returns (bool);
218 
219   function directDebit(address debtor, address receiver) public view returns (DirectDebit);
220   function setupDirectDebit(address receiver, DirectDebitInfo info) public returns (bool);
221   function terminateDirectDebit(address receiver) public returns (bool);
222   function withdrawDirectDebit(address debtor) public returns (bool);
223   function withdrawDirectDebit(address[] debtors, bool strict) public returns (bool);
224 }
225 
226 contract ERC20Like is SecureERC20, FsTKToken {
227   using AddressExtension for address;
228   using Math for uint256;
229 
230   modifier liquid {
231     require(isLiquid);
232      _;
233   }
234   modifier canUseDirectDebit {
235     require(isDirectDebitEnable);
236      _;
237   }
238   modifier canDelegate {
239     require(isDelegateEnable);
240      _;
241   }
242 
243   bool public erc20ApproveChecking;
244   bool public isLiquid = true;
245   bool public isDelegateEnable;
246   bool public isDirectDebitEnable;
247   string public metadata;
248   mapping(address => Account) internal accounts;
249 
250   constructor(string _metadata) public {
251     metadata = _metadata;
252   }
253 
254   function balanceOf(address owner) public view returns (uint256) {
255     return accounts[owner].balance;
256   }
257 
258   function allowance(address owner, address spender) public view returns (uint256) {
259     return accounts[owner].instruments[spender].allowance;
260   }
261 
262   function transfer(address to, uint256 value) public liquid returns (bool) {
263     Account storage senderAccount = accounts[msg.sender];
264 
265     senderAccount.balance = senderAccount.balance.sub(value);
266     accounts[to].balance += value;
267 
268     emit Transfer(msg.sender, to, value);
269     return true;
270   }
271 
272   function transferFrom(address from, address to, uint256 value) public liquid returns (bool) {
273     Account storage fromAccount = accounts[from];
274     Instrument storage senderInstrument = fromAccount.instruments[msg.sender];
275 
276     fromAccount.balance = fromAccount.balance.sub(value);
277     senderInstrument.allowance = senderInstrument.allowance.sub(value);
278     accounts[to].balance += value;
279 
280     emit Transfer(from, to, value);
281     return true;
282   }
283 
284   function approve(address spender, uint256 value) public returns (bool) {
285     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
286     if (erc20ApproveChecking) {
287       require((value == 0) || (spenderInstrument.allowance == 0));
288     }
289 
290     emit Approval(
291       msg.sender,
292       spender,
293       spenderInstrument.allowance = value
294     );
295     return true;
296   }
297 
298   function setERC20ApproveChecking(bool approveChecking) public {
299     emit SetERC20ApproveChecking(erc20ApproveChecking = approveChecking);
300   }
301 
302   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool) {
303     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
304     require(spenderInstrument.allowance == expectedValue);
305 
306     emit Approval(
307       msg.sender,
308       spender,
309       spenderInstrument.allowance = newValue
310     );
311     return true;
312   }
313 
314   function increaseAllowance(address spender, uint256 value) public returns (bool) {
315     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
316 
317     emit Approval(
318       msg.sender,
319       spender,
320       spenderInstrument.allowance = spenderInstrument.allowance.add(value)
321     );
322     return true;
323   }
324 
325   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool) {
326     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
327 
328     uint256 currentValue = spenderInstrument.allowance;
329     uint256 newValue;
330     if (strict) {
331       newValue = currentValue.sub(value);
332     } else if (value < currentValue) {
333       newValue = currentValue - value;
334     }
335 
336     emit Approval(
337       msg.sender,
338       spender,
339       spenderInstrument.allowance = newValue
340     );
341     return true;
342   }
343 
344   function setMetadata0(string _metadata) internal {
345     emit SetMetadata(metadata = _metadata);
346   }
347 
348   function setLiquid0(bool liquidity) internal {
349     emit SetLiquid(isLiquid = liquidity);
350   }
351 
352   function setDelegate(bool delegate) public {
353     emit SetDelegate(isDelegateEnable = delegate);
354   }
355 
356   function setDirectDebit(bool directDebit) public {
357     emit SetDirectDebit(isDirectDebitEnable = directDebit);
358   }
359 
360   function spendableAllowance(address owner, address spender) public view returns (uint256) {
361     Account storage ownerAccount = accounts[owner];
362     return Math.min(
363       ownerAccount.instruments[spender].allowance,
364       ownerAccount.balance
365     );
366   }
367 
368   function transfer(uint256[] data) public liquid returns (bool) {
369     Account storage senderAccount = accounts[msg.sender];
370     uint256 totalValue;
371 
372     for (uint256 i = 0; i < data.length; i++) {
373       address receiver = address(data[i] >> 96);
374       uint256 value = data[i] & 0xffffffffffffffffffffffff;
375 
376       totalValue = totalValue.add(value);
377       accounts[receiver].balance += value;
378 
379       emit Transfer(msg.sender, receiver, value);
380     }
381 
382     senderAccount.balance = senderAccount.balance.sub(totalValue);
383 
384     return true;
385   }
386 
387   function transferAndCall(
388     address to,
389     uint256 value,
390     bytes data
391   )
392     public
393     payable
394     liquid
395     returns (bool)
396   {
397     require(
398       to != address(this) &&
399       data.length >= 68 &&
400       transfer(to, value)
401     );
402     assembly {
403         mstore(add(data, 36), value)
404         mstore(add(data, 68), caller)
405     }
406     require(to.call.value(msg.value)(data));
407     return true;
408   }
409 
410   function nonceOf(address owner) public view returns (uint256) {
411     return accounts[owner].nonce;
412   }
413 
414   function increaseNonce() public returns (bool) {
415     emit IncreaseNonce(msg.sender, accounts[msg.sender].nonce += 1);
416   }
417 
418   function delegateTransferAndCall(
419     uint256 nonce,
420     uint256 fee,
421     uint256 gasAmount,
422     address to,
423     uint256 value,
424     bytes data,
425     DelegateMode mode,
426     uint8 v,
427     bytes32 r,
428     bytes32 s
429   )
430     public
431     liquid
432     canDelegate
433     returns (bool)
434   {
435     require(to != address(this));
436     address signer;
437     address relayer;
438     if (mode == DelegateMode.PublicMsgSender) {
439       signer = ecrecover(
440         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, address(0))),
441         v,
442         r,
443         s
444       );
445       relayer = msg.sender;
446     } else if (mode == DelegateMode.PublicTxOrigin) {
447       signer = ecrecover(
448         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, address(0))),
449         v,
450         r,
451         s
452       );
453       relayer = tx.origin;
454     } else if (mode == DelegateMode.PrivateMsgSender) {
455       signer = ecrecover(
456         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, msg.sender)),
457         v,
458         r,
459         s
460       );
461       relayer = msg.sender;
462     } else if (mode == DelegateMode.PrivateTxOrigin) {
463       signer = ecrecover(
464         keccak256(abi.encodePacked(this, nonce, fee, gasAmount, to, value, data, mode, tx.origin)),
465         v,
466         r,
467         s
468       );
469       relayer = tx.origin;
470     } else {
471       revert();
472     }
473 
474     Account storage signerAccount = accounts[signer];
475     require(nonce == signerAccount.nonce);
476     emit IncreaseNonce(signer, signerAccount.nonce += 1);
477 
478     signerAccount.balance = signerAccount.balance.sub(value.add(fee));
479     accounts[to].balance += value;
480     if (fee != 0) {
481       accounts[relayer].balance += fee;
482       emit Transfer(signer, relayer, fee);
483     }
484 
485     if (!to.isAccount() && data.length >= 68) {
486       assembly {
487         mstore(add(data, 36), value)
488         mstore(add(data, 68), signer)
489       }
490       if (to.call.gas(gasAmount)(data)) {
491         emit Transfer(signer, to, value);
492       } else {
493         signerAccount.balance += value;
494         accounts[to].balance -= value;
495       }
496     } else {
497       emit Transfer(signer, to, value);
498     }
499 
500     return true;
501   }
502 
503   function directDebit(address debtor, address receiver) public view returns (DirectDebit) {
504     return accounts[debtor].instruments[receiver].directDebit;
505   }
506 
507   function setupDirectDebit(
508     address receiver,
509     DirectDebitInfo info
510   )
511     public
512     returns (bool)
513   {
514     accounts[msg.sender].instruments[receiver].directDebit = DirectDebit({
515       info: info,
516       epoch: 0
517     });
518 
519     emit SetupDirectDebit(msg.sender, receiver, info);
520     return true;
521   }
522 
523   function terminateDirectDebit(address receiver) public returns (bool) {
524     delete accounts[msg.sender].instruments[receiver].directDebit;
525 
526     emit TerminateDirectDebit(msg.sender, receiver);
527     return true;
528   }
529 
530   function withdrawDirectDebit(address debtor) public liquid canUseDirectDebit returns (bool) {
531     Account storage debtorAccount = accounts[debtor];
532     DirectDebit storage debit = debtorAccount.instruments[msg.sender].directDebit;
533     uint256 epoch = (block.timestamp.sub(debit.info.startTime) / debit.info.interval).add(1);
534     uint256 amount = epoch.sub(debit.epoch).mul(debit.info.amount);
535     require(amount > 0);
536     debtorAccount.balance = debtorAccount.balance.sub(amount);
537     accounts[msg.sender].balance += amount;
538     debit.epoch = epoch;
539 
540     emit Transfer(debtor, msg.sender, amount);
541     return true;
542   }
543 
544   function withdrawDirectDebit(address[] debtors, bool strict) public liquid canUseDirectDebit returns (bool result) {
545     Account storage receiverAccount = accounts[msg.sender];
546     result = true;
547     uint256 total;
548 
549     for (uint256 i = 0; i < debtors.length; i++) {
550       address debtor = debtors[i];
551       Account storage debtorAccount = accounts[debtor];
552       DirectDebit storage debit = debtorAccount.instruments[msg.sender].directDebit;
553       uint256 epoch = (block.timestamp.sub(debit.info.startTime) / debit.info.interval).add(1);
554       uint256 amount = epoch.sub(debit.epoch).mul(debit.info.amount);
555       require(amount > 0);
556       uint256 debtorBalance = debtorAccount.balance;
557 
558       if (amount > debtorBalance) {
559         if (strict) {
560           revert();
561         }
562         result = false;
563         emit WithdrawDirectDebitFailure(debtor, msg.sender);
564       } else {
565         debtorAccount.balance = debtorBalance - amount;
566         total += amount;
567         debit.epoch = epoch;
568 
569         emit Transfer(debtor, msg.sender, amount);
570       }
571     }
572 
573     receiverAccount.balance += total;
574   }
575 }
576 
577 contract FsTKAllocation {
578   function initialize(uint256 _vestedAmount) public;
579 }
580 
581 contract FunderSmartToken is Authorizable, ERC20Like {
582 
583   string public constant name = "Funder Smart Token";
584   string public constant symbol = "FST";
585   uint256 public constant totalSupply = 330000000 ether;
586   uint8 public constant decimals = 18;
587 
588   constructor(
589     FsTKAuthority _fstkAuthority,
590     string _metadata,
591     address coldWallet,
592     FsTKAllocation allocation
593   )
594     Authorizable(_fstkAuthority)
595     ERC20Like(_metadata)
596     public
597   {
598     uint256 vestedAmount = totalSupply / 12;
599     accounts[allocation].balance = vestedAmount;
600     emit Transfer(address(0), allocation, vestedAmount);
601     allocation.initialize(vestedAmount);
602 
603     uint256 releaseAmount = totalSupply - vestedAmount;
604     accounts[coldWallet].balance = releaseAmount;
605 
606     emit Transfer(address(0), coldWallet, releaseAmount);
607   }
608 
609   function setMetadata(string infoUrl) public onlyFsTKAuthorized {
610     setMetadata0(infoUrl);
611   }
612 
613   function setLiquid(bool liquidity) public onlyFsTKAuthorized {
614     setLiquid0(liquidity);
615   }
616 
617   function setERC20ApproveChecking(bool approveChecking) public onlyFsTKAuthorized {
618     super.setERC20ApproveChecking(approveChecking);
619   }
620 
621   function setDelegate(bool delegate) public onlyFsTKAuthorized {
622     super.setDelegate(delegate);
623   }
624 
625   function setDirectDebit(bool directDebit) public onlyFsTKAuthorized {
626     super.setDirectDebit(directDebit);
627   }
628 
629   function transferToken(ERC20 erc20, address to, uint256 value) public onlyFsTKAuthorized {
630     erc20.transfer(to, value);
631   }
632 }