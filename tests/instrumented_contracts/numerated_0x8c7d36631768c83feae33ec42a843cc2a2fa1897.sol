1 pragma solidity ^0.4.18;
2 
3 contract OraclizeAddrResolverI {
4     function getAddress() public returns (address _addr);
5 }
6 
7 library OraclizeLib {
8    
9     struct OraclizeData {
10         OraclizeAddrResolverI oraclizeAddressResolver;
11         OraclizeI oraclize;
12         mapping(bytes32=>bytes32) oraclizeRandomDSArgs;
13         mapping(bytes32=>bool) oraclizeRandomDsSessionKeyHashVerified;
14         string oraclizeNetworkName;
15     }
16 
17     function initializeOraclize(OraclizeData storage self) internal {
18        self.oraclizeAddressResolver = oraclize_setNetwork(self);
19        if (self.oraclizeAddressResolver != address(0)) {
20            self.oraclize = OraclizeI(self.oraclizeAddressResolver.getAddress());
21        }
22     }
23 
24     function oraclize_setNetwork(OraclizeData storage self) public returns(OraclizeAddrResolverI) {
25         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0) { //mainnet
26             oraclize_setNetworkName(self, "eth_mainnet");
27             return OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
28         }
29         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0) { //ropsten testnet
30             oraclize_setNetworkName(self, "eth_ropsten3");
31             return OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
32         }
33         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0) { //kovan testnet
34             oraclize_setNetworkName(self, "eth_kovan");
35             return OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
36         }
37         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0) { //rinkeby testnet
38             oraclize_setNetworkName(self, "eth_rinkeby");
39             return OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
40         }
41         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0) { //ethereum-bridge
42             return OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
43         }
44         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0) { //ether.camp ide
45             return OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
46         }
47         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0) { //browser-solidity
48             return OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
49         }
50     }
51 
52     function oraclize_setNetworkName(OraclizeData storage self, string _network_name) internal {
53         self.oraclizeNetworkName = _network_name;
54     }
55     
56     function oraclize_getNetworkName(OraclizeData storage self) internal constant returns (string) {
57         return self.oraclizeNetworkName;
58     }
59 
60     function oraclize_getPrice(OraclizeData storage self, string datasource) public returns (uint) {
61         return self.oraclize.getPrice(datasource);
62     }
63 
64     function oraclize_getPrice(OraclizeData storage self, string datasource, uint gaslimit) public returns (uint) {
65         return self.oraclize.getPrice(datasource, gaslimit);
66     }
67 
68     function oraclize_query(OraclizeData storage self, string datasource, string arg) public returns (bytes32 id) {
69         return oraclize_query(self, 0, datasource, arg);
70     }
71 
72     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg) public returns (bytes32 id) {
73         uint price = self.oraclize.getPrice(datasource);
74         if (price > 1 ether + tx.gasprice*200000) {
75             return 0; // unexpectedly high price
76         }
77         return self.oraclize.query.value(price)(timestamp, datasource, arg);
78     }
79 
80     function oraclize_query(OraclizeData storage self, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
81         return oraclize_query(self, 0, datasource, arg, gaslimit);
82     }
83 
84     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
85         uint price = self.oraclize.getPrice(datasource, gaslimit);
86         if (price > 1 ether + tx.gasprice*gaslimit) {
87             return 0; // unexpectedly high price
88         }
89         return self.oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
90     }
91 
92     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2) public returns (bytes32 id) {
93         return oraclize_query(self, 0, datasource, arg1, arg2);
94     }
95 
96     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2) public returns (bytes32 id) {
97         uint price = self.oraclize.getPrice(datasource);
98         if (price > 1 ether + tx.gasprice*200000) {
99             return 0; // unexpectedly high price
100         }
101         return self.oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
102     }
103 
104     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
105         return oraclize_query(self, 0, datasource, arg1, arg2, gaslimit);
106     }
107 
108     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
109         uint price = self.oraclize.getPrice(datasource, gaslimit);
110         if (price > 1 ether + tx.gasprice*gaslimit) {
111             return 0; // unexpectedly high price
112         }
113         return self.oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
114     }
115 
116     function oraclize_query(OraclizeData storage self, string datasource, string[] argN) internal returns (bytes32 id) {
117         return oraclize_query(self, 0, datasource, argN);
118     }
119 
120     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN) internal returns (bytes32 id) {
121         uint price = self.oraclize.getPrice(datasource);
122         if (price > 1 ether + tx.gasprice*200000) {
123             return 0; // unexpectedly high price
124         }
125         bytes memory args = stra2cbor(argN);
126         return self.oraclize.queryN.value(price)(timestamp, datasource, args);
127     }
128 
129     function oraclize_query(OraclizeData storage self, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id) {
130         return oraclize_query(self, 0, datasource, argN, gaslimit);
131     }
132 
133     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id){
134         uint price = self.oraclize.getPrice(datasource, gaslimit);
135         if (price > 1 ether + tx.gasprice*gaslimit) {
136             return 0; // unexpectedly high price
137         }
138         bytes memory args = stra2cbor(argN);
139         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
140     }
141 
142      function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, bytes[] argN, uint gaslimit) internal returns (bytes32 id){
143         uint price = self.oraclize.getPrice(datasource, gaslimit);
144         if (price > 1 ether + tx.gasprice*gaslimit) {
145             return 0; // unexpectedly high price
146         }
147         bytes memory args = ba2cbor(argN);
148         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
149     }
150 
151     function oraclize_newRandomDSQuery(OraclizeData storage self, uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32) {
152         assert((_nbytes > 0) && (_nbytes <= 32));
153         bytes memory nbytes = new bytes(1);
154         nbytes[0] = byte(_nbytes);
155         bytes memory unonce = new bytes(32);
156         bytes memory sessionKeyHash = new bytes(32);
157         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash(self);
158         assembly {
159             mstore(unonce, 0x20)
160             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
161             mstore(sessionKeyHash, 0x20)
162             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
163         }
164         bytes[] memory args = new bytes[](3);
165         args[0] = unonce;
166         args[1] = nbytes;
167         args[2] = sessionKeyHash; 
168         bytes32 queryId = oraclize_query(self, _delay, "random", args, _customGasLimit);
169         oraclize_randomDS_setCommitment(self, queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
170         return queryId;
171     }
172 
173      function oraclize_randomDS_proofVerify__main(OraclizeData storage self, bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
174         bool checkok;
175         
176         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
177         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
178         bytes memory keyhash = new bytes(32);
179         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
180         checkok = (keccak256(keyhash) == keccak256(sha256(context_name, queryId)));
181         if (checkok == false) {
182             return false;
183         }
184         
185         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
186         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
187         
188         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
189         checkok = matchBytes32Prefix(sha256(sig1), result);
190         if (checkok == false) {
191             return false;
192         }
193         
194         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
195         // This is to verify that the computed args match with the ones specified in the query.
196         bytes memory commitmentSlice1 = new bytes(8+1+32);
197         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
198         
199         bytes memory sessionPubkey = new bytes(64);
200         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
201         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
202         
203         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
204         if (self.oraclizeRandomDSArgs[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)) {
205             delete self.oraclizeRandomDSArgs[queryId]; //unonce, nbytes and sessionKeyHash match
206         } else {
207             return false;
208         }
209 
210         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
211         bytes memory tosign1 = new bytes(32+8+1+32);
212         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
213         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
214         if (checkok == false) {
215             return false;
216         }
217 
218         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
219         if (self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] == false) {
220             self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
221         }
222         
223         return self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash];
224     }
225 
226     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
227         bool sigok;
228         
229         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
230         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
231         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
232         
233         bytes memory appkey1_pubkey = new bytes(64);
234         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
235         
236         bytes memory tosign2 = new bytes(1+65+32);
237         tosign2[0] = 1; //role
238         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
239         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
240         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
241         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
242         
243         if (sigok == false) {
244             return false;
245         }
246         
247         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
248         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
249         
250         bytes memory tosign3 = new bytes(1+65);
251         tosign3[0] = 0xFE;
252         copyBytes(proof, 3, 65, tosign3, 1);
253         
254         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
255         copyBytes(proof, 3+65, sig3.length, sig3, 0);
256         
257         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
258         
259         return sigok;
260     }
261 
262     function oraclize_randomDS_proofVerify__returnCode(OraclizeData storage self, bytes32 _queryId, string _result, bytes _proof) internal returns (uint8) {
263         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
264         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) {
265             return 1;
266         }
267         bool proofVerified = oraclize_randomDS_proofVerify__main(self, _proof, _queryId, bytes(_result), oraclize_getNetworkName(self));
268         if (proofVerified == false) {
269             return 2;
270         }
271         return 0;
272     }
273     
274     function oraclize_randomDS_setCommitment(OraclizeData storage self, bytes32 queryId, bytes32 commitment) internal {
275         self.oraclizeRandomDSArgs[queryId] = commitment;
276     }
277     
278     function matchBytes32Prefix(bytes32 content, bytes prefix) internal pure returns (bool) {
279         bool match_ = true;
280         
281         for (uint i=0; i<prefix.length; i++) {
282             if (content[i] != prefix[i]) {
283                 match_ = false;
284             }
285         }
286         
287         return match_;
288     }
289 
290     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool) {
291         bool sigok;
292         address signer;
293         
294         bytes32 sigr;
295         bytes32 sigs;
296         
297         bytes memory sigr_ = new bytes(32);
298         uint offset = 4+(uint(dersig[3]) - 0x20);
299         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
300         bytes memory sigs_ = new bytes(32);
301         offset += 32 + 2;
302         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
303 
304         assembly {
305             sigr := mload(add(sigr_, 32))
306             sigs := mload(add(sigs_, 32))
307         }
308         
309         
310         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
311         if (address(keccak256(pubkey)) == signer) {
312             return true;
313         } else {
314             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
315             return (address(keccak256(pubkey)) == signer);
316         }
317     }
318 
319     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
320     // Duplicate Solidity's ecrecover, but catching the CALL return value
321     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
322         // We do our own memory management here. Solidity uses memory offset
323         // 0x40 to store the current end of memory. We write past it (as
324         // writes are memory extensions), but don't update the offset so
325         // Solidity will reuse it. The memory used here is only needed for
326         // this context.
327 
328         // FIXME: inline assembly can't access return values
329         bool ret;
330         address addr;
331 
332         assembly {
333             let size := mload(0x40)
334             mstore(size, hash)
335             mstore(add(size, 32), v)
336             mstore(add(size, 64), r)
337             mstore(add(size, 96), s)
338 
339             // NOTE: we can reuse the request memory because we deal with
340             //       the return code
341             ret := call(3000, 1, 0, size, 128, size, 32)
342             addr := mload(size)
343         }
344   
345         return (ret, addr);
346     }
347     
348     function oraclize_cbAddress(OraclizeData storage self) public constant returns (address) {
349         return self.oraclize.cbAddress();
350     }
351 
352     function oraclize_setProof(OraclizeData storage self, byte proofP) public {
353         return self.oraclize.setProofType(proofP);
354     }
355 
356     function oraclize_setCustomGasPrice(OraclizeData storage self, uint gasPrice) public {
357         return self.oraclize.setCustomGasPrice(gasPrice);
358     }
359 
360     function oraclize_setConfig(OraclizeData storage self, bytes32 config) public {
361         return self.oraclize.setConfig(config);
362     }
363 
364     function getCodeSize(address _addr) public constant returns(uint _size) {
365         assembly {
366             _size := extcodesize(_addr)
367         }
368     }
369     
370     function oraclize_randomDS_getSessionPubKeyHash(OraclizeData storage self) internal returns (bytes32){
371         return self.oraclize.randomDS_getSessionPubKeyHash();
372     }
373 
374     function stra2cbor(string[] arr) internal pure returns (bytes) {
375         uint arrlen = arr.length;
376 
377         // get correct cbor output length
378         uint outputlen = 0;
379         bytes[] memory elemArray = new bytes[](arrlen);
380         for (uint i = 0; i < arrlen; i++) {
381             elemArray[i] = (bytes(arr[i]));
382             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
383         }
384         uint ctr = 0;
385         uint cborlen = arrlen + 0x80;
386         outputlen += byte(cborlen).length;
387         bytes memory res = new bytes(outputlen);
388 
389         while (byte(cborlen).length > ctr) {
390             res[ctr] = byte(cborlen)[ctr];
391             ctr++;
392         }
393         for (i = 0; i < arrlen; i++) {
394             res[ctr] = 0x5F;
395             ctr++;
396             for (uint x = 0; x < elemArray[i].length; x++) {
397                 // if there's a bug with larger strings, this may be the culprit
398                 if (x % 23 == 0) {
399                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
400                     elemcborlen += 0x40;
401                     uint lctr = ctr;
402                     while (byte(elemcborlen).length > ctr - lctr) {
403                         res[ctr] = byte(elemcborlen)[ctr - lctr];
404                         ctr++;
405                     }
406                 }
407                 res[ctr] = elemArray[i][x];
408                 ctr++;
409             }
410             res[ctr] = 0xFF;
411             ctr++;
412         }
413         return res;
414     }
415 
416     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
417             uint arrlen = arr.length;
418 
419             // get correct cbor output length
420             uint outputlen = 0;
421             bytes[] memory elemArray = new bytes[](arrlen);
422             for (uint i = 0; i < arrlen; i++) {
423                 elemArray[i] = (bytes(arr[i]));
424                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
425             }
426             uint ctr = 0;
427             uint cborlen = arrlen + 0x80;
428             outputlen += byte(cborlen).length;
429             bytes memory res = new bytes(outputlen);
430 
431             while (byte(cborlen).length > ctr) {
432                 res[ctr] = byte(cborlen)[ctr];
433                 ctr++;
434             }
435             for (i = 0; i < arrlen; i++) {
436                 res[ctr] = 0x5F;
437                 ctr++;
438                 for (uint x = 0; x < elemArray[i].length; x++) {
439                     // if there's a bug with larger strings, this may be the culprit
440                     if (x % 23 == 0) {
441                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
442                         elemcborlen += 0x40;
443                         uint lctr = ctr;
444                         while (byte(elemcborlen).length > ctr - lctr) {
445                             res[ctr] = byte(elemcborlen)[ctr - lctr];
446                             ctr++;
447                         }
448                     }
449                     res[ctr] = elemArray[i][x];
450                     ctr++;
451                 }
452                 res[ctr] = 0xFF;
453                 ctr++;
454             }
455             return res;
456         }
457 
458     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
459         uint minLength = length + toOffset;
460 
461         assert (to.length >= minLength);
462 
463         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
464         uint i = 32 + fromOffset;
465         uint j = 32 + toOffset;
466 
467         while (i < (32 + fromOffset + length)) {
468             assembly {
469                 let tmp := mload(add(from, i))
470                 mstore(add(to, j), tmp)
471             }
472             i += 32;
473             j += 32;
474         }
475 
476         return to;
477     }
478 }
479 
480 library Math {
481   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
482     return a >= b ? a : b;
483   }
484 
485   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
486     return a < b ? a : b;
487   }
488 
489   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
490     return a >= b ? a : b;
491   }
492 
493   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
494     return a < b ? a : b;
495   }
496 }
497 
498 contract RewardDistributable {
499     event TokensRewarded(address indexed player, address rewardToken, uint rewards, address requester, uint gameId, uint block);
500     event ReferralRewarded(address indexed referrer, address indexed player, address rewardToken, uint rewards, uint gameId, uint block);
501     event ReferralRegistered(address indexed player, address indexed referrer);
502 
503     /// @dev Calculates and transfers the rewards to the player.
504     function transferRewards(address player, uint entryAmount, uint gameId) public;
505 
506     /// @dev Returns the total number of tokens, across all approvals.
507     function getTotalTokens(address tokenAddress) public constant returns(uint);
508 
509     /// @dev Returns the total number of supported reward token contracts.
510     function getRewardTokenCount() public constant returns(uint);
511 
512     /// @dev Gets the total number of approvers.
513     function getTotalApprovers() public constant returns(uint);
514 
515     /// @dev Gets the reward rate inclusive of referral bonus.
516     function getRewardRate(address player, address tokenAddress) public constant returns(uint);
517 
518     /// @dev Adds a requester to the whitelist.
519     /// @param requester The address of a contract which will request reward transfers
520     function addRequester(address requester) public;
521 
522     /// @dev Removes a requester from the whitelist.
523     /// @param requester The address of a contract which will request reward transfers
524     function removeRequester(address requester) public;
525 
526     /// @dev Adds a approver address.  Approval happens with the token contract.
527     /// @param approver The approver address to add to the pool.
528     function addApprover(address approver) public;
529 
530     /// @dev Removes an approver address. 
531     /// @param approver The approver address to remove from the pool.
532     function removeApprover(address approver) public;
533 
534     /// @dev Updates the reward rate
535     function updateRewardRate(address tokenAddress, uint newRewardRate) public;
536 
537     /// @dev Updates the token address of the payment type.
538     function addRewardToken(address tokenAddress, uint newRewardRate) public;
539 
540     /// @dev Updates the token address of the payment type.
541     function removeRewardToken(address tokenAddress) public;
542 
543     /// @dev Updates the referral bonus rate
544     function updateReferralBonusRate(uint newReferralBonusRate) public;
545 
546     /// @dev Registers the player with the given referral code
547     /// @param player The address of the player
548     /// @param referrer The address of the referrer
549     function registerReferral(address player, address referrer) public;
550 
551     /// @dev Transfers any tokens to the owner
552     function destroyRewards() public;
553 }
554 
555 contract Priceable {
556     modifier costsExactly(uint price) {
557         if (msg.value == price) {
558             _;
559         }
560     }
561 
562     modifier costs(uint price) {
563         if (msg.value >= price) {
564             _;
565         }
566     }
567 }
568 
569 library SafeMath {
570   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
571     if (a == 0) {
572       return 0;
573     }
574     uint256 c = a * b;
575     assert(c / a == b);
576     return c;
577   }
578 
579   function div(uint256 a, uint256 b) internal pure returns (uint256) {
580     // assert(b > 0); // Solidity automatically throws when dividing by 0
581     uint256 c = a / b;
582     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
583     return c;
584   }
585 
586   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
587     assert(b <= a);
588     return a - b;
589   }
590 
591   function add(uint256 a, uint256 b) internal pure returns (uint256) {
592     uint256 c = a + b;
593     assert(c >= a);
594     return c;
595   }
596 }
597 
598 contract Ownable {
599   address public owner;
600 
601 
602   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
603 
604 
605   /**
606    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
607    * account.
608    */
609   function Ownable() public {
610     owner = msg.sender;
611   }
612 
613 
614   /**
615    * @dev Throws if called by any account other than the owner.
616    */
617   modifier onlyOwner() {
618     require(msg.sender == owner);
619     _;
620   }
621 
622 
623   /**
624    * @dev Allows the current owner to transfer control of the contract to a newOwner.
625    * @param newOwner The address to transfer ownership to.
626    */
627   function transferOwnership(address newOwner) public onlyOwner {
628     require(newOwner != address(0));
629     OwnershipTransferred(owner, newOwner);
630     owner = newOwner;
631   }
632 
633 }
634 
635 contract Cascading is Ownable {
636     using SafeMath for uint256;
637 
638     struct Cascade {
639         address cascade;
640         uint16 percentage;
641     }
642 
643     uint public totalCascadingPercentage;
644     Cascade[] public cascades;    
645 
646     /// @dev Adds an address and associated percentage for transfer.
647     /// @param newAddress The new address
648     function addCascade(address newAddress, uint newPercentage) public onlyOwner {
649         cascades.push(Cascade(newAddress, uint16(newPercentage)));
650         totalCascadingPercentage += newPercentage;
651     }
652 
653     /// @dev Deletes an address and associated percentage at the given index.
654     /// @param index The index of the cascade to be deleted.
655     function deleteCascade(uint index) public onlyOwner {
656         require(index < cascades.length);
657         
658         totalCascadingPercentage -= cascades[index].percentage;
659 
660         cascades[index] = cascades[cascades.length - 1];
661         delete cascades[cascades.length - 1];
662         cascades.length--;
663     }
664 
665     /// @dev Transfers the cascade values to the assigned addresses
666     /// @param totalJackpot the total jackpot amount
667     function transferCascades(uint totalJackpot) internal {
668         for (uint i = 0; i < cascades.length; i++) {
669             uint cascadeTotal = getCascadeTotal(cascades[i].percentage, totalJackpot);
670 
671             // Should be safe from re-entry given gas limit of 2300.
672             cascades[i].cascade.transfer(cascadeTotal);
673         }
674     }
675 
676     /// @dev Gets the cascade total for the given percentage
677     /// @param percentage the percentage of the total pot as a uint
678     /// @param totalJackpot the total jackpot amount
679     /// @return the total amount the percentage represents
680     function getCascadeTotal(uint percentage, uint totalJackpot) internal pure returns(uint) {
681         return totalJackpot.mul(percentage).div(100);        
682     }
683    
684     /// A utility method to calculate the total after cascades have been applied.
685     /// @param totalJackpot the total jackpot amount
686     /// @return the total amount after the cascades have been applied
687     function getTotalAfterCascades(uint totalJackpot) internal constant returns (uint) {
688         uint cascadeTotal = getCascadeTotal(totalCascadingPercentage, totalJackpot);
689         return totalJackpot.sub(cascadeTotal);
690     }
691 }
692 
693 contract SafeWinner is Ownable {
694     using SafeMath for uint256;
695 
696     mapping(address => uint) public pendingPayments;
697     address[] public pendingWinners;
698     uint public totalPendingPayments;
699 
700     event WinnerWithdrew(address indexed winner, uint amount, uint block);
701 
702     /// @dev records the winner so that a transfer or withdraw can occur at 
703     /// a later date.
704     function addPendingWinner(address winner, uint amount) internal {
705         pendingPayments[winner] = pendingPayments[winner].add(amount);
706         totalPendingPayments = totalPendingPayments.add(amount);
707         pendingWinners.push(winner);
708     }
709 
710     /// @dev allows a winner to withdraw their rightful jackpot.
711     function withdrawWinnings() public {
712         address winner = msg.sender;
713         uint payment = pendingPayments[winner];
714 
715         require(payment > 0);
716         require(this.balance >= payment);
717 
718         transferPending(winner, payment);
719     }
720 
721     /// @dev Retries all pending winners
722     function retryWinners() public onlyOwner {
723         for (uint i = 0; i < pendingWinners.length; i++) {
724             retryWinner(i);
725         }
726 
727         pendingWinners.length = 0;
728     }
729 
730     function retryWinner(uint index) public onlyOwner {
731         address winner = pendingWinners[index];
732         uint payment = pendingPayments[winner];
733         require(this.balance >= payment);
734         if (payment != 0) {
735             transferPending(winner, payment);
736         }
737     }
738 
739     function transferPending(address winner, uint256 payment) internal {
740         totalPendingPayments = totalPendingPayments.sub(payment);
741         pendingPayments[winner] = 0;
742         winner.transfer(payment);        
743         WinnerWithdrew(winner, payment, block.number);
744     }
745 }
746 
747 contract Raffle is Ownable, Priceable, SafeWinner, Cascading {
748   using SafeMath for uint256;
749   using OraclizeLib for OraclizeLib.OraclizeData;
750 
751   enum RaffleState { Active, InActive, PendingInActive }
752   enum RandomSource { RandomDS, Qrng }
753 
754   struct Jackpot {
755     uint absoluteTotal;
756     uint feeTotal;
757     uint cascadeTotal;
758     uint winnerTotal;
759   }
760 
761   struct TicketHolder {
762     address purchaser;
763     uint16 count;
764     uint80 runningTotal;
765   }
766   
767   // public
768   RaffleState public raffleState;
769   RandomSource public randomSource;
770   uint public ticketPrice;
771   uint public gameId;
772   uint public fee;
773   
774 
775   // internal
776   TicketHolder[] internal ticketHolders;
777   uint internal randomBytes;
778   uint internal randomQueried;
779   uint internal callbackGas;
780   RewardDistributable internal rewardDistributor;
781 
782   // oraclize
783   OraclizeLib.OraclizeData oraclizeData;
784 
785   // events
786   event TicketPurchased(address indexed ticketPurchaser, uint indexed id, uint numTickets, uint totalCost, uint block);
787   event WinnerSelected(address indexed winner, uint indexed id, uint winnings, uint block);
788   event RandomProofFailed(bytes32 queryId, uint indexed id, uint block);
789 
790   function Raffle(uint _ticketPrice, address _rewardDistributor) public {
791     ticketPrice = _ticketPrice;
792     raffleState = RaffleState.Active;
793     callbackGas = 200000;
794     randomBytes = 8;
795     fee = 5 finney;
796     rewardDistributor = RewardDistributable(_rewardDistributor);
797     oraclizeData.initializeOraclize();
798     randomSource = RandomSource.Qrng;
799     resetRaffle();
800   }
801 
802   /// @dev Returns whether the game is active.
803   function isActive() public constant returns (bool) {
804     return raffleState == RaffleState.Active || raffleState == RaffleState.PendingInActive;
805   }
806   
807   /// @dev Fallback function to purchase a single ticket.
808   function () public payable {
809   }
810    
811   /// @dev Gets the projected jackpot.
812   /// @return The projected jackpot amount.
813   function getProjectedJackpot() public constant returns (uint) {
814     uint jackpot = getAbsoluteProjectedJackpot();
815     Jackpot memory totals = getJackpotTotals(jackpot);
816     return totals.winnerTotal;
817   }
818 
819   /// @dev Gets the actual jackpot
820   /// @return The actual jackpot amount.
821   function getJackpot() public constant returns (uint) {
822     uint jackpot = getAbsoluteJackpot();
823     Jackpot memory totals = getJackpotTotals(jackpot);
824     return totals.winnerTotal;
825   }
826 
827   /// @dev Gets the ticket holder count
828   /// @return The total ticket holder count
829   function getTicketHolderCount() public constant returns (uint) {
830     return getTotalTickets();
831   }
832 
833   /// @dev Updates the ticket price.
834   function updateTicketPrice(uint updatedPrice) public onlyOwner {
835     require(raffleState == RaffleState.InActive);
836     require(updatedPrice > 0);
837     ticketPrice = updatedPrice;
838   }
839 
840   /// @dev Updates the ticket price.
841   function updateFee(uint updatedFee) public onlyOwner {
842     require(updatedFee > 0);
843     fee = updatedFee;
844   }
845 
846   /// @dev Deactivates the raffle after the next game.
847   function deactivate() public onlyOwner {
848     require(raffleState == RaffleState.Active);
849     raffleState = ticketHolders.length == 0 ? RaffleState.InActive : RaffleState.PendingInActive;
850   }
851 
852   /// @dev Activates the raffle, if inactivated.
853   function activate() public onlyOwner {
854     require(raffleState == RaffleState.InActive);
855     raffleState = RaffleState.Active;
856   }
857 
858   /// The oraclize callback function.
859   function __callback(bytes32 queryId, string result, bytes proof) public {
860     require(msg.sender == oraclizeData.oraclize_cbAddress());
861     
862     // We only expect this for this callback
863     if (oraclizeData.oraclize_randomDS_proofVerify__returnCode(queryId, result, proof) != 0) {
864       RandomProofFailed(queryId, gameId, now);
865       randomQueried = 0;
866       return;
867     }
868 
869     __callback(queryId, result);
870   }
871 
872   /// The oraclize callback function.
873   function __callback(bytes32 queryId, string result) public {
874     require(msg.sender == oraclizeData.oraclize_cbAddress());
875     
876     // Guard against the case where oraclize is triggered, or calls back multiple times.
877     if (!shouldChooseWinner()) {
878       return;
879     }
880 
881     uint maxRange = 2**(8*randomBytes); 
882     uint randomNumber = uint(keccak256(result)) % maxRange; 
883     winnerSelected(randomNumber);
884   }
885 
886   /// @dev An administrative function to allow in case the proof fails or 
887   /// a random winner needs to be chosen again.
888   function forceChooseRandomWinner() public onlyOwner {
889     require(raffleState != RaffleState.InActive);
890     executeRandomQuery();
891   }
892 
893   /// @dev Forces a refund for all participants and deactivates the contract
894   /// This offers a full refund, so it will be up to the owner to ensure a full balance.
895   function forceRefund() public onlyOwner {
896     raffleState = RaffleState.PendingInActive;
897 
898     uint total = getTotalTickets() * ticketPrice;
899     require(this.balance > total);
900 
901     for (uint i = 0; i < ticketHolders.length; i++) {
902       TicketHolder storage holder = ticketHolders[i];
903       holder.purchaser.transfer(uint256(holder.count).mul(ticketPrice));
904     }
905 
906     resetRaffle();
907   }
908 
909   /// @dev Destroys the current contract and moves all ETH back to  
910   function updateRewardDistributor(address newRewardDistributor) public onlyOwner {
911     rewardDistributor = RewardDistributable(newRewardDistributor);
912   }
913 
914   /// @dev Destroys the current contract and moves all ETH back to
915   /// owner. Only can occur after state has been set to inactive.
916   function destroy() public onlyOwner {
917     require(raffleState == RaffleState.InActive);
918     selfdestruct(owner);
919   }
920 
921   /// Gets the projected jackpot prior to any fees
922   /// @return The projected jackpot prior to any fees
923   function getAbsoluteProjectedJackpot() internal constant returns (uint);
924 
925   /// Gets the actual jackpot prior to any fees
926   /// @return The actual jackpot amount prior to any fees.
927   function getAbsoluteJackpot() internal constant returns (uint);
928   
929   /// An abstract function which determines whether a it is appropriate to choose a winner.
930   /// @return True if it is appropriate to choose the winner, false otherwise.
931   function shouldChooseWinner() internal returns (bool);
932 
933   function executeRandomQuery() internal {
934     if (randomSource == RandomSource.RandomDS) {
935       oraclizeData.oraclize_newRandomDSQuery(0, randomBytes, callbackGas);
936     }
937     else {
938       oraclizeData.oraclize_query("URL","json(https://qrng.anu.edu.au/API/jsonI.php?length=1&type=hex16&size=32).data[0]", callbackGas);
939     }
940   }
941 
942   /// Chooses the winner at random.
943   function chooseWinner() internal {
944     // We build in a buffer of 20 blocks.  Approx 1 block per 15 secs ~ 5 mins
945     // the last time random was queried, we'll execute again.
946     if (randomQueried < (block.number.sub(20))) {
947       executeRandomQuery();
948       randomQueried = block.number;
949     }
950   }
951 
952   /// Internal function for when a winner is chosen.
953   function winnerSelected(uint randomNumber) internal {
954     TicketHolder memory winner = getWinningTicketHolder(randomNumber);
955     uint jackpot = getAbsoluteJackpot();
956     Jackpot memory jackpotTotals = getJackpotTotals(jackpot);
957 
958     WinnerSelected(winner.purchaser, gameId, jackpotTotals.winnerTotal, now);    
959     transferJackpot(winner.purchaser, jackpotTotals.winnerTotal);
960     transferCascades(jackpotTotals.absoluteTotal);
961     resetRaffle();
962   }
963 
964   function getWinningTicketHolder(uint randomNumber) internal view returns(TicketHolder) {
965     assert(ticketHolders.length > 0);
966     uint totalTickets = getTotalTickets();
967     uint winner = (randomNumber % totalTickets) + 1;
968 
969     uint min = 0;
970     uint max = ticketHolders.length-1;
971     while (max > min) {
972         uint mid = (max + min + 1) / 2;
973         if (ticketHolders[mid].runningTotal >= winner &&
974          (ticketHolders[mid].runningTotal-ticketHolders[mid].count) < winner) {
975            return ticketHolders[mid];
976         }
977 
978         if (ticketHolders[mid].runningTotal <= winner) {
979             min = mid;
980         } else {
981             max = mid-1;
982         }
983     }
984 
985     return ticketHolders[min];
986   }
987 
988   /// Transfers the jackpot to the winner triggering the event
989   function transferJackpot(address winner, uint jackpot) internal returns(uint) {
990     // We explicitly do not use transfer here because if the 
991     // the call fails, the oraclize contract will not retry.
992     bool sendSuccessful = winner.send(jackpot);
993     if (!sendSuccessful) {
994       addPendingWinner(winner, jackpot);
995     }
996 
997     return jackpot;
998   }
999 
1000   /// Resets the raffle game state.
1001   function resetRaffle() internal {
1002     if (raffleState == RaffleState.PendingInActive) {
1003       raffleState = RaffleState.InActive;
1004     }
1005     ticketHolders.length = 0;
1006     gameId = block.number;
1007     randomQueried = 0;
1008   }
1009 
1010   /// Gets the jackpot after fees
1011   function getJackpotTotals(uint jackpot) internal constant returns(Jackpot) {
1012     if (jackpot < fee) {
1013       return Jackpot(0, 0, 0, 0);
1014     }
1015 
1016     uint cascadeTotal = getCascadeTotal(totalCascadingPercentage, jackpot);
1017     return Jackpot(jackpot, fee, cascadeTotal, jackpot.sub(fee).sub(cascadeTotal));
1018   }
1019 
1020   function updateRandomSource(uint newRandomSource) public onlyOwner {
1021     if (newRandomSource == 1) {
1022       randomSource = RandomSource.RandomDS;
1023     } else {
1024       randomSource = RandomSource.Qrng;
1025     }
1026 
1027     setProof();
1028   }
1029 
1030 
1031   function setProof() internal {
1032       if (randomSource == RandomSource.RandomDS) {
1033         // proofType_Ledger = 0x30;
1034         oraclizeData.oraclize_setProof(0x30);
1035       }
1036       else {
1037         oraclizeData.oraclize_setProof(0x00);
1038       }
1039   }
1040 
1041   function getTotalTickets() internal view returns(uint) {
1042     return ticketHolders.length == 0 ? 0 : ticketHolders[ticketHolders.length-1].runningTotal;
1043   }
1044 
1045   function updateOraclizeGas(uint newCallbackGas, uint customGasPrice) public onlyOwner {
1046     callbackGas = newCallbackGas;
1047     updateCustomGasPrice(customGasPrice);
1048   }
1049 
1050   function updateCustomGasPrice(uint customGasPrice) internal {
1051     oraclizeData.oraclize_setCustomGasPrice(customGasPrice);
1052   }
1053 }
1054 
1055 contract CountBasedRaffle is Raffle {
1056   
1057   uint public drawTicketCount;
1058 
1059   /// @dev Constructor for conventional raffle
1060   /// @param _ticketPrice The ticket price.
1061   /// @param _drawTicketCount The number of tickets for a draw to take place.
1062   function CountBasedRaffle(uint _ticketPrice, uint _drawTicketCount, address _rewardDistributor) Raffle(_ticketPrice, _rewardDistributor) public {
1063     drawTicketCount = _drawTicketCount;
1064   }
1065 
1066   /// @dev Gets the projected jackpot.
1067   function getAbsoluteProjectedJackpot() internal constant returns (uint) {
1068     uint totalTicketCount = getTotalTickets();
1069     uint ticketCount = drawTicketCount > totalTicketCount ? drawTicketCount : totalTicketCount;
1070     return ticketCount.mul(ticketPrice); 
1071   }
1072 
1073   /// @dev Gets the actual jackpot
1074   function getAbsoluteJackpot() internal constant returns (uint) {
1075     if (ticketHolders.length == 0) {
1076       return 0;
1077     }
1078 
1079     return this.balance.sub(totalPendingPayments);
1080   }
1081 
1082     /* @dev Purchases tickets to the raffle.
1083   * @param numTickets Number of tickets to purchase.
1084   * @param referrer The address of the referrer.
1085   */
1086   function purchaseTicket(uint numTickets, address referrer) public payable costsExactly(numTickets.mul(ticketPrice)) {
1087     require(raffleState != RaffleState.InActive);
1088     require(numTickets < drawTicketCount);
1089 
1090     // Add the address to the ticketHolders.
1091     uint totalTickets = getTotalTickets();
1092     ticketHolders.push(TicketHolder(msg.sender, uint16(numTickets), uint80(totalTickets.add(numTickets))));
1093     TicketPurchased(msg.sender, gameId, numTickets, ticketPrice.mul(numTickets), now);
1094     if (rewardDistributor != address(0)) {
1095       rewardDistributor.registerReferral(msg.sender, referrer);
1096       rewardDistributor.transferRewards(msg.sender, msg.value, gameId);
1097     }
1098 
1099     if (shouldChooseWinner()) {
1100       chooseWinner();
1101     }
1102   }
1103   
1104   /// An abstract function which determines whether a it is appropriate to choose a winner.
1105   /// @return True if it is appropriate to choose the winner, false otherwise.
1106   function shouldChooseWinner() internal returns (bool) {
1107     return getTotalTickets() >= drawTicketCount;
1108   }
1109 }
1110 
1111 contract GoldRaffle is CountBasedRaffle {
1112 
1113   /// @dev Constructor for conventional raffle
1114   /// Should reach jackpot of ~ 1.5 ETH
1115   function GoldRaffle(address _rewardDistributor) CountBasedRaffle(100 finney, 10, _rewardDistributor) public {
1116   }
1117 }
1118 
1119 contract OraclizeI {
1120     address public cbAddress;
1121     function query(uint _timestamp, string _datasource, string _arg) public payable returns (bytes32 _id);
1122     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) public  payable returns (bytes32 _id);
1123     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public  payable returns (bytes32 _id);
1124     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) public payable returns (bytes32 _id);
1125     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
1126     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) public payable returns (bytes32 _id);
1127     function getPrice(string _datasource) public returns (uint _dsprice);
1128     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
1129     function setProofType(byte _proofType) public;
1130     function setConfig(bytes32 _config) public;
1131     function setCustomGasPrice(uint _gasPrice) public;
1132     function randomDS_getSessionPubKeyHash() public returns(bytes32);
1133 }