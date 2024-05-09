1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address public owner;
8 
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner, "Sender not authorised.");
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner public {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49     uint256 public totalSupply;
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60     function allowance(address owner, address spender) public view returns (uint256);
61     function transferFrom(address from, address to, uint256 value) public returns (bool);
62     function approve(address spender, uint256 value) public returns (bool);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a * b;
73     assert(a == 0 || c / a == b);
74     return c;
75   }
76 
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85     assert(b <= a);
86     return a - b;
87   }
88 
89   function add(uint256 a, uint256 b) internal pure returns (uint256) {
90     uint256 c = a + b;
91     assert(c >= a);
92     return c;
93   }
94 }
95 
96 /**
97     @title ItMap, a solidity iterable map
98     @dev Credit to: https://gist.github.com/ethers/7e6d443818cbc9ad2c38efa7c0f363d1
99  */
100 library itmap {
101     struct entry {
102         // Equal to the index of the key of this item in keys, plus 1.
103         uint keyIndex;
104         uint value;
105     }
106 
107     struct itmap {
108         mapping(uint => entry) data;
109         uint[] keys;
110     }
111     
112     function insert(itmap storage self, uint key, uint value) internal returns (bool replaced) {
113         entry storage e = self.data[key];
114         e.value = value;
115         if (e.keyIndex > 0) {
116             return true;
117         } else {
118             e.keyIndex = ++self.keys.length;
119             self.keys[e.keyIndex - 1] = key;
120             return false;
121         }
122     }
123     
124     function remove(itmap storage self, uint key) internal returns (bool success) {
125         entry storage e = self.data[key];
126 
127         if (e.keyIndex == 0) {
128             return false;
129         }
130 
131         if (e.keyIndex < self.keys.length) {
132             // Move an existing element into the vacated key slot.
133             self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
134             self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
135         }
136 
137         self.keys.length -= 1;
138         delete self.data[key];
139         return true;
140     }
141     
142     function contains(itmap storage self, uint key) internal constant returns (bool exists) {
143         return self.data[key].keyIndex > 0;
144     }
145     
146     function size(itmap storage self) internal constant returns (uint) {
147         return self.keys.length;
148     }
149     
150     function get(itmap storage self, uint key) internal constant returns (uint) {
151         return self.data[key].value;
152     }
153     
154     function getKey(itmap storage self, uint idx) internal constant returns (uint) {
155         return self.keys[idx];
156     }
157 }
158 
159 /**
160     @title OwnersReceiver for transfer and calls
161  */
162 contract OwnersReceiver {
163     function onOwnershipTransfer(address _sender, uint _value, bytes _data) public;
164 }
165 
166 /**
167     @title PoolOwners, the crowdsale contract for LinkPool ownership
168  */
169 contract PoolOwners is Ownable {
170 
171     using SafeMath for uint256;
172     using itmap for itmap.itmap;
173 
174     itmap.itmap private ownerMap;
175 
176     mapping(address => mapping(address => uint256)) allowance;
177     mapping(address => bool) public tokenWhitelist;
178     mapping(address => bool) public whitelist;
179     mapping(address => uint256) public distributionMinimum;
180     
181     uint256 public totalContributed   = 0;
182     bool    public distributionActive = false;
183     uint256 public precisionMinimum   = 0.04 ether;
184     bool    public locked             = false;
185     address public wallet;
186 
187     bool    private contributionStarted = false;
188     uint256 private valuation           = 4000 ether;
189     uint256 private hardCap             = 1000 ether;
190     uint    private distribution        = 1;
191     address private dToken              = address(0);
192 
193     event Contribution(address indexed sender, uint256 share, uint256 amount);
194     event TokenDistributionActive(address indexed token, uint256 amount, uint256 amountOfOwners);
195     event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);
197     event TokenDistributionComplete(address indexed token, uint amount, uint256 amountOfOwners);
198 
199     modifier onlyPoolOwner() {
200         require(ownerMap.get(uint(msg.sender)) != 0, "You are not authorised to call this function");
201         _;
202     }
203 
204     /**
205         @dev Constructor set set the wallet initally
206         @param _wallet Address of the ETH wallet
207      */
208     constructor(address _wallet) public {
209         require(_wallet != address(0), "The ETH wallet address needs to be set");
210         wallet = _wallet;
211     }
212 
213     /**
214         @dev Fallback function, redirects to contribution
215         @dev Transfers tokens to LP wallet address
216      */
217     function() public payable {
218         require(contributionStarted, "Contribution is not active");
219         require(whitelist[msg.sender], "You are not whitelisted");
220         contribute(msg.sender, msg.value); 
221         wallet.transfer(msg.value);
222     }
223 
224     /**
225         @dev Manually set a contribution, used by owners to increase owners amounts
226         @param _sender The address of the sender to set the contribution for you
227         @param _amount The amount that the owner has sent
228      */
229     function addContribution(address _sender, uint256 _amount) public onlyOwner() { contribute(_sender, _amount); }
230 
231     /**
232         @dev Registers a new contribution, sets their share
233         @param _sender The address of the wallet contributing
234         @param _amount The amount that the owner has sent
235      */
236     function contribute(address _sender, uint256 _amount) private {
237         require(is128Bit(_amount), "Contribution amount isn't 128bit or smaller");
238         require(!locked, "Crowdsale period over, contribution is locked");
239         require(!distributionActive, "Cannot contribute when distribution is active");
240         require(_amount >= precisionMinimum, "Amount needs to be above the minimum contribution");
241         require(hardCap >= _amount, "Your contribution is greater than the hard cap");
242         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision");
243         require(hardCap >= totalContributed.add(_amount), "Your contribution would cause the total to exceed the hardcap");
244 
245         totalContributed = totalContributed.add(_amount);
246         uint256 share = percent(_amount, valuation, 5);
247 
248         uint owner = ownerMap.get(uint(_sender));
249         if (owner != 0) { // Existing owner
250             share += owner >> 128;
251             uint amount = (owner << 128 >> 128).add(_amount);
252             require(ownerMap.insert(uint(_sender), share << 128 | amount), "Sender does not exist in the map");
253         } else { // New owner
254             require(!ownerMap.insert(uint(_sender), share << 128 | _amount), "Map replacement detected");
255         }
256 
257         emit Contribution(_sender, share, _amount);
258     }
259 
260     /**
261         @dev Whitelist a wallet address
262         @param _owner Wallet of the owner
263      */
264     function whitelistWallet(address _owner) external onlyOwner() {
265         require(!locked, "Can't whitelist when the contract is locked");
266         require(_owner != address(0), "Blackhole address");
267         whitelist[_owner] = true;
268     }
269 
270     /**
271         @dev Start the distribution phase
272      */
273     function startContribution() external onlyOwner() {
274         require(!contributionStarted, "Contribution has started");
275         contributionStarted = true;
276     }
277 
278     /**
279         @dev Manually set a share directly, used to set the LinkPool members as owners
280         @param _owner Wallet address of the owner
281         @param _value The equivalent contribution value
282      */
283     function setOwnerShare(address _owner, uint256 _value) public onlyOwner() {
284         require(!locked, "Can't manually set shares, it's locked");
285         require(!distributionActive, "Cannot set owners share when distribution is active");
286         require(is128Bit(_value), "Contribution value isn't 128bit or smaller");
287 
288         uint owner = ownerMap.get(uint(_owner));
289         uint share;
290         if (owner == 0) {
291             share = percent(_value, valuation, 5);
292             require(!ownerMap.insert(uint(_owner), share << 128 | _value), "Map replacement detected");
293         } else {
294             share = (owner >> 128).add(percent(_value, valuation, 5));
295             uint value = (owner << 128 >> 128).add(_value);
296             require(ownerMap.insert(uint(_owner), share << 128 | value), "Sender does not exist in the map");
297         }
298     }
299 
300     /**
301         @dev Transfer part or all of your ownership to another address
302         @param _receiver The address that you're sending to
303         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
304      */
305     function sendOwnership(address _receiver, uint256 _amount) public onlyPoolOwner() {
306         _sendOwnership(msg.sender, _receiver, _amount);
307     }
308 
309     /**
310         @dev Transfer part or all of your ownership to another address and call the receiving contract
311         @param _receiver The address that you're sending to
312         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
313      */
314     function sendOwnershipAndCall(address _receiver, uint256 _amount, bytes _data) public onlyPoolOwner() {
315         _sendOwnership(msg.sender, _receiver, _amount);
316         if (isContract(_receiver)) {
317             contractFallback(_receiver, _amount, _data);
318         }
319     }
320 
321     /**
322         @dev Transfer part or all of your ownership to another address on behalf of an owner
323         @dev Same principle as approval in ERC20, to be used mostly by external contracts, eg DEX's
324         @param _owner The address of the owner who's having tokens sent on behalf of
325         @param _receiver The address that you're sending to
326         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
327      */
328     function sendOwnershipFrom(address _owner, address _receiver, uint256 _amount) public {
329         require(allowance[_owner][msg.sender] >= _amount, "Sender is not approved to send ownership of that amount");
330         allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);
331         if (allowance[_owner][msg.sender] == 0) {
332             delete allowance[_owner][msg.sender];
333         }
334         _sendOwnership(_owner, _receiver, _amount);
335     }
336 
337     function _sendOwnership(address _owner, address _receiver, uint256 _amount) private {
338         uint o = ownerMap.get(uint(_owner));
339         uint r = ownerMap.get(uint(_receiver));
340 
341         uint oTokens = o << 128 >> 128;
342         uint rTokens = r << 128 >> 128;
343 
344         require(is128Bit(_amount), "Amount isn't 128bit or smaller");
345         require(_owner != _receiver, "You can't send to yourself");
346         require(_receiver != address(0), "Ownership cannot be blackholed");
347         require(oTokens > 0, "You don't have any ownership");
348         require(oTokens >= _amount, "The amount exceeds what you have");
349         require(!distributionActive, "Distribution cannot be active when sending ownership");
350         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision amount");
351 
352         oTokens = oTokens.sub(_amount);
353 
354         if (oTokens == 0) {
355             require(ownerMap.remove(uint(_owner)), "Address doesn't exist in the map");
356         } else {
357             uint oPercentage = percent(oTokens, valuation, 5);
358             require(ownerMap.insert(uint(_owner), oPercentage << 128 | oTokens), "Sender does not exist in the map");
359         }
360         
361         uint rTNew = rTokens.add(_amount);
362         uint rPercentage = percent(rTNew, valuation, 5);
363         if (rTokens == 0) {
364             require(!ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Map replacement detected");
365         } else {
366             require(ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Sender does not exist in the map");
367         }
368 
369         emit OwnershipTransferred(_owner, _receiver, _amount);
370     }
371 
372     function contractFallback(address _receiver, uint256 _amount, bytes _data) private {
373         OwnersReceiver receiver = OwnersReceiver(_receiver);
374         receiver.onOwnershipTransfer(msg.sender, _amount, _data);
375     }
376 
377     function isContract(address _addr) private view returns (bool hasCode) {
378         uint length;
379         assembly { length := extcodesize(_addr) }
380         return length > 0;
381     }
382 
383     /**
384         @dev Increase the allowance of a sender
385         @param _sender The address of the sender on behalf of the owner
386         @param _amount The amount to increase approval by
387      */
388     function increaseAllowance(address _sender, uint256 _amount) public {
389         uint o = ownerMap.get(uint(msg.sender));
390         require(o << 128 >> 128 >= _amount, "The amount to increase allowance by is higher than your balance");
391         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].add(_amount);
392     }
393 
394     /**
395         @dev Decrease the allowance of a sender
396         @param _sender The address of the sender on behalf of the owner
397         @param _amount The amount to decrease approval by
398      */
399     function decreaseAllowance(address _sender, uint256 _amount) public {
400         require(allowance[msg.sender][_sender] >= _amount, "The amount to decrease allowance by is higher than the current allowance");
401         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].sub(_amount);
402         if (allowance[msg.sender][_sender] == 0) {
403             delete allowance[msg.sender][_sender];
404         }
405     }
406 
407     /**
408         @dev Lock the contribution/shares methods
409      */
410     function finishContribution() public onlyOwner() {
411         require(!locked, "Shares already locked");
412         locked = true;
413     }
414 
415     /**
416         @dev Start the distribution phase in the contract so owners can claim their tokens
417         @param _token The token address to start the distribution of
418      */
419     function distributeTokens(address _token) public onlyPoolOwner() {
420         require(tokenWhitelist[_token], "Token is not whitelisted to be distributed");
421         require(!distributionActive, "Distribution is already active");
422         distributionActive = true;
423 
424         uint256 currentBalance = ERC20(_token).balanceOf(this);
425         if (!is128Bit(currentBalance)) {
426             currentBalance = 1 << 128;
427         }
428         require(currentBalance > distributionMinimum[_token], "Amount in the contract isn't above the minimum distribution limit");
429 
430         distribution = currentBalance << 128;
431         dToken = _token;
432 
433         emit TokenDistributionActive(_token, currentBalance, ownerMap.size());
434     }
435 
436     /**
437         @dev Batch claiming of tokens for owners
438         @param _count The amount of owners to claim tokens for
439      */
440     function batchClaim(uint256 _count) public onlyPoolOwner() {
441         uint claimed = distribution << 128 >> 128;
442         uint to = _count.add(claimed);
443 
444         require(_count.add(claimed) <= ownerMap.size(), "To value is greater than the amount of owners");
445         for (uint256 i = claimed; i < to; i++) {
446             claimTokens(i);
447         }
448 
449         claimed = claimed.add(_count);
450         if (claimed == ownerMap.size()) {
451             distributionActive = false;
452             emit TokenDistributionComplete(dToken, distribution >> 128, ownerMap.size());
453         } else {
454             distribution = distribution >> 128 << 128 | claimed;
455         }
456     }
457 
458     /**
459         @dev Claim the tokens for the next owner in the map
460      */
461     function claimTokens(uint _i) private {
462         address owner = address(ownerMap.getKey(_i));
463         uint o = ownerMap.get(uint(owner));
464 
465         require(o >> 128 > 0, "You need to have a share to claim tokens");
466         require(distributionActive, "Distribution isn't active");
467 
468         uint256 tokenAmount = (distribution >> 128).mul(o >> 128).div(100000);
469         require(ERC20(dToken).transfer(owner, tokenAmount), "ERC20 transfer failed");
470     }
471 
472     /**
473         @dev Whitelist a token so it can be distributed
474         @dev Token whitelist is due to the potential of minting tokens and constantly lock this contract in distribution
475      */
476     function whitelistToken(address _token, uint256 _minimum) public onlyOwner() {
477         require(!tokenWhitelist[_token], "Token is already whitelisted");
478         tokenWhitelist[_token] = true;
479         distributionMinimum[_token] = _minimum;
480     }
481 
482     /**
483         @dev Set the minimum amount to be of transfered in this contract to start distribution
484         @param _minimum The minimum amount
485      */
486     function setDistributionMinimum(address _token, uint256 _minimum) public onlyOwner() {
487         distributionMinimum[_token] = _minimum;
488     }
489 
490     /**
491         @dev Get the amount of unclaimed owners in a distribution cycle
492      */
493     function getClaimedOwners() public view returns (uint) {
494         return distribution << 128 >> 128;
495     }
496 
497     /**
498         @dev Return an owners percentage
499         @param _owner The address of the owner
500      */
501     function getOwnerPercentage(address _owner) public view returns (uint) {
502         return ownerMap.get(uint(_owner)) >> 128;
503     }
504 
505     /**
506         @dev Return an owners share token amount
507         @param _owner The address of the owner
508      */
509     function getOwnerTokens(address _owner) public view returns (uint) {
510         return ownerMap.get(uint(_owner)) << 128 >> 128;
511     }
512 
513     /**
514         @dev Returns the current amount of active owners, ie share above 0
515      */
516     function getCurrentOwners() public view returns (uint) {
517         return ownerMap.size();
518     }
519 
520     /**
521         @dev Returns owner address based on the key
522         @param _i The index of the owner in the map
523      */
524     function getOwnerAddress(uint _i) public view returns (address) {
525         require(_i < ownerMap.size(), "Index is greater than the map size");
526         return address(ownerMap.getKey(_i));
527     }
528 
529     /**
530         @dev Returns the allowance amount for a sender address
531         @param _owner The address of the owner
532         @param _sender The address of the sender on an owners behalf
533      */
534     function getAllowance(address _owner, address _sender) public view returns (uint256) {
535         return allowance[_owner][_sender];
536     }
537 
538     /**
539         @dev Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
540      */
541     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
542         uint _numerator = numerator * 10 ** (precision+1);
543         uint _quotient = ((_numerator / denominator) + 5) / 10;
544         return ( _quotient);
545     }
546 
547     /**
548         @dev Strict type check for data packing
549         @param _val The value for checking
550      */
551     function is128Bit(uint _val) private pure returns (bool) {
552         return _val < 1 << 128;
553     }
554 }