1 pragma solidity ^0.5.4;
2 
3 library CBOR {
4 
5     using Buffer for Buffer.buffer;
6 
7     uint8 private constant MAJOR_TYPE_INT = 0;
8     uint8 private constant MAJOR_TYPE_MAP = 5;
9     uint8 private constant MAJOR_TYPE_BYTES = 2;
10     uint8 private constant MAJOR_TYPE_ARRAY = 4;
11     uint8 private constant MAJOR_TYPE_STRING = 3;
12     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
13     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
14 
15     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
16         if (_value <= 23) {
17             _buf.append(uint8((_major << 5) | _value));
18         } else if (_value <= 0xFF) {
19             _buf.append(uint8((_major << 5) | 24));
20             _buf.appendInt(_value, 1);
21         } else if (_value <= 0xFFFF) {
22             _buf.append(uint8((_major << 5) | 25));
23             _buf.appendInt(_value, 2);
24         } else if (_value <= 0xFFFFFFFF) {
25             _buf.append(uint8((_major << 5) | 26));
26             _buf.appendInt(_value, 4);
27         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
28             _buf.append(uint8((_major << 5) | 27));
29             _buf.appendInt(_value, 8);
30         }
31     }
32 
33     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
34         _buf.append(uint8((_major << 5) | 31));
35     }
36 
37     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
38         encodeType(_buf, MAJOR_TYPE_INT, _value);
39     }
40 
41     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
42         if (_value >= 0) {
43             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
44         } else {
45             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
46         }
47     }
48 
49     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
50         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
51         _buf.append(_value);
52     }
53 
54     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
55         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
56         _buf.append(bytes(_value));
57     }
58 
59     function startArray(Buffer.buffer memory _buf) internal pure {
60         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
61     }
62 
63     function startMap(Buffer.buffer memory _buf) internal pure {
64         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
65     }
66 
67     function endSequence(Buffer.buffer memory _buf) internal pure {
68         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
69     }
70 }
71 
72 library Buffer {
73 
74     struct buffer {
75         bytes buf;
76         uint capacity;
77     }
78 
79     function init(buffer memory _buf, uint _capacity) internal pure {
80         uint capacity = _capacity;
81         if (capacity % 32 != 0) {
82             capacity += 32 - (capacity % 32);
83         }
84         _buf.capacity = capacity; // Allocate space for the buffer data
85         assembly {
86             let ptr := mload(0x40)
87             mstore(_buf, ptr)
88             mstore(ptr, 0)
89             mstore(0x40, add(ptr, capacity))
90         }
91     }
92 
93     function resize(buffer memory _buf, uint _capacity) private pure {
94         bytes memory oldbuf = _buf.buf;
95         init(_buf, _capacity);
96         append(_buf, oldbuf);
97     }
98 
99     function max(uint _a, uint _b) private pure returns (uint _max) {
100         if (_a > _b) {
101             return _a;
102         }
103         return _b;
104     }
105     /**
106       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
107       *      would exceed the capacity of the buffer.
108       * @param _buf The buffer to append to.
109       * @param _data The data to append.
110       * @return The original buffer.
111       *
112       */
113     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
114         if (_data.length + _buf.buf.length > _buf.capacity) {
115             resize(_buf, max(_buf.capacity, _data.length) * 2);
116         }
117         uint dest;
118         uint src;
119         uint len = _data.length;
120         assembly {
121             let bufptr := mload(_buf) // Memory address of the buffer data
122             let buflen := mload(bufptr) // Length of existing buffer data
123             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
124             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
125             src := add(_data, 32)
126         }
127         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
128             assembly {
129                 mstore(dest, mload(src))
130             }
131             dest += 32;
132             src += 32;
133         }
134         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
135         assembly {
136             let srcpart := and(mload(src), not(mask))
137             let destpart := and(mload(dest), mask)
138             mstore(dest, or(destpart, srcpart))
139         }
140         return _buf;
141     }
142     /**
143       *
144       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
145       * exceed the capacity of the buffer.
146       * @param _buf The buffer to append to.
147       * @param _data The data to append.
148       * @return The original buffer.
149       *
150       */
151     function append(buffer memory _buf, uint8 _data) internal pure {
152         if (_buf.buf.length + 1 > _buf.capacity) {
153             resize(_buf, _buf.capacity * 2);
154         }
155         assembly {
156             let bufptr := mload(_buf) // Memory address of the buffer data
157             let buflen := mload(bufptr) // Length of existing buffer data
158             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
159             mstore8(dest, _data)
160             mstore(bufptr, add(buflen, 1)) // Update buffer length
161         }
162     }
163     /**
164       *
165       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
166       * exceed the capacity of the buffer.
167       * @param _buf The buffer to append to.
168       * @param _data The data to append.
169       * @return The original buffer.
170       *
171       */
172     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
173         if (_len + _buf.buf.length > _buf.capacity) {
174             resize(_buf, max(_buf.capacity, _len) * 2);
175         }
176         uint mask = 256 ** _len - 1;
177         assembly {
178             let bufptr := mload(_buf) // Memory address of the buffer data
179             let buflen := mload(bufptr) // Length of existing buffer data
180             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
181             mstore(dest, or(and(mload(dest), not(mask)), _data))
182             mstore(bufptr, add(buflen, _len)) // Update buffer length
183         }
184         return _buf;
185     }
186 }
187 
188 interface IERC20 {
189     function transfer(address to, uint256 value) external returns (bool);
190 
191     function approve(address spender, uint256 value) external returns (bool);
192 
193     function transferFrom(address from, address to, uint256 value) external returns (bool);
194 
195     function totalSupply() external view returns (uint256);
196 
197     function balanceOf(address who) external view returns (uint256);
198 
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 
203     event Approval(address indexed owner, address indexed spender, uint256 value);
204 }
205 
206 contract ERC20 is IERC20 {
207     using SafeMath for uint256;
208 
209     mapping (address => uint256) private _balances;
210 
211     mapping (address => mapping (address => uint256)) private _allowed;
212 
213     uint256 private _totalSupply;
214 
215     /**
216      * @dev Total number of tokens in existence
217      */
218     function totalSupply() public view returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev Gets the balance of the specified address.
224      * @param owner The address to query the balance of.
225      * @return An uint256 representing the amount owned by the passed address.
226      */
227     function balanceOf(address owner) public view returns (uint256) {
228         return _balances[owner];
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param owner address The address which owns the funds.
234      * @param spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address owner, address spender) public view returns (uint256) {
238         return _allowed[owner][spender];
239     }
240 
241     /**
242      * @dev Transfer token for a specified address
243      * @param to The address to transfer to.
244      * @param value The amount to be transferred.
245      */
246     function transfer(address to, uint256 value) public returns (bool) {
247         _transfer(msg.sender, to, value);
248         return true;
249     }
250 
251     /**
252      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253      * Beware that changing an allowance with this method brings the risk that someone may use both the old
254      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      * @param spender The address which will spend the funds.
258      * @param value The amount of tokens to be spent.
259      */
260     function approve(address spender, uint256 value) public returns (bool) {
261         _approve(msg.sender, spender, value);
262         return true;
263     }
264 
265     /**
266      * @dev Transfer tokens from one address to another.
267      * Note that while this function emits an Approval event, this is not required as per the specification,
268      * and other compliant implementations may not emit the event.
269      * @param from address The address which you want to send tokens from
270      * @param to address The address which you want to transfer to
271      * @param value uint256 the amount of tokens to be transferred
272      */
273     function transferFrom(address from, address to, uint256 value) public returns (bool) {
274         _transfer(from, to, value);
275         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
276         return true;
277     }
278 
279     /**
280      * @dev Increase the amount of tokens that an owner allowed to a spender.
281      * approve should be called when allowed_[_spender] == 0. To increment
282      * allowed value is better to use this function to avoid 2 calls (and wait until
283      * the first transaction is mined)
284      * From MonolithDAO Token.sol
285      * Emits an Approval event.
286      * @param spender The address which will spend the funds.
287      * @param addedValue The amount of tokens to increase the allowance by.
288      */
289     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
290         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
291         return true;
292     }
293 
294     /**
295      * @dev Decrease the amount of tokens that an owner allowed to a spender.
296      * approve should be called when allowed_[_spender] == 0. To decrement
297      * allowed value is better to use this function to avoid 2 calls (and wait until
298      * the first transaction is mined)
299      * From MonolithDAO Token.sol
300      * Emits an Approval event.
301      * @param spender The address which will spend the funds.
302      * @param subtractedValue The amount of tokens to decrease the allowance by.
303      */
304     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Transfer token for a specified addresses
311      * @param from The address to transfer from.
312      * @param to The address to transfer to.
313      * @param value The amount to be transferred.
314      */
315     function _transfer(address from, address to, uint256 value) internal {
316         require(to != address(0));
317 
318         _balances[from] = _balances[from].sub(value);
319         _balances[to] = _balances[to].add(value);
320         emit Transfer(from, to, value);
321     }
322 
323     /**
324      * @dev Internal function that mints an amount of the token and assigns it to
325      * an account. This encapsulates the modification of balances such that the
326      * proper events are emitted.
327      * @param account The account that will receive the created tokens.
328      * @param value The amount that will be created.
329      */
330     function _mint(address account, uint256 value) internal {
331         require(account != address(0));
332 
333         _totalSupply = _totalSupply.add(value);
334         _balances[account] = _balances[account].add(value);
335         emit Transfer(address(0), account, value);
336     }
337 
338     /**
339      * @dev Internal function that burns an amount of the token of a given
340      * account.
341      * @param account The account whose tokens will be burnt.
342      * @param value The amount that will be burnt.
343      */
344     function _burn(address account, uint256 value) internal {
345         require(account != address(0));
346 
347         _totalSupply = _totalSupply.sub(value);
348         _balances[account] = _balances[account].sub(value);
349         emit Transfer(account, address(0), value);
350     }
351 
352     /**
353      * @dev Approve an address to spend another addresses' tokens.
354      * @param owner The address that owns the tokens.
355      * @param spender The address that will spend the tokens.
356      * @param value The number of tokens that can be spent.
357      */
358     function _approve(address owner, address spender, uint256 value) internal {
359         require(spender != address(0));
360         require(owner != address(0));
361 
362         _allowed[owner][spender] = value;
363         emit Approval(owner, spender, value);
364     }
365 
366     /**
367      * @dev Internal function that burns an amount of the token of a given
368      * account, deducting from the sender's allowance for said account. Uses the
369      * internal burn function.
370      * Emits an Approval event (reflecting the reduced allowance).
371      * @param account The account whose tokens will be burnt.
372      * @param value The amount that will be burnt.
373      */
374     function _burnFrom(address account, uint256 value) internal {
375         _burn(account, value);
376         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
377     }
378 }
379 
380 contract OraclizeI {
381 
382     address public cbAddress;
383 
384     function setProofType(byte _proofType) external;
385     function setCustomGasPrice(uint _gasPrice) external;
386     function getPrice(string memory _datasource) public returns (uint _dsprice);
387     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
388     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
389     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
390     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
391     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
392     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
393     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
394     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
395 }
396 
397 contract usingOraclize {
398 
399     using CBOR for Buffer.buffer;
400 
401     OraclizeI oraclize;
402     OraclizeAddrResolverI OAR;
403 
404     uint constant day = 60 * 60 * 24;
405     uint constant week = 60 * 60 * 24 * 7;
406     uint constant month = 60 * 60 * 24 * 30;
407 
408     byte constant proofType_NONE = 0x00;
409     byte constant proofType_Ledger = 0x30;
410     byte constant proofType_Native = 0xF0;
411     byte constant proofStorage_IPFS = 0x01;
412     byte constant proofType_Android = 0x40;
413     byte constant proofType_TLSNotary = 0x10;
414 
415     string oraclize_network_name;
416     uint8 constant networkID_auto = 0;
417     uint8 constant networkID_morden = 2;
418     uint8 constant networkID_mainnet = 1;
419     uint8 constant networkID_testnet = 2;
420     uint8 constant networkID_consensys = 161;
421 
422     mapping(bytes32 => bytes32) oraclize_randomDS_args;
423     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
424 
425     modifier oraclizeAPI {
426         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
427             oraclize_setNetwork(networkID_auto);
428         }
429         if (address(oraclize) != OAR.getAddress()) {
430             oraclize = OraclizeI(OAR.getAddress());
431         }
432         _;
433     }
434 
435     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
436       return oraclize_setNetwork();
437       _networkID; // silence the warning and remain backwards compatible
438     }
439 
440     function oraclize_setNetworkName(string memory _network_name) internal {
441         oraclize_network_name = _network_name;
442     }
443 
444     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
445         return oraclize_network_name;
446     }
447 
448     function oraclize_setNetwork() internal returns (bool _networkSet) {
449         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
450             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
451             oraclize_setNetworkName("eth_mainnet");
452             return true;
453         }
454         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
455             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
456             oraclize_setNetworkName("eth_ropsten3");
457             return true;
458         }
459         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
460             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
461             oraclize_setNetworkName("eth_kovan");
462             return true;
463         }
464         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
465             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
466             oraclize_setNetworkName("eth_rinkeby");
467             return true;
468         }
469         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
470             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
471             return true;
472         }
473         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
474             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
475             return true;
476         }
477         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
478             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
479             return true;
480         }
481         return false;
482     }
483 
484     function __callback(bytes32 _myid, string memory _result) public {
485         __callback(_myid, _result, new bytes(0));
486     }
487 
488     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) public {
489       return;
490       _myid; _result; _proof; // Silence compiler warnings
491     }
492 
493     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
494         return oraclize.getPrice(_datasource);
495     }
496 
497     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
498         return oraclize.getPrice(_datasource, _gasLimit);
499     }
500 
501     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
502         uint price = oraclize.getPrice(_datasource);
503         if (price > 1 ether + tx.gasprice * 200000) {
504             return 0; // Unexpectedly high price
505         }
506         return oraclize.query.value(price)(0, _datasource, _arg);
507     }
508 
509     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
510         uint price = oraclize.getPrice(_datasource);
511         if (price > 1 ether + tx.gasprice * 200000) {
512             return 0; // Unexpectedly high price
513         }
514         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
515     }
516 
517     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
518         uint price = oraclize.getPrice(_datasource,_gasLimit);
519         if (price > 1 ether + tx.gasprice * _gasLimit) {
520             return 0; // Unexpectedly high price
521         }
522         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
523     }
524 
525     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
526         uint price = oraclize.getPrice(_datasource, _gasLimit);
527         if (price > 1 ether + tx.gasprice * _gasLimit) {
528            return 0; // Unexpectedly high price
529         }
530         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
531     }
532 
533     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
534         uint price = oraclize.getPrice(_datasource);
535         if (price > 1 ether + tx.gasprice * 200000) {
536             return 0; // Unexpectedly high price
537         }
538         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
539     }
540 
541     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
542         uint price = oraclize.getPrice(_datasource);
543         if (price > 1 ether + tx.gasprice * 200000) {
544             return 0; // Unexpectedly high price
545         }
546         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
547     }
548 
549     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
550         uint price = oraclize.getPrice(_datasource, _gasLimit);
551         if (price > 1 ether + tx.gasprice * _gasLimit) {
552             return 0; // Unexpectedly high price
553         }
554         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
555     }
556 
557     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
558         uint price = oraclize.getPrice(_datasource, _gasLimit);
559         if (price > 1 ether + tx.gasprice * _gasLimit) {
560             return 0; // Unexpectedly high price
561         }
562         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
563     }
564 
565     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
566         uint price = oraclize.getPrice(_datasource);
567         if (price > 1 ether + tx.gasprice * 200000) {
568             return 0; // Unexpectedly high price
569         }
570         bytes memory args = stra2cbor(_argN);
571         return oraclize.queryN.value(price)(0, _datasource, args);
572     }
573 
574     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
575         uint price = oraclize.getPrice(_datasource);
576         if (price > 1 ether + tx.gasprice * 200000) {
577             return 0; // Unexpectedly high price
578         }
579         bytes memory args = stra2cbor(_argN);
580         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
581     }
582 
583     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
584         uint price = oraclize.getPrice(_datasource, _gasLimit);
585         if (price > 1 ether + tx.gasprice * _gasLimit) {
586             return 0; // Unexpectedly high price
587         }
588         bytes memory args = stra2cbor(_argN);
589         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
590     }
591 
592     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
593         uint price = oraclize.getPrice(_datasource, _gasLimit);
594         if (price > 1 ether + tx.gasprice * _gasLimit) {
595             return 0; // Unexpectedly high price
596         }
597         bytes memory args = stra2cbor(_argN);
598         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
599     }
600 
601     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
602         string[] memory dynargs = new string[](1);
603         dynargs[0] = _args[0];
604         return oraclize_query(_datasource, dynargs);
605     }
606 
607     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
608         string[] memory dynargs = new string[](1);
609         dynargs[0] = _args[0];
610         return oraclize_query(_timestamp, _datasource, dynargs);
611     }
612 
613     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
614         string[] memory dynargs = new string[](1);
615         dynargs[0] = _args[0];
616         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
617     }
618 
619     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
620         string[] memory dynargs = new string[](1);
621         dynargs[0] = _args[0];
622         return oraclize_query(_datasource, dynargs, _gasLimit);
623     }
624 
625     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
626         string[] memory dynargs = new string[](2);
627         dynargs[0] = _args[0];
628         dynargs[1] = _args[1];
629         return oraclize_query(_datasource, dynargs);
630     }
631 
632     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
633         string[] memory dynargs = new string[](2);
634         dynargs[0] = _args[0];
635         dynargs[1] = _args[1];
636         return oraclize_query(_timestamp, _datasource, dynargs);
637     }
638 
639     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
640         string[] memory dynargs = new string[](2);
641         dynargs[0] = _args[0];
642         dynargs[1] = _args[1];
643         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
644     }
645 
646     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
647         string[] memory dynargs = new string[](2);
648         dynargs[0] = _args[0];
649         dynargs[1] = _args[1];
650         return oraclize_query(_datasource, dynargs, _gasLimit);
651     }
652 
653     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
654         string[] memory dynargs = new string[](3);
655         dynargs[0] = _args[0];
656         dynargs[1] = _args[1];
657         dynargs[2] = _args[2];
658         return oraclize_query(_datasource, dynargs);
659     }
660 
661     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
662         string[] memory dynargs = new string[](3);
663         dynargs[0] = _args[0];
664         dynargs[1] = _args[1];
665         dynargs[2] = _args[2];
666         return oraclize_query(_timestamp, _datasource, dynargs);
667     }
668 
669     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
670         string[] memory dynargs = new string[](3);
671         dynargs[0] = _args[0];
672         dynargs[1] = _args[1];
673         dynargs[2] = _args[2];
674         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
675     }
676 
677     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
678         string[] memory dynargs = new string[](3);
679         dynargs[0] = _args[0];
680         dynargs[1] = _args[1];
681         dynargs[2] = _args[2];
682         return oraclize_query(_datasource, dynargs, _gasLimit);
683     }
684 
685     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
686         string[] memory dynargs = new string[](4);
687         dynargs[0] = _args[0];
688         dynargs[1] = _args[1];
689         dynargs[2] = _args[2];
690         dynargs[3] = _args[3];
691         return oraclize_query(_datasource, dynargs);
692     }
693 
694     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
695         string[] memory dynargs = new string[](4);
696         dynargs[0] = _args[0];
697         dynargs[1] = _args[1];
698         dynargs[2] = _args[2];
699         dynargs[3] = _args[3];
700         return oraclize_query(_timestamp, _datasource, dynargs);
701     }
702 
703     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
704         string[] memory dynargs = new string[](4);
705         dynargs[0] = _args[0];
706         dynargs[1] = _args[1];
707         dynargs[2] = _args[2];
708         dynargs[3] = _args[3];
709         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
710     }
711 
712     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
713         string[] memory dynargs = new string[](4);
714         dynargs[0] = _args[0];
715         dynargs[1] = _args[1];
716         dynargs[2] = _args[2];
717         dynargs[3] = _args[3];
718         return oraclize_query(_datasource, dynargs, _gasLimit);
719     }
720 
721     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
722         string[] memory dynargs = new string[](5);
723         dynargs[0] = _args[0];
724         dynargs[1] = _args[1];
725         dynargs[2] = _args[2];
726         dynargs[3] = _args[3];
727         dynargs[4] = _args[4];
728         return oraclize_query(_datasource, dynargs);
729     }
730 
731     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
732         string[] memory dynargs = new string[](5);
733         dynargs[0] = _args[0];
734         dynargs[1] = _args[1];
735         dynargs[2] = _args[2];
736         dynargs[3] = _args[3];
737         dynargs[4] = _args[4];
738         return oraclize_query(_timestamp, _datasource, dynargs);
739     }
740 
741     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
742         string[] memory dynargs = new string[](5);
743         dynargs[0] = _args[0];
744         dynargs[1] = _args[1];
745         dynargs[2] = _args[2];
746         dynargs[3] = _args[3];
747         dynargs[4] = _args[4];
748         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
749     }
750 
751     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
752         string[] memory dynargs = new string[](5);
753         dynargs[0] = _args[0];
754         dynargs[1] = _args[1];
755         dynargs[2] = _args[2];
756         dynargs[3] = _args[3];
757         dynargs[4] = _args[4];
758         return oraclize_query(_datasource, dynargs, _gasLimit);
759     }
760 
761     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
762         uint price = oraclize.getPrice(_datasource);
763         if (price > 1 ether + tx.gasprice * 200000) {
764             return 0; // Unexpectedly high price
765         }
766         bytes memory args = ba2cbor(_argN);
767         return oraclize.queryN.value(price)(0, _datasource, args);
768     }
769 
770     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
771         uint price = oraclize.getPrice(_datasource);
772         if (price > 1 ether + tx.gasprice * 200000) {
773             return 0; // Unexpectedly high price
774         }
775         bytes memory args = ba2cbor(_argN);
776         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
777     }
778 
779     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
780         uint price = oraclize.getPrice(_datasource, _gasLimit);
781         if (price > 1 ether + tx.gasprice * _gasLimit) {
782             return 0; // Unexpectedly high price
783         }
784         bytes memory args = ba2cbor(_argN);
785         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
786     }
787 
788     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
789         uint price = oraclize.getPrice(_datasource, _gasLimit);
790         if (price > 1 ether + tx.gasprice * _gasLimit) {
791             return 0; // Unexpectedly high price
792         }
793         bytes memory args = ba2cbor(_argN);
794         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
795     }
796 
797     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
798         bytes[] memory dynargs = new bytes[](1);
799         dynargs[0] = _args[0];
800         return oraclize_query(_datasource, dynargs);
801     }
802 
803     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
804         bytes[] memory dynargs = new bytes[](1);
805         dynargs[0] = _args[0];
806         return oraclize_query(_timestamp, _datasource, dynargs);
807     }
808 
809     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
810         bytes[] memory dynargs = new bytes[](1);
811         dynargs[0] = _args[0];
812         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
813     }
814 
815     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
816         bytes[] memory dynargs = new bytes[](1);
817         dynargs[0] = _args[0];
818         return oraclize_query(_datasource, dynargs, _gasLimit);
819     }
820 
821     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
822         bytes[] memory dynargs = new bytes[](2);
823         dynargs[0] = _args[0];
824         dynargs[1] = _args[1];
825         return oraclize_query(_datasource, dynargs);
826     }
827 
828     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
829         bytes[] memory dynargs = new bytes[](2);
830         dynargs[0] = _args[0];
831         dynargs[1] = _args[1];
832         return oraclize_query(_timestamp, _datasource, dynargs);
833     }
834 
835     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
836         bytes[] memory dynargs = new bytes[](2);
837         dynargs[0] = _args[0];
838         dynargs[1] = _args[1];
839         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
840     }
841 
842     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
843         bytes[] memory dynargs = new bytes[](2);
844         dynargs[0] = _args[0];
845         dynargs[1] = _args[1];
846         return oraclize_query(_datasource, dynargs, _gasLimit);
847     }
848 
849     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
850         bytes[] memory dynargs = new bytes[](3);
851         dynargs[0] = _args[0];
852         dynargs[1] = _args[1];
853         dynargs[2] = _args[2];
854         return oraclize_query(_datasource, dynargs);
855     }
856 
857     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
858         bytes[] memory dynargs = new bytes[](3);
859         dynargs[0] = _args[0];
860         dynargs[1] = _args[1];
861         dynargs[2] = _args[2];
862         return oraclize_query(_timestamp, _datasource, dynargs);
863     }
864 
865     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
866         bytes[] memory dynargs = new bytes[](3);
867         dynargs[0] = _args[0];
868         dynargs[1] = _args[1];
869         dynargs[2] = _args[2];
870         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
871     }
872 
873     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
874         bytes[] memory dynargs = new bytes[](3);
875         dynargs[0] = _args[0];
876         dynargs[1] = _args[1];
877         dynargs[2] = _args[2];
878         return oraclize_query(_datasource, dynargs, _gasLimit);
879     }
880 
881     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
882         bytes[] memory dynargs = new bytes[](4);
883         dynargs[0] = _args[0];
884         dynargs[1] = _args[1];
885         dynargs[2] = _args[2];
886         dynargs[3] = _args[3];
887         return oraclize_query(_datasource, dynargs);
888     }
889 
890     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
891         bytes[] memory dynargs = new bytes[](4);
892         dynargs[0] = _args[0];
893         dynargs[1] = _args[1];
894         dynargs[2] = _args[2];
895         dynargs[3] = _args[3];
896         return oraclize_query(_timestamp, _datasource, dynargs);
897     }
898 
899     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
900         bytes[] memory dynargs = new bytes[](4);
901         dynargs[0] = _args[0];
902         dynargs[1] = _args[1];
903         dynargs[2] = _args[2];
904         dynargs[3] = _args[3];
905         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
906     }
907 
908     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
909         bytes[] memory dynargs = new bytes[](4);
910         dynargs[0] = _args[0];
911         dynargs[1] = _args[1];
912         dynargs[2] = _args[2];
913         dynargs[3] = _args[3];
914         return oraclize_query(_datasource, dynargs, _gasLimit);
915     }
916 
917     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
918         bytes[] memory dynargs = new bytes[](5);
919         dynargs[0] = _args[0];
920         dynargs[1] = _args[1];
921         dynargs[2] = _args[2];
922         dynargs[3] = _args[3];
923         dynargs[4] = _args[4];
924         return oraclize_query(_datasource, dynargs);
925     }
926 
927     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
928         bytes[] memory dynargs = new bytes[](5);
929         dynargs[0] = _args[0];
930         dynargs[1] = _args[1];
931         dynargs[2] = _args[2];
932         dynargs[3] = _args[3];
933         dynargs[4] = _args[4];
934         return oraclize_query(_timestamp, _datasource, dynargs);
935     }
936 
937     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
938         bytes[] memory dynargs = new bytes[](5);
939         dynargs[0] = _args[0];
940         dynargs[1] = _args[1];
941         dynargs[2] = _args[2];
942         dynargs[3] = _args[3];
943         dynargs[4] = _args[4];
944         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
945     }
946 
947     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
948         bytes[] memory dynargs = new bytes[](5);
949         dynargs[0] = _args[0];
950         dynargs[1] = _args[1];
951         dynargs[2] = _args[2];
952         dynargs[3] = _args[3];
953         dynargs[4] = _args[4];
954         return oraclize_query(_datasource, dynargs, _gasLimit);
955     }
956 
957     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
958         return oraclize.setProofType(_proofP);
959     }
960 
961 
962     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
963         return oraclize.cbAddress();
964     }
965 
966     function getCodeSize(address _addr) view internal returns (uint _size) {
967         assembly {
968             _size := extcodesize(_addr)
969         }
970     }
971 
972     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
973         return oraclize.setCustomGasPrice(_gasPrice);
974     }
975 
976     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
977         return oraclize.randomDS_getSessionPubKeyHash();
978     }
979 
980     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
981         bytes memory tmp = bytes(_a);
982         uint160 iaddr = 0;
983         uint160 b1;
984         uint160 b2;
985         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
986             iaddr *= 256;
987             b1 = uint160(uint8(tmp[i]));
988             b2 = uint160(uint8(tmp[i + 1]));
989             if ((b1 >= 97) && (b1 <= 102)) {
990                 b1 -= 87;
991             } else if ((b1 >= 65) && (b1 <= 70)) {
992                 b1 -= 55;
993             } else if ((b1 >= 48) && (b1 <= 57)) {
994                 b1 -= 48;
995             }
996             if ((b2 >= 97) && (b2 <= 102)) {
997                 b2 -= 87;
998             } else if ((b2 >= 65) && (b2 <= 70)) {
999                 b2 -= 55;
1000             } else if ((b2 >= 48) && (b2 <= 57)) {
1001                 b2 -= 48;
1002             }
1003             iaddr += (b1 * 16 + b2);
1004         }
1005         return address(iaddr);
1006     }
1007 
1008     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
1009         bytes memory a = bytes(_a);
1010         bytes memory b = bytes(_b);
1011         uint minLength = a.length;
1012         if (b.length < minLength) {
1013             minLength = b.length;
1014         }
1015         for (uint i = 0; i < minLength; i ++) {
1016             if (a[i] < b[i]) {
1017                 return -1;
1018             } else if (a[i] > b[i]) {
1019                 return 1;
1020             }
1021         }
1022         if (a.length < b.length) {
1023             return -1;
1024         } else if (a.length > b.length) {
1025             return 1;
1026         } else {
1027             return 0;
1028         }
1029     }
1030 
1031     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1032         bytes memory h = bytes(_haystack);
1033         bytes memory n = bytes(_needle);
1034         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1035             return -1;
1036         } else if (h.length > (2 ** 128 - 1)) {
1037             return -1;
1038         } else {
1039             uint subindex = 0;
1040             for (uint i = 0; i < h.length; i++) {
1041                 if (h[i] == n[0]) {
1042                     subindex = 1;
1043                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1044                         subindex++;
1045                     }
1046                     if (subindex == n.length) {
1047                         return int(i);
1048                     }
1049                 }
1050             }
1051             return -1;
1052         }
1053     }
1054 
1055     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
1056         return strConcat(_a, _b, "", "", "");
1057     }
1058 
1059     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
1060         return strConcat(_a, _b, _c, "", "");
1061     }
1062 
1063     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
1064         return strConcat(_a, _b, _c, _d, "");
1065     }
1066 
1067     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1068         bytes memory _ba = bytes(_a);
1069         bytes memory _bb = bytes(_b);
1070         bytes memory _bc = bytes(_c);
1071         bytes memory _bd = bytes(_d);
1072         bytes memory _be = bytes(_e);
1073         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1074         bytes memory babcde = bytes(abcde);
1075         uint k = 0;
1076         uint i = 0;
1077         for (i = 0; i < _ba.length; i++) {
1078             babcde[k++] = _ba[i];
1079         }
1080         for (i = 0; i < _bb.length; i++) {
1081             babcde[k++] = _bb[i];
1082         }
1083         for (i = 0; i < _bc.length; i++) {
1084             babcde[k++] = _bc[i];
1085         }
1086         for (i = 0; i < _bd.length; i++) {
1087             babcde[k++] = _bd[i];
1088         }
1089         for (i = 0; i < _be.length; i++) {
1090             babcde[k++] = _be[i];
1091         }
1092         return string(babcde);
1093     }
1094 
1095     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1096         return safeParseInt(_a, 0);
1097     }
1098 
1099     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1100         bytes memory bresult = bytes(_a);
1101         uint mint = 0;
1102         bool decimals = false;
1103         for (uint i = 0; i < bresult.length; i++) {
1104             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1105                 if (decimals) {
1106                    if (_b == 0) break;
1107                     else _b--;
1108                 }
1109                 mint *= 10;
1110                 mint += uint(uint8(bresult[i])) - 48;
1111             } else if (uint(uint8(bresult[i])) == 46) {
1112                 require(!decimals, 'More than one decimal encountered in string!');
1113                 decimals = true;
1114             } else {
1115                 revert("Non-numeral character encountered in string!");
1116             }
1117         }
1118         if (_b > 0) {
1119             mint *= 10 ** _b;
1120         }
1121         return mint;
1122     }
1123 
1124     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1125         return parseInt(_a, 0);
1126     }
1127 
1128     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1129         bytes memory bresult = bytes(_a);
1130         uint mint = 0;
1131         bool decimals = false;
1132         for (uint i = 0; i < bresult.length; i++) {
1133             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1134                 if (decimals) {
1135                    if (_b == 0) {
1136                        break;
1137                    } else {
1138                        _b--;
1139                    }
1140                 }
1141                 mint *= 10;
1142                 mint += uint(uint8(bresult[i])) - 48;
1143             } else if (uint(uint8(bresult[i])) == 46) {
1144                 decimals = true;
1145             }
1146         }
1147         if (_b > 0) {
1148             mint *= 10 ** _b;
1149         }
1150         return mint;
1151     }
1152 
1153     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1154         if (_i == 0) {
1155             return "0";
1156         }
1157         uint j = _i;
1158         uint len;
1159         while (j != 0) {
1160             len++;
1161             j /= 10;
1162         }
1163         bytes memory bstr = new bytes(len);
1164         uint k = len - 1;
1165         while (_i != 0) {
1166             bstr[k--] = byte(uint8(48 + _i % 10));
1167             _i /= 10;
1168         }
1169         return string(bstr);
1170     }
1171 
1172     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1173         safeMemoryCleaner();
1174         Buffer.buffer memory buf;
1175         Buffer.init(buf, 1024);
1176         buf.startArray();
1177         for (uint i = 0; i < _arr.length; i++) {
1178             buf.encodeString(_arr[i]);
1179         }
1180         buf.endSequence();
1181         return buf.buf;
1182     }
1183 
1184     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1185         safeMemoryCleaner();
1186         Buffer.buffer memory buf;
1187         Buffer.init(buf, 1024);
1188         buf.startArray();
1189         for (uint i = 0; i < _arr.length; i++) {
1190             buf.encodeBytes(_arr[i]);
1191         }
1192         buf.endSequence();
1193         return buf.buf;
1194     }
1195 
1196     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1197         require((_nbytes > 0) && (_nbytes <= 32));
1198         _delay *= 10; // Convert from seconds to ledger timer ticks
1199         bytes memory nbytes = new bytes(1);
1200         nbytes[0] = byte(uint8(_nbytes));
1201         bytes memory unonce = new bytes(32);
1202         bytes memory sessionKeyHash = new bytes(32);
1203         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1204         assembly {
1205             mstore(unonce, 0x20)
1206             /*
1207              The following variables can be relaxed.
1208              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1209              for an idea on how to override and replace commit hash variables.
1210             */
1211             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1212             mstore(sessionKeyHash, 0x20)
1213             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1214         }
1215         bytes memory delay = new bytes(32);
1216         assembly {
1217             mstore(add(delay, 0x20), _delay)
1218         }
1219         bytes memory delay_bytes8 = new bytes(8);
1220         copyBytes(delay, 24, 8, delay_bytes8, 0);
1221         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1222         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1223         bytes memory delay_bytes8_left = new bytes(8);
1224         assembly {
1225             let x := mload(add(delay_bytes8, 0x20))
1226             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1227             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1228             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1229             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1230             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1231             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1232             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1233             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1234         }
1235         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1236         return queryId;
1237     }
1238 
1239     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1240         oraclize_randomDS_args[_queryId] = _commitment;
1241     }
1242 
1243     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1244         bool sigok;
1245         address signer;
1246         bytes32 sigr;
1247         bytes32 sigs;
1248         bytes memory sigr_ = new bytes(32);
1249         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1250         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1251         bytes memory sigs_ = new bytes(32);
1252         offset += 32 + 2;
1253         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1254         assembly {
1255             sigr := mload(add(sigr_, 32))
1256             sigs := mload(add(sigs_, 32))
1257         }
1258         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1259         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1260             return true;
1261         } else {
1262             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1263             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1264         }
1265     }
1266 
1267     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1268         bool match_ = true;
1269         require(_prefix.length == _nRandomBytes);
1270         for (uint256 i = 0; i< _nRandomBytes; i++) {
1271             if (_content[i] != _prefix[i]) {
1272                 match_ = false;
1273             }
1274         }
1275         return match_;
1276     }
1277 
1278     /*
1279      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1280     */
1281     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1282         uint minLength = _length + _toOffset;
1283         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1284         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1285         uint j = 32 + _toOffset;
1286         while (i < (32 + _fromOffset + _length)) {
1287             assembly {
1288                 let tmp := mload(add(_from, i))
1289                 mstore(add(_to, j), tmp)
1290             }
1291             i += 32;
1292             j += 32;
1293         }
1294         return _to;
1295     }
1296     /*
1297      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1298      Duplicate Solidity's ecrecover, but catching the CALL return value
1299     */
1300     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1301         /*
1302          We do our own memory management here. Solidity uses memory offset
1303          0x40 to store the current end of memory. We write past it (as
1304          writes are memory extensions), but don't update the offset so
1305          Solidity will reuse it. The memory used here is only needed for
1306          this context.
1307          FIXME: inline assembly can't access return values
1308         */
1309         bool ret;
1310         address addr;
1311         assembly {
1312             let size := mload(0x40)
1313             mstore(size, _hash)
1314             mstore(add(size, 32), _v)
1315             mstore(add(size, 64), _r)
1316             mstore(add(size, 96), _s)
1317             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1318             addr := mload(size)
1319         }
1320         return (ret, addr);
1321     }
1322     /*
1323      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1324     */
1325     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1326         bytes32 r;
1327         bytes32 s;
1328         uint8 v;
1329         if (_sig.length != 65) {
1330             return (false, address(0));
1331         }
1332         /*
1333          The signature format is a compact form of:
1334            {bytes32 r}{bytes32 s}{uint8 v}
1335          Compact means, uint8 is not padded to 32 bytes.
1336         */
1337         assembly {
1338             r := mload(add(_sig, 32))
1339             s := mload(add(_sig, 64))
1340             /*
1341              Here we are loading the last 32 bytes. We exploit the fact that
1342              'mload' will pad with zeroes if we overread.
1343              There is no 'mload8' to do this, but that would be nicer.
1344             */
1345             v := byte(0, mload(add(_sig, 96)))
1346             /*
1347               Alternative solution:
1348               'byte' is not working due to the Solidity parser, so lets
1349               use the second best option, 'and'
1350               v := and(mload(add(_sig, 65)), 255)
1351             */
1352         }
1353         /*
1354          albeit non-transactional signatures are not specified by the YP, one would expect it
1355          to match the YP range of [27, 28]
1356          geth uses [0, 1] and some clients have followed. This might change, see:
1357          https://github.com/ethereum/go-ethereum/issues/2053
1358         */
1359         if (v < 27) {
1360             v += 27;
1361         }
1362         if (v != 27 && v != 28) {
1363             return (false, address(0));
1364         }
1365         return safer_ecrecover(_hash, v, r, s);
1366     }
1367 
1368     function safeMemoryCleaner() internal pure {
1369         assembly {
1370             let fmem := mload(0x40)
1371             codecopy(fmem, codesize, sub(msize, fmem))
1372         }
1373     }
1374 }
1375 
1376 contract Ownable {
1377     address private _owner;
1378 
1379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1380 
1381     /**
1382      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1383      * account.
1384      */
1385     constructor () internal {
1386         _owner = msg.sender;
1387         emit OwnershipTransferred(address(0), _owner);
1388     }
1389 
1390     /**
1391      * @return the address of the owner.
1392      */
1393     function owner() public view returns (address) {
1394         return _owner;
1395     }
1396 
1397     /**
1398      * @dev Throws if called by any account other than the owner.
1399      */
1400     modifier onlyOwner() {
1401         require(isOwner());
1402         _;
1403     }
1404 
1405     /**
1406      * @return true if `msg.sender` is the owner of the contract.
1407      */
1408     function isOwner() public view returns (bool) {
1409         return msg.sender == _owner;
1410     }
1411 
1412     /**
1413      * @dev Allows the current owner to relinquish control of the contract.
1414      * @notice Renouncing to ownership will leave the contract without an owner.
1415      * It will not be possible to call the functions with the `onlyOwner`
1416      * modifier anymore.
1417      */
1418     function renounceOwnership() public onlyOwner {
1419         emit OwnershipTransferred(_owner, address(0));
1420         _owner = address(0);
1421     }
1422 
1423     /**
1424      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1425      * @param newOwner The address to transfer ownership to.
1426      */
1427     function transferOwnership(address newOwner) public onlyOwner {
1428         _transferOwnership(newOwner);
1429     }
1430 
1431     /**
1432      * @dev Transfers control of the contract to a newOwner.
1433      * @param newOwner The address to transfer ownership to.
1434      */
1435     function _transferOwnership(address newOwner) internal {
1436         require(newOwner != address(0));
1437         emit OwnershipTransferred(_owner, newOwner);
1438         _owner = newOwner;
1439     }
1440 }
1441 
1442 library SafeMath {
1443     /**
1444      * @dev Multiplies two unsigned integers, reverts on overflow.
1445      */
1446     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1447         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1448         // benefit is lost if 'b' is also tested.
1449         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1450         if (a == 0) {
1451             return 0;
1452         }
1453 
1454         uint256 c = a * b;
1455         require(c / a == b);
1456 
1457         return c;
1458     }
1459 
1460     /**
1461      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1462      */
1463     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1464         // Solidity only automatically asserts when dividing by 0
1465         require(b > 0);
1466         uint256 c = a / b;
1467         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1468 
1469         return c;
1470     }
1471 
1472     /**
1473      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1474      */
1475     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1476         require(b <= a);
1477         uint256 c = a - b;
1478 
1479         return c;
1480     }
1481 
1482     /**
1483      * @dev Adds two unsigned integers, reverts on overflow.
1484      */
1485     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1486         uint256 c = a + b;
1487         require(c >= a);
1488 
1489         return c;
1490     }
1491 
1492     /**
1493      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1494      * reverts when dividing by zero.
1495      */
1496     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1497         require(b != 0);
1498         return a % b;
1499     }
1500 }
1501 
1502 contract EasyToken is ERC20, Ownable, usingOraclize {
1503 	using SafeMath for uint256;
1504 
1505     mapping(address => bool) approvedAccounts;
1506 
1507     address admin1;
1508     address admin2;
1509 
1510     address public accountPubICOSale;
1511     uint8 public decimals;
1512 	string public name;
1513 	string public symbol;
1514 	
1515 	uint pubICOStartsAt = 0; 
1516 
1517     modifier onlyKycTeam {
1518         require(msg.sender == admin1 || msg.sender == admin2);
1519         _;
1520     }
1521 	
1522 	modifier PubICOstarted {
1523 		require(now >= pubICOStartsAt && pubICOStartsAt!=0 );
1524 		_;
1525 	}
1526 
1527     /**
1528      * @dev Create new EAX token contract.
1529      *
1530      * @param _accountFounder The account for the found tokens that receives 1,024,000,000 tokens on creation.
1531      * @param _accountPrivPreSale The account for the private pre-sale tokens that receives 1,326,000,000 tokens on creation.
1532      * @param _accountPubPreSale The account for the public pre-sale tokens that receives 1,500,000,000 tokens on creation.
1533      * @param _accountPubICOSale The account for the public pre-sale tokens that receives 4,150,000,000 tokens on creation.
1534 	 * @param _accountSalesMgmt The account for the Sales Management tokens that receives 2,000,000,000 tokens on creation.
1535      * @param _accountEasyWorld The account for the EAX World tokens that receives 2,000.000,000 tokens on creation.
1536      */
1537     constructor (
1538         address _admin1,
1539         address _admin2,
1540 		address _accountFounder,
1541 		address _accountPrivPreSale,
1542 		address _accountPubPreSale,
1543         address _accountPubICOSale,
1544 		address _accountSalesMgmt,
1545 		address _accountEasyWorld
1546 		)
1547     public 
1548     payable
1549     {
1550         admin1 = _admin1;
1551         admin2 = _admin2;
1552         accountPubICOSale = _accountPubICOSale;
1553         decimals = 18; // 10**decimals=1000000000000000000
1554 		
1555 		_mint(_accountFounder, 1024000000000000000000000000); // 1024000000 * 10**(decimals);
1556         _mint(_accountPrivPreSale, 1326000000000000000000000000); // 1326000000 * 10**(decimals);
1557         _mint(_accountPubPreSale, 1500000000000000000000000000); // 1500000000 * 10**(decimals);
1558 		_mint(_accountPubICOSale, 4150000000000000000000000000); // 4150000000 * 10**(decimals);
1559         _mint(_accountSalesMgmt, 2000000000000000000000000000); // 2000000000 * 10**(decimals);
1560         _mint(_accountEasyWorld, 2000000000000000000000000000); // 2000000000 * 10**(decimals);
1561 		
1562 		name = "easy.world"; // easy
1563 		symbol = "EAX"; // EAX
1564     }
1565 
1566 	function setIcoStartDate(uint startDate) public // e.g. 1541030400 for 1.11.2018 
1567 	onlyKycTeam
1568 	{
1569 		require( pubICOStartsAt==0 ); // date not yet set
1570 		pubICOStartsAt = startDate;
1571 	}
1572 	
1573 	
1574 	// Buying mechanics
1575 	mapping(uint256 => uint256) buyQueueValue;
1576 	mapping(uint256 => address payable) buyQueueSender;
1577 	uint256 buyLast  = 0;
1578 	uint256 last_rate_update = 0;
1579 	bool queryRunning = false;
1580 	
1581     /** 
1582      * @dev During the public ICO users can buy EAX tokens by sending ETH to this method.
1583      *
1584      * @dev The buyer will receive his tokens after successful KYC approval by the EAX team. In case KYC is refused,
1585      * @dev the send ETH funds are send back to the buyer and no EAX tokens will be delivered.
1586      */
1587     function buyToken()
1588     payable
1589     external
1590 	PubICOstarted
1591     {
1592 		require( approvedAccounts[msg.sender] ); // only verified users can take part in the ICO
1593 		
1594 		buyLast += 1;
1595 		buyQueueValue[buyLast] = msg.value;
1596 		buyQueueSender[buyLast] = msg.sender;
1597 		
1598 		// Exchange rate is up to date
1599 		if( now < last_rate_update + 60*10 ) {
1600 			executeBuyQueue();
1601 			return;
1602 		}
1603 		if( !queryRunning ) { // Need to update exchange rate first
1604 			queryRunning = true;
1605 			oraclize_query(60, "URL", "json(https://api.pro.coinbase.com/products/ETH-EUR/ticker).price");
1606 		}
1607     }
1608 	
1609 	function executeBuyQueue() private {
1610 		if( buyLast < 1 || balanceOf(accountPubICOSale)==0 ) {
1611 			return;
1612 		}
1613 		
1614 		uint256 bValue;
1615 		address buyer;
1616 		uint256 numToken;
1617 			
1618 		for(uint256 i=1; i<=buyLast; i++ ) {
1619 			bValue = buyQueueValue[i];
1620 			buyer = buyQueueSender[i];
1621 			
1622 			numToken = bValue.mul(ethEaxRate); // 1 = mul 10**decimals divide by wei/eth 1000000000000000000
1623 			
1624 			if( balanceOf(accountPubICOSale) < numToken ) {
1625 				buyQueueValue[i] = bValue - (balanceOf(accountPubICOSale) / ethEaxRate); 
1626 				// rounding works to the benefit of the customer
1627 				
1628 				_transfer(accountPubICOSale, buyer, balanceOf(accountPubICOSale));
1629 				return;
1630 			}
1631 			_transfer(accountPubICOSale, buyer, numToken);
1632 				
1633 			delete buyQueueValue[i];
1634 			delete buyQueueSender[i];
1635 		}
1636 		
1637 		buyLast  = 0;
1638 	}
1639 	
1640 	uint256 public kycBonus = 100;
1641 	function setKycBonus(uint256 bonus) public
1642 	onlyKycTeam
1643 	{
1644 		kycBonus = bonus;
1645 	}
1646 	
1647 	
1648 	uint256 public ethEaxRate = 0;
1649 	event EthRateUpdate(string param, uint256 value);
1650 	// oraclize callback
1651 	function __callback(bytes32 myid, string memory result) public
1652 	{
1653         require(msg.sender == oraclize_cbAddress());
1654 		
1655         // Calculating rate
1656 		ethEaxRate = parseInt(result) * 1000;
1657 		int dot = indexOf(result, ".");
1658 		if( dot == -1 ) { // dot not found. Bad query!
1659 			queryRunning = false;
1660 			return;
1661 		}
1662 		uint udot = uint(dot);
1663 		string memory cents = substring(result, udot+1, udot+4); // end is not included
1664 		ethEaxRate = (ethEaxRate + parseInt(cents)) / 3; // 0.003 Euro pro Token
1665 		emit EthRateUpdate(result, ethEaxRate);
1666 		
1667 		last_rate_update = now;
1668 		queryRunning = false;
1669 		executeBuyQueue(); 
1670     }
1671 	
1672 	function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
1673 		bytes memory strBytes = bytes(str);
1674 		bytes memory result = new bytes(endIndex-startIndex);
1675 		for(uint i = startIndex; i < endIndex; i++) {
1676 			result[i-startIndex] = strBytes[i];
1677 		}
1678 		return string(result);
1679 	}
1680 
1681     /**
1682      * @dev Approve KYC of a user, who contributed in ETH.
1683      * @dev Deliver the tokens to the user's account and move the ETH balance to the EAX contract.
1684      *
1685      * @param _user The account of the user to approve KYC.
1686      */
1687     function kycApprove(address _user)
1688     external
1689     onlyKycTeam
1690     {
1691         // account is approved
1692         approvedAccounts[_user] = true;
1693 		
1694 		// hand out bonus for running through KYC
1695 		if( balanceOf(accountPubICOSale) == 0 ) {
1696 			return; 
1697 		}
1698 		
1699 		uint256 numToken = kycBonus.mul(1000000000000000000); // mul 10**decimals
1700 		if( balanceOf(accountPubICOSale) < kycBonus ) {
1701 			numToken = balanceOf(accountPubICOSale);
1702 		}
1703 		_transfer(accountPubICOSale, _user, numToken);
1704 	}
1705 
1706     /**
1707      * @dev Retrieve ETH from the contract.
1708      *
1709      * @dev The contract owner can use this method to transfer received ETH to another wallet.
1710      *
1711      * @param _safe The address of the wallet the funds should get transferred to.
1712      * @param _value The amount of ETH to transfer.
1713      */
1714     function retrieveEth(address payable _safe, uint256 _value)
1715     external
1716     onlyOwner
1717     {
1718         _safe.transfer(_value);
1719     }
1720 	
1721 	function refundOversold() 
1722 	external
1723 	{
1724 		require( balanceOf(accountPubICOSale)==0 );
1725 		require( buyLast >= 1);
1726 		
1727 		uint256 bValue;
1728 		address payable buyer;
1729 		for( uint i=1; i<=buyLast; i++ ) {
1730 			bValue = buyQueueValue[i];
1731 			buyer = buyQueueSender[i];
1732 			
1733 			// return funds
1734 			buyer.transfer(bValue);
1735 			delete buyQueueValue[i];
1736 			delete buyQueueSender[i];
1737 		}
1738 		
1739 		buyLast  = 0;
1740 	}
1741 }
1742 
1743 contract OraclizeAddrResolverI {
1744     function getAddress() public returns (address _address);
1745 }
1746 
1747 contract solcChecker {
1748 /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol" */ function f(bytes calldata x) external;
1749 }