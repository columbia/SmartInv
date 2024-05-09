1 pragma solidity ^0.4.20;
2 /* import "github.com/oraclize/ethereum-api/oraclizeAPI.sol"; */
3 
4 
5 contract OraclizeI {
6     address public cbAddress;
7     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
8     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
9     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
10     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
11     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
12     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
13     function getPrice(string _datasource) public returns (uint _dsprice);
14     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
15     function setProofType(byte _proofType) external;
16     function setCustomGasPrice(uint _gasPrice) external;
17     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
18 }
19 contract OraclizeAddrResolverI {
20     function getAddress() public returns (address _addr);
21 }
22 contract usingOraclize {
23     uint constant day = 60*60*24;
24     uint constant week = 60*60*24*7;
25     uint constant month = 60*60*24*30;
26     byte constant proofType_NONE = 0x00;
27     byte constant proofType_TLSNotary = 0x10;
28     byte constant proofType_Android = 0x20;
29     byte constant proofType_Ledger = 0x30;
30     byte constant proofType_Native = 0xF0;
31     byte constant proofStorage_IPFS = 0x01;
32     uint8 constant networkID_auto = 0;
33     uint8 constant networkID_mainnet = 1;
34     uint8 constant networkID_testnet = 2;
35     uint8 constant networkID_morden = 2;
36     uint8 constant networkID_consensys = 161;
37 
38     OraclizeAddrResolverI OAR;
39 
40     OraclizeI oraclize;
41     modifier oraclizeAPI {
42         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
43             oraclize_setNetwork(networkID_auto);
44 
45         if(address(oraclize) != OAR.getAddress())
46             oraclize = OraclizeI(OAR.getAddress());
47 
48         _;
49     }
50     modifier coupon(string code){
51         oraclize = OraclizeI(OAR.getAddress());
52         _;
53     }
54 
55     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
56       return oraclize_setNetwork();
57       networkID; // silence the warning and remain backwards compatible
58     }
59     function oraclize_setNetwork() internal returns(bool){
60         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
61             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
62             oraclize_setNetworkName("eth_mainnet");
63             return true;
64         }
65         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
66             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
67             oraclize_setNetworkName("eth_ropsten3");
68             return true;
69         }
70         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
71             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
72             oraclize_setNetworkName("eth_kovan");
73             return true;
74         }
75         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
76             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
77             oraclize_setNetworkName("eth_rinkeby");
78             return true;
79         }
80         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
81             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
82             return true;
83         }
84         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
85             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
86             return true;
87         }
88         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
89             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
90             return true;
91         }
92         return false;
93     }
94 
95     function __callback(bytes32 myid, string result) public {
96         __callback(myid, result, new bytes(0));
97     }
98     function __callback(bytes32 myid, string result, bytes proof) public {
99       return;
100       myid; result; proof; // Silence compiler warnings
101     }
102 
103     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
104         return oraclize.getPrice(datasource);
105     }
106 
107     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
108         return oraclize.getPrice(datasource, gaslimit);
109     }
110 
111     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
112         uint price = oraclize.getPrice(datasource);
113         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
114         return oraclize.query.value(price)(0, datasource, arg);
115     }
116     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
117         uint price = oraclize.getPrice(datasource);
118         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
119         return oraclize.query.value(price)(timestamp, datasource, arg);
120     }
121     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
122         uint price = oraclize.getPrice(datasource, gaslimit);
123         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
124         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
125     }
126     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
127         uint price = oraclize.getPrice(datasource, gaslimit);
128         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
129         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
130     }
131     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
132         uint price = oraclize.getPrice(datasource);
133         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
134         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
135     }
136     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
137         uint price = oraclize.getPrice(datasource);
138         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
139         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
140     }
141     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
142         uint price = oraclize.getPrice(datasource, gaslimit);
143         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
144         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
145     }
146     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
147         uint price = oraclize.getPrice(datasource, gaslimit);
148         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
149         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
150     }
151     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
152         uint price = oraclize.getPrice(datasource);
153         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
154         bytes memory args = stra2cbor(argN);
155         return oraclize.queryN.value(price)(0, datasource, args);
156     }
157     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
158         uint price = oraclize.getPrice(datasource);
159         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
160         bytes memory args = stra2cbor(argN);
161         return oraclize.queryN.value(price)(timestamp, datasource, args);
162     }
163     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
164         uint price = oraclize.getPrice(datasource, gaslimit);
165         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
166         bytes memory args = stra2cbor(argN);
167         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
168     }
169     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
170         uint price = oraclize.getPrice(datasource, gaslimit);
171         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
172         bytes memory args = stra2cbor(argN);
173         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
174     }
175     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
176         string[] memory dynargs = new string[](1);
177         dynargs[0] = args[0];
178         return oraclize_query(datasource, dynargs);
179     }
180     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
181         string[] memory dynargs = new string[](1);
182         dynargs[0] = args[0];
183         return oraclize_query(timestamp, datasource, dynargs);
184     }
185     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
186         string[] memory dynargs = new string[](1);
187         dynargs[0] = args[0];
188         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
189     }
190     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
191         string[] memory dynargs = new string[](1);
192         dynargs[0] = args[0];
193         return oraclize_query(datasource, dynargs, gaslimit);
194     }
195 
196     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
197         string[] memory dynargs = new string[](2);
198         dynargs[0] = args[0];
199         dynargs[1] = args[1];
200         return oraclize_query(datasource, dynargs);
201     }
202     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
203         string[] memory dynargs = new string[](2);
204         dynargs[0] = args[0];
205         dynargs[1] = args[1];
206         return oraclize_query(timestamp, datasource, dynargs);
207     }
208     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
209         string[] memory dynargs = new string[](2);
210         dynargs[0] = args[0];
211         dynargs[1] = args[1];
212         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
213     }
214     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
215         string[] memory dynargs = new string[](2);
216         dynargs[0] = args[0];
217         dynargs[1] = args[1];
218         return oraclize_query(datasource, dynargs, gaslimit);
219     }
220     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
221         string[] memory dynargs = new string[](3);
222         dynargs[0] = args[0];
223         dynargs[1] = args[1];
224         dynargs[2] = args[2];
225         return oraclize_query(datasource, dynargs);
226     }
227     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
228         string[] memory dynargs = new string[](3);
229         dynargs[0] = args[0];
230         dynargs[1] = args[1];
231         dynargs[2] = args[2];
232         return oraclize_query(timestamp, datasource, dynargs);
233     }
234     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
235         string[] memory dynargs = new string[](3);
236         dynargs[0] = args[0];
237         dynargs[1] = args[1];
238         dynargs[2] = args[2];
239         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
240     }
241     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
242         string[] memory dynargs = new string[](3);
243         dynargs[0] = args[0];
244         dynargs[1] = args[1];
245         dynargs[2] = args[2];
246         return oraclize_query(datasource, dynargs, gaslimit);
247     }
248 
249     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
250         string[] memory dynargs = new string[](4);
251         dynargs[0] = args[0];
252         dynargs[1] = args[1];
253         dynargs[2] = args[2];
254         dynargs[3] = args[3];
255         return oraclize_query(datasource, dynargs);
256     }
257     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
258         string[] memory dynargs = new string[](4);
259         dynargs[0] = args[0];
260         dynargs[1] = args[1];
261         dynargs[2] = args[2];
262         dynargs[3] = args[3];
263         return oraclize_query(timestamp, datasource, dynargs);
264     }
265     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
266         string[] memory dynargs = new string[](4);
267         dynargs[0] = args[0];
268         dynargs[1] = args[1];
269         dynargs[2] = args[2];
270         dynargs[3] = args[3];
271         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
272     }
273     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
274         string[] memory dynargs = new string[](4);
275         dynargs[0] = args[0];
276         dynargs[1] = args[1];
277         dynargs[2] = args[2];
278         dynargs[3] = args[3];
279         return oraclize_query(datasource, dynargs, gaslimit);
280     }
281     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
282         string[] memory dynargs = new string[](5);
283         dynargs[0] = args[0];
284         dynargs[1] = args[1];
285         dynargs[2] = args[2];
286         dynargs[3] = args[3];
287         dynargs[4] = args[4];
288         return oraclize_query(datasource, dynargs);
289     }
290     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
291         string[] memory dynargs = new string[](5);
292         dynargs[0] = args[0];
293         dynargs[1] = args[1];
294         dynargs[2] = args[2];
295         dynargs[3] = args[3];
296         dynargs[4] = args[4];
297         return oraclize_query(timestamp, datasource, dynargs);
298     }
299     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
300         string[] memory dynargs = new string[](5);
301         dynargs[0] = args[0];
302         dynargs[1] = args[1];
303         dynargs[2] = args[2];
304         dynargs[3] = args[3];
305         dynargs[4] = args[4];
306         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
307     }
308     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
309         string[] memory dynargs = new string[](5);
310         dynargs[0] = args[0];
311         dynargs[1] = args[1];
312         dynargs[2] = args[2];
313         dynargs[3] = args[3];
314         dynargs[4] = args[4];
315         return oraclize_query(datasource, dynargs, gaslimit);
316     }
317     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
318         uint price = oraclize.getPrice(datasource);
319         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
320         bytes memory args = ba2cbor(argN);
321         return oraclize.queryN.value(price)(0, datasource, args);
322     }
323     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
324         uint price = oraclize.getPrice(datasource);
325         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
326         bytes memory args = ba2cbor(argN);
327         return oraclize.queryN.value(price)(timestamp, datasource, args);
328     }
329     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
330         uint price = oraclize.getPrice(datasource, gaslimit);
331         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
332         bytes memory args = ba2cbor(argN);
333         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
334     }
335     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
336         uint price = oraclize.getPrice(datasource, gaslimit);
337         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
338         bytes memory args = ba2cbor(argN);
339         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
340     }
341     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
342         bytes[] memory dynargs = new bytes[](1);
343         dynargs[0] = args[0];
344         return oraclize_query(datasource, dynargs);
345     }
346     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
347         bytes[] memory dynargs = new bytes[](1);
348         dynargs[0] = args[0];
349         return oraclize_query(timestamp, datasource, dynargs);
350     }
351     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
352         bytes[] memory dynargs = new bytes[](1);
353         dynargs[0] = args[0];
354         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
355     }
356     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
357         bytes[] memory dynargs = new bytes[](1);
358         dynargs[0] = args[0];
359         return oraclize_query(datasource, dynargs, gaslimit);
360     }
361 
362     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
363         bytes[] memory dynargs = new bytes[](2);
364         dynargs[0] = args[0];
365         dynargs[1] = args[1];
366         return oraclize_query(datasource, dynargs);
367     }
368     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
369         bytes[] memory dynargs = new bytes[](2);
370         dynargs[0] = args[0];
371         dynargs[1] = args[1];
372         return oraclize_query(timestamp, datasource, dynargs);
373     }
374     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
375         bytes[] memory dynargs = new bytes[](2);
376         dynargs[0] = args[0];
377         dynargs[1] = args[1];
378         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
379     }
380     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
381         bytes[] memory dynargs = new bytes[](2);
382         dynargs[0] = args[0];
383         dynargs[1] = args[1];
384         return oraclize_query(datasource, dynargs, gaslimit);
385     }
386     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
387         bytes[] memory dynargs = new bytes[](3);
388         dynargs[0] = args[0];
389         dynargs[1] = args[1];
390         dynargs[2] = args[2];
391         return oraclize_query(datasource, dynargs);
392     }
393     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
394         bytes[] memory dynargs = new bytes[](3);
395         dynargs[0] = args[0];
396         dynargs[1] = args[1];
397         dynargs[2] = args[2];
398         return oraclize_query(timestamp, datasource, dynargs);
399     }
400     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
401         bytes[] memory dynargs = new bytes[](3);
402         dynargs[0] = args[0];
403         dynargs[1] = args[1];
404         dynargs[2] = args[2];
405         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
406     }
407     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
408         bytes[] memory dynargs = new bytes[](3);
409         dynargs[0] = args[0];
410         dynargs[1] = args[1];
411         dynargs[2] = args[2];
412         return oraclize_query(datasource, dynargs, gaslimit);
413     }
414 
415     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
416         bytes[] memory dynargs = new bytes[](4);
417         dynargs[0] = args[0];
418         dynargs[1] = args[1];
419         dynargs[2] = args[2];
420         dynargs[3] = args[3];
421         return oraclize_query(datasource, dynargs);
422     }
423     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
424         bytes[] memory dynargs = new bytes[](4);
425         dynargs[0] = args[0];
426         dynargs[1] = args[1];
427         dynargs[2] = args[2];
428         dynargs[3] = args[3];
429         return oraclize_query(timestamp, datasource, dynargs);
430     }
431     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
432         bytes[] memory dynargs = new bytes[](4);
433         dynargs[0] = args[0];
434         dynargs[1] = args[1];
435         dynargs[2] = args[2];
436         dynargs[3] = args[3];
437         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
438     }
439     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
440         bytes[] memory dynargs = new bytes[](4);
441         dynargs[0] = args[0];
442         dynargs[1] = args[1];
443         dynargs[2] = args[2];
444         dynargs[3] = args[3];
445         return oraclize_query(datasource, dynargs, gaslimit);
446     }
447     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
448         bytes[] memory dynargs = new bytes[](5);
449         dynargs[0] = args[0];
450         dynargs[1] = args[1];
451         dynargs[2] = args[2];
452         dynargs[3] = args[3];
453         dynargs[4] = args[4];
454         return oraclize_query(datasource, dynargs);
455     }
456     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
457         bytes[] memory dynargs = new bytes[](5);
458         dynargs[0] = args[0];
459         dynargs[1] = args[1];
460         dynargs[2] = args[2];
461         dynargs[3] = args[3];
462         dynargs[4] = args[4];
463         return oraclize_query(timestamp, datasource, dynargs);
464     }
465     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
466         bytes[] memory dynargs = new bytes[](5);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         dynargs[2] = args[2];
470         dynargs[3] = args[3];
471         dynargs[4] = args[4];
472         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
473     }
474     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
475         bytes[] memory dynargs = new bytes[](5);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         dynargs[2] = args[2];
479         dynargs[3] = args[3];
480         dynargs[4] = args[4];
481         return oraclize_query(datasource, dynargs, gaslimit);
482     }
483 
484     function oraclize_cbAddress() oraclizeAPI internal returns (address){
485         return oraclize.cbAddress();
486     }
487     function oraclize_setProof(byte proofP) oraclizeAPI internal {
488         return oraclize.setProofType(proofP);
489     }
490     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
491         return oraclize.setCustomGasPrice(gasPrice);
492     }
493 
494     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
495         return oraclize.randomDS_getSessionPubKeyHash();
496     }
497 
498     function getCodeSize(address _addr) constant internal returns(uint _size) {
499         assembly {
500             _size := extcodesize(_addr)
501         }
502     }
503 
504     function parseAddr(string _a) internal pure returns (address){
505         bytes memory tmp = bytes(_a);
506         uint160 iaddr = 0;
507         uint160 b1;
508         uint160 b2;
509         for (uint i=2; i<2+2*20; i+=2){
510             iaddr *= 256;
511             b1 = uint160(tmp[i]);
512             b2 = uint160(tmp[i+1]);
513             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
514             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
515             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
516             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
517             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
518             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
519             iaddr += (b1*16+b2);
520         }
521         return address(iaddr);
522     }
523 
524     function strCompare(string _a, string _b) internal pure returns (int) {
525         bytes memory a = bytes(_a);
526         bytes memory b = bytes(_b);
527         uint minLength = a.length;
528         if (b.length < minLength) minLength = b.length;
529         for (uint i = 0; i < minLength; i ++)
530             if (a[i] < b[i])
531                 return -1;
532             else if (a[i] > b[i])
533                 return 1;
534         if (a.length < b.length)
535             return -1;
536         else if (a.length > b.length)
537             return 1;
538         else
539             return 0;
540     }
541 
542     function indexOf(string _haystack, string _needle) internal pure returns (int) {
543         bytes memory h = bytes(_haystack);
544         bytes memory n = bytes(_needle);
545         if(h.length < 1 || n.length < 1 || (n.length > h.length))
546             return -1;
547         else if(h.length > (2**128 -1))
548             return -1;
549         else
550         {
551             uint subindex = 0;
552             for (uint i = 0; i < h.length; i ++)
553             {
554                 if (h[i] == n[0])
555                 {
556                     subindex = 1;
557                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
558                     {
559                         subindex++;
560                     }
561                     if(subindex == n.length)
562                         return int(i);
563                 }
564             }
565             return -1;
566         }
567     }
568 
569     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
570         bytes memory _ba = bytes(_a);
571         bytes memory _bb = bytes(_b);
572         bytes memory _bc = bytes(_c);
573         bytes memory _bd = bytes(_d);
574         bytes memory _be = bytes(_e);
575         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
576         bytes memory babcde = bytes(abcde);
577         uint k = 0;
578         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
579         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
580         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
581         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
582         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
583         return string(babcde);
584     }
585 
586     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
587         return strConcat(_a, _b, _c, _d, "");
588     }
589 
590     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
591         return strConcat(_a, _b, _c, "", "");
592     }
593 
594     function strConcat(string _a, string _b) internal pure returns (string) {
595         return strConcat(_a, _b, "", "", "");
596     }
597 
598     // parseInt
599     function parseInt(string _a) internal pure returns (uint) {
600         return parseInt(_a, 0);
601     }
602 
603     // parseInt(parseFloat*10^_b)
604     function parseInt(string _a, uint _b) internal pure returns (uint) {
605         bytes memory bresult = bytes(_a);
606         uint mint = 0;
607         bool decimals = false;
608         for (uint i=0; i<bresult.length; i++){
609             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
610                 if (decimals){
611                    if (_b == 0) break;
612                     else _b--;
613                 }
614                 mint *= 10;
615                 mint += uint(bresult[i]) - 48;
616             } else if (bresult[i] == 46) decimals = true;
617         }
618         if (_b > 0) mint *= 10**_b;
619         return mint;
620     }
621 
622     function uint2str(uint i) internal pure returns (string){
623         if (i == 0) return "0";
624         uint j = i;
625         uint len;
626         while (j != 0){
627             len++;
628             j /= 10;
629         }
630         bytes memory bstr = new bytes(len);
631         uint k = len - 1;
632         while (i != 0){
633             bstr[k--] = byte(48 + i % 10);
634             i /= 10;
635         }
636         return string(bstr);
637     }
638 
639     function stra2cbor(string[] arr) internal pure returns (bytes) {
640             uint arrlen = arr.length;
641 
642             // get correct cbor output length
643             uint outputlen = 0;
644             bytes[] memory elemArray = new bytes[](arrlen);
645             for (uint i = 0; i < arrlen; i++) {
646                 elemArray[i] = (bytes(arr[i]));
647                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
648             }
649             uint ctr = 0;
650             uint cborlen = arrlen + 0x80;
651             outputlen += byte(cborlen).length;
652             bytes memory res = new bytes(outputlen);
653 
654             while (byte(cborlen).length > ctr) {
655                 res[ctr] = byte(cborlen)[ctr];
656                 ctr++;
657             }
658             for (i = 0; i < arrlen; i++) {
659                 res[ctr] = 0x5F;
660                 ctr++;
661                 for (uint x = 0; x < elemArray[i].length; x++) {
662                     // if there's a bug with larger strings, this may be the culprit
663                     if (x % 23 == 0) {
664                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
665                         elemcborlen += 0x40;
666                         uint lctr = ctr;
667                         while (byte(elemcborlen).length > ctr - lctr) {
668                             res[ctr] = byte(elemcborlen)[ctr - lctr];
669                             ctr++;
670                         }
671                     }
672                     res[ctr] = elemArray[i][x];
673                     ctr++;
674                 }
675                 res[ctr] = 0xFF;
676                 ctr++;
677             }
678             return res;
679         }
680 
681     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
682             uint arrlen = arr.length;
683 
684             // get correct cbor output length
685             uint outputlen = 0;
686             bytes[] memory elemArray = new bytes[](arrlen);
687             for (uint i = 0; i < arrlen; i++) {
688                 elemArray[i] = (bytes(arr[i]));
689                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
690             }
691             uint ctr = 0;
692             uint cborlen = arrlen + 0x80;
693             outputlen += byte(cborlen).length;
694             bytes memory res = new bytes(outputlen);
695 
696             while (byte(cborlen).length > ctr) {
697                 res[ctr] = byte(cborlen)[ctr];
698                 ctr++;
699             }
700             for (i = 0; i < arrlen; i++) {
701                 res[ctr] = 0x5F;
702                 ctr++;
703                 for (uint x = 0; x < elemArray[i].length; x++) {
704                     // if there's a bug with larger strings, this may be the culprit
705                     if (x % 23 == 0) {
706                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
707                         elemcborlen += 0x40;
708                         uint lctr = ctr;
709                         while (byte(elemcborlen).length > ctr - lctr) {
710                             res[ctr] = byte(elemcborlen)[ctr - lctr];
711                             ctr++;
712                         }
713                     }
714                     res[ctr] = elemArray[i][x];
715                     ctr++;
716                 }
717                 res[ctr] = 0xFF;
718                 ctr++;
719             }
720             return res;
721         }
722 
723 
724     string oraclize_network_name;
725     function oraclize_setNetworkName(string _network_name) internal {
726         oraclize_network_name = _network_name;
727     }
728 
729     function oraclize_getNetworkName() internal view returns (string) {
730         return oraclize_network_name;
731     }
732 
733     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
734         require((_nbytes > 0) && (_nbytes <= 32));
735         // Convert from seconds to ledger timer ticks
736         _delay *= 10;
737         bytes memory nbytes = new bytes(1);
738         nbytes[0] = byte(_nbytes);
739         bytes memory unonce = new bytes(32);
740         bytes memory sessionKeyHash = new bytes(32);
741         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
742         assembly {
743             mstore(unonce, 0x20)
744             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
745             mstore(sessionKeyHash, 0x20)
746             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
747         }
748         bytes memory delay = new bytes(32);
749         assembly {
750             mstore(add(delay, 0x20), _delay)
751         }
752 
753         bytes memory delay_bytes8 = new bytes(8);
754         copyBytes(delay, 24, 8, delay_bytes8, 0);
755 
756         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
757         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
758 
759         bytes memory delay_bytes8_left = new bytes(8);
760 
761         assembly {
762             let x := mload(add(delay_bytes8, 0x20))
763             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
764             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
765             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
766             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
767             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
768             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
769             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
770             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
771 
772         }
773 
774         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
775         return queryId;
776     }
777 
778     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
779         oraclize_randomDS_args[queryId] = commitment;
780     }
781 
782     mapping(bytes32=>bytes32) oraclize_randomDS_args;
783     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
784 
785     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
786         bool sigok;
787         address signer;
788 
789         bytes32 sigr;
790         bytes32 sigs;
791 
792         bytes memory sigr_ = new bytes(32);
793         uint offset = 4+(uint(dersig[3]) - 0x20);
794         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
795         bytes memory sigs_ = new bytes(32);
796         offset += 32 + 2;
797         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
798 
799         assembly {
800             sigr := mload(add(sigr_, 32))
801             sigs := mload(add(sigs_, 32))
802         }
803 
804 
805         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
806         if (address(keccak256(pubkey)) == signer) return true;
807         else {
808             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
809             return (address(keccak256(pubkey)) == signer);
810         }
811     }
812 
813     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
814         bool sigok;
815 
816         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
817         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
818         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
819 
820         bytes memory appkey1_pubkey = new bytes(64);
821         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
822 
823         bytes memory tosign2 = new bytes(1+65+32);
824         tosign2[0] = byte(1); //role
825         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
826         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
827         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
828         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
829 
830         if (sigok == false) return false;
831 
832 
833         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
834         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
835 
836         bytes memory tosign3 = new bytes(1+65);
837         tosign3[0] = 0xFE;
838         copyBytes(proof, 3, 65, tosign3, 1);
839 
840         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
841         copyBytes(proof, 3+65, sig3.length, sig3, 0);
842 
843         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
844 
845         return sigok;
846     }
847 
848     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
849         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
850         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
851 
852         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
853         require(proofVerified);
854 
855         _;
856     }
857 
858     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
859         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
860         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
861 
862         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
863         if (proofVerified == false) return 2;
864 
865         return 0;
866     }
867 
868     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
869         bool match_ = true;
870 
871         require(prefix.length == n_random_bytes);
872 
873         for (uint256 i=0; i< n_random_bytes; i++) {
874             if (content[i] != prefix[i]) match_ = false;
875         }
876 
877         return match_;
878     }
879 
880     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
881 
882         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
883         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
884         bytes memory keyhash = new bytes(32);
885         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
886         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
887 
888         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
889         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
890 
891         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
892         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
893 
894         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
895         // This is to verify that the computed args match with the ones specified in the query.
896         bytes memory commitmentSlice1 = new bytes(8+1+32);
897         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
898 
899         bytes memory sessionPubkey = new bytes(64);
900         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
901         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
902 
903         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
904         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
905             delete oraclize_randomDS_args[queryId];
906         } else return false;
907 
908 
909         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
910         bytes memory tosign1 = new bytes(32+8+1+32);
911         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
912         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
913 
914         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
915         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
916             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
917         }
918 
919         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
920     }
921 
922     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
923     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
924         uint minLength = length + toOffset;
925 
926         // Buffer too small
927         require(to.length >= minLength); // Should be a better way?
928 
929         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
930         uint i = 32 + fromOffset;
931         uint j = 32 + toOffset;
932 
933         while (i < (32 + fromOffset + length)) {
934             assembly {
935                 let tmp := mload(add(from, i))
936                 mstore(add(to, j), tmp)
937             }
938             i += 32;
939             j += 32;
940         }
941 
942         return to;
943     }
944 
945     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
946     // Duplicate Solidity's ecrecover, but catching the CALL return value
947     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
948         // We do our own memory management here. Solidity uses memory offset
949         // 0x40 to store the current end of memory. We write past it (as
950         // writes are memory extensions), but don't update the offset so
951         // Solidity will reuse it. The memory used here is only needed for
952         // this context.
953 
954         // FIXME: inline assembly can't access return values
955         bool ret;
956         address addr;
957 
958         assembly {
959             let size := mload(0x40)
960             mstore(size, hash)
961             mstore(add(size, 32), v)
962             mstore(add(size, 64), r)
963             mstore(add(size, 96), s)
964 
965             // NOTE: we can reuse the request memory because we deal with
966             //       the return code
967             ret := call(3000, 1, 0, size, 128, size, 32)
968             addr := mload(size)
969         }
970 
971         return (ret, addr);
972     }
973 
974     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
975     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
976         bytes32 r;
977         bytes32 s;
978         uint8 v;
979 
980         if (sig.length != 65)
981           return (false, 0);
982 
983         // The signature format is a compact form of:
984         //   {bytes32 r}{bytes32 s}{uint8 v}
985         // Compact means, uint8 is not padded to 32 bytes.
986         assembly {
987             r := mload(add(sig, 32))
988             s := mload(add(sig, 64))
989 
990             // Here we are loading the last 32 bytes. We exploit the fact that
991             // 'mload' will pad with zeroes if we overread.
992             // There is no 'mload8' to do this, but that would be nicer.
993             v := byte(0, mload(add(sig, 96)))
994 
995             // Alternative solution:
996             // 'byte' is not working due to the Solidity parser, so lets
997             // use the second best option, 'and'
998             // v := and(mload(add(sig, 65)), 255)
999         }
1000 
1001         // albeit non-transactional signatures are not specified by the YP, one would expect it
1002         // to match the YP range of [27, 28]
1003         //
1004         // geth uses [0, 1] and some clients have followed. This might change, see:
1005         //  https://github.com/ethereum/go-ethereum/issues/2053
1006         if (v < 27)
1007           v += 27;
1008 
1009         if (v != 27 && v != 28)
1010             return (false, 0);
1011 
1012         return safer_ecrecover(hash, v, r, s);
1013     }
1014 
1015 }
1016 
1017 contract BetContract is usingOraclize{
1018   uint  maxProfit;//最高奖池
1019   uint  maxmoneypercent;
1020   uint public contractBalance;
1021   uint minBet;
1022   uint onoff;//游戏启用或关闭
1023   address private owner;
1024   uint private orderId;
1025   uint private randonce;
1026 
1027   event LogNewOraclizeQuery(string description,bytes32 queryId);
1028   event LogNewRandomNumber(string result,bytes32 queryId);
1029   event LogSendBonus(uint id,bytes32 lableId,uint playId,uint content,uint singleMoney,uint mutilple,address user,uint betTime,uint status,uint winMoney);
1030 
1031   mapping (address => bytes32[]) playerLableList;//玩家下注批次
1032   mapping (bytes32 => mapping (uint => uint[7])) betList;//批次，注单映射
1033   mapping (bytes32 => uint) lableCount;//批次，注单数
1034   mapping (bytes32 => uint) lableTime;//批次，投注时间
1035   mapping (bytes32 => uint) lableStatus;//批次，状态 0 未结算，1 已撤单，2 已结算 3 已派奖
1036   mapping (bytes32 => uint[3]) openNumberList;//批次开奖号码映射
1037   mapping (bytes32 => string) openNumberStr;//批次开奖号码映射
1038   mapping (bytes32 => address) lableUser;
1039 
1040   function BetContract() public {
1041     owner = msg.sender;
1042     orderId = 0;
1043 
1044     onoff=1;
1045     minBet=1500000000000000;//最小金额要比手续费大
1046     maxmoneypercent=80;
1047     contractBalance = this.balance;
1048     maxProfit=(this.balance * maxmoneypercent)/100;
1049     randonce = 0;
1050   }
1051 
1052   /*
1053     * uintToString
1054     */
1055    function uintToString(uint i) internal  returns (string){
1056        if (i == 0) return "0";
1057        uint j = i;
1058        uint len;
1059        while (j != 0){
1060            len++;
1061            j /= 10;
1062        }
1063        bytes memory bstr = new bytes(len);
1064        uint k = len - 1;
1065        while (i != 0){
1066            bstr[k--] = byte(48 + i % 10);
1067            i /= 10;
1068        }
1069        return string(bstr);
1070    }
1071 
1072 
1073   modifier onlyAdmin() {
1074       require(msg.sender == owner);
1075       _;
1076   }
1077 
1078   function setGameOnoff(uint _on0ff) public onlyAdmin{
1079     onoff=_on0ff;
1080   }
1081 
1082   function getPlayRate(uint playId,uint level) internal pure returns (uint){
1083       uint result = 0;
1084       if(playId == 1 || playId == 2){
1085         //大小单双，赔率放大了10倍
1086         result = 19;
1087       }else if(playId == 3){
1088         //二同号复选
1089         result = 11;
1090       }else if(playId == 4){
1091         //三同号单选
1092         result = 156;
1093       }else if(playId == 5){
1094         //三同号通选
1095         result = 26;
1096       }else if(playId == 6){
1097         //和值
1098         if(level == 4 || level == 17){
1099           result = 53;
1100         }else if(level == 5 || level == 16){
1101           result = 21;
1102         }else if(level == 6 || level == 15){
1103           result = 17;
1104         }else if(level == 7 || level == 14){
1105           result = 13;
1106         }else if(level == 8 || level == 13){
1107           result = 9;
1108         }else if(level == 9 || level == 12){
1109           result = 8;
1110         }else if(level == 10 || level == 11){
1111           result = 7;
1112         }
1113       }else if(playId == 7){
1114         //二不同号
1115         result = 6;
1116       }else if(playId == 8){
1117         //猜1个号，赔率放大了10倍
1118         if(level == 1){
1119           result = 19;//单色子
1120         }else if(level == 2){
1121           result = 28;//对子
1122         }else if(level == 3){
1123           result = 37;//豹子
1124         }
1125       }
1126       return result;
1127     }
1128 
1129     function doBet(uint[] playid,uint[] betMoney,uint[] betContent,uint mutiply) public payable returns (bytes32) {
1130       require(onoff==1);
1131       require(playid.length > 0);
1132       require(mutiply > 0);
1133       require(msg.value >= minBet);
1134 
1135       /* checkBet(playid,betMoney,betContent,mutiply,msg.value); */
1136 
1137       /* uint total = 0; */
1138       bytes32 queryId;
1139       queryId = keccak256(block.blockhash(block.number-1),now,randonce);
1140 
1141        uint[7] tmp ;
1142        uint totalspand = 0;
1143       for(uint i=0;i<playid.length;i++){
1144         orderId++;
1145         tmp[0] =orderId;
1146         tmp[1] =playid[i];
1147         tmp[2] =betContent[i];
1148         tmp[3] =betMoney[i]*mutiply;
1149         totalspand +=betMoney[i]*mutiply;
1150         tmp[4] =now;
1151         tmp[5] =0;
1152         tmp[6] =0;
1153         betList[queryId][i] =tmp;
1154       }
1155       require(msg.value >= totalspand);
1156 
1157       lableTime[queryId] = now;
1158       lableCount[queryId] = playid.length;
1159       lableUser[queryId] = msg.sender;
1160       uint[3] memory codes = [uint(0),0,0];//开奖号码
1161       openNumberList[queryId] = codes;
1162       openNumberStr[queryId] ="0,0,0";
1163       lableStatus[queryId] = 0;
1164 
1165       uint index=playerLableList[msg.sender].length++;
1166       playerLableList[msg.sender][index]=queryId;//index:id
1167       opencode(queryId);
1168       return queryId;
1169     }
1170 
1171     function checkBet(uint[] playid,uint[] betMoney,uint[] betContent,uint mutiply,uint betTotal) internal{
1172         uint totalMoney = 0;
1173       uint totalWin1 = 0;//三个开奖号码不同时的盈利
1174       uint totalWin2 = 0;//两个开奖号码相同时的盈利
1175       uint totalWin3 = 0;//三个号码相同时的盈利
1176       uint rate;
1177       uint i;
1178       for(i=0;i<playid.length;i++){
1179         if(playid[i] >=1 && playid[i]<= 8){
1180           totalMoney += betMoney[i] * mutiply;
1181         }else{
1182           throw;
1183         }
1184         if(playid[i] ==1 || playid[i] ==2){
1185           rate = getPlayRate(playid[i],0)-10;
1186           totalWin1+=betMoney[i] * mutiply *rate/10;
1187           totalWin2+=betMoney[i] * mutiply *rate/10;
1188         }else if(playid[i] ==3){
1189           rate = getPlayRate(playid[i],0)-1;
1190           totalWin2+=betMoney[i] * mutiply *rate;
1191           totalWin3+=betMoney[i] * mutiply *rate;
1192         }else if(playid[i] ==4 || playid[i] ==5){
1193           rate = getPlayRate(playid[i],0)-1;
1194           totalWin3+=betMoney[i] * mutiply *rate;
1195         }else if(playid[i] ==6){
1196           rate = getPlayRate(playid[i],betContent[i])-1;
1197           totalWin1+=betMoney[i] * mutiply *rate;
1198           totalWin2+=betMoney[i] * mutiply *rate;
1199         }else if(playid[i] ==7){
1200           rate = getPlayRate(playid[i],0)-1;
1201           totalWin1+=betMoney[i] * mutiply *rate;
1202           totalWin2+=betMoney[i] * mutiply *rate;
1203         }else if(playid[i] ==8){
1204           totalWin1+=betMoney[i] * mutiply *9/10;
1205           totalWin2+=betMoney[i] * mutiply *18/10;
1206           totalWin3+=betMoney[i] * mutiply *27/10;
1207         }
1208       }
1209       uint maxWin=totalWin1;
1210       if(totalWin2 > maxWin){
1211         maxWin=totalWin2;
1212       }
1213       if(totalWin3 > maxWin){
1214         maxWin=totalWin3;
1215       }
1216       require(betTotal >= totalMoney);
1217 
1218       require(maxWin < maxProfit);
1219     }
1220     
1221     function opencode(bytes32 queryId) private {
1222       if (lableCount[queryId] < 1) revert();
1223       uint[3] memory codes = [uint(0),0,0];//开奖号码
1224 
1225       bytes32 code0hash = keccak256(abi.encodePacked(block.blockhash(block.number-1), now,msg.sender,randonce));
1226       randonce  = randonce + uint(code0hash)%10;
1227       uint code0int = uint(code0hash) % 6 + 1;
1228       bytes32 code1hash = keccak256(abi.encodePacked(block.blockhash(block.number-1), now,msg.sender,randonce));
1229       randonce  = randonce + uint(code1hash)%10;
1230       uint code1int = uint(code1hash) % 6 + 1;
1231       bytes32 code2hash = keccak256(abi.encodePacked(block.blockhash(block.number-1), now,msg.sender,randonce));
1232       randonce  = randonce + uint(code2hash)%10;
1233       uint code2int = uint(code2hash) % 6 + 1;
1234       var code0=uintToString(code0int);
1235       var code1=uintToString(code1int);
1236       var code2=uintToString(code2int);
1237       codes[0] = code0int;
1238       codes[1] = code1int;
1239       codes[2] = code2int;
1240       openNumberList[queryId] = codes;
1241       openNumberStr[queryId] = strConcat(code0,",",code1,",",code2);
1242 
1243       //结算，派奖
1244       doCheckBounds(queryId);
1245     }
1246 
1247     function doCancel(bytes32 queryId) internal {
1248       uint sta = lableStatus[queryId];
1249       require(sta == 0);
1250       uint[3] memory codes = openNumberList[queryId];
1251       require(codes[0] == 0 || codes[1] == 0 ||codes[2] == 0);
1252 
1253       uint totalBet = 0;
1254       uint len = lableCount[queryId];
1255 
1256       address to = lableUser[queryId];
1257       for(uint aa = 0 ; aa<len; aa++){
1258         //未结算
1259         if(betList[queryId][aa][5] == 0){
1260           totalBet+=betList[queryId][aa][3];
1261         }
1262       }
1263 
1264       if(totalBet > 0){
1265         to.transfer(totalBet);
1266       }
1267       contractBalance=this.balance;
1268       maxProfit=(this.balance * maxmoneypercent)/100;
1269       lableStatus[queryId] = 1;
1270     }
1271 
1272     function doSendBounds(bytes32 queryId) public payable {
1273       uint sta = lableStatus[queryId];
1274       require(sta == 2);
1275 
1276       uint totalWin = 0;
1277       uint len = lableCount[queryId];
1278 
1279       address to = lableUser[queryId];
1280       for(uint aa = 0 ; aa<len; aa++){
1281         //中奖
1282         if(betList[queryId][aa][5] == 2){
1283           totalWin+=betList[queryId][aa][6];
1284         }
1285       }
1286 
1287       if(totalWin > 0){
1288           to.transfer(totalWin);//转账
1289       }
1290       lableStatus[queryId] = 3;
1291       contractBalance=this.balance;
1292       maxProfit=(this.balance * maxmoneypercent)/100;
1293     }
1294 
1295     //中奖判断
1296     function checkWinMoney(uint[7] storage betinfo,uint[3] codes) internal {
1297       uint rates;
1298       if(betinfo[1] ==1){
1299           //大小 豹子不中奖
1300           if(codes[0] == codes[1] && codes[1] == codes[2]){
1301             betinfo[5]=1;//未中奖
1302           }else{
1303             uint sum = codes[0]+codes[1]+codes[2];
1304             if(sum >= 4 && sum < 11){
1305               sum = 4;//小
1306             }else if(sum >= 11 && sum < 18){
1307               sum = 17;//大
1308             }else{
1309               sum = 0;
1310             }
1311             betinfo[5]=1;
1312             if(sum >0 && betinfo[2] == sum){
1313                 betinfo[5]=2;
1314                 rates = getPlayRate(betinfo[1],0);
1315                 betinfo[6]=betinfo[3]*rates/10;
1316             }
1317 
1318           }
1319       }else if(betinfo[1] == 2){
1320           //单双 豹子不中奖
1321           if(codes[0] == codes[1] && codes[1] == codes[2]){
1322             betinfo[5]=1;//未中奖
1323           }else{
1324             uint sums = codes[0]+codes[1]+codes[2];
1325             if(sums % 2 == 0){
1326               sums = 2;//双
1327             }else{
1328               sums = 3;//单
1329             }
1330             betinfo[5]=1;
1331             if(sums == betinfo[2]){
1332               betinfo[5]=2;
1333               rates = getPlayRate(betinfo[1],0);
1334               betinfo[6]=betinfo[3]*rates/10;
1335             }
1336 
1337           }
1338 
1339         }else if(betinfo[1] == 3){
1340           //二同号复选
1341           betinfo[5]=1;//不中奖
1342           if(codes[0] == codes[1] || codes[1] == codes[2] ){
1343             uint tmp = 0;
1344             if(codes[0] == codes[1] ){
1345               tmp = codes[0];
1346             }else if(codes[1] == codes[2]){
1347               tmp = codes[1];
1348             }
1349             if(tmp == betinfo[2]){
1350               betinfo[5]=2;
1351               rates = getPlayRate(betinfo[1],0);
1352               betinfo[6]=betinfo[3]*rates;
1353             }
1354 
1355           }
1356         }else if(betinfo[1] == 4){
1357           //三同号单选
1358           betinfo[5]=1;//不中奖
1359           if(codes[0] == codes[1] && codes[1] == codes[2] ){
1360             if(codes[0] == betinfo[2]){
1361               betinfo[5]=2;
1362               rates = getPlayRate(betinfo[1],0);
1363               betinfo[6]=betinfo[3]*rates;
1364             }
1365           }
1366         }else if(betinfo[1] == 5){
1367           //三同号通选
1368           betinfo[5]=1;//不中奖
1369           if(codes[0] == codes[1] && codes[1] == codes[2] ){
1370               betinfo[5]=2;
1371               rates = getPlayRate(betinfo[1],0);
1372               betinfo[6]=betinfo[3]*rates;
1373           }
1374         }else if(betinfo[1] == 6){
1375           //和值 豹子不中奖
1376           if(codes[0] == codes[1] && codes[1] == codes[2]){
1377             betinfo[5]=1;//不中奖
1378           }else{
1379             betinfo[5]=1;//不中奖
1380             uint sum6 = codes[0]+codes[1]+codes[2];
1381             if(sum6 == betinfo[2]){
1382               betinfo[5]=2;
1383               rates = getPlayRate(betinfo[1],sum6);
1384               betinfo[6]=betinfo[3]*rates;
1385             }
1386           }
1387         }else if(betinfo[1] == 7){
1388           //二不同号 豹子不中奖
1389           if(codes[0] == codes[1] && codes[1] == codes[2]){
1390             betinfo[5]=1;//不中奖
1391           }else{
1392             uint[2] memory haoma = getErbutongHao(betinfo[2]);
1393             bool atmp=false;
1394             bool btmp=false;
1395             for(uint ai=0;ai<codes.length;ai++){
1396               if(codes[ai] == haoma[0]){
1397                 atmp = true;
1398                 continue;
1399               }
1400               if(codes[ai] == haoma[1]){
1401                 btmp = true;
1402                 continue;
1403               }
1404             }
1405             betinfo[5]=1;
1406             if(atmp && btmp){
1407               betinfo[5]=2;
1408               rates = getPlayRate(betinfo[1],0);
1409               betinfo[6]=betinfo[3]*rates;
1410             }
1411           }
1412         }else if(betinfo[1] == 8){
1413           //猜1个号，赔率放大了10倍
1414           uint tmpp = 0;
1415           betinfo[5]=1;//不中奖
1416           if(codes[0] == betinfo[2]){
1417             tmpp++;
1418           }
1419           if(codes[1] == betinfo[2]){
1420             tmpp++;
1421           }
1422           if(codes[2] == betinfo[2]){
1423             tmpp++;
1424           }
1425           if(tmpp > 0){
1426             betinfo[5]=2;
1427             rates = getPlayRate(betinfo[1],tmpp);
1428             betinfo[6]=betinfo[3]*rates/10;
1429           }
1430         }
1431 
1432     }
1433 
1434     function getErbutongHao(uint sss) internal view returns(uint[2]){
1435       uint[2] memory result ;
1436       if(sss == 12){
1437         result = [uint(1),2];
1438       }else if(sss == 13){
1439          result = [uint(1),3];
1440       }else if(sss == 14){
1441          result = [uint(1),4];
1442       }else if(sss == 15){
1443          result = [uint(1),5];
1444       }else if(sss == 16){
1445          result = [uint(1),6];
1446       }else if(sss == 23){
1447          result = [uint(2),3];
1448       }else if(sss == 24){
1449          result = [uint(2),4];
1450       }else if(sss == 25){
1451          result = [uint(2),5];
1452       }else if(sss == 26){
1453          result = [uint(2),6];
1454       }else if(sss == 34){
1455          result = [uint(3),4];
1456       }else if(sss == 35){
1457          result = [uint(3),5];
1458       }else if(sss == 36){
1459          result = [uint(3),6];
1460       }else if(sss == 45){
1461          result = [uint(4),5];
1462       }else if(sss == 46){
1463          result = [uint(4),6];
1464       }else if(sss == 56){
1465          result = [uint(5),6];
1466       }
1467       return (result);
1468     }
1469 
1470     function getLastBet() public view returns(string,uint[7][]){
1471       uint len=playerLableList[msg.sender].length;
1472       require(len>0);
1473 
1474       uint i=len-1;
1475       bytes32 lastLable = playerLableList[msg.sender][i];
1476       uint max = lableCount[lastLable];
1477       if(max > 50){
1478           max = 50;
1479       }
1480       uint[7][] memory result = new uint[7][](max) ;
1481       var opennum = "";
1482       for(uint a=0;a<max;a++){
1483          var ttmp =openNumberStr[lastLable];
1484          if(a==0){
1485            opennum =ttmp;
1486          }else{
1487            opennum = strConcat(opennum,";",ttmp);
1488          }
1489 
1490          result[a] = betList[lastLable][a];
1491          if(lableStatus[lastLable] == 1){
1492            result[a][5]=3;
1493          }
1494 
1495       }
1496 
1497       return (opennum,result);
1498     }
1499 
1500     function getLableRecords(bytes32 lable) public view returns(string,uint[7][]){
1501       uint max = lableCount[lable];
1502       if(max > 50){
1503           max = 50;
1504       }
1505       uint[7][] memory result = new uint[7][](max) ;
1506       var opennum="";
1507 
1508       for(uint a=0;a<max;a++){
1509          result[a] = betList[lable][a];
1510          if(lableStatus[lable] == 1){
1511            result[a][5]=3;
1512          }
1513          var ttmp =openNumberStr[lable];
1514          if(a==0){
1515            opennum =ttmp;
1516          }else{
1517            opennum = strConcat(opennum,";",ttmp);
1518          }
1519       }
1520 
1521       return (opennum,result);
1522     }
1523 
1524     function getAllRecords() public view returns(string,uint[7][]){
1525         uint len=playerLableList[msg.sender].length;
1526         require(len>0);
1527 
1528         uint max;
1529         bytes32 lastLable ;
1530         uint ss;
1531 
1532         for(uint i1=0;i1<len;i1++){
1533             ss = len-i1-1;
1534             lastLable = playerLableList[msg.sender][ss];
1535             max += lableCount[lastLable];
1536             if(100 < max){
1537               max = 100;
1538               break;
1539             }
1540         }
1541 
1542         uint[7][] memory result = new uint[7][](max) ;
1543         bytes32[] memory resultlable = new bytes32[](max) ;
1544         var opennum="";
1545 
1546         bool flag=false;
1547         uint betnums;
1548         uint j=0;
1549 
1550         for(uint ii=0;ii<len;ii++){
1551             ss = len-ii-1;
1552             lastLable = playerLableList[msg.sender][ss];
1553             betnums = lableCount[lastLable];
1554             for(uint k= 0; k<betnums; k++){
1555               if(j<max){
1556                   resultlable[j] = lastLable;
1557               	 var ttmp =openNumberStr[lastLable];
1558                  if(j==0){
1559                    opennum =ttmp;
1560                  }else{
1561                    opennum = strConcat(opennum,";",ttmp);
1562                  }
1563                   result[j] = betList[lastLable][k];
1564                   if(lableStatus[lastLable] == 1){
1565                     result[j][5]=3;
1566                   }else if(lableStatus[lastLable] == 2){
1567                     if(result[j][5]==2){
1568                       result[j][5]=4;
1569                     }
1570                   }else if(lableStatus[lastLable] == 3){
1571                     if(result[j][5]==2){
1572                       result[j][5]=5;
1573                     }
1574                   }
1575                   j++;
1576               }else{
1577                 flag = true;
1578                 break;
1579               }
1580             }
1581             if(flag){
1582                 break;
1583             }
1584         }
1585         return (opennum,result);
1586     }
1587 
1588   function senttest() public payable onlyAdmin{
1589       contractBalance=this.balance;
1590       maxProfit=(this.balance*maxmoneypercent)/100;
1591   }
1592 
1593   function setRandomSeed(uint _randomSeed) public payable onlyAdmin{
1594       randonce = _randomSeed;
1595   }
1596 
1597   function getRandomSeed() public view onlyAdmin returns(uint _randonce) {
1598       _randonce = randonce;
1599   }
1600 
1601   function withdraw(uint _amount , address desaccount) public onlyAdmin{
1602       desaccount.transfer(_amount);
1603       contractBalance=this.balance;
1604       maxProfit=(this.balance * maxmoneypercent)/100;
1605   }
1606 
1607   function getDatas() public view returns(
1608     uint _maxProfit,
1609     uint _minBet,
1610     uint _contractbalance,
1611     uint _onoff,
1612     address _owner
1613     //uint _oraclizeFee
1614     ){
1615         _maxProfit=maxProfit;
1616         _minBet=minBet;
1617         _contractbalance=contractBalance;
1618         _onoff=onoff;
1619         _owner=owner;
1620     }
1621 
1622     function getLableList() public view returns(string,bytes32[],uint[],uint[],uint){
1623       uint len=playerLableList[msg.sender].length;
1624       require(len>0);
1625 
1626       uint max=50;
1627       if(len < 50){
1628           max = len;
1629       }
1630 
1631       bytes32[] memory lablelist = new bytes32[](max) ;
1632       uint[] memory labletime = new uint[](max) ;
1633       uint[] memory lablestatus = new uint[](max) ;
1634       var opennum="";
1635 
1636       bytes32 lastLable ;
1637       for(uint i=0;i<max;i++){
1638           lastLable = playerLableList[msg.sender][max-i-1];
1639           lablelist[i]=lastLable;
1640           labletime[i]=lableTime[lastLable];
1641           lablestatus[i]=lableStatus[lastLable];
1642           var ttmp =openNumberStr[lastLable];
1643          if(i==0){
1644            opennum =ttmp;
1645          }else{
1646            opennum = strConcat(opennum,";",ttmp);
1647          }
1648       }
1649 
1650       return (opennum,lablelist,labletime,lablestatus,now);
1651     }
1652 
1653     function doCheckBounds(bytes32 queryId) internal{
1654         uint sta = lableStatus[queryId];
1655         require(sta == 0 || sta == 2);
1656         uint[3] memory codes = openNumberList[queryId];
1657         require(codes[0] > 0);
1658         //结算
1659         uint len = lableCount[queryId];
1660 
1661         uint totalWin;
1662         address to = lableUser[queryId];
1663         for(uint aa = 0 ; aa<len; aa++){
1664           //未结算
1665           if(sta == 0){
1666            if(betList[queryId][aa][5] == 0){
1667              checkWinMoney(betList[queryId][aa],codes);
1668              totalWin+=betList[queryId][aa][6];
1669            }
1670           }else if(sta == 2){
1671               totalWin+=betList[queryId][aa][6];
1672           }
1673         }
1674 
1675         lableStatus[queryId] = 2;
1676         //派奖
1677         if(totalWin > 0){
1678           if(totalWin < this.balance){
1679             to.transfer(totalWin);//转账
1680             lableStatus[queryId] = 3;
1681           }else{
1682               LogNewOraclizeQuery("sent bouns fail.",queryId);
1683           }
1684         }else{
1685           lableStatus[queryId] = 3;
1686         }
1687         contractBalance=this.balance;
1688         maxProfit=(this.balance * maxmoneypercent)/100;
1689     }
1690 
1691     function getOpenNum(bytes32 queryId) public view returns(string){
1692         return openNumberStr[queryId];
1693     }
1694 
1695     function doCheckSendBounds() public payable{
1696         uint len=playerLableList[msg.sender].length;
1697 
1698       uint max=50;
1699       if(len < 50){
1700           max = len;
1701       }
1702 
1703       uint sta;
1704       bytes32 lastLable ;
1705       for(uint i=0;i<max;i++){
1706           lastLable = playerLableList[msg.sender][max-i-1];
1707           sta = lableStatus[lastLable];
1708           if(sta == 0 || sta==2){
1709             doCheckBounds(lastLable);
1710           }
1711       }
1712     }
1713 
1714     function doCancelAll() public payable{
1715         uint len=playerLableList[msg.sender].length;
1716 
1717       uint max=50;
1718       if(len < 50){
1719           max = len;
1720       }
1721 
1722       uint sta;
1723       uint bettime;
1724       bytes32 lastLable ;
1725       for(uint i=0;i<max;i++){
1726           lastLable = playerLableList[msg.sender][max-i-1];
1727           sta = lableStatus[lastLable];
1728           bettime = lableTime[lastLable];
1729           if(sta == 0 && (now - bettime)>600){
1730             doCancel(lastLable);
1731           }
1732       }
1733     }
1734 }