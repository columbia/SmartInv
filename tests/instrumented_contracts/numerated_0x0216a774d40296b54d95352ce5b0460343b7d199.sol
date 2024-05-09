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
168   event Consume(address indexed from, uint256 value, bytes32 challenge);
169   event IncreaseNonce(address indexed from, uint256 nonce);
170   event SetupDirectDebit(address indexed debtor, address indexed receiver, DirectDebitInfo info);
171   event TerminateDirectDebit(address indexed debtor, address indexed receiver);
172   event WithdrawDirectDebitFailure(address indexed debtor, address indexed receiver);
173 
174   event SetMetadata(string metadata);
175   event SetLiquid(bool liquidity);
176   event SetDelegate(bool isDelegateEnable);
177   event SetDirectDebit(bool isDirectDebitEnable);
178 
179   struct DirectDebitInfo {
180     uint256 amount;
181     uint256 startTime;
182     uint256 interval;
183   }
184   struct DirectDebit {
185     DirectDebitInfo info;
186     uint256 epoch;
187   }
188   struct Instrument {
189     uint256 allowance;
190     DirectDebit directDebit;
191   }
192   struct Account {
193     uint256 balance;
194     uint256 nonce;
195     mapping (address => Instrument) instruments;
196   }
197 
198   function spendableAllowance(address owner, address spender) public view returns (uint256);
199   function transfer(uint256[] data) public returns (bool);
200   function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool);
201 
202   function nonceOf(address owner) public view returns (uint256);
203   function increaseNonce() public returns (bool);
204   function delegateTransferAndCall(
205     uint256 nonce,
206     uint256 fee,
207     address to,
208     uint256 value,
209     bytes data,
210     address delegator,
211     uint8 v,
212     bytes32 r,
213     bytes32 s
214   ) public returns (bool);
215 
216   function directDebit(address debtor, address receiver) public view returns (DirectDebit);
217   function setupDirectDebit(address receiver, DirectDebitInfo info) public returns (bool);
218   function terminateDirectDebit(address receiver) public returns (bool);
219   function withdrawDirectDebit(address debtor) public returns (bool);
220   function withdrawDirectDebit(address[] debtors, bool strict) public returns (bool);
221 }
222 
223 contract ERC20Like is SecureERC20, FsTKToken {
224   using AddressExtension for address;
225   using Math for uint256;
226 
227   modifier liquid {
228     require(isLiquid);
229      _;
230   }
231   modifier canUseDirectDebit {
232     require(isDirectDebitEnable);
233      _;
234   }
235   modifier canDelegate {
236     require(isDelegateEnable);
237      _;
238   }
239   modifier notThis(address _address) {
240     require(_address != address(this));
241     _;
242   }
243 
244   bool public erc20ApproveChecking;
245   bool public isLiquid = true;
246   bool public isDelegateEnable;
247   bool public isDirectDebitEnable;
248   string public metadata;
249   mapping(address => Account) internal accounts;
250 
251   constructor(string _metadata) public {
252     metadata = _metadata;
253   }
254 
255   function balanceOf(address owner) public view returns (uint256) {
256     return accounts[owner].balance;
257   }
258 
259   function allowance(address owner, address spender) public view returns (uint256) {
260     return accounts[owner].instruments[spender].allowance;
261   }
262 
263   function transfer(address to, uint256 value) public liquid returns (bool) {
264     Account storage senderAccount = accounts[msg.sender];
265 
266     senderAccount.balance = senderAccount.balance.sub(value);
267     accounts[to].balance += value;
268 
269     emit Transfer(msg.sender, to, value);
270     return true;
271   }
272 
273   function transferFrom(address from, address to, uint256 value) public liquid returns (bool) {
274     Account storage fromAccount = accounts[from];
275     Instrument storage senderInstrument = fromAccount.instruments[msg.sender];
276 
277     fromAccount.balance = fromAccount.balance.sub(value);
278     senderInstrument.allowance = senderInstrument.allowance.sub(value);
279     accounts[to].balance += value;
280 
281     emit Transfer(from, to, value);
282     return true;
283   }
284 
285   function approve(address spender, uint256 value) public returns (bool) {
286     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
287     if (erc20ApproveChecking) {
288       require((value == 0) || (spenderInstrument.allowance == 0));
289     }
290 
291     emit Approval(
292       msg.sender,
293       spender,
294       spenderInstrument.allowance = value
295     );
296     return true;
297   }
298 
299   function setERC20ApproveChecking(bool approveChecking) public {
300     emit SetERC20ApproveChecking(erc20ApproveChecking = approveChecking);
301   }
302 
303   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool) {
304     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
305     require(spenderInstrument.allowance == expectedValue);
306 
307     emit Approval(
308       msg.sender,
309       spender,
310       spenderInstrument.allowance = newValue
311     );
312     return true;
313   }
314 
315   function increaseAllowance(address spender, uint256 value) public returns (bool) {
316     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
317 
318     emit Approval(
319       msg.sender,
320       spender,
321       spenderInstrument.allowance = spenderInstrument.allowance.add(value)
322     );
323     return true;
324   }
325 
326   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool) {
327     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
328 
329     uint256 currentValue = spenderInstrument.allowance;
330     uint256 newValue;
331     if (strict) {
332       newValue = currentValue.sub(value);
333     } else if (value < currentValue) {
334       newValue = currentValue - value;
335     }
336 
337     emit Approval(
338       msg.sender,
339       spender,
340       spenderInstrument.allowance = newValue
341     );
342     return true;
343   }
344 
345   function setMetadata0(string _metadata) internal {
346     emit SetMetadata(metadata = _metadata);
347   }
348 
349   function setLiquid0(bool liquidity) internal {
350     emit SetLiquid(isLiquid = liquidity);
351   }
352 
353   function setDelegate(bool delegate) public {
354     emit SetDelegate(isDelegateEnable = delegate);
355   }
356 
357   function setDirectDebit(bool directDebit) public {
358     emit SetDirectDebit(isDirectDebitEnable = directDebit);
359   }
360 
361   function spendableAllowance(address owner, address spender) public view returns (uint256) {
362     Account storage ownerAccount = accounts[owner];
363     return Math.min(
364       ownerAccount.instruments[spender].allowance,
365       ownerAccount.balance
366     );
367   }
368 
369   function transfer(uint256[] data) public liquid returns (bool) {
370     Account storage senderAccount = accounts[msg.sender];
371     uint256 totalValue;
372 
373     for (uint256 i = 0; i < data.length; i++) {
374       address receiver = address(data[i] >> 96);
375       uint256 value = data[i] & 0xffffffffffffffffffffffff;
376 
377       totalValue = totalValue.add(value);
378       accounts[receiver].balance += value;
379 
380       emit Transfer(msg.sender, receiver, value);
381     }
382 
383     senderAccount.balance = senderAccount.balance.sub(totalValue);
384 
385     return true;
386   }
387 
388   function transferAndCall(
389     address to,
390     uint256 value,
391     bytes data
392   )
393     public
394     payable
395     liquid
396     notThis(to)
397     returns (bool)
398   {
399     require(
400       transfer(to, value) &&
401       data.length >= 68
402     );
403     assembly {
404         mstore(add(data, 36), value)
405         mstore(add(data, 68), caller)
406     }
407     require(to.call.value(msg.value)(data));
408     return true;
409   }
410 
411   function nonceOf(address owner) public view returns (uint256) {
412     return accounts[owner].nonce;
413   }
414 
415   function increaseNonce() public returns (bool) {
416     emit IncreaseNonce(msg.sender, accounts[msg.sender].nonce += 1);
417   }
418 
419   function delegateTransferAndCall(
420     uint256 nonce,
421     uint256 fee,
422     address to,
423     uint256 value,
424     bytes data,
425     address delegator,
426     uint8 v,
427     bytes32 r,
428     bytes32 s
429   )
430     public
431     liquid
432     canDelegate
433     notThis(to)
434     returns (bool)
435   {
436     address signer = ecrecover(
437       keccak256(abi.encodePacked(nonce, fee, to, value, data, delegator)),
438       v,
439       r,
440       s
441     );
442     Account storage signerAccount = accounts[signer];
443     require(
444       nonce == signerAccount.nonce &&
445       (delegator == address(0) || delegator == msg.sender)
446     );
447     emit IncreaseNonce(signer, signerAccount.nonce += 1);
448 
449     signerAccount.balance = signerAccount.balance.sub(value.add(fee));
450     accounts[to].balance += value;
451     emit Transfer(signer, to, value);
452     accounts[msg.sender].balance += fee;
453     emit Transfer(signer, msg.sender, fee);
454 
455     if (!to.isAccount()) {
456       require(data.length >= 68);
457       assembly {
458         mstore(add(data, 36), value)
459         mstore(add(data, 68), signer)
460       }
461       require(to.call(data));
462     }
463 
464     return true;
465   }
466 
467   function directDebit(address debtor, address receiver) public view returns (DirectDebit) {
468     return accounts[debtor].instruments[receiver].directDebit;
469   }
470 
471   function setupDirectDebit(
472     address receiver,
473     DirectDebitInfo info
474   )
475     public
476     returns (bool)
477   {
478     accounts[msg.sender].instruments[receiver].directDebit = DirectDebit({
479       info: info,
480       epoch: 0
481     });
482 
483     emit SetupDirectDebit(msg.sender, receiver, info);
484     return true;
485   }
486 
487   function terminateDirectDebit(address receiver) public returns (bool) {
488     delete accounts[msg.sender].instruments[receiver].directDebit;
489 
490     emit TerminateDirectDebit(msg.sender, receiver);
491     return true;
492   }
493 
494   function withdrawDirectDebit(address debtor) public liquid canUseDirectDebit returns (bool) {
495     Account storage debtorAccount = accounts[debtor];
496     DirectDebit storage debit = debtorAccount.instruments[msg.sender].directDebit;
497     uint256 epoch = (block.timestamp.sub(debit.info.startTime) / debit.info.interval).add(1);
498     uint256 amount = epoch.sub(debit.epoch).mul(debit.info.amount);
499     require(amount > 0);
500     debtorAccount.balance = debtorAccount.balance.sub(amount);
501     accounts[msg.sender].balance += amount;
502     debit.epoch = epoch;
503 
504     emit Transfer(debtor, msg.sender, amount);
505     return true;
506   }
507 
508   function withdrawDirectDebit(address[] debtors, bool strict) public liquid canUseDirectDebit returns (bool result) {
509     Account storage receiverAccount = accounts[msg.sender];
510     result = true;
511     uint256 total;
512 
513     for (uint256 i = 0; i < debtors.length; i++) {
514       address debtor = debtors[i];
515       Account storage debtorAccount = accounts[debtor];
516       DirectDebit storage debit = debtorAccount.instruments[msg.sender].directDebit;
517       uint256 epoch = (block.timestamp.sub(debit.info.startTime) / debit.info.interval).add(1);
518       uint256 amount = epoch.sub(debit.epoch).mul(debit.info.amount);
519       require(amount > 0);
520       uint256 debtorBalance = debtorAccount.balance;
521 
522       if (amount > debtorBalance) {
523         if (strict) {
524           revert();
525         }
526         result = false;
527         emit WithdrawDirectDebitFailure(debtor, msg.sender);
528       } else {
529         debtorAccount.balance = debtorBalance - amount;
530         total += amount;
531         debit.epoch = epoch;
532 
533         emit Transfer(debtor, msg.sender, amount);
534       }
535     }
536 
537     receiverAccount.balance += total;
538   }
539 }
540 
541 contract FsTKAllocation {
542   function initialize(uint256 _vestedAmount) public;
543 }
544 
545 contract FunderSmartToken is Authorizable, ERC20Like {
546 
547   string public constant name = "Funder Smart Token";
548   string public constant symbol = "FST";
549   uint256 public constant totalSupply = 330000000 ether;
550   uint8 public constant decimals = 18;
551 
552   constructor(
553     FsTKAuthority _fstkAuthority,
554     string _metadata,
555     address coldWallet,
556     FsTKAllocation allocation
557   )
558     Authorizable(_fstkAuthority)
559     ERC20Like(_metadata)
560     public
561   {
562     uint256 vestedAmount = totalSupply / 12;
563     accounts[allocation].balance = vestedAmount;
564     emit Transfer(address(0), allocation, vestedAmount);
565     allocation.initialize(vestedAmount);
566 
567     uint256 releaseAmount = totalSupply - vestedAmount;
568     accounts[coldWallet].balance = releaseAmount;
569 
570     emit Transfer(address(0), coldWallet, releaseAmount);
571   }
572 
573   function setMetadata(string infoUrl) public onlyFsTKAuthorized {
574     setMetadata0(infoUrl);
575   }
576 
577   function setLiquid(bool liquidity) public onlyFsTKAuthorized {
578     setLiquid0(liquidity);
579   }
580 
581   function setERC20ApproveChecking(bool approveChecking) public onlyFsTKAuthorized {
582     super.setERC20ApproveChecking(approveChecking);
583   }
584 
585   function setDelegate(bool delegate) public onlyFsTKAuthorized {
586     super.setDelegate(delegate);
587   }
588 
589   function setDirectDebit(bool directDebit) public onlyFsTKAuthorized {
590     super.setDirectDebit(directDebit);
591   }
592 
593   function transferToken(ERC20 erc20, address to, uint256 value) public onlyFsTKAuthorized {
594     erc20.transfer(to, value);
595   }
596 }