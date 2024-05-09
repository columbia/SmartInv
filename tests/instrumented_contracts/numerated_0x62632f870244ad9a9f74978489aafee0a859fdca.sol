1 pragma solidity ^0.5.7;
2 
3 
4 library SigUtils {
5     /**
6       @dev Recovers address who signed the message 
7       @param _hash operation ethereum signed message hash
8       @param _signature message `hash` signature  
9     */
10     function ecrecover2 (
11         bytes32 _hash, 
12         bytes memory _signature
13     ) internal pure returns (address) {
14         bytes32 r;
15         bytes32 s;
16         uint8 v;
17 
18         assembly {
19             r := mload(add(_signature, 32))
20             s := mload(add(_signature, 64))
21             v := and(mload(add(_signature, 65)), 255)
22         }
23 
24         if (v < 27) {
25             v += 27;
26         }
27 
28         return ecrecover(
29             _hash,
30             v,
31             r,
32             s
33         );
34     }
35 }
36 
37 // File: contracts/Marmo.sol
38 
39 pragma solidity ^0.5.7;
40 
41 
42 /*
43     Marmo wallet
44 
45     It has a signer, and it accepts signed messages ´Intents´ (Meta-Txs)
46     all messages are composed by an interpreter and a ´data´ field.
47 */
48 contract Marmo {
49     event Relayed(bytes32 indexed _id, address _implementation, bytes _data);
50     event Canceled(bytes32 indexed _id);
51 
52     // Random Invalid signer address
53     // Intents signed with this address are invalid
54     address private constant INVALID_ADDRESS = address(0x9431Bab00000000000000000000000039bD955c9);
55 
56     // Random slot to store signer
57     bytes32 private constant SIGNER_SLOT = keccak256("marmo.wallet.signer");
58 
59     // [1 bit (canceled) 95 bits (block) 160 bits (relayer)]
60     mapping(bytes32 => bytes32) private intentReceipt;
61 
62     function() external payable {}
63 
64     // Inits the wallet, any address can Init
65     // it should be called using another contract
66     function init(address _signer) external payable {
67         address signer;
68         bytes32 signerSlot = SIGNER_SLOT;
69         assembly { signer := sload(signerSlot) }
70         require(signer == address(0), "Signer already defined");
71         assembly { sstore(signerSlot, _signer) }
72     }
73 
74     // Signer of the Marmo wallet
75     // can perform transactions by signing Intents
76     function signer() public view returns (address _signer) {
77         bytes32 signerSlot = SIGNER_SLOT;
78         assembly { _signer := sload(signerSlot) }
79     } 
80 
81     // Address that relayed the `_id` intent
82     // address(0) if the intent was not relayed
83     function relayedBy(bytes32 _id) external view returns (address _relayer) {
84         (,,_relayer) = _decodeReceipt(intentReceipt[_id]);
85     }
86 
87     // Block when the intent was relayed
88     // 0 if the intent was not relayed
89     function relayedAt(bytes32 _id) external view returns (uint256 _block) {
90         (,_block,) = _decodeReceipt(intentReceipt[_id]);
91     }
92 
93     // True if the intent was canceled
94     // An executed intent can't be canceled and
95     // a Canceled intent can't be executed
96     function isCanceled(bytes32 _id) external view returns (bool _canceled) {
97         (_canceled,,) = _decodeReceipt(intentReceipt[_id]);
98     }
99 
100     // Relay a signed intent
101     //
102     // The implementation receives data containing the id of the 'intent' and its data,
103     // and it will perform all subsequent calls.
104     //
105     // The same _implementation and _data combination can only be relayed once
106     //
107     // Returns the result of the 'delegatecall' execution
108     function relay(
109         address _implementation,
110         bytes calldata _data,
111         bytes calldata _signature
112     ) external payable returns (
113         bytes memory result
114     ) {
115         // Calculate ID from
116         // (this, _implementation, data)
117         // Any change in _data results in a different ID
118         bytes32 id = keccak256(
119             abi.encodePacked(
120                 address(this),
121                 _implementation,
122                 keccak256(_data)
123             )
124         );
125 
126         // Read receipt only once
127         // if the receipt is 0, the Intent was not canceled or relayed
128         if (intentReceipt[id] != bytes32(0)) {
129             // Decode the receipt and determine if the Intent was canceled or relayed
130             (bool canceled, , address relayer) = _decodeReceipt(intentReceipt[id]);
131             require(relayer == address(0), "Intent already relayed");
132             require(!canceled, "Intent was canceled");
133             revert("Unknown error");
134         }
135 
136         // Read the signer from storage, avoid multiples 'sload' ops
137         address _signer = signer();
138 
139         // The signer 'INVALID_ADDRESS' is considered invalid and it will always throw
140         // this is meant to disable the wallet safely
141         require(_signer != INVALID_ADDRESS, "Signer is not a valid address");
142 
143         // Validate if the msg.sender is the signer or if the provided signature is valid
144         require(_signer == msg.sender || _signer == SigUtils.ecrecover2(id, _signature), "Invalid signature");
145 
146         // Save the receipt before performing any other action
147         intentReceipt[id] = _encodeReceipt(false, block.number, msg.sender);
148 
149         // Emit the 'relayed' event
150         emit Relayed(id, _implementation, _data);
151 
152         // Perform 'delegatecall' to _implementation, appending the id of the intent
153         // to the beginning of the _data.
154 
155         bool success;
156         (success, result) = _implementation.delegatecall(abi.encode(id, _data));
157 
158         // If the 'delegatecall' failed, reverts the transaction
159         // forwarding the revert message
160         if (!success) {
161             assembly {
162                 revert(add(result, 32), mload(result))
163             }
164         }
165     }
166 
167     // Cancels a not executed Intent '_id'
168     // a canceled intent can't be executed
169     function cancel(bytes32 _id) external {
170         require(msg.sender == address(this), "Only wallet can cancel txs");
171 
172         if (intentReceipt[_id] != bytes32(0)) {
173             (bool canceled, , address relayer) = _decodeReceipt(intentReceipt[_id]);
174             require(relayer == address(0), "Intent already relayed");
175             require(!canceled, "Intent was canceled");
176             revert("Unknown error");
177         }
178 
179         emit Canceled(_id);
180         intentReceipt[_id] = _encodeReceipt(true, 0, address(0));
181     }
182 
183     // Encodes an Intent receipt
184     // into a single bytes32
185     // canceled (1 bit) + block (95 bits) + relayer (160 bits)
186     // notice: Does not validate the _block length,
187     // a _block overflow would not corrupt the wallet state
188     function _encodeReceipt(
189         bool _canceled,
190         uint256 _block,
191         address _relayer
192     ) internal pure returns (bytes32 _receipt) {
193         assembly {
194             _receipt := or(shl(255, _canceled), or(shl(160, _block), _relayer))
195         }
196     }
197     
198     // Decodes an Intent receipt
199     // reverse of _encodeReceipt(bool,uint256,address)
200     function _decodeReceipt(bytes32 _receipt) internal pure returns (
201         bool _canceled,
202         uint256 _block,
203         address _relayer
204     ) {
205         assembly {
206             _canceled := shr(255, _receipt)
207             _block := and(shr(160, _receipt), 0x7fffffffffffffffffffffff)
208             _relayer := and(_receipt, 0xffffffffffffffffffffffffffffffffffffffff)
209         }
210     }
211 
212     // Used to receive ERC721 tokens
213     function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
214         return bytes4(0x150b7a02);
215     }
216 }
217 
218 // File: contracts/commons/Bytes.sol
219 
220 pragma solidity ^0.5.7;
221 
222 
223 // Bytes library to concat and transform
224 // bytes arrays
225 library Bytes {
226     // Concadenates two bytes array
227     function concat(
228         bytes memory _preBytes,
229         bytes memory _postBytes
230     ) internal pure returns (bytes memory) {
231         return abi.encodePacked(_preBytes, _postBytes);
232     }
233 
234     // Concatenates a bytes array and a bytes1
235     function concat(bytes memory _a, bytes1 _b) internal pure returns (bytes memory _out) {
236         return concat(_a, abi.encodePacked(_b));
237     }
238 
239     // Concatenates 6 bytes arrays
240     function concat(
241         bytes memory _a,
242         bytes memory _b,
243         bytes memory _c,
244         bytes memory _d,
245         bytes memory _e,
246         bytes memory _f
247     ) internal pure returns (bytes memory) {
248         return abi.encodePacked(
249             _a,
250             _b,
251             _c,
252             _d,
253             _e,
254             _f
255         );
256     }
257 
258     // Transforms a bytes1 into bytes
259     function toBytes(bytes1 _a) internal pure returns (bytes memory) {
260         return abi.encodePacked(_a);
261     }
262 
263     // Transform a uint256 into bytes (last 8 bits)
264     function toBytes1(uint256 _a) internal pure returns (bytes1 c) {
265         assembly { c := shl(248, _a) }
266     }
267 
268     // Adds a bytes1 and the last 8 bits of a uint256
269     function plus(bytes1 _a, uint256 _b) internal pure returns (bytes1 c) {
270         c = toBytes1(_b);
271         assembly { c := add(_a, c) }
272     }
273 
274     // Transforms a bytes into an array
275     // it fails if _a has more than 20 bytes
276     function toAddress(bytes memory _a) internal pure returns (address payable b) {
277         require(_a.length <= 20);
278         assembly {
279             b := shr(mul(sub(32, mload(_a)), 8), mload(add(_a, 32)))
280         }
281     }
282 
283     // Returns the most significant bit of a given uint256
284     function mostSignificantBit(uint256 x) internal pure returns (uint256) {        
285         uint8 o = 0;
286         uint8 h = 255;
287         
288         while (h > o) {
289             uint8 m = uint8 ((uint16 (o) + uint16 (h)) >> 1);
290             uint256 t = x >> m;
291             if (t == 0) h = m - 1;
292             else if (t > 1) o = m + 1;
293             else return m;
294         }
295         
296         return h;
297     }
298 
299     // Shrinks a given address to the minimal representation in a bytes array
300     function shrink(address _a) internal pure returns (bytes memory b) {
301         uint256 abits = mostSignificantBit(uint256(_a)) + 1;
302         uint256 abytes = abits / 8 + (abits % 8 == 0 ? 0 : 1);
303 
304         assembly {
305             b := 0x0
306             mstore(0x0, abytes)
307             mstore(0x20, shl(mul(sub(32, abytes), 8), _a))
308         }
309     }
310 }
311 
312 // File: contracts/commons/MinimalProxy.sol
313 
314 pragma solidity ^0.5.7;
315 
316 
317 
318 library MinimalProxy {
319     using Bytes for bytes1;
320     using Bytes for bytes;
321 
322     // Minimal proxy contract
323     // by Agusx1211
324     bytes constant CODE1 = hex"60"; // + <size>                                   // Copy code to memory
325     bytes constant CODE2 = hex"80600b6000396000f3";                               // Return and deploy contract
326     bytes constant CODE3 = hex"3660008037600080366000";   // + <pushx> + <source> // Proxy, copy calldata and start delegatecall
327     bytes constant CODE4 = hex"5af43d6000803e60003d9160"; // + <return jump>      // Do delegatecall and return jump
328     bytes constant CODE5 = hex"57fd5bf3";                                         // Return proxy
329 
330     bytes1 constant BASE_SIZE = 0x1d;
331     bytes1 constant PUSH_1 = 0x60;
332     bytes1 constant BASE_RETURN_JUMP = 0x1b;
333 
334     // Returns the Init code to create a
335     // Minimal proxy pointing to a given address
336     function build(address _address) internal pure returns (bytes memory initCode) {
337         return build(Bytes.shrink(_address));
338     }
339 
340     function build(bytes memory _address) private pure returns (bytes memory initCode) {
341         require(_address.length <= 20, "Address too long");
342         initCode = Bytes.concat(
343             CODE1,
344             BASE_SIZE.plus(_address.length).toBytes(),
345             CODE2,
346             CODE3.concat(PUSH_1.plus(_address.length - 1)).concat(_address),
347             CODE4.concat(BASE_RETURN_JUMP.plus(_address.length)),
348             CODE5
349         );
350     }
351 }
352 
353 // File: contracts/MarmoStork.sol
354 
355 pragma solidity ^0.5.7;
356 
357 
358 
359 
360 // MarmoStork creates all Marmo wallets
361 // every address has a designated marmo wallet
362 // and can send transactions by signing Meta-Tx (Intents)
363 //
364 // All wallets are proxies pointing to a single
365 // source contract, to make deployment costs viable
366 contract MarmoStork {
367     // Random Invalid signer address
368     // Intents signed with this address are invalid
369     address private constant INVALID_ADDRESS = address(0x9431Bab00000000000000000000000039bD955c9);
370 
371     // Prefix of create2 address formula (EIP-1014)
372     bytes1 private constant CREATE2_PREFIX = byte(0xff);
373 
374     // Bytecode to deploy marmo wallets
375     bytes public bytecode;
376 
377     // Hash of the bytecode
378     // used to calculate create2 result
379     bytes32 public hash;
380 
381     // Marmo Source contract
382     // all proxies point here
383     address public marmo;
384 
385     // Creates a new MarmoStork (Marmo wallet Factory)
386     // with wallets pointing to the _source contract reference
387     constructor(address payable _source) public {
388         // Generate and save wallet creator bytecode using the provided '_source'
389         bytecode = MinimalProxy.build(_source);
390 
391         // Precalculate init_code hash
392         hash = keccak256(bytecode);
393         
394         // Destroy the '_source' provided, if is not disabled
395         Marmo marmoc = Marmo(_source);
396         if (marmoc.signer() == address(0)) {
397             marmoc.init(INVALID_ADDRESS);
398         }
399 
400         // Validate, the signer of _source should be "INVALID_ADDRESS" (disabled)
401         require(marmoc.signer() == INVALID_ADDRESS, "Error init Marmo source");
402 
403         // Save the _source address, casting to address (160 bits)
404         marmo = address(marmoc);
405     }
406     
407     // Calculates the Marmo wallet for a given signer
408     // the wallet contract will be deployed in a deterministic manner
409     function marmoOf(address _signer) external view returns (address) {
410         // CREATE2 address
411         return address(
412             uint256(
413                 keccak256(
414                     abi.encodePacked(
415                         CREATE2_PREFIX,
416                         address(this),
417                         bytes32(uint256(_signer)),
418                         hash
419                     )
420                 )
421             )
422         );
423     }
424 
425     // Deploys the Marmo wallet of a given _signer
426     // all ETH sent will be forwarded to the wallet
427     function reveal(address _signer) external payable {
428         // Load init code from storage
429         bytes memory proxyCode = bytecode;
430 
431         // Create wallet proxy using CREATE2
432         // use _signer as salt
433         Marmo p;
434         assembly {
435             p := create2(0, add(proxyCode, 0x20), mload(proxyCode), _signer)
436         }
437 
438         // Init wallet with provided _signer
439         // and forward all Ether
440         p.init.value(msg.value)(_signer);
441     }
442 }