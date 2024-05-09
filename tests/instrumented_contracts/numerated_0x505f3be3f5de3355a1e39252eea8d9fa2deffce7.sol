1 pragma solidity ^0.4.17;
2 
3 
4 /// general helpers.
5 /// `internal` so they get compiled into contracts using them.
6 library Helpers {
7     /// returns whether `array` contains `value`.
8     function addressArrayContains(address[] array, address value) internal pure returns (bool) {
9         for (uint256 i = 0; i < array.length; i++) {
10             if (array[i] == value) {
11                 return true;
12             }
13         }
14         return false;
15     }
16 
17     // returns the digits of `inputValue` as a string.
18     // example: `uintToString(12345678)` returns `"12345678"`
19     function uintToString(uint256 inputValue) internal pure returns (string) {
20         // figure out the length of the resulting string
21         uint256 length = 0;
22         uint256 currentValue = inputValue;
23         do {
24             length++;
25             currentValue /= 10;
26         } while (currentValue != 0);
27         // allocate enough memory
28         bytes memory result = new bytes(length);
29         // construct the string backwards
30         uint256 i = length - 1;
31         currentValue = inputValue;
32         do {
33             result[i--] = byte(48 + currentValue % 10);
34             currentValue /= 10;
35         } while (currentValue != 0);
36         return string(result);
37     }
38 
39     /// returns whether signatures (whose components are in `vs`, `rs`, `ss`)
40     /// contain `requiredSignatures` distinct correct signatures
41     /// where signer is in `allowed_signers`
42     /// that signed `message`
43     function hasEnoughValidSignatures(bytes message, uint8[] vs, bytes32[] rs, bytes32[] ss, address[] allowed_signers, uint256 requiredSignatures) internal pure returns (bool) {
44         // not enough signatures
45         if (vs.length < requiredSignatures) {
46             return false;
47         }
48 
49         var hash = MessageSigning.hashMessage(message);
50         var encountered_addresses = new address[](allowed_signers.length);
51 
52         for (uint256 i = 0; i < requiredSignatures; i++) {
53             var recovered_address = ecrecover(hash, vs[i], rs[i], ss[i]);
54             // only signatures by addresses in `addresses` are allowed
55             if (!addressArrayContains(allowed_signers, recovered_address)) {
56                 return false;
57             }
58             // duplicate signatures are not allowed
59             if (addressArrayContains(encountered_addresses, recovered_address)) {
60                 return false;
61             }
62             encountered_addresses[i] = recovered_address;
63         }
64         return true;
65     }
66 
67 }
68 
69 
70 /// Library used only to test Helpers library via rpc calls
71 library HelpersTest {
72     function addressArrayContains(address[] array, address value) public pure returns (bool) {
73         return Helpers.addressArrayContains(array, value);
74     }
75 
76     function uintToString(uint256 inputValue) public pure returns (string str) {
77         return Helpers.uintToString(inputValue);
78     }
79 
80     function hasEnoughValidSignatures(bytes message, uint8[] vs, bytes32[] rs, bytes32[] ss, address[] addresses, uint256 requiredSignatures) public pure returns (bool) {
81         return Helpers.hasEnoughValidSignatures(message, vs, rs, ss, addresses, requiredSignatures);
82     }
83 }
84 
85 
86 // helpers for message signing.
87 // `internal` so they get compiled into contracts using them.
88 library MessageSigning {
89     function recoverAddressFromSignedMessage(bytes signature, bytes message) internal pure returns (address) {
90         require(signature.length == 65);
91         bytes32 r;
92         bytes32 s;
93         bytes1 v;
94         // solium-disable-next-line security/no-inline-assembly
95         assembly {
96             r := mload(add(signature, 0x20))
97             s := mload(add(signature, 0x40))
98             v := mload(add(signature, 0x60))
99         }
100         return ecrecover(hashMessage(message), uint8(v), r, s);
101     }
102 
103     function hashMessage(bytes message) internal pure returns (bytes32) {
104         bytes memory prefix = "\x19Ethereum Signed Message:\n";
105         return keccak256(prefix, Helpers.uintToString(message.length), message);
106     }
107 }
108 
109 
110 /// Library used only to test MessageSigning library via rpc calls
111 library MessageSigningTest {
112     function recoverAddressFromSignedMessage(bytes signature, bytes message) public pure returns (address) {
113         return MessageSigning.recoverAddressFromSignedMessage(signature, message);
114     }
115 }
116 
117 
118 library Message {
119     // layout of message :: bytes:
120     // offset  0: 32 bytes :: uint256 (big endian) - message length (not part of message. any `bytes` begins with the length in memory)
121     // offset 32: 20 bytes :: address - recipient address
122     // offset 52: 32 bytes :: uint256 (big endian) - value
123     // offset 84: 32 bytes :: bytes32 - transaction hash
124     // offset 116: 32 bytes :: uint256 (big endian) - main gas price
125 
126     // mload always reads 32 bytes.
127     // if mload reads an address it only interprets the last 20 bytes as the address.
128     // so we can and have to start reading recipient at offset 20 instead of 32.
129     // if we were to read at 32 the address would contain part of value and be corrupted.
130     // when reading from offset 20 mload will ignore 12 bytes followed
131     // by the 20 recipient address bytes and correctly convert it into an address.
132     // this saves some storage/gas over the alternative solution
133     // which is padding address to 32 bytes and reading recipient at offset 32.
134     // for more details see discussion in:
135     // https://github.com/paritytech/parity-bridge/issues/61
136 
137     function getRecipient(bytes message) internal pure returns (address) {
138         address recipient;
139         // solium-disable-next-line security/no-inline-assembly
140         assembly {
141             recipient := mload(add(message, 20))
142         }
143         return recipient;
144     }
145 
146     function getValue(bytes message) internal pure returns (uint256) {
147         uint256 value;
148         // solium-disable-next-line security/no-inline-assembly
149         assembly {
150             value := mload(add(message, 52))
151         }
152         return value;
153     }
154 
155     function getTransactionHash(bytes message) internal pure returns (bytes32) {
156         bytes32 hash;
157         // solium-disable-next-line security/no-inline-assembly
158         assembly {
159             hash := mload(add(message, 84))
160         }
161         return hash;
162     }
163 
164     function getMainGasPrice(bytes message) internal pure returns (uint256) {
165         uint256 gasPrice;
166         // solium-disable-next-line security/no-inline-assembly
167         assembly {
168             gasPrice := mload(add(message, 116))
169         }
170         return gasPrice;
171     }
172 }
173 
174 
175 /// Library used only to test Message library via rpc calls
176 library MessageTest {
177     function getRecipient(bytes message) public pure returns (address) {
178         return Message.getRecipient(message);
179     }
180 
181     function getValue(bytes message) public pure returns (uint256) {
182         return Message.getValue(message);
183     }
184 
185     function getTransactionHash(bytes message) public pure returns (bytes32) {
186         return Message.getTransactionHash(message);
187     }
188 
189     function getMainGasPrice(bytes message) public pure returns (uint256) {
190         return Message.getMainGasPrice(message);
191     }
192 }
193 
194 
195 contract MainBridge {
196     /// Number of authorities signatures required to withdraw the money.
197     ///
198     /// Must be lesser than number of authorities.
199     uint256 public requiredSignatures;
200 
201     /// The gas cost of calling `MainBridge.withdraw`.
202     ///
203     /// Is subtracted from `value` on withdraw.
204     /// recipient pays the relaying authority for withdraw.
205     /// this shuts down attacks that exhaust authorities funds on main chain.
206     uint256 public estimatedGasCostOfWithdraw;
207 
208     /// reject deposits that would increase `this.balance` beyond this value.
209     /// security feature:
210     /// limits the total amount of mainnet ether that can be lost
211     /// if the bridge is faulty or compromised in any way!
212     /// set to 0 to disable.
213     uint256 public maxTotalMainContractBalance;
214 
215     /// reject deposits whose `msg.value` is higher than this value.
216     /// security feature.
217     /// set to 0 to disable.
218     uint256 public maxSingleDepositValue;
219 
220     /// Contract authorities.
221     address[] public authorities;
222 
223     /// Used side transaction hashes.
224     mapping (bytes32 => bool) public withdraws;
225 
226     /// Event created on money deposit.
227     event Deposit (address recipient, uint256 value);
228 
229     /// Event created on money withdraw.
230     event Withdraw (address recipient, uint256 value, bytes32 transactionHash);
231 
232     /// Constructor.
233     function MainBridge(
234         uint256 requiredSignaturesParam,
235         address[] authoritiesParam,
236         uint256 estimatedGasCostOfWithdrawParam,
237         uint256 maxTotalMainContractBalanceParam,
238         uint256 maxSingleDepositValueParam
239     ) public
240     {
241         require(requiredSignaturesParam != 0);
242         require(requiredSignaturesParam <= authoritiesParam.length);
243         requiredSignatures = requiredSignaturesParam;
244         authorities = authoritiesParam;
245         estimatedGasCostOfWithdraw = estimatedGasCostOfWithdrawParam;
246         maxTotalMainContractBalance = maxTotalMainContractBalanceParam;
247         maxSingleDepositValue = maxSingleDepositValueParam;
248     }
249 
250     /// Should be used to deposit money.
251     function () public payable {
252         require(maxSingleDepositValue == 0 || msg.value <= maxSingleDepositValue);
253         // the value of `this.balance` in payable methods is increased
254         // by `msg.value` before the body of the payable method executes
255         require(maxTotalMainContractBalance == 0 || this.balance <= maxTotalMainContractBalance);
256         Deposit(msg.sender, msg.value);
257     }
258 
259     /// Called by the bridge node processes on startup
260     /// to determine early whether the address pointing to the main
261     /// bridge contract is misconfigured.
262     /// so we can provide a helpful error message instead of the very
263     /// unhelpful errors encountered otherwise.
264     function isMainBridgeContract() public pure returns (bool) {
265         return true;
266     }
267 
268     /// final step of a withdraw.
269     /// checks that `requiredSignatures` `authorities` have signed of on the `message`.
270     /// then transfers `value` to `recipient` (both extracted from `message`).
271     /// see message library above for a breakdown of the `message` contents.
272     /// `vs`, `rs`, `ss` are the components of the signatures.
273 
274     /// anyone can call this, provided they have the message and required signatures!
275     /// only the `authorities` can create these signatures.
276     /// `requiredSignatures` authorities can sign arbitrary `message`s
277     /// transfering any ether `value` out of this contract to `recipient`.
278     /// bridge users must trust a majority of `requiredSignatures` of the `authorities`.
279     function withdraw(uint8[] vs, bytes32[] rs, bytes32[] ss, bytes message) public {
280         require(message.length == 116);
281 
282         // check that at least `requiredSignatures` `authorities` have signed `message`
283         require(Helpers.hasEnoughValidSignatures(message, vs, rs, ss, authorities, requiredSignatures));
284 
285         address recipient = Message.getRecipient(message);
286         uint256 value = Message.getValue(message);
287         bytes32 hash = Message.getTransactionHash(message);
288         uint256 mainGasPrice = Message.getMainGasPrice(message);
289 
290         // if the recipient calls `withdraw` they can choose the gas price freely.
291         // if anyone else calls `withdraw` they have to use the gas price
292         // `mainGasPrice` specified by the user initiating the withdraw.
293         // this is a security mechanism designed to shut down
294         // malicious senders setting extremely high gas prices
295         // and effectively burning recipients withdrawn value.
296         // see https://github.com/paritytech/parity-bridge/issues/112
297         // for further explanation.
298         require((recipient == msg.sender) || (tx.gasprice == mainGasPrice));
299 
300         // The following two statements guard against reentry into this function.
301         // Duplicated withdraw or reentry.
302         require(!withdraws[hash]);
303         // Order of operations below is critical to avoid TheDAO-like re-entry bug
304         withdraws[hash] = true;
305 
306         uint256 estimatedWeiCostOfWithdraw = estimatedGasCostOfWithdraw * mainGasPrice;
307 
308         // charge recipient for relay cost
309         uint256 valueRemainingAfterSubtractingCost = value - estimatedWeiCostOfWithdraw;
310 
311         // pay out recipient
312         recipient.transfer(valueRemainingAfterSubtractingCost);
313 
314         // refund relay cost to relaying authority
315         msg.sender.transfer(estimatedWeiCostOfWithdraw);
316 
317         Withdraw(recipient, valueRemainingAfterSubtractingCost, hash);
318     }
319 }
320 
321 
322 contract SideBridge {
323     // following is the part of SideBridge that implements an ERC20 token.
324     // ERC20 spec: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
325 
326     uint256 public totalSupply;
327 
328     string public name = "SideBridge";
329     // BETH = bridged ether
330     string public symbol = "BETH";
331     // 1-1 mapping of ether to tokens
332     uint8 public decimals = 18;
333 
334     /// maps addresses to their token balances
335     mapping (address => uint256) public balances;
336 
337     // owner of account approves the transfer of an amount by another account
338     mapping(address => mapping (address => uint256)) allowed;
339 
340     /// Event created on money transfer
341     event Transfer(address indexed from, address indexed to, uint256 tokens);
342 
343     // returns the ERC20 token balance of the given address
344     function balanceOf(address tokenOwner) public view returns (uint256) {
345         return balances[tokenOwner];
346     }
347 
348     /// Transfer `value` to `recipient` on this `side` chain.
349     ///
350     /// does not affect `main` chain. does not do a relay.
351     /// as specificed in ERC20 this doesn't fail if tokens == 0.
352     function transfer(address recipient, uint256 tokens) public returns (bool) {
353         require(balances[msg.sender] >= tokens);
354         // fails if there is an overflow
355         require(balances[recipient] + tokens >= balances[recipient]);
356 
357         balances[msg.sender] -= tokens;
358         balances[recipient] += tokens;
359         Transfer(msg.sender, recipient, tokens);
360         return true;
361     }
362 
363     // following is the part of SideBridge that is concerned
364     // with the part of the ERC20 standard responsible for giving others spending rights
365     // and spending others tokens
366 
367     // created when `approve` is executed to mark that
368     // `tokenOwner` has approved `spender` to spend `tokens` of his tokens
369     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
370 
371     // allow `spender` to withdraw from your account, multiple times, up to the `tokens` amount.
372     // calling this function repeatedly overwrites the current allowance.
373     function approve(address spender, uint256 tokens) public returns (bool) {
374         allowed[msg.sender][spender] = tokens;
375         Approval(msg.sender, spender, tokens);
376         return true;
377     }
378 
379     // returns how much `spender` is allowed to spend of `owner`s tokens
380     function allowance(address owner, address spender) public view returns (uint256) {
381         return allowed[owner][spender];
382     }
383 
384     function transferFrom(address from, address to, uint tokens) public returns (bool) {
385         // `from` has enough tokens
386         require(balances[from] >= tokens);
387         // `sender` is allowed to move `tokens` from `from`
388         require(allowed[from][msg.sender] >= tokens);
389         // fails if there is an overflow
390         require(balances[to] + tokens >= balances[to]);
391 
392         balances[to] += tokens;
393         balances[from] -= tokens;
394         allowed[from][msg.sender] -= tokens;
395 
396         Transfer(from, to, tokens);
397         return true;
398     }
399 
400     // following is the part of SideBridge that is
401     // no longer part of ERC20 and is concerned with
402     // with moving tokens from and to MainBridge
403 
404     struct SignaturesCollection {
405         /// Signed message.
406         bytes message;
407         /// Authorities who signed the message.
408         address[] authorities;
409         /// Signatures
410         bytes[] signatures;
411     }
412 
413     /// Number of authorities signatures required to withdraw the money.
414     ///
415     /// Must be less than number of authorities.
416     uint256 public requiredSignatures;
417 
418     uint256 public estimatedGasCostOfWithdraw;
419 
420     /// Contract authorities.
421     address[] public authorities;
422 
423     /// Pending deposits and authorities who confirmed them
424     mapping (bytes32 => address[]) deposits;
425 
426     /// Pending signatures and authorities who confirmed them
427     mapping (bytes32 => SignaturesCollection) signatures;
428 
429     /// triggered when an authority confirms a deposit
430     event DepositConfirmation(address recipient, uint256 value, bytes32 transactionHash);
431 
432     /// triggered when enough authorities have confirmed a deposit
433     event Deposit(address recipient, uint256 value, bytes32 transactionHash);
434 
435     /// Event created on money withdraw.
436     event Withdraw(address recipient, uint256 value, uint256 mainGasPrice);
437 
438     event WithdrawSignatureSubmitted(bytes32 messageHash);
439 
440     /// Collected signatures which should be relayed to main chain.
441     event CollectedSignatures(address indexed authorityResponsibleForRelay, bytes32 messageHash);
442 
443     function SideBridge(
444         uint256 _requiredSignatures,
445         address[] _authorities,
446         uint256 _estimatedGasCostOfWithdraw
447     ) public
448     {
449         require(_requiredSignatures != 0);
450         require(_requiredSignatures <= _authorities.length);
451         requiredSignatures = _requiredSignatures;
452         authorities = _authorities;
453         estimatedGasCostOfWithdraw = _estimatedGasCostOfWithdraw;
454     }
455 
456     // Called by the bridge node processes on startup
457     // to determine early whether the address pointing to the side
458     // bridge contract is misconfigured.
459     // so we can provide a helpful error message instead of the
460     // very unhelpful errors encountered otherwise.
461     function isSideBridgeContract() public pure returns (bool) {
462         return true;
463     }
464 
465     /// require that sender is an authority
466     modifier onlyAuthority() {
467         require(Helpers.addressArrayContains(authorities, msg.sender));
468         _;
469     }
470 
471     /// Used to deposit money to the contract.
472     ///
473     /// deposit recipient (bytes20)
474     /// deposit value (uint256)
475     /// mainnet transaction hash (bytes32) // to avoid transaction duplication
476     function deposit(address recipient, uint256 value, bytes32 transactionHash) public onlyAuthority() {
477         // Protection from misbehaving authority
478         var hash = keccak256(recipient, value, transactionHash);
479 
480         // don't allow authority to confirm deposit twice
481         require(!Helpers.addressArrayContains(deposits[hash], msg.sender));
482 
483         deposits[hash].push(msg.sender);
484 
485         // TODO: this may cause troubles if requiredSignatures len is changed
486         if (deposits[hash].length != requiredSignatures) {
487             DepositConfirmation(recipient, value, transactionHash);
488             return;
489         }
490 
491         balances[recipient] += value;
492         // mints tokens
493         totalSupply += value;
494         // ERC20 specifies: a token contract which creates new tokens
495         // SHOULD trigger a Transfer event with the _from address
496         // set to 0x0 when tokens are created.
497         Transfer(0x0, recipient, value);
498         Deposit(recipient, value, transactionHash);
499     }
500 
501     /// Transfer `value` from `msg.sender`s local balance (on `side` chain) to `recipient` on `main` chain.
502     ///
503     /// immediately decreases `msg.sender`s local balance.
504     /// emits a `Withdraw` event which will be picked up by the bridge authorities.
505     /// bridge authorities will then sign off (by calling `submitSignature`) on a message containing `value`,
506     /// `recipient` and the `hash` of the transaction on `side` containing the `Withdraw` event.
507     /// once `requiredSignatures` are collected a `CollectedSignatures` event will be emitted.
508     /// an authority will pick up `CollectedSignatures` an call `MainBridge.withdraw`
509     /// which transfers `value - relayCost` to `recipient` completing the transfer.
510     function transferToMainViaRelay(address recipient, uint256 value, uint256 mainGasPrice) public {
511         require(balances[msg.sender] >= value);
512         // don't allow 0 value transfers to main
513         require(value > 0);
514 
515         uint256 estimatedWeiCostOfWithdraw = estimatedGasCostOfWithdraw * mainGasPrice;
516         require(value > estimatedWeiCostOfWithdraw);
517 
518         balances[msg.sender] -= value;
519         // burns tokens
520         totalSupply -= value;
521         // in line with the transfer event from `0x0` on token creation
522         // recommended by ERC20 (see implementation of `deposit` above)
523         // we trigger a Transfer event to `0x0` on token destruction
524         Transfer(msg.sender, 0x0, value);
525         Withdraw(recipient, value, mainGasPrice);
526     }
527 
528     /// Should be used as sync tool
529     ///
530     /// Message is a message that should be relayed to main chain once authorities sign it.
531     ///
532     /// for withdraw message contains:
533     /// withdrawal recipient (bytes20)
534     /// withdrawal value (uint256)
535     /// side transaction hash (bytes32) // to avoid transaction duplication
536     function submitSignature(bytes signature, bytes message) public onlyAuthority() {
537         // ensure that `signature` is really `message` signed by `msg.sender`
538         require(msg.sender == MessageSigning.recoverAddressFromSignedMessage(signature, message));
539 
540         require(message.length == 116);
541         var hash = keccak256(message);
542 
543         // each authority can only provide one signature per message
544         require(!Helpers.addressArrayContains(signatures[hash].authorities, msg.sender));
545         signatures[hash].message = message;
546         signatures[hash].authorities.push(msg.sender);
547         signatures[hash].signatures.push(signature);
548 
549         // TODO: this may cause troubles if requiredSignatures len is changed
550         if (signatures[hash].authorities.length == requiredSignatures) {
551             CollectedSignatures(msg.sender, hash);
552         } else {
553             WithdrawSignatureSubmitted(hash);
554         }
555     }
556 
557     function hasAuthoritySignedMainToSide(address authority, address recipient, uint256 value, bytes32 mainTxHash) public view returns (bool) {
558         var hash = keccak256(recipient, value, mainTxHash);
559 
560         return Helpers.addressArrayContains(deposits[hash], authority);
561     }
562 
563     function hasAuthoritySignedSideToMain(address authority, bytes message) public view returns (bool) {
564         require(message.length == 116);
565         var messageHash = keccak256(message);
566         return Helpers.addressArrayContains(signatures[messageHash].authorities, authority);
567     }
568 
569     /// Get signature
570     function signature(bytes32 messageHash, uint256 index) public view returns (bytes) {
571         return signatures[messageHash].signatures[index];
572     }
573 
574     /// Get message
575     function message(bytes32 message_hash) public view returns (bytes) {
576         return signatures[message_hash].message;
577     }
578 }