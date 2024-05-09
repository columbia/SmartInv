1 pragma solidity ^0.4.18;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
11     function getPrice(string _datasource) public returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
13     function setProofType(byte _proofType) external;
14     function setCustomGasPrice(uint _gasPrice) external;
15     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
16 }
17 
18 contract OraclizeAddrResolverI {
19     function getAddress() public returns (address _addr);
20 }
21 
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
98     
99    function __callback(bytes32 myid, string result, bytes proof) public {
100        
101    }
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
735         bytes memory nbytes = new bytes(1);
736         nbytes[0] = byte(_nbytes);
737         bytes memory unonce = new bytes(32);
738         bytes memory sessionKeyHash = new bytes(32);
739         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
740         assembly {
741             mstore(unonce, 0x20)
742             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
743             mstore(sessionKeyHash, 0x20)
744             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
745         }
746         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
747         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
748         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(bytes8(_delay), args[1], sha256(args[0]), args[2])));
749         return queryId;
750     }
751 
752     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
753         oraclize_randomDS_args[queryId] = commitment;
754     }
755 
756     mapping(bytes32=>bytes32) oraclize_randomDS_args;
757     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
758 
759     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
760         bool sigok;
761         address signer;
762 
763         bytes32 sigr;
764         bytes32 sigs;
765 
766         bytes memory sigr_ = new bytes(32);
767         uint offset = 4+(uint(dersig[3]) - 0x20);
768         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
769         bytes memory sigs_ = new bytes(32);
770         offset += 32 + 2;
771         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
772 
773         assembly {
774             sigr := mload(add(sigr_, 32))
775             sigs := mload(add(sigs_, 32))
776         }
777 
778 
779         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
780         if (address(keccak256(pubkey)) == signer) return true;
781         else {
782             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
783             return (address(keccak256(pubkey)) == signer);
784         }
785     }
786 
787     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
788         bool sigok;
789 
790         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
791         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
792         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
793 
794         bytes memory appkey1_pubkey = new bytes(64);
795         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
796 
797         bytes memory tosign2 = new bytes(1+65+32);
798         tosign2[0] = byte(1); //role
799         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
800         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
801         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
802         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
803 
804         if (sigok == false) return false;
805 
806 
807         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
808         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
809 
810         bytes memory tosign3 = new bytes(1+65);
811         tosign3[0] = 0xFE;
812         copyBytes(proof, 3, 65, tosign3, 1);
813 
814         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
815         copyBytes(proof, 3+65, sig3.length, sig3, 0);
816 
817         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
818 
819         return sigok;
820     }
821 
822     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
823         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
824         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
825 
826         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
827         require(proofVerified);
828 
829         _;
830     }
831 
832     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
833         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
834         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
835 
836         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
837         if (proofVerified == false) return 2;
838 
839         return 0;
840     }
841 
842     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
843         bool match_ = true;
844         
845 
846         for (uint256 i=0; i< n_random_bytes; i++) {
847             if (content[i] != prefix[i]) match_ = false;
848         }
849 
850         return match_;
851     }
852 
853     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
854 
855         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
856         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
857         bytes memory keyhash = new bytes(32);
858         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
859         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
860 
861         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
862         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
863 
864         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
865         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
866 
867         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
868         // This is to verify that the computed args match with the ones specified in the query.
869         bytes memory commitmentSlice1 = new bytes(8+1+32);
870         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
871 
872         bytes memory sessionPubkey = new bytes(64);
873         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
874         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
875 
876         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
877         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
878             delete oraclize_randomDS_args[queryId];
879         } else return false;
880 
881 
882         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
883         bytes memory tosign1 = new bytes(32+8+1+32);
884         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
885         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
886 
887         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
888         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
889             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
890         }
891 
892         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
893     }
894 
895     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
896     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
897         uint minLength = length + toOffset;
898 
899         // Buffer too small
900         require(to.length >= minLength); // Should be a better way?
901 
902         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
903         uint i = 32 + fromOffset;
904         uint j = 32 + toOffset;
905 
906         while (i < (32 + fromOffset + length)) {
907             assembly {
908                 let tmp := mload(add(from, i))
909                 mstore(add(to, j), tmp)
910             }
911             i += 32;
912             j += 32;
913         }
914 
915         return to;
916     }
917 
918     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
919     // Duplicate Solidity's ecrecover, but catching the CALL return value
920     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
921         // We do our own memory management here. Solidity uses memory offset
922         // 0x40 to store the current end of memory. We write past it (as
923         // writes are memory extensions), but don't update the offset so
924         // Solidity will reuse it. The memory used here is only needed for
925         // this context.
926 
927         // FIXME: inline assembly can't access return values
928         bool ret;
929         address addr;
930 
931         assembly {
932             let size := mload(0x40)
933             mstore(size, hash)
934             mstore(add(size, 32), v)
935             mstore(add(size, 64), r)
936             mstore(add(size, 96), s)
937 
938             // NOTE: we can reuse the request memory because we deal with
939             //       the return code
940             ret := call(3000, 1, 0, size, 128, size, 32)
941             addr := mload(size)
942         }
943 
944         return (ret, addr);
945     }
946 
947     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
948     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
949         bytes32 r;
950         bytes32 s;
951         uint8 v;
952 
953         if (sig.length != 65)
954           return (false, 0);
955 
956         // The signature format is a compact form of:
957         //   {bytes32 r}{bytes32 s}{uint8 v}
958         // Compact means, uint8 is not padded to 32 bytes.
959         assembly {
960             r := mload(add(sig, 32))
961             s := mload(add(sig, 64))
962 
963             // Here we are loading the last 32 bytes. We exploit the fact that
964             // 'mload' will pad with zeroes if we overread.
965             // There is no 'mload8' to do this, but that would be nicer.
966             v := byte(0, mload(add(sig, 96)))
967 
968             // Alternative solution:
969             // 'byte' is not working due to the Solidity parser, so lets
970             // use the second best option, 'and'
971             // v := and(mload(add(sig, 65)), 255)
972         }
973 
974         // albeit non-transactional signatures are not specified by the YP, one would expect it
975         // to match the YP range of [27, 28]
976         //
977         // geth uses [0, 1] and some clients have followed. This might change, see:
978         //  https://github.com/ethereum/go-ethereum/issues/2053
979         if (v < 27)
980           v += 27;
981 
982         if (v != 27 && v != 28)
983             return (false, 0);
984 
985         return safer_ecrecover(hash, v, r, s);
986     }
987 
988 }
989 
990 contract Mortal {
991     /* Define variable owner of the type address */
992     address owner;
993 
994     /* This function is executed at initialization and sets the owner of the contract */
995     constructor() public {
996         owner = msg.sender;
997     }
998 
999     /* Function to recover the funds on the contract */
1000     function kill() public {
1001         if (msg.sender == owner) {
1002             selfdestruct(owner);
1003         }
1004     }
1005 }
1006 
1007 contract BucketContract is Mortal {
1008 	mapping (address => uint) public betAmount;
1009 	mapping (address => bool) public hasBet;
1010 	address[] public betters;
1011 	uint[] public amountWon;
1012 	uint[] public amountBid;
1013 	address public owner;
1014 	uint256 public totalBid;
1015 	bool public payoutComplete;
1016 	bool public isWinner;
1017 	uint256 public gameId;
1018 	uint256 public referralAmount;
1019 	uint256 public settlementType;
1020 	uint256 public processed;/* no of payouts processed */
1021 	uint256 public remaining;/* no of payouts remaining */
1022 	uint256 public totalBalance;
1023 
1024 	GameContract public gameContractObject;
1025 
1026 	event StateChanged(bool status, string message);
1027 	event SendReward(address winner, uint amount);
1028 
1029 	modifier onlyGameContractOrOwner {
1030 		require (msg.sender == address(gameContractObject) || msg.sender == owner);
1031 		_;
1032 	}
1033 
1034 	modifier onlyGameContract {
1035 		require (msg.sender == address(gameContractObject));
1036 		_;
1037 	}
1038 
1039   modifier onlyOwner {
1040 	  require(msg.sender == owner);
1041 	  _;
1042   }
1043 
1044   constructor(address gcAddress/*, uint256 _gameId*/) public {
1045 		owner = msg.sender;
1046 		// gameId = _gameId;
1047 		gameContractObject = GameContract(gcAddress);
1048 		emit StateChanged(true, "bucket contract deployed");
1049 	}
1050 
1051 	function getBettersArrayLength() public view returns(uint256) {
1052 		return betters.length;
1053 	}
1054 
1055 	function getBetter() public view returns(address[]) {
1056 		return betters;
1057 	} 
1058 
1059 	function getWinningAmount() public view returns(uint[]) {
1060 		return amountWon;
1061 	}
1062 
1063 	function getBidAmount() public view returns(uint[]) {
1064 		return amountBid;
1065 	}
1066 
1067 	function setGameId(uint256 _gameId) public onlyGameContract {
1068 		assert(gameId == 0);
1069 		gameId = _gameId;
1070 	}
1071 
1072 	function bet() public payable /*gameRunning*/ {
1073 		require (msg.value >= gameContractObject.getPrice(), "Too small bet");
1074 		assert(gameContractObject.canBet());
1075 		if (hasBet[msg.sender] == false) {
1076 			betters.push(msg.sender);
1077 			hasBet[msg.sender] = true;
1078 		}
1079 		betAmount[msg.sender] += msg.value;
1080 		totalBid += msg.value;
1081 		emit StateChanged(true,"Bet submitted");
1082 	}
1083 
1084 	function transferToOtherBucketContract(address _bucketContract) public onlyGameContractOrOwner {
1085 		_bucketContract.transfer(address(this).balance);
1086 	}
1087 
1088 	function () public payable {
1089 		emit StateChanged(true, "Ether Received");
1090 	}
1091 
1092 	/* setWinner function - set the winning contract */
1093 	function setWinner(uint256 _gameId) public onlyGameContractOrOwner {
1094 		require(_gameId == gameContractObject.gameId());
1095 		assert(gameContractObject.state() == GameContract.GameState.RandomReceived);
1096 		assert(!isWinner);
1097 		isWinner = true;
1098 		address houseAddressOne = gameContractObject.getHouseAddressOne();
1099 		address houseAddressTwo = gameContractObject.getHouseAddressTwo();
1100 		address referralAddress = gameContractObject.getReferralAddress();
1101 		if (totalBid == 0) {
1102 			houseAddressOne.transfer((address(this).balance * 70)/100);
1103 			houseAddressTwo.transfer(address(this).balance);
1104       settlementType = 0;
1105 		} else if (totalBid == address(this).balance) {
1106 		    settlementType = 1;
1107 		} else {
1108 			totalBalance = address(this).balance - totalBid;
1109 			uint256 houseAddressShare = gameContractObject.getHouseAddressShare();
1110 			houseAddressOne.transfer((totalBalance * houseAddressShare * 70) / 10000);/* 70 percent of house share goes to bucket one */
1111 			houseAddressTwo.transfer((totalBalance * houseAddressShare * 30) / 10000);/* 30 percent of house share goes to bucket one */
1112 			referralAmount = (totalBalance * gameContractObject.getReferralAddressShare())/100;	
1113 			referralAddress.transfer(referralAmount);
1114 			totalBalance = address(this).balance;
1115 			settlementType = 2;
1116 		}
1117 		processed = 0;
1118 		remaining = betters.length;
1119 	}
1120 
1121 	function payout() public onlyGameContract {
1122 		assert(!payoutComplete);
1123 		assert(isWinner);
1124 		uint256 batchsize = gameContractObject.getBatchSize();
1125 		uint256 i;
1126 		if (betters.length - processed <= batchsize) {
1127 			batchsize = remaining;
1128 		}
1129 		uint256 processLimit = processed + batchsize;
1130 		if (settlementType == 0) {
1131 		    gameContractObject.finishGame();
1132 		    return;
1133 		}
1134 		else if (settlementType == 1) {
1135 			for (i = processed; i < processLimit && i < betters.length; i++) {
1136 				address better = betters[i];
1137 				uint amount = betAmount[better];
1138 				better.transfer(amount);
1139 				emit SendReward(better, amount);
1140 				amountWon.push(amount);
1141 			}
1142 		
1143 		} else if (settlementType == 2) {
1144 			for (i = processed; i < processLimit && i < betters.length; i++) {
1145 				address better2 = betters[i];
1146 				uint amountToTransfer = (betAmount[better2]*totalBalance)/totalBid;
1147 				better2.transfer(amountToTransfer); 
1148 				emit SendReward(better2, amountToTransfer);
1149 				amountWon.push(amountToTransfer - betAmount[better2]);
1150 				amountBid.push(betAmount[better2]);
1151 			}
1152 		}
1153 		processed = i;	
1154 		remaining = betters.length - processed;
1155 		if (processed > betters.length - 1) {
1156 			payoutComplete = true;
1157 			gameContractObject.getHouseAddressOne().transfer(address(this).balance);
1158 			gameContractObject.finishGame();
1159 		}
1160 	}
1161 	
1162 	function resetBucket() public onlyGameContract {
1163 	    assert(gameContractObject.state() == GameContract.GameState.Finishing);
1164 	    uint256 i;
1165 	    for (i = 0; i < betters.length; i++) {
1166 	        delete betAmount[betters[i]];
1167 	        delete hasBet[betters[i]];
1168 	    }
1169 	    delete betters;
1170 	    delete amountWon;
1171 	    delete amountBid;
1172 	    totalBid = 0;
1173 	    payoutComplete = false;
1174         isWinner = false;
1175 	    gameId = 0;
1176 			referralAmount = 0;
1177 	    settlementType = 0;
1178 	    processed = 0;/* no of payouts processed */
1179 			remaining = 0;/* no of payouts remaining */ 
1180 	    totalBalance = 0;
1181 	}
1182 	
1183 	function drain() public onlyGameContractOrOwner {
1184 		assert(gameContractObject.state() == GameContract.GameState.Deployed || gameContractObject.state() == GameContract.GameState.Finished);
1185 		gameContractObject.getHouseAddressOne().transfer((address(this).balance * 7) / 10);
1186 		gameContractObject.getHouseAddressTwo().transfer(address(this).balance);
1187 		emit StateChanged(true, "Drain Successful");
1188 	}
1189 
1190 }
1191 
1192 contract GameContract is usingOraclize, Mortal {
1193 	enum GameState {
1194 		Deployed,
1195 		Started,
1196 		RandomRequesting,
1197 		RandomReceived,
1198 		Settled,
1199 		Finishing,
1200 		Finished
1201 	}
1202 
1203 	address public owner;
1204 	address public otherSettingOwner;
1205 	uint256 public price = 1e16;
1206 	uint256 public gameId;
1207 	uint public startTime = 0;
1208 	address public houseAddressOne;
1209 	address public houseAddressTwo;	
1210 	address public referralAddress;
1211 	address public recentWinnerContract;
1212 	uint256 public shareOfHouseAddress = 10;
1213 	uint256 public shareOfReferralAddress = 20;
1214 	uint256 public batchSize = 50;
1215 	uint256 public callbackGas = 100000; /* The gas amount required to call oraclize function */
1216   
1217     GameContract.GameState public state = GameContract.GameState.Deployed;
1218 
1219 	mapping (uint256 => bool) public isGameSettled;
1220 	mapping (uint256 => address) public winningContract;
1221 	mapping (uint256 => uint256) public typeOfWinnerContract;
1222 	mapping (uint256 => uint256) public randomValue;
1223 	mapping (bytes32 => uint256) public oraclizeQueryData;
1224 	mapping (uint256 => bool) public oraclizeValueReceived;
1225 	mapping (uint256 => bool) public settlement;
1226  	 
1227 	BucketContract public bucketOneContractObject;
1228 	BucketContract public bucketTwoContractObject;
1229 
1230 	event StateChanged(bool state, string status);
1231 	event CallbackEvent(uint256 number);
1232 
1233 	modifier onlyOwner {
1234 		require(msg.sender == owner);
1235 		_;
1236 	}
1237 
1238 	modifier onlyOtherSettingOwner {
1239 		require(msg.sender == otherSettingOwner);
1240 		_;
1241 	}
1242 	
1243 	modifier onlyContractOrOwner {
1244 		require (msg.sender == address(this) || msg.sender == owner);
1245 		_;
1246 	}
1247 
1248 	constructor( address _houseAddressOne, address _houseAddressTwo, address _referralAddress, address _otherSettingOwner) public {
1249       require(_houseAddressOne != address(0) && _houseAddressTwo != address(0) && _referralAddress != address(0) && _otherSettingOwner != address(0));
1250       owner = msg.sender;
1251 	  houseAddressOne = _houseAddressOne;
1252       houseAddressTwo = _houseAddressTwo;
1253       referralAddress = _referralAddress;
1254       otherSettingOwner = _otherSettingOwner;
1255       bucketOneContractObject = new BucketContract(address(this));
1256       bucketTwoContractObject = new BucketContract(address(this));
1257       emit StateChanged(true, "Contract deployed");
1258 	}
1259 
1260 		function kill() public onlyOwner {
1261 			// kill buckets first
1262 			if (address(bucketOneContractObject) != 0) {
1263 				bucketOneContractObject.kill();
1264 			}
1265 			if (address(bucketTwoContractObject) != 0) {
1266 				bucketTwoContractObject.kill();
1267 			}
1268 			super.kill();
1269 		}
1270 
1271 	/*House Share will be value between 1-100*/
1272 	function setHouseAddressShare (uint _share) public onlyOtherSettingOwner {
1273 		require(_share >= 1 && _share <= 100);
1274 		require(_share + shareOfReferralAddress <= 100);
1275 		shareOfHouseAddress = _share;
1276 	}
1277 
1278 	function setReferralAddressShare (uint _share) public onlyOtherSettingOwner {
1279 		require(_share >= 1 && _share <= 100);
1280 		require(_share + shareOfHouseAddress <= 100);		
1281 		shareOfReferralAddress = _share;
1282 	}
1283 
1284 	function getHouseAddressShare() public view returns(uint) {
1285 		return shareOfHouseAddress;
1286 	}
1287 
1288 	function getReferralAddressShare() public view returns(uint) {
1289 		return shareOfReferralAddress;
1290 	}
1291 
1292 	function setPrice (uint256 _price) public onlyOtherSettingOwner {
1293 		require(_price != 0);
1294 		price = _price;
1295 	}
1296 
1297 	function setHouseAddressOne(address _houseAddress) public onlyOtherSettingOwner {
1298 		require(_houseAddress != address(0));
1299 		houseAddressOne = _houseAddress;
1300 	}
1301 
1302 	function setHouseAddressTwo(address _houseAddress) public onlyOtherSettingOwner {
1303 		require(_houseAddress != address(0));
1304 		houseAddressTwo = _houseAddress;
1305 	}
1306 
1307 	function setReferralAddress(address _referralAddress) public onlyOtherSettingOwner {
1308 		require(_referralAddress != address(0));
1309 		referralAddress = _referralAddress;
1310 	}
1311 
1312 	function setCallbackGas(uint256 _value) public onlyOtherSettingOwner {
1313 		require(_value > 0);
1314 		callbackGas = _value;
1315 	}
1316 
1317 	function setBatchSize(uint256 _size) public onlyOtherSettingOwner {
1318 		require(_size != 0);
1319 		batchSize = _size;
1320 	}
1321 
1322 	function setOwner(address _owner) public onlyOwner {
1323 		require(_owner != address(0));
1324 		owner = _owner;
1325 	}
1326 
1327 	function setOtherSettingOwner(address _otherSettingOwner) public onlyOtherSettingOwner {
1328 		require(_otherSettingOwner != address(0));
1329 		otherSettingOwner = _otherSettingOwner;
1330 	}
1331 
1332 	function getPrice () public view returns (uint256 _price) {
1333 		return price;
1334 	}
1335 
1336 	function getGameId() public view returns (uint256 _gameId) {
1337 		return gameId;
1338 	}
1339 	
1340 	function getHouseAddressOne() public view returns (address _houseAddress) {
1341 		return houseAddressOne;
1342 	}
1343 
1344 	function getHouseAddressTwo() public view returns (address _houseAddress) {
1345 		return houseAddressTwo;
1346 	}
1347 
1348 	function getReferralAddress() public view returns(address _referralAddress) {
1349 		return referralAddress;
1350 	}
1351 
1352 	function getWinnerContractAddress(uint256 _gameId) public view returns(address) {
1353 		return winningContract[_gameId];
1354 	}
1355 
1356 	function getWinnerType(uint256 _gameId) public view returns(uint256) {
1357 		return typeOfWinnerContract[_gameId];
1358 	}
1359 
1360 	function getBatchSize() public view returns(uint256) {
1361 		return batchSize;
1362 	}
1363 
1364     function beginGame (uint256 _gameId) public payable onlyOwner {
1365         require(_gameId != 0);
1366         require(isGameSettled[_gameId] != true);
1367         assert(state == GameContract.GameState.Deployed || state == GameContract.GameState.Finished);
1368         gameId = _gameId;
1369             bucketOneContractObject.setGameId(_gameId);
1370             bucketTwoContractObject.setGameId(_gameId);
1371         startTime = block.timestamp; // solium-disable-line
1372         state = GameContract.GameState.Started;
1373         emit StateChanged(true, "game started");
1374     }
1375 
1376 	function () public payable {
1377 		emit StateChanged(true, "Ether Received");
1378 	}
1379 
1380 	function finalize() public onlyOwner {
1381 		require(oraclizeValueReceived[gameId] == false);
1382 		bytes32 queryId = oraclize_newRandomDSQuery(0, 7, callbackGas);
1383 		oraclizeQueryData[queryId] = gameId;
1384 		state = GameContract.GameState.RandomRequesting;
1385 	}
1386 
1387 	function __callback(bytes32 _queryId, string _result) public {
1388 		require(msg.sender == oraclize_cbAddress());
1389 		assert(oraclizeValueReceived[oraclizeQueryData[_queryId]] == false);
1390 		uint256 maxRange = 2**(8*7);
1391 		uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % maxRange;
1392 		randomValue[oraclizeQueryData[_queryId]] = randomNumber;
1393 		oraclizeValueReceived[oraclizeQueryData[_queryId]] = true;
1394 		state = GameContract.GameState.RandomReceived;
1395 		emit CallbackEvent(randomNumber);
1396 	}
1397 
1398 	function startSettlement() public onlyOwner {
1399 		require(state == GameContract.GameState.RandomReceived);
1400 		assert(oraclizeValueReceived[gameId]);
1401 		assert(settlement[gameId] == false);
1402 		uint256 randomNumber = randomValue[gameId];
1403 		if (randomNumber % 2 == 0) {
1404 			bucketTwoContractObject.transferToOtherBucketContract(address(bucketOneContractObject));
1405 			recentWinnerContract = address(bucketOneContractObject);
1406 			winningContract[gameId] = address(bucketOneContractObject);
1407 			bucketOneContractObject.setWinner(gameId);
1408 			settlement[gameId] = true;
1409 			state = GameContract.GameState.Settled;
1410 		} else {
1411 			bucketOneContractObject.transferToOtherBucketContract(address(bucketTwoContractObject));
1412 			recentWinnerContract = address(bucketTwoContractObject);
1413 			winningContract[gameId] = address(bucketTwoContractObject);
1414 			bucketTwoContractObject.setWinner(gameId);
1415 			settlement[gameId] = true;
1416 			state = GameContract.GameState.Settled;
1417 		}
1418 	}
1419 
1420 	function payout() public onlyOwner {
1421 		require(state == GameContract.GameState.Settled);
1422 		BucketContract(recentWinnerContract).payout();
1423 	}
1424 
1425 	function canBet() public view returns (bool) {
1426       return state == GameContract.GameState.Started;
1427 	}
1428 
1429 	function finishGame() public {
1430 		require(msg.sender == winningContract[gameId] || msg.sender == recentWinnerContract);
1431 		isGameSettled[gameId] = true;
1432 		state = GameContract.GameState.Finishing;
1433 		emit StateChanged(true, "game finished");
1434 	}
1435 
1436 	function reset() public onlyOwner {
1437 		require(state == GameContract.GameState.Finishing);
1438 		bucketOneContractObject.resetBucket();
1439 		bucketTwoContractObject.resetBucket();
1440 		state = GameContract.GameState.Finished;
1441 		emit StateChanged(true, "game reset");
1442 	}
1443 	
1444 	function drain() public onlyOwner {
1445 		houseAddressOne.transfer((address(this).balance * 7) / 10);
1446 		houseAddressTwo.transfer(address(this).balance);
1447 		emit StateChanged(true, "Drain Successful");
1448 	}
1449     
1450 }