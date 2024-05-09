1 pragma solidity ^0.4.13;
2 
3 contract FranklinStorage {
4 
5     // For tree depth 24
6     bytes32 constant EMPTY_TREE_ROOT = 0x003f7e15e4de3453fe13e11fb4b007f1fce6a5b0f0353b3b8208910143aaa2f7;
7 
8     uint256 public constant DEADLINE = 3600;
9 
10     event BlockCommitted(uint32 indexed blockNumber);
11     event BlockVerified(uint32 indexed blockNumber);
12 
13     enum Circuit {
14         DEPOSIT,
15         TRANSFER,
16         EXIT
17     }
18 
19     enum AccountState {
20         NOT_REGISTERED,
21         REGISTERED,
22         PENDING_EXIT,
23         UNCONFIRMED_EXIT
24     }
25 
26     struct Block {
27         uint8 circuit;
28         uint64  deadline;
29         uint128 totalFees;
30         bytes32 newRoot;
31         bytes32 publicDataCommitment;
32         address prover;
33     }
34 
35     // Key is block number
36     mapping (uint32 => Block) public blocks;
37     // Only some addresses can send proofs
38     mapping (address => bool) public operators;
39     // Fee collection accounting
40     mapping (address => uint256) public balances;
41 
42     struct Account {
43         uint8 state;
44         uint32 exitBatchNumber;
45         address owner;
46         uint256 publicKey;
47         uint32 exitListHead;
48         uint32 exitListTail;
49     }
50 
51     // one Ethereum address should have one account
52     mapping (address => uint24) public ethereumAddressToAccountID;
53 
54     // Plasma account => general information
55     mapping (uint24 => Account) public accounts;
56 
57     // Public information for users
58     bool public stopped;
59     uint32 public lastCommittedBlockNumber;
60     uint32 public lastVerifiedBlockNumber;
61     bytes32 public lastVerifiedRoot;
62     uint64 public constant MAX_DELAY = 1 days;
63     uint256 public constant DENOMINATOR = 1000000000000;
64 
65     // deposits
66 
67     uint256 public constant DEPOSIT_BATCH_SIZE = 1;
68     uint256 public totalDepositRequests; // enumerates total number of deposit, starting from 0
69     uint256 public lastCommittedDepositBatch;
70     uint256 public lastVerifiedDepositBatch;
71     uint128 public currentDepositBatchFee; // deposit request fee scaled units
72 
73     uint24 public constant SPECIAL_ACCOUNT_DEPOSITS = 1;
74 
75     uint24 public nextAccountToRegister;
76 
77     // some ideas for optimization of the deposit request information storage:
78     // store in a mapping: 20k gas to add, 5k to update a record + 5k to update the global counter per batch
79     // store in an array: 20k + 5k gas to add, 5k to update + up to DEPOSIT_BATCH_SIZE * SLOAD
80 
81     // batch number => (plasma address => deposit information)
82     mapping (uint256 => mapping (uint24 => DepositRequest)) public depositRequests;
83     mapping (uint256 => DepositBatch) public depositBatches;
84 
85     struct DepositRequest {
86         uint128 amount;
87     }
88 
89     enum DepositBatchState {
90         CREATED,
91         COMMITTED,
92         VERIFIED
93     }
94 
95     struct DepositBatch {
96         uint8 state;
97         uint24 numRequests;
98         uint32 blockNumber;
99         uint64 timestamp;
100         uint128 batchFee;
101     }
102 
103     event LogDepositRequest(uint256 indexed batchNumber, uint24 indexed accountID, uint256 indexed publicKey, uint128 amount);
104     event LogCancelDepositRequest(uint256 indexed batchNumber, uint24 indexed accountID);
105 
106     // Exits 
107 
108     uint256 constant EXIT_BATCH_SIZE = 1;
109     uint256 public totalExitRequests; 
110     uint256 public lastCommittedExitBatch;
111     uint256 public lastVerifiedExitBatch;
112     uint128 public currentExitBatchFee; 
113 
114     uint24 public constant SPECIAL_ACCOUNT_EXITS = 0;
115 
116     // batches for complete exits
117     mapping (uint256 => ExitBatch) public exitBatches;
118 
119     enum ExitBatchState {
120         CREATED,
121         COMMITTED,
122         VERIFIED
123     }
124 
125     struct ExitBatch {
126         uint8 state;
127         uint32 blockNumber;
128         uint64 timestamp;
129         uint128 batchFee;
130     }
131 
132     event LogExitRequest(uint256 indexed batchNumber, uint24 indexed accountID);
133     event LogCancelExitRequest(uint256 indexed batchNumber, uint24 indexed accountID);
134 
135     event LogExit(address indexed ethereumAddress, uint32 indexed blockNumber);
136     event LogCompleteExit(address indexed ethereumAddress, uint32 indexed blockNumber, uint24 accountID);
137 
138     struct ExitLeaf {
139         uint32 nextID;
140         uint128 amount;
141     }
142 
143     mapping (address => mapping (uint32 => ExitLeaf)) public exitLeafs;
144 
145     // mapping ethereum address => block number => balance
146     // mapping (address => mapping (uint32 => uint128)) public exitAmounts;
147     // Delegates chain
148     address public depositor;
149     address public transactor;
150     address public exitor;
151 }
152 
153 contract Verifier {
154 
155     function NegateY( uint256 Y )
156         internal pure returns (uint256)
157     {
158         uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
159         return q - (Y % q);
160     }
161 
162     function Verify ( uint256[14] in_vk, uint256[] vk_gammaABC, uint256[8] in_proof, uint256[] proof_inputs )
163         internal 
164         view 
165         returns (bool)
166     {
167         require( ((vk_gammaABC.length / 2) - 1) == proof_inputs.length, "Invalid number of public inputs" );
168 
169         // Compute the linear combination vk_x
170         uint256[3] memory mul_input;
171         uint256[4] memory add_input;
172         bool success;
173         uint m = 2;
174 
175         // First two fields are used as the sum
176         add_input[0] = vk_gammaABC[0];
177         add_input[1] = vk_gammaABC[1];
178 
179         // Performs a sum of gammaABC[0] + sum[ gammaABC[i+1]^proof_inputs[i] ]
180         for (uint i = 0; i < proof_inputs.length; i++) {
181             mul_input[0] = vk_gammaABC[m++];
182             mul_input[1] = vk_gammaABC[m++];
183             mul_input[2] = proof_inputs[i];
184 
185             assembly {
186                 // ECMUL, output to last 2 elements of `add_input`
187                 success := staticcall(sub(gas, 2000), 7, mul_input, 0x60, add(add_input, 0x40), 0x40)
188             }
189             require( success, "Failed to call ECMUL precompile" );
190 
191             assembly {
192                 // ECADD
193                 success := staticcall(sub(gas, 2000), 6, add_input, 0x80, add_input, 0x40)
194             }
195             require( success, "Failed to call ECADD precompile" );
196         }
197 
198         uint[24] memory input = [
199             // (proof.A, proof.B)
200             in_proof[0], in_proof[1],                           // proof.A   (G1)
201             in_proof[2], in_proof[3], in_proof[4], in_proof[5], // proof.B   (G2)
202 
203             // (-vk.alpha, vk.beta)
204             in_vk[0], NegateY(in_vk[1]),                        // -vk.alpha (G1)
205             in_vk[2], in_vk[3], in_vk[4], in_vk[5],             // vk.beta   (G2)
206 
207             // (-vk_x, vk.gamma)
208             add_input[0], NegateY(add_input[1]),                // -vk_x     (G1)
209             in_vk[6], in_vk[7], in_vk[8], in_vk[9],             // vk.gamma  (G2)
210 
211             // (-proof.C, vk.delta)
212             in_proof[6], NegateY(in_proof[7]),                  // -proof.C  (G1)
213             in_vk[10], in_vk[11], in_vk[12], in_vk[13]          // vk.delta  (G2)
214         ];
215 
216         uint[1] memory out;
217         assembly {
218             success := staticcall(sub(gas, 2000), 8, input, 768, out, 0x20)
219         }
220         require(success, "Failed to call pairing precompile");
221         return out[0] == 1;
222     }
223 }
224 
225 contract DepositVerificationKey {
226 
227     function getVkDepositCircuit() internal pure returns (uint256[14] memory vk, uint256[] memory gammaABC) {
228 
229         
230         vk[0] = 0x02834523b73cb0630d49fc3e2054522563fb6471012d3f1e6fe31cb946240774;
231         vk[1] = 0x0ba99f12ab5e9c80db6c85f62fb7a0df5d0dcb1088eb4b48d36156d816489128;
232         vk[2] = 0x0f19b305cee59f6dc3c054880068b4a13768e5b901d0479271c20f8b79243965;
233         vk[3] = 0x11e32a8c382c7fb28b177d02e354607f7c33abc7f5636e71cd0fb4cd77eb1d74;
234         vk[4] = 0x2bee5b6bb3fda73e29152d399f1bd211961f048eeb0d5a7d752ad9ffb649dff1;
235         vk[5] = 0x15ec0d94cdfe1fdcc23a58995e2af0b788fffae99691676fa943d608226b8682;
236         vk[6] = 0x03f6ee67c8871c54c6f20e77376eb305e5b4964f1019bce1ad9ce22b2bec622c;
237         vk[7] = 0x21b45fc68e2059b1eab7eee045ab7be7ed45a2d3f6e3515ac1ec28f7b490b1dd;
238         vk[8] = 0x0c9b53ea69e19134e41340bb6c0d1795661381291bf630c24396f8e866528002;
239         vk[9] = 0x2e24ea773c3f54e3e7fc82249e7de02be3932e8b156800d9e4d19a5047f85cbb;
240         vk[10] = 0x215e8c48ee50bad165d2420f9220145fa4cc98d7dcb52cc2a6e9010fd6214411;
241         vk[11] = 0x1917a1144eb6f1c16ebf2673f2eb0fe275ae8bf518ae36553354580cd191293f;
242         vk[12] = 0x1d636227f8db452d07a36077ffb1f0723947ae4cae746721445d3d249438ee57;
243         vk[13] = 0x13c4be40874508b0fa8b895657084e1a8e1bb7002d7a8cc05f0973763cb20755;
244 
245         gammaABC = new uint256[](8);
246         gammaABC[0] = 0x017474e8efdf8775559844f978a7d23602c51508c42055cba41da71d8c184662;
247         gammaABC[1] = 0x0479fb6bc0d7c11f5a734f450f6a47ec94bd59014f8398b248f59dc058b76b64;
248         gammaABC[2] = 0x06cef07cba4570717e5a1389b1425ed2f9d3de870c651254f557b82187eda82c;
249         gammaABC[3] = 0x1ba4b300e354352533d910452a340d16d2205ab18698cc5158bbb89a4d6340e9;
250         gammaABC[4] = 0x16901a82f58d7d091cb47c0b8daa365e9c8dea97ff33d461044ce0c8f03cae71;
251         gammaABC[5] = 0x0902ea2f0d929f53465faab02d6e6c475868b5004b6ccdf29ec17fdcf1f4bf50;
252         gammaABC[6] = 0x113c4aa77bfc12e18d3d0f64e840c2f912406ee9e61e476aaa67f8c743baa7c2;
253         gammaABC[7] = 0x176aa258bd76a01a4f744c71483afbc1ec4cd0529a6842b8a14c7feb75821e90;
254 
255 
256     }
257 
258 }
259 
260 contract ExitVerificationKey {
261 
262     function getVkExitCircuit() internal pure returns (uint256[14] memory vk, uint256[] memory gammaABC) {
263 
264         
265         vk[0] = 0x2655d0f184451488c9c86edaa0f36a7d4f7a2fc3825e7d030af5660d3681ace6;
266         vk[1] = 0x30062c29546c272a712d301884a3deef21716e671c5da66cac7f5d263714a2a6;
267         vk[2] = 0x1e6c69a1d12135996fa27fb9f435d1876b34629e574671ba77826b8733d93b65;
268         vk[3] = 0x0bb271e151e34c9bfe2abaaf66c5888ccfa6c2272a29ab8f5f572d1177fbdf1e;
269         vk[4] = 0x05ff0ddaeb5d75296cac71fd305db5a3395759a926cb6c8701f84d35710f78ee;
270         vk[5] = 0x20272b96093e40001583fead3bd6e8c6453f346bdf92d5779bed7ab884d0aa2e;
271         vk[6] = 0x0950cc975d157dd4e80dc8d162caa4e506186f7adbe9cf69867a18e56b7a167b;
272         vk[7] = 0x0a58c1bf8b3a41a9d53c66509de333ac6e110de78d270f6f4c7a32acac5d65bf;
273         vk[8] = 0x152ff1340ad2dcf6eb3b2373263f3e3d48c58e4f3c8035d994d690efb89105cd;
274         vk[9] = 0x1a7a1d4994c386d270238d45dcf938bfae17753560be434e4c98950d9a150d9c;
275         vk[10] = 0x0ea995b343d372ae0f5cad6a29ea289172d127085b8ebb9a8a46d8c359728dcb;
276         vk[11] = 0x256fd00e2102e55b0e0882a8fc9297d9e2eb66b1f368dea21c3b4fea52ff1b77;
277         vk[12] = 0x024e59df7dad7374d09caa273089b9d27057c131db4d645cbe2b780ed8dca72b;
278         vk[13] = 0x1aea3eea3d14b2240eabd4c12fa0cc60a3431e6f55132cf7809eb80b5c696c7d;
279 
280         gammaABC = new uint256[](8);
281         gammaABC[0] = 0x02e10a3d18c9ddc8a7faf5e20d6cd56ae82426e802596b8e424c8d24a2d8cc91;
282         gammaABC[1] = 0x0fcf4f982b4c051fe7d7e25d73c174f709e1a116a39573f5ebcce86a694086ac;
283         gammaABC[2] = 0x0647167a8df2f9de6e1dbd6e6e52e8bcf6b64d7fb9a6405f3efca93f250cac14;
284         gammaABC[3] = 0x2045113ec018db92050dba997d86b3b440c420d55819887fee065a17ef897897;
285         gammaABC[4] = 0x253baaed4e84773d8b85c1ac4d0b64d15d5652b318c3a72daf96a6d26a6d1481;
286         gammaABC[5] = 0x170034f174be16fd996aeb4ac97653a3f0e344ed8b5dbe947d952208a938edba;
287         gammaABC[6] = 0x23967a7baa217743b308217c7db86912a130a668bce7c9ac030d5ed42472347c;
288         gammaABC[7] = 0x2bfd3180a31b3fef9328b1225755ea2e7ca8d1e832cb4729930e15b5f842300d;
289 
290 
291     }
292 
293 }
294 
295 contract TransferVerificationKey {
296 
297     function getVkTransferCircuit() internal pure returns (uint256[14] memory vk, uint256[] memory gammaABC) {
298 
299         
300         vk[0] = 0x10c2409dca4fa02e16250e08e4cbf8eae90c8fba1e91115f065f88f73d0ec0ba;
301         vk[1] = 0x0aa6ecb84f58760a6a01d0f31bb8776582c893f66562b623d9082e50b9147015;
302         vk[2] = 0x10296458aa3bcd5ad37ae95f63f55e90b8830fe1449dc21aee05ebdf7e29ef14;
303         vk[3] = 0x0f51783ae1ca492c229a5d04bc2de03ff6ff9a4f877a2bc80bb60eb1f70cc84b;
304         vk[4] = 0x0f874f1341d40fe04cebe4668c968c74d2d09aa07e4685889c90f6d4ec4345de;
305         vk[5] = 0x1652c73a52779311ca7ffdcd9749e40592780259a9c9e738b63199dad11d7f17;
306         vk[6] = 0x086d1b9a535ffcebe71f045e022967f0c113114c04a1bf944a395c14cce50f49;
307         vk[7] = 0x2b2166f750b92453a4bc000425e93c3c412d911961dcd9050c61368f07673262;
308         vk[8] = 0x12ba168ac5544a1b8c1bd3c47b6d9a1391db76a608e4556b639e0032e2deffbe;
309         vk[9] = 0x2b32a828faf0bb870f693cc8031c166b0063d854c435ea1b516e67ba5a6d8907;
310         vk[10] = 0x100f54919b2e2f9ddaacfae446be3614441bb0e451380ec96658979748613433;
311         vk[11] = 0x066bcceed5d7a04466af77a2af1e9ca005a12f19bc4d7cc8e231354885b82607;
312         vk[12] = 0x28782e5b286bda594b1ad6320c62df3dbfcf4db5043430d19204f46a34fd4119;
313         vk[13] = 0x11b16528236d3aba305c2f3b051b0d88902465da7969d8b6719fbf9dd35dcf2a;
314 
315         gammaABC = new uint256[](8);
316         gammaABC[0] = 0x0f33cb3065f68e121317d06f1424955c5a7e2ec8edebc909aac08a3f17069886;
317         gammaABC[1] = 0x037f77f317232115d1e59c5d751cdfc7cb71860def1eac9c26601ca608818d82;
318         gammaABC[2] = 0x160621974534ddb69577555fb5add3b219fc3d7940d6af98fd0b4d1323e98a02;
319         gammaABC[3] = 0x0f99ebad244805d05f610d8a9e2fb9395fe4159ed19ff545c1663395faf2e54e;
320         gammaABC[4] = 0x252887d8a49ac0d88d097657230f297137e590d836a958c33f6e86737a7b6d5d;
321         gammaABC[5] = 0x303d4a352e156b053325cd397e875076f30a41b8b5cb919c284f76021c95d506;
322         gammaABC[6] = 0x12373b5d89c0ded59c6cff32b0ff93b98a46b0fabc01be54748fbe072c34721e;
323         gammaABC[7] = 0x00c29f8e6d126eff674bede612ba90717ef37c8fa3431309d2bb81dac30871e5;
324 
325 
326     }
327 
328 }
329 
330 contract VerificationKeys is TransferVerificationKey, DepositVerificationKey, ExitVerificationKey {
331 }
332 
333 contract FranklinCommon is VerificationKeys, FranklinStorage, Verifier {
334 
335     modifier active_only() {
336         require(!stopped, "contract should not be globally stopped");
337         _;
338     }
339 
340     modifier operator_only() {
341         require(operators[msg.sender] == true, "sender should be one of the operators");
342         _;
343     }
344 
345     // unit normalization functions
346     function scaleIntoPlasmaUnitsFromWei(uint256 value)
347     public
348     pure
349     returns (uint128) {
350         uint256 den = DENOMINATOR;
351         require(value % den == 0, "amount has higher precision than possible");
352         uint256 scaled = value / den;
353         require(scaled < uint256(1) << 128, "deposit amount is too high");
354         return uint128(scaled);
355     }
356 
357     function scaleFromPlasmaUnitsIntoWei(uint128 value)
358     public
359     pure
360     returns (uint256) {
361         return uint256(value) * DENOMINATOR;
362     }
363 
364     function verifyProof(Circuit circuitType, uint256[8] memory proof, bytes32 oldRoot, bytes32 newRoot, bytes32 finalHash)
365         internal view returns (bool valid)
366     {
367         uint256 mask = (~uint256(0)) >> 3;
368         uint256[14] memory vk;
369         uint256[] memory gammaABC;
370         if (circuitType == Circuit.DEPOSIT) {
371             (vk, gammaABC) = getVkDepositCircuit();
372         } else if (circuitType == Circuit.TRANSFER) {
373             (vk, gammaABC) = getVkTransferCircuit();
374         } else if (circuitType == Circuit.EXIT) {
375             (vk, gammaABC) = getVkExitCircuit();
376         } else {
377             return false;
378         }
379         uint256[] memory inputs = new uint256[](3);
380         inputs[0] = uint256(oldRoot);
381         inputs[1] = uint256(newRoot);
382         inputs[2] = uint256(finalHash) & mask;
383         return Verify(vk, gammaABC, proof, inputs);
384     }
385 
386 }
387 
388 contract FranklinProxy is FranklinCommon {
389 
390     constructor(address _depositor, address _transactor, address _exitor) public {
391         nextAccountToRegister = 2;
392         lastVerifiedRoot = EMPTY_TREE_ROOT;
393         operators[msg.sender] = true;
394         depositor = _depositor;
395         transactor = _transactor;
396         exitor = _exitor;
397 
398     }
399 
400     function deposit(uint256[2] memory, uint128) public payable {
401         callExternal(depositor);
402     }
403 
404     function depositInto(uint24, uint128) public payable {
405         callExternal(depositor);
406     }
407 
408     function cancelDeposit() public {
409         callExternal(depositor);
410     }
411 
412     function startNextDepositBatch() public {
413         callExternal(depositor);
414     }
415 
416     function changeDepositBatchFee(uint128) public {
417         callExternal(depositor);
418     }
419 
420     function commitDepositBlock(uint256, uint24[DEPOSIT_BATCH_SIZE] memory, uint32, bytes32) public {
421         callExternal(depositor);
422     }
423 
424     function verifyDepositBlock(uint256, uint24[DEPOSIT_BATCH_SIZE] memory, uint32, uint256[8] memory) public {
425         callExternal(depositor);
426     } 
427 
428     function commitTransferBlock(uint32, uint128, bytes memory, bytes32) public {
429         callExternal(transactor);
430     }
431 
432     function verifyTransferBlock(uint32, uint256[8] memory) public {
433         callExternal(transactor);
434     }
435 
436     function exit() public payable {
437         callExternal(exitor);
438     }
439 
440     function cancelExit() public {
441         callExternal(exitor);
442     }
443 
444     function startNextExitBatch() public {
445         callExternal(exitor);
446     }
447 
448     function changeExitBatchFee(uint128) public {
449         callExternal(exitor);
450     }
451 
452     function commitExitBlock(uint256, uint24[EXIT_BATCH_SIZE] memory, uint32, bytes memory, bytes32) public {
453         callExternal(exitor);
454     }
455 
456     function verifyExitBlock(uint256, uint32, uint256[8] memory) public {
457         callExternal(exitor);
458     }
459 
460     function withdrawUserBalance(uint256) public {
461         callExternal(exitor);
462     }
463 
464     // this is inline delegate-call to dispatch functions to subcontracts that are responsible for execution
465     function callExternal(address callee) internal {
466         assembly {
467             let memoryPointer := mload(0x40)
468             calldatacopy(memoryPointer, 0, calldatasize)
469             let newFreeMemoryPointer := add(memoryPointer, calldatasize)
470             mstore(0x40, newFreeMemoryPointer)
471             let retVal := delegatecall(sub(gas, 2000), callee, memoryPointer, calldatasize, newFreeMemoryPointer, 0x40)
472             let retDataSize := returndatasize
473             returndatacopy(newFreeMemoryPointer, 0, retDataSize)
474             switch retVal case 0 { revert(newFreeMemoryPointer, returndatasize) } default { return(newFreeMemoryPointer, retDataSize) }
475             //return(newFreeMemoryPointer, retDataSize)
476         }
477     }
478 }
479 
