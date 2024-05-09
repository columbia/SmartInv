1 contract EtherTreasuryInterface {
2     function withdraw(address _to, uint _value) returns(bool);
3     function withdrawWithReference(address _to, uint _value, string _reference) returns(bool);
4 }
5 
6 contract MultiAsset {
7     function owner(bytes32 _symbol) constant returns(address);
8     function isCreated(bytes32 _symbol) constant returns(bool);
9     function totalSupply(bytes32 _symbol) constant returns(uint);
10     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
11     function transfer(address _to, uint _value, bytes32 _symbol) returns(bool);
12     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
13     function proxyTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool);
14     function proxyApprove(address _spender, uint _value, bytes32 _symbol) returns(bool);
15     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
16     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
17     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
18     function proxySetCosignerAddress(address _address, bytes32 _symbol) returns(bool);
19 }
20 
21 contract Asset {
22     event Transfer(address indexed from, address indexed to, uint value);
23     event Approve(address indexed from, address indexed spender, uint value);
24 
25     MultiAsset public multiAsset;
26     bytes32 public symbol;
27 
28     function init(address _multiAsset, bytes32 _symbol) returns(bool) {
29         MultiAsset ma = MultiAsset(_multiAsset);
30         if (address(multiAsset) != 0x0 || !ma.isCreated(_symbol)) {
31             return false;
32         }
33         multiAsset = ma;
34         symbol = _symbol;
35         return true;
36     }
37 
38     modifier onlyMultiAsset() {
39         if (msg.sender == address(multiAsset)) {
40             _
41         }
42     }
43 
44     function totalSupply() constant returns(uint) {
45         return multiAsset.totalSupply(symbol);
46     }
47 
48     function balanceOf(address _owner) constant returns(uint) {
49         return multiAsset.balanceOf(_owner, symbol);
50     }
51 
52     function allowance(address _from, address _spender) constant returns(uint) {
53         return multiAsset.allowance(_from, _spender, symbol);
54     }
55 
56     function transfer(address _to, uint _value) returns(bool) {
57         return transferWithReference(_to, _value, "");
58     }
59 
60     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
61         if (!multiAsset.proxyTransferWithReference(_to, _value, symbol, _reference)) {
62             return false;
63         }
64         return true;
65     }
66 
67     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
68         return transferToICAPWithReference(_icap, _value, "");
69     }
70 
71     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
72         if (!multiAsset.proxyTransferToICAPWithReference(_icap, _value, _reference)) {
73             return false;
74         }
75         return true;
76     }
77     
78     function transferFrom(address _from, address _to, uint _value) returns(bool) {
79         return transferFromWithReference(_from, _to, _value, "");
80     }
81 
82     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
83         if (!multiAsset.proxyTransferFromWithReference(_from, _to, _value, symbol, _reference)) {
84             return false;
85         }
86         return true;
87     }
88 
89     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
90         return transferFromToICAPWithReference(_from, _icap, _value, "");
91     }
92 
93     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
94         if (!multiAsset.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference)) {
95             return false;
96         }
97         return true;
98     }
99 
100     function approve(address _spender, uint _value) returns(bool) {
101         if (!multiAsset.proxyApprove(_spender, _value, symbol)) {
102             return false;
103         }
104         return true;
105     }
106 
107     function setCosignerAddress(address _cosigner) returns(bool) {
108         if (!multiAsset.proxySetCosignerAddress(_cosigner, symbol)) {
109             return false;
110         }
111         return true;
112     }
113 
114     function emitTransfer(address _from, address _to, uint _value) onlyMultiAsset() {
115         Transfer(_from, _to, _value);
116     }
117 
118     function emitApprove(address _from, address _spender, uint _value) onlyMultiAsset() {
119         Approve(_from, _spender, _value);
120     }
121 
122     function sendToOwner() returns(bool) {
123         return multiAsset.transfer(multiAsset.owner(symbol), balanceOf(address(this)), symbol);
124     }
125 }
126 
127 contract Ambi {
128     function getNodeAddress(bytes32) constant returns(address);
129     function addNode(bytes32, address) external returns(bool);    
130     function hasRelation(bytes32, bytes32, address) constant returns(bool);
131 }
132 
133 contract AmbiEnabled {
134     Ambi ambiC;
135     bytes32 public name;
136 
137     modifier checkAccess(bytes32 _role) {
138         if(address(ambiC) != 0x0 && ambiC.hasRelation(name, _role, msg.sender)){
139             _
140         }
141     }
142     
143     function getAddress(bytes32 _name) constant returns (address) {
144         return ambiC.getNodeAddress(_name);
145     }
146 
147     function setAmbiAddress(address _ambi, bytes32 _name) returns (bool){
148         if(address(ambiC) != 0x0){
149             return false;
150         }
151         Ambi ambiContract = Ambi(_ambi);
152         if(ambiContract.getNodeAddress(_name)!=address(this)) {
153             bool isNode = ambiContract.addNode(_name, address(this));
154             if (!isNode){
155                 return false;
156             }   
157         }
158         name = _name;
159         ambiC = ambiContract;
160         return true;
161     }
162 
163     function remove() checkAccess("owner") {
164         suicide(msg.sender);
165     }
166 }
167 
168 contract OpenDollar is Asset, AmbiEnabled {
169     uint public txGasPriceLimit = 21000000000;
170     uint public refundGas = 40000;
171     uint public transferCallGas = 21000;
172     uint public transferWithReferenceCallGas = 21000;
173     uint public transferFromCallGas = 21000;
174     uint public transferFromWithReferenceCallGas = 21000;
175     uint public transferToICAPCallGas = 21000;
176     uint public transferToICAPWithReferenceCallGas = 21000;
177     uint public transferFromToICAPCallGas = 21000;
178     uint public transferFromToICAPWithReferenceCallGas = 21000;
179     uint public approveCallGas = 21000;
180     uint public forwardCallGas = 21000;
181     uint public setCosignerCallGas = 21000;
182     EtherTreasuryInterface public treasury;
183     mapping(uint32 => address) public allowedForwards;
184 
185     function updateRefundGas() checkAccess("setup") returns(uint) {
186         uint startGas = msg.gas;
187         uint refund = (startGas - msg.gas + refundGas) * tx.gasprice;
188         if (tx.gasprice > txGasPriceLimit) {
189             return 0;
190         }
191         if (!_refund(1)) {
192             return 0;
193         }
194         refundGas = startGas - msg.gas;
195         return refundGas;
196     }
197 
198     function setOperationsCallGas
199         (
200             uint _transfer,
201             uint _transferFrom,
202             uint _transferToICAP,
203             uint _transferFromToICAP,
204             uint _transferWithReference,
205             uint _transferFromWithReference,
206             uint _transferToICAPWithReference,
207             uint _transferFromToICAPWithReference,
208             uint _approve,
209             uint _forward,
210             uint _setCosigner
211         ) checkAccess("setup") returns(bool)
212     {
213         transferCallGas = _transfer;
214         transferFromCallGas = _transferFrom;
215         transferToICAPCallGas = _transferToICAP;
216         transferFromToICAPCallGas = _transferFromToICAP;
217         transferWithReferenceCallGas = _transferWithReference;
218         transferFromWithReferenceCallGas = _transferFromWithReference;
219         transferToICAPWithReferenceCallGas = _transferToICAPWithReference;
220         transferFromToICAPWithReferenceCallGas = _transferFromToICAPWithReference;
221         approveCallGas = _approve;
222         forwardCallGas = _forward;
223         setCosignerCallGas = _setCosigner;
224         return true;
225     }
226 
227     function setupTreasury(address _treasury, uint _txGasPriceLimit) checkAccess("admin") returns(bool) {
228         if (_txGasPriceLimit == 0) {
229             return false;
230         }
231         treasury = EtherTreasuryInterface(_treasury);
232         txGasPriceLimit = _txGasPriceLimit;
233         if (msg.value > 0 && !address(treasury).send(msg.value)) {
234             throw;
235         }
236         return true;
237     }
238 
239     function setForward(bytes4 _msgSig, address _forward) checkAccess("admin") returns(bool) {
240         allowedForwards[uint32(_msgSig)] = _forward;
241         return true;
242     }
243 
244     function _stringGas(string _string) constant internal returns(uint) {
245         return bytes(_string).length * 75;
246     }
247 
248     function _applyRefund(uint _startGas) internal returns(bool) {
249         if (tx.gasprice > txGasPriceLimit) {
250             return false;
251         }
252         uint refund = (_startGas - msg.gas + refundGas) * tx.gasprice;
253         return _refund(refund);
254     }
255 
256     function _refund(uint _value) internal returns(bool) {
257         return treasury.withdraw(tx.origin, _value);
258     }
259 
260     function _transfer(address _to, uint _value) internal returns(bool, bool) {
261         uint startGas = msg.gas + transferCallGas;
262         if (!multiAsset.proxyTransferWithReference(_to, _value, symbol, "")) {
263             return (false, false);
264         }
265         return (true, _applyRefund(startGas));
266     }
267 
268     function _transferFrom(address _from, address _to, uint _value) internal returns(bool, bool) {
269         uint startGas = msg.gas + transferFromCallGas;
270         if (!multiAsset.proxyTransferFromWithReference(_from, _to, _value, symbol, "")) {
271             return (false, false);
272         }
273         return (true, _applyRefund(startGas));
274     }
275 
276     function _transferToICAP(bytes32 _icap, uint _value) internal returns(bool, bool) {
277         uint startGas = msg.gas + transferToICAPCallGas;
278         if (!multiAsset.proxyTransferToICAPWithReference(_icap, _value, "")) {
279             return (false, false);
280         }
281         return (true, _applyRefund(startGas));
282     }
283 
284     function _transferFromToICAP(address _from, bytes32 _icap, uint _value) internal returns(bool, bool) {
285         uint startGas = msg.gas + transferFromToICAPCallGas;
286         if (!multiAsset.proxyTransferFromToICAPWithReference(_from, _icap, _value, "")) {
287             return (false, false);
288         }
289         return (true, _applyRefund(startGas));
290     }
291 
292     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool, bool) {
293         uint startGas = msg.gas + transferWithReferenceCallGas + _stringGas(_reference);
294         if (!multiAsset.proxyTransferWithReference(_to, _value, symbol, _reference)) {
295             return (false, false);
296         }
297         return (true, _applyRefund(startGas));
298     }
299 
300     function _transferFromWithReference(address _from, address _to, uint _value, string _reference) internal returns(bool, bool) {
301         uint startGas = msg.gas + transferFromWithReferenceCallGas + _stringGas(_reference);
302         if (!multiAsset.proxyTransferFromWithReference(_from, _to, _value, symbol, _reference)) {
303             return (false, false);
304         }
305         return (true, _applyRefund(startGas));
306     }
307 
308     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) internal returns(bool, bool) {
309         uint startGas = msg.gas + transferToICAPWithReferenceCallGas + _stringGas(_reference);
310         if (!multiAsset.proxyTransferToICAPWithReference(_icap, _value, _reference)) {
311             return (false, false);
312         }
313         return (true, _applyRefund(startGas));
314     }
315 
316     function _transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) internal returns(bool, bool) {
317         uint startGas = msg.gas + transferFromToICAPWithReferenceCallGas + _stringGas(_reference);
318         if (!multiAsset.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference)) {
319             return (false, false);
320         }
321         return (true, _applyRefund(startGas));
322     }
323 
324     function _approve(address _spender, uint _value) internal returns(bool, bool) {
325         uint startGas = msg.gas + approveCallGas;
326         if (!multiAsset.proxyApprove(_spender, _value, symbol)) {
327             return (false, false);
328         }
329         return (true, _applyRefund(startGas));
330     }
331 
332     function _setCosignerAddress(address _cosigner) internal returns(bool, bool) {
333         uint startGas = msg.gas + setCosignerCallGas;
334         if (!multiAsset.proxySetCosignerAddress(_cosigner, symbol)) {
335             return (false, false);
336         }
337         return (true, _applyRefund(startGas));
338     }
339 
340     function transfer(address _to, uint _value) returns(bool) {
341         bool success;
342         (success,) = _transfer(_to, _value);
343         return success;
344     }
345 
346     function transferFrom(address _from, address _to, uint _value) returns(bool) {
347         bool success;
348         (success,) = _transferFrom(_from, _to, _value);
349         return success;
350     }
351 
352     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
353         bool success;
354         (success,) = _transferToICAP(_icap, _value);
355         return success;
356     }
357 
358     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
359         bool success;
360         (success,) = _transferFromToICAP(_from, _icap, _value);
361         return success;
362     }
363 
364     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
365         bool success;
366         (success,) = _transferWithReference(_to, _value, _reference);
367         return success;
368     }
369 
370     function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
371         bool success;
372         (success,) = _transferFromWithReference(_from, _to, _value, _reference);
373         return success;
374     }
375 
376     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
377         bool success;
378         (success,) = _transferToICAPWithReference(_icap, _value, _reference);
379         return success;
380     }
381 
382     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
383         bool success;
384         (success,) = _transferFromToICAPWithReference(_from, _icap, _value, _reference);
385         return success;
386     }
387 
388     function approve(address _spender, uint _value) returns(bool) {
389         bool success;
390         (success,) = _approve(_spender, _value);
391         return success;
392     }
393 
394     function setCosignerAddress(address _cosigner) returns(bool) {
395         bool success;
396         (success,) = _setCosignerAddress(_cosigner);
397         return success;
398     }
399 
400     function checkTransfer(address _to, uint _value) constant returns(bool, bool) {
401         return _transfer(_to, _value);
402     }
403 
404     function checkTransferFrom(address _from, address _to, uint _value) constant returns(bool, bool) {
405         return _transferFrom(_from, _to, _value);
406     }
407 
408     function checkTransferToICAP(bytes32 _icap, uint _value) constant returns(bool, bool) {
409         return _transferToICAP(_icap, _value);
410     }
411 
412     function checkTransferFromToICAP(address _from, bytes32 _icap, uint _value) constant returns(bool, bool) {
413         return _transferFromToICAP(_from, _icap, _value);
414     }
415 
416     function checkTransferWithReference(address _to, uint _value, string _reference) constant returns(bool, bool) {
417         return _transferWithReference(_to, _value, _reference);
418     }
419 
420     function checkTransferFromWithReference(address _from, address _to, uint _value, string _reference) constant returns(bool, bool) {
421         return _transferFromWithReference(_from, _to, _value, _reference);
422     }
423 
424     function checkTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) constant returns(bool, bool) {
425         return _transferToICAPWithReference(_icap, _value, _reference);
426     }
427 
428     function checkTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) constant returns(bool, bool) {
429         return _transferFromToICAPWithReference(_from, _icap, _value, _reference);
430     }
431 
432     function checkApprove(address _spender, uint _value) constant returns(bool, bool) {
433         return _approve(_spender, _value);
434     }
435 
436     function checkSetCosignerAddress(address _cosigner) constant returns(bool, bool) {
437         return _setCosignerAddress(_cosigner);
438     }
439 
440     function _forward(address _to, bytes _data) internal returns(bool) {
441         uint startGas = msg.gas + forwardCallGas + (_data.length * 50);
442         if (_to == 0x0) {
443             return false;
444         }
445         _to.call.value(msg.value)(_data);
446         return _applyRefund(startGas);
447     }
448 
449     function () returns(bool) {
450         return _forward(allowedForwards[uint32(msg.sig)], msg.data);
451     }
452 }