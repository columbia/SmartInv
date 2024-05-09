1 pragma solidity ^0.4.18;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 contract Ownable {
22   address public owner;
23 
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   function Ownable() public {
33     owner = msg.sender;
34   }
35 
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 library OraclizeLib {
59    
60     struct OraclizeData {
61         OraclizeAddrResolverI oraclizeAddressResolver;
62         OraclizeI oraclize;
63         mapping(bytes32=>bytes32) oraclizeRandomDSArgs;
64         mapping(bytes32=>bool) oraclizeRandomDsSessionKeyHashVerified;
65         string oraclizeNetworkName;
66     }
67 
68     function initializeOraclize(OraclizeData storage self) internal {
69        self.oraclizeAddressResolver = oraclize_setNetwork(self);
70        if (self.oraclizeAddressResolver != address(0)) {
71            self.oraclize = OraclizeI(self.oraclizeAddressResolver.getAddress());
72        }
73     }
74 
75     function oraclize_setNetwork(OraclizeData storage self) public returns(OraclizeAddrResolverI) {
76         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0) { //mainnet
77             oraclize_setNetworkName(self, "eth_mainnet");
78             return OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
79         }
80         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0) { //ropsten testnet
81             oraclize_setNetworkName(self, "eth_ropsten3");
82             return OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
83         }
84         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0) { //kovan testnet
85             oraclize_setNetworkName(self, "eth_kovan");
86             return OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
87         }
88         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0) { //rinkeby testnet
89             oraclize_setNetworkName(self, "eth_rinkeby");
90             return OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
91         }
92         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0) { //ethereum-bridge
93             return OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
94         }
95         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0) { //ether.camp ide
96             return OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
97         }
98         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0) { //browser-solidity
99             return OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
100         }
101     }
102 
103     function oraclize_setNetworkName(OraclizeData storage self, string _network_name) internal {
104         self.oraclizeNetworkName = _network_name;
105     }
106     
107     function oraclize_getNetworkName(OraclizeData storage self) internal constant returns (string) {
108         return self.oraclizeNetworkName;
109     }
110 
111     function oraclize_getPrice(OraclizeData storage self, string datasource) public returns (uint) {
112         return self.oraclize.getPrice(datasource);
113     }
114 
115     function oraclize_getPrice(OraclizeData storage self, string datasource, uint gaslimit) public returns (uint) {
116         return self.oraclize.getPrice(datasource, gaslimit);
117     }
118 
119     function oraclize_query(OraclizeData storage self, string datasource, string arg) public returns (bytes32 id) {
120         return oraclize_query(self, 0, datasource, arg);
121     }
122 
123     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg) public returns (bytes32 id) {
124         uint price = self.oraclize.getPrice(datasource);
125         if (price > 1 ether + tx.gasprice*200000) {
126             return 0; // unexpectedly high price
127         }
128         return self.oraclize.query.value(price)(timestamp, datasource, arg);
129     }
130 
131     function oraclize_query(OraclizeData storage self, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
132         return oraclize_query(self, 0, datasource, arg, gaslimit);
133     }
134 
135     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
136         uint price = self.oraclize.getPrice(datasource, gaslimit);
137         if (price > 1 ether + tx.gasprice*gaslimit) {
138             return 0; // unexpectedly high price
139         }
140         return self.oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
141     }
142 
143     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2) public returns (bytes32 id) {
144         return oraclize_query(self, 0, datasource, arg1, arg2);
145     }
146 
147     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2) public returns (bytes32 id) {
148         uint price = self.oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) {
150             return 0; // unexpectedly high price
151         }
152         return self.oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
153     }
154 
155     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
156         return oraclize_query(self, 0, datasource, arg1, arg2, gaslimit);
157     }
158 
159     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
160         uint price = self.oraclize.getPrice(datasource, gaslimit);
161         if (price > 1 ether + tx.gasprice*gaslimit) {
162             return 0; // unexpectedly high price
163         }
164         return self.oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
165     }
166 
167     function oraclize_query(OraclizeData storage self, string datasource, string[] argN) internal returns (bytes32 id) {
168         return oraclize_query(self, 0, datasource, argN);
169     }
170 
171     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN) internal returns (bytes32 id) {
172         uint price = self.oraclize.getPrice(datasource);
173         if (price > 1 ether + tx.gasprice*200000) {
174             return 0; // unexpectedly high price
175         }
176         bytes memory args = stra2cbor(argN);
177         return self.oraclize.queryN.value(price)(timestamp, datasource, args);
178     }
179 
180     function oraclize_query(OraclizeData storage self, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id) {
181         return oraclize_query(self, 0, datasource, argN, gaslimit);
182     }
183 
184     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id){
185         uint price = self.oraclize.getPrice(datasource, gaslimit);
186         if (price > 1 ether + tx.gasprice*gaslimit) {
187             return 0; // unexpectedly high price
188         }
189         bytes memory args = stra2cbor(argN);
190         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
191     }
192 
193      function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, bytes[] argN, uint gaslimit) internal returns (bytes32 id){
194         uint price = self.oraclize.getPrice(datasource, gaslimit);
195         if (price > 1 ether + tx.gasprice*gaslimit) {
196             return 0; // unexpectedly high price
197         }
198         bytes memory args = ba2cbor(argN);
199         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
200     }
201 
202     function oraclize_newRandomDSQuery(OraclizeData storage self, uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32) {
203         assert((_nbytes > 0) && (_nbytes <= 32));
204         bytes memory nbytes = new bytes(1);
205         nbytes[0] = byte(_nbytes);
206         bytes memory unonce = new bytes(32);
207         bytes memory sessionKeyHash = new bytes(32);
208         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash(self);
209         assembly {
210             mstore(unonce, 0x20)
211             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
212             mstore(sessionKeyHash, 0x20)
213             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
214         }
215         bytes[] memory args = new bytes[](3);
216         args[0] = unonce;
217         args[1] = nbytes;
218         args[2] = sessionKeyHash; 
219         bytes32 queryId = oraclize_query(self, _delay, "random", args, _customGasLimit);
220         oraclize_randomDS_setCommitment(self, queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
221         return queryId;
222     }
223 
224      function oraclize_randomDS_proofVerify__main(OraclizeData storage self, bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
225         bool checkok;
226         
227         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
228         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
229         bytes memory keyhash = new bytes(32);
230         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
231         checkok = (keccak256(keyhash) == keccak256(sha256(context_name, queryId)));
232         if (checkok == false) {
233             return false;
234         }
235         
236         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
237         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
238         
239         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
240         checkok = matchBytes32Prefix(sha256(sig1), result);
241         if (checkok == false) {
242             return false;
243         }
244         
245         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
246         // This is to verify that the computed args match with the ones specified in the query.
247         bytes memory commitmentSlice1 = new bytes(8+1+32);
248         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
249         
250         bytes memory sessionPubkey = new bytes(64);
251         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
252         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
253         
254         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
255         if (self.oraclizeRandomDSArgs[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)) {
256             delete self.oraclizeRandomDSArgs[queryId]; //unonce, nbytes and sessionKeyHash match
257         } else {
258             return false;
259         }
260 
261         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
262         bytes memory tosign1 = new bytes(32+8+1+32);
263         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
264         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
265         if (checkok == false) {
266             return false;
267         }
268 
269         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
270         if (self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] == false) {
271             self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
272         }
273         
274         return self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash];
275     }
276 
277     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
278         bool sigok;
279         
280         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
281         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
282         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
283         
284         bytes memory appkey1_pubkey = new bytes(64);
285         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
286         
287         bytes memory tosign2 = new bytes(1+65+32);
288         tosign2[0] = 1; //role
289         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
290         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
291         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
292         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
293         
294         if (sigok == false) {
295             return false;
296         }
297         
298         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
299         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
300         
301         bytes memory tosign3 = new bytes(1+65);
302         tosign3[0] = 0xFE;
303         copyBytes(proof, 3, 65, tosign3, 1);
304         
305         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
306         copyBytes(proof, 3+65, sig3.length, sig3, 0);
307         
308         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
309         
310         return sigok;
311     }
312 
313     function oraclize_randomDS_proofVerify__returnCode(OraclizeData storage self, bytes32 _queryId, string _result, bytes _proof) internal returns (uint8) {
314         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
315         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) {
316             return 1;
317         }
318         bool proofVerified = oraclize_randomDS_proofVerify__main(self, _proof, _queryId, bytes(_result), oraclize_getNetworkName(self));
319         if (proofVerified == false) {
320             return 2;
321         }
322         return 0;
323     }
324     
325     function oraclize_randomDS_setCommitment(OraclizeData storage self, bytes32 queryId, bytes32 commitment) internal {
326         self.oraclizeRandomDSArgs[queryId] = commitment;
327     }
328     
329     function matchBytes32Prefix(bytes32 content, bytes prefix) internal pure returns (bool) {
330         bool match_ = true;
331         
332         for (uint i=0; i<prefix.length; i++) {
333             if (content[i] != prefix[i]) {
334                 match_ = false;
335             }
336         }
337         
338         return match_;
339     }
340 
341     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool) {
342         bool sigok;
343         address signer;
344         
345         bytes32 sigr;
346         bytes32 sigs;
347         
348         bytes memory sigr_ = new bytes(32);
349         uint offset = 4+(uint(dersig[3]) - 0x20);
350         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
351         bytes memory sigs_ = new bytes(32);
352         offset += 32 + 2;
353         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
354 
355         assembly {
356             sigr := mload(add(sigr_, 32))
357             sigs := mload(add(sigs_, 32))
358         }
359         
360         
361         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
362         if (address(keccak256(pubkey)) == signer) {
363             return true;
364         } else {
365             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
366             return (address(keccak256(pubkey)) == signer);
367         }
368     }
369 
370     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
371     // Duplicate Solidity's ecrecover, but catching the CALL return value
372     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
373         // We do our own memory management here. Solidity uses memory offset
374         // 0x40 to store the current end of memory. We write past it (as
375         // writes are memory extensions), but don't update the offset so
376         // Solidity will reuse it. The memory used here is only needed for
377         // this context.
378 
379         // FIXME: inline assembly can't access return values
380         bool ret;
381         address addr;
382 
383         assembly {
384             let size := mload(0x40)
385             mstore(size, hash)
386             mstore(add(size, 32), v)
387             mstore(add(size, 64), r)
388             mstore(add(size, 96), s)
389 
390             // NOTE: we can reuse the request memory because we deal with
391             //       the return code
392             ret := call(3000, 1, 0, size, 128, size, 32)
393             addr := mload(size)
394         }
395   
396         return (ret, addr);
397     }
398     
399     function oraclize_cbAddress(OraclizeData storage self) public constant returns (address) {
400         return self.oraclize.cbAddress();
401     }
402 
403     function oraclize_setProof(OraclizeData storage self, byte proofP) public {
404         return self.oraclize.setProofType(proofP);
405     }
406 
407     function oraclize_setCustomGasPrice(OraclizeData storage self, uint gasPrice) public {
408         return self.oraclize.setCustomGasPrice(gasPrice);
409     }
410 
411     function oraclize_setConfig(OraclizeData storage self, bytes32 config) public {
412         return self.oraclize.setConfig(config);
413     }
414 
415     function getCodeSize(address _addr) public constant returns(uint _size) {
416         assembly {
417             _size := extcodesize(_addr)
418         }
419     }
420     
421     function oraclize_randomDS_getSessionPubKeyHash(OraclizeData storage self) internal returns (bytes32){
422         return self.oraclize.randomDS_getSessionPubKeyHash();
423     }
424 
425     function stra2cbor(string[] arr) internal pure returns (bytes) {
426         uint arrlen = arr.length;
427 
428         // get correct cbor output length
429         uint outputlen = 0;
430         bytes[] memory elemArray = new bytes[](arrlen);
431         for (uint i = 0; i < arrlen; i++) {
432             elemArray[i] = (bytes(arr[i]));
433             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
434         }
435         uint ctr = 0;
436         uint cborlen = arrlen + 0x80;
437         outputlen += byte(cborlen).length;
438         bytes memory res = new bytes(outputlen);
439 
440         while (byte(cborlen).length > ctr) {
441             res[ctr] = byte(cborlen)[ctr];
442             ctr++;
443         }
444         for (i = 0; i < arrlen; i++) {
445             res[ctr] = 0x5F;
446             ctr++;
447             for (uint x = 0; x < elemArray[i].length; x++) {
448                 // if there's a bug with larger strings, this may be the culprit
449                 if (x % 23 == 0) {
450                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
451                     elemcborlen += 0x40;
452                     uint lctr = ctr;
453                     while (byte(elemcborlen).length > ctr - lctr) {
454                         res[ctr] = byte(elemcborlen)[ctr - lctr];
455                         ctr++;
456                     }
457                 }
458                 res[ctr] = elemArray[i][x];
459                 ctr++;
460             }
461             res[ctr] = 0xFF;
462             ctr++;
463         }
464         return res;
465     }
466 
467     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
468             uint arrlen = arr.length;
469 
470             // get correct cbor output length
471             uint outputlen = 0;
472             bytes[] memory elemArray = new bytes[](arrlen);
473             for (uint i = 0; i < arrlen; i++) {
474                 elemArray[i] = (bytes(arr[i]));
475                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
476             }
477             uint ctr = 0;
478             uint cborlen = arrlen + 0x80;
479             outputlen += byte(cborlen).length;
480             bytes memory res = new bytes(outputlen);
481 
482             while (byte(cborlen).length > ctr) {
483                 res[ctr] = byte(cborlen)[ctr];
484                 ctr++;
485             }
486             for (i = 0; i < arrlen; i++) {
487                 res[ctr] = 0x5F;
488                 ctr++;
489                 for (uint x = 0; x < elemArray[i].length; x++) {
490                     // if there's a bug with larger strings, this may be the culprit
491                     if (x % 23 == 0) {
492                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
493                         elemcborlen += 0x40;
494                         uint lctr = ctr;
495                         while (byte(elemcborlen).length > ctr - lctr) {
496                             res[ctr] = byte(elemcborlen)[ctr - lctr];
497                             ctr++;
498                         }
499                     }
500                     res[ctr] = elemArray[i][x];
501                     ctr++;
502                 }
503                 res[ctr] = 0xFF;
504                 ctr++;
505             }
506             return res;
507         }
508 
509     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
510         uint minLength = length + toOffset;
511 
512         assert (to.length >= minLength);
513 
514         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
515         uint i = 32 + fromOffset;
516         uint j = 32 + toOffset;
517 
518         while (i < (32 + fromOffset + length)) {
519             assembly {
520                 let tmp := mload(add(from, i))
521                 mstore(add(to, j), tmp)
522             }
523             i += 32;
524             j += 32;
525         }
526 
527         return to;
528     }
529 }
530 
531 library SafeMath {
532   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
533     if (a == 0) {
534       return 0;
535     }
536     uint256 c = a * b;
537     assert(c / a == b);
538     return c;
539   }
540 
541   function div(uint256 a, uint256 b) internal pure returns (uint256) {
542     // assert(b > 0); // Solidity automatically throws when dividing by 0
543     uint256 c = a / b;
544     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
545     return c;
546   }
547 
548   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
549     assert(b <= a);
550     return a - b;
551   }
552 
553   function add(uint256 a, uint256 b) internal pure returns (uint256) {
554     uint256 c = a + b;
555     assert(c >= a);
556     return c;
557   }
558 }
559 
560 contract OraclizeAddrResolverI {
561     function getAddress() public returns (address _addr);
562 }
563 
564 contract Priceable {
565     modifier costsExactly(uint price) {
566         if (msg.value == price) {
567             _;
568         }
569     }
570 
571     modifier costs(uint price) {
572         if (msg.value >= price) {
573             _;
574         }
575     }
576 }
577 
578 contract SafeWinner is Ownable {
579     using SafeMath for uint256;
580 
581     mapping(address => uint) public pendingPayments;
582     address[] public pendingWinners;
583     uint public totalPendingPayments;
584 
585     event WinnerWithdrew(address indexed winner, uint amount, uint block);
586 
587     /// @dev records the winner so that a transfer or withdraw can occur at 
588     /// a later date.
589     function addPendingWinner(address winner, uint amount) internal {
590         pendingPayments[winner] = pendingPayments[winner].add(amount);
591         totalPendingPayments = totalPendingPayments.add(amount);
592         pendingWinners.push(winner);
593     }
594 
595     /// @dev allows a winner to withdraw their rightful jackpot.
596     function withdrawWinnings() public {
597         address winner = msg.sender;
598         uint payment = pendingPayments[winner];
599 
600         require(payment > 0);
601         require(this.balance >= payment);
602 
603         transferPending(winner, payment);
604     }
605 
606     /// @dev Retries all pending winners
607     function retryWinners() public onlyOwner {
608         for (uint i = 0; i < pendingWinners.length; i++) {
609             retryWinner(i);
610         }
611 
612         pendingWinners.length = 0;
613     }
614 
615     function retryWinner(uint index) public onlyOwner {
616         address winner = pendingWinners[index];
617         uint payment = pendingPayments[winner];
618         require(this.balance >= payment);
619         if (payment != 0) {
620             transferPending(winner, payment);
621         }
622     }
623 
624     function transferPending(address winner, uint256 payment) internal {
625         totalPendingPayments = totalPendingPayments.sub(payment);
626         pendingPayments[winner] = 0;
627         winner.transfer(payment);        
628         WinnerWithdrew(winner, payment, block.number);
629     }
630 }
631 
632 contract RewardDistributable {
633     event TokensRewarded(address indexed player, address rewardToken, uint rewards, address requester, uint gameId, uint block);
634     event ReferralRewarded(address indexed referrer, address indexed player, address rewardToken, uint rewards, uint gameId, uint block);
635     event ReferralRegistered(address indexed player, address indexed referrer);
636 
637     /// @dev Calculates and transfers the rewards to the player.
638     function transferRewards(address player, uint entryAmount, uint gameId) public;
639 
640     /// @dev Returns the total number of tokens, across all approvals.
641     function getTotalTokens(address tokenAddress) public constant returns(uint);
642 
643     /// @dev Returns the total number of supported reward token contracts.
644     function getRewardTokenCount() public constant returns(uint);
645 
646     /// @dev Gets the total number of approvers.
647     function getTotalApprovers() public constant returns(uint);
648 
649     /// @dev Gets the reward rate inclusive of referral bonus.
650     function getRewardRate(address player, address tokenAddress) public constant returns(uint);
651 
652     /// @dev Adds a requester to the whitelist.
653     /// @param requester The address of a contract which will request reward transfers
654     function addRequester(address requester) public;
655 
656     /// @dev Removes a requester from the whitelist.
657     /// @param requester The address of a contract which will request reward transfers
658     function removeRequester(address requester) public;
659 
660     /// @dev Adds a approver address.  Approval happens with the token contract.
661     /// @param approver The approver address to add to the pool.
662     function addApprover(address approver) public;
663 
664     /// @dev Removes an approver address. 
665     /// @param approver The approver address to remove from the pool.
666     function removeApprover(address approver) public;
667 
668     /// @dev Updates the reward rate
669     function updateRewardRate(address tokenAddress, uint newRewardRate) public;
670 
671     /// @dev Updates the token address of the payment type.
672     function addRewardToken(address tokenAddress, uint newRewardRate) public;
673 
674     /// @dev Updates the token address of the payment type.
675     function removeRewardToken(address tokenAddress) public;
676 
677     /// @dev Updates the referral bonus rate
678     function updateReferralBonusRate(uint newReferralBonusRate) public;
679 
680     /// @dev Registers the player with the given referral code
681     /// @param player The address of the player
682     /// @param referrer The address of the referrer
683     function registerReferral(address player, address referrer) public;
684 
685     /// @dev Transfers any tokens to the owner
686     function destroyRewards() public;
687 }
688 
689 contract OraclizeI {
690     address public cbAddress;
691     function query(uint _timestamp, string _datasource, string _arg) public payable returns (bytes32 _id);
692     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) public  payable returns (bytes32 _id);
693     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public  payable returns (bytes32 _id);
694     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) public payable returns (bytes32 _id);
695     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
696     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) public payable returns (bytes32 _id);
697     function getPrice(string _datasource) public returns (uint _dsprice);
698     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
699     function setProofType(byte _proofType) public;
700     function setConfig(bytes32 _config) public;
701     function setCustomGasPrice(uint _gasPrice) public;
702     function randomDS_getSessionPubKeyHash() public returns(bytes32);
703 }
704 
705 contract Cascading is Ownable {
706     using SafeMath for uint256;
707 
708     struct Cascade {
709         address cascade;
710         uint16 percentage;
711     }
712 
713     uint public totalCascadingPercentage;
714     Cascade[] public cascades;    
715 
716     /// @dev Adds an address and associated percentage for transfer.
717     /// @param newAddress The new address
718     function addCascade(address newAddress, uint newPercentage) public onlyOwner {
719         cascades.push(Cascade(newAddress, uint16(newPercentage)));
720         totalCascadingPercentage += newPercentage;
721     }
722 
723     /// @dev Deletes an address and associated percentage at the given index.
724     /// @param index The index of the cascade to be deleted.
725     function deleteCascade(uint index) public onlyOwner {
726         require(index < cascades.length);
727         
728         totalCascadingPercentage -= cascades[index].percentage;
729 
730         cascades[index] = cascades[cascades.length - 1];
731         delete cascades[cascades.length - 1];
732         cascades.length--;
733     }
734 
735     /// @dev Transfers the cascade values to the assigned addresses
736     /// @param totalJackpot the total jackpot amount
737     function transferCascades(uint totalJackpot) internal {
738         for (uint i = 0; i < cascades.length; i++) {
739             uint cascadeTotal = getCascadeTotal(cascades[i].percentage, totalJackpot);
740 
741             // Should be safe from re-entry given gas limit of 2300.
742             cascades[i].cascade.transfer(cascadeTotal);
743         }
744     }
745 
746     /// @dev Gets the cascade total for the given percentage
747     /// @param percentage the percentage of the total pot as a uint
748     /// @param totalJackpot the total jackpot amount
749     /// @return the total amount the percentage represents
750     function getCascadeTotal(uint percentage, uint totalJackpot) internal pure returns(uint) {
751         return totalJackpot.mul(percentage).div(100);        
752     }
753    
754     /// A utility method to calculate the total after cascades have been applied.
755     /// @param totalJackpot the total jackpot amount
756     /// @return the total amount after the cascades have been applied
757     function getTotalAfterCascades(uint totalJackpot) internal constant returns (uint) {
758         uint cascadeTotal = getCascadeTotal(totalCascadingPercentage, totalJackpot);
759         return totalJackpot.sub(cascadeTotal);
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
1127 contract SilverRaffle is CountBasedRaffle {
1128 
1129   /// @dev Constructor for conventional raffle
1130   /// Should total jackpot of ~ 0.6 ETH
1131   function SilverRaffle(address _rewardDistributor) CountBasedRaffle(50 finney, 12, _rewardDistributor) public {
1132   }
1133 }