1 pragma solidity ^0.4.18;
2 
3 contract OraclizeI {
4     address public cbAddress;
5     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
6     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
7     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
8     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
9     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
10     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
11     function getPrice(string _datasource) returns (uint _dsprice);
12     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
13     function useCoupon(string _coupon);
14     function setProofType(byte _proofType);
15     function setConfig(bytes32 _config);
16     function setCustomGasPrice(uint _gasPrice);
17     function randomDS_getSessionPubKeyHash() returns(bytes32);
18 }
19 contract OraclizeAddrResolverI {
20     function getAddress() returns (address _addr);
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
42         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
43         oraclize = OraclizeI(OAR.getAddress());
44         _;
45     }
46     modifier coupon(string code){
47         oraclize = OraclizeI(OAR.getAddress());
48         oraclize.useCoupon(code);
49         _;
50     }
51 
52     function oraclize_setNetwork(uint8) internal returns(bool){
53 //    function oraclize_setNetwork(uint8 networkID) internal returns(bool){
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
92     function __callback(bytes32, string, bytes) {
93 //    function __callback(bytes32 myid, string result, bytes proof) {
94     }
95 
96     function oraclize_useCoupon(string code) oraclizeAPI internal {
97         oraclize.useCoupon(code);
98     }
99 
100     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
101         return oraclize.getPrice(datasource);
102     }
103 
104     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
105         return oraclize.getPrice(datasource, gaslimit);
106     }
107 
108     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
109         uint price = oraclize.getPrice(datasource);
110         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
111         return oraclize.query.value(price)(0, datasource, arg);
112     }
113     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
114         uint price = oraclize.getPrice(datasource);
115         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
116         return oraclize.query.value(price)(timestamp, datasource, arg);
117     }
118     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
119         uint price = oraclize.getPrice(datasource, gaslimit);
120         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
121         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
122     }
123     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
124         uint price = oraclize.getPrice(datasource, gaslimit);
125         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
126         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
127     }
128     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
129         uint price = oraclize.getPrice(datasource);
130         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
131         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
132     }
133     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
134         uint price = oraclize.getPrice(datasource);
135         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
136         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
137     }
138     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
139         uint price = oraclize.getPrice(datasource, gaslimit);
140         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
141         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
142     }
143     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
144         uint price = oraclize.getPrice(datasource, gaslimit);
145         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
146         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
147     }
148     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
149         uint price = oraclize.getPrice(datasource);
150         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
151         bytes memory args = stra2cbor(argN);
152         return oraclize.queryN.value(price)(0, datasource, args);
153     }
154     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
155         uint price = oraclize.getPrice(datasource);
156         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
157         bytes memory args = stra2cbor(argN);
158         return oraclize.queryN.value(price)(timestamp, datasource, args);
159     }
160     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
161         uint price = oraclize.getPrice(datasource, gaslimit);
162         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
163         bytes memory args = stra2cbor(argN);
164         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
165     }
166     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
167         uint price = oraclize.getPrice(datasource, gaslimit);
168         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
169         bytes memory args = stra2cbor(argN);
170         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
171     }
172     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
173         string[] memory dynargs = new string[](1);
174         dynargs[0] = args[0];
175         return oraclize_query(datasource, dynargs);
176     }
177     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
178         string[] memory dynargs = new string[](1);
179         dynargs[0] = args[0];
180         return oraclize_query(timestamp, datasource, dynargs);
181     }
182     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
183         string[] memory dynargs = new string[](1);
184         dynargs[0] = args[0];
185         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
186     }
187     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
188         string[] memory dynargs = new string[](1);
189         dynargs[0] = args[0];
190         return oraclize_query(datasource, dynargs, gaslimit);
191     }
192 
193     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
194         string[] memory dynargs = new string[](2);
195         dynargs[0] = args[0];
196         dynargs[1] = args[1];
197         return oraclize_query(datasource, dynargs);
198     }
199     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
200         string[] memory dynargs = new string[](2);
201         dynargs[0] = args[0];
202         dynargs[1] = args[1];
203         return oraclize_query(timestamp, datasource, dynargs);
204     }
205     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
206         string[] memory dynargs = new string[](2);
207         dynargs[0] = args[0];
208         dynargs[1] = args[1];
209         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
210     }
211     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
212         string[] memory dynargs = new string[](2);
213         dynargs[0] = args[0];
214         dynargs[1] = args[1];
215         return oraclize_query(datasource, dynargs, gaslimit);
216     }
217     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
218         string[] memory dynargs = new string[](3);
219         dynargs[0] = args[0];
220         dynargs[1] = args[1];
221         dynargs[2] = args[2];
222         return oraclize_query(datasource, dynargs);
223     }
224     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
225         string[] memory dynargs = new string[](3);
226         dynargs[0] = args[0];
227         dynargs[1] = args[1];
228         dynargs[2] = args[2];
229         return oraclize_query(timestamp, datasource, dynargs);
230     }
231     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
232         string[] memory dynargs = new string[](3);
233         dynargs[0] = args[0];
234         dynargs[1] = args[1];
235         dynargs[2] = args[2];
236         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
237     }
238     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
239         string[] memory dynargs = new string[](3);
240         dynargs[0] = args[0];
241         dynargs[1] = args[1];
242         dynargs[2] = args[2];
243         return oraclize_query(datasource, dynargs, gaslimit);
244     }
245 
246     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
247         string[] memory dynargs = new string[](4);
248         dynargs[0] = args[0];
249         dynargs[1] = args[1];
250         dynargs[2] = args[2];
251         dynargs[3] = args[3];
252         return oraclize_query(datasource, dynargs);
253     }
254     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
255         string[] memory dynargs = new string[](4);
256         dynargs[0] = args[0];
257         dynargs[1] = args[1];
258         dynargs[2] = args[2];
259         dynargs[3] = args[3];
260         return oraclize_query(timestamp, datasource, dynargs);
261     }
262     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
263         string[] memory dynargs = new string[](4);
264         dynargs[0] = args[0];
265         dynargs[1] = args[1];
266         dynargs[2] = args[2];
267         dynargs[3] = args[3];
268         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
269     }
270     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
271         string[] memory dynargs = new string[](4);
272         dynargs[0] = args[0];
273         dynargs[1] = args[1];
274         dynargs[2] = args[2];
275         dynargs[3] = args[3];
276         return oraclize_query(datasource, dynargs, gaslimit);
277     }
278     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
279         string[] memory dynargs = new string[](5);
280         dynargs[0] = args[0];
281         dynargs[1] = args[1];
282         dynargs[2] = args[2];
283         dynargs[3] = args[3];
284         dynargs[4] = args[4];
285         return oraclize_query(datasource, dynargs);
286     }
287     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
288         string[] memory dynargs = new string[](5);
289         dynargs[0] = args[0];
290         dynargs[1] = args[1];
291         dynargs[2] = args[2];
292         dynargs[3] = args[3];
293         dynargs[4] = args[4];
294         return oraclize_query(timestamp, datasource, dynargs);
295     }
296     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
297         string[] memory dynargs = new string[](5);
298         dynargs[0] = args[0];
299         dynargs[1] = args[1];
300         dynargs[2] = args[2];
301         dynargs[3] = args[3];
302         dynargs[4] = args[4];
303         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
304     }
305     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
306         string[] memory dynargs = new string[](5);
307         dynargs[0] = args[0];
308         dynargs[1] = args[1];
309         dynargs[2] = args[2];
310         dynargs[3] = args[3];
311         dynargs[4] = args[4];
312         return oraclize_query(datasource, dynargs, gaslimit);
313     }
314     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
315         uint price = oraclize.getPrice(datasource);
316         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
317         bytes memory args = ba2cbor(argN);
318         return oraclize.queryN.value(price)(0, datasource, args);
319     }
320     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
321         uint price = oraclize.getPrice(datasource);
322         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
323         bytes memory args = ba2cbor(argN);
324         return oraclize.queryN.value(price)(timestamp, datasource, args);
325     }
326     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
327         uint price = oraclize.getPrice(datasource, gaslimit);
328         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
329         bytes memory args = ba2cbor(argN);
330         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
331     }
332     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
333         uint price = oraclize.getPrice(datasource, gaslimit);
334         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
335         bytes memory args = ba2cbor(argN);
336         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
337     }
338     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
339         bytes[] memory dynargs = new bytes[](1);
340         dynargs[0] = args[0];
341         return oraclize_query(datasource, dynargs);
342     }
343     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
344         bytes[] memory dynargs = new bytes[](1);
345         dynargs[0] = args[0];
346         return oraclize_query(timestamp, datasource, dynargs);
347     }
348     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
349         bytes[] memory dynargs = new bytes[](1);
350         dynargs[0] = args[0];
351         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
352     }
353     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
354         bytes[] memory dynargs = new bytes[](1);
355         dynargs[0] = args[0];
356         return oraclize_query(datasource, dynargs, gaslimit);
357     }
358 
359     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
360         bytes[] memory dynargs = new bytes[](2);
361         dynargs[0] = args[0];
362         dynargs[1] = args[1];
363         return oraclize_query(datasource, dynargs);
364     }
365     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
366         bytes[] memory dynargs = new bytes[](2);
367         dynargs[0] = args[0];
368         dynargs[1] = args[1];
369         return oraclize_query(timestamp, datasource, dynargs);
370     }
371     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
372         bytes[] memory dynargs = new bytes[](2);
373         dynargs[0] = args[0];
374         dynargs[1] = args[1];
375         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
376     }
377     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
378         bytes[] memory dynargs = new bytes[](2);
379         dynargs[0] = args[0];
380         dynargs[1] = args[1];
381         return oraclize_query(datasource, dynargs, gaslimit);
382     }
383     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
384         bytes[] memory dynargs = new bytes[](3);
385         dynargs[0] = args[0];
386         dynargs[1] = args[1];
387         dynargs[2] = args[2];
388         return oraclize_query(datasource, dynargs);
389     }
390     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
391         bytes[] memory dynargs = new bytes[](3);
392         dynargs[0] = args[0];
393         dynargs[1] = args[1];
394         dynargs[2] = args[2];
395         return oraclize_query(timestamp, datasource, dynargs);
396     }
397     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
398         bytes[] memory dynargs = new bytes[](3);
399         dynargs[0] = args[0];
400         dynargs[1] = args[1];
401         dynargs[2] = args[2];
402         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
403     }
404     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
405         bytes[] memory dynargs = new bytes[](3);
406         dynargs[0] = args[0];
407         dynargs[1] = args[1];
408         dynargs[2] = args[2];
409         return oraclize_query(datasource, dynargs, gaslimit);
410     }
411 
412     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
413         bytes[] memory dynargs = new bytes[](4);
414         dynargs[0] = args[0];
415         dynargs[1] = args[1];
416         dynargs[2] = args[2];
417         dynargs[3] = args[3];
418         return oraclize_query(datasource, dynargs);
419     }
420     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
421         bytes[] memory dynargs = new bytes[](4);
422         dynargs[0] = args[0];
423         dynargs[1] = args[1];
424         dynargs[2] = args[2];
425         dynargs[3] = args[3];
426         return oraclize_query(timestamp, datasource, dynargs);
427     }
428     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
429         bytes[] memory dynargs = new bytes[](4);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         dynargs[2] = args[2];
433         dynargs[3] = args[3];
434         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
435     }
436     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
437         bytes[] memory dynargs = new bytes[](4);
438         dynargs[0] = args[0];
439         dynargs[1] = args[1];
440         dynargs[2] = args[2];
441         dynargs[3] = args[3];
442         return oraclize_query(datasource, dynargs, gaslimit);
443     }
444     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
445         bytes[] memory dynargs = new bytes[](5);
446         dynargs[0] = args[0];
447         dynargs[1] = args[1];
448         dynargs[2] = args[2];
449         dynargs[3] = args[3];
450         dynargs[4] = args[4];
451         return oraclize_query(datasource, dynargs);
452     }
453     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
454         bytes[] memory dynargs = new bytes[](5);
455         dynargs[0] = args[0];
456         dynargs[1] = args[1];
457         dynargs[2] = args[2];
458         dynargs[3] = args[3];
459         dynargs[4] = args[4];
460         return oraclize_query(timestamp, datasource, dynargs);
461     }
462     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
463         bytes[] memory dynargs = new bytes[](5);
464         dynargs[0] = args[0];
465         dynargs[1] = args[1];
466         dynargs[2] = args[2];
467         dynargs[3] = args[3];
468         dynargs[4] = args[4];
469         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
470     }
471     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472         bytes[] memory dynargs = new bytes[](5);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         dynargs[2] = args[2];
476         dynargs[3] = args[3];
477         dynargs[4] = args[4];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480 
481     function oraclize_cbAddress() oraclizeAPI internal returns (address){
482         return oraclize.cbAddress();
483     }
484     function oraclize_setProof(byte proofP) oraclizeAPI internal {
485         return oraclize.setProofType(proofP);
486     }
487     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
488         return oraclize.setCustomGasPrice(gasPrice);
489     }
490     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
491         return oraclize.setConfig(config);
492     }
493 
494     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
495         return oraclize.randomDS_getSessionPubKeyHash();
496     }
497 
498     function getCodeSize(address _addr) constant internal returns(uint _size) {
499         assembly {
500         _size := extcodesize(_addr)
501         }
502     }
503 
504     function parseAddr(string _a) internal returns (address){
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
524     function strCompare(string _a, string _b) internal returns (int) {
525         bytes memory a = bytes(_a);
526         bytes memory b = bytes(_b);
527         uint minLength = a.length;
528         if (b.length < minLength) minLength = b.length;
529         for (uint i = 0; i < minLength; i ++)
530         if (a[i] < b[i])
531         return -1;
532         else if (a[i] > b[i])
533         return 1;
534         if (a.length < b.length)
535         return -1;
536         else if (a.length > b.length)
537         return 1;
538         else
539         return 0;
540     }
541 
542     function indexOf(string _haystack, string _needle) internal returns (int) {
543         bytes memory h = bytes(_haystack);
544         bytes memory n = bytes(_needle);
545         if(h.length < 1 || n.length < 1 || (n.length > h.length))
546         return -1;
547         else if(h.length > (2**128 -1))
548         return -1;
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
562                     return int(i);
563                 }
564             }
565             return -1;
566         }
567     }
568 
569     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
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
586     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
587         return strConcat(_a, _b, _c, _d, "");
588     }
589 
590     function strConcat(string _a, string _b, string _c) internal returns (string) {
591         return strConcat(_a, _b, _c, "", "");
592     }
593 
594     function strConcat(string _a, string _b) internal returns (string) {
595         return strConcat(_a, _b, "", "", "");
596     }
597 
598     // parseInt
599     function parseInt(string _a) internal returns (uint) {
600         return parseInt(_a, 0);
601     }
602 
603     // parseInt(parseFloat*10^_b)
604     function parseInt(string _a, uint _b) internal returns (uint) {
605         bytes memory bresult = bytes(_a);
606         uint mint = 0;
607         bool decimals = false;
608         for (uint i=0; i<bresult.length; i++){
609             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
610                 if (decimals){
611                     if (_b == 0) break;
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
622     function uint2str(uint i) internal returns (string){
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
639     function stra2cbor(string[] arr) internal returns (bytes) {
640         uint arrlen = arr.length;
641 
642         // get correct cbor output length
643         uint outputlen = 0;
644         bytes[] memory elemArray = new bytes[](arrlen);
645         for (uint i = 0; i < arrlen; i++) {
646             elemArray[i] = (bytes(arr[i]));
647             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
648         }
649         uint ctr = 0;
650         uint cborlen = arrlen + 0x80;
651         outputlen += byte(cborlen).length;
652         bytes memory res = new bytes(outputlen);
653 
654         while (byte(cborlen).length > ctr) {
655             res[ctr] = byte(cborlen)[ctr];
656             ctr++;
657         }
658         for (i = 0; i < arrlen; i++) {
659             res[ctr] = 0x5F;
660             ctr++;
661             for (uint x = 0; x < elemArray[i].length; x++) {
662                 // if there's a bug with larger strings, this may be the culprit
663                 if (x % 23 == 0) {
664                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
665                     elemcborlen += 0x40;
666                     uint lctr = ctr;
667                     while (byte(elemcborlen).length > ctr - lctr) {
668                         res[ctr] = byte(elemcborlen)[ctr - lctr];
669                         ctr++;
670                     }
671                 }
672                 res[ctr] = elemArray[i][x];
673                 ctr++;
674             }
675             res[ctr] = 0xFF;
676             ctr++;
677         }
678         return res;
679     }
680 
681     function ba2cbor(bytes[] arr) internal returns (bytes) {
682         uint arrlen = arr.length;
683 
684         // get correct cbor output length
685         uint outputlen = 0;
686         bytes[] memory elemArray = new bytes[](arrlen);
687         for (uint i = 0; i < arrlen; i++) {
688             elemArray[i] = (bytes(arr[i]));
689             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
690         }
691         uint ctr = 0;
692         uint cborlen = arrlen + 0x80;
693         outputlen += byte(cborlen).length;
694         bytes memory res = new bytes(outputlen);
695 
696         while (byte(cborlen).length > ctr) {
697             res[ctr] = byte(cborlen)[ctr];
698             ctr++;
699         }
700         for (i = 0; i < arrlen; i++) {
701             res[ctr] = 0x5F;
702             ctr++;
703             for (uint x = 0; x < elemArray[i].length; x++) {
704                 // if there's a bug with larger strings, this may be the culprit
705                 if (x % 23 == 0) {
706                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
707                     elemcborlen += 0x40;
708                     uint lctr = ctr;
709                     while (byte(elemcborlen).length > ctr - lctr) {
710                         res[ctr] = byte(elemcborlen)[ctr - lctr];
711                         ctr++;
712                     }
713                 }
714                 res[ctr] = elemArray[i][x];
715                 ctr++;
716             }
717             res[ctr] = 0xFF;
718             ctr++;
719         }
720         return res;
721     }
722 
723 
724     string oraclize_network_name;
725     function oraclize_setNetworkName(string _network_name) internal {
726         oraclize_network_name = _network_name;
727     }
728 
729     function oraclize_getNetworkName() internal returns (string) {
730         return oraclize_network_name;
731     }
732 
733     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
734 //        if ((_nbytes == 0)||(_nbytes > 32)) throw;
735         require(_nbytes != 0 && _nbytes < 32);
736         bytes memory nbytes = new bytes(1);
737         nbytes[0] = byte(_nbytes);
738         bytes memory unonce = new bytes(32);
739         bytes memory sessionKeyHash = new bytes(32);
740         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
741         assembly {
742         mstore(unonce, 0x20)
743         mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
744         mstore(sessionKeyHash, 0x20)
745         mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
746         }
747         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
748         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
749         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
750         return queryId;
751     }
752 
753     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
754         oraclize_randomDS_args[queryId] = commitment;
755     }
756 
757     mapping(bytes32=>bytes32) oraclize_randomDS_args;
758     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
759 
760     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
761         bool sigok;
762         address signer;
763 
764         bytes32 sigr;
765         bytes32 sigs;
766 
767         bytes memory sigr_ = new bytes(32);
768         uint offset = 4+(uint(dersig[3]) - 0x20);
769         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
770         bytes memory sigs_ = new bytes(32);
771         offset += 32 + 2;
772         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
773 
774         assembly {
775         sigr := mload(add(sigr_, 32))
776         sigs := mload(add(sigs_, 32))
777         }
778 
779 
780         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
781         if (address(sha3(pubkey)) == signer) return true;
782         else {
783             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
784             return (address(sha3(pubkey)) == signer);
785         }
786     }
787 
788     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
789         bool sigok;
790 
791         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
792         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
793         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
794 
795         bytes memory appkey1_pubkey = new bytes(64);
796         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
797 
798         bytes memory tosign2 = new bytes(1+65+32);
799 //        tosign2[0] = 1; //role
800         tosign2[0] = 0x1; //role
801         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
802         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
803         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
804         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
805 
806         if (sigok == false) return false;
807 
808 
809         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
810         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
811 
812         bytes memory tosign3 = new bytes(1+65);
813         tosign3[0] = 0xFE;
814         copyBytes(proof, 3, 65, tosign3, 1);
815 
816         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
817         copyBytes(proof, 3+65, sig3.length, sig3, 0);
818 
819         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
820 
821         return sigok;
822     }
823 
824     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
825         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
826 //        if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
827         require(_proof[0] == "L" && _proof[1] == "P" && _proof[2] == 1);
828 
829         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
830 //        if (proofVerified == false) throw;
831         require(proofVerified == true);
832 
833         _;
834     }
835 
836     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
837         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
838         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
839 
840         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
841         if (proofVerified == false) return 2;
842 
843         return 0;
844     }
845 
846     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
847         bool match_ = true;
848 
849 //        for (var i=0; i<prefix.length; i++){
850         for (var i=uint8(0); i<prefix.length; i++){
851             if (content[i] != prefix[i]) match_ = false;
852         }
853 
854         return match_;
855     }
856 
857     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
858         bool checkok;
859 
860 
861         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
862         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
863         bytes memory keyhash = new bytes(32);
864         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
865         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
866         if (checkok == false) return false;
867 
868         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
869         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
870 
871 
872         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
873         checkok = matchBytes32Prefix(sha256(sig1), result);
874         if (checkok == false) return false;
875 
876 
877         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
878         // This is to verify that the computed args match with the ones specified in the query.
879         bytes memory commitmentSlice1 = new bytes(8+1+32);
880         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
881 
882         bytes memory sessionPubkey = new bytes(64);
883         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
884         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
885 
886         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
887         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
888             delete oraclize_randomDS_args[queryId];
889         } else return false;
890 
891 
892         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
893         bytes memory tosign1 = new bytes(32+8+1+32);
894         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
895         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
896         if (checkok == false) return false;
897 
898         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
899         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
900             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
901         }
902 
903         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
904     }
905 
906 
907     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
908     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
909         uint minLength = length + toOffset;
910 
911 //        if (to.length < minLength) {
912             // Buffer too small
913 //            throw; // Should be a better way?
914 //        }
915         require(to.length > minLength);
916 
917         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
918         uint i = 32 + fromOffset;
919         uint j = 32 + toOffset;
920 
921         while (i < (32 + fromOffset + length)) {
922             assembly {
923             let tmp := mload(add(from, i))
924             mstore(add(to, j), tmp)
925             }
926             i += 32;
927             j += 32;
928         }
929 
930         return to;
931     }
932 
933     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
934     // Duplicate Solidity's ecrecover, but catching the CALL return value
935     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
936         // We do our own memory management here. Solidity uses memory offset
937         // 0x40 to store the current end of memory. We write past it (as
938         // writes are memory extensions), but don't update the offset so
939         // Solidity will reuse it. The memory used here is only needed for
940         // this context.
941 
942         // FIXME: inline assembly can't access return values
943         bool ret;
944         address addr;
945 
946         assembly {
947         let size := mload(0x40)
948         mstore(size, hash)
949         mstore(add(size, 32), v)
950         mstore(add(size, 64), r)
951         mstore(add(size, 96), s)
952 
953         // NOTE: we can reuse the request memory because we deal with
954         //       the return code
955         ret := call(3000, 1, 0, size, 128, size, 32)
956         addr := mload(size)
957         }
958 
959         return (ret, addr);
960     }
961 
962     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
963     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
964         bytes32 r;
965         bytes32 s;
966         uint8 v;
967 
968         if (sig.length != 65)
969         return (false, 0);
970 
971         // The signature format is a compact form of:
972         //   {bytes32 r}{bytes32 s}{uint8 v}
973         // Compact means, uint8 is not padded to 32 bytes.
974         assembly {
975         r := mload(add(sig, 32))
976         s := mload(add(sig, 64))
977 
978         // Here we are loading the last 32 bytes. We exploit the fact that
979         // 'mload' will pad with zeroes if we overread.
980         // There is no 'mload8' to do this, but that would be nicer.
981         v := byte(0, mload(add(sig, 96)))
982 
983         // Alternative solution:
984         // 'byte' is not working due to the Solidity parser, so lets
985         // use the second best option, 'and'
986         // v := and(mload(add(sig, 65)), 255)
987     }
988 
989 // albeit non-transactional signatures are not specified by the YP, one would expect it
990 // to match the YP range of [27, 28]
991 //
992 // geth uses [0, 1] and some clients have followed. This might change, see:
993 //  https://github.com/ethereum/go-ethereum/issues/2053
994 if (v < 27)
995 v += 27;
996 
997 if (v != 27 && v != 28)
998 return (false, 0);
999 
1000 return safer_ecrecover(hash, v, r, s);
1001 }
1002 
1003 }
1004 // </ORACLIZE_API>
1005 /* solhint-enable */
1006 
1007 
1008 
1009 
1010 /**
1011  * @title SafeMath
1012  * @dev Math operations with safety checks that throw on error
1013  */
1014 library SafeMath {
1015     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1016         uint256 c = a * b;
1017         assert(a == 0 || c / a == b);
1018         return c;
1019     }
1020 
1021     function div(uint256 a, uint256 b) internal constant returns (uint256) {
1022         // assert(b > 0); // Solidity automatically throws when dividing by 0
1023         uint256 c = a / b;
1024         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1025         return c;
1026     }
1027 
1028     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1029         assert(b <= a);
1030         return a - b;
1031     }
1032 
1033     function add(uint256 a, uint256 b) internal constant returns (uint256) {
1034         uint256 c = a + b;
1035         assert(c >= a);
1036         return c;
1037     }
1038    
1039 }
1040 
1041 
1042 contract Ownable {
1043     //Variables
1044     address public owner;
1045 
1046     address public newOwner;
1047     address[] public allOwners;
1048     //    Modifiers
1049     /**
1050      * @dev Throws if called by any account other than the owner.
1051      */
1052     modifier onlyOwner() {
1053         require(msg.sender == owner);
1054         _;
1055     }
1056 
1057     /**
1058      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1059      * account.
1060      */
1061     function Ownable() public {
1062         owner = msg.sender;
1063     }
1064 
1065     /**
1066      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1067      * @param _newOwner The address to transfer ownership to.
1068      */
1069     function transferOwnership(address _newOwner) public onlyOwner {
1070         require(_newOwner != address(0));
1071         newOwner = _newOwner;
1072     }
1073 
1074     function acceptOwnership() public {
1075         if (msg.sender == newOwner) {
1076             owner = newOwner;
1077         }
1078     }
1079     
1080     mapping (address => bool) ownerslist;
1081     
1082     function addToOwnerlist(address _address) public onlyOwner returns(bool) {
1083         allOwners.push(_address);
1084         ownerslist[_address] = true;
1085         return true;
1086     }
1087     function removeFromOwnerlist(address _address) public onlyOwner returns (bool){
1088         require (ownerslist[_address]);
1089         ownerslist[_address] = false;
1090         for(uint i = 0; i<allOwners.length;i++){
1091             if (allOwners[i] == _address){
1092                 allOwners[i] == 0x1;
1093             }
1094         }
1095         return true;
1096     }
1097 }
1098    
1099   contract CNFTOKEN is Ownable, usingOraclize {
1100        // Triggered when tokens are transferred.
1101       event Transfer(address indexed _from, address indexed _to, uint256 _value);
1102    
1103       // Triggered whenever approve(address _spender, uint256 _value) is called.
1104       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
1105       
1106     event NewOraclizeQuery(string description);
1107 
1108     event NewNodePriceTicker(string price);
1109       
1110       string public constant symbol = "CNF";
1111       string public constant name = "CNF";
1112       uint8 public constant decimals = 8;
1113       uint256 _totalSupply = 10000000*pow(10,decimals);
1114       
1115       uint public EthToUsd = 2150537634408602;
1116       
1117       uint public priceUpdateAt;
1118       
1119       using SafeMath for uint;
1120       
1121       // Owner of this contract
1122       address public owner;
1123     
1124       // Balances for each account
1125       mapping(address => uint256) balances;
1126    
1127       // Owner of account approves the transfer of an amount to another account
1128       mapping(address => mapping (address => uint256)) allowed;
1129    
1130     function pow(uint256 a, uint256 b) constant returns (uint256){
1131         return (a**b);
1132     }
1133       
1134    
1135       function totalSupply() public constant returns (uint256) {
1136            return _totalSupply;
1137       }
1138    
1139       function balanceOf(address _address) public constant returns (uint256 balance) {
1140           return balances[_address];
1141       }
1142    
1143       function transfer(address _to, uint256 _amount) public returns (bool success) {
1144         //   require(!locked);
1145         require(this != _to);
1146           if (balances[msg.sender] >= _amount 
1147               && _amount > 0
1148               && balances[_to] + _amount > balances[_to]) {
1149               balances[msg.sender] -= _amount;
1150               balances[_to] += _amount;
1151               Transfer(msg.sender, _to, _amount);
1152               return true;
1153           } else {
1154               return false;
1155           }
1156       }
1157 
1158       function transferFrom(
1159           address _from,
1160           address _to,
1161           uint256 _amount
1162      )public returns (bool success) {
1163         //  require(!locked);
1164          require(this != _to);
1165          
1166          if (balances[_from] >= _amount
1167              && allowed[_from][msg.sender] >= _amount
1168              && _amount > 0
1169              && balances[_to] + _amount > balances[_to]) {
1170              balances[_from] -= _amount;
1171              allowed[_from][msg.sender] -= _amount;
1172              balances[_to] += _amount;
1173              Transfer(_from, _to, _amount);
1174              return true;
1175          } else {
1176              return false;
1177          }
1178      }
1179   
1180      function approve(address _spender, uint256 _amount)public returns (bool success) {
1181          allowed[msg.sender][_spender] = _amount;
1182          Approval(msg.sender, _spender, _amount);
1183          return true;
1184      }
1185   
1186      function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
1187          return allowed[_owner][_spender];
1188      }
1189 
1190     struct ICO{
1191         uint start;
1192         uint finish;
1193         uint bonusTime;
1194     }
1195     
1196     ICO[] public icoPhases;
1197     
1198     // Constructor
1199       function CNFTOKEN() public {
1200         owner = msg.sender;
1201         balances[this] = _totalSupply;
1202         addToOwnerlist(msg.sender);
1203         icoPhases.push(ICO(1515412800,1516017600,30));
1204         icoPhases.push(ICO(1516017600,1516622400,20));
1205         icoPhases.push(ICO(1516622400,1517227200,15));
1206         icoPhases.push(ICO(1517227200,1517745600,10));
1207         icoPhases.push(ICO(1517745600,1518004800,0));
1208         
1209         priceUpdateAt = now;
1210         
1211         oraclize_setNetwork(networkID_auto);
1212         oraclize = OraclizeI(OAR.getAddress());
1213       }
1214     
1215     function() public payable{
1216         require(now>=startPreIco);
1217         require(now<=icoPhases[icoPhases.length - 1].finish);
1218         require(buy(msg.sender,msg.value));
1219      }
1220      
1221      function buy(address _address, uint _value) internal returns (bool){
1222          uint _amount = getAmountWithBonus(_value);
1223          if((priceUpdateAt+3600) < now){
1224              update();
1225             priceUpdateAt = now;
1226 
1227          }
1228         
1229         uint minInvest = uint(50).mul(pow(10,decimals));
1230         require(_amount>=minInvest);
1231          
1232          if (balances[this] >= _amount){
1233              balances[this] = balances[this].sub(_amount);
1234              balances[_address] = balances[_address].add(_amount);
1235              Transfer(this,_address,_amount);
1236              return true;
1237          }
1238          return false;
1239      }
1240      
1241      
1242      function setCourse(uint course) public onlyOwner{
1243          EthToUsd = course;
1244      }
1245      
1246      
1247      function sendEther(address _address, uint256 _value) public onlyOwner returns(bool){
1248          if (_value > this.balance){
1249              _value = this.balance;
1250          }
1251          _address.transfer(_value);
1252      }
1253      function burnUnsoldTokens() public onlyOwner{
1254          _totalSupply = _totalSupply.sub(balances[this]);
1255          balances[this] = 0;
1256      }
1257      
1258     //bonuses 
1259     function getTokenWithBonus(uint _token) constant returns(uint){
1260          uint bonus = preIcoBonus(_token,block.timestamp).add(IcoBonus(block.timestamp));
1261          return _token.add(_token.mul(bonus).div(100));
1262      }
1263     
1264     function getAmountWithBonus(uint _amount) constant returns(uint){
1265         uint256 amount = _amount.mul(pow(10,decimals)).div(EthToUsd);
1266         return getTokenWithBonus(amount);
1267         
1268     }
1269     
1270     function IcoBonus(uint time) constant returns(uint){
1271         if (time >= 1517745600) return 0;
1272         if (time >= 1517227200) return 10;
1273         if (time >= 1516622400) return 15;
1274         if (time >= 1516017600) return 20;
1275         if (time >= 1515412800) return 30;
1276     }
1277 
1278     uint startPreIco = 1512388800;
1279     uint finishPreIco = 1513857600;
1280     
1281     function preIcoBonus(uint amount, uint time) constant returns(uint){
1282         if ((time>startPreIco) &&(time<finishPreIco)){
1283         if(amount >= uint(9000).mul(pow(10,decimals))){
1284         return 70;}
1285         if(amount>=uint(3000).mul(pow(10,decimals))){
1286         return 50;
1287         }
1288         return 30; 
1289         }
1290         return 0;
1291     }
1292      
1293      
1294      //Oraclize update
1295      function update() internal {
1296         if (oraclize_getPrice("URL") > this.balance) {
1297             NewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1298         } else {
1299             NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1300             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1301         }
1302     }
1303     
1304     function __callback(bytes32, string _result, bytes) public {
1305         require(msg.sender == oraclize_cbAddress());
1306 
1307         uint256 price = uint256(10 ** 23).div(parseInt(_result, 5));
1308 
1309         require(price > 0);
1310 
1311         EthToUsd = price;
1312         
1313         NewNodePriceTicker(_result);
1314     }
1315 }