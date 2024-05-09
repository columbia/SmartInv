1 pragma solidity ^0.4.4;
2 
3 contract EtherTreasuryInterface {
4     function withdraw(address _to, uint _value) returns(bool);
5     function withdrawWithReference(address _to, uint _value, string _reference) returns(bool);
6 }
7 
8 contract SafeMin {
9     modifier onlyHuman {
10         if (_isHuman()) {
11             _;
12         }
13     }
14 
15     modifier immutable(address _address) {
16         if (_address == 0) {
17             _;
18         }
19     }
20 
21     function _safeFalse() internal returns(bool) {
22         _safeSend(msg.sender, msg.value);
23         return false;
24     }
25 
26     function _safeSend(address _to, uint _value) internal {
27         if (!_unsafeSend(_to, _value)) {
28             throw;
29         }
30     }
31 
32     function _unsafeSend(address _to, uint _value) internal returns(bool) {
33         return _to.call.value(_value)();
34     }
35 
36     function _isContract() constant internal returns(bool) {
37         return msg.sender != tx.origin;
38     }
39 
40     function _isHuman() constant internal returns(bool) {
41         return !_isContract();
42     }
43 }
44 
45 contract MultiAsset {
46     function isCreated(bytes32 _symbol) constant returns(bool);
47     function baseUnit(bytes32 _symbol) constant returns(uint8);
48     function name(bytes32 _symbol) constant returns(string);
49     function description(bytes32 _symbol) constant returns(string);
50     function isReissuable(bytes32 _symbol) constant returns(bool);
51     function owner(bytes32 _symbol) constant returns(address);
52     function isOwner(address _owner, bytes32 _symbol) constant returns(bool);
53     function totalSupply(bytes32 _symbol) constant returns(uint);
54     function balanceOf(address _holder, bytes32 _symbol) constant returns(uint);
55     function transfer(address _to, uint _value, bytes32 _symbol) returns(bool);
56     function transferToICAP(bytes32 _icap, uint _value) returns(bool);
57     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool);
58     function transferWithReference(address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
59     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
60     function proxyTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool);
61     function approve(address _spender, uint _value, bytes32 _symbol) returns(bool);
62     function proxyApprove(address _spender, uint _value, bytes32 _symbol) returns(bool);
63     function allowance(address _from, address _spender, bytes32 _symbol) constant returns(uint);
64     function transferFrom(address _from, address _to, uint _value, bytes32 _symbol) returns(bool);
65     function transferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
66     function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool);
67     function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
68     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference) returns(bool);
69     function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool);
70     function setCosignerAddress(address _address, bytes32 _symbol) returns(bool);
71     function setCosignerAddressForUser(address _address) returns(bool);
72     function proxySetCosignerAddress(address _address, bytes32 _symbol) returns(bool);
73 }
74 
75 contract AssetMin is SafeMin {
76     event Transfer(address indexed from, address indexed to, uint value);
77     event Approve(address indexed from, address indexed spender, uint value);
78 
79     MultiAsset public multiAsset;
80     bytes32 public symbol;
81     string public name;
82 
83     function init(address _multiAsset, bytes32 _symbol) immutable(address(multiAsset)) returns(bool) {
84         MultiAsset ma = MultiAsset(_multiAsset);
85         if (!ma.isCreated(_symbol)) {
86             return false;
87         }
88         multiAsset = ma;
89         symbol = _symbol;
90         return true;
91     }
92 
93     function setName(string _name) returns(bool) {
94         if (bytes(name).length != 0) {
95             return false;
96         }
97         name = _name;
98         return true;
99     }
100 
101     modifier onlyMultiAsset() {
102         if (msg.sender == address(multiAsset)) {
103             _;
104         }
105     }
106 
107     function totalSupply() constant returns(uint) {
108         return multiAsset.totalSupply(symbol);
109     }
110 
111     function balanceOf(address _owner) constant returns(uint) {
112         return multiAsset.balanceOf(_owner, symbol);
113     }
114 
115     function allowance(address _from, address _spender) constant returns(uint) {
116         return multiAsset.allowance(_from, _spender, symbol);
117     }
118 
119     function transfer(address _to, uint _value) returns(bool) {
120         return __transferWithReference(_to, _value, "");
121     }
122 
123     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
124         return __transferWithReference(_to, _value, _reference);
125     }
126 
127     function __transferWithReference(address _to, uint _value, string _reference) private returns(bool) {
128         return _isHuman() ?
129             multiAsset.proxyTransferWithReference(_to, _value, symbol, _reference) :
130             multiAsset.transferFromWithReference(msg.sender, _to, _value, symbol, _reference);
131     }
132 
133     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
134         return __transferToICAPWithReference(_icap, _value, "");
135     }
136 
137     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
138         return __transferToICAPWithReference(_icap, _value, _reference);
139     }
140 
141     function __transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) private returns(bool) {
142         return _isHuman() ?
143             multiAsset.proxyTransferToICAPWithReference(_icap, _value, _reference) :
144             multiAsset.transferFromToICAPWithReference(msg.sender, _icap, _value, _reference);
145     }
146     
147     function approve(address _spender, uint _value) onlyHuman() returns(bool) {
148         return multiAsset.proxyApprove(_spender, _value, symbol);
149     }
150 
151     function setCosignerAddress(address _cosigner) onlyHuman() returns(bool) {
152         return multiAsset.proxySetCosignerAddress(_cosigner, symbol);
153     }
154 
155     function emitTransfer(address _from, address _to, uint _value) onlyMultiAsset() {
156         Transfer(_from, _to, _value);
157     }
158 
159     function emitApprove(address _from, address _spender, uint _value) onlyMultiAsset() {
160         Approve(_from, _spender, _value);
161     }
162 
163     function sendToOwner() returns(bool) {
164         address owner = multiAsset.owner(symbol);
165         return multiAsset.transfer(owner, balanceOf(owner), symbol);
166     }
167 
168     function decimals() constant returns(uint8) {
169         return multiAsset.baseUnit(symbol);
170     }
171 }
172 
173 contract Owned {
174     address public contractOwner;
175 
176     function Owned() {
177         contractOwner = msg.sender;
178     }
179 
180     modifier onlyContractOwner() {
181         if (contractOwner == msg.sender) {
182             _;
183         }
184     }
185 }
186 
187 contract GMT is AssetMin, Owned {
188     uint public txGasPriceLimit = 21000000000;
189     uint public refundGas = 40000;
190     uint public transferCallGas = 21000;
191     uint public transferWithReferenceCallGas = 21000;
192     uint public transferToICAPCallGas = 21000;
193     uint public transferToICAPWithReferenceCallGas = 21000;
194     uint public approveCallGas = 21000;
195     uint public forwardCallGas = 21000;
196     uint public setCosignerCallGas = 21000;
197     EtherTreasuryInterface public treasury;
198     mapping(bytes32 => address) public allowedForwards;
199 
200     function updateRefundGas() onlyContractOwner() returns(uint) {
201         uint startGas = msg.gas;
202         // just to simulate calculations, dunno if optimizer will remove this.
203         uint refund = (startGas - msg.gas + refundGas) * tx.gasprice;
204         if (tx.gasprice > txGasPriceLimit) {
205             return 0;
206         }
207         // end.
208         if (!_refund(1)) {
209             return 0;
210         }
211         refundGas = startGas - msg.gas;
212         return refundGas;
213     }
214 
215     function setOperationsCallGas(
216         uint _transfer,
217         uint _transferToICAP,
218         uint _transferWithReference,
219         uint _transferToICAPWithReference,
220         uint _approve,
221         uint _forward,
222         uint _setCosigner
223     )
224         onlyContractOwner()
225         returns(bool)
226     {
227         transferCallGas = _transfer;
228         transferToICAPCallGas = _transferToICAP;
229         transferWithReferenceCallGas = _transferWithReference;
230         transferToICAPWithReferenceCallGas = _transferToICAPWithReference;
231         approveCallGas = _approve;
232         forwardCallGas = _forward;
233         setCosignerCallGas = _setCosigner;
234         return true;
235     }
236 
237     function setupTreasury(address _treasury, uint _txGasPriceLimit) payable onlyContractOwner() returns(bool) {
238         if (_txGasPriceLimit == 0) {
239             return _safeFalse();
240         }
241         treasury = EtherTreasuryInterface(_treasury);
242         txGasPriceLimit = _txGasPriceLimit;
243         if (msg.value > 0) {
244             _safeSend(_treasury, msg.value);
245         }
246         return true;
247     }
248 
249     function setForward(bytes4 _msgSig, address _forward) onlyContractOwner() returns(bool) {
250         allowedForwards[sha3(_msgSig)] = _forward;
251         return true;
252     }
253 
254     function _stringGas(string _string) constant internal returns(uint) {
255         return bytes(_string).length * 75; // ~75 gas per byte, empirical shown 68-72.
256     }
257 
258     function _applyRefund(uint _startGas) internal returns(bool) {
259         if (tx.gasprice > txGasPriceLimit) {
260             return false;
261         }
262         uint refund = (_startGas - msg.gas + refundGas) * tx.gasprice;
263         return _refund(refund);
264     }
265 
266     function _refund(uint _value) internal returns(bool) {
267         return address(treasury) != 0 && treasury.withdraw(tx.origin, _value);
268     }
269 
270     function _transfer(address _to, uint _value) internal returns(bool, bool) {
271         uint startGas = msg.gas + transferCallGas;
272         if (!super.transfer(_to, _value)) {
273             return (false, false);
274         }
275         return (true, _applyRefund(startGas));
276     }
277 
278     function _transferToICAP(bytes32 _icap, uint _value) internal returns(bool, bool) {
279         uint startGas = msg.gas + transferToICAPCallGas;
280         if (!super.transferToICAP(_icap, _value)) {
281             return (false, false);
282         }
283         return (true, _applyRefund(startGas));
284     }
285 
286     function _transferWithReference(address _to, uint _value, string _reference) internal returns(bool, bool) {
287         uint startGas = msg.gas + transferWithReferenceCallGas + _stringGas(_reference);
288         if (!super.transferWithReference(_to, _value, _reference)) {
289             return (false, false);
290         }
291         return (true, _applyRefund(startGas));
292     }
293 
294     function _transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) internal returns(bool, bool) {
295         uint startGas = msg.gas + transferToICAPWithReferenceCallGas + _stringGas(_reference);
296         if (!super.transferToICAPWithReference(_icap, _value, _reference)) {
297             return (false, false);
298         }
299         return (true, _applyRefund(startGas));
300     }
301 
302     function _approve(address _spender, uint _value) internal returns(bool, bool) {
303         uint startGas = msg.gas + approveCallGas;
304         if (!super.approve(_spender, _value)) {
305             return (false, false);
306         }
307         return (true, _applyRefund(startGas));
308     }
309 
310     function _setCosignerAddress(address _cosigner) internal returns(bool, bool) {
311         uint startGas = msg.gas + setCosignerCallGas;
312         if (!super.setCosignerAddress(_cosigner)) {
313             return (false, false);
314         }
315         return (true, _applyRefund(startGas));
316     }
317 
318     function transfer(address _to, uint _value) returns(bool) {
319         bool success;
320         (success,) = _transfer(_to, _value);
321         return success;
322     }
323 
324     function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
325         bool success;
326         (success,) = _transferToICAP(_icap, _value);
327         return success;
328     }
329 
330     function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
331         bool success;
332         (success,) = _transferWithReference(_to, _value, _reference);
333         return success;
334     }
335 
336     function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
337         bool success;
338         (success,) = _transferToICAPWithReference(_icap, _value, _reference);
339         return success;
340     }
341 
342     function approve(address _spender, uint _value) returns(bool) {
343         bool success;
344         (success,) = _approve(_spender, _value);
345         return success;
346     }
347 
348     function setCosignerAddress(address _cosigner) returns(bool) {
349         bool success;
350         (success,) = _setCosignerAddress(_cosigner);
351         return success;
352     }
353 
354     function checkTransfer(address _to, uint _value) constant returns(bool, bool) {
355         return _transfer(_to, _value);
356     }
357 
358     function checkTransferToICAP(bytes32 _icap, uint _value) constant returns(bool, bool) {
359         return _transferToICAP(_icap, _value);
360     }
361 
362     function checkTransferWithReference(address _to, uint _value, string _reference) constant returns(bool, bool) {
363         return _transferWithReference(_to, _value, _reference);
364     }
365 
366     function checkTransferToICAPWithReference(bytes32 _icap, uint _value, string _reference) constant returns(bool, bool) {
367         return _transferToICAPWithReference(_icap, _value, _reference);
368     }
369 
370     function checkApprove(address _spender, uint _value) constant returns(bool, bool) {
371         return _approve(_spender, _value);
372     }
373 
374     function checkSetCosignerAddress(address _cosigner) constant returns(bool, bool) {
375         return _setCosignerAddress(_cosigner);
376     }
377 
378     function checkForward(bytes _data) constant returns(bool, bool) {
379         return _forward(allowedForwards[sha3(_data[0], _data[1], _data[2], _data[3])], _data);
380     }
381 
382     function _forward(address _to, bytes _data) internal returns(bool, bool) {
383         uint startGas = msg.gas + forwardCallGas + (_data.length * 50); // 50 gas per byte;
384         if (_to == 0x0) {
385             return (false, _safeFalse());
386         }
387         if (!_to.call.value(msg.value)(_data)) {
388             return (false, _safeFalse());
389         }
390         return (true, _applyRefund(startGas));
391     }
392 
393     function () payable {
394         _forward(allowedForwards[sha3(msg.sig)], msg.data);
395     }
396 }