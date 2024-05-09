1 pragma solidity 0.4.11;
2 
3 // File: contracts/OwnerValidator.sol
4 
5 contract TokenContract {
6     function totalSupply() constant returns (uint256 supply);
7     function decimals() constant returns(uint8 units);
8     function balanceOf(address _owner) constant returns (uint256 balance);
9     function transfer(address _to, uint256 _value) returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11     function transferFromSender(address _to, uint256 _value) returns (bool success);
12     function approve(address _spender, uint256 _value) returns (bool success);
13     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
14 }
15 contract OwnerValidator {
16     function validate(address addr) constant returns (bool);
17 }
18 
19 contract Owned {
20     function ownerValidate(address addr) constant returns (bool);
21     bool public isWorking;
22 
23     function Owned() {
24         isWorking = true;
25     }
26 
27     modifier onlyOwner {
28         if (!ownerValidate(msg.sender)) throw;
29         _;
30     }
31 
32     modifier onlyWorking {
33         if (!isWorking) throw;
34         _;
35     }
36 
37     modifier onlyNotWorking {
38         if (isWorking) throw;
39         _;
40     }
41 
42     function setWorking(bool _isWorking) onlyOwner {
43         isWorking = _isWorking;
44     }
45 }
46 
47 contract OwnerValidatorImpl is OwnerValidator, Owned {
48 
49     address[] public owners;
50 
51 
52     TokenContract public tokenContract;
53 
54     function OwnerValidatorImpl() {
55         owners.push(msg.sender);
56     }
57 
58 
59     function indexOfOwners(address _address) private constant returns (uint pos) {
60         pos = 0;
61         for (uint i = 0; i < owners.length; i++) {
62             if (owners[i] == _address) {
63                 pos = i + 1;
64                 break;
65             }
66         }
67         return pos;
68     }
69 
70     function validate(address addr) constant returns (bool) {
71         return (indexOfOwners(addr) != 0);
72     }
73 
74     function getOwners() constant returns (address[]) {
75         return owners;
76     }
77 
78     function addOwner(address addr) onlyWorking {
79         if (validate(msg.sender)) {
80             if (!validate(addr)) {
81                 owners.push(addr);
82             }
83         }
84     }
85 
86     function removeOwner(address addr) onlyWorking {
87         if (validate(msg.sender)) {
88             uint pos = indexOfOwners(addr);
89             if (pos > 0) {
90                 owners[pos - 1] = 0x0;
91             }
92         }
93     }
94 
95     function setTokenContract(address _tokenContract) onlyWorking {
96         if (validate(msg.sender)) {
97             tokenContract = TokenContract(_tokenContract);
98         }
99     }
100 
101     function ownerValidate(address addr) constant returns (bool) {
102         return validate(addr);
103     }
104 
105     function transferFromSender(address _to, uint256 _value) returns (bool success) {
106         if (!validate(msg.sender)) throw;
107         return tokenContract.transferFromSender(_to, _value);
108     }
109 
110     function sendFromOwn(address _to, uint256 _value) returns (bool success) {
111         if (!validate(msg.sender)) throw;
112         if (!_to.send(_value)) throw;
113         return true;
114     }
115 }
116 
117 // File: contracts/OffChainManager.sol
118 
119 
120 contract OffChainManager {
121     function isToOffChainAddress(address addr) constant returns (bool);
122     function getOffChainRootAddress() constant returns (address);
123 }
124 
125 contract OffChainManagerImpl is OffChainManager, Owned {
126     address public rootAddress;
127     address[] public offChainAddreses;
128 
129     mapping (address => uint256) refOffChainAddresses;
130 
131     OwnerValidator public ownerValidator;
132 
133     TokenContract public tokenContract;
134 
135     function OffChainManagerImpl(
136         address _rootAddress,
137         address _ownerValidator
138     ) {
139         rootAddress = _rootAddress;
140         ownerValidator = OwnerValidator(_ownerValidator);
141     }
142 
143     function setRootAddress(address _address) onlyWorking {
144         if (ownerValidator.validate(msg.sender)) {
145             rootAddress = _address;
146         }
147     }
148 
149     function setOwnerValidatorAddress(address _ownerValidator) onlyWorking {
150         if (ownerValidator.validate(msg.sender)) {
151             ownerValidator = OwnerValidator(_ownerValidator);
152         }
153     }
154 
155     function setTokenContract(address _tokenContract) {
156         if (ownerValidator.validate(msg.sender)) {
157             tokenContract = TokenContract(_tokenContract);
158         }
159     }
160 
161     function offChainAddresesValidCount() constant returns (uint) {
162         uint cnt = 0;
163         for (uint i = 0; i < offChainAddreses.length; i++) {
164             if (offChainAddreses[i] != 0) {
165                 cnt++;
166             }
167         }
168         return cnt;
169     }
170 
171     function addOffChainAddress(address _address) private {
172         if (!isToOffChainAddress(_address)) {
173             offChainAddreses.push(_address);
174             refOffChainAddresses[_address] = offChainAddreses.length;
175         }
176     }
177 
178     function removeOffChainAddress(address _address) private {
179         uint pos = refOffChainAddresses[_address];
180         if (pos > 0) {
181             offChainAddreses[pos - 1] = 0;
182             refOffChainAddresses[_address] = 0x0;
183         }
184     }
185 
186     function addOffChainAddresses(address[] _addresses) onlyWorking {
187         if (ownerValidator.validate(msg.sender)) {
188             for (uint i = 0; i < _addresses.length; i++) {
189                 addOffChainAddress(_addresses[i]);
190             }
191         }
192     }
193 
194     function removeOffChainAddresses(address[] _addresses) onlyWorking {
195         if (ownerValidator.validate(msg.sender)) {
196             for (uint i = 0; i < _addresses.length; i++) {
197                 removeOffChainAddress(_addresses[i]);
198             }
199         }
200     }
201 
202     function ownerValidate(address addr) constant returns (bool) {
203         return ownerValidator.validate(addr);
204     }
205 
206     function transferFromSender(address _to, uint256 _value) returns (bool success) {
207         if (!ownerValidator.validate(msg.sender)) throw;
208         return tokenContract.transferFromSender(_to, _value);
209     }
210 
211     function sendFromOwn(address _to, uint256 _value) returns (bool success) {
212         if (!ownerValidator.validate(msg.sender)) throw;
213         if (!_to.send(_value)) throw;
214         return true;
215     }
216 
217     function isToOffChainAddress(address addr) constant returns (bool) {
218         return refOffChainAddresses[addr] > 0;
219     }
220 
221     function getOffChainRootAddress() constant returns (address) {
222         return rootAddress;
223     }
224 
225     function getOffChainAddresses() constant returns (address[]) {
226         return offChainAddreses;
227     }
228 
229     function isToOffChainAddresses(address[] _addresses) constant returns (bool) {
230         for (uint i = 0; i < _addresses.length; i++) {
231             if (!isToOffChainAddress(_addresses[i])) {
232                 return false;
233             }
234         }
235         return true;
236     }
237 }
238 
239 // File: contracts/TokenContract.sol
240 
241 library SafeMath {
242   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
243     uint256 c = a * b;
244     assert(a == 0 || c / a == b);
245     return c;
246   }
247 
248   function div(uint256 a, uint256 b) internal constant returns (uint256) {
249 // assert(b > 0);
250     uint256 c = a / b;
251 // assert(a == b * c + a % b);
252     return c;
253   }
254 
255   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
256     assert(b <= a);
257     return a - b;
258   }
259 
260   function add(uint256 a, uint256 b) internal constant returns (uint256) {
261     uint256 c = a + b;
262     assert(c >= a);
263     return c;
264   }
265 }
266 
267 
268 contract TokenContractImpl is TokenContract, Owned {
269     using SafeMath for uint256;
270     string public standard = "Token 0.1";
271     uint256 _totalSupply;
272     uint8 _decimals;
273 
274     mapping (address => uint256) public balances;
275     mapping (address => mapping (address => uint256)) public allowed;
276 
277     OwnerValidator public ownerValidator;
278     OffChainManager public offChainManager;
279 
280     bool public isRedenominated;
281     uint256 public redenomiValue;
282     mapping (address => uint256) public redenominatedBalances;
283     mapping (address => mapping (address => uint256)) public redenominatedAllowed;
284 
285     function TokenContractImpl(
286         uint256 initialSupply,
287         uint8 decimals,
288         address _ownerValidator,
289         address _offChainManager
290     ){
291         balances[msg.sender] = initialSupply;
292         _totalSupply = initialSupply;
293         _decimals = decimals;
294         ownerValidator = OwnerValidator(_ownerValidator);
295         offChainManager = OffChainManager(_offChainManager);
296     }
297 
298     function totalSupply() constant returns (uint256 totalSupply) {
299         if (isRedenominated) {
300             return redenominatedValue(_totalSupply);
301         }
302         return _totalSupply;
303     }
304 
305     function decimals() constant returns (uint8 decimals) {
306         return _decimals;
307     }
308 
309     function balanceOf(address _owner) constant returns (uint256 balance) {
310         if (isRedenominated) {
311             if (redenominatedBalances[_owner] > 0) {
312                 return redenominatedBalances[_owner];
313             }
314             return redenominatedValue(balances[_owner]);
315         }
316         return balances[_owner];
317     }
318 
319     function allowance(address _owner, address _spender) constant returns (uint remaining) {
320         if (isRedenominated) {
321             if (redenominatedAllowed[_owner][_spender] > 0) {
322                 return redenominatedAllowed[_owner][_spender];
323             }
324             return redenominatedValue(allowed[_owner][_spender]);
325         }
326         return allowed[_owner][_spender];
327     }
328 
329     function redenominatedValue(uint256 _value) private returns (uint256) {
330         return _value.mul(redenomiValue);
331     }
332 
333     function ownerValidate(address addr) constant returns (bool) {
334         return ownerValidator.validate(addr);
335     }
336 
337 
338     function redenominate(uint256 _redenomiValue) {
339         if (isRedenominated) throw;
340         if (ownerValidator.validate(msg.sender)) {
341             redenomiValue = _redenomiValue;
342             Redenominate(msg.sender, isRedenominated, redenomiValue);
343         }
344     }
345 
346 
347     function applyRedenomination() onlyNotWorking {
348         if (isRedenominated) throw;
349         if (redenomiValue == 0) throw;
350         if (ownerValidator.validate(msg.sender)) {
351             isRedenominated = true;
352             ApplyRedenomination(msg.sender, isRedenominated, redenomiValue);
353         }
354     }
355 
356     function setOwnerValidatorAddress(address _ownerValidator) onlyWorking {
357         if (ownerValidator.validate(msg.sender)) {
358             ownerValidator = OwnerValidator(_ownerValidator);
359         }
360     }
361 
362     function setOffChainManagerAddress(address _offChainManager) onlyWorking {
363         if (ownerValidator.validate(msg.sender)) {
364             offChainManager = OffChainManager(_offChainManager);
365         }
366     }
367 
368     function transfer(address _to, uint256 _value) onlyWorking returns (bool success) {
369         return transferProcess(tx.origin, _to, _value);
370     }
371 
372     function transferProcess(address _from, address _to, uint256 _value) private returns (bool success) {
373         if (balanceOf(_from) < _value) throw;
374         subtractBalance(_from, _value);
375         if (offChainManager.isToOffChainAddress(_to)) {
376             addBalance(offChainManager.getOffChainRootAddress(), _value);
377             ToOffChainTransfer(_from, _to, _to, _value);
378         } else {
379             addBalance(_to, _value);
380         }
381         return true;
382     }
383 
384     function addBalance(address _address, uint256 _value) private {
385         if (isRedenominated) {
386             if (redenominatedBalances[_address] == 0) {
387                 if (balances[_address] > 0) {
388                     redenominatedBalances[_address] = redenominatedValue(balances[_address]);
389                     balances[_address] = 0;
390                 }
391             }
392             redenominatedBalances[_address] = redenominatedBalances[_address].add(_value);
393         } else {
394             balances[_address] = balances[_address].add(_value);
395         }
396     }
397 
398     function subtractBalance(address _address, uint256 _value) private {
399         if (isRedenominated) {
400             if (redenominatedBalances[_address] == 0) {
401                 if (balances[_address] > 0) {
402                     redenominatedBalances[_address] = redenominatedValue(balances[_address]);
403                     balances[_address] = 0;
404                 }
405             }
406             redenominatedBalances[_address] = redenominatedBalances[_address].sub(_value);
407         } else {
408             balances[_address] = balances[_address].sub(_value);
409         }
410     }
411 
412     function transferFrom(address _from, address _to, uint256 _value) onlyWorking returns (bool success) {
413         if (balanceOf(_from) < _value) throw;
414         if (balanceOf(_to).add(_value) < balanceOf(_to)) throw;
415         if (_value > allowance(_from, tx.origin)) throw;
416         subtractBalance(_from, _value);
417         if (offChainManager.isToOffChainAddress(_to)) {
418             addBalance(offChainManager.getOffChainRootAddress(), _value);
419             ToOffChainTransfer(tx.origin, _to, _to, _value);
420         } else {
421             addBalance(_to, _value);
422         }
423         subtractAllowed(_from, tx.origin, _value);
424         return true;
425     }
426 
427 
428     function transferFromSender(address _to, uint256 _value) onlyWorking returns (bool success) {
429         if (!transferProcess(msg.sender, _to, _value)) throw;
430         TransferFromSender(msg.sender, _to, _value);
431         return true;
432     }
433 
434 
435     function transferFromOwn(address _to, uint256 _value) onlyWorking returns (bool success) {
436         if (!ownerValidator.validate(msg.sender)) throw;
437         if (!transferProcess(this, _to, _value)) throw;
438         TransferFromSender(this, _to, _value);
439         return true;
440     }
441 
442     function sendFromOwn(address _to, uint256 _value) returns (bool success) {
443         if (!ownerValidator.validate(msg.sender)) throw;
444         if (!_to.send(_value)) throw;
445         return true;
446     }
447 
448     function approve(address _spender, uint256 _value) onlyWorking returns (bool success) {
449         setAllowed(tx.origin, _spender, _value);
450         return true;
451     }
452 
453     function subtractAllowed(address _from, address _spender, uint256 _value) private {
454         if (isRedenominated) {
455             if (redenominatedAllowed[_from][_spender] == 0) {
456                 if (allowed[_from][_spender] > 0) {
457                     redenominatedAllowed[_from][_spender] = redenominatedValue(allowed[_from][_spender]);
458                     allowed[_from][_spender] = 0;
459                 }
460             }
461             redenominatedAllowed[_from][_spender] = redenominatedAllowed[_from][_spender].sub(_value);
462         } else {
463             allowed[_from][_spender] = allowed[_from][_spender].sub(_value);
464         }
465     }
466 
467     function setAllowed(address _owner, address _spender, uint256 _value) private {
468         if (isRedenominated) {
469             redenominatedAllowed[_owner][_spender] = _value;
470         } else {
471             allowed[_owner][_spender] = _value;
472         }
473     }
474 
475     event TransferFromSender(address indexed _from, address indexed _to, uint256 _value);
476     event ToOffChainTransfer(address indexed _from, address indexed _toKey, address _to, uint256 _value);
477     event Redenominate(address _owner, bool _isRedenominated, uint256 _redenomiVakye);
478     event ApplyRedenomination(address _owner, bool _isRedenominated, uint256 _redenomiVakye);
479 }
480 
481 // File: contracts/MainContract.sol
482 
483 contract MainContract {
484     string public standard = "Token 0.1";
485     string public name;
486     string public symbol;
487 
488     OwnerValidator public ownerValidator;
489     TokenContract public tokenContract;
490 
491     function MainContract(
492         string _tokenName,
493         address _ownerValidator,
494         address _tokenContract,
495         string _symbol
496     ) {
497         ownerValidator = OwnerValidator(_ownerValidator);
498         tokenContract = TokenContract(_tokenContract);
499         name = _tokenName;
500         symbol = _symbol;
501     }
502 
503     function totalSupply() constant returns(uint256 totalSupply) {
504         return tokenContract.totalSupply();
505     }
506 
507     function decimals() constant returns(uint8 decimals) {
508         return tokenContract.decimals();
509     }
510 
511     function setOwnerValidateAddress(address _ownerValidator) {
512         if (ownerValidator.validate(msg.sender)) {
513             ownerValidator = OwnerValidator(_ownerValidator);
514         }
515     }
516 
517     function setTokenContract(address _tokenContract) {
518         if (ownerValidator.validate(msg.sender)) {
519             tokenContract = TokenContract(_tokenContract);
520         }
521     }
522 
523     function transferFromSender(address _to, uint256 _value) returns (bool success) {
524         if (!ownerValidator.validate(msg.sender)) throw;
525         return tokenContract.transferFromSender(_to, _value);
526     }
527 
528     function sendFromOwn(address _to, uint256 _value) returns (bool success) {
529         if (!ownerValidator.validate(msg.sender)) throw;
530         if (!_to.send(_value)) throw;
531         return true;
532     }
533 
534     function balanceOf(address _owner) constant returns (uint256 balance) {
535         return uint256(tokenContract.balanceOf(_owner));
536     }
537 
538     function transfer(address _to, uint256 _value) returns (bool success) {
539         if (tokenContract.transfer(_to, _value)) {
540             Transfer(msg.sender, _to, _value);
541             return true;
542         } else {
543             throw;
544         }
545     }
546 
547     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
548         if (tokenContract.transferFrom(_from, _to, _value)) {
549             Transfer(_from, _to, _value);
550             return true;
551         } else {
552             throw;
553         }
554     }
555 
556     function approve(address _spender, uint256 _value) returns (bool success) {
557         if (tokenContract.approve(_spender,_value)) {
558             Approval(msg.sender,_spender,_value);
559             return true;
560         } else {
561             throw;
562         }
563     }
564 
565     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
566         return tokenContract.allowance(_owner,_spender);
567     }
568 
569     event Transfer(address indexed _from, address indexed _to, uint256 _value);
570     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
571 }