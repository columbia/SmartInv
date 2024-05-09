1 pragma solidity ^0.4.13;
2 
3 contract FranklinStorage {
4 
5     // NOTE: This is test code! All contracts will be thoughrouhly rewritten for production.
6 
7     address public testCreator;
8 
9     constructor() public {
10         testCreator = msg.sender;
11     }
12 
13     function killThisTestContract() public {
14         require(msg.sender == testCreator, "only creator can clean up test contracts");
15         selfdestruct(testCreator);
16     }
17     
18 
19     // For tree depth 24
20     bytes32 constant EMPTY_TREE_ROOT = 0x003f7e15e4de3453fe13e11fb4b007f1fce6a5b0f0353b3b8208910143aaa2f7;
21 
22     uint256 public constant DEADLINE = 3600;
23 
24     event BlockCommitted(uint32 indexed blockNumber);
25     event BlockVerified(uint32 indexed blockNumber);
26 
27     enum Circuit {
28         DEPOSIT,
29         TRANSFER,
30         EXIT
31     }
32 
33     enum AccountState {
34         NOT_REGISTERED,
35         REGISTERED,
36         PENDING_EXIT,
37         UNCONFIRMED_EXIT
38     }
39 
40     struct Block {
41         uint8 circuit;
42         uint64  deadline;
43         uint128 totalFees;
44         bytes32 newRoot;
45         bytes32 publicDataCommitment;
46         address prover;
47     }
48 
49     // Key is block number
50     mapping (uint32 => Block) public blocks;
51     // Only some addresses can send proofs
52     mapping (address => bool) public operators;
53     // Fee collection accounting
54     mapping (address => uint256) public balances;
55 
56     struct Account {
57         uint8 state;
58         uint32 exitBatchNumber;
59         address owner;
60         uint256 publicKey;
61         uint32 exitListHead;
62         uint32 exitListTail;
63     }
64 
65     // one Ethereum address should have one account
66     mapping (address => uint24) public ethereumAddressToAccountID;
67 
68     // Plasma account => general information
69     mapping (uint24 => Account) public accounts;
70 
71     // Public information for users
72     bool public stopped;
73     uint32 public lastCommittedBlockNumber;
74     uint32 public lastVerifiedBlockNumber;
75     bytes32 public lastVerifiedRoot;
76     uint64 public constant MAX_DELAY = 1 days;
77     uint256 public constant DENOMINATOR = 1000000000000;
78 
79     // deposits
80 
81     uint256 public constant DEPOSIT_BATCH_SIZE = 1;
82     uint256 public totalDepositRequests; // enumerates total number of deposit, starting from 0
83     uint256 public lastCommittedDepositBatch;
84     uint256 public lastVerifiedDepositBatch;
85     uint128 public currentDepositBatchFee; // deposit request fee scaled units
86 
87     uint24 public constant SPECIAL_ACCOUNT_DEPOSITS = 1;
88 
89     uint24 public nextAccountToRegister;
90 
91     // some ideas for optimization of the deposit request information storage:
92     // store in a mapping: 20k gas to add, 5k to update a record + 5k to update the global counter per batch
93     // store in an array: 20k + 5k gas to add, 5k to update + up to DEPOSIT_BATCH_SIZE * SLOAD
94 
95     // batch number => (plasma address => deposit information)
96     mapping (uint256 => mapping (uint24 => DepositRequest)) public depositRequests;
97     mapping (uint256 => DepositBatch) public depositBatches;
98 
99     struct DepositRequest {
100         uint128 amount;
101     }
102 
103     enum DepositBatchState {
104         CREATED,
105         COMMITTED,
106         VERIFIED
107     }
108 
109     struct DepositBatch {
110         uint8 state;
111         uint24 numRequests;
112         uint32 blockNumber;
113         uint64 timestamp;
114         uint128 batchFee;
115     }
116 
117     event LogDepositRequest(uint256 indexed batchNumber, uint24 indexed accountID, uint256 indexed publicKey, uint128 amount);
118     event LogCancelDepositRequest(uint256 indexed batchNumber, uint24 indexed accountID);
119 
120     // Exits 
121 
122     uint256 constant EXIT_BATCH_SIZE = 1;
123     uint256 public totalExitRequests; 
124     uint256 public lastCommittedExitBatch;
125     uint256 public lastVerifiedExitBatch;
126     uint128 public currentExitBatchFee; 
127 
128     uint24 public constant SPECIAL_ACCOUNT_EXITS = 0;
129 
130     // batches for complete exits
131     mapping (uint256 => ExitBatch) public exitBatches;
132 
133     enum ExitBatchState {
134         CREATED,
135         COMMITTED,
136         VERIFIED
137     }
138 
139     struct ExitBatch {
140         uint8 state;
141         uint32 blockNumber;
142         uint64 timestamp;
143         uint128 batchFee;
144     }
145 
146     event LogExitRequest(uint256 indexed batchNumber, uint24 indexed accountID);
147     event LogCancelExitRequest(uint256 indexed batchNumber, uint24 indexed accountID);
148 
149     event LogExit(address indexed ethereumAddress, uint32 indexed blockNumber);
150     event LogCompleteExit(address indexed ethereumAddress, uint32 indexed blockNumber, uint24 accountID);
151 
152     struct ExitLeaf {
153         uint32 nextID;
154         uint128 amount;
155     }
156 
157     mapping (address => mapping (uint32 => ExitLeaf)) public exitLeafs;
158 
159     // mapping ethereum address => block number => balance
160     // mapping (address => mapping (uint32 => uint128)) public exitAmounts;
161     // Delegates chain
162     address public depositor;
163     address public transactor;
164     address public exitor;
165 }
166 
167 contract Verifier {
168 
169     function NegateY( uint256 Y )
170         internal pure returns (uint256)
171     {
172         uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
173         return q - (Y % q);
174     }
175 
176     function Verify ( uint256[14] in_vk, uint256[] vk_gammaABC, uint256[8] in_proof, uint256[] proof_inputs )
177         internal 
178         view 
179         returns (bool)
180     {
181         require( ((vk_gammaABC.length / 2) - 1) == proof_inputs.length, "Invalid number of public inputs" );
182 
183         // Compute the linear combination vk_x
184         uint256[3] memory mul_input;
185         uint256[4] memory add_input;
186         bool success;
187         uint m = 2;
188 
189         // First two fields are used as the sum
190         add_input[0] = vk_gammaABC[0];
191         add_input[1] = vk_gammaABC[1];
192 
193         // Performs a sum of gammaABC[0] + sum[ gammaABC[i+1]^proof_inputs[i] ]
194         for (uint i = 0; i < proof_inputs.length; i++) {
195             mul_input[0] = vk_gammaABC[m++];
196             mul_input[1] = vk_gammaABC[m++];
197             mul_input[2] = proof_inputs[i];
198 
199             assembly {
200                 // ECMUL, output to last 2 elements of `add_input`
201                 success := staticcall(sub(gas, 2000), 7, mul_input, 0x60, add(add_input, 0x40), 0x40)
202             }
203             require( success, "Failed to call ECMUL precompile" );
204 
205             assembly {
206                 // ECADD
207                 success := staticcall(sub(gas, 2000), 6, add_input, 0x80, add_input, 0x40)
208             }
209             require( success, "Failed to call ECADD precompile" );
210         }
211 
212         uint[24] memory input = [
213             // (proof.A, proof.B)
214             in_proof[0], in_proof[1],                           // proof.A   (G1)
215             in_proof[2], in_proof[3], in_proof[4], in_proof[5], // proof.B   (G2)
216 
217             // (-vk.alpha, vk.beta)
218             in_vk[0], NegateY(in_vk[1]),                        // -vk.alpha (G1)
219             in_vk[2], in_vk[3], in_vk[4], in_vk[5],             // vk.beta   (G2)
220 
221             // (-vk_x, vk.gamma)
222             add_input[0], NegateY(add_input[1]),                // -vk_x     (G1)
223             in_vk[6], in_vk[7], in_vk[8], in_vk[9],             // vk.gamma  (G2)
224 
225             // (-proof.C, vk.delta)
226             in_proof[6], NegateY(in_proof[7]),                  // -proof.C  (G1)
227             in_vk[10], in_vk[11], in_vk[12], in_vk[13]          // vk.delta  (G2)
228         ];
229 
230         uint[1] memory out;
231         assembly {
232             success := staticcall(sub(gas, 2000), 8, input, 768, out, 0x20)
233         }
234         require(success, "Failed to call pairing precompile");
235         return out[0] == 1;
236     }
237 }
238 
239 contract DepositVerificationKey {
240 
241     function getVkDepositCircuit() internal pure returns (uint256[14] memory vk, uint256[] memory gammaABC) {
242 
243         
244         vk[0] = 0x02834523b73cb0630d49fc3e2054522563fb6471012d3f1e6fe31cb946240774;
245         vk[1] = 0x0ba99f12ab5e9c80db6c85f62fb7a0df5d0dcb1088eb4b48d36156d816489128;
246         vk[2] = 0x0f19b305cee59f6dc3c054880068b4a13768e5b901d0479271c20f8b79243965;
247         vk[3] = 0x11e32a8c382c7fb28b177d02e354607f7c33abc7f5636e71cd0fb4cd77eb1d74;
248         vk[4] = 0x2bee5b6bb3fda73e29152d399f1bd211961f048eeb0d5a7d752ad9ffb649dff1;
249         vk[5] = 0x15ec0d94cdfe1fdcc23a58995e2af0b788fffae99691676fa943d608226b8682;
250         vk[6] = 0x03f6ee67c8871c54c6f20e77376eb305e5b4964f1019bce1ad9ce22b2bec622c;
251         vk[7] = 0x21b45fc68e2059b1eab7eee045ab7be7ed45a2d3f6e3515ac1ec28f7b490b1dd;
252         vk[8] = 0x0c9b53ea69e19134e41340bb6c0d1795661381291bf630c24396f8e866528002;
253         vk[9] = 0x2e24ea773c3f54e3e7fc82249e7de02be3932e8b156800d9e4d19a5047f85cbb;
254         vk[10] = 0x215e8c48ee50bad165d2420f9220145fa4cc98d7dcb52cc2a6e9010fd6214411;
255         vk[11] = 0x1917a1144eb6f1c16ebf2673f2eb0fe275ae8bf518ae36553354580cd191293f;
256         vk[12] = 0x1d636227f8db452d07a36077ffb1f0723947ae4cae746721445d3d249438ee57;
257         vk[13] = 0x13c4be40874508b0fa8b895657084e1a8e1bb7002d7a8cc05f0973763cb20755;
258 
259         gammaABC = new uint256[](8);
260         gammaABC[0] = 0x017474e8efdf8775559844f978a7d23602c51508c42055cba41da71d8c184662;
261         gammaABC[1] = 0x0479fb6bc0d7c11f5a734f450f6a47ec94bd59014f8398b248f59dc058b76b64;
262         gammaABC[2] = 0x06cef07cba4570717e5a1389b1425ed2f9d3de870c651254f557b82187eda82c;
263         gammaABC[3] = 0x1ba4b300e354352533d910452a340d16d2205ab18698cc5158bbb89a4d6340e9;
264         gammaABC[4] = 0x16901a82f58d7d091cb47c0b8daa365e9c8dea97ff33d461044ce0c8f03cae71;
265         gammaABC[5] = 0x0902ea2f0d929f53465faab02d6e6c475868b5004b6ccdf29ec17fdcf1f4bf50;
266         gammaABC[6] = 0x113c4aa77bfc12e18d3d0f64e840c2f912406ee9e61e476aaa67f8c743baa7c2;
267         gammaABC[7] = 0x176aa258bd76a01a4f744c71483afbc1ec4cd0529a6842b8a14c7feb75821e90;
268 
269 
270     }
271 
272 }
273 
274 contract ExitVerificationKey {
275 
276     function getVkExitCircuit() internal pure returns (uint256[14] memory vk, uint256[] memory gammaABC) {
277 
278         
279         vk[0] = 0x2655d0f184451488c9c86edaa0f36a7d4f7a2fc3825e7d030af5660d3681ace6;
280         vk[1] = 0x30062c29546c272a712d301884a3deef21716e671c5da66cac7f5d263714a2a6;
281         vk[2] = 0x1e6c69a1d12135996fa27fb9f435d1876b34629e574671ba77826b8733d93b65;
282         vk[3] = 0x0bb271e151e34c9bfe2abaaf66c5888ccfa6c2272a29ab8f5f572d1177fbdf1e;
283         vk[4] = 0x05ff0ddaeb5d75296cac71fd305db5a3395759a926cb6c8701f84d35710f78ee;
284         vk[5] = 0x20272b96093e40001583fead3bd6e8c6453f346bdf92d5779bed7ab884d0aa2e;
285         vk[6] = 0x0950cc975d157dd4e80dc8d162caa4e506186f7adbe9cf69867a18e56b7a167b;
286         vk[7] = 0x0a58c1bf8b3a41a9d53c66509de333ac6e110de78d270f6f4c7a32acac5d65bf;
287         vk[8] = 0x152ff1340ad2dcf6eb3b2373263f3e3d48c58e4f3c8035d994d690efb89105cd;
288         vk[9] = 0x1a7a1d4994c386d270238d45dcf938bfae17753560be434e4c98950d9a150d9c;
289         vk[10] = 0x0ea995b343d372ae0f5cad6a29ea289172d127085b8ebb9a8a46d8c359728dcb;
290         vk[11] = 0x256fd00e2102e55b0e0882a8fc9297d9e2eb66b1f368dea21c3b4fea52ff1b77;
291         vk[12] = 0x024e59df7dad7374d09caa273089b9d27057c131db4d645cbe2b780ed8dca72b;
292         vk[13] = 0x1aea3eea3d14b2240eabd4c12fa0cc60a3431e6f55132cf7809eb80b5c696c7d;
293 
294         gammaABC = new uint256[](8);
295         gammaABC[0] = 0x02e10a3d18c9ddc8a7faf5e20d6cd56ae82426e802596b8e424c8d24a2d8cc91;
296         gammaABC[1] = 0x0fcf4f982b4c051fe7d7e25d73c174f709e1a116a39573f5ebcce86a694086ac;
297         gammaABC[2] = 0x0647167a8df2f9de6e1dbd6e6e52e8bcf6b64d7fb9a6405f3efca93f250cac14;
298         gammaABC[3] = 0x2045113ec018db92050dba997d86b3b440c420d55819887fee065a17ef897897;
299         gammaABC[4] = 0x253baaed4e84773d8b85c1ac4d0b64d15d5652b318c3a72daf96a6d26a6d1481;
300         gammaABC[5] = 0x170034f174be16fd996aeb4ac97653a3f0e344ed8b5dbe947d952208a938edba;
301         gammaABC[6] = 0x23967a7baa217743b308217c7db86912a130a668bce7c9ac030d5ed42472347c;
302         gammaABC[7] = 0x2bfd3180a31b3fef9328b1225755ea2e7ca8d1e832cb4729930e15b5f842300d;
303 
304 
305     }
306 
307 }
308 
309 contract TransferVerificationKey {
310 
311     function getVkTransferCircuit() internal pure returns (uint256[14] memory vk, uint256[] memory gammaABC) {
312 
313         
314         vk[0] = 0x10c2409dca4fa02e16250e08e4cbf8eae90c8fba1e91115f065f88f73d0ec0ba;
315         vk[1] = 0x0aa6ecb84f58760a6a01d0f31bb8776582c893f66562b623d9082e50b9147015;
316         vk[2] = 0x10296458aa3bcd5ad37ae95f63f55e90b8830fe1449dc21aee05ebdf7e29ef14;
317         vk[3] = 0x0f51783ae1ca492c229a5d04bc2de03ff6ff9a4f877a2bc80bb60eb1f70cc84b;
318         vk[4] = 0x0f874f1341d40fe04cebe4668c968c74d2d09aa07e4685889c90f6d4ec4345de;
319         vk[5] = 0x1652c73a52779311ca7ffdcd9749e40592780259a9c9e738b63199dad11d7f17;
320         vk[6] = 0x086d1b9a535ffcebe71f045e022967f0c113114c04a1bf944a395c14cce50f49;
321         vk[7] = 0x2b2166f750b92453a4bc000425e93c3c412d911961dcd9050c61368f07673262;
322         vk[8] = 0x12ba168ac5544a1b8c1bd3c47b6d9a1391db76a608e4556b639e0032e2deffbe;
323         vk[9] = 0x2b32a828faf0bb870f693cc8031c166b0063d854c435ea1b516e67ba5a6d8907;
324         vk[10] = 0x100f54919b2e2f9ddaacfae446be3614441bb0e451380ec96658979748613433;
325         vk[11] = 0x066bcceed5d7a04466af77a2af1e9ca005a12f19bc4d7cc8e231354885b82607;
326         vk[12] = 0x28782e5b286bda594b1ad6320c62df3dbfcf4db5043430d19204f46a34fd4119;
327         vk[13] = 0x11b16528236d3aba305c2f3b051b0d88902465da7969d8b6719fbf9dd35dcf2a;
328 
329         gammaABC = new uint256[](8);
330         gammaABC[0] = 0x0f33cb3065f68e121317d06f1424955c5a7e2ec8edebc909aac08a3f17069886;
331         gammaABC[1] = 0x037f77f317232115d1e59c5d751cdfc7cb71860def1eac9c26601ca608818d82;
332         gammaABC[2] = 0x160621974534ddb69577555fb5add3b219fc3d7940d6af98fd0b4d1323e98a02;
333         gammaABC[3] = 0x0f99ebad244805d05f610d8a9e2fb9395fe4159ed19ff545c1663395faf2e54e;
334         gammaABC[4] = 0x252887d8a49ac0d88d097657230f297137e590d836a958c33f6e86737a7b6d5d;
335         gammaABC[5] = 0x303d4a352e156b053325cd397e875076f30a41b8b5cb919c284f76021c95d506;
336         gammaABC[6] = 0x12373b5d89c0ded59c6cff32b0ff93b98a46b0fabc01be54748fbe072c34721e;
337         gammaABC[7] = 0x00c29f8e6d126eff674bede612ba90717ef37c8fa3431309d2bb81dac30871e5;
338 
339 
340     }
341 
342 }
343 
344 contract VerificationKeys is TransferVerificationKey, DepositVerificationKey, ExitVerificationKey {
345 }
346 
347 contract FranklinCommon is VerificationKeys, FranklinStorage, Verifier {
348 
349     modifier active_only() {
350         require(!stopped, "contract should not be globally stopped");
351         _;
352     }
353 
354     modifier operator_only() {
355         require(operators[msg.sender] == true, "sender should be one of the operators");
356         _;
357     }
358 
359     // unit normalization functions
360     function scaleIntoPlasmaUnitsFromWei(uint256 value)
361     public
362     pure
363     returns (uint128) {
364         uint256 den = DENOMINATOR;
365         require(value % den == 0, "amount has higher precision than possible");
366         uint256 scaled = value / den;
367         require(scaled < uint256(1) << 128, "deposit amount is too high");
368         return uint128(scaled);
369     }
370 
371     function scaleFromPlasmaUnitsIntoWei(uint128 value)
372     public
373     pure
374     returns (uint256) {
375         return uint256(value) * DENOMINATOR;
376     }
377 
378     function verifyProof(Circuit circuitType, uint256[8] memory proof, bytes32 oldRoot, bytes32 newRoot, bytes32 finalHash)
379         internal view returns (bool valid)
380     {
381         uint256 mask = (~uint256(0)) >> 3;
382         uint256[14] memory vk;
383         uint256[] memory gammaABC;
384         if (circuitType == Circuit.DEPOSIT) {
385             (vk, gammaABC) = getVkDepositCircuit();
386         } else if (circuitType == Circuit.TRANSFER) {
387             (vk, gammaABC) = getVkTransferCircuit();
388         } else if (circuitType == Circuit.EXIT) {
389             (vk, gammaABC) = getVkExitCircuit();
390         } else {
391             return false;
392         }
393         uint256[] memory inputs = new uint256[](3);
394         inputs[0] = uint256(oldRoot);
395         inputs[1] = uint256(newRoot);
396         inputs[2] = uint256(finalHash) & mask;
397         return Verify(vk, gammaABC, proof, inputs);
398     }
399 
400 }
401 
402 contract FranklinProxy is FranklinCommon {
403 
404     constructor(address _depositor, address _transactor, address _exitor) public {
405         nextAccountToRegister = 2;
406         lastVerifiedRoot = EMPTY_TREE_ROOT;
407         operators[msg.sender] = true;
408         depositor = _depositor;
409         transactor = _transactor;
410         exitor = _exitor;
411 
412     }
413 
414     function deposit(uint256[2] memory, uint128) public payable {
415         callExternal(depositor);
416     }
417 
418     function depositInto(uint24, uint128) public payable {
419         callExternal(depositor);
420     }
421 
422     function cancelDeposit() public {
423         callExternal(depositor);
424     }
425 
426     function startNextDepositBatch() public {
427         callExternal(depositor);
428     }
429 
430     function changeDepositBatchFee(uint128) public {
431         callExternal(depositor);
432     }
433 
434     function commitDepositBlock(uint256, uint24[DEPOSIT_BATCH_SIZE] memory, uint32, bytes32) public {
435         callExternal(depositor);
436     }
437 
438     function verifyDepositBlock(uint256, uint24[DEPOSIT_BATCH_SIZE] memory, uint32, uint256[8] memory) public {
439         callExternal(depositor);
440     } 
441 
442     function commitTransferBlock(uint32, uint128, bytes memory, bytes32) public {
443         callExternal(transactor);
444     }
445 
446     function verifyTransferBlock(uint32, uint256[8] memory) public {
447         callExternal(transactor);
448     }
449 
450     function exit() public payable {
451         callExternal(exitor);
452     }
453 
454     function cancelExit() public {
455         callExternal(exitor);
456     }
457 
458     function startNextExitBatch() public {
459         callExternal(exitor);
460     }
461 
462     function changeExitBatchFee(uint128) public {
463         callExternal(exitor);
464     }
465 
466     function commitExitBlock(uint256, uint24[EXIT_BATCH_SIZE] memory, uint32, bytes memory, bytes32) public {
467         callExternal(exitor);
468     }
469 
470     function verifyExitBlock(uint256, uint32, uint256[8] memory) public {
471         callExternal(exitor);
472     }
473 
474     function withdrawUserBalance(uint256) public {
475         callExternal(exitor);
476     }
477 
478     // this is inline delegate-call to dispatch functions to subcontracts that are responsible for execution
479     function callExternal(address callee) internal {
480         assembly {
481             let memoryPointer := mload(0x40)
482             calldatacopy(memoryPointer, 0, calldatasize)
483             let newFreeMemoryPointer := add(memoryPointer, calldatasize)
484             mstore(0x40, newFreeMemoryPointer)
485             let retVal := delegatecall(sub(gas, 2000), callee, memoryPointer, calldatasize, newFreeMemoryPointer, 0x40)
486             let retDataSize := returndatasize
487             returndatacopy(newFreeMemoryPointer, 0, retDataSize)
488             switch retVal case 0 { revert(newFreeMemoryPointer, returndatasize) } default { return(newFreeMemoryPointer, retDataSize) }
489             //return(newFreeMemoryPointer, retDataSize)
490         }
491     }
492 }
493 
