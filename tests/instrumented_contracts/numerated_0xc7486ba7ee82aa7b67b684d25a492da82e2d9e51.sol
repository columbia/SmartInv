1 pragma solidity 0.4.23;
2 
3 // File: contracts/ERC677Receiver.sol
4 
5 contract ERC677Receiver {
6   function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
7 }
8 
9 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public view returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 // File: contracts/ERC677.sol
37 
38 contract ERC677 is ERC20 {
39     event Transfer(address indexed from, address indexed to, uint value, bytes data);
40 
41     function transferAndCall(address, uint, bytes) external returns (bool);
42 
43 }
44 
45 // File: contracts/IBurnableMintableERC677Token.sol
46 
47 contract IBurnableMintableERC677Token is ERC677 {
48     function mint(address, uint256) public returns (bool);
49     function burn(uint256 _value) public;
50     function claimTokens(address _token, address _to) public;
51 }
52 
53 // File: contracts/IBridgeValidators.sol
54 
55 interface IBridgeValidators {
56     function isValidator(address _validator) public view returns(bool);
57     function requiredSignatures() public view returns(uint256);
58     function owner() public view returns(address);
59 }
60 
61 // File: contracts/libraries/Message.sol
62 
63 library Message {
64     // function uintToString(uint256 inputValue) internal pure returns (string) {
65     //     // figure out the length of the resulting string
66     //     uint256 length = 0;
67     //     uint256 currentValue = inputValue;
68     //     do {
69     //         length++;
70     //         currentValue /= 10;
71     //     } while (currentValue != 0);
72     //     // allocate enough memory
73     //     bytes memory result = new bytes(length);
74     //     // construct the string backwards
75     //     uint256 i = length - 1;
76     //     currentValue = inputValue;
77     //     do {
78     //         result[i--] = byte(48 + currentValue % 10);
79     //         currentValue /= 10;
80     //     } while (currentValue != 0);
81     //     return string(result);
82     // }
83 
84     function addressArrayContains(address[] array, address value) internal pure returns (bool) {
85         for (uint256 i = 0; i < array.length; i++) {
86             if (array[i] == value) {
87                 return true;
88             }
89         }
90         return false;
91     }
92     // layout of message :: bytes:
93     // offset  0: 32 bytes :: uint256 - message length
94     // offset 32: 20 bytes :: address - recipient address
95     // offset 52: 32 bytes :: uint256 - value
96     // offset 84: 32 bytes :: bytes32 - transaction hash
97     // offset 116: 32 bytes :: uint256 - home gas price
98 
99     // bytes 1 to 32 are 0 because message length is stored as little endian.
100     // mload always reads 32 bytes.
101     // so we can and have to start reading recipient at offset 20 instead of 32.
102     // if we were to read at 32 the address would contain part of value and be corrupted.
103     // when reading from offset 20 mload will read 12 zero bytes followed
104     // by the 20 recipient address bytes and correctly convert it into an address.
105     // this saves some storage/gas over the alternative solution
106     // which is padding address to 32 bytes and reading recipient at offset 32.
107     // for more details see discussion in:
108     // https://github.com/paritytech/parity-bridge/issues/61
109     function parseMessage(bytes message)
110         internal
111         pure
112         returns(address recipient, uint256 amount, bytes32 txHash)
113     {
114         require(isMessageValid(message));
115         assembly {
116             recipient := and(mload(add(message, 20)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
117             amount := mload(add(message, 52))
118             txHash := mload(add(message, 84))
119         }
120     }
121 
122     function isMessageValid(bytes _msg) internal pure returns(bool) {
123         return _msg.length == 116;
124     }
125 
126     function recoverAddressFromSignedMessage(bytes signature, bytes message) internal pure returns (address) {
127         require(signature.length == 65);
128         bytes32 r;
129         bytes32 s;
130         bytes1 v;
131         // solium-disable-next-line security/no-inline-assembly
132         assembly {
133             r := mload(add(signature, 0x20))
134             s := mload(add(signature, 0x40))
135             v := mload(add(signature, 0x60))
136         }
137         return ecrecover(hashMessage(message), uint8(v), r, s);
138     }
139 
140     function hashMessage(bytes message) internal pure returns (bytes32) {
141         bytes memory prefix = "\x19Ethereum Signed Message:\n";
142         // message is always 116 length
143         string memory msgLength = "116";
144         return keccak256(prefix, msgLength, message);
145     }
146 
147     function hasEnoughValidSignatures(
148         bytes _message,
149         uint8[] _vs,
150         bytes32[] _rs,
151         bytes32[] _ss,
152         IBridgeValidators _validatorContract) internal view {
153         require(isMessageValid(_message));
154         uint256 requiredSignatures = _validatorContract.requiredSignatures();
155         require(_vs.length >= requiredSignatures);
156         bytes32 hash = hashMessage(_message);
157         address[] memory encounteredAddresses = new address[](requiredSignatures);
158 
159         for (uint256 i = 0; i < requiredSignatures; i++) {
160             address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
161             require(_validatorContract.isValidator(recoveredAddress));
162             if (addressArrayContains(encounteredAddresses, recoveredAddress)) {
163                 revert();
164             }
165             encounteredAddresses[i] = recoveredAddress;
166         }
167     }
168 }
169 
170 // File: contracts/libraries/SafeMath.sol
171 
172 /**
173  * @title SafeMath
174  * @dev Math operations with safety checks that throw on error
175  */
176 library SafeMath {
177 
178   /**
179   * @dev Multiplies two numbers, throws on overflow.
180   */
181   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182     if (a == 0) {
183       return 0;
184     }
185     uint256 c = a * b;
186     assert(c / a == b);
187     return c;
188   }
189 
190   /**
191   * @dev Integer division of two numbers, truncating the quotient.
192   */
193   function div(uint256 a, uint256 b) internal pure returns (uint256) {
194     // assert(b > 0); // Solidity automatically throws when dividing by 0
195     uint256 c = a / b;
196     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197     return c;
198   }
199 
200   /**
201   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
202   */
203   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204     assert(b <= a);
205     return a - b;
206   }
207 
208   /**
209   * @dev Adds two numbers, throws on overflow.
210   */
211   function add(uint256 a, uint256 b) internal pure returns (uint256) {
212     uint256 c = a + b;
213     assert(c >= a);
214     return c;
215   }
216 }
217 
218 // File: contracts/upgradeability/EternalStorage.sol
219 
220 /**
221  * @title EternalStorage
222  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
223  */
224 contract EternalStorage {
225 
226     mapping(bytes32 => uint256) internal uintStorage;
227     mapping(bytes32 => string) internal stringStorage;
228     mapping(bytes32 => address) internal addressStorage;
229     mapping(bytes32 => bytes) internal bytesStorage;
230     mapping(bytes32 => bool) internal boolStorage;
231     mapping(bytes32 => int256) internal intStorage;
232 
233 }
234 
235 // File: contracts/upgradeable_contracts/U_BasicBridge.sol
236 
237 contract BasicBridge is EternalStorage {
238     event GasPriceChanged(uint256 gasPrice);
239     event RequiredBlockConfirmationChanged(uint256 requiredBlockConfirmations);
240     function validatorContract() public view returns(IBridgeValidators) {
241         return IBridgeValidators(addressStorage[keccak256("validatorContract")]);
242     }
243 
244     modifier onlyValidator() {
245         require(validatorContract().isValidator(msg.sender));
246         _;
247     }
248 
249     modifier onlyOwner() {
250         require(validatorContract().owner() == msg.sender);
251         _;
252     }
253 
254     function setGasPrice(uint256 _gasPrice) public onlyOwner {
255         require(_gasPrice > 0);
256         uintStorage[keccak256("gasPrice")] = _gasPrice;
257         emit GasPriceChanged(_gasPrice);
258     }
259 
260     function gasPrice() public view returns(uint256) {
261         return uintStorage[keccak256("gasPrice")];
262     }
263 
264     function setRequiredBlockConfirmations(uint256 _blockConfirmations) public onlyOwner {
265         require(_blockConfirmations > 0);
266         uintStorage[keccak256("requiredBlockConfirmations")] = _blockConfirmations;
267         emit RequiredBlockConfirmationChanged(_blockConfirmations);
268     }
269 
270     function requiredBlockConfirmations() public view returns(uint256) {
271         return uintStorage[keccak256("requiredBlockConfirmations")];
272     }
273 }
274 
275 // File: contracts/upgradeable_contracts/U_ForeignBridge.sol
276 
277 contract ForeignBridge is ERC677Receiver, BasicBridge {
278     using SafeMath for uint256;
279     /// triggered when relay of deposit from HomeBridge is complete
280     event Deposit(address recipient, uint value, bytes32 transactionHash);
281 
282     /// Event created on money withdraw.
283     event Withdraw(address recipient, uint256 value, uint256 homeGasPrice);
284 
285     /// Collected signatures which should be relayed to home chain.
286     event CollectedSignatures(address authorityResponsibleForRelay, bytes32 messageHash);
287 
288     event GasConsumptionLimitsUpdated(uint256 gasLimitDepositRelay, uint256 gasLimitWithdrawConfirm);
289 
290     event SignedForDeposit(address indexed signer, bytes32 transactionHash);
291     event SignedForWithdraw(address indexed signer, bytes32 messageHash);
292     event DailyLimit(uint256 newLimit);
293 
294     function initialize(
295         address _validatorContract,
296         address _erc677token,
297         uint256 _foreignDailyLimit,
298         uint256 _maxPerTx,
299         uint256 _minPerTx,
300         uint256 _foreignGasPrice,
301         uint256 _requiredBlockConfirmations
302     ) public returns(bool) {
303         require(!isInitialized());
304         require(_validatorContract != address(0));
305         require(_minPerTx > 0 && _maxPerTx > _minPerTx && _foreignDailyLimit > _maxPerTx);
306         require(_foreignGasPrice > 0);
307         addressStorage[keccak256("validatorContract")] = _validatorContract;
308         setErc677token(_erc677token);
309         uintStorage[keccak256("foreignDailyLimit")] = _foreignDailyLimit;
310         uintStorage[keccak256("deployedAtBlock")] = block.number;
311         uintStorage[keccak256("maxPerTx")] = _maxPerTx;
312         uintStorage[keccak256("minPerTx")] = _minPerTx;
313         uintStorage[keccak256("gasPrice")] = _foreignGasPrice;
314         uintStorage[keccak256("requiredBlockConfirmations")] = _requiredBlockConfirmations;
315         setInitialize(true);
316         return isInitialized();
317     }
318 
319     function onTokenTransfer(address _from, uint256 _value, bytes /*_data*/) external returns(bool) {
320         require(msg.sender == address(erc677token()));
321         require(withinLimit(_value));
322         setTotalSpentPerDay(getCurrentDay(), totalSpentPerDay(getCurrentDay()).add(_value));
323         erc677token().burn(_value);
324         emit Withdraw(_from, _value, gasPriceForCompensationAtHomeSide());
325         return true;
326     }
327 
328     function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
329         require(_maxPerTx < foreignDailyLimit());
330         uintStorage[keccak256("maxPerTx")] = _maxPerTx;
331     }
332 
333     function setMinPerTx(uint256 _minPerTx) external onlyOwner {
334         require(_minPerTx < foreignDailyLimit() && _minPerTx < maxPerTx());
335         uintStorage[keccak256("minPerTx")] = _minPerTx;
336     }
337 
338     function claimTokens(address _token, address _to) external onlyOwner {
339         require(_to != address(0));
340         if (_token == address(0)) {
341             _to.transfer(address(this).balance);
342             return;
343         }
344 
345         ERC20Basic token = ERC20Basic(_token);
346         uint256 balance = token.balanceOf(this);
347         require(token.transfer(_to, balance));
348     }
349 
350     function claimTokensFromErc677(address _token, address _to) external onlyOwner {
351         erc677token().claimTokens(_token, _to);
352     }
353 
354     function minPerTx() public view returns(uint256) {
355         return uintStorage[keccak256("minPerTx")];
356     }
357 
358     function maxPerTx() public view returns(uint256) {
359         return uintStorage[keccak256("maxPerTx")];
360     }
361 
362     function totalSpentPerDay(uint256 _day) public view returns(uint256) {
363         return uintStorage[keccak256("totalSpentPerDay", _day)];
364     }
365 
366     function deployedAtBlock() public view returns(uint256) {
367         return uintStorage[keccak256("deployedAtBlock")];
368     }
369 
370     function gasLimitDepositRelay() public view returns(uint256) {
371         return uintStorage[keccak256("gasLimitDepositRelay")];
372     }
373 
374     function gasLimitWithdrawConfirm() public view returns(uint256) {
375         return uintStorage[keccak256("gasLimitWithdrawConfirm")];
376     }
377 
378     function foreignDailyLimit() public view returns(uint256) {
379         return uintStorage[keccak256("foreignDailyLimit")];
380     }
381 
382     function erc677token() public view returns(IBurnableMintableERC677Token) {
383         return IBurnableMintableERC677Token(addressStorage[keccak256("erc677token")]);
384     }
385 
386     function setGasLimits(uint256 _gasLimitDepositRelay, uint256 _gasLimitWithdrawConfirm) external onlyOwner {
387         uintStorage[keccak256("gasLimitDepositRelay")] = _gasLimitDepositRelay;
388         uintStorage[keccak256("gasLimitWithdrawConfirm")] = _gasLimitWithdrawConfirm;
389         emit GasConsumptionLimitsUpdated(gasLimitDepositRelay(), gasLimitWithdrawConfirm());
390     }
391 
392     function deposit(address recipient, uint256 value, bytes32 transactionHash) external onlyValidator {
393         bytes32 hashMsg = keccak256(recipient, value, transactionHash);
394         bytes32 hashSender = keccak256(msg.sender, hashMsg);
395         // Duplicated deposits
396         require(!depositsSigned(hashSender));
397         setDepositsSigned(hashSender, true);
398 
399         uint256 signed = numDepositsSigned(hashMsg);
400         require(!isAlreadyProcessed(signed));
401         // the check above assumes that the case when the value could be overflew will not happen in the addition operation below
402         signed = signed + 1;
403 
404         setNumDepositsSigned(hashMsg, signed);
405 
406         emit SignedForDeposit(msg.sender, transactionHash);
407 
408         if (signed >= validatorContract().requiredSignatures()) {
409             // If the bridge contract does not own enough tokens to transfer
410             // it will couse funds lock on the home side of the bridge
411             setNumDepositsSigned(hashMsg, markAsProcessed(signed));
412             erc677token().mint(recipient, value);
413             emit Deposit(recipient, value, transactionHash);
414         }
415     }
416 
417     /// Should be used as sync tool
418     ///
419     /// Message is a message that should be relayed to main chain once authorities sign it.
420     ///
421     /// for withdraw message contains:
422     /// withdrawal recipient (bytes20)
423     /// withdrawal value (uint)
424     /// foreign transaction hash (bytes32) // to avoid transaction duplication
425     function submitSignature(bytes signature, bytes message) external onlyValidator {
426         // ensure that `signature` is really `message` signed by `msg.sender`
427         require(Message.isMessageValid(message));
428         require(msg.sender == Message.recoverAddressFromSignedMessage(signature, message));
429         bytes32 hashMsg = keccak256(message);
430         bytes32 hashSender = keccak256(msg.sender, hashMsg);
431 
432         uint256 signed = numMessagesSigned(hashMsg);
433         require(!isAlreadyProcessed(signed));
434         // the check above assumes that the case when the value could be overflew will not happen in the addition operation below
435         signed = signed + 1;
436         if (signed > 1) {
437             // Duplicated signatures
438             require(!messagesSigned(hashSender));
439         } else {
440             setMessages(hashMsg, message);
441         }
442         setMessagesSigned(hashSender, true);
443 
444         bytes32 signIdx = keccak256(hashMsg, (signed-1));
445         setSignatures(signIdx, signature);
446 
447         setNumMessagesSigned(hashMsg, signed);
448 
449         emit SignedForWithdraw(msg.sender, hashMsg);
450         if (signed >= validatorContract().requiredSignatures()) {
451             setNumMessagesSigned(hashMsg, markAsProcessed(signed));
452             emit CollectedSignatures(msg.sender, hashMsg);
453         }
454     }
455 
456     function gasPriceForCompensationAtHomeSide() public pure returns(uint256) {
457         return 1000000000 wei;
458     }
459 
460     function isAlreadyProcessed(uint256 _number) public pure returns(bool) {
461         return _number & 2**255 == 2**255;
462     }
463 
464     function signature(bytes32 _hash, uint256 _index) public view returns (bytes) {
465         bytes32 signIdx = keccak256(_hash, _index);
466         return signatures(signIdx);
467     }
468 
469     /// Get message
470     function message(bytes32 _hash) public view returns (bytes) {
471         return messages(_hash);
472     }
473 
474     function getCurrentDay() public view returns(uint256) {
475         return now / 1 days;
476     }
477 
478     function setForeignDailyLimit(uint256 _foreignDailyLimit) public onlyOwner {
479         uintStorage[keccak256("foreignDailyLimit")] = _foreignDailyLimit;
480         emit DailyLimit(_foreignDailyLimit);
481     }
482 
483     function withinLimit(uint256 _amount) public view returns(bool) {
484         uint256 nextLimit = totalSpentPerDay(getCurrentDay()).add(_amount);
485         return foreignDailyLimit() >= nextLimit && _amount <= maxPerTx() && _amount >= minPerTx();
486     }
487 
488     function isInitialized() public view returns(bool) {
489         return boolStorage[keccak256("isInitialized")];
490     }
491 
492     function messages(bytes32 _hash) private view returns(bytes) {
493         return bytesStorage[keccak256("messages", _hash)];
494     }
495 
496     function setMessages(bytes32 _hash, bytes _message) private {
497         bytesStorage[keccak256("messages", _hash)] = _message;
498     }
499 
500     function signatures(bytes32 _hash) private view returns(bytes) {
501         return bytesStorage[keccak256("signatures", _hash)];
502     }
503 
504     function setSignatures(bytes32 _hash, bytes _signature) private {
505         bytesStorage[keccak256("signatures", _hash)] = _signature;
506     }
507 
508     function messagesSigned(bytes32 _message) public view returns(bool) {
509         return boolStorage[keccak256("messagesSigned", _message)];
510     }
511 
512     function depositsSigned(bytes32 _deposit) public view returns(bool) {
513         return boolStorage[keccak256("depositsSigned", _deposit)];
514     }
515 
516     function markAsProcessed(uint256 _v) private pure returns(uint256) {
517         return _v | 2 ** 255;
518     }
519 
520     function numMessagesSigned(bytes32 _message) private view returns(uint256) {
521         return uintStorage[keccak256("numMessagesSigned", _message)];
522     }
523 
524     function numDepositsSigned(bytes32 _deposit) private view returns(uint256) {
525         return uintStorage[keccak256("numDepositsSigned", _deposit)];
526     }
527 
528     function setMessagesSigned(bytes32 _hash, bool _status) private {
529         boolStorage[keccak256("messagesSigned", _hash)] = _status;
530     }
531 
532     function setDepositsSigned(bytes32 _deposit, bool _status) private {
533         boolStorage[keccak256("depositsSigned", _deposit)] = _status;
534     }
535 
536     function setNumMessagesSigned(bytes32 _message, uint256 _number) private {
537         uintStorage[keccak256("numMessagesSigned", _message)] = _number;
538     }
539 
540     function setNumDepositsSigned(bytes32 _deposit, uint256 _number) private {
541         uintStorage[keccak256("numDepositsSigned", _deposit)] = _number;
542     }
543 
544     function setTotalSpentPerDay(uint256 _day, uint256 _value) private {
545         uintStorage[keccak256("totalSpentPerDay", _day)] = _value;
546     }
547 
548     function setErc677token(address _token) private {
549         require(_token != address(0));
550         addressStorage[keccak256("erc677token")] = _token;
551     }
552 
553     function setInitialize(bool _status) private {
554         boolStorage[keccak256("isInitialized")] = _status;
555     }
556 
557 }