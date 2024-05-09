1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract OraclizeAddrResolverI {
33     function getAddress() public returns (address _addr);
34 }
35 
36 library Math {
37   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
38     return a >= b ? a : b;
39   }
40 
41   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
42     return a < b ? a : b;
43   }
44 
45   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
46     return a >= b ? a : b;
47   }
48 
49   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
50     return a < b ? a : b;
51   }
52 }
53 
54 contract OraclizeI {
55     address public cbAddress;
56     function query(uint _timestamp, string _datasource, string _arg) public payable returns (bytes32 _id);
57     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) public  payable returns (bytes32 _id);
58     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public  payable returns (bytes32 _id);
59     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) public payable returns (bytes32 _id);
60     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
61     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) public payable returns (bytes32 _id);
62     function getPrice(string _datasource) public returns (uint _dsprice);
63     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
64     function setProofType(byte _proofType) public;
65     function setConfig(bytes32 _config) public;
66     function setCustomGasPrice(uint _gasPrice) public;
67     function randomDS_getSessionPubKeyHash() public returns(bytes32);
68 }
69 
70 contract Priceable {
71     modifier costsExactly(uint price) {
72         if (msg.value == price) {
73             _;
74         }
75     }
76 
77     modifier costs(uint price) {
78         if (msg.value >= price) {
79             _;
80         }
81     }
82 }
83 
84 contract FullERC20 {
85   event Transfer(address indexed from, address indexed to, uint256 value);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87   
88   uint256 public totalSupply;
89   uint8 public decimals;
90 
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   function allowance(address owner, address spender) public view returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96 }
97 
98 library OraclizeLib {
99    
100     struct OraclizeData {
101         OraclizeAddrResolverI oraclizeAddressResolver;
102         OraclizeI oraclize;
103         mapping(bytes32=>bytes32) oraclizeRandomDSArgs;
104         mapping(bytes32=>bool) oraclizeRandomDsSessionKeyHashVerified;
105         string oraclizeNetworkName;
106     }
107 
108     function initializeOraclize(OraclizeData storage self) internal {
109        self.oraclizeAddressResolver = oraclize_setNetwork(self);
110        if (self.oraclizeAddressResolver != address(0)) {
111            self.oraclize = OraclizeI(self.oraclizeAddressResolver.getAddress());
112        }
113     }
114 
115     function oraclize_setNetwork(OraclizeData storage self) public returns(OraclizeAddrResolverI) {
116         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0) { //mainnet
117             oraclize_setNetworkName(self, "eth_mainnet");
118             return OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
119         }
120         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0) { //ropsten testnet
121             oraclize_setNetworkName(self, "eth_ropsten3");
122             return OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
123         }
124         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0) { //kovan testnet
125             oraclize_setNetworkName(self, "eth_kovan");
126             return OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
127         }
128         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0) { //rinkeby testnet
129             oraclize_setNetworkName(self, "eth_rinkeby");
130             return OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
131         }
132         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0) { //ethereum-bridge
133             return OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
134         }
135         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0) { //ether.camp ide
136             return OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
137         }
138         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0) { //browser-solidity
139             return OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
140         }
141     }
142 
143     function oraclize_setNetworkName(OraclizeData storage self, string _network_name) internal {
144         self.oraclizeNetworkName = _network_name;
145     }
146     
147     function oraclize_getNetworkName(OraclizeData storage self) internal constant returns (string) {
148         return self.oraclizeNetworkName;
149     }
150 
151     function oraclize_getPrice(OraclizeData storage self, string datasource) public returns (uint) {
152         return self.oraclize.getPrice(datasource);
153     }
154 
155     function oraclize_getPrice(OraclizeData storage self, string datasource, uint gaslimit) public returns (uint) {
156         return self.oraclize.getPrice(datasource, gaslimit);
157     }
158 
159     function oraclize_query(OraclizeData storage self, string datasource, string arg) public returns (bytes32 id) {
160         return oraclize_query(self, 0, datasource, arg);
161     }
162 
163     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg) public returns (bytes32 id) {
164         uint price = self.oraclize.getPrice(datasource);
165         if (price > 1 ether + tx.gasprice*200000) {
166             return 0; // unexpectedly high price
167         }
168         return self.oraclize.query.value(price)(timestamp, datasource, arg);
169     }
170 
171     function oraclize_query(OraclizeData storage self, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
172         return oraclize_query(self, 0, datasource, arg, gaslimit);
173     }
174 
175     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg, uint gaslimit) public returns (bytes32 id) {
176         uint price = self.oraclize.getPrice(datasource, gaslimit);
177         if (price > 1 ether + tx.gasprice*gaslimit) {
178             return 0; // unexpectedly high price
179         }
180         return self.oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
181     }
182 
183     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2) public returns (bytes32 id) {
184         return oraclize_query(self, 0, datasource, arg1, arg2);
185     }
186 
187     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2) public returns (bytes32 id) {
188         uint price = self.oraclize.getPrice(datasource);
189         if (price > 1 ether + tx.gasprice*200000) {
190             return 0; // unexpectedly high price
191         }
192         return self.oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
193     }
194 
195     function oraclize_query(OraclizeData storage self, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
196         return oraclize_query(self, 0, datasource, arg1, arg2, gaslimit);
197     }
198 
199     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) public returns (bytes32 id) {
200         uint price = self.oraclize.getPrice(datasource, gaslimit);
201         if (price > 1 ether + tx.gasprice*gaslimit) {
202             return 0; // unexpectedly high price
203         }
204         return self.oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
205     }
206 
207     function oraclize_query(OraclizeData storage self, string datasource, string[] argN) internal returns (bytes32 id) {
208         return oraclize_query(self, 0, datasource, argN);
209     }
210 
211     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN) internal returns (bytes32 id) {
212         uint price = self.oraclize.getPrice(datasource);
213         if (price > 1 ether + tx.gasprice*200000) {
214             return 0; // unexpectedly high price
215         }
216         bytes memory args = stra2cbor(argN);
217         return self.oraclize.queryN.value(price)(timestamp, datasource, args);
218     }
219 
220     function oraclize_query(OraclizeData storage self, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id) {
221         return oraclize_query(self, 0, datasource, argN, gaslimit);
222     }
223 
224     function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, string[] argN, uint gaslimit) internal returns (bytes32 id){
225         uint price = self.oraclize.getPrice(datasource, gaslimit);
226         if (price > 1 ether + tx.gasprice*gaslimit) {
227             return 0; // unexpectedly high price
228         }
229         bytes memory args = stra2cbor(argN);
230         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
231     }
232 
233      function oraclize_query(OraclizeData storage self, uint timestamp, string datasource, bytes[] argN, uint gaslimit) internal returns (bytes32 id){
234         uint price = self.oraclize.getPrice(datasource, gaslimit);
235         if (price > 1 ether + tx.gasprice*gaslimit) {
236             return 0; // unexpectedly high price
237         }
238         bytes memory args = ba2cbor(argN);
239         return self.oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
240     }
241 
242     function oraclize_newRandomDSQuery(OraclizeData storage self, uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32) {
243         assert((_nbytes > 0) && (_nbytes <= 32));
244         bytes memory nbytes = new bytes(1);
245         nbytes[0] = byte(_nbytes);
246         bytes memory unonce = new bytes(32);
247         bytes memory sessionKeyHash = new bytes(32);
248         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash(self);
249         assembly {
250             mstore(unonce, 0x20)
251             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
252             mstore(sessionKeyHash, 0x20)
253             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
254         }
255         bytes[] memory args = new bytes[](3);
256         args[0] = unonce;
257         args[1] = nbytes;
258         args[2] = sessionKeyHash; 
259         bytes32 queryId = oraclize_query(self, _delay, "random", args, _customGasLimit);
260         oraclize_randomDS_setCommitment(self, queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
261         return queryId;
262     }
263 
264      function oraclize_randomDS_proofVerify__main(OraclizeData storage self, bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
265         bool checkok;
266         
267         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
268         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
269         bytes memory keyhash = new bytes(32);
270         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
271         checkok = (keccak256(keyhash) == keccak256(sha256(context_name, queryId)));
272         if (checkok == false) {
273             return false;
274         }
275         
276         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
277         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
278         
279         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
280         checkok = matchBytes32Prefix(sha256(sig1), result);
281         if (checkok == false) {
282             return false;
283         }
284         
285         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
286         // This is to verify that the computed args match with the ones specified in the query.
287         bytes memory commitmentSlice1 = new bytes(8+1+32);
288         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
289         
290         bytes memory sessionPubkey = new bytes(64);
291         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
292         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
293         
294         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
295         if (self.oraclizeRandomDSArgs[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)) {
296             delete self.oraclizeRandomDSArgs[queryId]; //unonce, nbytes and sessionKeyHash match
297         } else {
298             return false;
299         }
300 
301         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
302         bytes memory tosign1 = new bytes(32+8+1+32);
303         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
304         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
305         if (checkok == false) {
306             return false;
307         }
308 
309         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
310         if (self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] == false) {
311             self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
312         }
313         
314         return self.oraclizeRandomDsSessionKeyHashVerified[sessionPubkeyHash];
315     }
316 
317     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
318         bool sigok;
319         
320         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
321         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
322         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
323         
324         bytes memory appkey1_pubkey = new bytes(64);
325         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
326         
327         bytes memory tosign2 = new bytes(1+65+32);
328         tosign2[0] = 1; //role
329         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
330         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
331         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
332         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
333         
334         if (sigok == false) {
335             return false;
336         }
337         
338         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
339         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
340         
341         bytes memory tosign3 = new bytes(1+65);
342         tosign3[0] = 0xFE;
343         copyBytes(proof, 3, 65, tosign3, 1);
344         
345         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
346         copyBytes(proof, 3+65, sig3.length, sig3, 0);
347         
348         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
349         
350         return sigok;
351     }
352 
353     function oraclize_randomDS_proofVerify__returnCode(OraclizeData storage self, bytes32 _queryId, string _result, bytes _proof) internal returns (uint8) {
354         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
355         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) {
356             return 1;
357         }
358         bool proofVerified = oraclize_randomDS_proofVerify__main(self, _proof, _queryId, bytes(_result), oraclize_getNetworkName(self));
359         if (proofVerified == false) {
360             return 2;
361         }
362         return 0;
363     }
364     
365     function oraclize_randomDS_setCommitment(OraclizeData storage self, bytes32 queryId, bytes32 commitment) internal {
366         self.oraclizeRandomDSArgs[queryId] = commitment;
367     }
368     
369     function matchBytes32Prefix(bytes32 content, bytes prefix) internal pure returns (bool) {
370         bool match_ = true;
371         
372         for (uint i=0; i<prefix.length; i++) {
373             if (content[i] != prefix[i]) {
374                 match_ = false;
375             }
376         }
377         
378         return match_;
379     }
380 
381     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool) {
382         bool sigok;
383         address signer;
384         
385         bytes32 sigr;
386         bytes32 sigs;
387         
388         bytes memory sigr_ = new bytes(32);
389         uint offset = 4+(uint(dersig[3]) - 0x20);
390         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
391         bytes memory sigs_ = new bytes(32);
392         offset += 32 + 2;
393         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
394 
395         assembly {
396             sigr := mload(add(sigr_, 32))
397             sigs := mload(add(sigs_, 32))
398         }
399         
400         
401         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
402         if (address(keccak256(pubkey)) == signer) {
403             return true;
404         } else {
405             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
406             return (address(keccak256(pubkey)) == signer);
407         }
408     }
409 
410     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
411     // Duplicate Solidity's ecrecover, but catching the CALL return value
412     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
413         // We do our own memory management here. Solidity uses memory offset
414         // 0x40 to store the current end of memory. We write past it (as
415         // writes are memory extensions), but don't update the offset so
416         // Solidity will reuse it. The memory used here is only needed for
417         // this context.
418 
419         // FIXME: inline assembly can't access return values
420         bool ret;
421         address addr;
422 
423         assembly {
424             let size := mload(0x40)
425             mstore(size, hash)
426             mstore(add(size, 32), v)
427             mstore(add(size, 64), r)
428             mstore(add(size, 96), s)
429 
430             // NOTE: we can reuse the request memory because we deal with
431             //       the return code
432             ret := call(3000, 1, 0, size, 128, size, 32)
433             addr := mload(size)
434         }
435   
436         return (ret, addr);
437     }
438     
439     function oraclize_cbAddress(OraclizeData storage self) public constant returns (address) {
440         return self.oraclize.cbAddress();
441     }
442 
443     function oraclize_setProof(OraclizeData storage self, byte proofP) public {
444         return self.oraclize.setProofType(proofP);
445     }
446 
447     function oraclize_setCustomGasPrice(OraclizeData storage self, uint gasPrice) public {
448         return self.oraclize.setCustomGasPrice(gasPrice);
449     }
450 
451     function oraclize_setConfig(OraclizeData storage self, bytes32 config) public {
452         return self.oraclize.setConfig(config);
453     }
454 
455     function getCodeSize(address _addr) public constant returns(uint _size) {
456         assembly {
457             _size := extcodesize(_addr)
458         }
459     }
460     
461     function oraclize_randomDS_getSessionPubKeyHash(OraclizeData storage self) internal returns (bytes32){
462         return self.oraclize.randomDS_getSessionPubKeyHash();
463     }
464 
465     function stra2cbor(string[] arr) internal pure returns (bytes) {
466         uint arrlen = arr.length;
467 
468         // get correct cbor output length
469         uint outputlen = 0;
470         bytes[] memory elemArray = new bytes[](arrlen);
471         for (uint i = 0; i < arrlen; i++) {
472             elemArray[i] = (bytes(arr[i]));
473             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
474         }
475         uint ctr = 0;
476         uint cborlen = arrlen + 0x80;
477         outputlen += byte(cborlen).length;
478         bytes memory res = new bytes(outputlen);
479 
480         while (byte(cborlen).length > ctr) {
481             res[ctr] = byte(cborlen)[ctr];
482             ctr++;
483         }
484         for (i = 0; i < arrlen; i++) {
485             res[ctr] = 0x5F;
486             ctr++;
487             for (uint x = 0; x < elemArray[i].length; x++) {
488                 // if there's a bug with larger strings, this may be the culprit
489                 if (x % 23 == 0) {
490                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
491                     elemcborlen += 0x40;
492                     uint lctr = ctr;
493                     while (byte(elemcborlen).length > ctr - lctr) {
494                         res[ctr] = byte(elemcborlen)[ctr - lctr];
495                         ctr++;
496                     }
497                 }
498                 res[ctr] = elemArray[i][x];
499                 ctr++;
500             }
501             res[ctr] = 0xFF;
502             ctr++;
503         }
504         return res;
505     }
506 
507     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
508             uint arrlen = arr.length;
509 
510             // get correct cbor output length
511             uint outputlen = 0;
512             bytes[] memory elemArray = new bytes[](arrlen);
513             for (uint i = 0; i < arrlen; i++) {
514                 elemArray[i] = (bytes(arr[i]));
515                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
516             }
517             uint ctr = 0;
518             uint cborlen = arrlen + 0x80;
519             outputlen += byte(cborlen).length;
520             bytes memory res = new bytes(outputlen);
521 
522             while (byte(cborlen).length > ctr) {
523                 res[ctr] = byte(cborlen)[ctr];
524                 ctr++;
525             }
526             for (i = 0; i < arrlen; i++) {
527                 res[ctr] = 0x5F;
528                 ctr++;
529                 for (uint x = 0; x < elemArray[i].length; x++) {
530                     // if there's a bug with larger strings, this may be the culprit
531                     if (x % 23 == 0) {
532                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
533                         elemcborlen += 0x40;
534                         uint lctr = ctr;
535                         while (byte(elemcborlen).length > ctr - lctr) {
536                             res[ctr] = byte(elemcborlen)[ctr - lctr];
537                             ctr++;
538                         }
539                     }
540                     res[ctr] = elemArray[i][x];
541                     ctr++;
542                 }
543                 res[ctr] = 0xFF;
544                 ctr++;
545             }
546             return res;
547         }
548 
549     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
550         uint minLength = length + toOffset;
551 
552         assert (to.length >= minLength);
553 
554         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
555         uint i = 32 + fromOffset;
556         uint j = 32 + toOffset;
557 
558         while (i < (32 + fromOffset + length)) {
559             assembly {
560                 let tmp := mload(add(from, i))
561                 mstore(add(to, j), tmp)
562             }
563             i += 32;
564             j += 32;
565         }
566 
567         return to;
568     }
569 }
570 
571 contract Ownable {
572   address public owner;
573 
574 
575   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
576 
577 
578   /**
579    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
580    * account.
581    */
582   function Ownable() public {
583     owner = msg.sender;
584   }
585 
586 
587   /**
588    * @dev Throws if called by any account other than the owner.
589    */
590   modifier onlyOwner() {
591     require(msg.sender == owner);
592     _;
593   }
594 
595 
596   /**
597    * @dev Allows the current owner to transfer control of the contract to a newOwner.
598    * @param newOwner The address to transfer ownership to.
599    */
600   function transferOwnership(address newOwner) public onlyOwner {
601     require(newOwner != address(0));
602     OwnershipTransferred(owner, newOwner);
603     owner = newOwner;
604   }
605 
606 }
607 
608 contract RewardApprover is Ownable {
609 
610     FullERC20 public token;
611     RewardDistributable internal rewardDistributor;
612 
613     /// @dev transfers permissions to the distributor to distribute tokens
614     /// on its behalf.
615     function approveTokenTransfers() internal {
616         if (rewardDistributor == address(0) || token == address(0)) {
617             return;
618         }
619 
620         uint balance = token.balanceOf(this);
621         token.approve(rewardDistributor, balance);
622     }
623     
624     /// @dev Updates the reward distributor
625     function updateRewardDistributor(address newRewardDistributor) public onlyOwner {
626         rewardDistributor = RewardDistributable(newRewardDistributor);
627     }
628 }
629 
630 contract Cascading is Ownable {
631     using SafeMath for uint256;
632 
633     struct Cascade {
634         address cascade;
635         uint16 percentage;
636     }
637 
638     uint public totalCascadingPercentage;
639     Cascade[] public cascades;    
640 
641     /// @dev Adds an address and associated percentage for transfer.
642     /// @param newAddress The new address
643     function addCascade(address newAddress, uint newPercentage) public onlyOwner {
644         cascades.push(Cascade(newAddress, uint16(newPercentage)));
645         totalCascadingPercentage += newPercentage;
646     }
647 
648     /// @dev Deletes an address and associated percentage at the given index.
649     /// @param index The index of the cascade to be deleted.
650     function deleteCascade(uint index) public onlyOwner {
651         require(index < cascades.length);
652         
653         totalCascadingPercentage -= cascades[index].percentage;
654 
655         cascades[index] = cascades[cascades.length - 1];
656         delete cascades[cascades.length - 1];
657         cascades.length--;
658     }
659 
660     /// @dev Transfers the cascade values to the assigned addresses
661     /// @param totalJackpot the total jackpot amount
662     function transferCascades(uint totalJackpot) internal {
663         for (uint i = 0; i < cascades.length; i++) {
664             uint cascadeTotal = getCascadeTotal(cascades[i].percentage, totalJackpot);
665 
666             // Should be safe from re-entry given gas limit of 2300.
667             cascades[i].cascade.transfer(cascadeTotal);
668         }
669     }
670 
671     /// @dev Gets the cascade total for the given percentage
672     /// @param percentage the percentage of the total pot as a uint
673     /// @param totalJackpot the total jackpot amount
674     /// @return the total amount the percentage represents
675     function getCascadeTotal(uint percentage, uint totalJackpot) internal pure returns(uint) {
676         return totalJackpot.mul(percentage).div(100);        
677     }
678    
679     /// A utility method to calculate the total after cascades have been applied.
680     /// @param totalJackpot the total jackpot amount
681     /// @return the total amount after the cascades have been applied
682     function getTotalAfterCascades(uint totalJackpot) internal constant returns (uint) {
683         uint cascadeTotal = getCascadeTotal(totalCascadingPercentage, totalJackpot);
684         return totalJackpot.sub(cascadeTotal);
685     }
686 }
687 
688 contract SafeWinner is Ownable {
689     using SafeMath for uint256;
690 
691     mapping(address => uint) public pendingPayments;
692     address[] public pendingWinners;
693     uint public totalPendingPayments;
694 
695     event WinnerWithdrew(address indexed winner, uint amount, uint block);
696 
697     /// @dev records the winner so that a transfer or withdraw can occur at 
698     /// a later date.
699     function addPendingWinner(address winner, uint amount) internal {
700         pendingPayments[winner] = pendingPayments[winner].add(amount);
701         totalPendingPayments = totalPendingPayments.add(amount);
702         pendingWinners.push(winner);
703     }
704 
705     /// @dev allows a winner to withdraw their rightful jackpot.
706     function withdrawWinnings() public {
707         address winner = msg.sender;
708         uint payment = pendingPayments[winner];
709 
710         require(payment > 0);
711         require(this.balance >= payment);
712 
713         transferPending(winner, payment);
714     }
715 
716     /// @dev Retries all pending winners
717     function retryWinners() public onlyOwner {
718         for (uint i = 0; i < pendingWinners.length; i++) {
719             retryWinner(i);
720         }
721 
722         pendingWinners.length = 0;
723     }
724 
725     function retryWinner(uint index) public onlyOwner {
726         address winner = pendingWinners[index];
727         uint payment = pendingPayments[winner];
728         require(this.balance >= payment);
729         if (payment != 0) {
730             transferPending(winner, payment);
731         }
732     }
733 
734     function transferPending(address winner, uint256 payment) internal {
735         totalPendingPayments = totalPendingPayments.sub(payment);
736         pendingPayments[winner] = 0;
737         winner.transfer(payment);        
738         WinnerWithdrew(winner, payment, block.number);
739     }
740 }
741 
742 contract Raffle is Ownable, Priceable, SafeWinner, Cascading {
743   using SafeMath for uint256;
744   using OraclizeLib for OraclizeLib.OraclizeData;
745 
746   enum RaffleState { Active, InActive, PendingInActive }
747   enum RandomSource { RandomDS, Qrng }
748 
749   struct Jackpot {
750     uint absoluteTotal;
751     uint feeTotal;
752     uint cascadeTotal;
753     uint winnerTotal;
754   }
755 
756   struct TicketHolder {
757     address purchaser;
758     uint16 count;
759     uint80 runningTotal;
760   }
761   
762   // public
763   RaffleState public raffleState;
764   RandomSource public randomSource;
765   uint public ticketPrice;
766   uint public gameId;
767   uint public fee;
768   
769 
770   // internal
771   TicketHolder[] internal ticketHolders;
772   uint internal randomBytes;
773   uint internal randomQueried;
774   uint internal callbackGas;
775   RewardDistributable internal rewardDistributor;
776 
777   // oraclize
778   OraclizeLib.OraclizeData oraclizeData;
779 
780   // events
781   event TicketPurchased(address indexed ticketPurchaser, uint indexed id, uint numTickets, uint totalCost, uint block);
782   event WinnerSelected(address indexed winner, uint indexed id, uint winnings, uint block);
783   event RandomProofFailed(bytes32 queryId, uint indexed id, uint block);
784 
785   function Raffle(uint _ticketPrice, address _rewardDistributor) public {
786     ticketPrice = _ticketPrice;
787     raffleState = RaffleState.Active;
788     callbackGas = 200000;
789     randomBytes = 8;
790     fee = 5 finney;
791     rewardDistributor = RewardDistributable(_rewardDistributor);
792     oraclizeData.initializeOraclize();
793     randomSource = RandomSource.Qrng;
794     resetRaffle();
795   }
796 
797   /// @dev Returns whether the game is active.
798   function isActive() public constant returns (bool) {
799     return raffleState == RaffleState.Active || raffleState == RaffleState.PendingInActive;
800   }
801   
802   /// @dev Fallback function to purchase a single ticket.
803   function () public payable {
804   }
805    
806   /// @dev Gets the projected jackpot.
807   /// @return The projected jackpot amount.
808   function getProjectedJackpot() public constant returns (uint) {
809     uint jackpot = getAbsoluteProjectedJackpot();
810     Jackpot memory totals = getJackpotTotals(jackpot);
811     return totals.winnerTotal;
812   }
813 
814   /// @dev Gets the actual jackpot
815   /// @return The actual jackpot amount.
816   function getJackpot() public constant returns (uint) {
817     uint jackpot = getAbsoluteJackpot();
818     Jackpot memory totals = getJackpotTotals(jackpot);
819     return totals.winnerTotal;
820   }
821 
822   /// @dev Gets the ticket holder count
823   /// @return The total ticket holder count
824   function getTicketHolderCount() public constant returns (uint) {
825     return getTotalTickets();
826   }
827 
828   /// @dev Updates the ticket price.
829   function updateTicketPrice(uint updatedPrice) public onlyOwner {
830     require(raffleState == RaffleState.InActive);
831     require(updatedPrice > 0);
832     ticketPrice = updatedPrice;
833   }
834 
835   /// @dev Updates the ticket price.
836   function updateFee(uint updatedFee) public onlyOwner {
837     require(updatedFee > 0);
838     fee = updatedFee;
839   }
840 
841   /// @dev Deactivates the raffle after the next game.
842   function deactivate() public onlyOwner {
843     require(raffleState == RaffleState.Active);
844     raffleState = ticketHolders.length == 0 ? RaffleState.InActive : RaffleState.PendingInActive;
845   }
846 
847   /// @dev Activates the raffle, if inactivated.
848   function activate() public onlyOwner {
849     require(raffleState == RaffleState.InActive);
850     raffleState = RaffleState.Active;
851   }
852 
853   /// The oraclize callback function.
854   function __callback(bytes32 queryId, string result, bytes proof) public {
855     require(msg.sender == oraclizeData.oraclize_cbAddress());
856     
857     // We only expect this for this callback
858     if (oraclizeData.oraclize_randomDS_proofVerify__returnCode(queryId, result, proof) != 0) {
859       RandomProofFailed(queryId, gameId, now);
860       randomQueried = 0;
861       return;
862     }
863 
864     __callback(queryId, result);
865   }
866 
867   /// The oraclize callback function.
868   function __callback(bytes32 queryId, string result) public {
869     require(msg.sender == oraclizeData.oraclize_cbAddress());
870     
871     // Guard against the case where oraclize is triggered, or calls back multiple times.
872     if (!shouldChooseWinner()) {
873       return;
874     }
875 
876     uint maxRange = 2**(8*randomBytes); 
877     uint randomNumber = uint(keccak256(result)) % maxRange; 
878     winnerSelected(randomNumber);
879   }
880 
881   /// @dev An administrative function to allow in case the proof fails or 
882   /// a random winner needs to be chosen again.
883   function forceChooseRandomWinner() public onlyOwner {
884     require(raffleState != RaffleState.InActive);
885     executeRandomQuery();
886   }
887 
888   /// @dev Forces a refund for all participants and deactivates the contract
889   /// This offers a full refund, so it will be up to the owner to ensure a full balance.
890   function forceRefund() public onlyOwner {
891     raffleState = RaffleState.PendingInActive;
892 
893     uint total = getTotalTickets() * ticketPrice;
894     require(this.balance > total);
895 
896     for (uint i = 0; i < ticketHolders.length; i++) {
897       TicketHolder storage holder = ticketHolders[i];
898       holder.purchaser.transfer(uint256(holder.count).mul(ticketPrice));
899     }
900 
901     resetRaffle();
902   }
903 
904   /// @dev Destroys the current contract and moves all ETH back to  
905   function updateRewardDistributor(address newRewardDistributor) public onlyOwner {
906     rewardDistributor = RewardDistributable(newRewardDistributor);
907   }
908 
909   /// @dev Destroys the current contract and moves all ETH back to
910   /// owner. Only can occur after state has been set to inactive.
911   function destroy() public onlyOwner {
912     require(raffleState == RaffleState.InActive);
913     selfdestruct(owner);
914   }
915 
916   /// Gets the projected jackpot prior to any fees
917   /// @return The projected jackpot prior to any fees
918   function getAbsoluteProjectedJackpot() internal constant returns (uint);
919 
920   /// Gets the actual jackpot prior to any fees
921   /// @return The actual jackpot amount prior to any fees.
922   function getAbsoluteJackpot() internal constant returns (uint);
923   
924   /// An abstract function which determines whether a it is appropriate to choose a winner.
925   /// @return True if it is appropriate to choose the winner, false otherwise.
926   function shouldChooseWinner() internal returns (bool);
927 
928   function executeRandomQuery() internal {
929     if (randomSource == RandomSource.RandomDS) {
930       oraclizeData.oraclize_newRandomDSQuery(0, randomBytes, callbackGas);
931     }
932     else {
933       oraclizeData.oraclize_query("URL","json(https://qrng.anu.edu.au/API/jsonI.php?length=1&type=hex16&size=32).data[0]", callbackGas);
934     }
935   }
936 
937   /// Chooses the winner at random.
938   function chooseWinner() internal {
939     // We build in a buffer of 20 blocks.  Approx 1 block per 15 secs ~ 5 mins
940     // the last time random was queried, we'll execute again.
941     if (randomQueried < (block.number.sub(20))) {
942       executeRandomQuery();
943       randomQueried = block.number;
944     }
945   }
946 
947   /// Internal function for when a winner is chosen.
948   function winnerSelected(uint randomNumber) internal {
949     TicketHolder memory winner = getWinningTicketHolder(randomNumber);
950     uint jackpot = getAbsoluteJackpot();
951     Jackpot memory jackpotTotals = getJackpotTotals(jackpot);
952 
953     WinnerSelected(winner.purchaser, gameId, jackpotTotals.winnerTotal, now);    
954     transferJackpot(winner.purchaser, jackpotTotals.winnerTotal);
955     transferCascades(jackpotTotals.absoluteTotal);
956     resetRaffle();
957   }
958 
959   function getWinningTicketHolder(uint randomNumber) internal view returns(TicketHolder) {
960     assert(ticketHolders.length > 0);
961     uint totalTickets = getTotalTickets();
962     uint winner = (randomNumber % totalTickets) + 1;
963 
964     uint min = 0;
965     uint max = ticketHolders.length-1;
966     while (max > min) {
967         uint mid = (max + min + 1) / 2;
968         if (ticketHolders[mid].runningTotal >= winner &&
969          (ticketHolders[mid].runningTotal-ticketHolders[mid].count) < winner) {
970            return ticketHolders[mid];
971         }
972 
973         if (ticketHolders[mid].runningTotal <= winner) {
974             min = mid;
975         } else {
976             max = mid-1;
977         }
978     }
979 
980     return ticketHolders[min];
981   }
982 
983   /// Transfers the jackpot to the winner triggering the event
984   function transferJackpot(address winner, uint jackpot) internal returns(uint) {
985     // We explicitly do not use transfer here because if the 
986     // the call fails, the oraclize contract will not retry.
987     bool sendSuccessful = winner.send(jackpot);
988     if (!sendSuccessful) {
989       addPendingWinner(winner, jackpot);
990     }
991 
992     return jackpot;
993   }
994 
995   /// Resets the raffle game state.
996   function resetRaffle() internal {
997     if (raffleState == RaffleState.PendingInActive) {
998       raffleState = RaffleState.InActive;
999     }
1000     ticketHolders.length = 0;
1001     gameId = block.number;
1002     randomQueried = 0;
1003   }
1004 
1005   /// Gets the jackpot after fees
1006   function getJackpotTotals(uint jackpot) internal constant returns(Jackpot) {
1007     if (jackpot < fee) {
1008       return Jackpot(0, 0, 0, 0);
1009     }
1010 
1011     uint cascadeTotal = getCascadeTotal(totalCascadingPercentage, jackpot);
1012     return Jackpot(jackpot, fee, cascadeTotal, jackpot.sub(fee).sub(cascadeTotal));
1013   }
1014 
1015   function updateRandomSource(uint newRandomSource) public onlyOwner {
1016     if (newRandomSource == 1) {
1017       randomSource = RandomSource.RandomDS;
1018     } else {
1019       randomSource = RandomSource.Qrng;
1020     }
1021 
1022     setProof();
1023   }
1024 
1025 
1026   function setProof() internal {
1027       if (randomSource == RandomSource.RandomDS) {
1028         // proofType_Ledger = 0x30;
1029         oraclizeData.oraclize_setProof(0x30);
1030       }
1031       else {
1032         oraclizeData.oraclize_setProof(0x00);
1033       }
1034   }
1035 
1036   function getTotalTickets() internal view returns(uint) {
1037     return ticketHolders.length == 0 ? 0 : ticketHolders[ticketHolders.length-1].runningTotal;
1038   }
1039 
1040   function updateOraclizeGas(uint newCallbackGas, uint customGasPrice) public onlyOwner {
1041     callbackGas = newCallbackGas;
1042     updateCustomGasPrice(customGasPrice);
1043   }
1044 
1045   function updateCustomGasPrice(uint customGasPrice) internal {
1046     oraclizeData.oraclize_setCustomGasPrice(customGasPrice);
1047   }
1048 }
1049 
1050 contract DateBasedRaffle is Ownable, Raffle {
1051   using SafeMath for uint256;
1052 
1053   uint public nextDrawTime;
1054   uint public drawPeriod;
1055   uint public minJackpot;
1056 
1057   /// @dev Constructor for conventional raffle
1058   /// @param _ticketPrice The ticket price.
1059   /// @param _drawPeriod The number of tickets for a draw to take place.
1060   function DateBasedRaffle(uint _ticketPrice, uint _drawPeriod) Raffle(_ticketPrice, address(0)) public {
1061     drawPeriod = _drawPeriod;
1062     nextDrawTime = now.add(_drawPeriod);
1063     minJackpot = 20 finney;
1064   }
1065 
1066   /// @dev Gets the projected jackpot.
1067   function getAbsoluteProjectedJackpot() internal constant returns (uint) {
1068     return this.balance - totalPendingPayments; 
1069   }
1070 
1071   /// @dev Gets the actual jackpot
1072   function getAbsoluteJackpot() internal constant returns (uint) {
1073     return this.balance - totalPendingPayments;
1074   }
1075   
1076   /// An abstract function which determines whether a it is appropriate to choose a winner.
1077   /// @return True if it is appropriate to choose the winner, false otherwise.
1078   function shouldChooseWinner() internal returns (bool) {
1079     uint jackpot = getAbsoluteJackpot();
1080     Jackpot memory jackpotTotals = getJackpotTotals(jackpot);
1081     return now > nextDrawTime && jackpotTotals.winnerTotal > minJackpot;
1082   }
1083 
1084   function resetRaffle() internal {
1085     nextDrawTime = now.add(drawPeriod);
1086     Raffle.resetRaffle();
1087   }
1088 
1089   function updateDrawPeriod(uint newDrawPeriod) public onlyOwner {
1090     drawPeriod = newDrawPeriod;
1091   }
1092 }
1093 
1094 contract ProgressiveRaffle is Ownable, RewardApprover, DateBasedRaffle {
1095   
1096   uint public tokenTicketPrice; // price for a ticket with whole tokens
1097   FullERC20 public token;
1098 
1099   /// @dev Constructor for conventional raffle
1100   function ProgressiveRaffle(uint _tokenTicketPrice, uint _timePeriod, address tokenAddress) DateBasedRaffle(0, _timePeriod) public {
1101     tokenTicketPrice = _tokenTicketPrice;
1102     token = FullERC20(tokenAddress);
1103   }
1104 
1105   /// @dev Purchases tickets to the raffle.
1106   /// @param numTickets Number of tickets to purchase.
1107   function purchaseTicket(uint numTickets, address referrer) public payable costsExactly(0) {
1108     require(raffleState != RaffleState.InActive);
1109     require(numTickets < 65536);
1110     // transfer the tokens
1111     assert(token.transferFrom(msg.sender, this, numTickets.mul(tokenTicketPrice).mul(10**uint256(token.decimals()))));
1112     
1113     // Add the address to the ticketHolders.
1114     uint totalTickets = getTotalTickets();
1115     ticketHolders.push(TicketHolder(msg.sender, uint16(numTickets), uint80(totalTickets.add(numTickets))));
1116 
1117     TicketPurchased(msg.sender, gameId, numTickets, ticketPrice.mul(numTickets), now);
1118 
1119     if (shouldChooseWinner()) {
1120       chooseWinner();
1121     }
1122   }
1123 
1124   /// Internal function for when a winner is chosen.
1125   function winnerSelected(uint randomNumber) internal {
1126     uint jackpot = getAbsoluteJackpot();
1127     Jackpot memory jackpotTotals = getJackpotTotals(jackpot);
1128 
1129     TicketHolder memory winner = getWinningTicketHolder(randomNumber);
1130     WinnerSelected(winner.purchaser, gameId, jackpotTotals.winnerTotal, now);    
1131     transferJackpot(winner.purchaser, jackpotTotals.winnerTotal);
1132     transferCascades(jackpotTotals.absoluteTotal);
1133 
1134     approveTokenTransfers(); // Put the tokens back into the pool.
1135     resetRaffle();
1136   }
1137 
1138   /// @dev Updates the token ticket price
1139   function updateTokenTicketPrice(uint newTokenTicketPrice) public onlyOwner {
1140     tokenTicketPrice = newTokenTicketPrice;
1141   }
1142 
1143   /// @dev Updates the token address of the payment type.
1144   function updateToken(address newToken) public onlyOwner {
1145     token = FullERC20(newToken);
1146   }
1147 
1148    /// @dev Destroys the current contract and moves all ETH back to
1149   /// owner. Only can occur after state has been set to inactive.
1150   function destroy() public onlyOwner {
1151     require(raffleState == RaffleState.InActive);
1152     if (token != address(0)) {
1153       assert(token.transfer(owner, token.balanceOf(this)));
1154     }
1155     selfdestruct(owner);
1156   }
1157 
1158   /// @dev Forces a refund for all participants and deactivates the contract
1159   /// This offers a full refund, so it will be up to the owner to ensure a full balance.
1160   function forceRefund() public onlyOwner {
1161     raffleState = RaffleState.PendingInActive;
1162 
1163     uint total = getTotalTickets() * ticketPrice;
1164     require(this.balance > total);
1165 
1166     for (uint i = 0; i < ticketHolders.length; i++) {
1167       TicketHolder storage holder = ticketHolders[i];
1168       assert(token.transfer(
1169           holder.purchaser, 
1170           uint256(holder.count).mul(tokenTicketPrice).mul(10**uint256(token.decimals()))));
1171     }
1172 
1173     resetRaffle();
1174   }
1175 }
1176 
1177 contract RewardDistributable {
1178     event TokensRewarded(address indexed player, address rewardToken, uint rewards, address requester, uint gameId, uint block);
1179     event ReferralRewarded(address indexed referrer, address indexed player, address rewardToken, uint rewards, uint gameId, uint block);
1180     event ReferralRegistered(address indexed player, address indexed referrer);
1181 
1182     /// @dev Calculates and transfers the rewards to the player.
1183     function transferRewards(address player, uint entryAmount, uint gameId) public;
1184 
1185     /// @dev Returns the total number of tokens, across all approvals.
1186     function getTotalTokens(address tokenAddress) public constant returns(uint);
1187 
1188     /// @dev Returns the total number of supported reward token contracts.
1189     function getRewardTokenCount() public constant returns(uint);
1190 
1191     /// @dev Gets the total number of approvers.
1192     function getTotalApprovers() public constant returns(uint);
1193 
1194     /// @dev Gets the reward rate inclusive of referral bonus.
1195     function getRewardRate(address player, address tokenAddress) public constant returns(uint);
1196 
1197     /// @dev Adds a requester to the whitelist.
1198     /// @param requester The address of a contract which will request reward transfers
1199     function addRequester(address requester) public;
1200 
1201     /// @dev Removes a requester from the whitelist.
1202     /// @param requester The address of a contract which will request reward transfers
1203     function removeRequester(address requester) public;
1204 
1205     /// @dev Adds a approver address.  Approval happens with the token contract.
1206     /// @param approver The approver address to add to the pool.
1207     function addApprover(address approver) public;
1208 
1209     /// @dev Removes an approver address. 
1210     /// @param approver The approver address to remove from the pool.
1211     function removeApprover(address approver) public;
1212 
1213     /// @dev Updates the reward rate
1214     function updateRewardRate(address tokenAddress, uint newRewardRate) public;
1215 
1216     /// @dev Updates the token address of the payment type.
1217     function addRewardToken(address tokenAddress, uint newRewardRate) public;
1218 
1219     /// @dev Updates the token address of the payment type.
1220     function removeRewardToken(address tokenAddress) public;
1221 
1222     /// @dev Updates the referral bonus rate
1223     function updateReferralBonusRate(uint newReferralBonusRate) public;
1224 
1225     /// @dev Registers the player with the given referral code
1226     /// @param player The address of the player
1227     /// @param referrer The address of the referrer
1228     function registerReferral(address player, address referrer) public;
1229 
1230     /// @dev Transfers any tokens to the owner
1231     function destroyRewards() public;
1232 }