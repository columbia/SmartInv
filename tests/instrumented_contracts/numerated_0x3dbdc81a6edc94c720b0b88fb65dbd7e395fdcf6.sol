1 /*
2 Copyright (c) 2015-2016 Oraclize SRL
3 Copyright (c) 2016-2017 Oraclize LTD
4 */
5 
6 /*
7 Oraclize Connector v1.2.0
8 */
9 
10 // 'compressed' alternative, where all modifiers have been changed to FUNCTIONS
11 // which is cheaper for deployment, potentially cheaper execution
12 
13 pragma solidity ^0.4.11;
14 
15 contract Oraclize {
16     mapping (address => uint) reqc;
17 
18     mapping (address => byte) public cbAddresses;
19 
20     mapping (address => bool) public offchainPayment;
21 
22     event Log1(address sender, bytes32 cid, uint timestamp, string datasource, string arg, uint gaslimit, byte proofType, uint gasPrice);
23     event Log2(address sender, bytes32 cid, uint timestamp, string datasource, string arg1, string arg2, uint gaslimit, byte proofType, uint gasPrice);
24     event LogN(address sender, bytes32 cid, uint timestamp, string datasource, bytes args, uint gaslimit, byte proofType, uint gasPrice);
25     event Log1_fnc(address sender, bytes32 cid, uint timestamp, string datasource, string arg, function() external callback, uint gaslimit, byte proofType, uint gasPrice);
26     event Log2_fnc(address sender, bytes32 cid, uint timestamp, string datasource, string arg1, string arg2, function() external callback, uint gaslimit, byte proofType, uint gasPrice);
27     event LogN_fnc(address sender, bytes32 cid, uint timestamp, string datasource, bytes args, function() external callback, uint gaslimit, byte proofType, uint gasPrice);
28 
29     event Emit_OffchainPaymentFlag(address indexed idx_sender, address sender, bool indexed idx_flag, bool flag);
30 
31     address owner;
32     address paymentFlagger;
33 
34     function changeAdmin(address _newAdmin)
35     external
36     {
37         onlyadmin();
38         owner = _newAdmin;
39     }
40 
41     function changePaymentFlagger(address _newFlagger)
42     external
43     {
44         onlyadmin();
45         paymentFlagger = _newFlagger;
46     }
47 
48     function addCbAddress(address newCbAddress, byte addressType)
49     external
50     {
51         onlyadmin();
52         //bytes memory nil = '';
53         addCbAddress(newCbAddress, addressType, hex'');
54     }
55 
56     // proof is currently a placeholder for when associated proof for addressType is added
57     function addCbAddress(address newCbAddress, byte addressType, bytes proof)
58     public
59     {
60         onlyadmin();
61         cbAddresses[newCbAddress] = addressType;
62     }
63 
64     function removeCbAddress(address newCbAddress)
65     external
66     {
67         onlyadmin();
68         delete cbAddresses[newCbAddress];
69     }
70 
71     function cbAddress()
72     constant
73     returns (address _cbAddress)
74     {
75         if (cbAddresses[tx.origin] != 0)
76             _cbAddress = tx.origin;
77     }
78 
79     function addDSource(string dsname, uint multiplier)
80     external
81     {
82         addDSource(dsname, 0x00, multiplier);
83     }
84 
85     function addDSource(string dsname, byte proofType, uint multiplier)
86     public
87     {
88         onlyadmin();
89         bytes32 dsname_hash = sha3(dsname, proofType);
90         dsources[dsources.length++] = dsname_hash;
91         price_multiplier[dsname_hash] = multiplier;
92     }
93 
94     // Utilized by bridge
95     function multiAddDSource(bytes32[] dsHash, uint256[] multiplier)
96     external
97     {
98         onlyadmin();
99         // dsHash -> sha3(DATASOURCE_NAME, PROOF_TYPE);
100         for (uint i=0; i<dsHash.length; i++) {
101             dsources[dsources.length++] = dsHash[i];
102             price_multiplier[dsHash[i]] = multiplier[i];
103         }
104     }
105 
106     function multisetProofType(uint[] _proofType, address[] _addr)
107     external
108     {
109         onlyadmin();
110         for (uint i=0; i<_addr.length; i++) addr_proofType[_addr[i]] = byte(_proofType[i]);
111     }
112 
113     function multisetCustomGasPrice(uint[] _gasPrice, address[] _addr)
114     external
115     {
116         onlyadmin();
117         for (uint i=0; i<_addr.length; i++) addr_gasPrice[_addr[i]] = _gasPrice[i];
118     }
119 
120     uint gasprice = 20000000000;
121 
122     function setGasPrice(uint newgasprice)
123     external
124     {
125         onlyadmin();
126         gasprice = newgasprice;
127     }
128 
129     function setBasePrice(uint new_baseprice)
130     external
131     { //0.001 usd in ether
132         onlyadmin();
133         baseprice = new_baseprice;
134         for (uint i=0; i<dsources.length; i++) price[dsources[i]] = new_baseprice*price_multiplier[dsources[i]];
135     }
136 
137     function setBasePrice(uint new_baseprice, bytes proofID)
138     external
139     { //0.001 usd in ether
140         onlyadmin();
141         baseprice = new_baseprice;
142         for (uint i=0; i<dsources.length; i++) price[dsources[i]] = new_baseprice*price_multiplier[dsources[i]];
143     }
144 
145     function setOffchainPayment(address _addr, bool _flag)
146     external
147     {
148       if (msg.sender != paymentFlagger) throw;
149       offchainPayment[_addr] = _flag;
150       Emit_OffchainPaymentFlag(_addr, _addr, _flag, _flag);
151     }
152 
153     function withdrawFunds(address _addr)
154     external
155     {
156         onlyadmin();
157         _addr.send(this.balance);
158     }
159 
160     // unnecessary?
161     //function() {}
162 
163     function Oraclize() {
164         owner = msg.sender;
165     }
166 
167     // Pesudo-modifiers
168 
169     function onlyadmin()
170     private {
171         if (msg.sender != owner) throw;
172     }
173 
174     function costs(string datasource, uint gaslimit)
175     private
176     returns (uint price) {
177         price = getPrice(datasource, gaslimit, msg.sender);
178 
179         if (msg.value >= price){
180             uint diff = msg.value - price;
181             if (diff > 0) {
182                 // added for correct query cost to be returned
183                 if(!msg.sender.send(diff)) {
184                     throw;
185                 }
186             }
187         } else throw;
188     }
189 
190     mapping (address => byte) addr_proofType;
191     mapping (address => uint) addr_gasPrice;
192     uint public baseprice;
193     mapping (bytes32 => uint) price;
194     mapping (bytes32 => uint) price_multiplier;
195     bytes32[] dsources;
196 
197     bytes32[] public randomDS_sessionPubKeysHash;
198 
199     function randomDS_updateSessionPubKeysHash(bytes32[] _newSessionPubKeysHash)
200     external
201     {
202         onlyadmin();
203         randomDS_sessionPubKeysHash.length = 0;
204         for (uint i=0; i<_newSessionPubKeysHash.length; i++) randomDS_sessionPubKeysHash.push(_newSessionPubKeysHash[i]);
205     }
206 
207     function randomDS_getSessionPubKeyHash()
208     external
209     constant
210     returns (bytes32) {
211         uint i = uint(sha3(reqc[msg.sender]))%randomDS_sessionPubKeysHash.length;
212         return randomDS_sessionPubKeysHash[i];
213     }
214 
215     function setProofType(byte _proofType)
216     external
217     {
218         addr_proofType[msg.sender] = _proofType;
219     }
220 
221     function setCustomGasPrice(uint _gasPrice)
222     external
223     {
224         addr_gasPrice[msg.sender] = _gasPrice;
225     }
226 
227     function getPrice(string _datasource)
228     public
229     returns (uint _dsprice)
230     {
231         return getPrice(_datasource, msg.sender);
232     }
233 
234     function getPrice(string _datasource, uint _gaslimit)
235     public
236     returns (uint _dsprice)
237     {
238         return getPrice(_datasource, _gaslimit, msg.sender);
239     }
240 
241     function getPrice(string _datasource, address _addr)
242     private
243     returns (uint _dsprice)
244     {
245         return getPrice(_datasource, 200000, _addr);
246     }
247 
248     function getPrice(string _datasource, uint _gaslimit, address _addr)
249     private
250     returns (uint _dsprice)
251     {
252         uint gasprice_ = addr_gasPrice[_addr];
253         if (
254                 (offchainPayment[_addr])
255             ||(
256                 (_gaslimit <= 200000)&&
257                 (reqc[_addr] == 0)&&
258                 (gasprice_ <= gasprice)&&
259                 (tx.origin != cbAddress())
260             )
261         ) return 0;
262 
263         if (gasprice_ == 0) gasprice_ = gasprice;
264         _dsprice = price[sha3(_datasource, addr_proofType[_addr])];
265         _dsprice += _gaslimit*gasprice_;
266         return _dsprice;
267     }
268 
269     function getCodeSize(address _addr)
270     private
271     constant
272     returns(uint _size)
273     {
274         assembly {
275             _size := extcodesize(_addr)
276         }
277     }
278 
279     function query(string _datasource, string _arg)
280     payable
281     external
282     returns (bytes32 _id)
283     {
284         return query1(0, _datasource, _arg, 200000);
285     }
286 
287     function query1(string _datasource, string _arg)
288     payable
289     external
290     returns (bytes32 _id)
291     {
292         return query1(0, _datasource, _arg, 200000);
293     }
294 
295     function query2(string _datasource, string _arg1, string _arg2)
296     payable
297     external
298     returns (bytes32 _id)
299     {
300         return query2(0, _datasource, _arg1, _arg2, 200000);
301     }
302 
303     function queryN(string _datasource, bytes _args)
304     payable
305     external
306     returns (bytes32 _id)
307     {
308         return queryN(0, _datasource, _args, 200000);
309     }
310 
311     function query(uint _timestamp, string _datasource, string _arg)
312     payable
313     external
314     returns (bytes32 _id)
315     {
316         return query1(_timestamp, _datasource, _arg, 200000);
317     }
318 
319     function query1(uint _timestamp, string _datasource, string _arg)
320     payable
321     external
322     returns (bytes32 _id)
323     {
324         return query1(_timestamp, _datasource, _arg, 200000);
325     }
326 
327     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2)
328     payable
329     external
330     returns (bytes32 _id)
331     {
332         return query2(_timestamp, _datasource, _arg1, _arg2, 200000);
333     }
334 
335     function queryN(uint _timestamp, string _datasource, bytes _args)
336     payable
337     external
338     returns (bytes32 _id)
339     {
340         return queryN(_timestamp, _datasource, _args, 200000);
341     }
342 
343 /*  Needless?
344     function query(uint _timestamp, string _datasource, string _arg, uint _gaslimit)
345     payable
346     external
347     returns (bytes32 _id)
348     {
349         return query1(_timestamp, _datasource, _arg, _gaslimit);
350     }
351 */
352     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit)
353     payable
354     external
355     returns (bytes32 _id)
356     {
357         return query1(_timestamp, _datasource, _arg, _gaslimit);
358     }
359 
360     function query1_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit)
361     payable
362     external
363     returns (bytes32 _id)
364     {
365         return query1(_timestamp, _datasource, _arg, _gaslimit);
366     }
367 
368     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit)
369     payable
370     external
371     returns (bytes32 _id)
372     {
373         return query2(_timestamp, _datasource, _arg1, _arg2, _gaslimit);
374     }
375 
376     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _args, uint _gaslimit)
377     payable
378     external
379     returns (bytes32 _id)
380     {
381         return queryN(_timestamp, _datasource, _args, _gaslimit);
382     }
383 
384     function query1(uint _timestamp, string _datasource, string _arg, uint _gaslimit)
385     payable
386     public
387     returns (bytes32 _id)
388     {
389         costs(_datasource, _gaslimit);
390     	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
391 
392         _id = sha3(this, msg.sender, reqc[msg.sender]);
393         reqc[msg.sender]++;
394         Log1(msg.sender, _id, _timestamp, _datasource, _arg, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
395         return _id;
396     }
397 
398     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit)
399     payable
400     public
401     returns (bytes32 _id)
402     {
403         costs(_datasource, _gaslimit);
404     	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
405 
406         _id = sha3(this, msg.sender, reqc[msg.sender]);
407         reqc[msg.sender]++;
408         Log2(msg.sender, _id, _timestamp, _datasource, _arg1, _arg2, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
409         return _id;
410     }
411 
412     function queryN(uint _timestamp, string _datasource, bytes _args, uint _gaslimit)
413     payable
414     public
415     returns (bytes32 _id)
416     {
417         costs(_datasource, _gaslimit);
418     	if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)) throw;
419 
420         _id = sha3(this, msg.sender, reqc[msg.sender]);
421         reqc[msg.sender]++;
422         LogN(msg.sender, _id, _timestamp, _datasource, _args, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
423         return _id;
424     }
425 
426     function query1_fnc(uint _timestamp, string _datasource, string _arg, function() external _fnc, uint _gaslimit)
427     payable
428     public
429     returns (bytes32 _id)
430     {
431         costs(_datasource, _gaslimit);
432         if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)||address(_fnc) != msg.sender) throw;
433 
434         _id = sha3(this, msg.sender, reqc[msg.sender]);
435         reqc[msg.sender]++;
436         Log1_fnc(msg.sender, _id, _timestamp, _datasource, _arg, _fnc, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
437         return _id;
438     }
439 
440     function query2_fnc(uint _timestamp, string _datasource, string _arg1, string _arg2, function() external _fnc, uint _gaslimit)
441     payable
442     public
443     returns (bytes32 _id)
444     {
445         costs(_datasource, _gaslimit);
446         if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)||address(_fnc) != msg.sender) throw;
447 
448         _id = sha3(this, msg.sender, reqc[msg.sender]);
449         reqc[msg.sender]++;
450         Log2_fnc(msg.sender, _id, _timestamp, _datasource, _arg1, _arg2, _fnc,  _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
451         return _id;
452     }
453 
454     function queryN_fnc(uint _timestamp, string _datasource, bytes _args, function() external _fnc, uint _gaslimit)
455     payable
456     public
457     returns (bytes32 _id)
458     {
459         costs(_datasource, _gaslimit);
460         if ((_timestamp > now+3600*24*60)||(_gaslimit > block.gaslimit)||address(_fnc) != msg.sender) throw;
461 
462         _id = sha3(this, msg.sender, reqc[msg.sender]);
463         reqc[msg.sender]++;
464         LogN_fnc(msg.sender, _id, _timestamp, _datasource, _args, _fnc, _gaslimit, addr_proofType[msg.sender], addr_gasPrice[msg.sender]);
465         return _id;
466     }
467 }