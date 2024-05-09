1 pragma solidity 0.4.24;
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
30   function allowance(address owner, address spender)
31     public view returns (uint256);
32 
33   function transferFrom(address from, address to, uint256 value)
34     public returns (bool);
35 
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(
38     address indexed owner,
39     address indexed spender,
40     uint256 value
41   );
42 }
43 
44 // File: contracts/ERC677.sol
45 
46 contract ERC677 is ERC20 {
47     event Transfer(address indexed from, address indexed to, uint value, bytes data);
48 
49     function transferAndCall(address, uint, bytes) external returns (bool);
50 
51 }
52 
53 // File: contracts/IBurnableMintableERC677Token.sol
54 
55 contract IBurnableMintableERC677Token is ERC677 {
56     function mint(address, uint256) public returns (bool);
57     function burn(uint256 _value) public;
58     function claimTokens(address _token, address _to) public;
59 }
60 
61 // File: contracts/IBridgeValidators.sol
62 
63 interface IBridgeValidators {
64     function isValidator(address _validator) public view returns(bool);
65     function requiredSignatures() public view returns(uint256);
66     function owner() public view returns(address);
67 }
68 
69 // File: contracts/libraries/Message.sol
70 
71 library Message {
72     // function uintToString(uint256 inputValue) internal pure returns (string) {
73     //     // figure out the length of the resulting string
74     //     uint256 length = 0;
75     //     uint256 currentValue = inputValue;
76     //     do {
77     //         length++;
78     //         currentValue /= 10;
79     //     } while (currentValue != 0);
80     //     // allocate enough memory
81     //     bytes memory result = new bytes(length);
82     //     // construct the string backwards
83     //     uint256 i = length - 1;
84     //     currentValue = inputValue;
85     //     do {
86     //         result[i--] = byte(48 + currentValue % 10);
87     //         currentValue /= 10;
88     //     } while (currentValue != 0);
89     //     return string(result);
90     // }
91 
92     function addressArrayContains(address[] array, address value) internal pure returns (bool) {
93         for (uint256 i = 0; i < array.length; i++) {
94             if (array[i] == value) {
95                 return true;
96             }
97         }
98         return false;
99     }
100     // layout of message :: bytes:
101     // offset  0: 32 bytes :: uint256 - message length
102     // offset 32: 20 bytes :: address - recipient address
103     // offset 52: 32 bytes :: uint256 - value
104     // offset 84: 32 bytes :: bytes32 - transaction hash
105     // offset 104: 20 bytes :: address - contract address to prevent double spending
106 
107     // bytes 1 to 32 are 0 because message length is stored as little endian.
108     // mload always reads 32 bytes.
109     // so we can and have to start reading recipient at offset 20 instead of 32.
110     // if we were to read at 32 the address would contain part of value and be corrupted.
111     // when reading from offset 20 mload will read 12 zero bytes followed
112     // by the 20 recipient address bytes and correctly convert it into an address.
113     // this saves some storage/gas over the alternative solution
114     // which is padding address to 32 bytes and reading recipient at offset 32.
115     // for more details see discussion in:
116     // https://github.com/paritytech/parity-bridge/issues/61
117     function parseMessage(bytes message)
118         internal
119         pure
120         returns(address recipient, uint256 amount, bytes32 txHash, address contractAddress)
121     {
122         require(isMessageValid(message));
123         assembly {
124             recipient := and(mload(add(message, 20)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
125             amount := mload(add(message, 52))
126             txHash := mload(add(message, 84))
127             contractAddress := mload(add(message, 104))
128         }
129     }
130 
131     function isMessageValid(bytes _msg) internal pure returns(bool) {
132         return _msg.length == requiredMessageLength();
133     }
134 
135     function requiredMessageLength() internal pure returns(uint256) {
136         return 104;
137     }
138 
139     function recoverAddressFromSignedMessage(bytes signature, bytes message) internal pure returns (address) {
140         require(signature.length == 65);
141         bytes32 r;
142         bytes32 s;
143         bytes1 v;
144         // solium-disable-next-line security/no-inline-assembly
145         assembly {
146             r := mload(add(signature, 0x20))
147             s := mload(add(signature, 0x40))
148             v := mload(add(signature, 0x60))
149         }
150         return ecrecover(hashMessage(message), uint8(v), r, s);
151     }
152 
153     function hashMessage(bytes message) internal pure returns (bytes32) {
154         bytes memory prefix = "\x19Ethereum Signed Message:\n";
155         // message is always 84 length
156         string memory msgLength = "104";
157         return keccak256(abi.encodePacked(prefix, msgLength, message));
158     }
159 
160     function hasEnoughValidSignatures(
161         bytes _message,
162         uint8[] _vs,
163         bytes32[] _rs,
164         bytes32[] _ss,
165         IBridgeValidators _validatorContract) internal view {
166         require(isMessageValid(_message));
167         uint256 requiredSignatures = _validatorContract.requiredSignatures();
168         require(_vs.length >= requiredSignatures);
169         bytes32 hash = hashMessage(_message);
170         address[] memory encounteredAddresses = new address[](requiredSignatures);
171 
172         for (uint256 i = 0; i < requiredSignatures; i++) {
173             address recoveredAddress = ecrecover(hash, _vs[i], _rs[i], _ss[i]);
174             require(_validatorContract.isValidator(recoveredAddress));
175             if (addressArrayContains(encounteredAddresses, recoveredAddress)) {
176                 revert();
177             }
178             encounteredAddresses[i] = recoveredAddress;
179         }
180     }
181 }
182 
183 // File: contracts/libraries/SafeMath.sol
184 
185 /**
186  * @title SafeMath
187  * @dev Math operations with safety checks that throw on error
188  */
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195     if (a == 0) {
196       return 0;
197     }
198     uint256 c = a * b;
199     assert(c / a == b);
200     return c;
201   }
202 
203   /**
204   * @dev Integer division of two numbers, truncating the quotient.
205   */
206   function div(uint256 a, uint256 b) internal pure returns (uint256) {
207     // assert(b > 0); // Solidity automatically throws when dividing by 0
208     uint256 c = a / b;
209     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210     return c;
211   }
212 
213   /**
214   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
215   */
216   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217     assert(b <= a);
218     return a - b;
219   }
220 
221   /**
222   * @dev Adds two numbers, throws on overflow.
223   */
224   function add(uint256 a, uint256 b) internal pure returns (uint256) {
225     uint256 c = a + b;
226     assert(c >= a);
227     return c;
228   }
229 }
230 
231 // File: contracts/libraries/Version.sol
232 
233 library Version {
234 
235     struct Version {
236         uint64 major;
237         uint64 minor;
238         uint64 patch;
239     }
240 
241 }
242 
243 // File: contracts/upgradeability/EternalStorage.sol
244 
245 /**
246  * @title EternalStorage
247  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
248  */
249 contract EternalStorage {
250 
251     mapping(bytes32 => uint256) internal uintStorage;
252     mapping(bytes32 => string) internal stringStorage;
253     mapping(bytes32 => address) internal addressStorage;
254     mapping(bytes32 => bytes) internal bytesStorage;
255     mapping(bytes32 => bool) internal boolStorage;
256     mapping(bytes32 => int256) internal intStorage;
257 
258 }
259 
260 // File: contracts/upgradeable_contracts/Validatable.sol
261 
262 contract Validatable is EternalStorage {
263     function validatorContract() public view returns(IBridgeValidators) {
264         return IBridgeValidators(addressStorage[keccak256(abi.encodePacked("validatorContract"))]);
265     }
266 
267     modifier onlyValidator() {
268         require(validatorContract().isValidator(msg.sender));
269         _;
270     }
271 
272     modifier onlyOwner() {
273         require(validatorContract().owner() == msg.sender);
274         _;
275     }
276 
277     function requiredSignatures() public view returns(uint256) {
278         return validatorContract().requiredSignatures();
279     }
280 
281 }
282 
283 // File: contracts/upgradeable_contracts/BasicBridge.sol
284 
285 contract BasicBridge is EternalStorage, Validatable {
286     using SafeMath for uint256;
287 
288     Version.Version public getBridgeInterfacesVersion = Version.Version(2, 0, 0);
289 
290     event GasPriceChanged(uint256 gasPrice);
291     event RequiredBlockConfirmationChanged(uint256 requiredBlockConfirmations);
292     event DailyLimitChanged(uint256 newLimit);
293 
294     function setGasPrice(uint256 _gasPrice) public onlyOwner {
295         require(_gasPrice > 0);
296         uintStorage[keccak256(abi.encodePacked("gasPrice"))] = _gasPrice;
297         emit GasPriceChanged(_gasPrice);
298     }
299 
300     function gasPrice() public view returns(uint256) {
301         return uintStorage[keccak256(abi.encodePacked("gasPrice"))];
302     }
303 
304     function setRequiredBlockConfirmations(uint256 _blockConfirmations) public onlyOwner {
305         require(_blockConfirmations > 0);
306         uintStorage[keccak256(abi.encodePacked("requiredBlockConfirmations"))] = _blockConfirmations;
307         emit RequiredBlockConfirmationChanged(_blockConfirmations);
308     }
309 
310     function requiredBlockConfirmations() public view returns(uint256) {
311         return uintStorage[keccak256(abi.encodePacked("requiredBlockConfirmations"))];
312     }
313 
314     function deployedAtBlock() public view returns(uint256) {
315         return uintStorage[keccak256(abi.encodePacked("deployedAtBlock"))];
316     }
317 
318     function setTotalSpentPerDay(uint256 _day, uint256 _value) internal {
319         uintStorage[keccak256(abi.encodePacked("totalSpentPerDay", _day))] = _value;
320     }
321 
322     function totalSpentPerDay(uint256 _day) public view returns(uint256) {
323         return uintStorage[keccak256(abi.encodePacked("totalSpentPerDay", _day))];
324     }
325 
326     function minPerTx() public view returns(uint256) {
327         return uintStorage[keccak256(abi.encodePacked("minPerTx"))];
328     }
329 
330     function maxPerTx() public view returns(uint256) {
331         return uintStorage[keccak256(abi.encodePacked("maxPerTx"))];
332     }
333 
334     function setInitialize(bool _status) internal {
335         boolStorage[keccak256(abi.encodePacked("isInitialized"))] = _status;
336     }
337 
338     function isInitialized() public view returns(bool) {
339         return boolStorage[keccak256(abi.encodePacked("isInitialized"))];
340     }
341 
342     function getCurrentDay() public view returns(uint256) {
343         return now / 1 days;
344     }
345 
346     function setDailyLimit(uint256 _dailyLimit) public onlyOwner {
347         uintStorage[keccak256(abi.encodePacked("dailyLimit"))] = _dailyLimit;
348         emit DailyLimitChanged(_dailyLimit);
349     }
350 
351     function dailyLimit() public view returns(uint256) {
352         return uintStorage[keccak256(abi.encodePacked("dailyLimit"))];
353     }
354 
355     function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
356         require(_maxPerTx < dailyLimit());
357         uintStorage[keccak256(abi.encodePacked("maxPerTx"))] = _maxPerTx;
358     }
359 
360     function setMinPerTx(uint256 _minPerTx) external onlyOwner {
361         require(_minPerTx < dailyLimit() && _minPerTx < maxPerTx());
362         uintStorage[keccak256(abi.encodePacked("minPerTx"))] = _minPerTx;
363     }
364 
365     function withinLimit(uint256 _amount) public view returns(bool) {
366         uint256 nextLimit = totalSpentPerDay(getCurrentDay()).add(_amount);
367         return dailyLimit() >= nextLimit && _amount <= maxPerTx() && _amount >= minPerTx();
368     }
369 
370     function claimTokens(address _token, address _to) public onlyOwner {
371         require(_to != address(0));
372         if (_token == address(0)) {
373             _to.transfer(address(this).balance);
374             return;
375         }
376 
377         ERC20Basic token = ERC20Basic(_token);
378         uint256 balance = token.balanceOf(this);
379         require(token.transfer(_to, balance));
380     }
381 
382 }
383 
384 // File: contracts/upgradeable_contracts/BasicForeignBridge.sol
385 
386 contract BasicForeignBridge is EternalStorage, Validatable {
387     using SafeMath for uint256;
388     /// triggered when relay of deposit from HomeBridge is complete
389     event RelayedMessage(address recipient, uint value, bytes32 transactionHash);
390     function executeSignatures(uint8[] vs, bytes32[] rs, bytes32[] ss, bytes message) external {
391         Message.hasEnoughValidSignatures(message, vs, rs, ss, validatorContract());
392         address recipient;
393         uint256 amount;
394         bytes32 txHash;
395         address contractAddress;
396         (recipient, amount, txHash, contractAddress) = Message.parseMessage(message);
397         require(contractAddress == address(this));
398         require(!relayedMessages(txHash));
399         setRelayedMessages(txHash, true);
400         require(onExecuteMessage(recipient, amount));
401         emit RelayedMessage(recipient, amount, txHash);
402     }
403 
404     function onExecuteMessage(address, uint256) internal returns(bool){
405         // has to be defined
406     }
407 
408     function setRelayedMessages(bytes32 _txHash, bool _status) internal {
409         boolStorage[keccak256(abi.encodePacked("relayedMessages", _txHash))] = _status;
410     }
411 
412     function relayedMessages(bytes32 _txHash) public view returns(bool) {
413         return boolStorage[keccak256(abi.encodePacked("relayedMessages", _txHash))];
414     }
415 }
416 
417 // File: contracts/upgradeable_contracts/erc20_to_erc20/ForeignBridgeErcToErc.sol
418 
419 contract ForeignBridgeErcToErc is BasicBridge, BasicForeignBridge {
420 
421     event RelayedMessage(address recipient, uint value, bytes32 transactionHash);
422 
423     function initialize(
424         address _validatorContract,
425         address _erc20token,
426         uint256 _requiredBlockConfirmations
427     ) public returns(bool) {
428         require(!isInitialized(), "already initialized");
429         require(_validatorContract != address(0), "address cannot be empty");
430         require(_requiredBlockConfirmations != 0, "requiredBlockConfirmations cannot be 0");
431         addressStorage[keccak256(abi.encodePacked("validatorContract"))] = _validatorContract;
432         setErc20token(_erc20token);
433         uintStorage[keccak256(abi.encodePacked("deployedAtBlock"))] = block.number;
434         uintStorage[keccak256(abi.encodePacked("requiredBlockConfirmations"))] = _requiredBlockConfirmations;
435         setInitialize(true);
436         return isInitialized();
437     }
438 
439     function getBridgeMode() public pure returns(bytes4 _data) {
440         return bytes4(keccak256(abi.encodePacked("erc-to-erc-core")));
441     }
442 
443     function claimTokens(address _token, address _to) public onlyOwner {
444         require(_token != address(erc20token()));
445         super.claimTokens(_token, _to);
446     }
447 
448     function erc20token() public view returns(ERC20Basic) {
449         return ERC20Basic(addressStorage[keccak256(abi.encodePacked("erc20token"))]);
450     }
451 
452     function onExecuteMessage(address _recipient, uint256 _amount) internal returns(bool){
453         return erc20token().transfer(_recipient, _amount);
454     }
455 
456     function setErc20token(address _token) private {
457         require(_token != address(0));
458         addressStorage[keccak256(abi.encodePacked("erc20token"))] = _token;
459     }
460 }