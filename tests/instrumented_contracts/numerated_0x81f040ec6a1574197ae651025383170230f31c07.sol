1 pragma solidity 0.4.19;
2 
3 /// @title ERC223 interface
4 interface ERC223 {
5 
6     function totalSupply() public view returns (uint);
7     function name() public view returns (string);
8     function symbol() public view returns (string);
9     function decimals() public view returns (uint8);
10     function balanceOf(address _owner) public view returns (uint);
11     function transfer(address _to, uint _value) public returns (bool);
12     function transfer(address _to, uint _value, bytes _data) public returns (bool);
13 
14     event Transfer(address indexed _from, address indexed _to, uint indexed _value, bytes _data);
15 }
16 
17 /// @title Interface for the contract that will work with ERC223 tokens.
18 interface ERC223ReceivingContract { 
19     /**
20      * @dev Standard ERC223 function that will handle incoming token transfers.
21      *
22      * @param _from  Token sender address.
23      * @param _value Amount of tokens.
24      * @param _data  Transaction data.
25      */
26     function tokenFallback(address _from, uint _value, bytes _data) public;
27 }
28 
29 contract OraclizeI {
30     address public cbAddress;
31     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
32     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
33     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
34     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
35     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
36     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
37     function getPrice(string _datasource) returns (uint _dsprice);
38     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
39     function useCoupon(string _coupon);
40     function setProofType(byte _proofType);
41     function setConfig(bytes32 _config);
42     function setCustomGasPrice(uint _gasPrice);
43     function randomDS_getSessionPubKeyHash() returns(bytes32);
44 }
45 
46 contract OraclizeAddrResolverI {
47     function getAddress() returns (address _addr);
48 }
49 
50 contract usingOraclize {
51     uint constant day = 60*60*24;
52     uint constant week = 60*60*24*7;
53     uint constant month = 60*60*24*30;
54     byte constant proofType_NONE = 0x00;
55     byte constant proofType_TLSNotary = 0x10;
56     byte constant proofType_Android = 0x20;
57     byte constant proofType_Ledger = 0x30;
58     byte constant proofType_Native = 0xF0;
59     byte constant proofStorage_IPFS = 0x01;
60     uint8 constant networkID_auto = 0;
61     uint8 constant networkID_mainnet = 1;
62     uint8 constant networkID_testnet = 2;
63     uint8 constant networkID_morden = 2;
64     uint8 constant networkID_consensys = 161;
65 
66     OraclizeAddrResolverI OAR;
67 
68     OraclizeI oraclize;
69     modifier oraclizeAPI {
70         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
71             oraclize_setNetwork(networkID_auto);
72 
73         if(address(oraclize) != OAR.getAddress())
74             oraclize = OraclizeI(OAR.getAddress());
75 
76         _;
77     }
78     modifier coupon(string code){
79         oraclize = OraclizeI(OAR.getAddress());
80         oraclize.useCoupon(code);
81         _;
82     }
83 
84     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
85         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
86             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
87             oraclize_setNetworkName("eth_mainnet");
88             return true;
89         }
90         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
91             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
92             oraclize_setNetworkName("eth_ropsten3");
93             return true;
94         }
95         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
96             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
97             oraclize_setNetworkName("eth_kovan");
98             return true;
99         }
100         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
101             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
102             oraclize_setNetworkName("eth_rinkeby");
103             return true;
104         }
105         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
106             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
107             return true;
108         }
109         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
110             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
111             return true;
112         }
113         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
114             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
115             return true;
116         }
117         return false;
118     }
119 
120     function __callback(bytes32 myid, string result) {
121         __callback(myid, result, new bytes(0));
122     }
123     function __callback(bytes32 myid, string result, bytes proof) {
124     }
125 
126     function oraclize_useCoupon(string code) oraclizeAPI internal {
127         oraclize.useCoupon(code);
128     }
129 
130     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
131         return oraclize.getPrice(datasource);
132     }
133 
134     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
135         return oraclize.getPrice(datasource, gaslimit);
136     }
137 
138     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource);
140         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
141         return oraclize.query.value(price)(0, datasource, arg);
142     }
143     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource);
145         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
146         return oraclize.query.value(price)(timestamp, datasource, arg);
147     }
148     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource, gaslimit);
150         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
151         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
152     }
153     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource, gaslimit);
155         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
156         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
157     }
158     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
159         uint price = oraclize.getPrice(datasource);
160         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
161         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
162     }
163     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource);
165         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
166         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
167     }
168     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
169         uint price = oraclize.getPrice(datasource, gaslimit);
170         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
171         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
172     }
173     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
174         uint price = oraclize.getPrice(datasource, gaslimit);
175         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
176         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
177     }
178     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
179         uint price = oraclize.getPrice(datasource);
180         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
181         bytes memory args = stra2cbor(argN);
182         return oraclize.queryN.value(price)(0, datasource, args);
183     }
184     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
185         uint price = oraclize.getPrice(datasource);
186         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
187         bytes memory args = stra2cbor(argN);
188         return oraclize.queryN.value(price)(timestamp, datasource, args);
189     }
190     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
191         uint price = oraclize.getPrice(datasource, gaslimit);
192         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
193         bytes memory args = stra2cbor(argN);
194         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
195     }
196     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
197         uint price = oraclize.getPrice(datasource, gaslimit);
198         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
199         bytes memory args = stra2cbor(argN);
200         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
201     }
202     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
203         string[] memory dynargs = new string[](1);
204         dynargs[0] = args[0];
205         return oraclize_query(datasource, dynargs);
206     }
207     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
208         string[] memory dynargs = new string[](1);
209         dynargs[0] = args[0];
210         return oraclize_query(timestamp, datasource, dynargs);
211     }
212     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
213         string[] memory dynargs = new string[](1);
214         dynargs[0] = args[0];
215         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
216     }
217     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
218         string[] memory dynargs = new string[](1);
219         dynargs[0] = args[0];
220         return oraclize_query(datasource, dynargs, gaslimit);
221     }
222 
223     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](2);
225         dynargs[0] = args[0];
226         dynargs[1] = args[1];
227         return oraclize_query(datasource, dynargs);
228     }
229     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
230         string[] memory dynargs = new string[](2);
231         dynargs[0] = args[0];
232         dynargs[1] = args[1];
233         return oraclize_query(timestamp, datasource, dynargs);
234     }
235     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
236         string[] memory dynargs = new string[](2);
237         dynargs[0] = args[0];
238         dynargs[1] = args[1];
239         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
240     }
241     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
242         string[] memory dynargs = new string[](2);
243         dynargs[0] = args[0];
244         dynargs[1] = args[1];
245         return oraclize_query(datasource, dynargs, gaslimit);
246     }
247     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
248         string[] memory dynargs = new string[](3);
249         dynargs[0] = args[0];
250         dynargs[1] = args[1];
251         dynargs[2] = args[2];
252         return oraclize_query(datasource, dynargs);
253     }
254     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
255         string[] memory dynargs = new string[](3);
256         dynargs[0] = args[0];
257         dynargs[1] = args[1];
258         dynargs[2] = args[2];
259         return oraclize_query(timestamp, datasource, dynargs);
260     }
261     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](3);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         dynargs[2] = args[2];
266         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
267     }
268     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
269         string[] memory dynargs = new string[](3);
270         dynargs[0] = args[0];
271         dynargs[1] = args[1];
272         dynargs[2] = args[2];
273         return oraclize_query(datasource, dynargs, gaslimit);
274     }
275 
276     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
277         string[] memory dynargs = new string[](4);
278         dynargs[0] = args[0];
279         dynargs[1] = args[1];
280         dynargs[2] = args[2];
281         dynargs[3] = args[3];
282         return oraclize_query(datasource, dynargs);
283     }
284     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
285         string[] memory dynargs = new string[](4);
286         dynargs[0] = args[0];
287         dynargs[1] = args[1];
288         dynargs[2] = args[2];
289         dynargs[3] = args[3];
290         return oraclize_query(timestamp, datasource, dynargs);
291     }
292     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
293         string[] memory dynargs = new string[](4);
294         dynargs[0] = args[0];
295         dynargs[1] = args[1];
296         dynargs[2] = args[2];
297         dynargs[3] = args[3];
298         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
299     }
300     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
301         string[] memory dynargs = new string[](4);
302         dynargs[0] = args[0];
303         dynargs[1] = args[1];
304         dynargs[2] = args[2];
305         dynargs[3] = args[3];
306         return oraclize_query(datasource, dynargs, gaslimit);
307     }
308     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](5);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         dynargs[4] = args[4];
315         return oraclize_query(datasource, dynargs);
316     }
317     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
318         string[] memory dynargs = new string[](5);
319         dynargs[0] = args[0];
320         dynargs[1] = args[1];
321         dynargs[2] = args[2];
322         dynargs[3] = args[3];
323         dynargs[4] = args[4];
324         return oraclize_query(timestamp, datasource, dynargs);
325     }
326     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
327         string[] memory dynargs = new string[](5);
328         dynargs[0] = args[0];
329         dynargs[1] = args[1];
330         dynargs[2] = args[2];
331         dynargs[3] = args[3];
332         dynargs[4] = args[4];
333         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
334     }
335     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
336         string[] memory dynargs = new string[](5);
337         dynargs[0] = args[0];
338         dynargs[1] = args[1];
339         dynargs[2] = args[2];
340         dynargs[3] = args[3];
341         dynargs[4] = args[4];
342         return oraclize_query(datasource, dynargs, gaslimit);
343     }
344     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
345         uint price = oraclize.getPrice(datasource);
346         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
347         bytes memory args = ba2cbor(argN);
348         return oraclize.queryN.value(price)(0, datasource, args);
349     }
350     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
351         uint price = oraclize.getPrice(datasource);
352         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
353         bytes memory args = ba2cbor(argN);
354         return oraclize.queryN.value(price)(timestamp, datasource, args);
355     }
356     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
357         uint price = oraclize.getPrice(datasource, gaslimit);
358         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
359         bytes memory args = ba2cbor(argN);
360         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
361     }
362     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
363         uint price = oraclize.getPrice(datasource, gaslimit);
364         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
365         bytes memory args = ba2cbor(argN);
366         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
367     }
368     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
369         bytes[] memory dynargs = new bytes[](1);
370         dynargs[0] = args[0];
371         return oraclize_query(datasource, dynargs);
372     }
373     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
374         bytes[] memory dynargs = new bytes[](1);
375         dynargs[0] = args[0];
376         return oraclize_query(timestamp, datasource, dynargs);
377     }
378     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
379         bytes[] memory dynargs = new bytes[](1);
380         dynargs[0] = args[0];
381         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
382     }
383     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
384         bytes[] memory dynargs = new bytes[](1);
385         dynargs[0] = args[0];
386         return oraclize_query(datasource, dynargs, gaslimit);
387     }
388 
389     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
390         bytes[] memory dynargs = new bytes[](2);
391         dynargs[0] = args[0];
392         dynargs[1] = args[1];
393         return oraclize_query(datasource, dynargs);
394     }
395     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
396         bytes[] memory dynargs = new bytes[](2);
397         dynargs[0] = args[0];
398         dynargs[1] = args[1];
399         return oraclize_query(timestamp, datasource, dynargs);
400     }
401     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
402         bytes[] memory dynargs = new bytes[](2);
403         dynargs[0] = args[0];
404         dynargs[1] = args[1];
405         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
406     }
407     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
408         bytes[] memory dynargs = new bytes[](2);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         return oraclize_query(datasource, dynargs, gaslimit);
412     }
413     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
414         bytes[] memory dynargs = new bytes[](3);
415         dynargs[0] = args[0];
416         dynargs[1] = args[1];
417         dynargs[2] = args[2];
418         return oraclize_query(datasource, dynargs);
419     }
420     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
421         bytes[] memory dynargs = new bytes[](3);
422         dynargs[0] = args[0];
423         dynargs[1] = args[1];
424         dynargs[2] = args[2];
425         return oraclize_query(timestamp, datasource, dynargs);
426     }
427     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
428         bytes[] memory dynargs = new bytes[](3);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
433     }
434     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
435         bytes[] memory dynargs = new bytes[](3);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         dynargs[2] = args[2];
439         return oraclize_query(datasource, dynargs, gaslimit);
440     }
441 
442     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
443         bytes[] memory dynargs = new bytes[](4);
444         dynargs[0] = args[0];
445         dynargs[1] = args[1];
446         dynargs[2] = args[2];
447         dynargs[3] = args[3];
448         return oraclize_query(datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
451         bytes[] memory dynargs = new bytes[](4);
452         dynargs[0] = args[0];
453         dynargs[1] = args[1];
454         dynargs[2] = args[2];
455         dynargs[3] = args[3];
456         return oraclize_query(timestamp, datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
459         bytes[] memory dynargs = new bytes[](4);
460         dynargs[0] = args[0];
461         dynargs[1] = args[1];
462         dynargs[2] = args[2];
463         dynargs[3] = args[3];
464         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
465     }
466     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         bytes[] memory dynargs = new bytes[](4);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         dynargs[3] = args[3];
472         return oraclize_query(datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](5);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         dynargs[3] = args[3];
480         dynargs[4] = args[4];
481         return oraclize_query(datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
484         bytes[] memory dynargs = new bytes[](5);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         dynargs[3] = args[3];
489         dynargs[4] = args[4];
490         return oraclize_query(timestamp, datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
493         bytes[] memory dynargs = new bytes[](5);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         dynargs[3] = args[3];
498         dynargs[4] = args[4];
499         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
500     }
501     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
502         bytes[] memory dynargs = new bytes[](5);
503         dynargs[0] = args[0];
504         dynargs[1] = args[1];
505         dynargs[2] = args[2];
506         dynargs[3] = args[3];
507         dynargs[4] = args[4];
508         return oraclize_query(datasource, dynargs, gaslimit);
509     }
510 
511     function oraclize_cbAddress() oraclizeAPI internal returns (address){
512         return oraclize.cbAddress();
513     }
514     function oraclize_setProof(byte proofP) oraclizeAPI internal {
515         return oraclize.setProofType(proofP);
516     }
517     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
518         return oraclize.setCustomGasPrice(gasPrice);
519     }
520     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
521         return oraclize.setConfig(config);
522     }
523 
524     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
525         return oraclize.randomDS_getSessionPubKeyHash();
526     }
527 
528     function getCodeSize(address _addr) constant internal returns(uint _size) {
529         assembly {
530             _size := extcodesize(_addr)
531         }
532     }
533 
534     function parseAddr(string _a) internal returns (address){
535         bytes memory tmp = bytes(_a);
536         uint160 iaddr = 0;
537         uint160 b1;
538         uint160 b2;
539         for (uint i=2; i<2+2*20; i+=2){
540             iaddr *= 256;
541             b1 = uint160(tmp[i]);
542             b2 = uint160(tmp[i+1]);
543             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
544             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
545             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
546             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
547             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
548             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
549             iaddr += (b1*16+b2);
550         }
551         return address(iaddr);
552     }
553 
554     function strCompare(string _a, string _b) internal returns (int) {
555         bytes memory a = bytes(_a);
556         bytes memory b = bytes(_b);
557         uint minLength = a.length;
558         if (b.length < minLength) minLength = b.length;
559         for (uint i = 0; i < minLength; i ++)
560             if (a[i] < b[i])
561                 return -1;
562             else if (a[i] > b[i])
563                 return 1;
564         if (a.length < b.length)
565             return -1;
566         else if (a.length > b.length)
567             return 1;
568         else
569             return 0;
570     }
571 
572     function indexOf(string _haystack, string _needle) internal returns (int) {
573         bytes memory h = bytes(_haystack);
574         bytes memory n = bytes(_needle);
575         if(h.length < 1 || n.length < 1 || (n.length > h.length))
576             return -1;
577         else if(h.length > (2**128 -1))
578             return -1;
579         else
580         {
581             uint subindex = 0;
582             for (uint i = 0; i < h.length; i ++)
583             {
584                 if (h[i] == n[0])
585                 {
586                     subindex = 1;
587                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
588                     {
589                         subindex++;
590                     }
591                     if(subindex == n.length)
592                         return int(i);
593                 }
594             }
595             return -1;
596         }
597     }
598 
599     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
600         bytes memory _ba = bytes(_a);
601         bytes memory _bb = bytes(_b);
602         bytes memory _bc = bytes(_c);
603         bytes memory _bd = bytes(_d);
604         bytes memory _be = bytes(_e);
605         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
606         bytes memory babcde = bytes(abcde);
607         uint k = 0;
608         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
609         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
610         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
611         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
612         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
613         return string(babcde);
614     }
615 
616     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
617         return strConcat(_a, _b, _c, _d, "");
618     }
619 
620     function strConcat(string _a, string _b, string _c) internal returns (string) {
621         return strConcat(_a, _b, _c, "", "");
622     }
623 
624     function strConcat(string _a, string _b) internal returns (string) {
625         return strConcat(_a, _b, "", "", "");
626     }
627 
628     // parseInt
629     function parseInt(string _a) internal returns (uint) {
630         return parseInt(_a, 0);
631     }
632 
633     // parseInt(parseFloat*10^_b)
634     function parseInt(string _a, uint _b) internal returns (uint) {
635         bytes memory bresult = bytes(_a);
636         uint mint = 0;
637         bool decimals = false;
638         for (uint i=0; i<bresult.length; i++){
639             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
640                 if (decimals){
641                    if (_b == 0) break;
642                     else _b--;
643                 }
644                 mint *= 10;
645                 mint += uint(bresult[i]) - 48;
646             } else if (bresult[i] == 46) decimals = true;
647         }
648         if (_b > 0) mint *= 10**_b;
649         return mint;
650     }
651 
652     function uint2str(uint i) internal returns (string){
653         if (i == 0) return "0";
654         uint j = i;
655         uint len;
656         while (j != 0){
657             len++;
658             j /= 10;
659         }
660         bytes memory bstr = new bytes(len);
661         uint k = len - 1;
662         while (i != 0){
663             bstr[k--] = byte(48 + i % 10);
664             i /= 10;
665         }
666         return string(bstr);
667     }
668 
669     function stra2cbor(string[] arr) internal returns (bytes) {
670             uint arrlen = arr.length;
671 
672             // get correct cbor output length
673             uint outputlen = 0;
674             bytes[] memory elemArray = new bytes[](arrlen);
675             for (uint i = 0; i < arrlen; i++) {
676                 elemArray[i] = (bytes(arr[i]));
677                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
678             }
679             uint ctr = 0;
680             uint cborlen = arrlen + 0x80;
681             outputlen += byte(cborlen).length;
682             bytes memory res = new bytes(outputlen);
683 
684             while (byte(cborlen).length > ctr) {
685                 res[ctr] = byte(cborlen)[ctr];
686                 ctr++;
687             }
688             for (i = 0; i < arrlen; i++) {
689                 res[ctr] = 0x5F;
690                 ctr++;
691                 for (uint x = 0; x < elemArray[i].length; x++) {
692                     // if there's a bug with larger strings, this may be the culprit
693                     if (x % 23 == 0) {
694                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
695                         elemcborlen += 0x40;
696                         uint lctr = ctr;
697                         while (byte(elemcborlen).length > ctr - lctr) {
698                             res[ctr] = byte(elemcborlen)[ctr - lctr];
699                             ctr++;
700                         }
701                     }
702                     res[ctr] = elemArray[i][x];
703                     ctr++;
704                 }
705                 res[ctr] = 0xFF;
706                 ctr++;
707             }
708             return res;
709         }
710 
711     function ba2cbor(bytes[] arr) internal returns (bytes) {
712             uint arrlen = arr.length;
713 
714             // get correct cbor output length
715             uint outputlen = 0;
716             bytes[] memory elemArray = new bytes[](arrlen);
717             for (uint i = 0; i < arrlen; i++) {
718                 elemArray[i] = (bytes(arr[i]));
719                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
720             }
721             uint ctr = 0;
722             uint cborlen = arrlen + 0x80;
723             outputlen += byte(cborlen).length;
724             bytes memory res = new bytes(outputlen);
725 
726             while (byte(cborlen).length > ctr) {
727                 res[ctr] = byte(cborlen)[ctr];
728                 ctr++;
729             }
730             for (i = 0; i < arrlen; i++) {
731                 res[ctr] = 0x5F;
732                 ctr++;
733                 for (uint x = 0; x < elemArray[i].length; x++) {
734                     // if there's a bug with larger strings, this may be the culprit
735                     if (x % 23 == 0) {
736                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
737                         elemcborlen += 0x40;
738                         uint lctr = ctr;
739                         while (byte(elemcborlen).length > ctr - lctr) {
740                             res[ctr] = byte(elemcborlen)[ctr - lctr];
741                             ctr++;
742                         }
743                     }
744                     res[ctr] = elemArray[i][x];
745                     ctr++;
746                 }
747                 res[ctr] = 0xFF;
748                 ctr++;
749             }
750             return res;
751         }
752 
753 
754     string oraclize_network_name;
755     function oraclize_setNetworkName(string _network_name) internal {
756         oraclize_network_name = _network_name;
757     }
758 
759     function oraclize_getNetworkName() internal returns (string) {
760         return oraclize_network_name;
761     }
762 
763     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
764         if ((_nbytes == 0)||(_nbytes > 32)) throw;
765         bytes memory nbytes = new bytes(1);
766         nbytes[0] = byte(_nbytes);
767         bytes memory unonce = new bytes(32);
768         bytes memory sessionKeyHash = new bytes(32);
769         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
770         assembly {
771             mstore(unonce, 0x20)
772             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
773             mstore(sessionKeyHash, 0x20)
774             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
775         }
776         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
777         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
778         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
779         return queryId;
780     }
781 
782     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
783         oraclize_randomDS_args[queryId] = commitment;
784     }
785 
786     mapping(bytes32=>bytes32) oraclize_randomDS_args;
787     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
788 
789     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
790         bool sigok;
791         address signer;
792 
793         bytes32 sigr;
794         bytes32 sigs;
795 
796         bytes memory sigr_ = new bytes(32);
797         uint offset = 4+(uint(dersig[3]) - 0x20);
798         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
799         bytes memory sigs_ = new bytes(32);
800         offset += 32 + 2;
801         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
802 
803         assembly {
804             sigr := mload(add(sigr_, 32))
805             sigs := mload(add(sigs_, 32))
806         }
807 
808 
809         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
810         if (address(sha3(pubkey)) == signer) return true;
811         else {
812             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
813             return (address(sha3(pubkey)) == signer);
814         }
815     }
816 
817     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
818         bool sigok;
819 
820         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
821         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
822         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
823 
824         bytes memory appkey1_pubkey = new bytes(64);
825         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
826 
827         bytes memory tosign2 = new bytes(1+65+32);
828         tosign2[0] = 1; //role
829         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
830         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
831         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
832         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
833 
834         if (sigok == false) return false;
835 
836 
837         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
838         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
839 
840         bytes memory tosign3 = new bytes(1+65);
841         tosign3[0] = 0xFE;
842         copyBytes(proof, 3, 65, tosign3, 1);
843 
844         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
845         copyBytes(proof, 3+65, sig3.length, sig3, 0);
846 
847         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
848 
849         return sigok;
850     }
851 
852     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
853         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
854         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
855 
856         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
857         if (proofVerified == false) throw;
858 
859         _;
860     }
861 
862     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
863         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
864         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
865 
866         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
867         if (proofVerified == false) return 2;
868 
869         return 0;
870     }
871 
872     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
873         bool match_ = true;
874         
875         for (uint256 i=0; i< n_random_bytes; i++) {
876             if (content[i] != prefix[i]) match_ = false;
877         }
878 
879         return match_;
880     }
881 
882     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
883 
884         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
885         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
886         bytes memory keyhash = new bytes(32);
887         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
888         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
889 
890         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
891         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
892 
893         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
894         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
895 
896         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
897         // This is to verify that the computed args match with the ones specified in the query.
898         bytes memory commitmentSlice1 = new bytes(8+1+32);
899         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
900 
901         bytes memory sessionPubkey = new bytes(64);
902         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
903         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
904 
905         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
906         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
907             delete oraclize_randomDS_args[queryId];
908         } else return false;
909 
910 
911         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
912         bytes memory tosign1 = new bytes(32+8+1+32);
913         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
914         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
915 
916         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
917         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
918             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
919         }
920 
921         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
922     }
923 
924 
925     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
926     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
927         uint minLength = length + toOffset;
928 
929         if (to.length < minLength) {
930             // Buffer too small
931             throw; // Should be a better way?
932         }
933 
934         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
935         uint i = 32 + fromOffset;
936         uint j = 32 + toOffset;
937 
938         while (i < (32 + fromOffset + length)) {
939             assembly {
940                 let tmp := mload(add(from, i))
941                 mstore(add(to, j), tmp)
942             }
943             i += 32;
944             j += 32;
945         }
946 
947         return to;
948     }
949 
950     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
951     // Duplicate Solidity's ecrecover, but catching the CALL return value
952     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
953         // We do our own memory management here. Solidity uses memory offset
954         // 0x40 to store the current end of memory. We write past it (as
955         // writes are memory extensions), but don't update the offset so
956         // Solidity will reuse it. The memory used here is only needed for
957         // this context.
958 
959         // FIXME: inline assembly can't access return values
960         bool ret;
961         address addr;
962 
963         assembly {
964             let size := mload(0x40)
965             mstore(size, hash)
966             mstore(add(size, 32), v)
967             mstore(add(size, 64), r)
968             mstore(add(size, 96), s)
969 
970             // NOTE: we can reuse the request memory because we deal with
971             //       the return code
972             ret := call(3000, 1, 0, size, 128, size, 32)
973             addr := mload(size)
974         }
975 
976         return (ret, addr);
977     }
978 
979     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
980     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
981         bytes32 r;
982         bytes32 s;
983         uint8 v;
984 
985         if (sig.length != 65)
986           return (false, 0);
987 
988         // The signature format is a compact form of:
989         //   {bytes32 r}{bytes32 s}{uint8 v}
990         // Compact means, uint8 is not padded to 32 bytes.
991         assembly {
992             r := mload(add(sig, 32))
993             s := mload(add(sig, 64))
994 
995             // Here we are loading the last 32 bytes. We exploit the fact that
996             // 'mload' will pad with zeroes if we overread.
997             // There is no 'mload8' to do this, but that would be nicer.
998             v := byte(0, mload(add(sig, 96)))
999 
1000             // Alternative solution:
1001             // 'byte' is not working due to the Solidity parser, so lets
1002             // use the second best option, 'and'
1003             // v := and(mload(add(sig, 65)), 255)
1004         }
1005 
1006         // albeit non-transactional signatures are not specified by the YP, one would expect it
1007         // to match the YP range of [27, 28]
1008         //
1009         // geth uses [0, 1] and some clients have followed. This might change, see:
1010         //  https://github.com/ethereum/go-ethereum/issues/2053
1011         if (v < 27)
1012           v += 27;
1013 
1014         if (v != 27 && v != 28)
1015             return (false, 0);
1016 
1017         return safer_ecrecover(hash, v, r, s);
1018     }
1019 
1020 }
1021 // </ORACLIZE_API>
1022 
1023 /**
1024  * @title Ownable
1025  * @dev The Ownable contract has an owner address, and provides basic authorization control
1026  * functions, this simplifies the implementation of "user permissions".
1027  */
1028 contract Ownable {
1029   address public owner;
1030 
1031 
1032   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1033 
1034 
1035   /**
1036    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1037    * account.
1038    */
1039   function Ownable() public {
1040     owner = msg.sender;
1041   }
1042 
1043   /**
1044    * @dev Throws if called by any account other than the owner.
1045    */
1046   modifier onlyOwner() {
1047     require(msg.sender == owner);
1048     _;
1049   }
1050 
1051   /**
1052    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1053    * @param newOwner The address to transfer ownership to.
1054    */
1055   function transferOwnership(address newOwner) public onlyOwner {
1056     require(newOwner != address(0));
1057     OwnershipTransferred(owner, newOwner);
1058     owner = newOwner;
1059   }
1060 
1061 }
1062 
1063 
1064 /**
1065  * @title Dutch auction of DGTX tokens. Sale of 100 000 000 DGTX.
1066  * @author SmartDec
1067  */
1068 contract Auction is Ownable, usingOraclize, ERC223ReceivingContract {
1069     
1070     address public token;
1071     address public beneficiary;
1072 
1073     uint public constant TOKEN_DECIMALS_MULTIPLIER = uint(10) ** 18;
1074     uint public constant TOTAL_TOKENS = 100000000 * TOKEN_DECIMALS_MULTIPLIER; // 100 000 000 DGTX
1075     uint public constant DOLLAR_DECIMALS_MULTIPLIER = 100;
1076 
1077     uint public constant START_PRICE_IN_CENTS = 25; 
1078     uint public constant MIN_PRICE_IN_CENTS = 1; 
1079     uint public constant TRANSACTION_MIN_IN_ETH = 0.01 ether; 
1080     uint public constant START_ETH_TO_CENTS = 83800; 
1081 
1082     uint public startTime;
1083     uint public endTime;
1084 
1085     uint public maxBidInCentsPerAddress;
1086     uint public ethToCents = START_ETH_TO_CENTS;
1087     
1088     uint public totalTokens = TOTAL_TOKENS;
1089     bool public tokensReceived = false;
1090     uint public totalCentsCollected = 0;
1091     address[] public participants;
1092     mapping (address => uint) public centsReceived; // Participants' bid in USD cents
1093     mapping (address => bool) public withdrawn; // Participants who received their tokens
1094 
1095     bool public updateEthToCentsRateCycleStarted = false;
1096     
1097     event NewOraclizeQuery(string description);
1098     event EthToCentsUpdated(uint _rate);
1099     event Bid(address indexed _from, uint256 _valueCents);
1100     event TokensWithdraw(address indexed _whom, uint256 _value);
1101 
1102     /**
1103      * @notice Constructor for contract. Sets token and beneficiary addresses.
1104      * @param _token token address - supposed to be DGTX address
1105      * @param _beneficiary recipient of received ethers
1106      */
1107     function Auction(address _token, address _beneficiary, uint _startTime, uint _maxBidInCentsPerAddress)
1108             public
1109             payable
1110             Ownable()
1111     {
1112         require(_token != address(0));
1113         require(_beneficiary != address(0));
1114         require(_startTime > now);
1115         require(_maxBidInCentsPerAddress > 0);
1116         token = _token;
1117         beneficiary = _beneficiary;
1118         startTime = _startTime;
1119         endTime = startTime + 30 days;
1120         maxBidInCentsPerAddress = _maxBidInCentsPerAddress;
1121     }
1122 
1123     /**
1124      * @notice Fallback function.
1125      * During the auction receives and remembers participants bids.
1126      * After the sale is finished, withdraws tokens to participants.
1127      * It is not allowed to bid from contract (e.g., multisig).
1128      */
1129     function () public payable {
1130         if (msg.sender == owner) {
1131             return;
1132         }
1133         require(now >= startTime);
1134         require(!isContract(msg.sender));
1135 
1136         if (!hasEnded()) {
1137             require(msg.value >= TRANSACTION_MIN_IN_ETH);
1138             bid(msg.sender, msg.value);
1139         } else {
1140             require(!withdrawn[msg.sender]);
1141             require(centsReceived[msg.sender] != 0);
1142             withdrawTokens(msg.sender);
1143             msg.sender.transfer(msg.value);
1144         }
1145     }
1146 
1147     /**
1148      * @notice Anyone can call this function to start update cycle.
1149      */
1150     function startEthToCentsRateUpdateCycle() public {
1151         require(!updateEthToCentsRateCycleStarted);
1152         updateEthToCentsRateCycleStarted = true;
1153         updateEthToCentsRate(0);
1154     }
1155 
1156     /**
1157      * @notice Function to receive ERC223 tokens (only from token, only once, only TOTAL_TOKENS).
1158      * @param _value number of tokens to receive
1159      */
1160     function tokenFallback(address, uint _value, bytes) public {
1161         require(msg.sender == token);
1162         require(!tokensReceived);
1163         require(_value == TOTAL_TOKENS);
1164         totalTokens = TOTAL_TOKENS;
1165         tokensReceived = true;
1166     }
1167 
1168     /**
1169      * @notice Get current price: dgtx to cents.
1170      * 25 cents in the beginning and linearly decreases by 1 cent every hour until it reaches 1 cent.
1171      * @return current token to cents price
1172      */
1173     function getPrice() public view returns (uint) {
1174         if (now < startTime) {
1175             return START_PRICE_IN_CENTS;
1176         }
1177         uint passedHours = (now - startTime) / 1 hours;
1178         return (passedHours >= 24) ? MIN_PRICE_IN_CENTS : (25 - passedHours);
1179     }
1180 
1181     /**
1182      * @notice Checks if auction has ended.
1183      * @return true if auction has ended
1184      */
1185     function hasEnded() public view returns (bool) {
1186         return now > endTime || areTokensSold();
1187     }
1188 
1189     /**
1190      * @notice Сhecks if sufficient funds have been received:
1191      * amount of USD cents received is more or equal to the current valuation of the tokens offered
1192      * (that is current auction token price multiplied by total amount of tokens offered).
1193      * @dev Sets final token price
1194      * @return true if all tokens are sold
1195      */
1196     function areTokensSold() public view returns (bool) {
1197         return totalCentsCollected >= getPrice() * totalTokens / TOKEN_DECIMALS_MULTIPLIER;
1198     }
1199 
1200     /**
1201      * @notice Function to receive transaction from oracle with new ETH rate.
1202      * @dev Calls updateEthToCentsRate in one hour (starts update cycle)
1203      * @param result string with new rate
1204      */
1205     function __callback(bytes32, string result) public {
1206         require(msg.sender == oraclize_cbAddress());
1207         uint newEthToCents = parseInt(result, 2); // convert string to cents
1208         if (newEthToCents > 0) {
1209             ethToCents = newEthToCents;
1210             EthToCentsUpdated(ethToCents);
1211         } 
1212         if (!hasEnded()) {
1213             updateEthToCentsRate(1 hours);
1214         }
1215     }
1216 
1217     /**
1218      * @notice Function to transfer tokens to participants in the range [_from, _to).
1219      * @param _from starting index in the range of participants to withdraw to
1220      * @param _to index after the last participant to withdraw to
1221      */
1222     function distributeTokensRange(uint _from, uint _to) public {
1223         require(hasEnded());
1224         require(_from < _to && _to <= participants.length);
1225 
1226         address recipient;
1227         for (uint i = _from; i < _to; ++i) {
1228             recipient = participants[i];
1229             if (!withdrawn[recipient]) {
1230                 withdrawTokens(recipient);
1231             }
1232         }
1233     }
1234 
1235     /**
1236      * @notice Lets the owner withdraw extra tokens, which were not sold during the auction.
1237      * @param _recipient address to transfer tokens to
1238      */
1239     function withdrawExtraTokens(address _recipient) public onlyOwner {
1240         require(now > endTime && !areTokensSold());
1241         uint gap = totalTokens - totalCentsCollected * TOKEN_DECIMALS_MULTIPLIER / MIN_PRICE_IN_CENTS;
1242         ERC223(token).transfer(_recipient, gap);
1243     }
1244 
1245     /**
1246      * @notice Lets the owner withdraw ethers from contract.
1247      * @param _recipient address to transfer ethers to
1248      * @param _value Wei to withdraw
1249      */
1250     function withdraw(address _recipient, uint _value) public onlyOwner {
1251         require(_value != 0);
1252         require(_recipient != address(0));
1253         require(this.balance >= _value);
1254         _recipient.transfer(_value);
1255     }
1256 
1257     /**
1258      * @notice Lets the owner withdraw all ethers from contract.
1259      * @param _recipient address to transfer ethers to 
1260      */
1261     function withdrawAll(address _recipient) public onlyOwner {
1262         withdraw(_recipient, this.balance);
1263     }
1264 
1265     /**
1266      * @dev Function which records bids.
1267      * @param _bidder is the address that bids
1268      * @param _valueETH is value of THE bid in ether
1269      */
1270     function bid(address _bidder, uint _valueETH) internal {
1271         uint price = getPrice();
1272         uint bidInCents = _valueETH * ethToCents / 1 ether;
1273 
1274         uint centsToAccept = bidInCents;
1275         uint ethToAccept = _valueETH;
1276 
1277         // Refund any ether above address bid limit
1278         if (centsReceived[_bidder] + centsToAccept > maxBidInCentsPerAddress) {
1279             centsToAccept = maxBidInCentsPerAddress - centsReceived[_bidder];
1280             ethToAccept = centsToAccept * 1 ether / ethToCents;
1281         }
1282 
1283         // Refund bid part which more than total tokens cost
1284         if (totalCentsCollected + centsToAccept > price * totalTokens / TOKEN_DECIMALS_MULTIPLIER) {
1285             centsToAccept = price * totalTokens / TOKEN_DECIMALS_MULTIPLIER - totalCentsCollected;
1286             ethToAccept = centsToAccept * 1 ether / ethToCents;
1287         }
1288 
1289         require(centsToAccept > 0 && ethToAccept > 0);
1290 
1291         if (centsReceived[_bidder] == 0) {
1292             participants.push(_bidder);
1293         }
1294 
1295         centsReceived[_bidder] += centsToAccept;
1296         totalCentsCollected += centsToAccept;
1297         Bid(_bidder, centsToAccept);
1298 
1299         if (ethToAccept < _valueETH) {
1300             _bidder.transfer(_valueETH - ethToAccept);
1301         }
1302         beneficiary.transfer(ethToAccept);
1303     }
1304 
1305     /**
1306      * @dev Internal function to withdraw tokens by final price.
1307      * @param _recipient participant to withdraw
1308      */
1309     function withdrawTokens(address _recipient) internal {
1310         uint256 tokens = 0;
1311         if (totalCentsCollected < totalTokens * MIN_PRICE_IN_CENTS / TOKEN_DECIMALS_MULTIPLIER) {
1312             tokens = centsReceived[_recipient] * TOKEN_DECIMALS_MULTIPLIER / MIN_PRICE_IN_CENTS;
1313         } else {
1314             tokens = centsReceived[_recipient] * totalTokens / totalCentsCollected;
1315         }
1316         withdrawn[_recipient] = true;
1317         ERC223(token).transfer(_recipient, tokens);
1318         TokensWithdraw(_recipient, tokens);
1319     }
1320 
1321     /**
1322      * @dev Assemble the given address bytecode. If bytecode exists then the _addr is a contract.
1323      * @return true if _addr is contract
1324      */
1325     function isContract(address _addr) internal view returns (bool) {
1326         // retrieve the size of the code on target address, this needs assembly
1327         uint length;
1328         assembly { length := extcodesize(_addr) }
1329         return length > 0;
1330     }
1331 
1332     /**
1333      * @dev Internal function to make an oraclize query for rate update with given delay in seconds.
1334      * @param _delay Delay for query in seconds
1335      */
1336     function updateEthToCentsRate(uint _delay) private {
1337         NewOraclizeQuery("Update of ETH to USD cents price requested");
1338         oraclize_query(
1339             _delay,
1340             "URL",
1341             "json(https://api.etherscan.io/api?module=stats&action=ethprice&apikey=YourApiKeyToken).result.ethusd");
1342     }
1343 
1344 }