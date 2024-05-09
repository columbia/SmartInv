1 pragma solidity ^0.4.17;
2 
3 contract ExtendData {
4     
5    struct User {
6         bytes32 username;
7         bool verified;
8     }
9 
10     modifier onlyOwners {
11         require(owners[msg.sender]);
12         _;
13     }
14 
15     mapping(bytes32 => address) usernameToAddress;
16     mapping(bytes32 => address) queryToAddress;
17     mapping(address => mapping(bytes32 => uint)) tips;
18     mapping(address => mapping(bytes32 => uint)) lastTip;
19     mapping(bytes32 => uint) balances;
20     mapping(address => User) users;   
21     mapping(address => bool) owners;
22     
23     function ExtendData() public {
24         owners[msg.sender] = true;
25     }
26     
27     //getters
28     function getAddressForUsername(bytes32 _username) public constant onlyOwners returns (address) {
29         return usernameToAddress[_username];
30     }
31 
32     function getAddressForQuery(bytes32 _queryId) public constant onlyOwners returns (address) {
33         return queryToAddress[_queryId];
34     }
35     
36     function getBalanceForUser(bytes32 _username) public constant onlyOwners returns (uint) {
37         return balances[_username];
38     }
39     
40     function getUserVerified(address _address) public constant onlyOwners returns (bool) {
41         return users[_address].verified;
42     }
43     
44     function getUserUsername(address _address) public constant onlyOwners returns (bytes32) {
45         return users[_address].username;
46     }
47 
48     function getTip(address _from, bytes32 _to) public constant onlyOwners  returns (uint) {
49         return tips[_from][_to];
50     }
51   
52     function getLastTipTime(address _from, bytes32 _to) public constant onlyOwners returns (uint) {
53         return lastTip[_from][_to];
54     }
55 
56     //setters
57     function setQueryIdForAddress(bytes32 _queryId, address _address) public onlyOwners {
58         queryToAddress[_queryId] = _address;
59     }
60    
61     function setBalanceForUser(bytes32 _username, uint _balance) public onlyOwners {
62         balances[_username] = _balance;
63     }
64  
65     function setUsernameForAddress(bytes32 _username, address _address) public onlyOwners {
66         usernameToAddress[_username] = _address;
67     }
68 
69     function setVerified(address _address) public onlyOwners {
70         users[_address].verified = true;
71     }
72 
73     function addTip(address _from, bytes32 _to, uint _tip) public onlyOwners {
74         tips[_from][_to] += _tip;
75         balances[_to] += _tip;
76         lastTip[_from][_to] = now;     
77     }
78 
79     function addUser(address _address, bytes32 _username) public onlyOwners {
80         users[_address] = User({
81                 username: _username,
82                 verified: false
83             });
84     }
85 
86     function removeTip(address _from, bytes32 _to) public onlyOwners {
87         balances[_to] -= tips[_from][_to];
88         tips[_from][_to] = 0;
89     }
90     
91     //owner modification
92     function addOwner(address _address) public onlyOwners {
93         owners[_address] = true;
94     }
95     
96     function removeOwner(address _address) public onlyOwners {
97         owners[_address] = false;
98     }
99 }
100 
101 pragma solidity ^0.4.17;
102 
103 contract ExtendEvents {
104 
105     event LogQuery(bytes32 query, address userAddress);
106     event LogBalance(uint balance);
107     event LogNeededBalance(uint balance);
108     event CreatedUser(bytes32 username);
109     event UsernameDoesNotMatch(bytes32 username, bytes32 neededUsername);
110     event VerifiedUser(bytes32 username);
111     event UserTipped(address from, bytes32 indexed username, uint val);
112     event WithdrawSuccessful(bytes32 username);
113     event CheckAddressVerified(address userAddress);
114     event RefundSuccessful(address from, bytes32 username);
115     event GoldBought(uint price, address from, bytes32 to, string months, string priceUsd, string commentId, string nonce, string signature);
116 
117     mapping(address => bool) owners;
118 
119     modifier onlyOwners() {
120         require(owners[msg.sender]);
121         _;
122     }
123 
124     function ExtendEvents() {
125         owners[msg.sender] = true;
126     }
127 
128     function addOwner(address _address) onlyOwners {
129         owners[_address] = true;
130     }
131 
132     function removeOwner(address _address) onlyOwners {
133         owners[_address] = false;
134     }
135 
136     function goldBought(uint _price, 
137                         address _from, 
138                         bytes32 _to, 
139                         string _months,
140                         string _priceUsd, 
141                         string _commentId,
142                         string _nonce, 
143                         string _signature) onlyOwners {
144                             
145         GoldBought(_price, _from, _to, _months, _priceUsd, _commentId, _nonce, _signature);
146     }
147 
148     function createdUser(bytes32 _username) onlyOwners {
149         CreatedUser(_username);
150     }
151 
152     function refundSuccessful(address _from, bytes32 _username) onlyOwners {
153         RefundSuccessful(_from, _username);
154     }
155 
156     function usernameDoesNotMatch(bytes32 _username, bytes32 _neededUsername) onlyOwners {
157         UsernameDoesNotMatch(_username, _neededUsername);
158     }
159 
160     function verifiedUser(bytes32 _username) onlyOwners {
161         VerifiedUser(_username);
162     }
163 
164     function userTipped(address _from, bytes32 _username, uint _val) onlyOwners {
165         UserTipped(_from, _username, _val);
166     }
167 
168     function withdrawSuccessful(bytes32 _username) onlyOwners {
169         WithdrawSuccessful(_username);
170     }
171 
172     function logQuery(bytes32 _query, address _userAddress) onlyOwners {
173         LogQuery(_query, _userAddress);
174     }
175 
176     function logBalance(uint _balance) onlyOwners {
177         LogBalance(_balance);
178     }
179 
180     function logNeededBalance(uint _balance) onlyOwners {
181         LogNeededBalance(_balance);
182     }
183 
184 }
185 
186 
187 pragma solidity ^0.4.17;
188 
189 // <ORACLIZE_API>
190 /*
191 Copyright (c) 2015-2016 Oraclize SRL
192 Copyright (c) 2016 Oraclize LTD
193 
194 
195 
196 Permission is hereby granted, free of charge, to any person obtaining a copy
197 of this software and associated documentation files (the "Software"), to deal
198 in the Software without restriction, including without limitation the rights
199 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
200 copies of the Software, and to permit persons to whom the Software is
201 furnished to do so, subject to the following conditions:
202 
203 
204 
205 The above copyright notice and this permission notice shall be included in
206 all copies or substantial portions of the Software.
207 
208 
209 
210 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
211 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
212 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
213 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
214 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
215 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
216 THE SOFTWARE.
217 */
218 
219 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
220 
221 contract OraclizeI {
222     address public cbAddress;
223     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
224     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
225     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
226     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
227     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
228     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
229     function getPrice(string _datasource) returns (uint _dsprice);
230     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
231     function useCoupon(string _coupon);
232     function setProofType(byte _proofType);
233     function setConfig(bytes32 _config);
234     function setCustomGasPrice(uint _gasPrice);
235     function randomDS_getSessionPubKeyHash() returns(bytes32);
236 }
237 contract OraclizeAddrResolverI {
238     function getAddress() returns (address _addr);
239 }
240 contract usingOraclize {
241     uint constant day = 60*60*24;
242     uint constant week = 60*60*24*7;
243     uint constant month = 60*60*24*30;
244     byte constant proofType_NONE = 0x00;
245     byte constant proofType_TLSNotary = 0x10;
246     byte constant proofType_Android = 0x20;
247     byte constant proofType_Ledger = 0x30;
248     byte constant proofType_Native = 0xF0;
249     byte constant proofStorage_IPFS = 0x01;
250     uint8 constant networkID_auto = 0;
251     uint8 constant networkID_mainnet = 1;
252     uint8 constant networkID_testnet = 2;
253     uint8 constant networkID_morden = 2;
254     uint8 constant networkID_consensys = 161;
255 
256     OraclizeAddrResolverI OAR;
257 
258     OraclizeI oraclize;
259     modifier oraclizeAPI {
260         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
261         oraclize = OraclizeI(OAR.getAddress());
262         _;
263     }
264     modifier coupon(string code){
265         oraclize = OraclizeI(OAR.getAddress());
266         oraclize.useCoupon(code);
267         _;
268     }
269 
270     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
271         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
272             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
273             oraclize_setNetworkName("eth_mainnet");
274             return true;
275         }
276         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
277             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
278             oraclize_setNetworkName("eth_ropsten3");
279             return true;
280         }
281         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
282             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
283             oraclize_setNetworkName("eth_kovan");
284             return true;
285         }
286         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
287             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
288             oraclize_setNetworkName("eth_rinkeby");
289             return true;
290         }
291         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
292             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
293             return true;
294         }
295         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
296             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
297             return true;
298         }
299         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
300             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
301             return true;
302         }
303         return false;
304     }
305 
306     function __callback(bytes32 myid, string result) {
307         __callback(myid, result, new bytes(0));
308     }
309     function __callback(bytes32 myid, string result, bytes proof) {
310     }
311     
312     function oraclize_useCoupon(string code) oraclizeAPI internal {
313         oraclize.useCoupon(code);
314     }
315 
316     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
317         return oraclize.getPrice(datasource);
318     }
319 
320     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
321         return oraclize.getPrice(datasource, gaslimit);
322     }
323     
324     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
325         uint price = oraclize.getPrice(datasource);
326         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
327         return oraclize.query.value(price)(0, datasource, arg);
328     }
329     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
330         uint price = oraclize.getPrice(datasource);
331         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
332         return oraclize.query.value(price)(timestamp, datasource, arg);
333     }
334     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
335         uint price = oraclize.getPrice(datasource, gaslimit);
336         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
337         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
338     }
339     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
340         uint price = oraclize.getPrice(datasource, gaslimit);
341         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
342         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
343     }
344     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
345         uint price = oraclize.getPrice(datasource);
346         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
347         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
348     }
349     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
350         uint price = oraclize.getPrice(datasource);
351         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
352         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
353     }
354     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
355         uint price = oraclize.getPrice(datasource, gaslimit);
356         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
357         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
358     }
359     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
360         uint price = oraclize.getPrice(datasource, gaslimit);
361         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
362         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
363     }
364     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
365         uint price = oraclize.getPrice(datasource);
366         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
367         bytes memory args = stra2cbor(argN);
368         return oraclize.queryN.value(price)(0, datasource, args);
369     }
370     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource);
372         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
373         bytes memory args = stra2cbor(argN);
374         return oraclize.queryN.value(price)(timestamp, datasource, args);
375     }
376     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource, gaslimit);
378         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
379         bytes memory args = stra2cbor(argN);
380         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
381     }
382     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
383         uint price = oraclize.getPrice(datasource, gaslimit);
384         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
385         bytes memory args = stra2cbor(argN);
386         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
387     }
388     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
389         string[] memory dynargs = new string[](1);
390         dynargs[0] = args[0];
391         return oraclize_query(datasource, dynargs);
392     }
393     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
394         string[] memory dynargs = new string[](1);
395         dynargs[0] = args[0];
396         return oraclize_query(timestamp, datasource, dynargs);
397     }
398     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         string[] memory dynargs = new string[](1);
400         dynargs[0] = args[0];
401         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
402     }
403     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
404         string[] memory dynargs = new string[](1);
405         dynargs[0] = args[0];       
406         return oraclize_query(datasource, dynargs, gaslimit);
407     }
408     
409     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
410         string[] memory dynargs = new string[](2);
411         dynargs[0] = args[0];
412         dynargs[1] = args[1];
413         return oraclize_query(datasource, dynargs);
414     }
415     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
416         string[] memory dynargs = new string[](2);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         return oraclize_query(timestamp, datasource, dynargs);
420     }
421     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
422         string[] memory dynargs = new string[](2);
423         dynargs[0] = args[0];
424         dynargs[1] = args[1];
425         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
426     }
427     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
428         string[] memory dynargs = new string[](2);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         return oraclize_query(datasource, dynargs, gaslimit);
432     }
433     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
434         string[] memory dynargs = new string[](3);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         dynargs[2] = args[2];
438         return oraclize_query(datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](3);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         dynargs[2] = args[2];
445         return oraclize_query(timestamp, datasource, dynargs);
446     }
447     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](3);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
453     }
454     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
455         string[] memory dynargs = new string[](3);
456         dynargs[0] = args[0];
457         dynargs[1] = args[1];
458         dynargs[2] = args[2];
459         return oraclize_query(datasource, dynargs, gaslimit);
460     }
461     
462     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
463         string[] memory dynargs = new string[](4);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         dynargs[2] = args[2];
467         dynargs[3] = args[3];
468         return oraclize_query(datasource, dynargs);
469     }
470     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
471         string[] memory dynargs = new string[](4);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         dynargs[3] = args[3];
476         return oraclize_query(timestamp, datasource, dynargs);
477     }
478     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
479         string[] memory dynargs = new string[](4);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         dynargs[2] = args[2];
483         dynargs[3] = args[3];
484         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
485     }
486     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
487         string[] memory dynargs = new string[](4);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         dynargs[2] = args[2];
491         dynargs[3] = args[3];
492         return oraclize_query(datasource, dynargs, gaslimit);
493     }
494     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](5);
496         dynargs[0] = args[0];
497         dynargs[1] = args[1];
498         dynargs[2] = args[2];
499         dynargs[3] = args[3];
500         dynargs[4] = args[4];
501         return oraclize_query(datasource, dynargs);
502     }
503     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](5);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         dynargs[3] = args[3];
509         dynargs[4] = args[4];
510         return oraclize_query(timestamp, datasource, dynargs);
511     }
512     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513         string[] memory dynargs = new string[](5);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         dynargs[3] = args[3];
518         dynargs[4] = args[4];
519         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
520     }
521     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](5);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         dynargs[4] = args[4];
528         return oraclize_query(datasource, dynargs, gaslimit);
529     }
530     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
531         uint price = oraclize.getPrice(datasource);
532         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
533         bytes memory args = ba2cbor(argN);
534         return oraclize.queryN.value(price)(0, datasource, args);
535     }
536     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
537         uint price = oraclize.getPrice(datasource);
538         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
539         bytes memory args = ba2cbor(argN);
540         return oraclize.queryN.value(price)(timestamp, datasource, args);
541     }
542     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
543         uint price = oraclize.getPrice(datasource, gaslimit);
544         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
545         bytes memory args = ba2cbor(argN);
546         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
547     }
548     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
549         uint price = oraclize.getPrice(datasource, gaslimit);
550         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
551         bytes memory args = ba2cbor(argN);
552         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
553     }
554     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
555         bytes[] memory dynargs = new bytes[](1);
556         dynargs[0] = args[0];
557         return oraclize_query(datasource, dynargs);
558     }
559     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
560         bytes[] memory dynargs = new bytes[](1);
561         dynargs[0] = args[0];
562         return oraclize_query(timestamp, datasource, dynargs);
563     }
564     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         bytes[] memory dynargs = new bytes[](1);
566         dynargs[0] = args[0];
567         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
568     }
569     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
570         bytes[] memory dynargs = new bytes[](1);
571         dynargs[0] = args[0];       
572         return oraclize_query(datasource, dynargs, gaslimit);
573     }
574     
575     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
576         bytes[] memory dynargs = new bytes[](2);
577         dynargs[0] = args[0];
578         dynargs[1] = args[1];
579         return oraclize_query(datasource, dynargs);
580     }
581     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
582         bytes[] memory dynargs = new bytes[](2);
583         dynargs[0] = args[0];
584         dynargs[1] = args[1];
585         return oraclize_query(timestamp, datasource, dynargs);
586     }
587     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
588         bytes[] memory dynargs = new bytes[](2);
589         dynargs[0] = args[0];
590         dynargs[1] = args[1];
591         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
592     }
593     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
594         bytes[] memory dynargs = new bytes[](2);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         return oraclize_query(datasource, dynargs, gaslimit);
598     }
599     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
600         bytes[] memory dynargs = new bytes[](3);
601         dynargs[0] = args[0];
602         dynargs[1] = args[1];
603         dynargs[2] = args[2];
604         return oraclize_query(datasource, dynargs);
605     }
606     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](3);
608         dynargs[0] = args[0];
609         dynargs[1] = args[1];
610         dynargs[2] = args[2];
611         return oraclize_query(timestamp, datasource, dynargs);
612     }
613     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](3);
615         dynargs[0] = args[0];
616         dynargs[1] = args[1];
617         dynargs[2] = args[2];
618         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
619     }
620     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
621         bytes[] memory dynargs = new bytes[](3);
622         dynargs[0] = args[0];
623         dynargs[1] = args[1];
624         dynargs[2] = args[2];
625         return oraclize_query(datasource, dynargs, gaslimit);
626     }
627     
628     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
629         bytes[] memory dynargs = new bytes[](4);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         dynargs[2] = args[2];
633         dynargs[3] = args[3];
634         return oraclize_query(datasource, dynargs);
635     }
636     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
637         bytes[] memory dynargs = new bytes[](4);
638         dynargs[0] = args[0];
639         dynargs[1] = args[1];
640         dynargs[2] = args[2];
641         dynargs[3] = args[3];
642         return oraclize_query(timestamp, datasource, dynargs);
643     }
644     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
645         bytes[] memory dynargs = new bytes[](4);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         dynargs[2] = args[2];
649         dynargs[3] = args[3];
650         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
651     }
652     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
653         bytes[] memory dynargs = new bytes[](4);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         dynargs[2] = args[2];
657         dynargs[3] = args[3];
658         return oraclize_query(datasource, dynargs, gaslimit);
659     }
660     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](5);
662         dynargs[0] = args[0];
663         dynargs[1] = args[1];
664         dynargs[2] = args[2];
665         dynargs[3] = args[3];
666         dynargs[4] = args[4];
667         return oraclize_query(datasource, dynargs);
668     }
669     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](5);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         dynargs[3] = args[3];
675         dynargs[4] = args[4];
676         return oraclize_query(timestamp, datasource, dynargs);
677     }
678     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
679         bytes[] memory dynargs = new bytes[](5);
680         dynargs[0] = args[0];
681         dynargs[1] = args[1];
682         dynargs[2] = args[2];
683         dynargs[3] = args[3];
684         dynargs[4] = args[4];
685         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
686     }
687     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](5);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         dynargs[2] = args[2];
692         dynargs[3] = args[3];
693         dynargs[4] = args[4];
694         return oraclize_query(datasource, dynargs, gaslimit);
695     }
696 
697     function oraclize_cbAddress() oraclizeAPI internal returns (address){
698         return oraclize.cbAddress();
699     }
700     function oraclize_setProof(byte proofP) oraclizeAPI internal {
701         return oraclize.setProofType(proofP);
702     }
703     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
704         return oraclize.setCustomGasPrice(gasPrice);
705     }
706     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
707         return oraclize.setConfig(config);
708     }
709     
710     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
711         return oraclize.randomDS_getSessionPubKeyHash();
712     }
713 
714     function getCodeSize(address _addr) constant internal returns(uint _size) {
715         assembly {
716             _size := extcodesize(_addr)
717         }
718     }
719 
720     function parseAddr(string _a) internal returns (address){
721         bytes memory tmp = bytes(_a);
722         uint160 iaddr = 0;
723         uint160 b1;
724         uint160 b2;
725         for (uint i=2; i<2+2*20; i+=2){
726             iaddr *= 256;
727             b1 = uint160(tmp[i]);
728             b2 = uint160(tmp[i+1]);
729             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
730             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
731             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
732             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
733             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
734             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
735             iaddr += (b1*16+b2);
736         }
737         return address(iaddr);
738     }
739 
740     function strCompare(string _a, string _b) internal returns (int) {
741         bytes memory a = bytes(_a);
742         bytes memory b = bytes(_b);
743         uint minLength = a.length;
744         if (b.length < minLength) minLength = b.length;
745         for (uint i = 0; i < minLength; i ++)
746             if (a[i] < b[i])
747                 return -1;
748             else if (a[i] > b[i])
749                 return 1;
750         if (a.length < b.length)
751             return -1;
752         else if (a.length > b.length)
753             return 1;
754         else
755             return 0;
756     }
757 
758     function indexOf(string _haystack, string _needle) internal returns (int) {
759         bytes memory h = bytes(_haystack);
760         bytes memory n = bytes(_needle);
761         if(h.length < 1 || n.length < 1 || (n.length > h.length))
762             return -1;
763         else if(h.length > (2**128 -1))
764             return -1;
765         else
766         {
767             uint subindex = 0;
768             for (uint i = 0; i < h.length; i ++)
769             {
770                 if (h[i] == n[0])
771                 {
772                     subindex = 1;
773                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
774                     {
775                         subindex++;
776                     }
777                     if(subindex == n.length)
778                         return int(i);
779                 }
780             }
781             return -1;
782         }
783     }
784 
785     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
786         bytes memory _ba = bytes(_a);
787         bytes memory _bb = bytes(_b);
788         bytes memory _bc = bytes(_c);
789         bytes memory _bd = bytes(_d);
790         bytes memory _be = bytes(_e);
791         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
792         bytes memory babcde = bytes(abcde);
793         uint k = 0;
794         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
795         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
796         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
797         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
798         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
799         return string(babcde);
800     }
801 
802     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
803         return strConcat(_a, _b, _c, _d, "");
804     }
805 
806     function strConcat(string _a, string _b, string _c) internal returns (string) {
807         return strConcat(_a, _b, _c, "", "");
808     }
809 
810     function strConcat(string _a, string _b) internal returns (string) {
811         return strConcat(_a, _b, "", "", "");
812     }
813 
814     // parseInt
815     function parseInt(string _a) internal returns (uint) {
816         return parseInt(_a, 0);
817     }
818 
819     // parseInt(parseFloat*10^_b)
820     function parseInt(string _a, uint _b) internal returns (uint) {
821         bytes memory bresult = bytes(_a);
822         uint mint = 0;
823         bool decimals = false;
824         for (uint i=0; i<bresult.length; i++){
825             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
826                 if (decimals){
827                    if (_b == 0) break;
828                     else _b--;
829                 }
830                 mint *= 10;
831                 mint += uint(bresult[i]) - 48;
832             } else if (bresult[i] == 46) decimals = true;
833         }
834         if (_b > 0) mint *= 10**_b;
835         return mint;
836     }
837 
838     function uint2str(uint i) internal returns (string){
839         if (i == 0) return "0";
840         uint j = i;
841         uint len;
842         while (j != 0){
843             len++;
844             j /= 10;
845         }
846         bytes memory bstr = new bytes(len);
847         uint k = len - 1;
848         while (i != 0){
849             bstr[k--] = byte(48 + i % 10);
850             i /= 10;
851         }
852         return string(bstr);
853     }
854     
855     function stra2cbor(string[] arr) internal returns (bytes) {
856             uint arrlen = arr.length;
857 
858             // get correct cbor output length
859             uint outputlen = 0;
860             bytes[] memory elemArray = new bytes[](arrlen);
861             for (uint i = 0; i < arrlen; i++) {
862                 elemArray[i] = (bytes(arr[i]));
863                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
864             }
865             uint ctr = 0;
866             uint cborlen = arrlen + 0x80;
867             outputlen += byte(cborlen).length;
868             bytes memory res = new bytes(outputlen);
869 
870             while (byte(cborlen).length > ctr) {
871                 res[ctr] = byte(cborlen)[ctr];
872                 ctr++;
873             }
874             for (i = 0; i < arrlen; i++) {
875                 res[ctr] = 0x5F;
876                 ctr++;
877                 for (uint x = 0; x < elemArray[i].length; x++) {
878                     // if there's a bug with larger strings, this may be the culprit
879                     if (x % 23 == 0) {
880                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
881                         elemcborlen += 0x40;
882                         uint lctr = ctr;
883                         while (byte(elemcborlen).length > ctr - lctr) {
884                             res[ctr] = byte(elemcborlen)[ctr - lctr];
885                             ctr++;
886                         }
887                     }
888                     res[ctr] = elemArray[i][x];
889                     ctr++;
890                 }
891                 res[ctr] = 0xFF;
892                 ctr++;
893             }
894             return res;
895         }
896 
897     function ba2cbor(bytes[] arr) internal returns (bytes) {
898             uint arrlen = arr.length;
899 
900             // get correct cbor output length
901             uint outputlen = 0;
902             bytes[] memory elemArray = new bytes[](arrlen);
903             for (uint i = 0; i < arrlen; i++) {
904                 elemArray[i] = (bytes(arr[i]));
905                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
906             }
907             uint ctr = 0;
908             uint cborlen = arrlen + 0x80;
909             outputlen += byte(cborlen).length;
910             bytes memory res = new bytes(outputlen);
911 
912             while (byte(cborlen).length > ctr) {
913                 res[ctr] = byte(cborlen)[ctr];
914                 ctr++;
915             }
916             for (i = 0; i < arrlen; i++) {
917                 res[ctr] = 0x5F;
918                 ctr++;
919                 for (uint x = 0; x < elemArray[i].length; x++) {
920                     // if there's a bug with larger strings, this may be the culprit
921                     if (x % 23 == 0) {
922                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
923                         elemcborlen += 0x40;
924                         uint lctr = ctr;
925                         while (byte(elemcborlen).length > ctr - lctr) {
926                             res[ctr] = byte(elemcborlen)[ctr - lctr];
927                             ctr++;
928                         }
929                     }
930                     res[ctr] = elemArray[i][x];
931                     ctr++;
932                 }
933                 res[ctr] = 0xFF;
934                 ctr++;
935             }
936             return res;
937         }
938         
939         
940     string oraclize_network_name;
941     function oraclize_setNetworkName(string _network_name) internal {
942         oraclize_network_name = _network_name;
943     }
944     
945     function oraclize_getNetworkName() internal returns (string) {
946         return oraclize_network_name;
947     }
948     
949     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
950         if ((_nbytes == 0)||(_nbytes > 32)) throw;
951         bytes memory nbytes = new bytes(1);
952         nbytes[0] = byte(_nbytes);
953         bytes memory unonce = new bytes(32);
954         bytes memory sessionKeyHash = new bytes(32);
955         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
956         assembly {
957             mstore(unonce, 0x20)
958             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
959             mstore(sessionKeyHash, 0x20)
960             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
961         }
962         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
963         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
964         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
965         return queryId;
966     }
967     
968     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
969         oraclize_randomDS_args[queryId] = commitment;
970     }
971     
972     mapping(bytes32=>bytes32) oraclize_randomDS_args;
973     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
974 
975     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
976         bool sigok;
977         address signer;
978         
979         bytes32 sigr;
980         bytes32 sigs;
981         
982         bytes memory sigr_ = new bytes(32);
983         uint offset = 4+(uint(dersig[3]) - 0x20);
984         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
985         bytes memory sigs_ = new bytes(32);
986         offset += 32 + 2;
987         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
988 
989         assembly {
990             sigr := mload(add(sigr_, 32))
991             sigs := mload(add(sigs_, 32))
992         }
993         
994         
995         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
996         if (address(sha3(pubkey)) == signer) return true;
997         else {
998             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
999             return (address(sha3(pubkey)) == signer);
1000         }
1001     }
1002 
1003     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1004         bool sigok;
1005         
1006         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1007         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1008         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1009         
1010         bytes memory appkey1_pubkey = new bytes(64);
1011         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1012         
1013         bytes memory tosign2 = new bytes(1+65+32);
1014         tosign2[0] = 1; //role
1015         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1016         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1017         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1018         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1019         
1020         if (sigok == false) return false;
1021         
1022         
1023         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1024         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1025         
1026         bytes memory tosign3 = new bytes(1+65);
1027         tosign3[0] = 0xFE;
1028         copyBytes(proof, 3, 65, tosign3, 1);
1029         
1030         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1031         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1032         
1033         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1034         
1035         return sigok;
1036     }
1037     
1038     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1039         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1040         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1041         
1042         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1043         if (proofVerified == false) throw;
1044         
1045         _;
1046     }
1047     
1048     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1049         bool match_ = true;
1050         
1051         for (var i=0; i<prefix.length; i++){
1052             if (content[i] != prefix[i]) match_ = false;
1053         }
1054         
1055         return match_;
1056     }
1057 
1058     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1059         bool checkok;
1060         
1061         
1062         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1063         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1064         bytes memory keyhash = new bytes(32);
1065         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1066         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1067         if (checkok == false) return false;
1068         
1069         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1070         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1071         
1072         
1073         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1074         checkok = matchBytes32Prefix(sha256(sig1), result);
1075         if (checkok == false) return false;
1076         
1077         
1078         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1079         // This is to verify that the computed args match with the ones specified in the query.
1080         bytes memory commitmentSlice1 = new bytes(8+1+32);
1081         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1082         
1083         bytes memory sessionPubkey = new bytes(64);
1084         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1085         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1086         
1087         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1088         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1089             delete oraclize_randomDS_args[queryId];
1090         } else return false;
1091         
1092         
1093         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1094         bytes memory tosign1 = new bytes(32+8+1+32);
1095         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1096         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1097         if (checkok == false) return false;
1098         
1099         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1100         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1101             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1102         }
1103         
1104         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1105     }
1106 
1107     
1108     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1109     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1110         uint minLength = length + toOffset;
1111 
1112         if (to.length < minLength) {
1113             // Buffer too small
1114             throw; // Should be a better way?
1115         }
1116 
1117         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1118         uint i = 32 + fromOffset;
1119         uint j = 32 + toOffset;
1120 
1121         while (i < (32 + fromOffset + length)) {
1122             assembly {
1123                 let tmp := mload(add(from, i))
1124                 mstore(add(to, j), tmp)
1125             }
1126             i += 32;
1127             j += 32;
1128         }
1129 
1130         return to;
1131     }
1132     
1133     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1134     // Duplicate Solidity's ecrecover, but catching the CALL return value
1135     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1136         // We do our own memory management here. Solidity uses memory offset
1137         // 0x40 to store the current end of memory. We write past it (as
1138         // writes are memory extensions), but don't update the offset so
1139         // Solidity will reuse it. The memory used here is only needed for
1140         // this context.
1141 
1142         // FIXME: inline assembly can't access return values
1143         bool ret;
1144         address addr;
1145 
1146         assembly {
1147             let size := mload(0x40)
1148             mstore(size, hash)
1149             mstore(add(size, 32), v)
1150             mstore(add(size, 64), r)
1151             mstore(add(size, 96), s)
1152 
1153             // NOTE: we can reuse the request memory because we deal with
1154             //       the return code
1155             ret := call(3000, 1, 0, size, 128, size, 32)
1156             addr := mload(size)
1157         }
1158   
1159         return (ret, addr);
1160     }
1161 
1162     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1163     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1164         bytes32 r;
1165         bytes32 s;
1166         uint8 v;
1167 
1168         if (sig.length != 65)
1169           return (false, 0);
1170 
1171         // The signature format is a compact form of:
1172         //   {bytes32 r}{bytes32 s}{uint8 v}
1173         // Compact means, uint8 is not padded to 32 bytes.
1174         assembly {
1175             r := mload(add(sig, 32))
1176             s := mload(add(sig, 64))
1177 
1178             // Here we are loading the last 32 bytes. We exploit the fact that
1179             // 'mload' will pad with zeroes if we overread.
1180             // There is no 'mload8' to do this, but that would be nicer.
1181             v := byte(0, mload(add(sig, 96)))
1182 
1183             // Alternative solution:
1184             // 'byte' is not working due to the Solidity parser, so lets
1185             // use the second best option, 'and'
1186             // v := and(mload(add(sig, 65)), 255)
1187         }
1188 
1189         // albeit non-transactional signatures are not specified by the YP, one would expect it
1190         // to match the YP range of [27, 28]
1191         //
1192         // geth uses [0, 1] and some clients have followed. This might change, see:
1193         //  https://github.com/ethereum/go-ethereum/issues/2053
1194         if (v < 27)
1195           v += 27;
1196 
1197         if (v != 27 && v != 28)
1198             return (false, 0);
1199 
1200         return safer_ecrecover(hash, v, r, s);
1201     }
1202         
1203 }
1204 // </ORACLIZE_API>
1205 
1206 pragma solidity ^0.4.17;
1207 
1208 contract Extend is usingOraclize {
1209 
1210     modifier  onlyVerified() { 
1211         require(data.getUserVerified(msg.sender)); 
1212         _; 
1213     }
1214     
1215     ExtendData data;
1216     ExtendEvents events;
1217     address owner;
1218 
1219     function Extend(ExtendData _data, ExtendEvents _events) public {
1220         data = ExtendData(_data);
1221         events = ExtendEvents(_events);
1222         owner = msg.sender;
1223     }
1224 
1225     function getDataAddress() public constant returns (address) {
1226         return address(data);
1227     }
1228 
1229     function getEventAddress() public constant returns (address) {
1230         return address(events);
1231     }
1232 
1233     function getOraclizePrice() public constant returns (uint) {
1234         return oraclize_getPrice("computation");
1235     }
1236 
1237     function getAddressFromUsername(bytes32 _username) public constant returns (address userAddress) {
1238         return data.getAddressForUsername(_username);
1239     }
1240 
1241     function getUsernameForAddress(address _address) public constant returns (bytes32) {
1242         if (data.getUserVerified(_address)) {
1243             return data.getUserUsername(_address);
1244         }
1245         
1246         return 0x0;
1247     }
1248 
1249     function checkAddressVerified() public constant returns (bool) {
1250         return data.getUserVerified(msg.sender);
1251     }
1252 
1253     function checkUsernameVerified(bytes32 _username) public constant returns (bool) {
1254         return data.getUserVerified(data.getAddressForUsername(_username));
1255     }
1256 
1257     function checkBalance() public onlyVerified constant returns (uint) {
1258         return data.getBalanceForUser(data.getUserUsername(msg.sender));
1259     }
1260 
1261     function checkIfRefundAvailable(bytes32 _username) public constant returns (bool) {
1262         return (data.getLastTipTime(msg.sender, _username) < (now - 2 weeks)) && (data.getTip(msg.sender, _username) > 0);
1263     }
1264 
1265     /**
1266      * Creates user with username and address
1267      * @param _username reddit username from user
1268      * @param _token reddit oauth access token encrypted with oraclize public key
1269      */
1270     function createUser(bytes32 _username, string _token) public payable {
1271 
1272         data.addUser(msg.sender, _username);
1273 
1274         if (oraclize_getPrice("computation") > msg.value) {
1275             events.logBalance(msg.value);
1276             events.logNeededBalance(oraclize_getPrice("computation"));
1277             return;
1278         } 
1279         
1280         string memory queryString = strConcat("[computation] ['QmaCikXkkUHD7cQMK3AJhTjpPmNj4hLwf3DXBzcEpM9vnL', '${[decrypt] ", _token, "}']");
1281         bytes32 queryId = oraclize_query("nested", queryString);
1282         data.setQueryIdForAddress(queryId, msg.sender);
1283 
1284         events.logQuery(queryId, msg.sender);
1285         events.createdUser(_username);
1286     }
1287 
1288     /**
1289      * Tip user for his post/comment 
1290      * @param _username reddit username for user
1291      */
1292     function tipUser(bytes32 _username) public payable {
1293         data.addTip(msg.sender, _username, msg.value);
1294         
1295         events.userTipped(msg.sender, _username, msg.value);
1296         sendTip(_username, msg.value);
1297     }
1298 
1299     /**
1300      * Refund your money for tipping user
1301      * @param _username reddit username for user
1302      */
1303     function refundMoneyForUser(bytes32 _username) public {
1304         require(data.getLastTipTime(msg.sender, _username) < (now - 2 weeks));
1305         require(!checkUsernameVerified(_username));
1306 
1307         uint toSend = data.getTip(msg.sender, _username);
1308         data.removeTip(msg.sender, _username);
1309         msg.sender.transfer(toSend);
1310 
1311         events.refundSuccessful(msg.sender, _username);
1312     }
1313 
1314     /**
1315      * Buy gold for user
1316      * @param _to reddit username for user
1317      * @param _months for using gold
1318      * @param _priceUsd price returned from server
1319      * @param _commentId comment on reddit
1320      * @param _nonce server sent
1321      * @param _signature server sent
1322      */
1323     function buyGold(bytes32 _to,  
1324                      string _months, 
1325                      string _priceUsd,
1326                      string _commentId, 
1327                      string _nonce, 
1328                      string _signature) public payable {
1329 
1330         owner.transfer(msg.value);
1331         events.goldBought(msg.value, msg.sender, _to, _months, _priceUsd, _commentId, _nonce,  _signature);  
1332     }
1333 
1334     /**
1335      * Function called when API gets results
1336      * @param _myid query id.
1337      * @param _result string returned from api, should be reddit username
1338      */
1339     function __callback(bytes32 _myid, string _result) {
1340         require(msg.sender == oraclize_cbAddress());
1341 
1342         address queryAddress = data.getAddressForQuery(_myid);
1343         bytes32 usernameAddress = data.getUserUsername(queryAddress);
1344         bytes32 resultBytes = stringToBytes32(_result);
1345 
1346         if (usernameAddress != resultBytes) {
1347             events.usernameDoesNotMatch(resultBytes, usernameAddress);
1348             return;
1349         }
1350 
1351         data.setVerified(queryAddress);
1352         data.setUsernameForAddress(usernameAddress, queryAddress);
1353         events.verifiedUser(usernameAddress);
1354 
1355         sendTip(usernameAddress, data.getBalanceForUser(usernameAddress));
1356     }
1357 
1358     /**
1359      * Convert string to bytes32
1360      * @param _source string to convert
1361      */
1362     function stringToBytes32(string memory _source) internal returns (bytes32 result) {
1363         bytes memory tempEmptyStringTest = bytes(_source);
1364         if (tempEmptyStringTest.length == 0) {
1365             return 0x0;
1366         }
1367         
1368         assembly {
1369             result := mload(add(_source, 32))
1370         }
1371     }
1372 
1373     /**
1374      * Send tip for user
1375      * @param _username reddit username for user
1376      * @param _value to send
1377      */ 
1378     function sendTip(bytes32 _username, uint _value) private {
1379         address userAddress = getAddressFromUsername(_username);
1380         if (userAddress != 0x0 && _value > 0) {
1381             data.setBalanceForUser(_username, 0);
1382             userAddress.transfer(_value);
1383         }
1384     }
1385 
1386     function () payable {
1387         revert();
1388     }
1389 }