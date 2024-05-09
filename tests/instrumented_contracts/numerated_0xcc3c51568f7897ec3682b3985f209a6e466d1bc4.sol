1 pragma solidity ^0.4.18;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) public payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) public  payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public  payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) public payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) public payable returns (bytes32 _id);
11     function getPrice(string _datasource) public returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
13     function setProofType(byte _proofType) public;
14     function setConfig(bytes32 _config) public;
15     function setCustomGasPrice(uint _gasPrice) public;
16     function randomDS_getSessionPubKeyHash() public returns(bytes32);
17 }
18 
19 library Math {
20   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
21     return a >= b ? a : b;
22   }
23 
24   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
25     return a < b ? a : b;
26   }
27 
28   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
29     return a >= b ? a : b;
30   }
31 
32   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
33     return a < b ? a : b;
34   }
35 }
36 
37 contract OraclizeAddrResolverI {
38     function getAddress() public returns (address _addr);
39 }
40 
41 contract Priceable {
42     modifier costsExactly(uint price) {
43         if (msg.value == price) {
44             _;
45         }
46     }
47 
48     modifier costs(uint price) {
49         if (msg.value >= price) {
50             _;
51         }
52     }
53 }
54 
55 contract RewardDistributable {
56     event TokensRewarded(address indexed player, address rewardToken, uint rewards, address requester, uint gameId, uint block);
57     event ReferralRewarded(address indexed referrer, address indexed player, address rewardToken, uint rewards, uint gameId, uint block);
58     event ReferralRegistered(address indexed player, address indexed referrer);
59 
60     /// @dev Calculates and transfers the rewards to the player.
61     function transferRewards(address player, uint entryAmount, uint gameId) public;
62 
63     /// @dev Returns the total number of tokens, across all approvals.
64     function getTotalTokens(address tokenAddress) public constant returns(uint);
65 
66     /// @dev Returns the total number of supported reward token contracts.
67     function getRewardTokenCount() public constant returns(uint);
68 
69     /// @dev Gets the total number of approvers.
70     function getTotalApprovers() public constant returns(uint);
71 
72     /// @dev Gets the reward rate inclusive of referral bonus.
73     function getRewardRate(address player, address tokenAddress) public constant returns(uint);
74 
75     /// @dev Adds a requester to the whitelist.
76     /// @param requester The address of a contract which will request reward transfers
77     function addRequester(address requester) public;
78 
79     /// @dev Removes a requester from the whitelist.
80     /// @param requester The address of a contract which will request reward transfers
81     function removeRequester(address requester) public;
82 
83     /// @dev Adds a approver address.  Approval happens with the token contract.
84     /// @param approver The approver address to add to the pool.
85     function addApprover(address approver) public;
86 
87     /// @dev Removes an approver address. 
88     /// @param approver The approver address to remove from the pool.
89     function removeApprover(address approver) public;
90 
91     /// @dev Updates the reward rate
92     function updateRewardRate(address tokenAddress, uint newRewardRate) public;
93 
94     /// @dev Updates the token address of the payment type.
95     function addRewardToken(address tokenAddress, uint newRewardRate) public;
96 
97     /// @dev Updates the token address of the payment type.
98     function removeRewardToken(address tokenAddress) public;
99 
100     /// @dev Updates the referral bonus rate
101     function updateReferralBonusRate(uint newReferralBonusRate) public;
102 
103     /// @dev Registers the player with the given referral code
104     /// @param player The address of the player
105     /// @param referrer The address of the referrer
106     function registerReferral(address player, address referrer) public;
107 
108     /// @dev Transfers any tokens to the owner
109     function destroyRewards() public;
110 }
111 
112 library SafeMath {
113   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114     if (a == 0) {
115       return 0;
116     }
117     uint256 c = a * b;
118     assert(c / a == b);
119     return c;
120   }
121 
122   function div(uint256 a, uint256 b) internal pure returns (uint256) {
123     // assert(b > 0); // Solidity automatically throws when dividing by 0
124     uint256 c = a / b;
125     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126     return c;
127   }
128 
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   function add(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a + b;
136     assert(c >= a);
137     return c;
138   }
139 }
140 
141 library OraclizeLib {
142    
143     struct OraclizeData {
144         OraclizeAddrResolverI oraclizeAddressResolver;
145         OraclizeI oraclize;
146         mapping(bytes32=>bytes32) oraclizeRandomDSArgs;
147         mapping(bytes32=>bool) oraclizeRandomDsSessionKeyHashVerified;
148         string oraclizeNetworkName;
149     }
150 
151     function initializeOraclize(OraclizeData storage self) internal {
152        self.oraclizeAddressResolver = oraclize_setNetwork(self);
153        if (self.oraclizeAddressResolver != address(0)) {
154            self.oraclize = OraclizeI(self.oraclizeAddressResolver.getAddress());
155        }
156     }
157 
158     function oraclize_setNetwork(OraclizeData storage self) public returns(OraclizeAddrResolverI) {
159         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0) { //mainnet
160             oraclize_setNetworkName(self, "eth_mainnet");
161             return OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
162         }
163         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0) { //ropsten testnet
164             oraclize_setNetworkName(self, "eth_ropsten3");
165             return OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
166         }
167         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0) { //kovan testnet
168             oraclize_setNetworkName(self, "eth_kovan");
169             return OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
170         }
171         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0) { //rinkeby testnet
172             oraclize_setNetworkName(self, "eth_rinkeby");
173             return OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
174         }
175         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0) { //ethereum-bridge
176             return OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
177         }
178         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0) { //ether.camp ide
179             return OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
180         }
181         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0) { //browser-solidity
182             return OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
183         }
184     }
185 
186     function oraclize_setNetworkName(OraclizeData storage self, string _network_name) internal {
187         self.oraclizeNetworkName = _network_name;
188     }
189     
190     function oraclize_getNetworkName(OraclizeData storage self) internal constant returns (string) {
191         return self.oraclizeNetworkName;
192     }
193 
194     function oraclize_getPrice(OraclizeData storage self, string datasource) public returns (uint) {
195         return self.oraclize.getPrice(datasource);
196     }
197 
198     function oraclize_getPrice(OraclizeData storage self, string datasource, uint gaslimit) public returns (uint) {
199         return self.oraclize.getPrice(datasource, gaslimit);
200     }
201 
202     function oraclize_query(OraclizeData storage self, string datasource, string arg) public returns (bytes32 id) {
203         return oraclize_query(self, 0, datasource, arg);
204     }
205 
206     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg) public returns (bytes32 id) {
207         uint price = self.oraclize.getPrice(datasource);
208         if (price > 1 ether + tx.gasprice*200000) {
209             return 0; // unexpectedly high price
210         }
211         return self.oraclize.query.value(price)(timestamp, datasource, arg);
212     }
213 
214     function oraclize_query(OraclizeData storage self, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
215         return oraclize_query(self, 0, datasource, arg, gaslimit);
216     }
217 
218     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
219         uint price = self.oraclize.getPrice(datasource, gaslimit);
220         if (price > 1 ether + tx.gasprice*gaslimit) {
221             return 0; // unexpectedly high price
222         }
223         return self.oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
224     }
225 
226     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2) public returns (bytes32 id) {
227         return oraclize_query(self, 0, datasource, arg1, arg2);
228     }
229 
230     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2) public returns (bytes32 id) {
231         uint price = self.oraclize.getPrice(datasource);
232         if (price > 1 ether + tx.gasprice*200000) {
233             return 0; // unexpectedly high price
234         }
235         return self.oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
236     }
237 
238     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
239         return oraclize_query(self, 0, datasource, arg1, arg2, gaslimit);
240     }
241 
242     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
243         uint price = self.oraclize.getPrice(datasource, gaslimit);
244         if (price > 1 ether + tx.gasprice*gaslimit) {
245             return 0; // unexpectedly high price
246         }
247         return self.oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
248     }
249 
250     function oraclize_query(OraclizeData storage self, string datasource, string[] argN) internal returns (bytes32 id) {
251         return oraclize_query(self, 0, datasource, argN);
252     }
253 
254     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN) internal returns (bytes32 id) {
255         uint price = self.oraclize.getPrice(datasource);
256         if (price > 1 ether + tx.gasprice*200000) {
257             return 0; // unexpectedly high price
258         }
259         bytes memory args = stra2cbor(argN);
260         return self.oraclize.queryN.value(price)(timestamp, datasource, args);
261     }
262 
263     function oraclize_query(OraclizeData storage self, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id) {
264         return oraclize_query(self, 0, datasource, argN, gaslimit);
265     }
266 
267     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id){
268         uint price = self.oraclize.getPrice(datasource, gaslimit);
269         if (price > 1 ether + tx.gasprice*gaslimit) {
270             return 0; // unexpectedly high price
271         }
272         bytes memory args = stra2cbor(argN);
273         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
274     }
275 
276      function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, bytes[] argN, uint gaslimit) internal returns (bytes32 id){
277         uint price = self.oraclize.getPrice(datasource, gaslimit);
278         if (price > 1 ether + tx.gasprice*gaslimit) {
279             return 0; // unexpectedly high price
280         }
281         bytes memory args = ba2cbor(argN);
282         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
283     }
284 
285     function oraclize_newRandomDSQuery(OraclizeData storage self, uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32) {
286         assert((_nbytes > 0) && (_nbytes <= 32));
287         bytes memory nbytes = new bytes(1);
288         nbytes[0] = byte(_nbytes);
289         bytes memory unonce = new bytes(32);
290         bytes memory sessionKeyHash = new bytes(32);
291         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash(self);
292         assembly {
293             mstore(unonce, 0x20)
294             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
295             mstore(sessionKeyHash, 0x20)
296             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
297         }
298         bytes[] memory args = new bytes[](3);
299         args[0] = unonce;
300         args[1] = nbytes;
301         args[2] = sessionKeyHash; 
302         bytes32 queryId = oraclize_query(self, _delay, "random", args, _customGasLimit);
303         oraclize_randomDS_setCommitment(self, queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
304         return queryId;
305     }
306 
307      function oraclize_randomDS_proofVerify__main(OraclizeData storage self, bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
308         bool checkok;
309         
310         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
311         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
312         bytes memory keyhash = new bytes(32);
313         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
314         checkok = (keccak256(keyhash) == keccak256(sha256(context_name, queryId)));
315         if (checkok == false) {
316             return false;
317         }
318         
319         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
320         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
321         
322         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
323         checkok = matchBytes32Prefix(sha256(sig1), result);
324         if (checkok == false) {
325             return false;
326         }
327         
328         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
329         // This is to verify that the computed args match with the ones specified in the query.
330         bytes memory commitmentSlice1 = new bytes(8+1+32);
331         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
332         
333         bytes memory sessionPubkey = new bytes(64);
334         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
335         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
336         
337         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
338         if (self.oraclizeRandomDSArgs[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)) {
339             delete self.oraclizeRandomDSArgs[queryId]; //unonce, nbytes and sessionKeyHash match
340         } else {
341             return false;
342         }
343 
344         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
345         bytes memory tosign1 = new bytes(32+8+1+32);
346         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
347         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
348         if (checkok == false) {
349             return false;
350         }
351 
352         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
353         if (self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] == false) {
354             self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
355         }
356         
357         return self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash];
358     }
359 
360     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
361         bool sigok;
362         
363         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
364         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
365         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
366         
367         bytes memory appkey1_pubkey = new bytes(64);
368         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
369         
370         bytes memory tosign2 = new bytes(1+65+32);
371         tosign2[0] = 1; //role
372         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
373         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
374         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
375         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
376         
377         if (sigok == false) {
378             return false;
379         }
380         
381         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
382         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
383         
384         bytes memory tosign3 = new bytes(1+65);
385         tosign3[0] = 0xFE;
386         copyBytes(proof, 3, 65, tosign3, 1);
387         
388         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
389         copyBytes(proof, 3+65, sig3.length, sig3, 0);
390         
391         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
392         
393         return sigok;
394     }
395 
396     function oraclize_randomDS_proofVerify__returnCode(OraclizeData storage self, bytes32 _queryId, string _result, bytes _proof) internal returns (uint8) {
397         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
398         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) {
399             return 1;
400         }
401         bool proofVerified = oraclize_randomDS_proofVerify__main(self, _proof, _queryId, bytes(_result), oraclize_getNetworkName(self));
402         if (proofVerified == false) {
403             return 2;
404         }
405         return 0;
406     }
407     
408     function oraclize_randomDS_setCommitment(OraclizeData storage self, bytes32 queryId, bytes32 commitment) internal {
409         self.oraclizeRandomDSArgs[queryId] = commitment;
410     }
411     
412     function matchBytes32Prefix(bytes32 content, bytes prefix) internal pure returns (bool) {
413         bool match_ = true;
414         
415         for (uint i=0; i<prefix.length; i++) {
416             if (content[i] != prefix[i]) {
417                 match_ = false;
418             }
419         }
420         
421         return match_;
422     }
423 
424     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool) {
425         bool sigok;
426         address signer;
427         
428         bytes32 sigr;
429         bytes32 sigs;
430         
431         bytes memory sigr_ = new bytes(32);
432         uint offset = 4+(uint(dersig[3]) - 0x20);
433         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
434         bytes memory sigs_ = new bytes(32);
435         offset += 32 + 2;
436         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
437 
438         assembly {
439             sigr := mload(add(sigr_, 32))
440             sigs := mload(add(sigs_, 32))
441         }
442         
443         
444         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
445         if (address(keccak256(pubkey)) == signer) {
446             return true;
447         } else {
448             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
449             return (address(keccak256(pubkey)) == signer);
450         }
451     }
452 
453     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
454     // Duplicate Solidity's ecrecover, but catching the CALL return value
455     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
456         // We do our own memory management here. Solidity uses memory offset
457         // 0x40 to store the current end of memory. We write past it (as
458         // writes are memory extensions), but don't update the offset so
459         // Solidity will reuse it. The memory used here is only needed for
460         // this context.
461 
462         // FIXME: inline assembly can't access return values
463         bool ret;
464         address addr;
465 
466         assembly {
467             let size := mload(0x40)
468             mstore(size, hash)
469             mstore(add(size, 32), v)
470             mstore(add(size, 64), r)
471             mstore(add(size, 96), s)
472 
473             // NOTE: we can reuse the request memory because we deal with
474             //       the return code
475             ret := call(3000, 1, 0, size, 128, size, 32)
476             addr := mload(size)
477         }
478   
479         return (ret, addr);
480     }
481     
482     function oraclize_cbAddress(OraclizeData storage self) public constant returns (address) {
483         return self.oraclize.cbAddress();
484     }
485 
486     function oraclize_setProof(OraclizeData storage self, byte proofP) public {
487         return self.oraclize.setProofType(proofP);
488     }
489 
490     function oraclize_setCustomGasPrice(OraclizeData storage self, uint gasPrice) public {
491         return self.oraclize.setCustomGasPrice(gasPrice);
492     }
493 
494     function oraclize_setConfig(OraclizeData storage self, bytes32 config) public {
495         return self.oraclize.setConfig(config);
496     }
497 
498     function getCodeSize(address _addr) public constant returns(uint _size) {
499         assembly {
500             _size := extcodesize(_addr)
501         }
502     }
503     
504     function oraclize_randomDS_getSessionPubKeyHash(OraclizeData storage self) internal returns (bytes32){
505         return self.oraclize.randomDS_getSessionPubKeyHash();
506     }
507 
508     function stra2cbor(string[] arr) internal pure returns (bytes) {
509         uint arrlen = arr.length;
510 
511         // get correct cbor output length
512         uint outputlen = 0;
513         bytes[] memory elemArray = new bytes[](arrlen);
514         for (uint i = 0; i < arrlen; i++) {
515             elemArray[i] = (bytes(arr[i]));
516             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
517         }
518         uint ctr = 0;
519         uint cborlen = arrlen + 0x80;
520         outputlen += byte(cborlen).length;
521         bytes memory res = new bytes(outputlen);
522 
523         while (byte(cborlen).length > ctr) {
524             res[ctr] = byte(cborlen)[ctr];
525             ctr++;
526         }
527         for (i = 0; i < arrlen; i++) {
528             res[ctr] = 0x5F;
529             ctr++;
530             for (uint x = 0; x < elemArray[i].length; x++) {
531                 // if there's a bug with larger strings, this may be the culprit
532                 if (x % 23 == 0) {
533                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
534                     elemcborlen += 0x40;
535                     uint lctr = ctr;
536                     while (byte(elemcborlen).length > ctr - lctr) {
537                         res[ctr] = byte(elemcborlen)[ctr - lctr];
538                         ctr++;
539                     }
540                 }
541                 res[ctr] = elemArray[i][x];
542                 ctr++;
543             }
544             res[ctr] = 0xFF;
545             ctr++;
546         }
547         return res;
548     }
549 
550     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
551             uint arrlen = arr.length;
552 
553             // get correct cbor output length
554             uint outputlen = 0;
555             bytes[] memory elemArray = new bytes[](arrlen);
556             for (uint i = 0; i < arrlen; i++) {
557                 elemArray[i] = (bytes(arr[i]));
558                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
559             }
560             uint ctr = 0;
561             uint cborlen = arrlen + 0x80;
562             outputlen += byte(cborlen).length;
563             bytes memory res = new bytes(outputlen);
564 
565             while (byte(cborlen).length > ctr) {
566                 res[ctr] = byte(cborlen)[ctr];
567                 ctr++;
568             }
569             for (i = 0; i < arrlen; i++) {
570                 res[ctr] = 0x5F;
571                 ctr++;
572                 for (uint x = 0; x < elemArray[i].length; x++) {
573                     // if there's a bug with larger strings, this may be the culprit
574                     if (x % 23 == 0) {
575                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
576                         elemcborlen += 0x40;
577                         uint lctr = ctr;
578                         while (byte(elemcborlen).length > ctr - lctr) {
579                             res[ctr] = byte(elemcborlen)[ctr - lctr];
580                             ctr++;
581                         }
582                     }
583                     res[ctr] = elemArray[i][x];
584                     ctr++;
585                 }
586                 res[ctr] = 0xFF;
587                 ctr++;
588             }
589             return res;
590         }
591 
592     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
593         uint minLength = length + toOffset;
594 
595         assert (to.length >= minLength);
596 
597         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
598         uint i = 32 + fromOffset;
599         uint j = 32 + toOffset;
600 
601         while (i < (32 + fromOffset + length)) {
602             assembly {
603                 let tmp := mload(add(from, i))
604                 mstore(add(to, j), tmp)
605             }
606             i += 32;
607             j += 32;
608         }
609 
610         return to;
611     }
612 }
613 
614 contract Ownable {
615   address public owner;
616 
617 
618   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
619 
620 
621   /**
622    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
623    * account.
624    */
625   function Ownable() public {
626     owner = msg.sender;
627   }
628 
629 
630   /**
631    * @dev Throws if called by any account other than the owner.
632    */
633   modifier onlyOwner() {
634     require(msg.sender == owner);
635     _;
636   }
637 
638 
639   /**
640    * @dev Allows the current owner to transfer control of the contract to a newOwner.
641    * @param newOwner The address to transfer ownership to.
642    */
643   function transferOwnership(address newOwner) public onlyOwner {
644     require(newOwner != address(0));
645     OwnershipTransferred(owner, newOwner);
646     owner = newOwner;
647   }
648 
649 }
650 
651 contract Cascading is Ownable {
652     using SafeMath for uint256;
653 
654     struct Cascade {
655         address cascade;
656         uint16 percentage;
657     }
658 
659     uint public totalCascadingPercentage;
660     Cascade[] public cascades;    
661 
662     /// @dev Adds an address and associated percentage for transfer.
663     /// @param newAddress The new address
664     function addCascade(address newAddress, uint newPercentage) public onlyOwner {
665         cascades.push(Cascade(newAddress, uint16(newPercentage)));
666         totalCascadingPercentage += newPercentage;
667     }
668 
669     /// @dev Deletes an address and associated percentage at the given index.
670     /// @param index The index of the cascade to be deleted.
671     function deleteCascade(uint index) public onlyOwner {
672         require(index < cascades.length);
673         
674         totalCascadingPercentage -= cascades[index].percentage;
675 
676         cascades[index] = cascades[cascades.length - 1];
677         delete cascades[cascades.length - 1];
678         cascades.length--;
679     }
680 
681     /// @dev Transfers the cascade values to the assigned addresses
682     /// @param totalJackpot the total jackpot amount
683     function transferCascades(uint totalJackpot) internal {
684         for (uint i = 0; i < cascades.length; i++) {
685             uint cascadeTotal = getCascadeTotal(cascades[i].percentage, totalJackpot);
686 
687             // Should be safe from re-entry given gas limit of 2300.
688             cascades[i].cascade.transfer(cascadeTotal);
689         }
690     }
691 
692     /// @dev Gets the cascade total for the given percentage
693     /// @param percentage the percentage of the total pot as a uint
694     /// @param totalJackpot the total jackpot amount
695     /// @return the total amount the percentage represents
696     function getCascadeTotal(uint percentage, uint totalJackpot) internal pure returns(uint) {
697         return totalJackpot.mul(percentage).div(100);        
698     }
699    
700     /// A utility method to calculate the total after cascades have been applied.
701     /// @param totalJackpot the total jackpot amount
702     /// @return the total amount after the cascades have been applied
703     function getTotalAfterCascades(uint totalJackpot) internal constant returns (uint) {
704         uint cascadeTotal = getCascadeTotal(totalCascadingPercentage, totalJackpot);
705         return totalJackpot.sub(cascadeTotal);
706     }
707 }
708 
709 contract SafeWinner is Ownable {
710     using SafeMath for uint256;
711 
712     mapping(address => uint) public pendingPayments;
713     address[] public pendingWinners;
714     uint public totalPendingPayments;
715 
716     event WinnerWithdrew(address indexed winner, uint amount, uint block);
717 
718     /// @dev records the winner so that a transfer or withdraw can occur at 
719     /// a later date.
720     function addPendingWinner(address winner, uint amount) internal {
721         pendingPayments[winner] = pendingPayments[winner].add(amount);
722         totalPendingPayments = totalPendingPayments.add(amount);
723         pendingWinners.push(winner);
724     }
725 
726     /// @dev allows a winner to withdraw their rightful jackpot.
727     function withdrawWinnings() public {
728         address winner = msg.sender;
729         uint payment = pendingPayments[winner];
730 
731         require(payment > 0);
732         require(this.balance >= payment);
733 
734         transferPending(winner, payment);
735     }
736 
737     /// @dev Retries all pending winners
738     function retryWinners() public onlyOwner {
739         for (uint i = 0; i < pendingWinners.length; i++) {
740             retryWinner(i);
741         }
742 
743         pendingWinners.length = 0;
744     }
745 
746     function retryWinner(uint index) public onlyOwner {
747         address winner = pendingWinners[index];
748         uint payment = pendingPayments[winner];
749         require(this.balance >= payment);
750         if (payment != 0) {
751             transferPending(winner, payment);
752         }
753     }
754 
755     function transferPending(address winner, uint256 payment) internal {
756         totalPendingPayments = totalPendingPayments.sub(payment);
757         pendingPayments[winner] = 0;
758         winner.transfer(payment);        
759         WinnerWithdrew(winner, payment, block.number);
760     }
761 }
762 
763 contract Raffle is Ownable, Priceable, SafeWinner, Cascading {
764   using SafeMath for uint256;
765   using OraclizeLib for OraclizeLib.OraclizeData;
766 
767   enum RaffleState { Active, InActive, PendingInActive }
768   enum RandomSource { RandomDS, Qrng }
769 
770   struct Jackpot {
771     uint absoluteTotal;
772     uint feeTotal;
773     uint cascadeTotal;
774     uint winnerTotal;
775   }
776 
777   struct TicketHolder {
778     address purchaser;
779     uint16 count;
780     uint80 runningTotal;
781   }
782   
783   // public
784   RaffleState public raffleState;
785   RandomSource public randomSource;
786   uint public ticketPrice;
787   uint public gameId;
788   uint public fee;
789   
790 
791   // internal
792   TicketHolder[] internal ticketHolders;
793   uint internal randomBytes;
794   uint internal randomQueried;
795   uint internal callbackGas;
796   RewardDistributable internal rewardDistributor;
797 
798   // oraclize
799   OraclizeLib.OraclizeData oraclizeData;
800 
801   // events
802   event TicketPurchased(address indexed ticketPurchaser, uint indexed id, uint numTickets, uint totalCost, uint block);
803   event WinnerSelected(address indexed winner, uint indexed id, uint winnings, uint block);
804   event RandomProofFailed(bytes32 queryId, uint indexed id, uint block);
805 
806   function Raffle(uint _ticketPrice, address _rewardDistributor) public {
807     ticketPrice = _ticketPrice;
808     raffleState = RaffleState.Active;
809     callbackGas = 200000;
810     randomBytes = 8;
811     fee = 5 finney;
812     rewardDistributor = RewardDistributable(_rewardDistributor);
813     oraclizeData.initializeOraclize();
814     randomSource = RandomSource.Qrng;
815     resetRaffle();
816   }
817 
818   /// @dev Returns whether the game is active.
819   function isActive() public constant returns (bool) {
820     return raffleState == RaffleState.Active || raffleState == RaffleState.PendingInActive;
821   }
822   
823   /// @dev Fallback function to purchase a single ticket.
824   function () public payable {
825   }
826    
827   /// @dev Gets the projected jackpot.
828   /// @return The projected jackpot amount.
829   function getProjectedJackpot() public constant returns (uint) {
830     uint jackpot = getAbsoluteProjectedJackpot();
831     Jackpot memory totals = getJackpotTotals(jackpot);
832     return totals.winnerTotal;
833   }
834 
835   /// @dev Gets the actual jackpot
836   /// @return The actual jackpot amount.
837   function getJackpot() public constant returns (uint) {
838     uint jackpot = getAbsoluteJackpot();
839     Jackpot memory totals = getJackpotTotals(jackpot);
840     return totals.winnerTotal;
841   }
842 
843   /// @dev Gets the ticket holder count
844   /// @return The total ticket holder count
845   function getTicketHolderCount() public constant returns (uint) {
846     return getTotalTickets();
847   }
848 
849   /// @dev Updates the ticket price.
850   function updateTicketPrice(uint updatedPrice) public onlyOwner {
851     require(raffleState == RaffleState.InActive);
852     require(updatedPrice > 0);
853     ticketPrice = updatedPrice;
854   }
855 
856   /// @dev Updates the ticket price.
857   function updateFee(uint updatedFee) public onlyOwner {
858     require(updatedFee > 0);
859     fee = updatedFee;
860   }
861 
862   /// @dev Deactivates the raffle after the next game.
863   function deactivate() public onlyOwner {
864     require(raffleState == RaffleState.Active);
865     raffleState = ticketHolders.length == 0 ? RaffleState.InActive : RaffleState.PendingInActive;
866   }
867 
868   /// @dev Activates the raffle, if inactivated.
869   function activate() public onlyOwner {
870     require(raffleState == RaffleState.InActive);
871     raffleState = RaffleState.Active;
872   }
873 
874   /// The oraclize callback function.
875   function __callback(bytes32 queryId, string result, bytes proof) public {
876     require(msg.sender == oraclizeData.oraclize_cbAddress());
877     
878     // We only expect this for this callback
879     if (oraclizeData.oraclize_randomDS_proofVerify__returnCode(queryId, result, proof) != 0) {
880       RandomProofFailed(queryId, gameId, now);
881       randomQueried = 0;
882       return;
883     }
884 
885     __callback(queryId, result);
886   }
887 
888   /// The oraclize callback function.
889   function __callback(bytes32 queryId, string result) public {
890     require(msg.sender == oraclizeData.oraclize_cbAddress());
891     
892     // Guard against the case where oraclize is triggered, or calls back multiple times.
893     if (!shouldChooseWinner()) {
894       return;
895     }
896 
897     uint maxRange = 2**(8*randomBytes); 
898     uint randomNumber = uint(keccak256(result)) % maxRange; 
899     winnerSelected(randomNumber);
900   }
901 
902   /// @dev An administrative function to allow in case the proof fails or 
903   /// a random winner needs to be chosen again.
904   function forceChooseRandomWinner() public onlyOwner {
905     require(raffleState != RaffleState.InActive);
906     executeRandomQuery();
907   }
908 
909   /// @dev Forces a refund for all participants and deactivates the contract
910   /// This offers a full refund, so it will be up to the owner to ensure a full balance.
911   function forceRefund() public onlyOwner {
912     raffleState = RaffleState.PendingInActive;
913 
914     uint total = getTotalTickets() * ticketPrice;
915     require(this.balance > total);
916 
917     for (uint i = 0; i < ticketHolders.length; i++) {
918       TicketHolder storage holder = ticketHolders[i];
919       holder.purchaser.transfer(uint256(holder.count).mul(ticketPrice));
920     }
921 
922     resetRaffle();
923   }
924 
925   /// @dev Destroys the current contract and moves all ETH back to  
926   function updateRewardDistributor(address newRewardDistributor) public onlyOwner {
927     rewardDistributor = RewardDistributable(newRewardDistributor);
928   }
929 
930   /// @dev Destroys the current contract and moves all ETH back to
931   /// owner. Only can occur after state has been set to inactive.
932   function destroy() public onlyOwner {
933     require(raffleState == RaffleState.InActive);
934     selfdestruct(owner);
935   }
936 
937   /// Gets the projected jackpot prior to any fees
938   /// @return The projected jackpot prior to any fees
939   function getAbsoluteProjectedJackpot() internal constant returns (uint);
940 
941   /// Gets the actual jackpot prior to any fees
942   /// @return The actual jackpot amount prior to any fees.
943   function getAbsoluteJackpot() internal constant returns (uint);
944   
945   /// An abstract function which determines whether a it is appropriate to choose a winner.
946   /// @return True if it is appropriate to choose the winner, false otherwise.
947   function shouldChooseWinner() internal returns (bool);
948 
949   function executeRandomQuery() internal {
950     if (randomSource == RandomSource.RandomDS) {
951       oraclizeData.oraclize_newRandomDSQuery(0, randomBytes, callbackGas);
952     }
953     else {
954       oraclizeData.oraclize_query("URL","json(https://qrng.anu.edu.au/API/jsonI.php?length=1&type=hex16&size=32).data[0]", callbackGas);
955     }
956   }
957 
958   /// Chooses the winner at random.
959   function chooseWinner() internal {
960     // We build in a buffer of 20 blocks.  Approx 1 block per 15 secs ~ 5 mins
961     // the last time random was queried, we'll execute again.
962     if (randomQueried < (block.number.sub(20))) {
963       executeRandomQuery();
964       randomQueried = block.number;
965     }
966   }
967 
968   /// Internal function for when a winner is chosen.
969   function winnerSelected(uint randomNumber) internal {
970     TicketHolder memory winner = getWinningTicketHolder(randomNumber);
971     uint jackpot = getAbsoluteJackpot();
972     Jackpot memory jackpotTotals = getJackpotTotals(jackpot);
973 
974     WinnerSelected(winner.purchaser, gameId, jackpotTotals.winnerTotal, now);    
975     transferJackpot(winner.purchaser, jackpotTotals.winnerTotal);
976     transferCascades(jackpotTotals.absoluteTotal);
977     resetRaffle();
978   }
979 
980   function getWinningTicketHolder(uint randomNumber) internal view returns(TicketHolder) {
981     assert(ticketHolders.length > 0);
982     uint totalTickets = getTotalTickets();
983     uint winner = (randomNumber % totalTickets) + 1;
984 
985     uint min = 0;
986     uint max = ticketHolders.length-1;
987     while (max > min) {
988         uint mid = (max + min + 1) / 2;
989         if (ticketHolders[mid].runningTotal >= winner &&
990          (ticketHolders[mid].runningTotal-ticketHolders[mid].count) < winner) {
991            return ticketHolders[mid];
992         }
993 
994         if (ticketHolders[mid].runningTotal <= winner) {
995             min = mid;
996         } else {
997             max = mid-1;
998         }
999     }
1000 
1001     return ticketHolders[min];
1002   }
1003 
1004   /// Transfers the jackpot to the winner triggering the event
1005   function transferJackpot(address winner, uint jackpot) internal returns(uint) {
1006     // We explicitly do not use transfer here because if the 
1007     // the call fails, the oraclize contract will not retry.
1008     bool sendSuccessful = winner.send(jackpot);
1009     if (!sendSuccessful) {
1010       addPendingWinner(winner, jackpot);
1011     }
1012 
1013     return jackpot;
1014   }
1015 
1016   /// Resets the raffle game state.
1017   function resetRaffle() internal {
1018     if (raffleState == RaffleState.PendingInActive) {
1019       raffleState = RaffleState.InActive;
1020     }
1021     ticketHolders.length = 0;
1022     gameId = block.number;
1023     randomQueried = 0;
1024   }
1025 
1026   /// Gets the jackpot after fees
1027   function getJackpotTotals(uint jackpot) internal constant returns(Jackpot) {
1028     if (jackpot < fee) {
1029       return Jackpot(0, 0, 0, 0);
1030     }
1031 
1032     uint cascadeTotal = getCascadeTotal(totalCascadingPercentage, jackpot);
1033     return Jackpot(jackpot, fee, cascadeTotal, jackpot.sub(fee).sub(cascadeTotal));
1034   }
1035 
1036   function updateRandomSource(uint newRandomSource) public onlyOwner {
1037     if (newRandomSource == 1) {
1038       randomSource = RandomSource.RandomDS;
1039     } else {
1040       randomSource = RandomSource.Qrng;
1041     }
1042 
1043     setProof();
1044   }
1045 
1046 
1047   function setProof() internal {
1048       if (randomSource == RandomSource.RandomDS) {
1049         // proofType_Ledger = 0x30;
1050         oraclizeData.oraclize_setProof(0x30);
1051       }
1052       else {
1053         oraclizeData.oraclize_setProof(0x00);
1054       }
1055   }
1056 
1057   function getTotalTickets() internal view returns(uint) {
1058     return ticketHolders.length == 0 ? 0 : ticketHolders[ticketHolders.length-1].runningTotal;
1059   }
1060 
1061   function updateOraclizeGas(uint newCallbackGas, uint customGasPrice) public onlyOwner {
1062     callbackGas = newCallbackGas;
1063     updateCustomGasPrice(customGasPrice);
1064   }
1065 
1066   function updateCustomGasPrice(uint customGasPrice) internal {
1067     oraclizeData.oraclize_setCustomGasPrice(customGasPrice);
1068   }
1069 }
1070 
1071 contract CountBasedRaffle is Raffle {
1072   
1073   uint public drawTicketCount;
1074 
1075   /// @dev Constructor for conventional raffle
1076   /// @param _ticketPrice The ticket price.
1077   /// @param _drawTicketCount The number of tickets for a draw to take place.
1078   function CountBasedRaffle(uint _ticketPrice, uint _drawTicketCount, address _rewardDistributor) Raffle(_ticketPrice, _rewardDistributor) public {
1079     drawTicketCount = _drawTicketCount;
1080   }
1081 
1082   /// @dev Gets the projected jackpot.
1083   function getAbsoluteProjectedJackpot() internal constant returns (uint) {
1084     uint totalTicketCount = getTotalTickets();
1085     uint ticketCount = drawTicketCount > totalTicketCount ? drawTicketCount : totalTicketCount;
1086     return ticketCount.mul(ticketPrice); 
1087   }
1088 
1089   /// @dev Gets the actual jackpot
1090   function getAbsoluteJackpot() internal constant returns (uint) {
1091     if (ticketHolders.length == 0) {
1092       return 0;
1093     }
1094 
1095     return this.balance.sub(totalPendingPayments);
1096   }
1097 
1098     /* @dev Purchases tickets to the raffle.
1099   * @param numTickets Number of tickets to purchase.
1100   * @param referrer The address of the referrer.
1101   */
1102   function purchaseTicket(uint numTickets, address referrer) public payable costsExactly(numTickets.mul(ticketPrice)) {
1103     require(raffleState != RaffleState.InActive);
1104     require(numTickets < drawTicketCount);
1105 
1106     // Add the address to the ticketHolders.
1107     uint totalTickets = getTotalTickets();
1108     ticketHolders.push(TicketHolder(msg.sender, uint16(numTickets), uint80(totalTickets.add(numTickets))));
1109     TicketPurchased(msg.sender, gameId, numTickets, ticketPrice.mul(numTickets), now);
1110     if (rewardDistributor != address(0)) {
1111       rewardDistributor.registerReferral(msg.sender, referrer);
1112       rewardDistributor.transferRewards(msg.sender, msg.value, gameId);
1113     }
1114 
1115     if (shouldChooseWinner()) {
1116       chooseWinner();
1117     }
1118   }
1119   
1120   /// An abstract function which determines whether a it is appropriate to choose a winner.
1121   /// @return True if it is appropriate to choose the winner, false otherwise.
1122   function shouldChooseWinner() internal returns (bool) {
1123     return getTotalTickets() >= drawTicketCount;
1124   }
1125 }
1126 
1127 contract BronzeRaffle is CountBasedRaffle {
1128 
1129   /// @dev Constructor for conventional raffle
1130   /// Should total jackpot of ~ 0.4 ETH
1131   function BronzeRaffle(address _rewardDistributor) CountBasedRaffle(20 finney, 15, _rewardDistributor) public {
1132   }
1133 }