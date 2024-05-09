1 pragma solidity ^0.4.20;
2 
3 
4 contract OraclizeI {
5     address public cbAddress;
6     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
7     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
8     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
9     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
10     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
11     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
12     function getPrice(string _datasource) returns (uint _dsprice);
13     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
14     function useCoupon(string _coupon);
15     function setProofType(byte _proofType);
16     function setConfig(bytes32 _config);
17     function setCustomGasPrice(uint _gasPrice);
18     function randomDS_getSessionPubKeyHash() returns(bytes32);
19 }
20 contract OraclizeAddrResolverI {
21     function getAddress() returns (address _addr);
22 }
23 contract usingOraclize {
24     uint constant day = 60*60*24;
25     uint constant week = 60*60*24*7;
26     uint constant month = 60*60*24*30;
27     byte constant proofType_NONE = 0x00;
28     byte constant proofType_TLSNotary = 0x10;
29     byte constant proofType_Android = 0x20;
30     byte constant proofType_Ledger = 0x30;
31     byte constant proofType_Native = 0xF0;
32     byte constant proofStorage_IPFS = 0x01;
33     uint8 constant networkID_auto = 0;
34     uint8 constant networkID_mainnet = 1;
35     uint8 constant networkID_testnet = 2;
36     uint8 constant networkID_morden = 2;
37     uint8 constant networkID_consensys = 161;
38 
39     OraclizeAddrResolverI OAR;
40 
41     OraclizeI oraclize;
42     modifier oraclizeAPI {
43         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
44         oraclize = OraclizeI(OAR.getAddress());
45         _;
46     }
47     modifier coupon(string code){
48         oraclize = OraclizeI(OAR.getAddress());
49         oraclize.useCoupon(code);
50         _;
51     }
52 
53     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
54         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
55             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
56             oraclize_setNetworkName("eth_mainnet");
57             return true;
58         }
59         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
60             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
61             oraclize_setNetworkName("eth_ropsten3");
62             return true;
63         }
64         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
65             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
66             oraclize_setNetworkName("eth_kovan");
67             return true;
68         }
69         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
70             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
71             oraclize_setNetworkName("eth_rinkeby");
72             return true;
73         }
74         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
75             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
76             return true;
77         }
78         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
79             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
80             return true;
81         }
82         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
83             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
84             return true;
85         }
86         return false;
87     }
88 
89     function __callback(bytes32 myid, string result) {
90         __callback(myid, result, new bytes(0));
91     }
92     function __callback(bytes32 myid, string result, bytes proof) {
93     }
94     
95     function oraclize_useCoupon(string code) oraclizeAPI internal {
96         oraclize.useCoupon(code);
97     }
98 
99     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
100         return oraclize.getPrice(datasource);
101     }
102 
103     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
104         return oraclize.getPrice(datasource, gaslimit);
105     }
106     
107     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
108         uint price = oraclize.getPrice(datasource);
109         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
110         return oraclize.query.value(price)(0, datasource, arg);
111     }
112     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
113         uint price = oraclize.getPrice(datasource);
114         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
115         return oraclize.query.value(price)(timestamp, datasource, arg);
116     }
117     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
118         uint price = oraclize.getPrice(datasource, gaslimit);
119         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
120         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
121     }
122     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
123         uint price = oraclize.getPrice(datasource, gaslimit);
124         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
125         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
126     }
127     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
128         uint price = oraclize.getPrice(datasource);
129         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
130         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
131     }
132     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
133         uint price = oraclize.getPrice(datasource);
134         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
135         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
136     }
137     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
138         uint price = oraclize.getPrice(datasource, gaslimit);
139         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
140         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
141     }
142     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
143         uint price = oraclize.getPrice(datasource, gaslimit);
144         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
145         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
146     }
147     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
148         uint price = oraclize.getPrice(datasource);
149         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
150         bytes memory args = stra2cbor(argN);
151         return oraclize.queryN.value(price)(0, datasource, args);
152     }
153     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
154         uint price = oraclize.getPrice(datasource);
155         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
156         bytes memory args = stra2cbor(argN);
157         return oraclize.queryN.value(price)(timestamp, datasource, args);
158     }
159     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
160         uint price = oraclize.getPrice(datasource, gaslimit);
161         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
162         bytes memory args = stra2cbor(argN);
163         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
164     }
165     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
166         uint price = oraclize.getPrice(datasource, gaslimit);
167         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
168         bytes memory args = stra2cbor(argN);
169         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
170     }
171     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
172         string[] memory dynargs = new string[](1);
173         dynargs[0] = args[0];
174         return oraclize_query(datasource, dynargs);
175     }
176     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
177         string[] memory dynargs = new string[](1);
178         dynargs[0] = args[0];
179         return oraclize_query(timestamp, datasource, dynargs);
180     }
181     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
182         string[] memory dynargs = new string[](1);
183         dynargs[0] = args[0];
184         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
185     }
186     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
187         string[] memory dynargs = new string[](1);
188         dynargs[0] = args[0];       
189         return oraclize_query(datasource, dynargs, gaslimit);
190     }
191     
192     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
193         string[] memory dynargs = new string[](2);
194         dynargs[0] = args[0];
195         dynargs[1] = args[1];
196         return oraclize_query(datasource, dynargs);
197     }
198     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
199         string[] memory dynargs = new string[](2);
200         dynargs[0] = args[0];
201         dynargs[1] = args[1];
202         return oraclize_query(timestamp, datasource, dynargs);
203     }
204     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
205         string[] memory dynargs = new string[](2);
206         dynargs[0] = args[0];
207         dynargs[1] = args[1];
208         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
209     }
210     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
211         string[] memory dynargs = new string[](2);
212         dynargs[0] = args[0];
213         dynargs[1] = args[1];
214         return oraclize_query(datasource, dynargs, gaslimit);
215     }
216     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
217         string[] memory dynargs = new string[](3);
218         dynargs[0] = args[0];
219         dynargs[1] = args[1];
220         dynargs[2] = args[2];
221         return oraclize_query(datasource, dynargs);
222     }
223     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
224         string[] memory dynargs = new string[](3);
225         dynargs[0] = args[0];
226         dynargs[1] = args[1];
227         dynargs[2] = args[2];
228         return oraclize_query(timestamp, datasource, dynargs);
229     }
230     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
231         string[] memory dynargs = new string[](3);
232         dynargs[0] = args[0];
233         dynargs[1] = args[1];
234         dynargs[2] = args[2];
235         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
236     }
237     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
238         string[] memory dynargs = new string[](3);
239         dynargs[0] = args[0];
240         dynargs[1] = args[1];
241         dynargs[2] = args[2];
242         return oraclize_query(datasource, dynargs, gaslimit);
243     }
244     
245     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
246         string[] memory dynargs = new string[](4);
247         dynargs[0] = args[0];
248         dynargs[1] = args[1];
249         dynargs[2] = args[2];
250         dynargs[3] = args[3];
251         return oraclize_query(datasource, dynargs);
252     }
253     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
254         string[] memory dynargs = new string[](4);
255         dynargs[0] = args[0];
256         dynargs[1] = args[1];
257         dynargs[2] = args[2];
258         dynargs[3] = args[3];
259         return oraclize_query(timestamp, datasource, dynargs);
260     }
261     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
262         string[] memory dynargs = new string[](4);
263         dynargs[0] = args[0];
264         dynargs[1] = args[1];
265         dynargs[2] = args[2];
266         dynargs[3] = args[3];
267         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
268     }
269     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
270         string[] memory dynargs = new string[](4);
271         dynargs[0] = args[0];
272         dynargs[1] = args[1];
273         dynargs[2] = args[2];
274         dynargs[3] = args[3];
275         return oraclize_query(datasource, dynargs, gaslimit);
276     }
277     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
278         string[] memory dynargs = new string[](5);
279         dynargs[0] = args[0];
280         dynargs[1] = args[1];
281         dynargs[2] = args[2];
282         dynargs[3] = args[3];
283         dynargs[4] = args[4];
284         return oraclize_query(datasource, dynargs);
285     }
286     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
287         string[] memory dynargs = new string[](5);
288         dynargs[0] = args[0];
289         dynargs[1] = args[1];
290         dynargs[2] = args[2];
291         dynargs[3] = args[3];
292         dynargs[4] = args[4];
293         return oraclize_query(timestamp, datasource, dynargs);
294     }
295     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
296         string[] memory dynargs = new string[](5);
297         dynargs[0] = args[0];
298         dynargs[1] = args[1];
299         dynargs[2] = args[2];
300         dynargs[3] = args[3];
301         dynargs[4] = args[4];
302         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
303     }
304     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
305         string[] memory dynargs = new string[](5);
306         dynargs[0] = args[0];
307         dynargs[1] = args[1];
308         dynargs[2] = args[2];
309         dynargs[3] = args[3];
310         dynargs[4] = args[4];
311         return oraclize_query(datasource, dynargs, gaslimit);
312     }
313     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
314         uint price = oraclize.getPrice(datasource);
315         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
316         bytes memory args = ba2cbor(argN);
317         return oraclize.queryN.value(price)(0, datasource, args);
318     }
319     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
320         uint price = oraclize.getPrice(datasource);
321         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
322         bytes memory args = ba2cbor(argN);
323         return oraclize.queryN.value(price)(timestamp, datasource, args);
324     }
325     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
326         uint price = oraclize.getPrice(datasource, gaslimit);
327         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
328         bytes memory args = ba2cbor(argN);
329         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
330     }
331     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
332         uint price = oraclize.getPrice(datasource, gaslimit);
333         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
334         bytes memory args = ba2cbor(argN);
335         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
336     }
337     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
338         bytes[] memory dynargs = new bytes[](1);
339         dynargs[0] = args[0];
340         return oraclize_query(datasource, dynargs);
341     }
342     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
343         bytes[] memory dynargs = new bytes[](1);
344         dynargs[0] = args[0];
345         return oraclize_query(timestamp, datasource, dynargs);
346     }
347     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
348         bytes[] memory dynargs = new bytes[](1);
349         dynargs[0] = args[0];
350         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
351     }
352     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
353         bytes[] memory dynargs = new bytes[](1);
354         dynargs[0] = args[0];       
355         return oraclize_query(datasource, dynargs, gaslimit);
356     }
357     
358     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
359         bytes[] memory dynargs = new bytes[](2);
360         dynargs[0] = args[0];
361         dynargs[1] = args[1];
362         return oraclize_query(datasource, dynargs);
363     }
364     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
365         bytes[] memory dynargs = new bytes[](2);
366         dynargs[0] = args[0];
367         dynargs[1] = args[1];
368         return oraclize_query(timestamp, datasource, dynargs);
369     }
370     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
371         bytes[] memory dynargs = new bytes[](2);
372         dynargs[0] = args[0];
373         dynargs[1] = args[1];
374         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
375     }
376     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
377         bytes[] memory dynargs = new bytes[](2);
378         dynargs[0] = args[0];
379         dynargs[1] = args[1];
380         return oraclize_query(datasource, dynargs, gaslimit);
381     }
382     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
383         bytes[] memory dynargs = new bytes[](3);
384         dynargs[0] = args[0];
385         dynargs[1] = args[1];
386         dynargs[2] = args[2];
387         return oraclize_query(datasource, dynargs);
388     }
389     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
390         bytes[] memory dynargs = new bytes[](3);
391         dynargs[0] = args[0];
392         dynargs[1] = args[1];
393         dynargs[2] = args[2];
394         return oraclize_query(timestamp, datasource, dynargs);
395     }
396     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
397         bytes[] memory dynargs = new bytes[](3);
398         dynargs[0] = args[0];
399         dynargs[1] = args[1];
400         dynargs[2] = args[2];
401         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
402     }
403     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
404         bytes[] memory dynargs = new bytes[](3);
405         dynargs[0] = args[0];
406         dynargs[1] = args[1];
407         dynargs[2] = args[2];
408         return oraclize_query(datasource, dynargs, gaslimit);
409     }
410     
411     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
412         bytes[] memory dynargs = new bytes[](4);
413         dynargs[0] = args[0];
414         dynargs[1] = args[1];
415         dynargs[2] = args[2];
416         dynargs[3] = args[3];
417         return oraclize_query(datasource, dynargs);
418     }
419     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
420         bytes[] memory dynargs = new bytes[](4);
421         dynargs[0] = args[0];
422         dynargs[1] = args[1];
423         dynargs[2] = args[2];
424         dynargs[3] = args[3];
425         return oraclize_query(timestamp, datasource, dynargs);
426     }
427     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
428         bytes[] memory dynargs = new bytes[](4);
429         dynargs[0] = args[0];
430         dynargs[1] = args[1];
431         dynargs[2] = args[2];
432         dynargs[3] = args[3];
433         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
434     }
435     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
436         bytes[] memory dynargs = new bytes[](4);
437         dynargs[0] = args[0];
438         dynargs[1] = args[1];
439         dynargs[2] = args[2];
440         dynargs[3] = args[3];
441         return oraclize_query(datasource, dynargs, gaslimit);
442     }
443     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
444         bytes[] memory dynargs = new bytes[](5);
445         dynargs[0] = args[0];
446         dynargs[1] = args[1];
447         dynargs[2] = args[2];
448         dynargs[3] = args[3];
449         dynargs[4] = args[4];
450         return oraclize_query(datasource, dynargs);
451     }
452     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
453         bytes[] memory dynargs = new bytes[](5);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         dynargs[2] = args[2];
457         dynargs[3] = args[3];
458         dynargs[4] = args[4];
459         return oraclize_query(timestamp, datasource, dynargs);
460     }
461     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462         bytes[] memory dynargs = new bytes[](5);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         dynargs[2] = args[2];
466         dynargs[3] = args[3];
467         dynargs[4] = args[4];
468         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
469     }
470     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
471         bytes[] memory dynargs = new bytes[](5);
472         dynargs[0] = args[0];
473         dynargs[1] = args[1];
474         dynargs[2] = args[2];
475         dynargs[3] = args[3];
476         dynargs[4] = args[4];
477         return oraclize_query(datasource, dynargs, gaslimit);
478     }
479 
480     function oraclize_cbAddress() oraclizeAPI internal returns (address){
481         return oraclize.cbAddress();
482     }
483     function oraclize_setProof(byte proofP) oraclizeAPI internal {
484         return oraclize.setProofType(proofP);
485     }
486     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
487         return oraclize.setCustomGasPrice(gasPrice);
488     }
489     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
490         return oraclize.setConfig(config);
491     }
492     
493     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
494         return oraclize.randomDS_getSessionPubKeyHash();
495     }
496 
497     function getCodeSize(address _addr) constant internal returns(uint _size) {
498         assembly {
499             _size := extcodesize(_addr)
500         }
501     }
502 
503     function parseAddr(string _a) internal returns (address){
504         bytes memory tmp = bytes(_a);
505         uint160 iaddr = 0;
506         uint160 b1;
507         uint160 b2;
508         for (uint i=2; i<2+2*20; i+=2){
509             iaddr *= 256;
510             b1 = uint160(tmp[i]);
511             b2 = uint160(tmp[i+1]);
512             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
513             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
514             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
515             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
516             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
517             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
518             iaddr += (b1*16+b2);
519         }
520         return address(iaddr);
521     }
522 
523     function strCompare(string _a, string _b) internal returns (int) {
524         bytes memory a = bytes(_a);
525         bytes memory b = bytes(_b);
526         uint minLength = a.length;
527         if (b.length < minLength) minLength = b.length;
528         for (uint i = 0; i < minLength; i ++)
529             if (a[i] < b[i])
530                 return -1;
531             else if (a[i] > b[i])
532                 return 1;
533         if (a.length < b.length)
534             return -1;
535         else if (a.length > b.length)
536             return 1;
537         else
538             return 0;
539     }
540 
541     function indexOf(string _haystack, string _needle) internal returns (int) {
542         bytes memory h = bytes(_haystack);
543         bytes memory n = bytes(_needle);
544         if(h.length < 1 || n.length < 1 || (n.length > h.length))
545             return -1;
546         else if(h.length > (2**128 -1))
547             return -1;
548         else
549         {
550             uint subindex = 0;
551             for (uint i = 0; i < h.length; i ++)
552             {
553                 if (h[i] == n[0])
554                 {
555                     subindex = 1;
556                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
557                     {
558                         subindex++;
559                     }
560                     if(subindex == n.length)
561                         return int(i);
562                 }
563             }
564             return -1;
565         }
566     }
567 
568     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
569         bytes memory _ba = bytes(_a);
570         bytes memory _bb = bytes(_b);
571         bytes memory _bc = bytes(_c);
572         bytes memory _bd = bytes(_d);
573         bytes memory _be = bytes(_e);
574         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
575         bytes memory babcde = bytes(abcde);
576         uint k = 0;
577         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
578         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
579         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
580         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
581         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
582         return string(babcde);
583     }
584 
585     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
586         return strConcat(_a, _b, _c, _d, "");
587     }
588 
589     function strConcat(string _a, string _b, string _c) internal returns (string) {
590         return strConcat(_a, _b, _c, "", "");
591     }
592 
593     function strConcat(string _a, string _b) internal returns (string) {
594         return strConcat(_a, _b, "", "", "");
595     }
596 
597     // parseInt
598     function parseInt(string _a) internal returns (uint) {
599         return parseInt(_a, 0);
600     }
601 
602     // parseInt(parseFloat*10^_b)
603     function parseInt(string _a, uint _b) internal returns (uint) {
604         bytes memory bresult = bytes(_a);
605         uint mint = 0;
606         bool decimals = false;
607         for (uint i=0; i<bresult.length; i++){
608             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
609                 if (decimals){
610                    if (_b == 0) break;
611                     else _b--;
612                 }
613                 mint *= 10;
614                 mint += uint(bresult[i]) - 48;
615             } else if (bresult[i] == 46) decimals = true;
616         }
617         if (_b > 0) mint *= 10**_b;
618         return mint;
619     }
620 
621     function uint2str(uint i) internal returns (string){
622         if (i == 0) return "0";
623         uint j = i;
624         uint len;
625         while (j != 0){
626             len++;
627             j /= 10;
628         }
629         bytes memory bstr = new bytes(len);
630         uint k = len - 1;
631         while (i != 0){
632             bstr[k--] = byte(48 + i % 10);
633             i /= 10;
634         }
635         return string(bstr);
636     }
637     
638     function stra2cbor(string[] arr) internal returns (bytes) {
639             uint arrlen = arr.length;
640 
641             // get correct cbor output length
642             uint outputlen = 0;
643             bytes[] memory elemArray = new bytes[](arrlen);
644             for (uint i = 0; i < arrlen; i++) {
645                 elemArray[i] = (bytes(arr[i]));
646                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
647             }
648             uint ctr = 0;
649             uint cborlen = arrlen + 0x80;
650             outputlen += byte(cborlen).length;
651             bytes memory res = new bytes(outputlen);
652 
653             while (byte(cborlen).length > ctr) {
654                 res[ctr] = byte(cborlen)[ctr];
655                 ctr++;
656             }
657             for (i = 0; i < arrlen; i++) {
658                 res[ctr] = 0x5F;
659                 ctr++;
660                 for (uint x = 0; x < elemArray[i].length; x++) {
661                     // if there's a bug with larger strings, this may be the culprit
662                     if (x % 23 == 0) {
663                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
664                         elemcborlen += 0x40;
665                         uint lctr = ctr;
666                         while (byte(elemcborlen).length > ctr - lctr) {
667                             res[ctr] = byte(elemcborlen)[ctr - lctr];
668                             ctr++;
669                         }
670                     }
671                     res[ctr] = elemArray[i][x];
672                     ctr++;
673                 }
674                 res[ctr] = 0xFF;
675                 ctr++;
676             }
677             return res;
678         }
679 
680     function ba2cbor(bytes[] arr) internal returns (bytes) {
681             uint arrlen = arr.length;
682 
683             // get correct cbor output length
684             uint outputlen = 0;
685             bytes[] memory elemArray = new bytes[](arrlen);
686             for (uint i = 0; i < arrlen; i++) {
687                 elemArray[i] = (bytes(arr[i]));
688                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
689             }
690             uint ctr = 0;
691             uint cborlen = arrlen + 0x80;
692             outputlen += byte(cborlen).length;
693             bytes memory res = new bytes(outputlen);
694 
695             while (byte(cborlen).length > ctr) {
696                 res[ctr] = byte(cborlen)[ctr];
697                 ctr++;
698             }
699             for (i = 0; i < arrlen; i++) {
700                 res[ctr] = 0x5F;
701                 ctr++;
702                 for (uint x = 0; x < elemArray[i].length; x++) {
703                     // if there's a bug with larger strings, this may be the culprit
704                     if (x % 23 == 0) {
705                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
706                         elemcborlen += 0x40;
707                         uint lctr = ctr;
708                         while (byte(elemcborlen).length > ctr - lctr) {
709                             res[ctr] = byte(elemcborlen)[ctr - lctr];
710                             ctr++;
711                         }
712                     }
713                     res[ctr] = elemArray[i][x];
714                     ctr++;
715                 }
716                 res[ctr] = 0xFF;
717                 ctr++;
718             }
719             return res;
720         }
721         
722         
723     string oraclize_network_name;
724     function oraclize_setNetworkName(string _network_name) internal {
725         oraclize_network_name = _network_name;
726     }
727     
728     function oraclize_getNetworkName() internal returns (string) {
729         return oraclize_network_name;
730     }
731     
732     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
733         if ((_nbytes == 0)||(_nbytes > 32)) throw;
734         bytes memory nbytes = new bytes(1);
735         nbytes[0] = byte(_nbytes);
736         bytes memory unonce = new bytes(32);
737         bytes memory sessionKeyHash = new bytes(32);
738         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
739         assembly {
740             mstore(unonce, 0x20)
741             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
742             mstore(sessionKeyHash, 0x20)
743             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
744         }
745         bytes[3] memory args = [unonce, nbytes, sessionKeyHash]; 
746         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
747         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
748         return queryId;
749     }
750     
751     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
752         oraclize_randomDS_args[queryId] = commitment;
753     }
754     
755     mapping(bytes32=>bytes32) oraclize_randomDS_args;
756     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
757 
758     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
759         bool sigok;
760         address signer;
761         
762         bytes32 sigr;
763         bytes32 sigs;
764         
765         bytes memory sigr_ = new bytes(32);
766         uint offset = 4+(uint(dersig[3]) - 0x20);
767         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
768         bytes memory sigs_ = new bytes(32);
769         offset += 32 + 2;
770         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
771 
772         assembly {
773             sigr := mload(add(sigr_, 32))
774             sigs := mload(add(sigs_, 32))
775         }
776         
777         
778         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
779         if (address(sha3(pubkey)) == signer) return true;
780         else {
781             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
782             return (address(sha3(pubkey)) == signer);
783         }
784     }
785 
786     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
787         bool sigok;
788         
789         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
790         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
791         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
792         
793         bytes memory appkey1_pubkey = new bytes(64);
794         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
795         
796         bytes memory tosign2 = new bytes(1+65+32);
797         tosign2[0] = 1; //role
798         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
799         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
800         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
801         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
802         
803         if (sigok == false) return false;
804         
805         
806         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
807         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
808         
809         bytes memory tosign3 = new bytes(1+65);
810         tosign3[0] = 0xFE;
811         copyBytes(proof, 3, 65, tosign3, 1);
812         
813         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
814         copyBytes(proof, 3+65, sig3.length, sig3, 0);
815         
816         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
817         
818         return sigok;
819     }
820     
821     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
822         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
823         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
824         
825         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
826         if (proofVerified == false) throw;
827         
828         _;
829     }
830     
831     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
832         bool match_ = true;
833         
834         for (var i=0; i<prefix.length; i++){
835             if (content[i] != prefix[i]) match_ = false;
836         }
837         
838         return match_;
839     }
840 
841     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
842         bool checkok;
843         
844         
845         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
846         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
847         bytes memory keyhash = new bytes(32);
848         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
849         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
850         if (checkok == false) return false;
851         
852         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
853         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
854         
855         
856         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
857         checkok = matchBytes32Prefix(sha256(sig1), result);
858         if (checkok == false) return false;
859         
860         
861         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
862         // This is to verify that the computed args match with the ones specified in the query.
863         bytes memory commitmentSlice1 = new bytes(8+1+32);
864         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
865         
866         bytes memory sessionPubkey = new bytes(64);
867         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
868         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
869         
870         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
871         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
872             delete oraclize_randomDS_args[queryId];
873         } else return false;
874         
875         
876         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
877         bytes memory tosign1 = new bytes(32+8+1+32);
878         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
879         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
880         if (checkok == false) return false;
881         
882         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
883         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
884             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
885         }
886         
887         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
888     }
889 
890     
891     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
892     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
893         uint minLength = length + toOffset;
894 
895         if (to.length < minLength) {
896             // Buffer too small
897             throw; // Should be a better way?
898         }
899 
900         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
901         uint i = 32 + fromOffset;
902         uint j = 32 + toOffset;
903 
904         while (i < (32 + fromOffset + length)) {
905             assembly {
906                 let tmp := mload(add(from, i))
907                 mstore(add(to, j), tmp)
908             }
909             i += 32;
910             j += 32;
911         }
912 
913         return to;
914     }
915     
916     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
917     // Duplicate Solidity's ecrecover, but catching the CALL return value
918     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
919         // We do our own memory management here. Solidity uses memory offset
920         // 0x40 to store the current end of memory. We write past it (as
921         // writes are memory extensions), but don't update the offset so
922         // Solidity will reuse it. The memory used here is only needed for
923         // this context.
924 
925         // FIXME: inline assembly can't access return values
926         bool ret;
927         address addr;
928 
929         assembly {
930             let size := mload(0x40)
931             mstore(size, hash)
932             mstore(add(size, 32), v)
933             mstore(add(size, 64), r)
934             mstore(add(size, 96), s)
935 
936             // NOTE: we can reuse the request memory because we deal with
937             //       the return code
938             ret := call(3000, 1, 0, size, 128, size, 32)
939             addr := mload(size)
940         }
941   
942         return (ret, addr);
943     }
944 
945     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
946     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
947         bytes32 r;
948         bytes32 s;
949         uint8 v;
950 
951         if (sig.length != 65)
952           return (false, 0);
953 
954         // The signature format is a compact form of:
955         //   {bytes32 r}{bytes32 s}{uint8 v}
956         // Compact means, uint8 is not padded to 32 bytes.
957         assembly {
958             r := mload(add(sig, 32))
959             s := mload(add(sig, 64))
960 
961             // Here we are loading the last 32 bytes. We exploit the fact that
962             // 'mload' will pad with zeroes if we overread.
963             // There is no 'mload8' to do this, but that would be nicer.
964             v := byte(0, mload(add(sig, 96)))
965 
966             // Alternative solution:
967             // 'byte' is not working due to the Solidity parser, so lets
968             // use the second best option, 'and'
969             // v := and(mload(add(sig, 65)), 255)
970         }
971 
972         // albeit non-transactional signatures are not specified by the YP, one would expect it
973         // to match the YP range of [27, 28]
974         //
975         // geth uses [0, 1] and some clients have followed. This might change, see:
976         //  https://github.com/ethereum/go-ethereum/issues/2053
977         if (v < 27)
978           v += 27;
979 
980         if (v != 27 && v != 28)
981             return (false, 0);
982 
983         return safer_ecrecover(hash, v, r, s);
984     }
985         
986 }
987 // </ORACLIZE_API>
988 
989 library SafeMath {
990   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
991     uint256 c = a * b;
992     assert(a == 0 || c / a == b);
993     return c;
994   }
995 
996   function div(uint256 a, uint256 b) internal constant returns (uint256) {
997     // assert(b > 0); // Solidity automatically throws when dividing by 0
998     uint256 c = a / b;
999     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1000     return c;
1001   }
1002 
1003   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1004     assert(b <= a);
1005     return a - b;
1006   }
1007 
1008   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1009     uint256 c = a + b;
1010     assert(c >= a);
1011     return c;
1012   }
1013 }
1014 contract BettingControllerInterface {
1015     function remoteBettingClose() external;
1016     function depositHouseTakeout() external payable;
1017 }
1018 
1019 contract Betting is usingOraclize {
1020     using SafeMath for uint256; //using safemath
1021 
1022     uint countdown=3; // variable to check if all prices are received
1023     address public owner; //owner address
1024     
1025     uint public winnerPoolTotal;
1026     string public constant version = "0.2.2";
1027     
1028     BettingControllerInterface internal bettingControllerInstance;
1029     
1030     struct chronus_info {
1031         bool  betting_open; // boolean: check if betting is open
1032         bool  race_start; //boolean: check if race has started
1033         bool  race_end; //boolean: check if race has ended
1034         bool  voided_bet; //boolean: check if race has been voided
1035         uint32  starting_time; // timestamp of when the race starts
1036         uint32  betting_duration;
1037         uint32  race_duration; // duration of the race
1038         uint32 voided_timestamp;
1039     }
1040     
1041     struct horses_info{
1042         int64  BTC_delta; //horses.BTC delta value
1043         int64  ETH_delta; //horses.ETH delta value
1044         int64  LTC_delta; //horses.LTC delta value
1045         bytes32 BTC; //32-bytes equivalent of horses.BTC
1046         bytes32 ETH; //32-bytes equivalent of horses.ETH
1047         bytes32 LTC;  //32-bytes equivalent of horses.LTC
1048         uint customPreGasLimit;
1049         uint customPostGasLimit;
1050     }
1051 
1052     struct bet_info{
1053         bytes32 horse; // coin on which amount is bet on
1054         uint amount; // amount bet by Bettor
1055     }
1056     struct coin_info{
1057         uint256 pre; // locking price
1058         uint256 post; // ending price
1059         uint160 total; // total coin pool
1060         uint32 count; // number of bets
1061         bool price_check;
1062         bytes32 preOraclizeId;
1063         bytes32 postOraclizeId;
1064     }
1065     struct voter_info {
1066         uint160 total_bet; //total amount of bet placed
1067         bool rewarded; // boolean: check for double spending
1068         mapping(bytes32=>uint) bets; //array of bets
1069     }
1070     
1071 
1072     mapping (bytes32 => bytes32) oraclizeIndex; // mapping oraclize IDs with coins
1073     mapping (bytes32 => coin_info) coinIndex; // mapping coins with pool information
1074     mapping (address => voter_info) voterIndex; // mapping voter address with Bettor information
1075 
1076     uint public total_reward; // total reward to be awarded
1077     uint32 total_bettors;
1078     mapping (bytes32 => bool) public winner_horse;
1079 
1080 
1081     // tracking events
1082     event newOraclizeQuery(string description);
1083     event newPriceTicker(uint price);
1084     event Deposit(address _from, uint256 _value, bytes32 _horse, uint256 _date);
1085     event Withdraw(address _to, uint256 _value);
1086 
1087     // constructor
1088     function Betting() public payable {
1089         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1090         owner = msg.sender;
1091         oraclize_setCustomGasPrice(30000000000 wei);
1092         horses.BTC = bytes32("BTC");
1093         horses.ETH = bytes32("ETH");
1094         horses.LTC = bytes32("LTC");
1095         horses.customPreGasLimit = 80000;
1096         horses.customPostGasLimit = 230000;
1097         bettingControllerInstance = BettingControllerInterface(owner);
1098     }
1099 
1100     // data access structures
1101     horses_info public horses;
1102     chronus_info public chronus;
1103     
1104     // modifiers for restricting access to methods
1105     modifier onlyOwner {
1106         require(owner == msg.sender);
1107         _;
1108     }
1109 
1110     modifier duringBetting {
1111         require(chronus.betting_open);
1112         require(now < chronus.starting_time + chronus.betting_duration);
1113         _;
1114     }
1115     
1116     modifier beforeBetting {
1117         require(!chronus.betting_open && !chronus.race_start);
1118         _;
1119     }
1120 
1121     modifier afterRace {
1122         require(chronus.race_end);
1123         _;
1124     }
1125     
1126     //function to change owner
1127     function changeOwnership(address _newOwner) onlyOwner external {
1128         owner = _newOwner;
1129     }
1130 
1131     //oraclize callback method
1132     function __callback(bytes32 myid, string result, bytes proof) public {
1133         require (msg.sender == oraclize_cbAddress());
1134         require (!chronus.race_end);
1135         bytes32 coin_pointer; // variable to differentiate different callbacks
1136         chronus.race_start = true;
1137         chronus.betting_open = false;
1138         bettingControllerInstance.remoteBettingClose();
1139         coin_pointer = oraclizeIndex[myid];
1140 
1141         if (myid == coinIndex[coin_pointer].preOraclizeId) {
1142             if (coinIndex[coin_pointer].pre > 0) {
1143             } else if (now >= chronus.starting_time+chronus.betting_duration+ 30 minutes) {
1144                 forceVoidRace();
1145             } else {
1146                 coinIndex[coin_pointer].pre = stringToUintNormalize(result);
1147                 emit newPriceTicker(coinIndex[coin_pointer].pre);
1148             }
1149         } else if (myid == coinIndex[coin_pointer].postOraclizeId){
1150             if (coinIndex[coin_pointer].pre > 0 ){
1151                 if (coinIndex[coin_pointer].post > 0) {
1152                 } else if (now >= chronus.starting_time+chronus.race_duration+ 30 minutes) {
1153                     forceVoidRace();
1154                 } else {
1155                     coinIndex[coin_pointer].post = stringToUintNormalize(result);
1156                     coinIndex[coin_pointer].price_check = true;
1157                     emit newPriceTicker(coinIndex[coin_pointer].post);
1158                     
1159                     if (coinIndex[horses.ETH].price_check && coinIndex[horses.BTC].price_check && coinIndex[horses.LTC].price_check) {
1160                         reward();
1161                     }
1162                 }
1163             } else {
1164                 forceVoidRace();
1165             }
1166         }
1167     }
1168 
1169     // place a bet on a coin(horse) lockBetting
1170     function placeBet(bytes32 horse) external duringBetting payable  {
1171         require(msg.value >= 0.01 ether);
1172         if (voterIndex[msg.sender].total_bet==0) {
1173             total_bettors+=1;
1174         }
1175         uint _newAmount = voterIndex[msg.sender].bets[horse] + msg.value;
1176         voterIndex[msg.sender].bets[horse] = _newAmount;
1177         voterIndex[msg.sender].total_bet += uint160(msg.value);
1178         uint160 _newTotal = coinIndex[horse].total + uint160(msg.value); 
1179         uint32 _newCount = coinIndex[horse].count + 1;
1180         coinIndex[horse].total = _newTotal;
1181         coinIndex[horse].count = _newCount;
1182         emit Deposit(msg.sender, msg.value, horse, now);
1183     }
1184 
1185     // fallback method for accepting payments
1186     function () private payable {}
1187 
1188     // method to place the oraclize queries
1189     function setupRace(uint delay, uint  locking_duration) onlyOwner beforeBetting public payable returns(bool) {
1190         // if (oraclize_getPrice("URL") > (this.balance)/6) {
1191         if (oraclize_getPrice("URL" , horses.customPreGasLimit)*3 + oraclize_getPrice("URL", horses.customPostGasLimit)*3  > address(this).balance) {
1192             emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1193             return false;
1194         } else {
1195             chronus.starting_time = uint32(block.timestamp);
1196             chronus.betting_open = true;
1197             bytes32 temp_ID; // temp variable to store oraclize IDs
1198             emit newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1199             // bets open price query
1200             chronus.betting_duration = uint32(delay);
1201             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd",horses.customPreGasLimit);
1202             oraclizeIndex[temp_ID] = horses.ETH;
1203             coinIndex[horses.ETH].preOraclizeId = temp_ID;
1204 
1205             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd",horses.customPreGasLimit);
1206             oraclizeIndex[temp_ID] = horses.LTC;
1207             coinIndex[horses.LTC].preOraclizeId = temp_ID;
1208 
1209             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd",horses.customPreGasLimit);
1210             oraclizeIndex[temp_ID] = horses.BTC;
1211             coinIndex[horses.BTC].preOraclizeId = temp_ID;
1212 
1213             //bets closing price query
1214             delay = delay.add(locking_duration);
1215 
1216             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/ethereum/).0.price_usd",horses.customPostGasLimit);
1217             oraclizeIndex[temp_ID] = horses.ETH;
1218             coinIndex[horses.ETH].postOraclizeId = temp_ID;
1219 
1220             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/litecoin/).0.price_usd",horses.customPostGasLimit);
1221             oraclizeIndex[temp_ID] = horses.LTC;
1222             coinIndex[horses.LTC].postOraclizeId = temp_ID;
1223 
1224             temp_ID = oraclize_query(delay, "URL", "json(https://api.coinmarketcap.com/v1/ticker/bitcoin/).0.price_usd",horses.customPostGasLimit);
1225             oraclizeIndex[temp_ID] = horses.BTC;
1226             coinIndex[horses.BTC].postOraclizeId = temp_ID;
1227 
1228             chronus.race_duration = uint32(delay);
1229             return true;
1230         }
1231     }
1232 
1233     // method to calculate reward (called internally by callback)
1234     function reward() internal {
1235         /*
1236         calculating the difference in price with a precision of 5 digits
1237         not using safemath since signed integers are handled
1238         */
1239         horses.BTC_delta = int64(coinIndex[horses.BTC].post - coinIndex[horses.BTC].pre)*100000/int64(coinIndex[horses.BTC].pre);
1240         horses.ETH_delta = int64(coinIndex[horses.ETH].post - coinIndex[horses.ETH].pre)*100000/int64(coinIndex[horses.ETH].pre);
1241         horses.LTC_delta = int64(coinIndex[horses.LTC].post - coinIndex[horses.LTC].pre)*100000/int64(coinIndex[horses.LTC].pre);
1242         
1243         total_reward = (coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total);
1244         if (total_bettors <= 1) {
1245             forceVoidRace();
1246         } else {
1247             uint house_fee = total_reward.mul(5).div(100);
1248             require(house_fee < address(this).balance);
1249             total_reward = total_reward.sub(house_fee);
1250             bettingControllerInstance.depositHouseTakeout.value(house_fee)();
1251         }
1252         
1253         if (horses.BTC_delta > horses.ETH_delta) {
1254             if (horses.BTC_delta > horses.LTC_delta) {
1255                 winner_horse[horses.BTC] = true;
1256                 winnerPoolTotal = coinIndex[horses.BTC].total;
1257             }
1258             else if(horses.LTC_delta > horses.BTC_delta) {
1259                 winner_horse[horses.LTC] = true;
1260                 winnerPoolTotal = coinIndex[horses.LTC].total;
1261             } else {
1262                 winner_horse[horses.BTC] = true;
1263                 winner_horse[horses.LTC] = true;
1264                 winnerPoolTotal = coinIndex[horses.BTC].total + (coinIndex[horses.LTC].total);
1265             }
1266         } else if(horses.ETH_delta > horses.BTC_delta) {
1267             if (horses.ETH_delta > horses.LTC_delta) {
1268                 winner_horse[horses.ETH] = true;
1269                 winnerPoolTotal = coinIndex[horses.ETH].total;
1270             }
1271             else if (horses.LTC_delta > horses.ETH_delta) {
1272                 winner_horse[horses.LTC] = true;
1273                 winnerPoolTotal = coinIndex[horses.LTC].total;
1274             } else {
1275                 winner_horse[horses.ETH] = true;
1276                 winner_horse[horses.LTC] = true;
1277                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.LTC].total);
1278             }
1279         } else {
1280             if (horses.LTC_delta > horses.ETH_delta) {
1281                 winner_horse[horses.LTC] = true;
1282                 winnerPoolTotal = coinIndex[horses.LTC].total;
1283             } else if(horses.LTC_delta < horses.ETH_delta){
1284                 winner_horse[horses.ETH] = true;
1285                 winner_horse[horses.BTC] = true;
1286                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total);
1287             } else {
1288                 winner_horse[horses.LTC] = true;
1289                 winner_horse[horses.ETH] = true;
1290                 winner_horse[horses.BTC] = true;
1291                 winnerPoolTotal = coinIndex[horses.ETH].total + (coinIndex[horses.BTC].total) + (coinIndex[horses.LTC].total);
1292             }
1293         }
1294         chronus.race_end = true;
1295     }
1296 
1297     // method to calculate an invidual's reward
1298     function calculateReward(address candidate) internal afterRace constant returns(uint winner_reward) {
1299         voter_info storage bettor = voterIndex[candidate];
1300         if(chronus.voided_bet) {
1301             winner_reward = bettor.total_bet;
1302         } else {
1303             uint winning_bet_total;
1304             if(winner_horse[horses.BTC]) {
1305                 winning_bet_total += bettor.bets[horses.BTC];
1306             } if(winner_horse[horses.ETH]) {
1307                 winning_bet_total += bettor.bets[horses.ETH];
1308             } if(winner_horse[horses.LTC]) {
1309                 winning_bet_total += bettor.bets[horses.LTC];
1310             }
1311             winner_reward += (((total_reward.mul(10000000)).div(winnerPoolTotal)).mul(winning_bet_total)).div(10000000);
1312         } 
1313     }
1314 
1315     // method to just check the reward amount
1316     function checkReward() afterRace external constant returns (uint) {
1317         require(!voterIndex[msg.sender].rewarded);
1318         return calculateReward(msg.sender);
1319     }
1320 
1321     // method to claim the reward amount
1322     function claim_reward() afterRace external {
1323         require(!voterIndex[msg.sender].rewarded);
1324         uint transfer_amount = calculateReward(msg.sender);
1325         require(address(this).balance >= transfer_amount);
1326         voterIndex[msg.sender].rewarded = true;
1327         msg.sender.transfer(transfer_amount);
1328         emit Withdraw(msg.sender, transfer_amount);
1329     }
1330     
1331     function forceVoidRace() internal {
1332         chronus.voided_bet=true;
1333         chronus.race_end = true;
1334         chronus.voided_timestamp=uint32(now);
1335     }
1336 
1337     // utility function to convert string to integer with precision consideration
1338     function stringToUintNormalize(string s) internal pure returns (uint result) {
1339         uint p =2;
1340         bool precision=false;
1341         bytes memory b = bytes(s);
1342         uint i;
1343         result = 0;
1344         for (i = 0; i < b.length; i++) {
1345             if (precision) {p = p-1;}
1346             if (uint(b[i]) == 46){precision = true;}
1347             uint c = uint(b[i]);
1348             if (c >= 48 && c <= 57) {result = result * 10 + (c - 48);}
1349             if (precision && p == 0){return result;}
1350         }
1351         while (p!=0) {
1352             result = result*10;
1353             p=p-1;
1354         }
1355     }
1356 
1357 
1358     // exposing the coin pool details for DApp
1359     function getCoinIndex(bytes32 index, address candidate) external constant returns (uint, uint, uint, bool, uint) {
1360         return (coinIndex[index].total, coinIndex[index].pre, coinIndex[index].post, coinIndex[index].price_check, voterIndex[candidate].bets[index]);
1361     }
1362 
1363     // exposing the total reward amount for DApp
1364     function reward_total() external constant returns (uint) {
1365         return ((coinIndex[horses.BTC].total) + (coinIndex[horses.ETH].total) + (coinIndex[horses.LTC].total));
1366     }
1367     
1368     // in case of any errors in race, enable full refund for the Bettors to claim
1369     function refund() external onlyOwner {
1370         require(now > chronus.starting_time + chronus.race_duration);
1371         require((chronus.betting_open && !chronus.race_start)
1372             || (chronus.race_start && !chronus.race_end));
1373         chronus.voided_bet = true;
1374         chronus.race_end = true;
1375         chronus.voided_timestamp=uint32(now);
1376         bettingControllerInstance.remoteBettingClose();
1377     }
1378 
1379     // method to claim unclaimed winnings after 30 day notice period
1380     function recovery() external onlyOwner{
1381         require((chronus.race_end && now > chronus.starting_time + chronus.race_duration + (30 days))
1382             || (chronus.voided_bet && now > chronus.voided_timestamp + (30 days)));
1383         bettingControllerInstance.depositHouseTakeout.value(address(this).balance)();
1384     }
1385 }