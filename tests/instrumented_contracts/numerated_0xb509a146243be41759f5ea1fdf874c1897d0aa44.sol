1 /*
2 
3    _____                  _         _____                                    
4   / ____|                | |       / ____|                                   
5  | |     _ __ _   _ _ __ | |_ ___ | |     ___  _ __   __ _ _ __ ___  ___ ___ 
6  | |    | '__| | | | '_ \| __/ _ \| |    / _ \| '_ \ / _` | '__/ _ \/ __/ __|
7  | |____| |  | |_| | |_) | || (_) | |___| (_) | | | | (_| | | |  __/\__ \__ \
8   \_____|_|   \__, | .__/ \__\___/ \_____\___/|_| |_|\__, |_|  \___||___/___/
9                __/ | |                                __/ |                  
10               |___/|_|                               |___/                   
11 
12 
13 CryptoCongress smart contract 
14 
15 The official address is "cryptocongress.eth"
16 
17 Token and voting code begins on line 1030
18 
19 */
20 
21 pragma solidity ^0.4.10;
22 
23 contract OraclizeI {
24     address public cbAddress;
25     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
26     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
27     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
28     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
29     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
30     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
31     function getPrice(string _datasource) public returns (uint _dsprice);
32     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
33     function setProofType(byte _proofType) external;
34     function setCustomGasPrice(uint _gasPrice) external;
35     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
36 }
37 contract OraclizeAddrResolverI {
38     function getAddress() public returns (address _addr);
39 }
40 contract usingOraclize {
41     uint constant day = 60*60*24;
42     uint constant week = 60*60*24*7;
43     uint constant month = 60*60*24*30;
44     byte constant proofType_NONE = 0x00;
45     byte constant proofType_TLSNotary = 0x10;
46     byte constant proofType_Android = 0x20;
47     byte constant proofType_Ledger = 0x30;
48     byte constant proofType_Native = 0xF0;
49     byte constant proofStorage_IPFS = 0x01;
50     uint8 constant networkID_auto = 0;
51     uint8 constant networkID_mainnet = 1;
52     uint8 constant networkID_testnet = 2;
53     uint8 constant networkID_morden = 2;
54     uint8 constant networkID_consensys = 161;
55 
56     OraclizeAddrResolverI OAR;
57 
58     OraclizeI oraclize;
59     modifier oraclizeAPI {
60         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
61             oraclize_setNetwork(networkID_auto);
62 
63         if(address(oraclize) != OAR.getAddress())
64             oraclize = OraclizeI(OAR.getAddress());
65 
66         _;
67     }
68     modifier coupon(string code){
69         oraclize = OraclizeI(OAR.getAddress());
70         _;
71     }
72 
73     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
74       return oraclize_setNetwork();
75       networkID; // silence the warning and remain backwards compatible
76     }
77     function oraclize_setNetwork() internal returns(bool){
78         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
79             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
80             oraclize_setNetworkName("eth_mainnet");
81             return true;
82         }
83         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
84             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
85             oraclize_setNetworkName("eth_ropsten3");
86             return true;
87         }
88         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
89             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
90             oraclize_setNetworkName("eth_kovan");
91             return true;
92         }
93         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
94             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
95             oraclize_setNetworkName("eth_rinkeby");
96             return true;
97         }
98         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
99             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
100             return true;
101         }
102         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
103             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
104             return true;
105         }
106         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
107             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
108             return true;
109         }
110         return false;
111     }
112 
113     function __callback(bytes32 myid, string result) public {
114         __callback(myid, result, new bytes(0));
115     }
116     function __callback(bytes32 myid, string result, bytes proof) public {
117       return;
118       myid; result; proof; // Silence compiler warnings
119     }
120 
121     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
122         return oraclize.getPrice(datasource);
123     }
124 
125     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
126         return oraclize.getPrice(datasource, gaslimit);
127     }
128 
129     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
130         uint price = oraclize.getPrice(datasource);
131         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
132         return oraclize.query.value(price)(0, datasource, arg);
133     }
134     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
135         uint price = oraclize.getPrice(datasource);
136         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
137         return oraclize.query.value(price)(timestamp, datasource, arg);
138     }
139     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
140         uint price = oraclize.getPrice(datasource, gaslimit);
141         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
142         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
143     }
144     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
145         uint price = oraclize.getPrice(datasource, gaslimit);
146         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
147         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
148     }
149     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
150         uint price = oraclize.getPrice(datasource);
151         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
152         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
153     }
154     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
155         uint price = oraclize.getPrice(datasource);
156         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
157         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
158     }
159     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource, gaslimit);
161         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
162         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
163     }
164     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
165         uint price = oraclize.getPrice(datasource, gaslimit);
166         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
167         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
168     }
169     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource);
171         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
172         bytes memory args = stra2cbor(argN);
173         return oraclize.queryN.value(price)(0, datasource, args);
174     }
175     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
176         uint price = oraclize.getPrice(datasource);
177         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
178         bytes memory args = stra2cbor(argN);
179         return oraclize.queryN.value(price)(timestamp, datasource, args);
180     }
181     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
182         uint price = oraclize.getPrice(datasource, gaslimit);
183         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
184         bytes memory args = stra2cbor(argN);
185         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
186     }
187     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
188         uint price = oraclize.getPrice(datasource, gaslimit);
189         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
190         bytes memory args = stra2cbor(argN);
191         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
192     }
193     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
194         string[] memory dynargs = new string[](1);
195         dynargs[0] = args[0];
196         return oraclize_query(datasource, dynargs);
197     }
198     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
199         string[] memory dynargs = new string[](1);
200         dynargs[0] = args[0];
201         return oraclize_query(timestamp, datasource, dynargs);
202     }
203     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
204         string[] memory dynargs = new string[](1);
205         dynargs[0] = args[0];
206         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
207     }
208     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
209         string[] memory dynargs = new string[](1);
210         dynargs[0] = args[0];
211         return oraclize_query(datasource, dynargs, gaslimit);
212     }
213 
214     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
215         string[] memory dynargs = new string[](2);
216         dynargs[0] = args[0];
217         dynargs[1] = args[1];
218         return oraclize_query(datasource, dynargs);
219     }
220     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](2);
222         dynargs[0] = args[0];
223         dynargs[1] = args[1];
224         return oraclize_query(timestamp, datasource, dynargs);
225     }
226     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
227         string[] memory dynargs = new string[](2);
228         dynargs[0] = args[0];
229         dynargs[1] = args[1];
230         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
231     }
232     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
233         string[] memory dynargs = new string[](2);
234         dynargs[0] = args[0];
235         dynargs[1] = args[1];
236         return oraclize_query(datasource, dynargs, gaslimit);
237     }
238     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](3);
240         dynargs[0] = args[0];
241         dynargs[1] = args[1];
242         dynargs[2] = args[2];
243         return oraclize_query(datasource, dynargs);
244     }
245     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](3);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         dynargs[2] = args[2];
250         return oraclize_query(timestamp, datasource, dynargs);
251     }
252     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
253         string[] memory dynargs = new string[](3);
254         dynargs[0] = args[0];
255         dynargs[1] = args[1];
256         dynargs[2] = args[2];
257         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
258     }
259     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
260         string[] memory dynargs = new string[](3);
261         dynargs[0] = args[0];
262         dynargs[1] = args[1];
263         dynargs[2] = args[2];
264         return oraclize_query(datasource, dynargs, gaslimit);
265     }
266 
267     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
268         string[] memory dynargs = new string[](4);
269         dynargs[0] = args[0];
270         dynargs[1] = args[1];
271         dynargs[2] = args[2];
272         dynargs[3] = args[3];
273         return oraclize_query(datasource, dynargs);
274     }
275     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
276         string[] memory dynargs = new string[](4);
277         dynargs[0] = args[0];
278         dynargs[1] = args[1];
279         dynargs[2] = args[2];
280         dynargs[3] = args[3];
281         return oraclize_query(timestamp, datasource, dynargs);
282     }
283     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
284         string[] memory dynargs = new string[](4);
285         dynargs[0] = args[0];
286         dynargs[1] = args[1];
287         dynargs[2] = args[2];
288         dynargs[3] = args[3];
289         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
290     }
291     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
292         string[] memory dynargs = new string[](4);
293         dynargs[0] = args[0];
294         dynargs[1] = args[1];
295         dynargs[2] = args[2];
296         dynargs[3] = args[3];
297         return oraclize_query(datasource, dynargs, gaslimit);
298     }
299     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](5);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         dynargs[2] = args[2];
304         dynargs[3] = args[3];
305         dynargs[4] = args[4];
306         return oraclize_query(datasource, dynargs);
307     }
308     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](5);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         dynargs[4] = args[4];
315         return oraclize_query(timestamp, datasource, dynargs);
316     }
317     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
318         string[] memory dynargs = new string[](5);
319         dynargs[0] = args[0];
320         dynargs[1] = args[1];
321         dynargs[2] = args[2];
322         dynargs[3] = args[3];
323         dynargs[4] = args[4];
324         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
325     }
326     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
327         string[] memory dynargs = new string[](5);
328         dynargs[0] = args[0];
329         dynargs[1] = args[1];
330         dynargs[2] = args[2];
331         dynargs[3] = args[3];
332         dynargs[4] = args[4];
333         return oraclize_query(datasource, dynargs, gaslimit);
334     }
335     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
336         uint price = oraclize.getPrice(datasource);
337         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
338         bytes memory args = ba2cbor(argN);
339         return oraclize.queryN.value(price)(0, datasource, args);
340     }
341     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
342         uint price = oraclize.getPrice(datasource);
343         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
344         bytes memory args = ba2cbor(argN);
345         return oraclize.queryN.value(price)(timestamp, datasource, args);
346     }
347     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
348         uint price = oraclize.getPrice(datasource, gaslimit);
349         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
350         bytes memory args = ba2cbor(argN);
351         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
352     }
353     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
354         uint price = oraclize.getPrice(datasource, gaslimit);
355         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
356         bytes memory args = ba2cbor(argN);
357         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
358     }
359     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
360         bytes[] memory dynargs = new bytes[](1);
361         dynargs[0] = args[0];
362         return oraclize_query(datasource, dynargs);
363     }
364     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
365         bytes[] memory dynargs = new bytes[](1);
366         dynargs[0] = args[0];
367         return oraclize_query(timestamp, datasource, dynargs);
368     }
369     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
370         bytes[] memory dynargs = new bytes[](1);
371         dynargs[0] = args[0];
372         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
373     }
374     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
375         bytes[] memory dynargs = new bytes[](1);
376         dynargs[0] = args[0];
377         return oraclize_query(datasource, dynargs, gaslimit);
378     }
379 
380     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
381         bytes[] memory dynargs = new bytes[](2);
382         dynargs[0] = args[0];
383         dynargs[1] = args[1];
384         return oraclize_query(datasource, dynargs);
385     }
386     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
387         bytes[] memory dynargs = new bytes[](2);
388         dynargs[0] = args[0];
389         dynargs[1] = args[1];
390         return oraclize_query(timestamp, datasource, dynargs);
391     }
392     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
393         bytes[] memory dynargs = new bytes[](2);
394         dynargs[0] = args[0];
395         dynargs[1] = args[1];
396         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
397     }
398     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
399         bytes[] memory dynargs = new bytes[](2);
400         dynargs[0] = args[0];
401         dynargs[1] = args[1];
402         return oraclize_query(datasource, dynargs, gaslimit);
403     }
404     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](3);
406         dynargs[0] = args[0];
407         dynargs[1] = args[1];
408         dynargs[2] = args[2];
409         return oraclize_query(datasource, dynargs);
410     }
411     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](3);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         dynargs[2] = args[2];
416         return oraclize_query(timestamp, datasource, dynargs);
417     }
418     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
419         bytes[] memory dynargs = new bytes[](3);
420         dynargs[0] = args[0];
421         dynargs[1] = args[1];
422         dynargs[2] = args[2];
423         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
424     }
425     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
426         bytes[] memory dynargs = new bytes[](3);
427         dynargs[0] = args[0];
428         dynargs[1] = args[1];
429         dynargs[2] = args[2];
430         return oraclize_query(datasource, dynargs, gaslimit);
431     }
432 
433     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
434         bytes[] memory dynargs = new bytes[](4);
435         dynargs[0] = args[0];
436         dynargs[1] = args[1];
437         dynargs[2] = args[2];
438         dynargs[3] = args[3];
439         return oraclize_query(datasource, dynargs);
440     }
441     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
442         bytes[] memory dynargs = new bytes[](4);
443         dynargs[0] = args[0];
444         dynargs[1] = args[1];
445         dynargs[2] = args[2];
446         dynargs[3] = args[3];
447         return oraclize_query(timestamp, datasource, dynargs);
448     }
449     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
450         bytes[] memory dynargs = new bytes[](4);
451         dynargs[0] = args[0];
452         dynargs[1] = args[1];
453         dynargs[2] = args[2];
454         dynargs[3] = args[3];
455         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
456     }
457     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
458         bytes[] memory dynargs = new bytes[](4);
459         dynargs[0] = args[0];
460         dynargs[1] = args[1];
461         dynargs[2] = args[2];
462         dynargs[3] = args[3];
463         return oraclize_query(datasource, dynargs, gaslimit);
464     }
465     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](5);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         dynargs[2] = args[2];
470         dynargs[3] = args[3];
471         dynargs[4] = args[4];
472         return oraclize_query(datasource, dynargs);
473     }
474     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](5);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         dynargs[3] = args[3];
480         dynargs[4] = args[4];
481         return oraclize_query(timestamp, datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
484         bytes[] memory dynargs = new bytes[](5);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         dynargs[3] = args[3];
489         dynargs[4] = args[4];
490         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
491     }
492     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
493         bytes[] memory dynargs = new bytes[](5);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         dynargs[3] = args[3];
498         dynargs[4] = args[4];
499         return oraclize_query(datasource, dynargs, gaslimit);
500     }
501 
502     function oraclize_cbAddress() oraclizeAPI internal returns (address){
503         return oraclize.cbAddress();
504     }
505     function oraclize_setProof(byte proofP) oraclizeAPI internal {
506         return oraclize.setProofType(proofP);
507     }
508     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
509         return oraclize.setCustomGasPrice(gasPrice);
510     }
511 
512     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
513         return oraclize.randomDS_getSessionPubKeyHash();
514     }
515 
516     function getCodeSize(address _addr) constant internal returns(uint _size) {
517         assembly {
518             _size := extcodesize(_addr)
519         }
520     }
521 
522     function parseAddr(string _a) internal pure returns (address){
523         bytes memory tmp = bytes(_a);
524         uint160 iaddr = 0;
525         uint160 b1;
526         uint160 b2;
527         for (uint i=2; i<2+2*20; i+=2){
528             iaddr *= 256;
529             b1 = uint160(tmp[i]);
530             b2 = uint160(tmp[i+1]);
531             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
532             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
533             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
534             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
535             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
536             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
537             iaddr += (b1*16+b2);
538         }
539         return address(iaddr);
540     }
541 
542     function strCompare(string _a, string _b) internal pure returns (int) {
543         bytes memory a = bytes(_a);
544         bytes memory b = bytes(_b);
545         uint minLength = a.length;
546         if (b.length < minLength) minLength = b.length;
547         for (uint i = 0; i < minLength; i ++)
548             if (a[i] < b[i])
549                 return -1;
550             else if (a[i] > b[i])
551                 return 1;
552         if (a.length < b.length)
553             return -1;
554         else if (a.length > b.length)
555             return 1;
556         else
557             return 0;
558     }
559 
560     function indexOf(string _haystack, string _needle) internal pure returns (int) {
561         bytes memory h = bytes(_haystack);
562         bytes memory n = bytes(_needle);
563         if(h.length < 1 || n.length < 1 || (n.length > h.length))
564             return -1;
565         else if(h.length > (2**128 -1))
566             return -1;
567         else
568         {
569             uint subindex = 0;
570             for (uint i = 0; i < h.length; i ++)
571             {
572                 if (h[i] == n[0])
573                 {
574                     subindex = 1;
575                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
576                     {
577                         subindex++;
578                     }
579                     if(subindex == n.length)
580                         return int(i);
581                 }
582             }
583             return -1;
584         }
585     }
586 
587     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
588         bytes memory _ba = bytes(_a);
589         bytes memory _bb = bytes(_b);
590         bytes memory _bc = bytes(_c);
591         bytes memory _bd = bytes(_d);
592         bytes memory _be = bytes(_e);
593         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
594         bytes memory babcde = bytes(abcde);
595         uint k = 0;
596         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
597         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
598         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
599         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
600         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
601         return string(babcde);
602     }
603 
604     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
605         return strConcat(_a, _b, _c, _d, "");
606     }
607 
608     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
609         return strConcat(_a, _b, _c, "", "");
610     }
611 
612     function strConcat(string _a, string _b) internal pure returns (string) {
613         return strConcat(_a, _b, "", "", "");
614     }
615 
616     // parseInt
617     function parseInt(string _a) internal pure returns (uint) {
618         return parseInt(_a, 0);
619     }
620 
621     // parseInt(parseFloat*10^_b)
622     function parseInt(string _a, uint _b) internal pure returns (uint) {
623         bytes memory bresult = bytes(_a);
624         uint mint = 0;
625         bool decimals = false;
626         for (uint i=0; i<bresult.length; i++){
627             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
628                 if (decimals){
629                    if (_b == 0) break;
630                     else _b--;
631                 }
632                 mint *= 10;
633                 mint += uint(bresult[i]) - 48;
634             } else if (bresult[i] == 46) decimals = true;
635         }
636         if (_b > 0) mint *= 10**_b;
637         return mint;
638     }
639 
640     function uint2str(uint i) internal pure returns (string){
641         if (i == 0) return "0";
642         uint j = i;
643         uint len;
644         while (j != 0){
645             len++;
646             j /= 10;
647         }
648         bytes memory bstr = new bytes(len);
649         uint k = len - 1;
650         while (i != 0){
651             bstr[k--] = byte(48 + i % 10);
652             i /= 10;
653         }
654         return string(bstr);
655     }
656 
657     function stra2cbor(string[] arr) internal pure returns (bytes) {
658             uint arrlen = arr.length;
659 
660             // get correct cbor output length
661             uint outputlen = 0;
662             bytes[] memory elemArray = new bytes[](arrlen);
663             for (uint i = 0; i < arrlen; i++) {
664                 elemArray[i] = (bytes(arr[i]));
665                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
666             }
667             uint ctr = 0;
668             uint cborlen = arrlen + 0x80;
669             outputlen += byte(cborlen).length;
670             bytes memory res = new bytes(outputlen);
671 
672             while (byte(cborlen).length > ctr) {
673                 res[ctr] = byte(cborlen)[ctr];
674                 ctr++;
675             }
676             for (i = 0; i < arrlen; i++) {
677                 res[ctr] = 0x5F;
678                 ctr++;
679                 for (uint x = 0; x < elemArray[i].length; x++) {
680                     // if there's a bug with larger strings, this may be the culprit
681                     if (x % 23 == 0) {
682                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
683                         elemcborlen += 0x40;
684                         uint lctr = ctr;
685                         while (byte(elemcborlen).length > ctr - lctr) {
686                             res[ctr] = byte(elemcborlen)[ctr - lctr];
687                             ctr++;
688                         }
689                     }
690                     res[ctr] = elemArray[i][x];
691                     ctr++;
692                 }
693                 res[ctr] = 0xFF;
694                 ctr++;
695             }
696             return res;
697         }
698 
699     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
700             uint arrlen = arr.length;
701 
702             // get correct cbor output length
703             uint outputlen = 0;
704             bytes[] memory elemArray = new bytes[](arrlen);
705             for (uint i = 0; i < arrlen; i++) {
706                 elemArray[i] = (bytes(arr[i]));
707                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
708             }
709             uint ctr = 0;
710             uint cborlen = arrlen + 0x80;
711             outputlen += byte(cborlen).length;
712             bytes memory res = new bytes(outputlen);
713 
714             while (byte(cborlen).length > ctr) {
715                 res[ctr] = byte(cborlen)[ctr];
716                 ctr++;
717             }
718             for (i = 0; i < arrlen; i++) {
719                 res[ctr] = 0x5F;
720                 ctr++;
721                 for (uint x = 0; x < elemArray[i].length; x++) {
722                     // if there's a bug with larger strings, this may be the culprit
723                     if (x % 23 == 0) {
724                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
725                         elemcborlen += 0x40;
726                         uint lctr = ctr;
727                         while (byte(elemcborlen).length > ctr - lctr) {
728                             res[ctr] = byte(elemcborlen)[ctr - lctr];
729                             ctr++;
730                         }
731                     }
732                     res[ctr] = elemArray[i][x];
733                     ctr++;
734                 }
735                 res[ctr] = 0xFF;
736                 ctr++;
737             }
738             return res;
739         }
740 
741 
742     string oraclize_network_name;
743     function oraclize_setNetworkName(string _network_name) internal {
744         oraclize_network_name = _network_name;
745     }
746 
747     function oraclize_getNetworkName() internal view returns (string) {
748         return oraclize_network_name;
749     }
750 
751     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
752         require((_nbytes > 0) && (_nbytes <= 32));
753         bytes memory nbytes = new bytes(1);
754         nbytes[0] = byte(_nbytes);
755         bytes memory unonce = new bytes(32);
756         bytes memory sessionKeyHash = new bytes(32);
757         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
758         assembly {
759             mstore(unonce, 0x20)
760             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
761             mstore(sessionKeyHash, 0x20)
762             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
763         }
764         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
765         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
766         oraclize_randomDS_setCommitment(queryId, keccak256(bytes8(_delay), args[1], sha256(args[0]), args[2]));
767         return queryId;
768     }
769 
770     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
771         oraclize_randomDS_args[queryId] = commitment;
772     }
773 
774     mapping(bytes32=>bytes32) oraclize_randomDS_args;
775     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
776 
777     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
778         bool sigok;
779         address signer;
780 
781         bytes32 sigr;
782         bytes32 sigs;
783 
784         bytes memory sigr_ = new bytes(32);
785         uint offset = 4+(uint(dersig[3]) - 0x20);
786         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
787         bytes memory sigs_ = new bytes(32);
788         offset += 32 + 2;
789         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
790 
791         assembly {
792             sigr := mload(add(sigr_, 32))
793             sigs := mload(add(sigs_, 32))
794         }
795 
796 
797         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
798         if (address(keccak256(pubkey)) == signer) return true;
799         else {
800             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
801             return (address(keccak256(pubkey)) == signer);
802         }
803     }
804 
805     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
806         bool sigok;
807 
808         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
809         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
810         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
811 
812         bytes memory appkey1_pubkey = new bytes(64);
813         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
814 
815         bytes memory tosign2 = new bytes(1+65+32);
816         tosign2[0] = byte(1); //role
817         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
818         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
819         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
820         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
821 
822         if (sigok == false) return false;
823 
824 
825         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
826         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
827 
828         bytes memory tosign3 = new bytes(1+65);
829         tosign3[0] = 0xFE;
830         copyBytes(proof, 3, 65, tosign3, 1);
831 
832         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
833         copyBytes(proof, 3+65, sig3.length, sig3, 0);
834 
835         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
836 
837         return sigok;
838     }
839 
840     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
841         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
842         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
843 
844         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
845         require(proofVerified);
846 
847         _;
848     }
849 
850     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
851         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
852         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
853 
854         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
855         if (proofVerified == false) return 2;
856 
857         return 0;
858     }
859 
860     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
861         bool match_ = true;
862 
863 
864         for (uint256 i=0; i< n_random_bytes; i++) {
865             if (content[i] != prefix[i]) match_ = false;
866         }
867 
868         return match_;
869     }
870 
871     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
872 
873         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
874         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
875         bytes memory keyhash = new bytes(32);
876         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
877         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
878 
879         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
880         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
881 
882         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
883         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
884 
885         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
886         // This is to verify that the computed args match with the ones specified in the query.
887         bytes memory commitmentSlice1 = new bytes(8+1+32);
888         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
889 
890         bytes memory sessionPubkey = new bytes(64);
891         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
892         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
893 
894         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
895         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
896             delete oraclize_randomDS_args[queryId];
897         } else return false;
898 
899 
900         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
901         bytes memory tosign1 = new bytes(32+8+1+32);
902         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
903         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
904 
905         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
906         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
907             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
908         }
909 
910         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
911     }
912 
913     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
914     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
915         uint minLength = length + toOffset;
916 
917         // Buffer too small
918         require(to.length >= minLength); // Should be a better way?
919 
920         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
921         uint i = 32 + fromOffset;
922         uint j = 32 + toOffset;
923 
924         while (i < (32 + fromOffset + length)) {
925             assembly {
926                 let tmp := mload(add(from, i))
927                 mstore(add(to, j), tmp)
928             }
929             i += 32;
930             j += 32;
931         }
932 
933         return to;
934     }
935 
936     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
937     // Duplicate Solidity's ecrecover, but catching the CALL return value
938     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
939         // We do our own memory management here. Solidity uses memory offset
940         // 0x40 to store the current end of memory. We write past it (as
941         // writes are memory extensions), but don't update the offset so
942         // Solidity will reuse it. The memory used here is only needed for
943         // this context.
944 
945         // FIXME: inline assembly can't access return values
946         bool ret;
947         address addr;
948 
949         assembly {
950             let size := mload(0x40)
951             mstore(size, hash)
952             mstore(add(size, 32), v)
953             mstore(add(size, 64), r)
954             mstore(add(size, 96), s)
955 
956             // NOTE: we can reuse the request memory because we deal with
957             //       the return code
958             ret := call(3000, 1, 0, size, 128, size, 32)
959             addr := mload(size)
960         }
961 
962         return (ret, addr);
963     }
964 
965     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
966     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
967         bytes32 r;
968         bytes32 s;
969         uint8 v;
970 
971         if (sig.length != 65)
972           return (false, 0);
973 
974         // The signature format is a compact form of:
975         //   {bytes32 r}{bytes32 s}{uint8 v}
976         // Compact means, uint8 is not padded to 32 bytes.
977         assembly {
978             r := mload(add(sig, 32))
979             s := mload(add(sig, 64))
980 
981             // Here we are loading the last 32 bytes. We exploit the fact that
982             // 'mload' will pad with zeroes if we overread.
983             // There is no 'mload8' to do this, but that would be nicer.
984             v := byte(0, mload(add(sig, 96)))
985 
986             // Alternative solution:
987             // 'byte' is not working due to the Solidity parser, so lets
988             // use the second best option, 'and'
989             // v := and(mload(add(sig, 65)), 255)
990         }
991 
992         // albeit non-transactional signatures are not specified by the YP, one would expect it
993         // to match the YP range of [27, 28]
994         //
995         // geth uses [0, 1] and some clients have followed. This might change, see:
996         //  https://github.com/ethereum/go-ethereum/issues/2053
997         if (v < 27)
998           v += 27;
999 
1000         if (v != 27 && v != 28)
1001             return (false, 0);
1002 
1003         return safer_ecrecover(hash, v, r, s);
1004     }
1005 
1006 }
1007 
1008     contract SafeMath {
1009 
1010         function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
1011           uint256 z = x + y;
1012           assert((z >= x) && (z >= y));
1013           return z;
1014         }
1015 
1016         function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
1017           assert(x >= y);
1018           uint256 z = x - y;
1019           return z;
1020         }
1021 
1022         function safeMult(uint256 x, uint256 y) internal returns(uint256) {
1023           uint256 z = x * y;
1024           assert((x == 0)||(z/x == y));
1025           return z;
1026         }
1027 
1028     }
1029 
1030     contract Token {
1031         uint256 public totalSupply;
1032         function balanceOf(address _owner) constant returns (uint256 balance);
1033         function transfer(address _to, uint256 _value) returns (bool success);
1034         function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
1035         function approve(address _spender, uint256 _value) returns (bool success);
1036         function allowance(address _owner, address _spender) constant returns (uint256 remaining);
1037         event Transfer(address indexed _from, address indexed _to, uint256 _value);
1038         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1039     }
1040 
1041     contract StandardToken is Token {
1042         uint256 public fundingEndBlock;
1043 
1044         function transfer(address _to, uint256 _value) returns (bool success) {
1045           require (block.number > fundingEndBlock);
1046           if (balances[msg.sender] >= _value && _value > 0) {
1047             balances[msg.sender] -= _value;
1048             balances[_to] += _value;
1049             Transfer(msg.sender, _to, _value);
1050             return true;
1051           } else {
1052             return false;
1053           }
1054         }
1055 
1056         function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
1057           require (block.number > fundingEndBlock);
1058           if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
1059             balances[_to] += _value;
1060             balances[_from] -= _value;
1061             allowed[_from][msg.sender] -= _value;
1062             Transfer(_from, _to, _value);
1063             return true;
1064           } else {
1065             return false;
1066           }
1067         }
1068 
1069         function balanceOf(address _owner) constant returns (uint256 balance) {
1070             return balances[_owner];
1071         }
1072 
1073         function approve(address _spender, uint256 _value) returns (bool success) {
1074             require (block.number > fundingEndBlock);
1075             allowed[msg.sender][_spender] = _value;
1076             Approval(msg.sender, _spender, _value);
1077             return true;
1078         }
1079 
1080         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
1081           return allowed[_owner][_spender];
1082         }
1083 
1084         mapping (address => uint256) balances;
1085         mapping (address => mapping (address => uint256)) allowed;
1086     }
1087 
1088     contract CryptoCongress is StandardToken, SafeMath, usingOraclize {
1089         mapping(bytes => uint256) initialAllotments;
1090         mapping(bytes32 => bytes) validQueryIds; // Keeps track of Oraclize queries. 
1091         
1092         string public constant name = "CryptoCongress";
1093         string public constant symbol = "CC";
1094         uint256 public constant decimals = 18;
1095         string public constant requiredPrefix = "CryptoCongress ";
1096         string public constant a = "html(https://twitter.com/";
1097         string public constant b = "/status/";
1098         string public constant c = ").xpath(//*[contains(@class, 'TweetTextSize--jumbo')]/text())";
1099 
1100         address public ethFundDeposit; 
1101       
1102         // Crowdsale parameters
1103         uint256 public fundingStartBlock;
1104         uint256 public totalSupply = 0;
1105         uint256 public totalSupplyFromCrowdsale = 0;
1106 
1107         uint256 public constant tokenExchangeRate = 50; // 50 CC tokens per 1 ETH purchased at crowdsale
1108         uint256 public constant tokenCreationCap =  131583 * (10**3) * 10**decimals;  // 131,583,000 tokens
1109         
1110         event InitialAllotmentRecorded(string username, uint256 initialAllotment);
1111         
1112         // Oraclize events
1113         event newOraclizeQuery(string url);
1114         event newOraclizeCallback(string result, bytes proof);
1115 
1116         event InitialAllotmentClaimed(bytes username);
1117         event Proposal(string ID, string description, string data);
1118         event Vote(string proposalID, string vote, string data);
1119         
1120         // Constructor
1121         function CryptoCongress (
1122             address _ethFundDeposit,
1123             uint256 _fundingStartBlock,
1124             uint256 _fundingEndBlock) payable
1125         {                 
1126           ethFundDeposit = _ethFundDeposit;
1127           fundingStartBlock = _fundingStartBlock;
1128           fundingEndBlock = _fundingEndBlock;
1129 
1130           // Allows us to prove correct return from Oraclize
1131           oraclize_setProof(proofType_TLSNotary);
1132         }
1133 
1134         function createInitialAllotment(
1135             string username, 
1136             uint256 initialAllotment) 
1137         {
1138           require (msg.sender == ethFundDeposit);
1139           require (block.number < fundingStartBlock); 
1140           initialAllotments[bytes(username)] = initialAllotment;
1141           InitialAllotmentRecorded(username, initialAllotment);
1142         }
1143 
1144         function claimInitialAllotment(string twitterStatusID, string username) payable {
1145           bytes memory usernameAsBytes = bytes(username);
1146           require (usernameAsBytes.length < 16);
1147           require (msg.value > 4000000000000000); // accounts for oraclize fee
1148           require (block.number > fundingStartBlock);
1149           require (block.number < fundingEndBlock);
1150           require (initialAllotments[usernameAsBytes] > 0); // Check there are tokens to claim.
1151           
1152           string memory url = usingOraclize.strConcat(a,username,b,twitterStatusID,c);
1153          
1154           newOraclizeQuery(url);
1155           bytes32 queryId = oraclize_query("URL",url);
1156           validQueryIds[queryId] = usernameAsBytes;
1157         
1158         }
1159 
1160         function __callback(bytes32 myid, string result, bytes proof) {
1161             // Must be oraclize
1162             require (msg.sender == oraclize_cbAddress()); 
1163             newOraclizeCallback(result, proof);
1164           
1165             // // Require that the username not have claimed token allotment already
1166             require (initialAllotments[validQueryIds[myid]] > 0);  
1167 
1168             // Extra safety below; it should still satisfy basic requirements
1169             require (block.number > fundingStartBlock);
1170             require (block.number < fundingEndBlock);
1171           
1172             bytes memory resultBytes = bytes(result);
1173             
1174             // // Claiming tweet must be exactly 57 bytes
1175             // // 15 byte "CryptoCongress + 42 byte address"
1176             require (resultBytes.length == 57);
1177             
1178             // // First 16 bytes must be "CryptoCongress " (ending whitespace included)
1179             // // In hex = 0x 43 72 79 70 74 6f 43 6f 6e 67 72 65 73 73 20
1180             require (resultBytes[0] == 0x43);
1181             require (resultBytes[1] == 0x72); 
1182             require (resultBytes[2] == 0x79);
1183             require (resultBytes[3] == 0x70);
1184             require (resultBytes[4] == 0x74);
1185             require (resultBytes[5] == 0x6f);
1186             require (resultBytes[6] == 0x43);
1187             require (resultBytes[7] == 0x6f);
1188             require (resultBytes[8] == 0x6e);
1189             require (resultBytes[9] == 0x67);
1190             require (resultBytes[10] == 0x72);
1191             require (resultBytes[11] == 0x65);
1192             require (resultBytes[12] == 0x73);
1193             require (resultBytes[13] == 0x73);
1194             require (resultBytes[14] == 0x20);
1195   
1196             // // Next 20 characters are the address
1197             // // Must start with 0x
1198             require (resultBytes[15] == 0x30);
1199             require (resultBytes[16] == 0x78);
1200             
1201             // Convert bytes to an address
1202             uint160 iaddr = 0;
1203             uint160 b1;
1204             uint160 b2;
1205             
1206             for (uint i=0; i<40; i+=2){
1207                 iaddr *= 256;
1208                 b1 = uint160(resultBytes[i+17]);
1209                 b2 = uint160(resultBytes[i+18]);
1210                 if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1211                 else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1212                 else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1213                 if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1214                 else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1215                 else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1216                 iaddr += (b1*16+b2);
1217             }
1218             
1219             address addr = address(iaddr);
1220         
1221             uint256 tokenAllotment = initialAllotments[validQueryIds[myid]];
1222             uint256 checkedSupply = safeAdd(totalSupply, tokenAllotment);
1223             require (tokenCreationCap > checkedSupply); // extra safe
1224             totalSupply = checkedSupply;
1225 
1226             initialAllotments[validQueryIds[myid]] = 0;
1227             balances[addr] += tokenAllotment;  // SafeAdd not needed; bad semantics to use here
1228 
1229             // Logs token creation by username (bytes)
1230             InitialAllotmentClaimed(validQueryIds[myid]); // Log the bytes of the username who claimed funds 
1231             delete validQueryIds[myid];
1232             
1233             // Logs token creation by address for ERC20 front end compatibility
1234             Transfer(0x0,addr,tokenAllotment);
1235 
1236         }
1237 
1238         // Accepts ether and creates new CC tokens.
1239         // Enforces that no more than 1/3rd of tokens are be created by sale.
1240         function buyTokens(address beneficiary) public payable {
1241           require(beneficiary != address(0)); 
1242           require(msg.value != 0);
1243           require (block.number > fundingStartBlock);
1244           require (block.number < fundingEndBlock);
1245 
1246           uint256 tokens = safeMult(msg.value, tokenExchangeRate); 
1247           
1248           uint256 checkedTotalSupply = safeAdd(totalSupply, tokens); 
1249           uint256 checkedCrowdsaleSupply = safeAdd(totalSupplyFromCrowdsale, tokens);
1250 
1251           // (1) Enforces we don't go over total supply with potential sale. 
1252           require (tokenCreationCap > checkedTotalSupply);  
1253           
1254           // (2) Enforces that no more than 1/3rd of tokens are to be created by potential sale.
1255           require (safeMult(checkedCrowdsaleSupply, 3) < totalSupply);
1256        
1257           totalSupply = checkedTotalSupply;
1258           totalSupplyFromCrowdsale = checkedCrowdsaleSupply;
1259           
1260           balances[msg.sender] += tokens;  // safeAdd not needed
1261           
1262           // Logs token creation for ERC20 front end compatibility
1263           // All crowdsale purchases will enter via fallback function
1264           Transfer(0x0, beneficiary, tokens);  
1265         
1266         }
1267 
1268         // Secure withdraw
1269         function secureTransfer(uint256 amount) external {
1270           require (msg.sender == ethFundDeposit); 
1271           assert (ethFundDeposit.send(amount));  
1272         }
1273 
1274         // 20,000 tokens required to Propose
1275         function propose(string _ID, string _description, string _data) {
1276           require(bytes(_ID).length < 281 && bytes(_description).length < 281 && bytes(_data).length < 281);
1277           require (balances[msg.sender] > 20000000000000000000000);
1278           Proposal(_ID, _description, _data);
1279         }
1280 
1281         // 5,000 tokens required to Vote
1282         function vote(string _proposalID, string _vote, string _data) {
1283           require(bytes(_proposalID).length < 281 && bytes(_vote).length < 281 && bytes(_data).length < 281);
1284           require (balances[msg.sender] > 5000000000000000000000);
1285           Vote(_proposalID, _vote, _data);
1286         }
1287 
1288         // Payable fallback to ensure privacy.
1289         function () payable {
1290             buyTokens(msg.sender);
1291         }
1292 
1293     }