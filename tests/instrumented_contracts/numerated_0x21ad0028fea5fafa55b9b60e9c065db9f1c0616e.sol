1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Claimable is Ownable {
81   address public pendingOwner;
82 
83   /**
84    * @dev Modifier throws if called by any account other than the pendingOwner.
85    */
86   modifier onlyPendingOwner() {
87     require(msg.sender == pendingOwner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to set the pendingOwner address.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) onlyOwner public {
96     pendingOwner = newOwner;
97   }
98 
99   /**
100    * @dev Allows the pendingOwner address to finalize the transfer.
101    */
102   function claimOwnership() onlyPendingOwner public {
103     OwnershipTransferred(owner, pendingOwner);
104     owner = pendingOwner;
105     pendingOwner = address(0);
106   }
107 }
108 
109 contract ERC20Basic {
110   function totalSupply() public view returns (uint256);
111   function balanceOf(address who) public view returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 contract HasOperator is Claimable {
124     address public operator;
125 
126     function setOperator(address _operator) onlyOwner public {
127         operator = _operator;
128     }
129 
130     modifier ownerOrOperator {
131         require(msg.sender == owner || msg.sender == operator);
132         _;
133     }
134 }
135 
136 contract LikeCoin is ERC20, HasOperator {
137     using SafeMath for uint256;
138 
139     string constant public name = "LikeCoin";
140     string constant public symbol = "LIKE";
141 
142     // Synchronized to Ether -> Wei ratio, which is important
143     uint8 constant public decimals = 18;
144 
145     uint256 public supply = 0;
146     mapping(address => uint256) public balances;
147     mapping(address => mapping(address => uint256)) public allowed;
148 
149     address public crowdsaleAddr = 0x0;
150     address public contributorPoolAddr = 0x0;
151     uint256 public contributorPoolMintQuota = 0;
152     address[] public creatorsPoolAddrs;
153     mapping(address => bool) isCreatorsPool;
154     uint256 public creatorsPoolMintQuota = 0;
155     mapping(address => uint256) public lockedBalances;
156     uint public unlockTime = 0;
157     SignatureChecker public signatureChecker = SignatureChecker(0x0);
158     bool public signatureCheckerFreezed = false;
159     address public signatureOwner = 0x0;
160     bool public allowDelegate = true;
161     mapping (address => mapping (uint256 => bool)) public usedNonce;
162     mapping (address => bool) public transferAndCallWhitelist;
163 
164     event Lock(address indexed _addr, uint256 _value);
165     event SignatureCheckerChanged(address _newSignatureChecker);
166 
167     function LikeCoin(uint256 _initialSupply, address _signatureOwner, address _sigCheckerAddr) public {
168         supply = _initialSupply;
169         balances[owner] = _initialSupply;
170         signatureOwner = _signatureOwner;
171         signatureChecker = SignatureChecker(_sigCheckerAddr);
172         Transfer(0x0, owner, _initialSupply);
173     }
174 
175     function totalSupply() public constant returns (uint256) {
176         return supply;
177     }
178 
179     function balanceOf(address _owner) public constant returns (uint256 balance) {
180         return balances[_owner] + lockedBalances[_owner];
181     }
182 
183     function _tryUnlockBalance(address _from) internal {
184         if (unlockTime != 0 && now >= unlockTime && lockedBalances[_from] > 0) {
185             balances[_from] = balances[_from].add(lockedBalances[_from]);
186             delete lockedBalances[_from];
187         }
188     }
189 
190     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
191         _tryUnlockBalance(_from);
192         require(_from != 0x0);
193         require(_to != 0x0);
194         balances[_from] = balances[_from].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196         Transfer(_from, _to, _value);
197         return true;
198     }
199 
200     function transfer(address _to, uint256 _value) public returns (bool success) {
201         return _transfer(msg.sender, _to, _value);
202     }
203 
204     function transferAndLock(address _to, uint256 _value) public returns (bool success) {
205         require(msg.sender != 0x0);
206         require(_to != 0x0);
207         require(now < unlockTime);
208         require(msg.sender == crowdsaleAddr || msg.sender == owner || msg.sender == operator);
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         lockedBalances[_to] = lockedBalances[_to].add(_value);
211         Transfer(msg.sender, _to, _value);
212         Lock(_to, _value);
213         return true;
214     }
215 
216     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218         _transfer(_from, _to, _value);
219         return true;
220     }
221 
222     function _transferMultiple(address _from, address[] _addrs, uint256[] _values) internal returns (bool success) {
223         require(_from != 0x0);
224         require(_addrs.length > 0);
225         require(_values.length == _addrs.length);
226         _tryUnlockBalance(_from);
227         uint256 total = 0;
228         for (uint i = 0; i < _addrs.length; ++i) {
229             address addr = _addrs[i];
230             require(addr != 0x0);
231             uint256 value = _values[i];
232             balances[addr] = balances[addr].add(value);
233             total = total.add(value);
234             Transfer(_from, addr, value);
235         }
236         balances[_from] = balances[_from].sub(total);
237         return true;
238     }
239 
240     function transferMultiple(address[] _addrs, uint256[] _values) public returns (bool success) {
241         return _transferMultiple(msg.sender, _addrs, _values);
242     }
243 
244     function _isContract(address _addr) internal constant returns (bool) {
245         uint256 length;
246         assembly {
247             length := extcodesize(_addr)
248         }
249         return (length > 0);
250     }
251 
252     function _transferAndCall(address _from, address _to, uint256 _value, bytes _data) internal returns (bool success) {
253         require(_isContract(_to));
254         require(transferAndCallWhitelist[_to]);
255         require(_transfer(_from, _to, _value));
256         TransferAndCallReceiver(_to).tokenCallback(_from, _value, _data);
257         return true;
258     }
259 
260     function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool success) {
261         return _transferAndCall(msg.sender, _to, _value, _data);
262     }
263 
264     function setSignatureChecker(address _sigCheckerAddr) public {
265         require(msg.sender == signatureOwner);
266         require(!signatureCheckerFreezed);
267         require(signatureChecker != _sigCheckerAddr);
268         signatureChecker = SignatureChecker(_sigCheckerAddr);
269         SignatureCheckerChanged(_sigCheckerAddr);
270     }
271 
272     function freezeSignatureChecker() public {
273         require(msg.sender == signatureOwner);
274         require(!signatureCheckerFreezed);
275         signatureCheckerFreezed = true;
276     }
277 
278     modifier isDelegated(address _from, uint256 _maxReward, uint256 _claimedReward, uint256 _nonce) {
279         require(allowDelegate);
280         require(_from != 0x0);
281         require(_claimedReward <= _maxReward);
282         require(!usedNonce[_from][_nonce]);
283         usedNonce[_from][_nonce] = true;
284         require(_transfer(_from, msg.sender, _claimedReward));
285         _;
286     }
287 
288     function transferDelegated(
289         address _from,
290         address _to,
291         uint256 _value,
292         uint256 _maxReward,
293         uint256 _claimedReward,
294         uint256 _nonce,
295         bytes _signature
296     ) isDelegated(_from, _maxReward, _claimedReward, _nonce) public returns (bool success) {
297         require(signatureChecker.checkTransferDelegated(_from, _to, _value, _maxReward, _nonce, _signature));
298         return _transfer(_from, _to, _value);
299     }
300 
301     function transferAndCallDelegated(
302         address _from,
303         address _to,
304         uint256 _value,
305         bytes _data,
306         uint256 _maxReward,
307         uint256 _claimedReward,
308         uint256 _nonce,
309         bytes _signature
310     ) isDelegated(_from, _maxReward, _claimedReward, _nonce) public returns (bool success) {
311         require(signatureChecker.checkTransferAndCallDelegated(_from, _to, _value, _data, _maxReward, _nonce, _signature));
312         return _transferAndCall(_from, _to, _value, _data);
313     }
314 
315     function transferMultipleDelegated(
316         address _from,
317         address[] _addrs,
318         uint256[] _values,
319         uint256 _maxReward,
320         uint256 _claimedReward,
321         uint256 _nonce,
322         bytes _signature
323     ) isDelegated(_from, _maxReward, _claimedReward, _nonce) public returns (bool success) {
324         require(signatureChecker.checkTransferMultipleDelegated(_from, _addrs, _values, _maxReward, _nonce, _signature));
325         return _transferMultiple(_from, _addrs, _values);
326     }
327 
328     function switchDelegate(bool _allowed) ownerOrOperator public {
329         require(allowDelegate != _allowed);
330         allowDelegate = _allowed;
331     }
332 
333     function addTransferAndCallWhitelist(address _contract) ownerOrOperator public {
334         require(_isContract(_contract));
335         require(!transferAndCallWhitelist[_contract]);
336         transferAndCallWhitelist[_contract] = true;
337     }
338 
339     function removeTransferAndCallWhitelist(address _contract) ownerOrOperator public {
340         require(transferAndCallWhitelist[_contract]);
341         delete transferAndCallWhitelist[_contract];
342     }
343 
344     function approve(address _spender, uint256 _value) public returns (bool success) {
345         require(_value == 0 || allowed[msg.sender][_spender] == 0);
346         allowed[msg.sender][_spender] = _value;
347         Approval(msg.sender, _spender, _value);
348         return true;
349     }
350 
351     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
352         return allowed[_owner][_spender];
353     }
354 
355     function burn(uint256 _value) public {
356         balances[msg.sender] = balances[msg.sender].sub(_value);
357         supply = supply.sub(_value);
358         Transfer(msg.sender, 0x0, _value);
359     }
360 
361     function registerCrowdsales(address _crowdsaleAddr, uint256 _value, uint256 _privateFundUnlockTime) onlyOwner public {
362         require(crowdsaleAddr == 0x0);
363         require(_crowdsaleAddr != 0x0);
364         require(_isContract(_crowdsaleAddr));
365         require(_privateFundUnlockTime > now);
366         require(_value != 0);
367         unlockTime = _privateFundUnlockTime;
368         crowdsaleAddr = _crowdsaleAddr;
369         supply = supply.add(_value);
370         balances[_crowdsaleAddr] = balances[_crowdsaleAddr].add(_value);
371         Transfer(0x0, crowdsaleAddr, _value);
372     }
373 
374     function registerContributorPool(address _contributorPoolAddr, uint256 _mintLimit) onlyOwner public {
375         require(contributorPoolAddr == 0x0);
376         require(_contributorPoolAddr != 0x0);
377         require(_isContract(_contributorPoolAddr));
378         require(_mintLimit != 0);
379         contributorPoolAddr = _contributorPoolAddr;
380         contributorPoolMintQuota = _mintLimit;
381     }
382 
383     function mintForContributorPool(uint256 _value) public {
384         require(msg.sender == contributorPoolAddr);
385         require(_value != 0);
386         contributorPoolMintQuota = contributorPoolMintQuota.sub(_value);
387         supply = supply.add(_value);
388         balances[msg.sender] = balances[msg.sender].add(_value);
389         Transfer(0x0, msg.sender, _value);
390     }
391 
392     function registerCreatorsPools(address[] _poolAddrs, uint256 _mintLimit) onlyOwner public {
393         require(creatorsPoolAddrs.length == 0);
394         require(_poolAddrs.length > 0);
395         require(_mintLimit > 0);
396         for (uint i = 0; i < _poolAddrs.length; ++i) {
397             require(_isContract(_poolAddrs[i]));
398             creatorsPoolAddrs.push(_poolAddrs[i]);
399             isCreatorsPool[_poolAddrs[i]] = true;
400         }
401         creatorsPoolMintQuota = _mintLimit;
402     }
403 
404     function mintForCreatorsPool(uint256 _value) public {
405         require(isCreatorsPool[msg.sender]);
406         require(_value != 0);
407         creatorsPoolMintQuota = creatorsPoolMintQuota.sub(_value);
408         supply = supply.add(_value);
409         balances[msg.sender] = balances[msg.sender].add(_value);
410         Transfer(0x0, msg.sender, _value);
411     }
412 }
413 
414 contract LikeCrowdsale is HasOperator {
415     using SafeMath for uint256;
416 
417     LikeCoin public like = LikeCoin(0x0);
418     uint public start = 0;
419     uint public end = 0;
420     uint256 public coinsPerEth = 0;
421 
422     mapping (address => bool) public kycDone;
423 
424     bool finalized = false;
425 
426     event PriceChanged(uint256 _newPrice);
427     event AddPrivateFund(address indexed _addr, uint256 _value);
428     event RegisterKYC(address indexed _addr);
429     event Purchase(address indexed _addr, uint256 _ethers, uint256 _coins);
430     event LikeTransfer(address indexed _to, uint256 _value);
431     event Finalize();
432 
433     function LikeCrowdsale(address _likeAddr, uint _start, uint _end, uint256 _coinsPerEth) public {
434         require(_coinsPerEth != 0);
435         require(now < _start);
436         require(_start < _end);
437         owner = msg.sender;
438         like = LikeCoin(_likeAddr);
439         start = _start;
440         end = _end;
441         coinsPerEth = _coinsPerEth;
442     }
443 
444     function changePrice(uint256 _newCoinsPerEth) onlyOwner public {
445         require(_newCoinsPerEth != 0);
446         require(_newCoinsPerEth != coinsPerEth);
447         require(now < start);
448         coinsPerEth = _newCoinsPerEth;
449         PriceChanged(_newCoinsPerEth);
450     }
451 
452     function addPrivateFund(address _addr, uint256 _value) onlyOwner public {
453         require(now < start);
454         require(_value > 0);
455         like.transferAndLock(_addr, _value);
456         AddPrivateFund(_addr, _value);
457     }
458 
459     function registerKYC(address[] _customerAddrs) ownerOrOperator public {
460         for (uint32 i = 0; i < _customerAddrs.length; ++i) {
461             kycDone[_customerAddrs[i]] = true;
462             RegisterKYC(_customerAddrs[i]);
463         }
464     }
465 
466     function () public payable {
467         require(now >= start);
468         require(now < end);
469         require(!finalized);
470         require(msg.value > 0);
471         require(kycDone[msg.sender]);
472         uint256 coins = coinsPerEth.mul(msg.value);
473         like.transfer(msg.sender, coins);
474         Purchase(msg.sender, msg.value, coins);
475     }
476 
477     function transferLike(address _to, uint256 _value) onlyOwner public {
478         require(now < start || now >= end);
479         like.transfer(_to, _value);
480         LikeTransfer(_to, _value);
481     }
482 
483     function finalize() ownerOrOperator public {
484         require(!finalized);
485         require(now >= start);
486         uint256 remainingCoins = like.balanceOf(this);
487         require(now >= end || remainingCoins == 0);
488         owner.transfer(this.balance);
489         finalized = true;
490         Finalize();
491     }
492 }
493 
494 contract SignatureChecker {
495     function checkTransferDelegated(
496         address _from,
497         address _to,
498         uint256 _value,
499         uint256 _maxReward,
500         uint256 _nonce,
501         bytes _signature
502     ) public constant returns (bool);
503 
504     function checkTransferAndCallDelegated(
505         address _from,
506         address _to,
507         uint256 _value,
508         bytes _data,
509         uint256 _maxReward,
510         uint256 _nonce,
511         bytes _signature
512     ) public constant returns (bool);
513 
514     function checkTransferMultipleDelegated(
515         address _from,
516         address[] _addrs,
517         uint256[] _values,
518         uint256 _maxReward,
519         uint256 _nonce,
520         bytes _signature
521     ) public constant returns (bool);
522 }
523 
524 contract TransferAndCallReceiver {
525     function tokenCallback(address _from, uint256 _value, bytes _data) public;
526 }