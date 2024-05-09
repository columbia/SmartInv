1 pragma solidity ^0.4.1;
2 
3 // File: contracts/OwnerValidator.sol
4 
5 contract TokenContract {
6     function totalSupply() constant returns (uint256 supply);
7     function decimals() constant returns(uint8 units);
8     function balanceOf(address _owner) constant returns (uint256 balance);
9     function transfer(address _to, address _msgSender, uint256 _value) returns (bool success);
10     function transferFrom(address _from, address _to, address _msgSender, uint256 _value) returns (bool success);
11     function transferFromSender(address _to, uint256 _value) returns (bool success);
12     function approve(address _spender, address _msgSender, uint256 _value) returns (bool success);
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
119 contract OffChainManager {
120     function isToOffChainAddress(address addr) constant returns (bool);
121     function getOffChainRootAddress() constant returns (address);
122 }
123 
124 contract OffChainManagerImpl is OffChainManager, Owned {
125     address public rootAddress;
126     address[] public offChainAddreses;
127 
128     mapping (address => uint256) refOffChainAddresses; 
129 
130     OwnerValidator public ownerValidator;
131 
132     TokenContract public tokenContract;
133 
134     function OffChainManagerImpl(
135         address _rootAddress,
136         address _ownerValidator
137     ) {
138         rootAddress = _rootAddress;
139         ownerValidator = OwnerValidator(_ownerValidator);
140     }
141 
142     function setRootAddress(address _address) onlyWorking {
143         if (ownerValidator.validate(msg.sender)) {
144             rootAddress = _address;
145         }
146     }
147 
148     function setOwnerValidatorAddress(address _ownerValidator) onlyWorking {
149         if (ownerValidator.validate(msg.sender)) {
150             ownerValidator = OwnerValidator(_ownerValidator);
151         }
152     }
153 
154     function setTokenContract(address _tokenContract) {
155         if (ownerValidator.validate(msg.sender)) {
156             tokenContract = TokenContract(_tokenContract);
157         }
158     }
159 
160     function offChainAddresesValidCount() constant returns (uint) {
161         uint cnt = 0;
162         for (uint i = 0; i < offChainAddreses.length; i++) {
163             if (offChainAddreses[i] != 0) {
164                 cnt++;
165             }
166         }
167         return cnt;
168     }
169 
170     function addOffChainAddress(address _address) private {
171         if (!isToOffChainAddress(_address)) {
172             offChainAddreses.push(_address);
173             refOffChainAddresses[_address] = offChainAddreses.length;
174         }
175     }
176 
177     function removeOffChainAddress(address _address) private {
178         uint pos = refOffChainAddresses[_address];
179         if (pos > 0) {
180             offChainAddreses[pos - 1] = 0;
181             refOffChainAddresses[_address] = 0x0;
182         }
183     }
184 
185     function addOffChainAddresses(address[] _addresses) onlyWorking {
186         if (ownerValidator.validate(msg.sender)) {
187             for (uint i = 0; i < _addresses.length; i++) {
188                 addOffChainAddress(_addresses[i]);
189             }
190         }
191     }
192 
193     function removeOffChainAddresses(address[] _addresses) onlyWorking {
194         if (ownerValidator.validate(msg.sender)) {
195             for (uint i = 0; i < _addresses.length; i++) {
196                 removeOffChainAddress(_addresses[i]);
197             }
198         }
199     }
200 
201     function ownerValidate(address addr) constant returns (bool) {
202         return ownerValidator.validate(addr);
203     }
204 
205     function transferFromSender(address _to, uint256 _value) returns (bool success) {
206         if (!ownerValidator.validate(msg.sender)) throw;
207         return tokenContract.transferFromSender(_to, _value);
208     }
209 
210     function sendFromOwn(address _to, uint256 _value) returns (bool success) {
211         if (!ownerValidator.validate(msg.sender)) throw; 
212         if (!_to.send(_value)) throw;
213         return true;
214     }
215 
216     function isToOffChainAddress(address addr) constant returns (bool) {
217         return refOffChainAddresses[addr] > 0;
218     }
219 
220     function getOffChainRootAddress() constant returns (address) {
221         return rootAddress;
222     }
223 
224     function getOffChainAddresses() constant returns (address[]) {
225         return offChainAddreses;
226     } 
227 
228     function isToOffChainAddresses(address[] _addresses) constant returns (bool) {
229         for (uint i = 0; i < _addresses.length; i++) {
230             if (!isToOffChainAddress(_addresses[i])) {
231                 return false;
232             }
233         }
234         return true;
235     }
236 }
237 
238 // File: contracts/TokenContract.sol
239 
240 library SafeMath {
241   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
242     uint256 c = a * b;
243     assert(a == 0 || c / a == b);
244     return c;
245   }
246 
247   function div(uint256 a, uint256 b) internal constant returns (uint256) {
248 // assert(b > 0);
249     uint256 c = a / b;
250 // assert(a == b * c + a % b);
251     return c;
252   }
253 
254   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
255     assert(b <= a);
256     return a - b;
257   }
258 
259   function add(uint256 a, uint256 b) internal constant returns (uint256) {
260     uint256 c = a + b;
261     assert(c >= a);
262     return c;
263   }
264 }
265 
266 contract TokenContractImpl is TokenContract, Owned {
267     using SafeMath for uint256;
268     string public standard = "Token 0.1";
269     uint256 _totalSupply;
270     uint8 _decimals;
271     address public _mainAddress;
272 
273     mapping (address => uint256) public balances;
274     mapping (address => mapping (address => uint256)) public allowed;
275 
276     OwnerValidator public ownerValidator;
277     OffChainManager public offChainManager;
278 
279     bool public isRedenominated;
280     uint256 public redenomiValue;
281     mapping (address => uint256) public redenominatedBalances;
282     mapping (address => mapping (address => uint256)) public redenominatedAllowed;
283 
284     function TokenContractImpl(
285         uint256 initialSupply,
286         uint8 decimals,
287         address _ownerValidator,
288         address _offChainManager
289     ){
290         balances[msg.sender] = initialSupply;
291         _totalSupply = initialSupply;
292         _decimals = decimals;
293         ownerValidator = OwnerValidator(_ownerValidator);
294         offChainManager = OffChainManager(_offChainManager);
295     }
296 
297     function totalSupply() constant returns (uint256 totalSupply) {
298         if (isRedenominated) {
299             return redenominatedValue(_totalSupply);
300         }
301         return _totalSupply;
302     }
303 
304     function decimals() constant returns (uint8 decimals) {
305         return _decimals;
306     }
307 
308     function balanceOf(address _owner) constant returns (uint256 balance) {
309         if (isRedenominated) {
310             if (redenominatedBalances[_owner] > 0) {
311                 return redenominatedBalances[_owner];
312             }
313             return redenominatedValue(balances[_owner]);
314         }
315         return balances[_owner];
316     }
317 
318     function allowance(address _owner, address _spender) constant returns (uint remaining) {
319         if (isRedenominated) {
320             if (redenominatedAllowed[_owner][_spender] > 0) {
321                 return redenominatedAllowed[_owner][_spender];
322             }
323             return redenominatedValue(allowed[_owner][_spender]);
324         }
325         return allowed[_owner][_spender];
326     }
327 
328     function redenominatedValue(uint256 _value) private returns (uint256) {
329         return _value.mul(redenomiValue);
330     }
331 
332     function ownerValidate(address addr) constant returns (bool) {
333         return ownerValidator.validate(addr);
334     }
335 
336 
337     function redenominate(uint256 _redenomiValue) {
338         if (isRedenominated) throw;
339         if (ownerValidator.validate(msg.sender)) {
340             redenomiValue = _redenomiValue;
341             Redenominate(msg.sender, isRedenominated, redenomiValue);
342         }
343     }   
344 
345 
346     function applyRedenomination() onlyNotWorking {
347         if (isRedenominated) throw;
348         if (redenomiValue == 0) throw;
349         if (ownerValidator.validate(msg.sender)) {
350             isRedenominated = true;
351             ApplyRedenomination(msg.sender, isRedenominated, redenomiValue);
352         }
353     }   
354 
355     function setOwnerValidatorAddress(address _ownerValidator) onlyWorking {
356         if (ownerValidator.validate(msg.sender)) {
357             ownerValidator = OwnerValidator(_ownerValidator);
358         }
359     }
360 
361     function setOffChainManagerAddress(address _offChainManager) onlyWorking {
362         if (ownerValidator.validate(msg.sender)) {
363             offChainManager = OffChainManager(_offChainManager);
364         }
365     }
366 
367     function transfer(address _to, address _msgSender, uint256 _value) onlyWorking returns (bool success) {
368         if (msg.sender != _mainAddress) throw; 
369         return transferProcess(_msgSender, _to, _value);
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
412     function transferFrom(address _from, address _to, address _msgSender, uint256 _value) onlyWorking returns (bool success) {
413         if (msg.sender != _mainAddress) throw; 
414         if (balanceOf(_from) < _value) throw;
415         if (balanceOf(_to).add(_value) < balanceOf(_to)) throw;
416         if (_value > allowance(_from, _msgSender)) throw;
417         subtractBalance(_from, _value);
418         if (offChainManager.isToOffChainAddress(_to)) {
419             addBalance(offChainManager.getOffChainRootAddress(), _value);
420             ToOffChainTransfer(_msgSender, _to, _to, _value);
421         } else {
422             addBalance(_to, _value);
423         }
424         subtractAllowed(_from, _msgSender, _value);
425         return true;
426     }
427 
428 
429     function transferFromSender(address _to, uint256 _value) onlyWorking returns (bool success) {
430         if (!transferProcess(msg.sender, _to, _value)) throw;
431         TransferFromSender(msg.sender, _to, _value);
432         return true;
433     }
434 
435 
436     function transferFromOwn(address _to, uint256 _value) onlyWorking returns (bool success) {
437         if (!ownerValidator.validate(msg.sender)) throw;
438         if (!transferProcess(this, _to, _value)) throw;
439         TransferFromSender(this, _to, _value);    
440         return true;
441     }
442 
443     function sendFromOwn(address _to, uint256 _value) returns (bool success) {
444         if (!ownerValidator.validate(msg.sender)) throw; 
445         if (!_to.send(_value)) throw;
446         return true;
447     }
448 
449     function approve(address _spender, address _msgSender, uint256 _value) onlyWorking returns (bool success) {
450         if (msg.sender != _mainAddress) throw; 
451         setAllowed(_msgSender, _spender, _value);
452         return true;
453     }
454 
455     function subtractAllowed(address _from, address _spender, uint256 _value) private {
456         if (isRedenominated) {
457             if (redenominatedAllowed[_from][_spender] == 0) {
458                 if (allowed[_from][_spender] > 0) {
459                     redenominatedAllowed[_from][_spender] = redenominatedValue(allowed[_from][_spender]);
460                     allowed[_from][_spender] = 0;
461                 }
462             }
463             redenominatedAllowed[_from][_spender] = redenominatedAllowed[_from][_spender].sub(_value);
464         } else {
465             allowed[_from][_spender] = allowed[_from][_spender].sub(_value);
466         }
467     }
468 
469     function setAllowed(address _owner, address _spender, uint256 _value) private {
470         if (isRedenominated) {
471             redenominatedAllowed[_owner][_spender] = _value;
472         } else {
473             allowed[_owner][_spender] = _value;
474         }
475     }
476 
477     function setMainAddress(address _address) onlyOwner {
478         _mainAddress = _address;
479     }
480 
481     event TransferFromSender(address indexed _from, address indexed _to, uint256 _value);
482     event ToOffChainTransfer(address indexed _from, address indexed _toKey, address _to, uint256 _value);
483     event Redenominate(address _owner, bool _isRedenominated, uint256 _redenomiVakye);
484     event ApplyRedenomination(address _owner, bool _isRedenominated, uint256 _redenomiVakye);
485 }
486 
487 // File: contracts/MainContract.sol
488 
489 contract MainContract {
490     string public standard = "Token 0.1";
491     string public name;
492     string public symbol;
493 
494     OwnerValidator public ownerValidator;
495     TokenContract public tokenContract;
496 
497     function MainContract(
498         string _tokenName,
499         address _ownerValidator,
500         address _tokenContract,
501         string _symbol
502     ) {
503         ownerValidator = OwnerValidator(_ownerValidator);
504         tokenContract = TokenContract(_tokenContract);
505         name = _tokenName;
506         symbol = _symbol;
507     }
508 
509     function totalSupply() constant returns(uint256 totalSupply) {
510         return tokenContract.totalSupply();
511     }
512 
513     function decimals() constant returns(uint8 decimals) {
514         return tokenContract.decimals();
515     }
516 
517     function setOwnerValidateAddress(address _ownerValidator) {
518         if (ownerValidator.validate(msg.sender)) {
519             ownerValidator = OwnerValidator(_ownerValidator);
520         }
521     }
522 
523     function setTokenContract(address _tokenContract) {
524         if (ownerValidator.validate(msg.sender)) {
525             tokenContract = TokenContract(_tokenContract);
526         }
527     }
528 
529     function transferFromSender(address _to, uint256 _value) returns (bool success) {
530         if (!ownerValidator.validate(msg.sender)) throw;
531         return tokenContract.transferFromSender(_to, _value);
532     }
533 
534     function sendFromOwn(address _to, uint256 _value) returns (bool success) {
535         if (!ownerValidator.validate(msg.sender)) throw; 
536         if (!_to.send(_value)) throw;
537         return true;
538     }
539 
540     function balanceOf(address _owner) constant returns (uint256 balance) {
541         return uint256(tokenContract.balanceOf(_owner));
542     }
543 
544     function transfer(address _to, uint256 _value) returns (bool success) {
545         if (tokenContract.transfer(_to, msg.sender, _value)) {
546             Transfer(msg.sender, _to, _value);
547             return true;
548         } else {
549             throw;
550         }
551     }
552 
553     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
554         if (tokenContract.transferFrom(_from, _to, msg.sender, _value)) {
555             Transfer(_from, _to, _value);
556             return true;
557         } else {
558             throw;
559         }
560     }
561 
562     function approve(address _spender, uint256 _value) returns (bool success) {
563         if (tokenContract.approve(_spender,msg.sender,_value)) {
564             Approval(msg.sender,_spender,_value);
565             return true;
566         } else {
567             throw;
568         }
569     }
570 
571     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
572         return tokenContract.allowance(_owner,_spender);
573     }
574 
575     event Transfer(address indexed _from, address indexed _to, uint256 _value);
576     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
577 }