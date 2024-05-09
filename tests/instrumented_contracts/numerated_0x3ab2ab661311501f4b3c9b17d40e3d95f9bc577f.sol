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
165 /**
166     @title PoolOwners, the crowdsale contract for LinkPool ownership
167  */
168 contract PoolOwners is Ownable {
169 
170     using SafeMath for uint256;
171     using itmap for itmap.itmap;
172 
173     itmap.itmap private ownerMap;
174 
175     mapping(address => mapping(address => uint256)) allowance;
176     mapping(address => bool) public tokenWhitelist;
177     mapping(address => bool) public whitelist;
178     mapping(address => uint256) public distributionMinimum;
179     
180     uint256 public totalContributed   = 0;
181     bool    public distributionActive = false;
182     uint256 public precisionMinimum   = 0.04 ether;
183     bool    public locked             = false;
184     address public wallet;
185 
186     bool    private contributionStarted = false;
187     uint256 private valuation           = 4000 ether;
188     uint256 private hardCap             = 1000 ether;
189     uint    private distribution        = 1;
190     address private dToken              = address(0);
191 
192     event Contribution(address indexed sender, uint256 share, uint256 amount);
193     event TokenDistributionActive(address indexed token, uint256 amount, uint256 amountOfOwners);
194     event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);
196     event TokenDistributionComplete(address indexed token, uint amount, uint256 amountOfOwners);
197 
198     modifier onlyPoolOwner() {
199         require(ownerMap.get(uint(msg.sender)) != 0, "You are not authorised to call this function");
200         _;
201     }
202 
203     /**
204         @dev Constructor set set the wallet initally
205         @param _wallet Address of the ETH wallet
206      */
207     constructor(address _wallet) public {
208         require(_wallet != address(0), "The ETH wallet address needs to be set");
209         wallet = _wallet;
210     }
211 
212     /**
213         @dev Fallback function, redirects to contribution
214         @dev Transfers tokens to LP wallet address
215      */
216     function() public payable {
217         require(contributionStarted, "Contribution is not active");
218         require(whitelist[msg.sender], "You are not whitelisted");
219         contribute(msg.sender, msg.value); 
220         wallet.transfer(msg.value);
221     }
222 
223     /**
224         @dev Manually set a contribution, used by owners to increase owners amounts
225         @param _sender The address of the sender to set the contribution for you
226         @param _amount The amount that the owner has sent
227      */
228     function addContribution(address _sender, uint256 _amount) public onlyOwner() { contribute(_sender, _amount); }
229 
230     /**
231         @dev Registers a new contribution, sets their share
232         @param _sender The address of the wallet contributing
233         @param _amount The amount that the owner has sent
234      */
235     function contribute(address _sender, uint256 _amount) private {
236         require(is128Bit(_amount), "Contribution amount isn't 128bit or smaller");
237         require(!locked, "Crowdsale period over, contribution is locked");
238         require(!distributionActive, "Cannot contribute when distribution is active");
239         require(_amount >= precisionMinimum, "Amount needs to be above the minimum contribution");
240         require(hardCap >= _amount, "Your contribution is greater than the hard cap");
241         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision");
242         require(hardCap >= totalContributed.add(_amount), "Your contribution would cause the total to exceed the hardcap");
243 
244         totalContributed = totalContributed.add(_amount);
245         uint256 share = percent(_amount, valuation, 5);
246 
247         uint owner = ownerMap.get(uint(_sender));
248         if (owner != 0) { // Existing owner
249             share += owner >> 128;
250             uint amount = (owner << 128 >> 128).add(_amount);
251             require(ownerMap.insert(uint(_sender), share << 128 | amount), "Sender does not exist in the map");
252         } else { // New owner
253             require(!ownerMap.insert(uint(_sender), share << 128 | _amount), "Map replacement detected");
254         }
255 
256         emit Contribution(_sender, share, _amount);
257     }
258 
259     /**
260         @dev Whitelist a wallet address
261         @param _owner Wallet of the owner
262      */
263     function whitelistWallet(address _owner) external onlyOwner() {
264         require(!locked, "Can't whitelist when the contract is locked");
265         require(_owner != address(0), "Blackhole address");
266         whitelist[_owner] = true;
267     }
268 
269     /**
270         @dev Start the distribution phase
271      */
272     function startContribution() external onlyOwner() {
273         require(!contributionStarted, "Contribution has started");
274         contributionStarted = true;
275     }
276 
277     /**
278         @dev Manually set a share directly, used to set the LinkPool members as owners
279         @param _owner Wallet address of the owner
280         @param _value The equivalent contribution value
281      */
282     function setOwnerShare(address _owner, uint256 _value) public onlyOwner() {
283         require(!locked, "Can't manually set shares, it's locked");
284         require(!distributionActive, "Cannot set owners share when distribution is active");
285         require(is128Bit(_value), "Contribution value isn't 128bit or smaller");
286 
287         uint owner = ownerMap.get(uint(_owner));
288         uint share;
289         if (owner == 0) {
290             share = percent(_value, valuation, 5);
291             require(!ownerMap.insert(uint(_owner), share << 128 | _value), "Map replacement detected");
292         } else {
293             share = (owner >> 128).add(percent(_value, valuation, 5));
294             uint value = (owner << 128 >> 128).add(_value);
295             require(ownerMap.insert(uint(_owner), share << 128 | value), "Sender does not exist in the map");
296         }
297     }
298 
299     /**
300         @dev Transfer part or all of your ownership to another address
301         @param _receiver The address that you're sending to
302         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
303      */
304     function sendOwnership(address _receiver, uint256 _amount) public onlyPoolOwner() {
305         _sendOwnership(msg.sender, _receiver, _amount);
306     }
307 
308     /**
309         @dev Transfer part or all of your ownership to another address and call the receiving contract
310         @param _receiver The address that you're sending to
311         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
312      */
313     function sendOwnershipAndCall(address _receiver, uint256 _amount, bytes _data) public onlyPoolOwner() {
314         _sendOwnership(msg.sender, _receiver, _amount);
315         if (isContract(_receiver)) {
316             contractFallback(_receiver, _amount, _data);
317         }
318     }
319 
320     /**
321         @dev Transfer part or all of your ownership to another address on behalf of an owner
322         @dev Same principle as approval in ERC20, to be used mostly by external contracts, eg DEX's
323         @param _owner The address of the owner who's having tokens sent on behalf of
324         @param _receiver The address that you're sending to
325         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
326      */
327     function sendOwnershipFrom(address _owner, address _receiver, uint256 _amount) public {
328         require(allowance[_owner][msg.sender] >= _amount, "Sender is not approved to send ownership of that amount");
329         allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);
330         if (allowance[_owner][msg.sender] == 0) {
331             delete allowance[_owner][msg.sender];
332         }
333         _sendOwnership(_owner, _receiver, _amount);
334     }
335 
336     function _sendOwnership(address _owner, address _receiver, uint256 _amount) private {
337         uint o = ownerMap.get(uint(_owner));
338         uint r = ownerMap.get(uint(_receiver));
339 
340         uint oTokens = o << 128 >> 128;
341         uint rTokens = r << 128 >> 128;
342 
343         require(is128Bit(_amount), "Amount isn't 128bit or smaller");
344         require(_owner != _receiver, "You can't send to yourself");
345         require(_receiver != address(0), "Ownership cannot be blackholed");
346         require(oTokens > 0, "You don't have any ownership");
347         require(oTokens >= _amount, "The amount exceeds what you have");
348         require(!distributionActive, "Distribution cannot be active when sending ownership");
349         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision amount");
350 
351         oTokens = oTokens.sub(_amount);
352 
353         if (oTokens == 0) {
354             require(ownerMap.remove(uint(_owner)), "Address doesn't exist in the map");
355         } else {
356             uint oPercentage = percent(oTokens, valuation, 5);
357             require(ownerMap.insert(uint(_owner), oPercentage << 128 | oTokens), "Sender does not exist in the map");
358         }
359         
360         uint rTNew = rTokens.add(_amount);
361         uint rPercentage = percent(rTNew, valuation, 5);
362         if (rTokens == 0) {
363             require(!ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Map replacement detected");
364         } else {
365             require(ownerMap.insert(uint(_receiver), rPercentage << 128 | rTNew), "Sender does not exist in the map");
366         }
367 
368         emit OwnershipTransferred(_owner, _receiver, _amount);
369     }
370 
371     function contractFallback(address _receiver, uint256 _amount, bytes _data) private {
372         OwnersReceiver receiver = OwnersReceiver(_receiver);
373         receiver.onOwnershipTransfer(msg.sender, _amount, _data);
374     }
375 
376     function isContract(address _addr) private view returns (bool hasCode) {
377         uint length;
378         assembly { length := extcodesize(_addr) }
379         return length > 0;
380     }
381 
382     /**
383         @dev Increase the allowance of a sender
384         @param _sender The address of the sender on behalf of the owner
385         @param _amount The amount to increase approval by
386      */
387     function increaseAllowance(address _sender, uint256 _amount) public {
388         uint o = ownerMap.get(uint(msg.sender));
389         require(o << 128 >> 128 >= _amount, "The amount to increase allowance by is higher than your balance");
390         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].add(_amount);
391     }
392 
393     /**
394         @dev Decrease the allowance of a sender
395         @param _sender The address of the sender on behalf of the owner
396         @param _amount The amount to decrease approval by
397      */
398     function decreaseAllowance(address _sender, uint256 _amount) public {
399         require(allowance[msg.sender][_sender] >= _amount, "The amount to decrease allowance by is higher than the current allowance");
400         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].sub(_amount);
401         if (allowance[msg.sender][_sender] == 0) {
402             delete allowance[msg.sender][_sender];
403         }
404     }
405 
406     /**
407         @dev Lock the contribution/shares methods
408      */
409     function lockShares() public onlyOwner() {
410         require(!locked, "Shares already locked");
411         locked = true;
412     }
413 
414     /**
415         @dev Start the distribution phase in the contract so owners can claim their tokens
416         @param _token The token address to start the distribution of
417      */
418     function distributeTokens(address _token) public onlyPoolOwner() {
419         require(tokenWhitelist[_token], "Token is not whitelisted to be distributed");
420         require(!distributionActive, "Distribution is already active");
421         distributionActive = true;
422 
423         uint256 currentBalance = ERC20(_token).balanceOf(this);
424         if (!is128Bit(currentBalance)) {
425             currentBalance = 1 << 128;
426         }
427         require(currentBalance > distributionMinimum[_token], "Amount in the contract isn't above the minimum distribution limit");
428 
429         distribution = currentBalance << 128;
430         dToken = _token;
431 
432         emit TokenDistributionActive(_token, currentBalance, ownerMap.size());
433     }
434 
435     /**
436         @dev Batch claiming of tokens for owners
437         @param _count The amount of owners to claim tokens for
438      */
439     function batchClaim(uint256 _count) public onlyPoolOwner() {
440         uint claimed = distribution << 128 >> 128;
441         uint to = _count.add(claimed);
442 
443         require(_count.add(claimed) <= ownerMap.size(), "To value is greater than the amount of owners");
444         for (uint256 i = claimed; i < to; i++) {
445             claimTokens(i);
446         }
447 
448         claimed = claimed.add(_count);
449         if (claimed == ownerMap.size()) {
450             distributionActive = false;
451             emit TokenDistributionComplete(dToken, distribution >> 128, ownerMap.size());
452         } else {
453             distribution = distribution >> 128 << 128 | claimed;
454         }
455     }
456 
457     /**
458         @dev Claim the tokens for the next owner in the map
459      */
460     function claimTokens(uint _i) private {
461         address owner = address(ownerMap.getKey(_i));
462         uint o = ownerMap.get(uint(owner));
463 
464         require(o >> 128 > 0, "You need to have a share to claim tokens");
465         require(distributionActive, "Distribution isn't active");
466 
467         uint256 tokenAmount = (distribution >> 128).mul(o >> 128).div(100000);
468         require(ERC20(dToken).transfer(owner, tokenAmount), "ERC20 transfer failed");
469     }
470 
471     /**
472         @dev Whitelist a token so it can be distributed
473         @dev Token whitelist is due to the potential of minting tokens and constantly lock this contract in distribution
474      */
475     function whitelistToken(address _token, uint256 _minimum) public onlyOwner() {
476         require(!tokenWhitelist[_token], "Token is already whitelisted");
477         tokenWhitelist[_token] = true;
478         distributionMinimum[_token] = _minimum;
479     }
480 
481     /**
482         @dev Set the minimum amount to be of transfered in this contract to start distribution
483         @param _minimum The minimum amount
484      */
485     function setDistributionMinimum(address _token, uint256 _minimum) public onlyOwner() {
486         distributionMinimum[_token] = _minimum;
487     }
488 
489     /**
490         @dev Get the amount of unclaimed owners in a distribution cycle
491      */
492     function getClaimedOwners() public view returns (uint) {
493         return distribution << 128 >> 128;
494     }
495 
496     /**
497         @dev Return an owners percentage
498         @param _owner The address of the owner
499      */
500     function getOwnerPercentage(address _owner) public view returns (uint) {
501         return ownerMap.get(uint(_owner)) >> 128;
502     }
503 
504     /**
505         @dev Return an owners share token amount
506         @param _owner The address of the owner
507      */
508     function getOwnerTokens(address _owner) public view returns (uint) {
509         return ownerMap.get(uint(_owner)) << 128 >> 128;
510     }
511 
512     /**
513         @dev Returns the current amount of active owners, ie share above 0
514      */
515     function getCurrentOwners() public view returns (uint) {
516         return ownerMap.size();
517     }
518 
519     /**
520         @dev Returns owner address based on the key
521         @param _i The index of the owner in the map
522      */
523     function getOwnerAddress(uint _i) public view returns (address) {
524         require(_i < ownerMap.size(), "Index is greater than the map size");
525         return address(ownerMap.getKey(_i));
526     }
527 
528     /**
529         @dev Returns the allowance amount for a sender address
530         @param _owner The address of the owner
531         @param _sender The address of the sender on an owners behalf
532      */
533     function getAllowance(address _owner, address _sender) public view returns (uint256) {
534         return allowance[_owner][_sender];
535     }
536 
537     /**
538         @dev Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
539      */
540     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
541         uint _numerator = numerator * 10 ** (precision+1);
542         uint _quotient = ((_numerator / denominator) + 5) / 10;
543         return ( _quotient);
544     }
545 
546     /**
547         @dev Strict type check for data packing
548         @param _val The value for checking
549      */
550     function is128Bit(uint _val) private pure returns (bool) {
551         return _val < 1 << 128;
552     }
553 }