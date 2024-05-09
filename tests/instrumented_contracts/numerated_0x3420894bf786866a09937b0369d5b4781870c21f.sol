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
123 contract ContributorPool is Claimable {
124     LikeCoin public like = LikeCoin(0x0);
125     uint public mintCoolDown = 0;
126     uint256 public mintValue = 0;
127     uint public nextMintTime = 0;
128 
129     function ContributorPool(address _likeAddr, uint _mintCoolDown, uint256 _mintValue) public {
130         require(_mintValue > 0);
131         require(_mintCoolDown > 0);
132         like = LikeCoin(_likeAddr);
133         mintCoolDown = _mintCoolDown;
134         mintValue = _mintValue;
135     }
136 
137     function mint() onlyOwner public {
138         require(now > nextMintTime);
139         nextMintTime = now + mintCoolDown;
140         like.mintForContributorPool(mintValue);
141     }
142 
143     function transfer(address _to, uint256 _value) onlyOwner public {
144         require(_value > 0);
145         like.transfer(_to, _value);
146     }
147 }
148 
149 contract HasOperator is Claimable {
150     address public operator;
151 
152     function setOperator(address _operator) onlyOwner public {
153         operator = _operator;
154     }
155 
156     modifier ownerOrOperator {
157         require(msg.sender == owner || msg.sender == operator);
158         _;
159     }
160 }
161 
162 contract LikeCoin is ERC20, HasOperator {
163     using SafeMath for uint256;
164 
165     string constant public name = "LikeCoin";
166     string constant public symbol = "LIKE";
167 
168     // Synchronized to Ether -> Wei ratio, which is important
169     uint8 constant public decimals = 18;
170 
171     uint256 public supply = 0;
172     mapping(address => uint256) public balances;
173     mapping(address => mapping(address => uint256)) public allowed;
174 
175     address public crowdsaleAddr = 0x0;
176     address public contributorPoolAddr = 0x0;
177     uint256 public contributorPoolMintQuota = 0;
178     address[] public creatorsPoolAddrs;
179     mapping(address => bool) isCreatorsPool;
180     uint256 public creatorsPoolMintQuota = 0;
181     mapping(address => uint256) public lockedBalances;
182     uint public unlockTime = 0;
183     SignatureChecker public signatureChecker = SignatureChecker(0x0);
184     bool public signatureCheckerFreezed = false;
185     address public signatureOwner = 0x0;
186     bool public allowDelegate = true;
187     mapping (address => mapping (uint256 => bool)) public usedNonce;
188     mapping (address => bool) public transferAndCallWhitelist;
189 
190     event Lock(address indexed _addr, uint256 _value);
191     event SignatureCheckerChanged(address _newSignatureChecker);
192 
193     function LikeCoin(uint256 _initialSupply, address _signatureOwner, address _sigCheckerAddr) public {
194         supply = _initialSupply;
195         balances[owner] = _initialSupply;
196         signatureOwner = _signatureOwner;
197         signatureChecker = SignatureChecker(_sigCheckerAddr);
198         Transfer(0x0, owner, _initialSupply);
199     }
200 
201     function totalSupply() public constant returns (uint256) {
202         return supply;
203     }
204 
205     function balanceOf(address _owner) public constant returns (uint256 balance) {
206         return balances[_owner] + lockedBalances[_owner];
207     }
208 
209     function _tryUnlockBalance(address _from) internal {
210         if (unlockTime != 0 && now >= unlockTime && lockedBalances[_from] > 0) {
211             balances[_from] = balances[_from].add(lockedBalances[_from]);
212             delete lockedBalances[_from];
213         }
214     }
215 
216     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
217         _tryUnlockBalance(_from);
218         require(_from != 0x0);
219         require(_to != 0x0);
220         balances[_from] = balances[_from].sub(_value);
221         balances[_to] = balances[_to].add(_value);
222         Transfer(_from, _to, _value);
223         return true;
224     }
225 
226     function transfer(address _to, uint256 _value) public returns (bool success) {
227         return _transfer(msg.sender, _to, _value);
228     }
229 
230     function transferAndLock(address _to, uint256 _value) public returns (bool success) {
231         require(msg.sender != 0x0);
232         require(_to != 0x0);
233         require(now < unlockTime);
234         require(msg.sender == crowdsaleAddr || msg.sender == owner || msg.sender == operator);
235         balances[msg.sender] = balances[msg.sender].sub(_value);
236         lockedBalances[_to] = lockedBalances[_to].add(_value);
237         Transfer(msg.sender, _to, _value);
238         Lock(_to, _value);
239         return true;
240     }
241 
242     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
243         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
244         _transfer(_from, _to, _value);
245         return true;
246     }
247 
248     function _transferMultiple(address _from, address[] _addrs, uint256[] _values) internal returns (bool success) {
249         require(_from != 0x0);
250         require(_addrs.length > 0);
251         require(_values.length == _addrs.length);
252         _tryUnlockBalance(_from);
253         uint256 total = 0;
254         for (uint i = 0; i < _addrs.length; ++i) {
255             address addr = _addrs[i];
256             require(addr != 0x0);
257             uint256 value = _values[i];
258             balances[addr] = balances[addr].add(value);
259             total = total.add(value);
260             Transfer(_from, addr, value);
261         }
262         balances[_from] = balances[_from].sub(total);
263         return true;
264     }
265 
266     function transferMultiple(address[] _addrs, uint256[] _values) public returns (bool success) {
267         return _transferMultiple(msg.sender, _addrs, _values);
268     }
269 
270     function _isContract(address _addr) internal constant returns (bool) {
271         uint256 length;
272         assembly {
273             length := extcodesize(_addr)
274         }
275         return (length > 0);
276     }
277 
278     function _transferAndCall(address _from, address _to, uint256 _value, bytes _data) internal returns (bool success) {
279         require(_isContract(_to));
280         require(transferAndCallWhitelist[_to]);
281         require(_transfer(_from, _to, _value));
282         TransferAndCallReceiver(_to).tokenCallback(_from, _value, _data);
283         return true;
284     }
285 
286     function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool success) {
287         return _transferAndCall(msg.sender, _to, _value, _data);
288     }
289 
290     function setSignatureChecker(address _sigCheckerAddr) public {
291         require(msg.sender == signatureOwner);
292         require(!signatureCheckerFreezed);
293         require(signatureChecker != _sigCheckerAddr);
294         signatureChecker = SignatureChecker(_sigCheckerAddr);
295         SignatureCheckerChanged(_sigCheckerAddr);
296     }
297 
298     function freezeSignatureChecker() public {
299         require(msg.sender == signatureOwner);
300         require(!signatureCheckerFreezed);
301         signatureCheckerFreezed = true;
302     }
303 
304     modifier isDelegated(address _from, uint256 _maxReward, uint256 _claimedReward, uint256 _nonce) {
305         require(allowDelegate);
306         require(_from != 0x0);
307         require(_claimedReward <= _maxReward);
308         require(!usedNonce[_from][_nonce]);
309         usedNonce[_from][_nonce] = true;
310         require(_transfer(_from, msg.sender, _claimedReward));
311         _;
312     }
313 
314     function transferDelegated(
315         address _from,
316         address _to,
317         uint256 _value,
318         uint256 _maxReward,
319         uint256 _claimedReward,
320         uint256 _nonce,
321         bytes _signature
322     ) isDelegated(_from, _maxReward, _claimedReward, _nonce) public returns (bool success) {
323         require(signatureChecker.checkTransferDelegated(_from, _to, _value, _maxReward, _nonce, _signature));
324         return _transfer(_from, _to, _value);
325     }
326 
327     function transferAndCallDelegated(
328         address _from,
329         address _to,
330         uint256 _value,
331         bytes _data,
332         uint256 _maxReward,
333         uint256 _claimedReward,
334         uint256 _nonce,
335         bytes _signature
336     ) isDelegated(_from, _maxReward, _claimedReward, _nonce) public returns (bool success) {
337         require(signatureChecker.checkTransferAndCallDelegated(_from, _to, _value, _data, _maxReward, _nonce, _signature));
338         return _transferAndCall(_from, _to, _value, _data);
339     }
340 
341     function transferMultipleDelegated(
342         address _from,
343         address[] _addrs,
344         uint256[] _values,
345         uint256 _maxReward,
346         uint256 _claimedReward,
347         uint256 _nonce,
348         bytes _signature
349     ) isDelegated(_from, _maxReward, _claimedReward, _nonce) public returns (bool success) {
350         require(signatureChecker.checkTransferMultipleDelegated(_from, _addrs, _values, _maxReward, _nonce, _signature));
351         return _transferMultiple(_from, _addrs, _values);
352     }
353 
354     function switchDelegate(bool _allowed) ownerOrOperator public {
355         require(allowDelegate != _allowed);
356         allowDelegate = _allowed;
357     }
358 
359     function addTransferAndCallWhitelist(address _contract) ownerOrOperator public {
360         require(_isContract(_contract));
361         require(!transferAndCallWhitelist[_contract]);
362         transferAndCallWhitelist[_contract] = true;
363     }
364 
365     function removeTransferAndCallWhitelist(address _contract) ownerOrOperator public {
366         require(transferAndCallWhitelist[_contract]);
367         delete transferAndCallWhitelist[_contract];
368     }
369 
370     function approve(address _spender, uint256 _value) public returns (bool success) {
371         require(_value == 0 || allowed[msg.sender][_spender] == 0);
372         allowed[msg.sender][_spender] = _value;
373         Approval(msg.sender, _spender, _value);
374         return true;
375     }
376 
377     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
378         return allowed[_owner][_spender];
379     }
380 
381     function burn(uint256 _value) public {
382         balances[msg.sender] = balances[msg.sender].sub(_value);
383         supply = supply.sub(_value);
384         Transfer(msg.sender, 0x0, _value);
385     }
386 
387     function registerCrowdsales(address _crowdsaleAddr, uint256 _value, uint256 _privateFundUnlockTime) onlyOwner public {
388         require(crowdsaleAddr == 0x0);
389         require(_crowdsaleAddr != 0x0);
390         require(_isContract(_crowdsaleAddr));
391         require(_privateFundUnlockTime > now);
392         require(_value != 0);
393         unlockTime = _privateFundUnlockTime;
394         crowdsaleAddr = _crowdsaleAddr;
395         supply = supply.add(_value);
396         balances[_crowdsaleAddr] = balances[_crowdsaleAddr].add(_value);
397         Transfer(0x0, crowdsaleAddr, _value);
398     }
399 
400     function registerContributorPool(address _contributorPoolAddr, uint256 _mintLimit) onlyOwner public {
401         require(contributorPoolAddr == 0x0);
402         require(_contributorPoolAddr != 0x0);
403         require(_isContract(_contributorPoolAddr));
404         require(_mintLimit != 0);
405         contributorPoolAddr = _contributorPoolAddr;
406         contributorPoolMintQuota = _mintLimit;
407     }
408 
409     function mintForContributorPool(uint256 _value) public {
410         require(msg.sender == contributorPoolAddr);
411         require(_value != 0);
412         contributorPoolMintQuota = contributorPoolMintQuota.sub(_value);
413         supply = supply.add(_value);
414         balances[msg.sender] = balances[msg.sender].add(_value);
415         Transfer(0x0, msg.sender, _value);
416     }
417 
418     function registerCreatorsPools(address[] _poolAddrs, uint256 _mintLimit) onlyOwner public {
419         require(creatorsPoolAddrs.length == 0);
420         require(_poolAddrs.length > 0);
421         require(_mintLimit > 0);
422         for (uint i = 0; i < _poolAddrs.length; ++i) {
423             require(_isContract(_poolAddrs[i]));
424             creatorsPoolAddrs.push(_poolAddrs[i]);
425             isCreatorsPool[_poolAddrs[i]] = true;
426         }
427         creatorsPoolMintQuota = _mintLimit;
428     }
429 
430     function mintForCreatorsPool(uint256 _value) public {
431         require(isCreatorsPool[msg.sender]);
432         require(_value != 0);
433         creatorsPoolMintQuota = creatorsPoolMintQuota.sub(_value);
434         supply = supply.add(_value);
435         balances[msg.sender] = balances[msg.sender].add(_value);
436         Transfer(0x0, msg.sender, _value);
437     }
438 }
439 
440 contract SignatureChecker {
441     function checkTransferDelegated(
442         address _from,
443         address _to,
444         uint256 _value,
445         uint256 _maxReward,
446         uint256 _nonce,
447         bytes _signature
448     ) public constant returns (bool);
449 
450     function checkTransferAndCallDelegated(
451         address _from,
452         address _to,
453         uint256 _value,
454         bytes _data,
455         uint256 _maxReward,
456         uint256 _nonce,
457         bytes _signature
458     ) public constant returns (bool);
459 
460     function checkTransferMultipleDelegated(
461         address _from,
462         address[] _addrs,
463         uint256[] _values,
464         uint256 _maxReward,
465         uint256 _nonce,
466         bytes _signature
467     ) public constant returns (bool);
468 }
469 
470 contract TransferAndCallReceiver {
471     function tokenCallback(address _from, uint256 _value, bytes _data) public;
472 }