1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     function Ownable() {
17         owner = msg.sender;
18     }
19 
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner {
35         if (newOwner != address(0)) {
36             owner = newOwner;
37         }
38     }
39 }
40 
41 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
42 
43 contract ERC20 is Ownable {
44     /* Public variables of the token */
45     string public standard;
46 
47     string public name;
48 
49     string public symbol;
50 
51     uint8 public decimals;
52 
53     uint256 public initialSupply;
54 
55     bool public locked;
56 
57     uint256 public creationBlock;
58 
59     mapping (address => uint256) public balances;
60 
61     mapping (address => mapping (address => uint256)) public allowance;
62 
63     /* This generates a public event on the blockchain that will notify clients */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     modifier onlyPayloadSize(uint numwords) {
67         assert(msg.data.length == numwords * 32 + 4);
68         _;
69     }
70 
71     /* Initializes contract with initial supply tokens to the creator of the contract */
72     function ERC20(
73         uint256 _initialSupply,
74         string tokenName,
75         uint8 decimalUnits,
76         string tokenSymbol,
77         bool transferAllSupplyToOwner,
78         bool _locked
79     ) {
80         standard = 'ERC20 0.1';
81 
82         initialSupply = _initialSupply;
83 
84         if (transferAllSupplyToOwner) {
85             setBalance(msg.sender, initialSupply);
86         }
87         else {
88             setBalance(this, initialSupply);
89         }
90 
91         name = tokenName;
92         // Set the name for display purposes
93         symbol = tokenSymbol;
94         // Set the symbol for display purposes
95         decimals = decimalUnits;
96         // Amount of decimals for display purposes
97         locked = _locked;
98         creationBlock = block.number;
99     }
100 
101     /* internal balances */
102 
103     function setBalance(address holder, uint256 amount) internal {
104         balances[holder] = amount;
105     }
106 
107     function transferInternal(address _from, address _to, uint256 value) internal returns (bool success) {
108         if (value == 0) {
109             return true;
110         }
111 
112         if (balances[_from] < value) {
113             return false;
114         }
115 
116         if (balances[_to] + value <= balances[_to]) {
117             return false;
118         }
119 
120         setBalance(_from, balances[_from] - value);
121         setBalance(_to, balances[_to] + value);
122 
123         Transfer(_from, _to, value);
124 
125         return true;
126     }
127 
128     /* public methods */
129     function totalSupply() returns (uint256) {
130         return initialSupply;
131     }
132 
133     function balanceOf(address _address) returns (uint256) {
134         return balances[_address];
135     }
136 
137     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool) {
138         require(locked == false);
139         bool status = transferInternal(msg.sender, _to, _value);
140         require(status == true);
141 
142         return true;
143     }
144 
145     function approve(address _spender, uint256 _value) returns (bool success) {
146         if(locked) {
147             return false;
148         }
149 
150         allowance[msg.sender][_spender] = _value;
151 
152         return true;
153     }
154 
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
156         if (locked) {
157             return false;
158         }
159 
160         tokenRecipient spender = tokenRecipient(_spender);
161 
162         if (approve(_spender, _value)) {
163             spender.receiveApproval(msg.sender, _value, this, _extraData);
164             return true;
165         }
166     }
167 
168     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
169         if (locked) {
170             return false;
171         }
172 
173         if (allowance[_from][msg.sender] < _value) {
174             return false;
175         }
176 
177         bool _success = transferInternal(_from, _to, _value);
178 
179         if (_success) {
180             allowance[_from][msg.sender] -= _value;
181         }
182 
183         return _success;
184     }
185 }
186 contract ZeusPhases is ERC20 {
187 
188     uint256 public soldTokens;
189 
190     Phase[] public phases;
191 
192     struct Phase {
193         uint256 price;
194         uint256 maxAmount;
195         uint256 minCap;
196         uint256 since;
197         uint256 till;
198         bool isSucceed;
199     }
200 
201     function ZeusPhases(
202         uint256 initialSupply,
203         uint8 precision,
204         string tokenName,
205         string tokenSymbol,
206         bool transferAllSupplyToOwner,
207         bool _locked
208     ) ERC20(initialSupply, tokenName, precision, tokenSymbol, transferAllSupplyToOwner, _locked) {
209         standard = 'PhaseICO 0.1';
210     }
211 
212     function getIcoTokensAmount(uint256 value, uint256 time) returns (uint256) {
213         if (value == 0) {
214             return 0;
215         }
216 
217         uint256 amount = 0;
218         uint256 soldAmount = 0;
219 
220         for (uint i = 0; i < phases.length; i++) {
221             Phase storage phase = phases[i];
222             if (phase.since > time) {
223                 continue;
224             }
225 
226             if (phase.till < time) {
227                 continue;
228             }
229 
230             uint256 phaseAmount = value * (uint256(10) ** decimals) / phase.price;
231 
232             soldAmount += phaseAmount;
233 
234             uint256 bonusAmount;
235 
236             if(i == 0) {
237                 bonusAmount = getPreICOBonusAmount(time, phaseAmount);
238             }
239 
240             if(i == 1) {
241                 bonusAmount = getICOBonusAmount(time, phaseAmount);
242             }
243 
244             amount += phaseAmount + bonusAmount;
245         
246             if (phase.maxAmount < amount + soldTokens) {
247                 return 0;
248             }
249         }
250 
251         //Minimum investment (Euro transfer) in issuer wallet (# of tokens) for preICO & for ICO
252         if (soldAmount < 10 * uint256(10) ** decimals) {
253             return 0;
254         }
255 
256         return amount;
257     }
258 
259     function getPreICOBonusAmount(uint256 time, uint256 amount) returns (uint256) {
260         Phase storage icoPhase = phases[0];
261 
262         if (time < icoPhase.since) {
263             return 0;
264         }
265 
266         if (time > icoPhase.till) {
267             return 0;
268         }
269 
270         return amount * 50 / 100;
271     }
272 
273     function getICOBonusAmount(uint256 time, uint256 amount) returns (uint256) {
274         Phase storage icoPhase = phases[1];
275 
276         if (time < icoPhase.since) {
277             return 0;
278         }
279         if (time - icoPhase.since < 691200) {// 8d since ico => reward 30%;
280             return amount * 30 / 100;
281         }
282         else if (time - icoPhase.since < 1296000) {// 15d since ico => reward 20%
283             return amount * 20 / 100;
284         }
285         else if (time - icoPhase.since < 1987200) {// 23d since ico => reward 15%
286             return amount * 15 / 100;
287         }
288         else if (time - icoPhase.since < 2592000) {// 30d since ico => reward 10%
289             return amount * 10 / 100;
290         }
291 
292         return 0;
293     }
294 
295 }
296 
297 // <ORACLIZE_API>
298 /*
299 Copyright (c) 2015-2016 Oraclize SRL
300 Copyright (c) 2016 Oraclize LTD
301 
302 
303 
304 Permission is hereby granted, free of charge, to any person obtaining a copy
305 of this software and associated documentation files (the "Software"), to deal
306 in the Software without restriction, including without limitation the rights
307 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
308 copies of the Software, and to permit persons to whom the Software is
309 furnished to do so, subject to the following conditions:
310 
311 
312 
313 The above copyright notice and this permission notice shall be included in
314 all copies or substantial portions of the Software.
315 
316 
317 
318 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
319 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
320 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
321 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
322 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
323 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
324 THE SOFTWARE.
325 */
326 
327 contract OraclizeI {
328     address public cbAddress;
329     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
330     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
331     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
332     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
333     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
334     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
335     function getPrice(string _datasource) returns (uint _dsprice);
336     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
337     function useCoupon(string _coupon);
338     function setProofType(byte _proofType);
339     function setConfig(bytes32 _config);
340     function setCustomGasPrice(uint _gasPrice);
341     function randomDS_getSessionPubKeyHash() returns(bytes32);
342 }
343 contract OraclizeAddrResolverI {
344     function getAddress() returns (address _addr);
345 }
346 contract usingOraclize {
347     uint constant day = 60*60*24;
348     uint constant week = 60*60*24*7;
349     uint constant month = 60*60*24*30;
350     byte constant proofType_NONE = 0x00;
351     byte constant proofType_TLSNotary = 0x10;
352     byte constant proofType_Android = 0x20;
353     byte constant proofType_Ledger = 0x30;
354     byte constant proofType_Native = 0xF0;
355     byte constant proofStorage_IPFS = 0x01;
356     uint8 constant networkID_auto = 0;
357     uint8 constant networkID_mainnet = 1;
358     uint8 constant networkID_testnet = 2;
359     uint8 constant networkID_morden = 2;
360     uint8 constant networkID_consensys = 161;
361 
362     OraclizeAddrResolverI OAR;
363 
364     OraclizeI oraclize;
365     modifier oraclizeAPI {
366         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
367         oraclize = OraclizeI(OAR.getAddress());
368         _;
369     }
370     modifier coupon(string code){
371         oraclize = OraclizeI(OAR.getAddress());
372         oraclize.useCoupon(code);
373         _;
374     }
375 
376     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
377         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
378             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
379             oraclize_setNetworkName("eth_mainnet");
380             return true;
381         }
382         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
383             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
384             oraclize_setNetworkName("eth_ropsten3");
385             return true;
386         }
387         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
388             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
389             oraclize_setNetworkName("eth_kovan");
390             return true;
391         }
392         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
393             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
394             oraclize_setNetworkName("eth_rinkeby");
395             return true;
396         }
397         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
398             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
399             return true;
400         }
401         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
402             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
403             return true;
404         }
405         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
406             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
407             return true;
408         }
409         return false;
410     }
411 
412     function __callback(bytes32 myid, string result) {
413         __callback(myid, result, new bytes(0));
414     }
415     function __callback(bytes32 myid, string result, bytes proof) {
416     }
417     
418     function oraclize_useCoupon(string code) oraclizeAPI internal {
419         oraclize.useCoupon(code);
420     }
421 
422     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
423         return oraclize.getPrice(datasource);
424     }
425 
426     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
427         return oraclize.getPrice(datasource, gaslimit);
428     }
429     
430     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource);
432         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
433         return oraclize.query.value(price)(0, datasource, arg);
434     }
435     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
436         uint price = oraclize.getPrice(datasource);
437         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
438         return oraclize.query.value(price)(timestamp, datasource, arg);
439     }
440     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
441         uint price = oraclize.getPrice(datasource, gaslimit);
442         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
443         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
444     }
445     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
446         uint price = oraclize.getPrice(datasource, gaslimit);
447         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
448         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
449     }
450     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
451         uint price = oraclize.getPrice(datasource);
452         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
453         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
454     }
455     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
456         uint price = oraclize.getPrice(datasource);
457         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
458         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
459     }
460     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
461         uint price = oraclize.getPrice(datasource, gaslimit);
462         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
463         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
464     }
465     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
466         uint price = oraclize.getPrice(datasource, gaslimit);
467         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
468         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
469     }
470     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
471         uint price = oraclize.getPrice(datasource);
472         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
473         bytes memory args = stra2cbor(argN);
474         return oraclize.queryN.value(price)(0, datasource, args);
475     }
476     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
477         uint price = oraclize.getPrice(datasource);
478         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
479         bytes memory args = stra2cbor(argN);
480         return oraclize.queryN.value(price)(timestamp, datasource, args);
481     }
482     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
483         uint price = oraclize.getPrice(datasource, gaslimit);
484         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
485         bytes memory args = stra2cbor(argN);
486         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
487     }
488     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
489         uint price = oraclize.getPrice(datasource, gaslimit);
490         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
491         bytes memory args = stra2cbor(argN);
492         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
493     }
494     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](1);
496         dynargs[0] = args[0];
497         return oraclize_query(datasource, dynargs);
498     }
499     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](1);
501         dynargs[0] = args[0];
502         return oraclize_query(timestamp, datasource, dynargs);
503     }
504     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         string[] memory dynargs = new string[](1);
506         dynargs[0] = args[0];
507         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
508     }
509     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](1);
511         dynargs[0] = args[0];       
512         return oraclize_query(datasource, dynargs, gaslimit);
513     }
514     
515     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](2);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         return oraclize_query(datasource, dynargs);
520     }
521     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](2);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         return oraclize_query(timestamp, datasource, dynargs);
526     }
527     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](2);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
532     }
533     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](2);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         return oraclize_query(datasource, dynargs, gaslimit);
538     }
539     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
540         string[] memory dynargs = new string[](3);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         dynargs[2] = args[2];
544         return oraclize_query(datasource, dynargs);
545     }
546     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
547         string[] memory dynargs = new string[](3);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         return oraclize_query(timestamp, datasource, dynargs);
552     }
553     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](3);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
559     }
560     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
561         string[] memory dynargs = new string[](3);
562         dynargs[0] = args[0];
563         dynargs[1] = args[1];
564         dynargs[2] = args[2];
565         return oraclize_query(datasource, dynargs, gaslimit);
566     }
567     
568     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](4);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         dynargs[2] = args[2];
573         dynargs[3] = args[3];
574         return oraclize_query(datasource, dynargs);
575     }
576     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
577         string[] memory dynargs = new string[](4);
578         dynargs[0] = args[0];
579         dynargs[1] = args[1];
580         dynargs[2] = args[2];
581         dynargs[3] = args[3];
582         return oraclize_query(timestamp, datasource, dynargs);
583     }
584     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
585         string[] memory dynargs = new string[](4);
586         dynargs[0] = args[0];
587         dynargs[1] = args[1];
588         dynargs[2] = args[2];
589         dynargs[3] = args[3];
590         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
591     }
592     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
593         string[] memory dynargs = new string[](4);
594         dynargs[0] = args[0];
595         dynargs[1] = args[1];
596         dynargs[2] = args[2];
597         dynargs[3] = args[3];
598         return oraclize_query(datasource, dynargs, gaslimit);
599     }
600     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
601         string[] memory dynargs = new string[](5);
602         dynargs[0] = args[0];
603         dynargs[1] = args[1];
604         dynargs[2] = args[2];
605         dynargs[3] = args[3];
606         dynargs[4] = args[4];
607         return oraclize_query(datasource, dynargs);
608     }
609     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
610         string[] memory dynargs = new string[](5);
611         dynargs[0] = args[0];
612         dynargs[1] = args[1];
613         dynargs[2] = args[2];
614         dynargs[3] = args[3];
615         dynargs[4] = args[4];
616         return oraclize_query(timestamp, datasource, dynargs);
617     }
618     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
619         string[] memory dynargs = new string[](5);
620         dynargs[0] = args[0];
621         dynargs[1] = args[1];
622         dynargs[2] = args[2];
623         dynargs[3] = args[3];
624         dynargs[4] = args[4];
625         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
626     }
627     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
628         string[] memory dynargs = new string[](5);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         dynargs[2] = args[2];
632         dynargs[3] = args[3];
633         dynargs[4] = args[4];
634         return oraclize_query(datasource, dynargs, gaslimit);
635     }
636     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
637         uint price = oraclize.getPrice(datasource);
638         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
639         bytes memory args = ba2cbor(argN);
640         return oraclize.queryN.value(price)(0, datasource, args);
641     }
642     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
643         uint price = oraclize.getPrice(datasource);
644         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
645         bytes memory args = ba2cbor(argN);
646         return oraclize.queryN.value(price)(timestamp, datasource, args);
647     }
648     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
649         uint price = oraclize.getPrice(datasource, gaslimit);
650         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
651         bytes memory args = ba2cbor(argN);
652         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
653     }
654     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
655         uint price = oraclize.getPrice(datasource, gaslimit);
656         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
657         bytes memory args = ba2cbor(argN);
658         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
659     }
660     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](1);
662         dynargs[0] = args[0];
663         return oraclize_query(datasource, dynargs);
664     }
665     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](1);
667         dynargs[0] = args[0];
668         return oraclize_query(timestamp, datasource, dynargs);
669     }
670     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
671         bytes[] memory dynargs = new bytes[](1);
672         dynargs[0] = args[0];
673         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
674     }
675     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](1);
677         dynargs[0] = args[0];       
678         return oraclize_query(datasource, dynargs, gaslimit);
679     }
680     
681     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](2);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         return oraclize_query(datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](2);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         return oraclize_query(timestamp, datasource, dynargs);
692     }
693     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](2);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
698     }
699     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](2);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         return oraclize_query(datasource, dynargs, gaslimit);
704     }
705     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
706         bytes[] memory dynargs = new bytes[](3);
707         dynargs[0] = args[0];
708         dynargs[1] = args[1];
709         dynargs[2] = args[2];
710         return oraclize_query(datasource, dynargs);
711     }
712     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
713         bytes[] memory dynargs = new bytes[](3);
714         dynargs[0] = args[0];
715         dynargs[1] = args[1];
716         dynargs[2] = args[2];
717         return oraclize_query(timestamp, datasource, dynargs);
718     }
719     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
720         bytes[] memory dynargs = new bytes[](3);
721         dynargs[0] = args[0];
722         dynargs[1] = args[1];
723         dynargs[2] = args[2];
724         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
725     }
726     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
727         bytes[] memory dynargs = new bytes[](3);
728         dynargs[0] = args[0];
729         dynargs[1] = args[1];
730         dynargs[2] = args[2];
731         return oraclize_query(datasource, dynargs, gaslimit);
732     }
733     
734     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](4);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         dynargs[2] = args[2];
739         dynargs[3] = args[3];
740         return oraclize_query(datasource, dynargs);
741     }
742     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
743         bytes[] memory dynargs = new bytes[](4);
744         dynargs[0] = args[0];
745         dynargs[1] = args[1];
746         dynargs[2] = args[2];
747         dynargs[3] = args[3];
748         return oraclize_query(timestamp, datasource, dynargs);
749     }
750     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
751         bytes[] memory dynargs = new bytes[](4);
752         dynargs[0] = args[0];
753         dynargs[1] = args[1];
754         dynargs[2] = args[2];
755         dynargs[3] = args[3];
756         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
757     }
758     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
759         bytes[] memory dynargs = new bytes[](4);
760         dynargs[0] = args[0];
761         dynargs[1] = args[1];
762         dynargs[2] = args[2];
763         dynargs[3] = args[3];
764         return oraclize_query(datasource, dynargs, gaslimit);
765     }
766     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
767         bytes[] memory dynargs = new bytes[](5);
768         dynargs[0] = args[0];
769         dynargs[1] = args[1];
770         dynargs[2] = args[2];
771         dynargs[3] = args[3];
772         dynargs[4] = args[4];
773         return oraclize_query(datasource, dynargs);
774     }
775     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
776         bytes[] memory dynargs = new bytes[](5);
777         dynargs[0] = args[0];
778         dynargs[1] = args[1];
779         dynargs[2] = args[2];
780         dynargs[3] = args[3];
781         dynargs[4] = args[4];
782         return oraclize_query(timestamp, datasource, dynargs);
783     }
784     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
785         bytes[] memory dynargs = new bytes[](5);
786         dynargs[0] = args[0];
787         dynargs[1] = args[1];
788         dynargs[2] = args[2];
789         dynargs[3] = args[3];
790         dynargs[4] = args[4];
791         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
792     }
793     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
794         bytes[] memory dynargs = new bytes[](5);
795         dynargs[0] = args[0];
796         dynargs[1] = args[1];
797         dynargs[2] = args[2];
798         dynargs[3] = args[3];
799         dynargs[4] = args[4];
800         return oraclize_query(datasource, dynargs, gaslimit);
801     }
802 
803     function oraclize_cbAddress() oraclizeAPI internal returns (address){
804         return oraclize.cbAddress();
805     }
806     function oraclize_setProof(byte proofP) oraclizeAPI internal {
807         return oraclize.setProofType(proofP);
808     }
809     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
810         return oraclize.setCustomGasPrice(gasPrice);
811     }
812     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
813         return oraclize.setConfig(config);
814     }
815     
816     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
817         return oraclize.randomDS_getSessionPubKeyHash();
818     }
819 
820     function getCodeSize(address _addr) constant internal returns(uint _size) {
821         assembly {
822             _size := extcodesize(_addr)
823         }
824     }
825 
826     function parseAddr(string _a) internal returns (address){
827         bytes memory tmp = bytes(_a);
828         uint160 iaddr = 0;
829         uint160 b1;
830         uint160 b2;
831         for (uint i=2; i<2+2*20; i+=2){
832             iaddr *= 256;
833             b1 = uint160(tmp[i]);
834             b2 = uint160(tmp[i+1]);
835             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
836             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
837             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
838             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
839             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
840             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
841             iaddr += (b1*16+b2);
842         }
843         return address(iaddr);
844     }
845 
846     function strCompare(string _a, string _b) internal returns (int) {
847         bytes memory a = bytes(_a);
848         bytes memory b = bytes(_b);
849         uint minLength = a.length;
850         if (b.length < minLength) minLength = b.length;
851         for (uint i = 0; i < minLength; i ++)
852             if (a[i] < b[i])
853                 return -1;
854             else if (a[i] > b[i])
855                 return 1;
856         if (a.length < b.length)
857             return -1;
858         else if (a.length > b.length)
859             return 1;
860         else
861             return 0;
862     }
863 
864     function indexOf(string _haystack, string _needle) internal returns (int) {
865         bytes memory h = bytes(_haystack);
866         bytes memory n = bytes(_needle);
867         if(h.length < 1 || n.length < 1 || (n.length > h.length))
868             return -1;
869         else if(h.length > (2**128 -1))
870             return -1;
871         else
872         {
873             uint subindex = 0;
874             for (uint i = 0; i < h.length; i ++)
875             {
876                 if (h[i] == n[0])
877                 {
878                     subindex = 1;
879                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
880                     {
881                         subindex++;
882                     }
883                     if(subindex == n.length)
884                         return int(i);
885                 }
886             }
887             return -1;
888         }
889     }
890 
891     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
892         bytes memory _ba = bytes(_a);
893         bytes memory _bb = bytes(_b);
894         bytes memory _bc = bytes(_c);
895         bytes memory _bd = bytes(_d);
896         bytes memory _be = bytes(_e);
897         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
898         bytes memory babcde = bytes(abcde);
899         uint k = 0;
900         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
901         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
902         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
903         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
904         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
905         return string(babcde);
906     }
907 
908     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
909         return strConcat(_a, _b, _c, _d, "");
910     }
911 
912     function strConcat(string _a, string _b, string _c) internal returns (string) {
913         return strConcat(_a, _b, _c, "", "");
914     }
915 
916     function strConcat(string _a, string _b) internal returns (string) {
917         return strConcat(_a, _b, "", "", "");
918     }
919 
920     // parseInt
921     function parseInt(string _a) internal returns (uint) {
922         return parseInt(_a, 0);
923     }
924 
925     // parseInt(parseFloat*10^_b)
926     function parseInt(string _a, uint _b) internal returns (uint) {
927         bytes memory bresult = bytes(_a);
928         uint mint = 0;
929         bool decimals = false;
930         for (uint i=0; i<bresult.length; i++){
931             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
932                 if (decimals){
933                    if (_b == 0) break;
934                     else _b--;
935                 }
936                 mint *= 10;
937                 mint += uint(bresult[i]) - 48;
938             } else if (bresult[i] == 46) decimals = true;
939         }
940         if (_b > 0) mint *= 10**_b;
941         return mint;
942     }
943 
944     function uint2str(uint i) internal returns (string){
945         if (i == 0) return "0";
946         uint j = i;
947         uint len;
948         while (j != 0){
949             len++;
950             j /= 10;
951         }
952         bytes memory bstr = new bytes(len);
953         uint k = len - 1;
954         while (i != 0){
955             bstr[k--] = byte(48 + i % 10);
956             i /= 10;
957         }
958         return string(bstr);
959     }
960     
961     function stra2cbor(string[] arr) internal returns (bytes) {
962             uint arrlen = arr.length;
963 
964             // get correct cbor output length
965             uint outputlen = 0;
966             bytes[] memory elemArray = new bytes[](arrlen);
967             for (uint i = 0; i < arrlen; i++) {
968                 elemArray[i] = (bytes(arr[i]));
969                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
970             }
971             uint ctr = 0;
972             uint cborlen = arrlen + 0x80;
973             outputlen += byte(cborlen).length;
974             bytes memory res = new bytes(outputlen);
975 
976             while (byte(cborlen).length > ctr) {
977                 res[ctr] = byte(cborlen)[ctr];
978                 ctr++;
979             }
980             for (i = 0; i < arrlen; i++) {
981                 res[ctr] = 0x5F;
982                 ctr++;
983                 for (uint x = 0; x < elemArray[i].length; x++) {
984                     // if there's a bug with larger strings, this may be the culprit
985                     if (x % 23 == 0) {
986                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
987                         elemcborlen += 0x40;
988                         uint lctr = ctr;
989                         while (byte(elemcborlen).length > ctr - lctr) {
990                             res[ctr] = byte(elemcborlen)[ctr - lctr];
991                             ctr++;
992                         }
993                     }
994                     res[ctr] = elemArray[i][x];
995                     ctr++;
996                 }
997                 res[ctr] = 0xFF;
998                 ctr++;
999             }
1000             return res;
1001         }
1002 
1003     function ba2cbor(bytes[] arr) internal returns (bytes) {
1004             uint arrlen = arr.length;
1005 
1006             // get correct cbor output length
1007             uint outputlen = 0;
1008             bytes[] memory elemArray = new bytes[](arrlen);
1009             for (uint i = 0; i < arrlen; i++) {
1010                 elemArray[i] = (bytes(arr[i]));
1011                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1012             }
1013             uint ctr = 0;
1014             uint cborlen = arrlen + 0x80;
1015             outputlen += byte(cborlen).length;
1016             bytes memory res = new bytes(outputlen);
1017 
1018             while (byte(cborlen).length > ctr) {
1019                 res[ctr] = byte(cborlen)[ctr];
1020                 ctr++;
1021             }
1022             for (i = 0; i < arrlen; i++) {
1023                 res[ctr] = 0x5F;
1024                 ctr++;
1025                 for (uint x = 0; x < elemArray[i].length; x++) {
1026                     // if there's a bug with larger strings, this may be the culprit
1027                     if (x % 23 == 0) {
1028                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1029                         elemcborlen += 0x40;
1030                         uint lctr = ctr;
1031                         while (byte(elemcborlen).length > ctr - lctr) {
1032                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1033                             ctr++;
1034                         }
1035                     }
1036                     res[ctr] = elemArray[i][x];
1037                     ctr++;
1038                 }
1039                 res[ctr] = 0xFF;
1040                 ctr++;
1041             }
1042             return res;
1043         }
1044         
1045         
1046     string oraclize_network_name;
1047     function oraclize_setNetworkName(string _network_name) internal {
1048         oraclize_network_name = _network_name;
1049     }
1050     
1051     function oraclize_getNetworkName() internal returns (string) {
1052         return oraclize_network_name;
1053     }
1054     
1055     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1056         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1057         bytes memory nbytes = new bytes(1);
1058         nbytes[0] = byte(_nbytes);
1059         bytes memory unonce = new bytes(32);
1060         bytes memory sessionKeyHash = new bytes(32);
1061         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1062         assembly {
1063             mstore(unonce, 0x20)
1064             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1065             mstore(sessionKeyHash, 0x20)
1066             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1067         }
1068         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
1069         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
1070         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
1071         return queryId;
1072     }
1073     
1074     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1075         oraclize_randomDS_args[queryId] = commitment;
1076     }
1077     
1078     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1079     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1080 
1081     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1082         bool sigok;
1083         address signer;
1084         
1085         bytes32 sigr;
1086         bytes32 sigs;
1087         
1088         bytes memory sigr_ = new bytes(32);
1089         uint offset = 4+(uint(dersig[3]) - 0x20);
1090         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1091         bytes memory sigs_ = new bytes(32);
1092         offset += 32 + 2;
1093         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1094 
1095         assembly {
1096             sigr := mload(add(sigr_, 32))
1097             sigs := mload(add(sigs_, 32))
1098         }
1099         
1100         
1101         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1102         if (address(sha3(pubkey)) == signer) return true;
1103         else {
1104             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1105             return (address(sha3(pubkey)) == signer);
1106         }
1107     }
1108 
1109     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1110         bool sigok;
1111         
1112         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1113         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1114         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1115         
1116         bytes memory appkey1_pubkey = new bytes(64);
1117         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1118         
1119         bytes memory tosign2 = new bytes(1+65+32);
1120         tosign2[0] = 1; //role
1121         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1122         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1123         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1124         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1125         
1126         if (sigok == false) return false;
1127         
1128         
1129         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1130         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1131         
1132         bytes memory tosign3 = new bytes(1+65);
1133         tosign3[0] = 0xFE;
1134         copyBytes(proof, 3, 65, tosign3, 1);
1135         
1136         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1137         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1138         
1139         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1140         
1141         return sigok;
1142     }
1143     
1144     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1145         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1146         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1147         
1148         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1149         if (proofVerified == false) throw;
1150         
1151         _;
1152     }
1153     
1154     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1155         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1156         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1157         
1158         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1159         if (proofVerified == false) return 2;
1160         
1161         return 0;
1162     }
1163     
1164     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1165         bool match_ = true;
1166         
1167         for (var i=0; i<prefix.length; i++){
1168             if (content[i] != prefix[i]) match_ = false;
1169         }
1170         
1171         return match_;
1172     }
1173 
1174     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1175         bool checkok;
1176         
1177         
1178         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1179         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1180         bytes memory keyhash = new bytes(32);
1181         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1182         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1183         if (checkok == false) return false;
1184         
1185         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1186         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1187         
1188         
1189         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1190         checkok = matchBytes32Prefix(sha256(sig1), result);
1191         if (checkok == false) return false;
1192         
1193         
1194         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1195         // This is to verify that the computed args match with the ones specified in the query.
1196         bytes memory commitmentSlice1 = new bytes(8+1+32);
1197         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1198         
1199         bytes memory sessionPubkey = new bytes(64);
1200         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1201         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1202         
1203         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1204         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1205             delete oraclize_randomDS_args[queryId];
1206         } else return false;
1207         
1208         
1209         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1210         bytes memory tosign1 = new bytes(32+8+1+32);
1211         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1212         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1213         if (checkok == false) return false;
1214         
1215         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1216         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1217             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1218         }
1219         
1220         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1221     }
1222 
1223     
1224     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1225     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1226         uint minLength = length + toOffset;
1227 
1228         if (to.length < minLength) {
1229             // Buffer too small
1230             throw; // Should be a better way?
1231         }
1232 
1233         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1234         uint i = 32 + fromOffset;
1235         uint j = 32 + toOffset;
1236 
1237         while (i < (32 + fromOffset + length)) {
1238             assembly {
1239                 let tmp := mload(add(from, i))
1240                 mstore(add(to, j), tmp)
1241             }
1242             i += 32;
1243             j += 32;
1244         }
1245 
1246         return to;
1247     }
1248     
1249     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1250     // Duplicate Solidity's ecrecover, but catching the CALL return value
1251     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1252         // We do our own memory management here. Solidity uses memory offset
1253         // 0x40 to store the current end of memory. We write past it (as
1254         // writes are memory extensions), but don't update the offset so
1255         // Solidity will reuse it. The memory used here is only needed for
1256         // this context.
1257 
1258         // FIXME: inline assembly can't access return values
1259         bool ret;
1260         address addr;
1261 
1262         assembly {
1263             let size := mload(0x40)
1264             mstore(size, hash)
1265             mstore(add(size, 32), v)
1266             mstore(add(size, 64), r)
1267             mstore(add(size, 96), s)
1268 
1269             // NOTE: we can reuse the request memory because we deal with
1270             //       the return code
1271             ret := call(3000, 1, 0, size, 128, size, 32)
1272             addr := mload(size)
1273         }
1274   
1275         return (ret, addr);
1276     }
1277 
1278     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1279     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1280         bytes32 r;
1281         bytes32 s;
1282         uint8 v;
1283 
1284         if (sig.length != 65)
1285           return (false, 0);
1286 
1287         // The signature format is a compact form of:
1288         //   {bytes32 r}{bytes32 s}{uint8 v}
1289         // Compact means, uint8 is not padded to 32 bytes.
1290         assembly {
1291             r := mload(add(sig, 32))
1292             s := mload(add(sig, 64))
1293 
1294             // Here we are loading the last 32 bytes. We exploit the fact that
1295             // 'mload' will pad with zeroes if we overread.
1296             // There is no 'mload8' to do this, but that would be nicer.
1297             v := byte(0, mload(add(sig, 96)))
1298 
1299             // Alternative solution:
1300             // 'byte' is not working due to the Solidity parser, so lets
1301             // use the second best option, 'and'
1302             // v := and(mload(add(sig, 65)), 255)
1303         }
1304 
1305         // albeit non-transactional signatures are not specified by the YP, one would expect it
1306         // to match the YP range of [27, 28]
1307         //
1308         // geth uses [0, 1] and some clients have followed. This might change, see:
1309         //  https://github.com/ethereum/go-ethereum/issues/2053
1310         if (v < 27)
1311           v += 27;
1312 
1313         if (v != 27 && v != 28)
1314             return (false, 0);
1315 
1316         return safer_ecrecover(hash, v, r, s);
1317     }
1318         
1319 }
1320 // </ORACLIZE_API>
1321 contract ZeusPriceTicker is usingOraclize, ZeusPhases {
1322 
1323     uint256 public priceUpdateAt;
1324 
1325     event newOraclizeQuery(string description);
1326     event newZeusPriceTicker(string price);
1327 
1328     function ZeusPriceTicker(
1329         uint256 initialSupply,
1330         uint8 decimalUnits,
1331         string tokenName,
1332         string tokenSymbol,
1333         bool transferAllSupplyToOwner,
1334         bool _locked
1335     ) ZeusPhases(initialSupply, decimalUnits, tokenName, tokenSymbol, transferAllSupplyToOwner, _locked) {
1336         priceUpdateAt = now;
1337         oraclize_setNetwork(networkID_auto);
1338         oraclize = OraclizeI(OAR.getAddress());
1339     }
1340 
1341     function __callback(bytes32, string result, bytes) {
1342 //    function __callback(bytes32 myid, string result, bytes proof) {
1343         require(msg.sender == oraclize_cbAddress());
1344 
1345         uint256 price = 10 ** 23 / parseInt(result, 5);
1346 
1347         require(price > 0);
1348         for (uint i = 0; i < phases.length; i++) {
1349             Phase storage phase = phases[i];
1350             phase.price = price;
1351         }
1352 
1353         newZeusPriceTicker(result);
1354     }
1355 
1356     function update() internal {
1357         if (oraclize_getPrice("URL") > this.balance) {
1358             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1359         } else {
1360             newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1361             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHEUR).result.XETHZEUR.c.0");
1362         }
1363     }
1364 
1365 }
1366 
1367 contract Zeus is ZeusPriceTicker {
1368 
1369     uint256 public tokenPrice; //0.00420168 ether; 19/09/17 11:20 am
1370 
1371     uint256 public collectedEthers;
1372 
1373     uint256 public burnTimeChange;
1374 
1375     address distributionAddress1;
1376 
1377     address distributionAddress2;
1378 
1379     address distributionAddress3;
1380 
1381     address distributionAddress4;
1382 
1383     address distributionAddress5;
1384 
1385     address successFeeAcc;
1386 
1387     address bountyAcc;
1388 
1389     bool isBurned;
1390 
1391     mapping (address => uint256) public icoEtherBalances;
1392 
1393     event Refund(address holder, uint256 ethers, uint256 tokens);
1394 
1395     function Zeus(
1396         string tokenName,
1397         string tokenSymbol,
1398         uint256 initialSupply,
1399         uint8 decimalUnits,
1400         uint256 _tokenPrice,
1401         uint256 _preIcoSince,
1402         uint256 _preIcoTill,
1403         uint256 preIcoMaxAmount,
1404         uint256 _icoSince,
1405         uint256 _icoTill,
1406         uint256 icoMaxAmount,
1407         uint256 icoMinCap,
1408         uint256 _burnTimeChange,
1409         bool _locked
1410     ) ZeusPriceTicker(initialSupply, decimalUnits, tokenName, tokenSymbol, false, _locked) {
1411         standard = 'Zeus 0.1';
1412         tokenPrice = _tokenPrice;
1413         burnTimeChange = _burnTimeChange;
1414 
1415         phases.push(Phase(tokenPrice, preIcoMaxAmount, 0, _preIcoSince, _preIcoTill, false));
1416         phases.push(Phase(tokenPrice, icoMaxAmount, icoMinCap, _icoSince, _icoTill, false));
1417 
1418         distributionAddress1 = 0xB3927748906763F5906C83Ed105be1C1A6d03FFE;
1419         distributionAddress2 = 0x8e749918fC86e3F40d1C1a1457a0f98905cD456A;
1420         distributionAddress3 = 0x648340938fBF7b2F2A676FCCB806cd597279cA3a;
1421         distributionAddress4 = 0xd4564281fAE29Ca5c7345Fe9a4602E6b35857dA3;
1422         distributionAddress5 = 0x6Ed01383BfdCe351A616321B1A8D08De003D493A;
1423         successFeeAcc = 0xdA39e0Ce2adf93129D04F53176c7Bfaaae8B051a;
1424         bountyAcc = 0x0064952457905eBFB9c0292200A74B1d7414F081;
1425     }
1426 
1427     function setSellPrice(uint256 value) onlyOwner {
1428         require(value > 0);
1429         for (uint i = 0; i < phases.length; i++) {
1430             Phase storage phase = phases[i];
1431             phase.price = value;
1432         }
1433     }
1434 
1435     function buy(address _address, uint256 time, uint256 value) internal returns (bool) {
1436         if (locked == true) {
1437             return false;
1438         }
1439 
1440         if (priceUpdateAt + 3600 < now){
1441             update();
1442             priceUpdateAt = now;
1443         }
1444 
1445         uint256 amount = getIcoTokensAmount(value, time);
1446 
1447         if (amount == 0) {
1448             return false;
1449         }
1450 
1451         bool status = transferInternal(this, _address, amount);
1452 
1453         if (status) {
1454             onSuccessfulBuy(_address, value, amount, time);
1455         }
1456 
1457         return status;
1458     }
1459 
1460     function onSuccessfulBuy(address _address, uint256 value, uint256 amount, uint256 time) internal {
1461         collectedEthers += value;
1462         soldTokens += amount;
1463 
1464         Phase storage phase = phases[1];
1465         if (phase.since > time) {
1466             return;
1467         }
1468         if (phase.till < time) {
1469             return;
1470         }
1471         icoEtherBalances[_address] += value;
1472     }
1473 
1474     function() payable {
1475         bool status = buy(msg.sender, now, msg.value);
1476 
1477         require(status == true);
1478     }
1479 
1480     function isSucceed(uint8 phaseId) returns (bool) {
1481         if (phases.length < phaseId) {
1482             return false;
1483         }
1484 
1485         Phase storage phase = phases[phaseId];
1486 
1487         if (phase.isSucceed == true) {
1488             return true;
1489         }
1490 
1491         if (phase.till > now) {
1492             return false;
1493         }
1494 
1495         if (phase.minCap != 0 && phase.minCap > soldTokens) {
1496             return false;
1497         }
1498 
1499         phase.isSucceed = true;
1500 
1501         if (phaseId == 0) {
1502             sendPreICOEthers();
1503         }
1504         if (phaseId == 1) {
1505             sendICOEthers();
1506         }
1507 
1508         return true;
1509     }
1510 
1511     function sendPreICOEthers() internal {
1512         if (collectedEthers > 0) {
1513             distributionAddress1.transfer(collectedEthers * 87 / 100);
1514             distributionAddress2.transfer(collectedEthers * 5 / 100);
1515             distributionAddress3.transfer(collectedEthers * 5 / 100);
1516             successFeeAcc.transfer(this.balance);
1517         }
1518     }
1519 
1520     function sendICOEthers() internal {
1521         uint256 ethers = this.balance;
1522         if (ethers > 0) {
1523             distributionAddress5.transfer(ethers * 42 / 100);
1524             distributionAddress4.transfer(ethers * 30 / 100);
1525             distributionAddress1.transfer(ethers * 15 / 100);
1526             distributionAddress3.transfer(ethers * 5 / 100);
1527             distributionAddress2.transfer(ethers * 5 / 100);
1528             successFeeAcc.transfer(this.balance);
1529         }
1530     }
1531 
1532     function refund() returns (bool) {
1533         Phase storage icoPhase = phases[1];
1534         if (icoPhase.till > now) {
1535             return false;
1536         }
1537         if (icoPhase.till < now && icoPhase.minCap <= soldTokens) {
1538             return false;
1539         }
1540         if (icoEtherBalances[msg.sender] == 0) {
1541             return false;
1542         }
1543         setBalance(msg.sender, 0);
1544         uint256 refundAmount = icoEtherBalances[msg.sender];
1545         icoEtherBalances[msg.sender] = 0;
1546         msg.sender.transfer(refundAmount);
1547     }
1548 
1549     function burn() onlyOwner returns (bool){
1550 
1551         Phase storage icoPhase = phases[1];
1552 
1553         if (isSucceed(1) == false) {
1554             return false;
1555         }
1556 
1557         if (icoPhase.till + burnTimeChange > now) {
1558             return false;
1559         }
1560 
1561         if (isBurned) {
1562             return false;
1563         }
1564 
1565         isBurned = true;
1566 
1567         transferInternal(this, distributionAddress1, soldTokens * 15 / 100);
1568         transferInternal(this, bountyAcc, soldTokens * 2 / 100);
1569 
1570         setBalance(this, 0);
1571 
1572         return true;
1573     }
1574 
1575     function issue(address _addr, uint256 _amount) onlyOwner returns (bool){
1576         if (_amount > 0 ) {
1577             bool status = transferInternal(this, _addr, _amount);
1578             if (status) {
1579                 soldTokens += _amount;
1580             }
1581             return status;
1582         }
1583 
1584         return false;
1585     }
1586 
1587     function setLocked(bool _locked) onlyOwner {
1588         locked = _locked;
1589     }
1590 
1591 }