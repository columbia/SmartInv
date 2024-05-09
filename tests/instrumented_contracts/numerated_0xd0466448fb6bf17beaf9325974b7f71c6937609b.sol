1 pragma solidity 0.4.26;
2 
3 library SafeMath {
4     /** SafeMath **
5     * SafeMath based on the OpenZeppelin framework
6     * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
7     */
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13 
14         uint256 c = a * b;
15         require(c / a == b, "SafeMath: multiplication overflow");
16 
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // Solidity only automatically asserts when dividing by 0
22         require(b > 0, "SafeMath: division by zero");
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25 
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b <= a, "SafeMath: subtraction overflow");
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
44         return a >= b ? a : b;
45     }
46 
47     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
48         return a < b ? a : b;
49     }
50 
51     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a >= b ? a : b;
53     }
54 
55     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a < b ? a : b;
57     }
58 
59     function abs128(int128 a) internal pure returns (int128) {
60         return a < 0 ? a * -1 : a;
61     }
62 }
63 
64 contract Accessible {
65     /** Access Right Management **
66     * Copyright 2019
67     * Florian Weigand
68     * Synalytix UG, Munich
69     * florian(at)synalytix.de
70     */
71 
72     address public owner;
73     mapping(address => bool) public accessAllowed;
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     modifier ownership() {
80         require(owner == msg.sender, "Accessible: Only the owner of contract can call this method");
81         _;
82     }
83 
84     modifier accessible() {
85         require(accessAllowed[msg.sender], "Accessible: This address has no allowence to access this method");
86         _;
87     }
88 
89     function allowAccess(address _address) public ownership {
90         if (_address != address(0)) {
91             accessAllowed[_address] = true;
92         }
93     }
94 
95     function denyAccess(address _address) public ownership {
96         if (_address != address(0)) {
97             accessAllowed[_address] = false;
98         }
99     }
100 
101     function transferOwnership(address _address) public ownership {
102         if (_address != address(0)) {
103             owner = _address;
104         }
105     }
106 }
107 
108 contract Repaying is Accessible {
109     /** Repaying Contract **
110     * Idea based on https://ethereum.stackexchange.com/a/38517/55678
111     * Stackexchange user: medvedev1088
112     * ---------------------
113     * ReentrancyGuard based on the OpenZeppelin framework
114     * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
115     * ---------------------
116     * Copyright 2019 (only modifications)
117     * Florian Weigand
118     * Synalytix UG, Munich
119     * florian(at)synalytix.de
120     */
121 
122     using SafeMath for uint256;
123     uint256 private guardCounter;
124     bool stopRepaying = false;
125     // the max gas price is set to 65 gwei this is the same as local server max fee setting
126     uint256 maxGasPrice = 65000000000;
127     // gas consomption of the repayable function
128     uint256 additionalGasConsumption = 42492;
129 
130     constructor () internal {
131         // the counter starts at one to prevent changing it from zero to a non-zero
132         // value, which is a more expensive operation.
133         guardCounter = 1;
134     }
135 
136     modifier repayable {
137         guardCounter += 1;
138         uint256 localCounter = guardCounter;
139 
140         // repayable logic with kill swtich
141         if(!stopRepaying) {
142             uint256 startGas = gasleft();
143             _;
144             uint256 gasUsed = startGas.sub(gasleft());
145             // use maxGasPrice as upper bound for the gas price
146             uint256 gasPrice = maxGasPrice.min256(tx.gasprice);
147             uint256 repayal = gasPrice.mul(gasUsed.add(additionalGasConsumption));
148             msg.sender.transfer(repayal);
149         }
150         else {
151             _;
152         }
153 
154         // if the counters don't match a reentrance is happening, stop the execution
155         require(localCounter == guardCounter, "Repaying: reentrant call detected");
156     }
157 
158     function() external payable {
159         require(msg.data.length == 0, "Repaying: You can only transfer Ether to this contract *without* any data");
160     }
161 
162     function withdraw(address _address) public ownership {
163         require(_address != address(0) && (accessAllowed[_address] || _address == owner),
164         "Repaying: Address is not allowed to withdraw the balance");
165 
166         _address.transfer(address(this).balance);
167     }
168 
169     function setMaxGasPrice(uint256 _maxGasPrice) public ownership {
170         // define absolute max. with 125 gwei
171         maxGasPrice = _maxGasPrice.min256(125000000000);
172     }
173 
174     function getMaxGasPrice() external view returns (uint256) {
175         return maxGasPrice;
176     }
177 
178     function setAdditionalGasConsumption(uint256 _additionalGasConsumption) public ownership {
179         // define absolute max. with 65.000 gas limit
180         additionalGasConsumption = _additionalGasConsumption.min256(65000);
181     }
182 
183     function getAdditionalGasConsumption() external view returns (uint256) {
184         return additionalGasConsumption;
185     }
186 
187     function setStopRepaying(bool _stopRepaying) public ownership {
188         stopRepaying = _stopRepaying;
189     }
190 }
191 
192 contract TrueProfileStorage is Accessible {
193     /** Data Storage Contract **
194     * Copyright 2019
195     * Florian Weigand
196     * Synalytix UG, Munich
197     * florian(at)synalytix.de
198     */
199 
200     /**** signature struct ****/
201     struct Signature {
202         uint8 v;
203         bytes32 r;
204         bytes32 s;
205         uint8 revocationReasonId;
206         bool isValue;
207     }
208 
209     /**** signature storage ****/
210     mapping(bytes32 => Signature)   public signatureStorage;
211 
212     /**** general storage of non-struct data which might
213     be needed for further development of main contract ****/
214     mapping(bytes32 => uint256) public uIntStorage;
215     mapping(bytes32 => string) public stringStorage;
216     mapping(bytes32 => address) public addressStorage;
217     mapping(bytes32 => bytes) public bytesStorage;
218     mapping(bytes32 => bool) public boolStorage;
219     mapping(bytes32 => int256) public intStorage;
220 
221     /**** CRUD for Signature storage ****/
222     function getSignature(bytes32 _key) external view returns (uint8 v, bytes32 r, bytes32 s, uint8 revocationReasonId) {
223         Signature memory tempSignature = signatureStorage[_key];
224         if (tempSignature.isValue) {
225             return(tempSignature.v, tempSignature.r, tempSignature.s, tempSignature.revocationReasonId);
226         } else {
227             return(0, bytes32(0), bytes32(0), 0);
228         }
229     }
230 
231     function setSignature(bytes32 _key, uint8 _v, bytes32 _r, bytes32 _s, uint8 _revocationReasonId) external accessible {
232         require(ecrecover(_key, _v, _r, _s) != 0x0, "TrueProfileStorage: Signature does not resolve to valid address");
233         Signature memory tempSignature = Signature({
234             v: _v,
235             r: _r,
236             s: _s,
237             revocationReasonId: _revocationReasonId,
238             isValue: true
239         });
240         signatureStorage[_key] = tempSignature;
241     }
242 
243     function deleteSignature(bytes32 _key) external accessible {
244         require(signatureStorage[_key].isValue, "TrueProfileStorage: Signature to delete was not found");
245         Signature memory tempSignature = Signature({
246             v: 0,
247             r: bytes32(0),
248             s: bytes32(0),
249             revocationReasonId: 0,
250             isValue: false
251         });
252         signatureStorage[_key] = tempSignature;
253     }
254 
255     /**** Get Methods for additional storage ****/
256     function getAddress(bytes32 _key) external view returns (address) {
257         return addressStorage[_key];
258     }
259 
260     function getUint(bytes32 _key) external view returns (uint) {
261         return uIntStorage[_key];
262     }
263 
264     function getString(bytes32 _key) external view returns (string) {
265         return stringStorage[_key];
266     }
267 
268     function getBytes(bytes32 _key) external view returns (bytes) {
269         return bytesStorage[_key];
270     }
271 
272     function getBool(bytes32 _key) external view returns (bool) {
273         return boolStorage[_key];
274     }
275 
276     function getInt(bytes32 _key) external view returns (int) {
277         return intStorage[_key];
278     }
279 
280     /**** Set Methods for additional storage ****/
281     function setAddress(bytes32 _key, address _value) external accessible {
282         addressStorage[_key] = _value;
283     }
284 
285     function setUint(bytes32 _key, uint _value) external accessible {
286         uIntStorage[_key] = _value;
287     }
288 
289     function setString(bytes32 _key, string _value) external accessible {
290         stringStorage[_key] = _value;
291     }
292 
293     function setBytes(bytes32 _key, bytes _value) external accessible {
294         bytesStorage[_key] = _value;
295     }
296 
297     function setBool(bytes32 _key, bool _value) external accessible {
298         boolStorage[_key] = _value;
299     }
300 
301     function setInt(bytes32 _key, int _value) external accessible {
302         intStorage[_key] = _value;
303     }
304 
305     /**** Delete Methods for additional storage ****/
306     function deleteAddress(bytes32 _key) external accessible {
307         delete addressStorage[_key];
308     }
309 
310     function deleteUint(bytes32 _key) external accessible {
311         delete uIntStorage[_key];
312     }
313 
314     function deleteString(bytes32 _key) external accessible {
315         delete stringStorage[_key];
316     }
317 
318     function deleteBytes(bytes32 _key) external accessible {
319         delete bytesStorage[_key];
320     }
321 
322     function deleteBool(bytes32 _key) external accessible {
323         delete boolStorage[_key];
324     }
325 
326     function deleteInt(bytes32 _key) external accessible {
327         delete intStorage[_key];
328     }
329 }
330 
331 contract TrueProfileLogic is Repaying {
332     /** Logic Contract (updatable) **
333     * Copyright 2019
334     * Florian Weigand
335     * Synalytix UG, Munich
336     * florian(at)synalytix.de
337     */
338 
339     TrueProfileStorage trueProfileStorage;
340 
341     constructor(address _trueProfileStorage) public {
342         trueProfileStorage = TrueProfileStorage(_trueProfileStorage);
343     }
344 
345     /**** Signature logic methods ****/
346 
347     // add or update TrueProof
348     // if not present add to array
349     // if present the old TrueProof can be replaced with a new TrueProof
350     function addTrueProof(bytes32 _key, uint8 _v, bytes32 _r, bytes32 _s) external repayable accessible {
351         require(accessAllowed[ecrecover(_key, _v, _r, _s)], "TrueProfileLogic: Signature creator has no access to this contract");
352         // the certifcate is valid, so set the revokationReasonId to 0
353         uint8 revokationReasonId = 0;
354         trueProfileStorage.setSignature(_key, _v, _r, _s, revokationReasonId);
355     }
356 
357     // if the TrueProof was issued by error it can be revoked
358     // for revocation a reason id needs to be given
359     function revokeTrueProof(bytes32 _key, uint8 _revocationReasonId) external repayable accessible {
360         require(_revocationReasonId != 0, "TrueProfileLogic: Revocation reason needs to be unequal to 0");
361 
362         uint8 v;
363         bytes32 r;
364         bytes32 s;
365         uint8 oldRevocationReasonId;
366         (v, r, s, oldRevocationReasonId) = trueProfileStorage.getSignature(_key);
367 
368         require(v != 0, "TrueProfileLogic: This TrueProof was already revoked");
369 
370         // set the revokation reason id to the new value
371         trueProfileStorage.setSignature(_key, v, r, s, _revocationReasonId);
372     }
373 
374     function isValidTrueProof(bytes32 _key) external view returns (bool) {
375         // needs to be not revoked AND needs to have a valid signature
376         return this.isValidSignatureTrueProof(_key) && this.isNotRevokedTrueProof(_key);
377     }
378 
379     function isValidSignatureTrueProof(bytes32 _key) external view returns (bool) {
380         uint8 v;
381         bytes32 r;
382         bytes32 s;
383         uint8 revocationReasonId;
384         (v, r, s, revocationReasonId) = trueProfileStorage.getSignature(_key);
385 
386         // needs to have a valid signature
387         return accessAllowed[ecrecover(_key, v, r, s)];
388     }
389 
390     function isNotRevokedTrueProof(bytes32 _key) external view returns (bool) {
391         uint8 v;
392         bytes32 r;
393         bytes32 s;
394         uint8 revocationReasonId;
395         (v, r, s, revocationReasonId) = trueProfileStorage.getSignature(_key);
396 
397         // needs to be not revoked
398         return revocationReasonId == 0;
399     }
400 
401     function getSignature(bytes32 _key) external view returns (uint8 v, bytes32 r, bytes32 s, uint8 revocationReasonId) {
402         return trueProfileStorage.getSignature(_key);
403     }
404 
405     function getRevocationReasonId(bytes32 _key) external view returns (uint8) {
406         uint8 v;
407         bytes32 r;
408         bytes32 s;
409         uint8 revocationReasonId;
410         (v, r, s, revocationReasonId) = trueProfileStorage.getSignature(_key);
411 
412         return revocationReasonId;
413     }
414 }