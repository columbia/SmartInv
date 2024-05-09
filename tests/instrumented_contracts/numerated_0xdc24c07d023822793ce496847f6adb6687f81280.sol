1 pragma solidity ^0.4.3;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner, "Sender not authorised.");
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51     uint256 public totalSupply;
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62     function allowance(address owner, address spender) public view returns (uint256);
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64     function approve(address spender, uint256 value) public returns (bool);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract ERC677 is ERC20 {
69     function transferAndCall(address to, uint value, bytes data) public returns (bool success);
70 
71     event Transfer(address indexed from, address indexed to, uint value, bytes data);
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a * b;
81     assert(a == 0 || c / a == b);
82     return c;
83   }
84 
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 /**
105     @title ItMap, a solidity iterable map
106     @dev Credit to: https://gist.github.com/ethers/7e6d443818cbc9ad2c38efa7c0f363d1
107  */
108 library itmap {
109     struct entry {
110         // Equal to the index of the key of this item in keys, plus 1.
111         uint keyIndex;
112         uint value;
113     }
114 
115     struct itmap {
116         mapping(uint => entry) data;
117         uint[] keys;
118     }
119     
120     function insert(itmap storage self, uint key, uint value) internal returns (bool replaced) {
121         entry storage e = self.data[key];
122         e.value = value;
123         if (e.keyIndex > 0) {
124             return true;
125         } else {
126             e.keyIndex = ++self.keys.length;
127             self.keys[e.keyIndex - 1] = key;
128             return false;
129         }
130     }
131     
132     function remove(itmap storage self, uint key) internal returns (bool success) {
133         entry storage e = self.data[key];
134 
135         if (e.keyIndex == 0) {
136             return false;
137         }
138 
139         if (e.keyIndex < self.keys.length) {
140             // Move an existing element into the vacated key slot.
141             self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
142             self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
143         }
144 
145         self.keys.length -= 1;
146         delete self.data[key];
147         return true;
148     }
149     
150     function contains(itmap storage self, uint key) internal constant returns (bool exists) {
151         return self.data[key].keyIndex > 0;
152     }
153     
154     function size(itmap storage self) internal constant returns (uint) {
155         return self.keys.length;
156     }
157     
158     function get(itmap storage self, uint key) internal constant returns (uint) {
159         return self.data[key].value;
160     }
161     
162     function getKey(itmap storage self, uint idx) internal constant returns (uint) {
163         return self.keys[idx];
164     }
165 }
166 
167 /**
168     @title OwnersReceiver, same as `transferAndCall` in ERC677
169  */
170 contract OwnersReceiver {
171     function onOwnershipTransfer(address _sender, uint _value, bytes _data) public;
172 }
173 
174 /**
175     @title PoolOwners, the crowdsale contract for LinkPool ownership
176  */
177 contract PoolOwners is Ownable {
178 
179     using SafeMath for uint256;
180     using itmap for itmap.itmap;
181 
182     struct Owner {
183         uint256 key;
184         uint256 percentage;
185         uint256 shareTokens;
186         mapping(address => uint256) balance;
187     }
188     mapping(address => Owner) public owners;
189 
190     struct Distribution {
191         address token;
192         uint256 amount;
193         uint256 owners;
194         uint256 claimed;
195         mapping(address => bool) claimedAddresses;
196     }
197     mapping(uint256 => Distribution) public distributions;
198 
199     mapping(address => mapping(address => uint256)) allowance;
200     mapping(address => bool)    public tokenWhitelist;
201     mapping(address => uint256) public tokenBalance;
202     mapping(address => uint256) public totalReturned;
203     mapping(address => bool)    public whitelist;
204     mapping(address => bool)    public allOwners;
205 
206     itmap.itmap ownerMap;
207     
208     uint256 public totalContributed     = 0;
209     uint256 public totalOwners          = 0;
210     uint256 public totalDistributions   = 0;
211     bool    public distributionActive   = false;
212     uint256 public distributionMinimum  = 20 ether;
213     uint256 public precisionMinimum     = 0.04 ether;
214     bool    public locked               = false;
215     address public wallet;
216 
217     bool    private contributionStarted = false;
218     uint256 private valuation           = 4000 ether;
219     uint256 private hardCap             = 1000 ether;
220 
221     event Contribution(address indexed sender, uint256 share, uint256 amount);
222     event ClaimedTokens(address indexed owner, address indexed token, uint256 amount, uint256 claimedStakers, uint256 distributionId);
223     event TokenDistributionActive(address indexed token, uint256 amount, uint256 distributionId, uint256 amountOfOwners);
224     event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);
225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);
226     event TokenDistributionComplete(address indexed token, uint256 amountOfOwners);
227 
228     modifier onlyPoolOwner() {
229         require(allOwners[msg.sender], "You are not authorised to call this function");
230         _;
231     }
232 
233     /**
234         @dev Constructor set set the wallet initally
235         @param _wallet Address of the ETH wallet
236      */
237     constructor(address _wallet) public {
238         require(_wallet != address(0), "The ETH wallet address needs to be set");
239         wallet = _wallet;
240     }
241 
242     /**
243         @dev Fallback function, redirects to contribution
244         @dev Transfers tokens to LP wallet address
245      */
246     function() public payable {
247         require(contributionStarted, "Contribution is not active");
248         require(whitelist[msg.sender], "You are not whitelisted");
249         contribute(msg.sender, msg.value); 
250         wallet.transfer(msg.value);
251     }
252 
253     /**
254         @dev Manually set a contribution, used by owners to increase owners amounts
255         @param _sender The address of the sender to set the contribution for you
256         @param _amount The amount that the owner has sent
257      */
258     function addContribution(address _sender, uint256 _amount) public onlyOwner() { contribute(_sender, _amount); }
259 
260     /**
261         @dev Registers a new contribution, sets their share
262         @param _sender The address of the wallet contributing
263         @param _amount The amount that the owner has sent
264      */
265     function contribute(address _sender, uint256 _amount) private {
266         require(!locked, "Crowdsale period over, contribution is locked");
267         require(!distributionActive, "Cannot contribute when distribution is active");
268         require(_amount >= precisionMinimum, "Amount needs to be above the minimum contribution");
269         require(hardCap >= _amount, "Your contribution is greater than the hard cap");
270         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision");
271         require(hardCap >= totalContributed.add(_amount), "Your contribution would cause the total to exceed the hardcap");
272 
273         totalContributed = totalContributed.add(_amount);
274         uint256 share = percent(_amount, valuation, 5);
275 
276         Owner storage o = owners[_sender];
277         if (o.percentage != 0) { // Existing owner
278             o.shareTokens = o.shareTokens.add(_amount);
279             o.percentage = o.percentage.add(share);
280         } else { // New owner
281             o.key = totalOwners;
282             require(ownerMap.insert(o.key, uint(_sender)) == false, "Map replacement detected, fatal error");
283             totalOwners += 1;
284             o.shareTokens = _amount;
285             o.percentage = share;
286             allOwners[_sender] = true;
287         }
288 
289         emit Contribution(_sender, share, _amount);
290     }
291 
292     /**
293         @dev Whitelist a wallet address
294         @param _owner Wallet of the owner
295      */
296     function whitelistWallet(address _owner) external onlyOwner() {
297         require(!locked, "Can't whitelist when the contract is locked");
298         require(_owner != address(0), "Blackhole address");
299         whitelist[_owner] = true;
300     }
301 
302     /**
303         @dev Start the distribution phase
304      */
305     function startContribution() external onlyOwner() {
306         require(!contributionStarted, "Contribution has started");
307         contributionStarted = true;
308     }
309 
310     /**
311         @dev Manually set a share directly, used to set the LinkPool members as owners
312         @param _owner Wallet address of the owner
313         @param _value The equivalent contribution value
314      */
315     function setOwnerShare(address _owner, uint256 _value) public onlyOwner() {
316         require(!locked, "Can't manually set shares, it's locked");
317         require(!distributionActive, "Cannot set owners share when distribution is active");
318 
319         Owner storage o = owners[_owner];
320         if (o.shareTokens == 0) {
321             allOwners[_owner] = true;
322             require(ownerMap.insert(totalOwners, uint(_owner)) == false, "Map replacement detected, fatal error");
323             o.key = totalOwners;
324             totalOwners += 1;
325         }
326         o.shareTokens = _value;
327         o.percentage = percent(_value, valuation, 5);
328     }
329 
330     /**
331         @dev Transfer part or all of your ownership to another address
332         @param _receiver The address that you're sending to
333         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
334      */
335     function sendOwnership(address _receiver, uint256 _amount) public onlyPoolOwner() {
336         _sendOwnership(msg.sender, _receiver, _amount);
337     }
338 
339     /**
340         @dev Transfer part or all of your ownership to another address and call the receiving contract
341         @param _receiver The address that you're sending to
342         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
343      */
344     function sendOwnershipAndCall(address _receiver, uint256 _amount, bytes _data) public onlyPoolOwner() {
345         _sendOwnership(msg.sender, _receiver, _amount);
346         if (isContract(_receiver)) {
347             contractFallback(_receiver, _amount, _data);
348         }
349     }
350 
351     /**
352         @dev Transfer part or all of your ownership to another address on behalf of an owner
353         @dev Same principle as approval in ERC20, to be used mostly by external contracts, eg DEX's
354         @param _owner The address of the owner who's having tokens sent on behalf of
355         @param _receiver The address that you're sending to
356         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
357      */
358     function sendOwnershipFrom(address _owner, address _receiver, uint256 _amount) public {
359         require(allowance[_owner][msg.sender] >= _amount, "Sender is not approved to send ownership of that amount");
360         allowance[_owner][msg.sender] = allowance[_owner][msg.sender].sub(_amount);
361         _sendOwnership(_owner, _receiver, _amount);
362     }
363 
364     function _sendOwnership(address _owner, address _receiver, uint256 _amount) private {
365         Owner storage o = owners[_owner];
366         Owner storage r = owners[_receiver];
367 
368         require(_owner != _receiver, "You can't send to yourself");
369         require(_receiver != address(0), "Ownership cannot be blackholed");
370         require(o.shareTokens > 0, "You don't have any ownership");
371         require(o.shareTokens >= _amount, "The amount exceeds what you have");
372         require(!distributionActive, "Distribution cannot be active when sending ownership");
373         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision amount");
374 
375         o.shareTokens = o.shareTokens.sub(_amount);
376 
377         if (o.shareTokens == 0) {
378             o.percentage = 0;
379             require(ownerMap.remove(o.key) == true, "Address doesn't exist in the map, fatal error");
380         } else {
381             o.percentage = percent(o.shareTokens, valuation, 5);
382         }
383         
384         if (r.shareTokens == 0) {
385             if (!allOwners[_receiver]) {
386                 r.key = totalOwners;
387                 allOwners[_receiver] = true;
388                 totalOwners += 1;
389             }
390             require(ownerMap.insert(r.key, uint(_receiver)) == false, "Map replacement detected, fatal error");
391         }
392         r.shareTokens = r.shareTokens.add(_amount);
393         r.percentage = r.percentage.add(percent(_amount, valuation, 5));
394 
395         emit OwnershipTransferred(_owner, _receiver, _amount);
396     }
397 
398     function contractFallback(address _receiver, uint256 _amount, bytes _data) private {
399         OwnersReceiver receiver = OwnersReceiver(_receiver);
400         receiver.onOwnershipTransfer(msg.sender, _amount, _data);
401     }
402 
403     function isContract(address _addr) private view returns (bool hasCode) {
404         uint length;
405         assembly { length := extcodesize(_addr) }
406         return length > 0;
407     }
408 
409     /**
410         @dev Increase the allowance of a sender
411         @param _sender The address of the sender on behalf of the owner
412         @param _amount The amount to increase approval by
413      */
414     function increaseAllowance(address _sender, uint256 _amount) public {
415         require(owners[msg.sender].shareTokens >= _amount, "The amount to increase allowance by is higher than your balance");
416         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].add(_amount);
417     }
418 
419     /**
420         @dev Decrease the allowance of a sender
421         @param _sender The address of the sender on behalf of the owner
422         @param _amount The amount to decrease approval by
423      */
424     function decreaseAllowance(address _sender, uint256 _amount) public {
425         require(allowance[msg.sender][_sender] >= _amount, "The amount to decrease allowance by is higher than the current allowance");
426         allowance[msg.sender][_sender] = allowance[msg.sender][_sender].sub(_amount);
427     }
428 
429     /**
430         @dev Lock the contribution/shares methods
431      */
432     function lockShares() public onlyOwner() {
433         require(!locked, "Shares already locked");
434         locked = true;
435     }
436 
437     /**
438         @dev Start the distribution phase in the contract so owners can claim their tokens
439         @param _token The token address to start the distribution of
440      */
441     function distributeTokens(address _token) public onlyPoolOwner() {
442         require(tokenWhitelist[_token], "Token is not whitelisted to be distributed");
443         require(!distributionActive, "Distribution is already active");
444         distributionActive = true;
445 
446         ERC677 erc677 = ERC677(_token);
447 
448         uint256 currentBalance = erc677.balanceOf(this) - tokenBalance[_token];
449         require(currentBalance > distributionMinimum, "Amount in the contract isn't above the minimum distribution limit");
450 
451         totalDistributions++;
452         Distribution storage d = distributions[totalDistributions]; 
453         d.owners = ownerMap.size();
454         d.amount = currentBalance;
455         d.token = _token;
456         d.claimed = 0;
457         totalReturned[_token] += currentBalance;
458 
459         emit TokenDistributionActive(_token, currentBalance, totalDistributions, d.owners);
460     }
461 
462     /**
463         @dev Claim tokens by a owner address to add them to their balance
464         @param _owner The address of the owner to claim tokens for
465      */
466     function claimTokens(address _owner) public onlyPoolOwner() {
467         Owner storage o = owners[_owner];
468         Distribution storage d = distributions[totalDistributions]; 
469 
470         require(o.shareTokens > 0, "You need to have a share to claim tokens");
471         require(distributionActive, "Distribution isn't active");
472         require(!d.claimedAddresses[_owner], "Tokens already claimed for this address");
473 
474         address token = d.token;
475         uint256 tokenAmount = d.amount.mul(o.percentage).div(100000);
476         o.balance[token] = o.balance[token].add(tokenAmount);
477         tokenBalance[token] = tokenBalance[token].add(tokenAmount);
478 
479         d.claimed++;
480         d.claimedAddresses[_owner] = true;
481 
482         emit ClaimedTokens(_owner, token, tokenAmount, d.claimed, totalDistributions);
483 
484         if (d.claimed == d.owners) {
485             distributionActive = false;
486             emit TokenDistributionComplete(token, totalOwners);
487         }
488     }
489 
490     /**
491         @dev Batch claiming of tokens for owners
492         @dev Index range is based on the owners map size, any in-active owners will be skipped
493         @param _from The start of the index to claim for
494         @param _to The last entry in the index to claim for
495      */
496     function batchClaim(uint256 _from, uint256 _to) public onlyPoolOwner() {
497         Distribution storage d = distributions[totalDistributions]; 
498         for (uint256 i = _from; i < _to; i++) {
499             address owner = address(ownerMap.get(i));
500             if (owner != 0 && !d.claimedAddresses[owner]) {
501                 claimTokens(owner);
502             }
503         }
504     } 
505 
506     /**
507         @dev Withdraw tokens from your contract balance
508         @param _token The token address for token claiming
509         @param _amount The amount of tokens to withdraw
510      */
511     function withdrawTokens(address _token, uint256 _amount) public onlyPoolOwner() {
512         require(_amount > 0, "You have requested for 0 tokens to be withdrawn");
513 
514         Owner storage o = owners[msg.sender];
515         Distribution storage d = distributions[totalDistributions]; 
516 
517         if (distributionActive && !d.claimedAddresses[msg.sender]) {
518             claimTokens(msg.sender);
519         }
520         require(o.balance[_token] >= _amount, "Amount requested is higher than your balance");
521 
522         o.balance[_token] = o.balance[_token].sub(_amount);
523         tokenBalance[_token] = tokenBalance[_token].sub(_amount);
524 
525         ERC677 erc677 = ERC677(_token);
526         require(erc677.transfer(msg.sender, _amount) == true, "ERC20 transfer wasn't successful");
527 
528         emit TokenWithdrawal(_token, msg.sender, _amount);
529     }
530 
531     /**
532         @dev Whitelist a token so it can be distributed
533         @dev Token whitelist is due to the potential of minting tokens and constantly lock this contract in distribution
534      */
535     function whitelistToken(address _token) public onlyOwner() {
536         require(!tokenWhitelist[_token], "Token is already whitelisted");
537         tokenWhitelist[_token] = true;
538     }
539 
540     /**
541         @dev Set the minimum amount to be of transfered in this contract to start distribution
542         @param _minimum The minimum amount
543      */
544     function setDistributionMinimum(uint256 _minimum) public onlyOwner() {
545         distributionMinimum = _minimum;
546     }
547 
548     /**
549         @dev Returns the contract balance of the sender for a given token
550         @param _token The address of the ERC token
551      */
552     function getOwnerBalance(address _token) public view returns (uint256) {
553         Owner storage o = owners[msg.sender];
554         return o.balance[_token];
555     }
556 
557     /**
558         @dev Returns the current amount of active owners, ie share above 0
559      */
560     function getCurrentOwners() public view returns (uint) {
561         return ownerMap.size();
562     }
563 
564     /**
565         @dev Returns owner address based on the key
566         @param _key The key of the address in the map
567      */
568     function getOwnerAddress(uint _key) public view returns (address) {
569         return address(ownerMap.get(_key));
570     }
571 
572     /**
573         @dev Returns the allowance amount for a sender address
574         @param _owner The address of the owner
575         @param _sender The address of the sender on an owners behalf
576      */
577     function getAllowance(address _owner, address _sender) public view returns (uint256) {
578         return allowance[_owner][_sender];
579     }
580 
581     /**
582         @dev Returns whether a owner has claimed their tokens
583         @param _owner The address of the owner
584         @param _dId The distribution id
585      */
586     function hasClaimed(address _owner, uint256 _dId) public view returns (bool) {
587         Distribution storage d = distributions[_dId]; 
588         return d.claimedAddresses[_owner];
589     }
590 
591     /**
592         @dev Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
593      */
594     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
595         uint _numerator = numerator * 10 ** (precision+1);
596         uint _quotient = ((_numerator / denominator) + 5) / 10;
597         return ( _quotient);
598     }
599 }