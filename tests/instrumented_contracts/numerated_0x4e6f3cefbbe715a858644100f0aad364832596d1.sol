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
100 contract FsTKAllocation {
101 
102   function initialize(uint256 _vestedAmount) public;
103 }
104 
105 contract FsTKAuthority {
106 
107   function isAuthorized(address sender, address _contract, bytes data) public view returns (bool);
108   function isApproved(bytes32 hash, uint256 approveTime, bytes approveToken) public view returns (bool);
109   function validate() public pure returns (bool);
110 }
111 
112 contract Authorizable {
113 
114   event SetFsTKAuthority(FsTKAuthority indexed _address);
115 
116   modifier onlyFsTKAuthorized {
117     require(fstkAuthority.isAuthorized(msg.sender, this, msg.data));
118     _;
119   }
120   modifier onlyFsTKApproved(bytes32 hash, uint256 approveTime, bytes approveToken) {
121     require(fstkAuthority.isApproved(hash, approveTime, approveToken));
122     _;
123   }
124 
125   FsTKAuthority internal fstkAuthority;
126 
127   constructor(FsTKAuthority _fstkAuthority) internal {
128     fstkAuthority = _fstkAuthority;
129   }
130 
131   function setFsTKAuthority(FsTKAuthority _fstkAuthority) public onlyFsTKAuthorized {
132     require(_fstkAuthority.validate());
133     emit SetFsTKAuthority(fstkAuthority = _fstkAuthority);
134   }
135 }
136 
137 contract ERC20 {
138 
139   event Transfer(address indexed from, address indexed to, uint256 value);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 
142   function balanceOf(address owner) public view returns (uint256);
143   function allowance(address owner, address spender) public view returns (uint256);
144   function transfer(address to, uint256 value) public returns (bool);
145   function transferFrom(address from, address to, uint256 value) public returns (bool);
146   function approve(address spender, uint256 value) public returns (bool);
147 }
148 
149 contract SecureERC20 is ERC20 {
150 
151   event SetERC20ApproveChecking(bool approveChecking);
152 
153   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool);
154   function increaseAllowance(address spender, uint256 value) public returns (bool);
155   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool);
156   function setERC20ApproveChecking(bool approveChecking) public;
157 }
158 
159 contract FsTKToken {
160 
161   event SetupDirectDebit(address indexed debtor, address indexed receiver, DirectDebitInfo info);
162   event TerminateDirectDebit(address indexed debtor, address indexed receiver);
163   event WithdrawDirectDebitFailure(address indexed debtor, address indexed receiver);
164 
165   event SetMetadata(string metadata);
166   event SetLiquid(bool liquidity);
167   event SetDelegate(bool isDelegateEnable);
168   event SetDirectDebit(bool isDirectDebitEnable);
169 
170   struct DirectDebitInfo {
171     uint256 amount;
172     uint256 startTime;
173     uint256 interval;
174   }
175   struct DirectDebit {
176     DirectDebitInfo info;
177     uint256 epoch;
178   }
179   struct Instrument {
180     uint256 allowance;
181     DirectDebit directDebit;
182   }
183   struct Account {
184     uint256 balance;
185     uint256 nonce;
186     mapping (address => Instrument) instruments;
187   }
188 
189   function spendableAllowance(address owner, address spender) public view returns (uint256);
190   function transfer(uint256[] data) public returns (bool);
191   function transferAndCall(address to, uint256 value, bytes data) public payable returns (bool);
192   function delegateTransferAndCall(
193     uint256 nonce,
194     uint256 gasAmount,
195     address to,
196     uint256 value,
197     bytes data,
198     uint8 v,
199     bytes32 r,
200     bytes32 s
201   ) public returns (bool);
202 
203   function directDebitOf(address debtor, address receiver) public view returns (DirectDebit);
204   function setupDirectDebit(address receiver, DirectDebitInfo info) public returns (bool);
205   function terminateDirectDebit(address receiver) public returns (bool);
206   function withdrawDirectDebit(address debtor) public returns (bool);
207   function withdrawDirectDebit(address[] debtors, bool strict) public returns (bool result);
208 }
209 
210 contract AbstractToken is SecureERC20, FsTKToken {
211   using AddressExtension for address;
212   using Math for uint256;
213 
214   modifier liquid {
215     require(isLiquid);
216      _;
217   }
218   modifier canUseDirectDebit {
219     require(isDirectDebitEnable);
220      _;
221   }
222 
223   bool public erc20ApproveChecking;
224   bool public isLiquid = true;
225   bool public isDelegateEnable;
226   bool public isDirectDebitEnable;
227   string public metadata;
228   mapping(address => Account) internal accounts;
229 
230   constructor(string _metadata) public {
231     metadata = _metadata;
232   }
233 
234   function balanceOf(address owner) public view returns (uint256) {
235     return accounts[owner].balance;
236   }
237 
238   function allowance(address owner, address spender) public view returns (uint256) {
239     return accounts[owner].instruments[spender].allowance;
240   }
241 
242   function transfer(address to, uint256 value) public liquid returns (bool) {
243     Account storage senderAccount = accounts[msg.sender];
244     uint256 senderBalance = senderAccount.balance;
245     require(value <= senderBalance);
246 
247     senderAccount.balance = senderBalance - value;
248     accounts[to].balance += value;
249 
250     emit Transfer(msg.sender, to, value);
251     return true;
252   }
253 
254   function transferFrom(address from, address to, uint256 value) public liquid returns (bool) {
255     Account storage fromAccount = accounts[from];
256     uint256 fromBalance = fromAccount.balance;
257     Instrument storage senderInstrument = fromAccount.instruments[msg.sender];
258     uint256 senderAllowance = senderInstrument.allowance;
259     require(value <= fromBalance);
260     require(value <= senderAllowance);
261 
262     fromAccount.balance = fromBalance - value;
263     senderInstrument.allowance = senderAllowance - value;
264     accounts[to].balance += value;
265 
266     emit Transfer(from, to, value);
267     return true;
268   }
269 
270   function approve(address spender, uint256 value) public returns (bool) {
271     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
272     if (erc20ApproveChecking) {
273       require((value == 0) || (spenderInstrument.allowance == 0));
274     }
275     spenderInstrument.allowance = value;
276 
277     emit Approval(msg.sender, spender, value);
278     return true;
279   }
280 
281   function setERC20ApproveChecking(bool approveChecking) public {
282     emit SetERC20ApproveChecking(erc20ApproveChecking = approveChecking);
283   }
284 
285   function approve(address spender, uint256 expectedValue, uint256 newValue) public returns (bool) {
286     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
287     require(spenderInstrument.allowance == expectedValue);
288 
289     spenderInstrument.allowance = newValue;
290 
291     emit Approval(msg.sender, spender, newValue);
292     return true;
293   }
294 
295   function increaseAllowance(address spender, uint256 value) public returns (bool) {
296     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
297 
298     uint256 newValue = spenderInstrument.allowance.add(value);
299     spenderInstrument.allowance = newValue;
300 
301     emit Approval(msg.sender, spender, newValue);
302     return true;
303   }
304 
305   function decreaseAllowance(address spender, uint256 value, bool strict) public returns (bool) {
306     Instrument storage spenderInstrument = accounts[msg.sender].instruments[spender];
307 
308     uint256 currentValue = spenderInstrument.allowance;
309     uint256 newValue;
310     if (strict) {
311       newValue = currentValue.sub(value);
312     } else if (value < currentValue) {
313       newValue = currentValue - value;
314     }
315     spenderInstrument.allowance = newValue;
316 
317     emit Approval(msg.sender, spender, newValue);
318     return true;
319   }
320 
321   function setMetadata0(string _metadata) internal {
322     emit SetMetadata(metadata = _metadata);
323   }
324 
325   function setLiquid0(bool liquidity) internal {
326     emit SetLiquid(isLiquid = liquidity);
327   }
328 
329   function setDelegate(bool delegate) public {
330     emit SetDelegate(isDelegateEnable = delegate);
331   }
332 
333   function setDirectDebit(bool directDebit) public {
334     emit SetDirectDebit(isDirectDebitEnable = directDebit);
335   }
336 
337   function spendableAllowance(address owner, address spender) public view returns (uint256) {
338     Account storage ownerAccount = accounts[owner];
339     return Math.min(
340       ownerAccount.instruments[spender].allowance,
341       ownerAccount.balance
342     );
343   }
344 
345   function transfer(uint256[] data) public liquid returns (bool) {
346     Account storage senderAccount = accounts[msg.sender];
347     uint256 totalValue;
348     for (uint256 i = 0; i < data.length; i++) {
349       address receiver = address(data[i] >> 96);
350       uint256 value = data[i] & 0xffffffffffffffffffffffff;
351 
352       totalValue = totalValue.add(value);
353       accounts[receiver].balance += value;
354 
355       emit Transfer(msg.sender, receiver, value);
356     }
357 
358     uint256 senderBalance = senderAccount.balance;
359     require(totalValue <= senderBalance);
360     senderAccount.balance = senderBalance - totalValue;
361 
362     return true;
363   }
364 
365   function transferAndCall(address to, uint256 value, bytes data) public payable liquid returns (bool) {
366     require(to != address(this));
367     require(transfer(to, value));
368     require(data.length >= 68);
369     assembly {
370         mstore(add(data, 36), value)
371         mstore(add(data, 68), caller)
372     }
373     require(to.call.value(msg.value)(data));
374     return true;
375   }
376 
377   function delegateTransferAndCall(
378     uint256 nonce,
379     uint256 gasAmount,
380     address to,
381     uint256 value,
382     bytes data,
383     uint8 v,
384     bytes32 r,
385     bytes32 s
386   )
387     public
388     liquid
389     returns (bool)
390   {
391     require(isDelegateEnable);
392     require(to != address(this));
393 
394     address signer = ecrecover(
395       keccak256(nonce, gasAmount, to, value, data),
396       v,
397       r,
398       s
399     );
400     Account storage signerAccount = accounts[signer];
401     require(nonce == signerAccount.nonce);
402     signerAccount.nonce = nonce.add(1);
403     uint256 signerBalance = signerAccount.balance;
404     uint256 total = value.add(gasAmount);
405     require(total <= signerBalance);
406 
407     signerAccount.balance = signerBalance - total;
408     accounts[to].balance += value;
409     emit Transfer(signer, to, value);
410     accounts[msg.sender].balance += gasAmount;
411     emit Transfer(signer, msg.sender, gasAmount);
412 
413     if (!to.isAccount()) {
414       require(data.length >= 68);
415       assembly {
416         mstore(add(data, 36), value)
417         mstore(add(data, 68), signer)
418       }
419       require(to.call(data));
420     }
421 
422     return true;
423   }
424 
425   function directDebitOf(address debtor, address receiver) public view returns (DirectDebit) {
426     return accounts[debtor].instruments[receiver].directDebit;
427   }
428 
429   function setupDirectDebit(
430     address receiver,
431     DirectDebitInfo info
432   )
433     public
434     returns (bool)
435   {
436     accounts[msg.sender].instruments[receiver].directDebit = DirectDebit({
437       info: info,
438       epoch: 0
439     });
440 
441     emit SetupDirectDebit(msg.sender, receiver, info);
442     return true;
443   }
444 
445   function terminateDirectDebit(address receiver) public returns (bool) {
446     delete accounts[msg.sender].instruments[receiver].directDebit;
447 
448     emit TerminateDirectDebit(msg.sender, receiver);
449     return true;
450   }
451 
452   function calculateTotalDirectDebitAmount(uint256 amount, uint256 epochNow, uint256 epochLast) pure private returns (uint256) {
453     require(amount > 0);
454     require(epochNow > epochLast);
455     return (epochNow - epochLast).mul(amount);
456   }
457 
458   function withdrawDirectDebit(address debtor) public liquid canUseDirectDebit returns (bool) {
459     Account storage debtorAccount = accounts[debtor];
460     uint256 debtorBalance = debtorAccount.balance;
461     DirectDebit storage directDebit = debtorAccount.instruments[msg.sender].directDebit;
462     uint256 epoch = block.timestamp.sub(directDebit.info.startTime) / directDebit.info.interval + 1;
463     uint256 amount = calculateTotalDirectDebitAmount(directDebit.info.amount, epoch, directDebit.epoch);
464     require(amount <= debtorBalance);
465 
466     debtorAccount.balance = debtorBalance - amount;
467     accounts[msg.sender].balance += amount;
468     directDebit.epoch = epoch;
469 
470     emit Transfer(debtor, msg.sender, amount);
471     return true;
472   }
473 
474   function withdrawDirectDebit(address[] debtors, bool strict) public liquid canUseDirectDebit returns (bool result) {
475     Account storage receiverAccount = accounts[msg.sender];
476     result = true;
477 
478     for (uint256 i = 0; i < debtors.length; i++) {
479       address debtor = debtors[i];
480       Account storage debtorAccount = accounts[debtor];
481       uint256 debtorBalance = debtorAccount.balance;
482       DirectDebit storage directDebit = debtorAccount.instruments[msg.sender].directDebit;
483       uint256 epoch = block.timestamp.sub(directDebit.info.startTime) / directDebit.info.interval + 1;
484       uint256 amount = calculateTotalDirectDebitAmount(directDebit.info.amount, epoch, directDebit.epoch);
485 
486       if (amount > debtorBalance) {
487         if (strict) {
488           revert();
489         }
490         result = false;
491         emit WithdrawDirectDebitFailure(debtor, msg.sender);
492       } else {
493         debtorAccount.balance = debtorBalance - amount;
494         receiverAccount.balance += amount;
495         directDebit.epoch = epoch;
496 
497         emit Transfer(debtor, msg.sender, amount);
498       }
499     }
500   }
501 }
502 
503 contract FunderSmartToken is AbstractToken, Authorizable {
504 
505   string public constant name = "Funder Smart Token";
506   string public constant symbol = "FST";
507   uint256 public constant totalSupply = 330000000 ether;
508   uint8 public constant decimals = 18;
509 
510   constructor(
511     FsTKAuthority _fstkAuthority,
512     string _metadata,
513     address coldWallet,
514     FsTKAllocation allocation
515   )
516     AbstractToken(_metadata)
517     Authorizable(_fstkAuthority)
518     public
519   {
520     uint256 vestedAmount = totalSupply / 12;
521     accounts[allocation].balance = vestedAmount;
522     emit Transfer(address(0), allocation, vestedAmount);
523     allocation.initialize(vestedAmount);
524 
525     uint256 releaseAmount = totalSupply - vestedAmount;
526     accounts[coldWallet].balance = releaseAmount;
527 
528     emit Transfer(address(0), coldWallet, releaseAmount);
529   }
530 
531   function setMetadata(string infoUrl) public onlyFsTKAuthorized {
532     setMetadata0(infoUrl);
533   }
534 
535   function setLiquid(bool liquidity) public onlyFsTKAuthorized {
536     setLiquid0(liquidity);
537   }
538 
539   function setERC20ApproveChecking(bool approveChecking) public onlyFsTKAuthorized {
540     AbstractToken.setERC20ApproveChecking(approveChecking);
541   }
542 
543   function setDelegate(bool delegate) public onlyFsTKAuthorized {
544     AbstractToken.setDelegate(delegate);
545   }
546 
547   function setDirectDebit(bool directDebit) public onlyFsTKAuthorized {
548     AbstractToken.setDirectDebit(directDebit);
549   }
550 
551   function transferToken(ERC20 erc20, address to, uint256 value) public onlyFsTKAuthorized {
552     erc20.transfer(to, value);
553   }
554 }