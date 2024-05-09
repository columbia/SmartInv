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
160     @title OwnersReceiver
161     @dev PoolOwners supporting receiving contract
162  */
163 contract OwnersReceiver {
164     function onOwnershipTransfer(address _sender, uint _value, bytes _data) public;
165     function onOwnershipStake(address _sender, uint _value, bytes _data) public;
166     function onOwnershipStakeRemoval(address _sender, uint _value, bytes _data) public;
167 }
168 
169 /**
170     @title PoolOwners
171     @dev ERC20 token distribution to holders based on share ownership
172  */
173 contract PoolOwners is Ownable {
174 
175     using SafeMath for uint256;
176     using itmap for itmap.itmap;
177 
178     itmap.itmap private ownerMap;
179 
180     mapping(address => mapping(address => uint256)) public allowance;
181     mapping(address => mapping(address => uint256)) public stakes;
182     mapping(address => uint256) public stakeTotals;
183     mapping(address => bool) public tokenWhitelist;
184     mapping(address => bool) public whitelist;
185     mapping(address => uint256) public distributionMinimum;
186     
187     uint256 public totalContributed = 0;
188     uint256 public precisionMinimum = 0.04 ether;
189     uint256 private valuation = 4000 ether;
190     uint256 private hardCap = 1000 ether;
191     uint256 private distribution = 1;
192     
193     bool public distributionActive = false;
194     bool public locked = false;
195     bool private contributionStarted = false;
196 
197     address public wallet;
198     address private dToken = address(0);
199     
200     uint   public constant totalSupply = 4000 ether;
201     string public constant name = "LinkPool Owners";
202     uint8  public constant decimals = 18;
203     string public constant symbol = "LP";
204 
205     event Contribution(address indexed sender, uint256 share, uint256 amount);
206     event TokenDistributionActive(address indexed token, uint256 amount, uint256 amountOfOwners);
207     event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);
209     event TokenDistributionComplete(address indexed token, uint amount, uint256 amountOfOwners);
210     event OwnershipStaked(address indexed owner, address indexed receiver, uint256 amount);
211     event OwnershipStakeRemoved(address indexed owner, address indexed receiver, uint256 amount);
212 
213     modifier onlyPoolOwner() {
214         require(ownerMap.get(uint(msg.sender)) != 0, "You are not authorised to call this function");
215         _;
216     }
217 
218     modifier withinPrecision(uint256 _amount) {
219         require(_amount > 0, "Cannot use zero");
220         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision amount");
221         _;
222     }
223 
224     /**
225         @dev Constructor set set the wallet initally
226         @param _wallet Address of the ETH wallet
227      */
228     constructor(address _wallet) public {
229         require(_wallet != address(0), "The ETH wallet address needs to be set");
230         wallet = _wallet;
231         tokenWhitelist[address(0)] = true; // 0x0 treated as ETH
232     }
233 
234     /**
235         @dev Fallback function, redirects to contribution
236         @dev Transfers tokens to the wallet address
237      */
238     function() public payable {
239         if (!locked) {
240             require(contributionStarted, "Contribution is not active");
241             require(whitelist[msg.sender], "You are not whitelisted");
242             contribute(msg.sender, msg.value); 
243             wallet.transfer(msg.value);
244         }
245     }
246 
247     /**
248         @dev Manually set a contribution, used by owners to increase owners amounts
249         @param _sender The address of the sender to set the contribution for you
250         @param _value The amount that the owner has sent
251      */
252     function addContribution(address _sender, uint256 _value) public onlyOwner() { contribute(_sender, _value); }
253 
254     /**
255         @dev Registers a new contribution, sets their share
256         @param _sender The address of the wallet contributing
257         @param _value The amount that the owner has sent
258      */
259     function contribute(address _sender, uint256 _value) private withinPrecision(_value) {
260         require(_is128Bit(_value), "Contribution amount isn't 128bit or smaller");
261         require(!locked, "Crowdsale period over, contribution is locked");
262         require(!distributionActive, "Cannot contribute when distribution is active");
263         require(_value >= precisionMinimum, "Amount needs to be above the minimum contribution");
264         require(hardCap >= _value, "Your contribution is greater than the hard cap");
265         require(hardCap >= totalContributed.add(_value), "Your contribution would cause the total to exceed the hardcap");
266 
267         totalContributed = totalContributed.add(_value);
268         uint256 share = percent(_value, valuation, 5);
269 
270         uint owner = ownerMap.get(uint(_sender));
271         if (owner != 0) { // Existing owner
272             share += owner >> 128;
273             uint value = (owner << 128 >> 128).add(_value);
274             require(ownerMap.insert(uint(_sender), share << 128 | value), "Sender does not exist in the map");
275         } else { // New owner
276             require(!ownerMap.insert(uint(_sender), share << 128 | _value), "Map replacement detected");
277         }
278 
279         emit Contribution(_sender, share, _value);
280     }
281 
282     /**
283         @dev Whitelist a wallet address
284         @param _owner Wallet of the owner
285      */
286     function whitelistWallet(address _owner) external onlyOwner() {
287         require(!locked, "Can't whitelist when the contract is locked");
288         require(_owner != address(0), "Blackhole address");
289         whitelist[_owner] = true;
290     }
291 
292     /**
293         @dev Start the distribution phase
294      */
295     function startContribution() external onlyOwner() {
296         require(!contributionStarted, "Contribution has started");
297         contributionStarted = true;
298     }
299 
300     /**
301         @dev Manually set a share directly, used to set the LinkPool members as owners
302         @param _owner Wallet address of the owner
303         @param _value The equivalent contribution value
304      */
305     function setOwnerShare(address _owner, uint256 _value) public onlyOwner() withinPrecision(_value) {
306         require(!locked, "Can't manually set shares, it's locked");
307         require(!distributionActive, "Cannot set owners share when distribution is active");
308         require(_is128Bit(_value), "Contribution value isn't 128bit or smaller");
309 
310         uint owner = ownerMap.get(uint(_owner));
311         uint share;
312         if (owner == 0) {
313             share = percent(_value, valuation, 5);
314             require(!ownerMap.insert(uint(_owner), share << 128 | _value), "Map replacement detected");
315         } else {
316             share = (owner >> 128).add(percent(_value, valuation, 5));
317             uint value = (owner << 128 >> 128).add(_value);
318             require(ownerMap.insert(uint(_owner), share << 128 | value), "Sender does not exist in the map");
319         }
320     }
321 
322     /**
323         @dev Transfer part or all of your ownership to another address
324         @param _receiver The address that you're sending to
325         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
326      */
327     function sendOwnership(address _receiver, uint256 _amount) public onlyPoolOwner() {
328         _sendOwnership(msg.sender, _receiver, _amount);
329     }
330 
331     /**
332         @dev Transfer part or all of your ownership to another address and call the receiving contract
333         @param _receiver The address that you're sending to
334         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
335      */
336     function sendOwnershipAndCall(address _receiver, uint256 _amount, bytes _data) public onlyPoolOwner() {
337         _sendOwnership(msg.sender, _receiver, _amount);
338         if (_isContract(_receiver)) {
339             OwnersReceiver(_receiver).onOwnershipTransfer(msg.sender, _amount, _data);
340         }
341     }
342 
343     /**
344         @dev Transfer part or all of your ownership to another address on behalf of an owner
345         @dev Same principle as approval in ERC20, to be used mostly by external contracts, eg DEX's
346         @param _owner The address of the owner who's having tokens sent on behalf of
347         @param _receiver The address that you're sending to
348         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
349      */
350     function sendOwnershipFrom(address _owner, address _receiver, uint256 _amount) public {
351         require(allowance[_owner][msg.sender] >= _amount, "Sender is not approved to send ownership of that amount");
352         allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);
353         if (allowance[_owner][msg.sender] == 0) {
354             delete allowance[_owner][msg.sender];
355         }
356         _sendOwnership(_owner, _receiver, _amount);
357     }
358 
359     /**
360         @dev Increase the allowance of a sender
361         @param _sender The address of the sender on behalf of the owner
362         @param _amount The amount to increase approval by
363      */
364     function increaseAllowance(address _sender, uint256 _amount) public withinPrecision(_amount) {
365         uint o = ownerMap.get(uint(msg.sender));
366         require(o << 128 >> 128 >= _amount, "The amount to increase allowance by is higher than your balance");
367         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].add(_amount);
368     }
369 
370     /**
371         @dev Decrease the allowance of a sender
372         @param _sender The address of the sender on behalf of the owner
373         @param _amount The amount to decrease approval by
374      */
375     function decreaseAllowance(address _sender, uint256 _amount) public withinPrecision(_amount) {
376         require(allowance[msg.sender][_sender] >= _amount, "The amount to decrease allowance by is higher than the current allowance");
377         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].sub(_amount);
378         if (allowance[msg.sender][_sender] == 0) {
379             delete allowance[msg.sender][_sender];
380         }
381     }
382 
383     /**
384         @dev Stakes ownership with a contract, locking it from being transferred
385         @dev Calls the `onOwnershipStake` implementation on the receiver
386         @param _receiver The contract address to receive the stake
387         @param _amount The amount to be staked
388         @param _data Subsequent data to be sent with the stake
389      */
390     function stakeOwnership(address _receiver, uint256 _amount, bytes _data) public withinPrecision(_amount) {
391         uint o = ownerMap.get(uint(msg.sender));
392         require((o << 128 >> 128).sub(stakeTotals[msg.sender]) >= _amount, "The amount to be staked is higher than your balance");
393         stakeTotals[msg.sender] = stakeTotals[msg.sender].add(_amount);
394         stakes[msg.sender][_receiver] = stakes[msg.sender][_receiver].add(_amount);
395         OwnersReceiver(_receiver).onOwnershipStake(msg.sender, _amount, _data);
396         emit OwnershipStaked(msg.sender, _receiver, _amount);
397     }
398 
399     /**
400         @dev Removes an ownership stake
401         @dev Calls the `onOwnershipStakeRemoval` implementation on the receiver
402         @param _receiver The contract address to remove the stake
403         @param _amount The amount of the stake to be removed
404         @param _data Subsequent data to be sent with the stake
405      */
406     function removeOwnershipStake(address _receiver, uint256 _amount, bytes _data) public withinPrecision(_amount) {
407         require(stakeTotals[msg.sender] >= _amount, "The stake amount to remove is higher than what's staked");
408         require(stakes[msg.sender][_receiver] >= _amount, "The stake amount to remove is greater than what's staked with the receiver");
409         stakeTotals[msg.sender] = stakeTotals[msg.sender].sub(_amount);
410         stakes[msg.sender][_receiver] = stakes[msg.sender][_receiver].sub(_amount);
411         if (stakes[msg.sender][_receiver] == 0) {
412             delete stakes[msg.sender][_receiver];
413         }
414         if (stakeTotals[msg.sender] == 0) {
415             delete stakeTotals[msg.sender];
416         }
417         OwnersReceiver(_receiver).onOwnershipStakeRemoval(msg.sender, _amount, _data);
418         emit OwnershipStakeRemoved(msg.sender, _receiver, _amount);
419     }
420 
421     /**
422         @dev Lock the contribution/shares methods
423      */
424     function finishContribution() public onlyOwner() {
425         require(!locked, "Shares already locked");
426         locked = true;
427     }
428 
429     /**
430         @dev Start the distribution phase in the contract so owners can claim their tokens
431         @param _token The token address to start the distribution of
432      */
433     function distributeTokens(address _token) public onlyPoolOwner() {
434         require(tokenWhitelist[_token], "Token is not whitelisted to be distributed");
435         require(!distributionActive, "Distribution is already active");
436         distributionActive = true;
437 
438         uint256 currentBalance;
439         if (_token == address(0)) {
440             currentBalance = address(this).balance;
441         } else {
442             currentBalance = ERC20(_token).balanceOf(this);
443         }
444         if (!_is128Bit(currentBalance)) {
445             currentBalance = 1 << 128;
446         }
447         require(currentBalance > distributionMinimum[_token], "Amount in the contract isn't above the minimum distribution limit");
448 
449         distribution = currentBalance << 128;
450         dToken = _token;
451 
452         emit TokenDistributionActive(_token, currentBalance, ownerMap.size());
453     }
454 
455     /**
456         @dev Batch claiming of tokens for owners
457         @param _count The amount of owners to claim tokens for
458      */
459     function batchClaim(uint256 _count) public onlyPoolOwner() {
460         require(distributionActive, "Distribution isn't active");
461         uint claimed = distribution << 128 >> 128;
462         uint to = _count.add(claimed);
463         distribution = distribution >> 128 << 128 | to;
464         require(_count.add(claimed) <= ownerMap.size(), "To value is greater than the amount of owners");
465 
466         if (to == ownerMap.size()) {
467             distributionActive = false;
468             emit TokenDistributionComplete(dToken, distribution >> 128, ownerMap.size());
469         }
470         for (uint256 i = claimed; i < to; i++) {
471             _claimTokens(i);
472         }
473     }
474 
475     /**
476         @dev Whitelist a token so it can be distributed
477         @dev Token whitelist is due to the potential of minting tokens and constantly lock this contract in distribution
478      */
479     function whitelistToken(address _token, uint256 _minimum) public onlyOwner() {
480         require(!tokenWhitelist[_token], "Token is already whitelisted");
481         tokenWhitelist[_token] = true;
482         distributionMinimum[_token] = _minimum;
483     }
484 
485     /**
486         @dev Set the minimum amount to be of transfered in this contract to start distribution
487         @param _minimum The minimum amount
488      */
489     function setDistributionMinimum(address _token, uint256 _minimum) public onlyOwner() {
490         distributionMinimum[_token] = _minimum;
491     }
492 
493     /**
494         @dev ERC20 implementation of balances to allow for viewing in supported wallets
495         @param _owner The address of the owner
496      */
497     function balanceOf(address _owner) public view returns (uint) {
498         return ownerMap.get(uint(_owner)) << 128 >> 128;
499     }
500 
501     /**
502         @dev Get the amount of unclaimed owners in a distribution cycle
503      */
504     function getClaimedOwners() public view returns (uint) {
505         return distribution << 128 >> 128;
506     }
507 
508     /**
509         @dev Return an owners percentage
510         @param _owner The address of the owner
511      */
512     function getOwnerPercentage(address _owner) public view returns (uint) {
513         return ownerMap.get(uint(_owner)) >> 128;
514     }
515 
516     /**
517         @dev Return an owners share token amount
518         @param _owner The address of the owner
519      */
520     function getOwnerTokens(address _owner) public view returns (uint) {
521         return ownerMap.get(uint(_owner)) << 128 >> 128;
522     }
523 
524     /**
525         @dev Returns the current amount of active owners, ie share above 0
526      */
527     function getCurrentOwners() public view returns (uint) {
528         return ownerMap.size();
529     }
530 
531     /**
532         @dev Returns owner address based on the key
533         @param _i The index of the owner in the map
534      */
535     function getOwnerAddress(uint _i) public view returns (address) {
536         require(_i < ownerMap.size(), "Index is greater than the map size");
537         return address(ownerMap.getKey(_i));
538     }
539 
540     /**
541         @dev Returns the allowance amount for a sender address
542         @param _owner The address of the owner
543         @param _sender The address of the sender on an owners behalf
544      */
545     function getAllowance(address _owner, address _sender) public view returns (uint256) {
546         return allowance[_owner][_sender];
547     }
548 
549     /**
550         @dev Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
551      */
552     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
553         uint _numerator = numerator * 10 ** (precision+1);
554         uint _quotient = ((_numerator / denominator) + 5) / 10;
555         return ( _quotient);
556     }
557 
558     // Private Methods
559 
560     /**
561         @dev Claim the tokens for the next owner in the map
562      */
563     function _claimTokens(uint _i) private {
564         address owner = address(ownerMap.getKey(_i));
565         uint o = ownerMap.get(uint(owner));
566         uint256 tokenAmount = (distribution >> 128).mul(o >> 128).div(100000);
567         if (dToken == address(0) && !_isContract(owner)) {
568             owner.transfer(tokenAmount);
569         } else {
570             require(ERC20(dToken).transfer(owner, tokenAmount), "ERC20 transfer failed");
571         }
572     }  
573 
574     /**
575         @dev Transfers tokens to a different address
576         @dev Shared by all transfer implementations
577      */
578     function _sendOwnership(address _owner, address _receiver, uint256 _amount) private withinPrecision(_amount) {
579         uint o = ownerMap.get(uint(_owner));
580         uint r = ownerMap.get(uint(_receiver));
581 
582         uint oTokens = o << 128 >> 128;
583         uint rTokens = r << 128 >> 128;
584 
585         require(_is128Bit(_amount), "Amount isn't 128bit or smaller");
586         require(_owner != _receiver, "You can't send to yourself");
587         require(_receiver != address(0), "Ownership cannot be blackholed");
588         require(oTokens > 0, "You don't have any ownership");
589         require(oTokens.sub(stakeTotals[_owner]) >= _amount, "The amount to send exceeds the addresses balance");
590         require(!distributionActive, "Distribution cannot be active when sending ownership");
591         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision amount");
592 
593         oTokens = oTokens.sub(_amount);
594 
595         if (oTokens == 0) {
596             require(ownerMap.remove(uint(_owner)), "Address doesn't exist in the map");
597         } else {
598             uint oPercentage = percent(oTokens, valuation, 5);
599             require(ownerMap.insert(uint(_owner), oPercentage << 128 | oTokens), "Sender does not exist in the map");
600         }
601         
602         uint rTNew = rTokens.add(_amount);
603         uint rPercentage = percent(rTNew, valuation, 5);
604         if (rTokens == 0) {
605             require(!ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Map replacement detected");
606         } else {
607             require(ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Sender does not exist in the map");
608         }
609 
610         emit OwnershipTransferred(_owner, _receiver, _amount);
611     }
612 
613     /**
614         @dev Check whether an address given is a contract
615      */
616     function _isContract(address _addr) private view returns (bool hasCode) {
617         uint length;
618         assembly { length := extcodesize(_addr) }
619         return length > 0;
620     }
621 
622     /**
623         @dev Strict type check for data packing
624         @param _val The value for checking
625      */
626     function _is128Bit(uint _val) private pure returns (bool) {
627         return _val < 1 << 128;
628     }
629 }