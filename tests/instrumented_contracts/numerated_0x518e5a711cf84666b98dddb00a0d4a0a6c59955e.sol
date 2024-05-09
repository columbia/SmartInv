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
134         if (e.keyIndex == 0)
135             return false;
136         
137         if (e.keyIndex < self.keys.length) {
138             // Move an existing element into the vacated key slot.
139             self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
140             self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
141             self.keys.length -= 1;
142             delete self.data[key];
143             return true;
144         }
145     }
146     
147     function contains(itmap storage self, uint key) internal view returns (bool exists) {
148         return self.data[key].keyIndex > 0;
149     }
150     
151     function size(itmap storage self) internal view returns (uint) {
152         return self.keys.length;
153     }
154     
155     function get(itmap storage self, uint key) internal view returns (uint) {
156         return self.data[key].value;
157     }
158     
159     function getKey(itmap storage self, uint idx) internal view returns (uint) {
160         return self.keys[idx];
161     }
162 }
163 
164 /**
165     @title PoolOwners, the crowdsale contract for LinkPool ownership
166  */
167 contract PoolOwners is Ownable {
168 
169     using SafeMath for uint256;
170     using itmap for itmap.itmap;
171 
172     struct Owner {
173         uint256 key;
174         uint256 percentage;
175         uint256 shareTokens;
176         mapping(address => uint256) balance;
177     }
178     mapping(address => Owner) public owners;
179 
180     struct Distribution {
181         address token;
182         uint256 amount;
183         uint256 owners;
184         uint256 claimed;
185         mapping(address => bool) claimedAddresses;
186     }
187     mapping(uint256 => Distribution) public distributions;
188 
189     mapping(address => uint256) public tokenBalance;
190     mapping(address => uint256) public totalReturned;
191 
192     mapping(address => bool) private whitelist;
193 
194     itmap.itmap ownerMap;
195     
196     uint256 public totalContributed     = 0;
197     uint256 public totalOwners          = 0;
198     uint256 public totalDistributions   = 0;
199     bool    public distributionActive   = false;
200     uint256 public distributionMinimum  = 20 ether;
201     uint256 public precisionMinimum     = 0.04 ether;
202     bool    public locked               = false;
203     address public wallet;
204 
205     bool    private contributionStarted = false;
206     uint256 private valuation           = 4000 ether;
207     uint256 private hardCap             = 1000 ether;
208 
209     event Contribution(address indexed sender, uint256 share, uint256 amount);
210     event ClaimedTokens(address indexed owner, address indexed token, uint256 amount, uint256 claimedStakers, uint256 distributionId);
211     event TokenDistributionActive(address indexed token, uint256 amount, uint256 distributionId, uint256 amountOfOwners);
212     event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);
213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);
214     event TokenDistributionComplete(address indexed token, uint256 amountOfOwners);
215 
216     modifier onlyWhitelisted() {
217         require(whitelist[msg.sender]);
218         _;
219     }
220 
221     /**
222         @dev Constructor set set the wallet initally
223         @param _wallet Address of the ETH wallet
224      */
225     constructor(address _wallet) public {
226         require(_wallet != address(0));
227         wallet = _wallet;
228     }
229 
230     /**
231         @dev Fallback function, redirects to contribution
232         @dev Transfers tokens to LP wallet address
233      */
234     function() public payable {
235         require(contributionStarted, "Contribution phase hasn't started");
236         require(whitelist[msg.sender], "You are not whitelisted");
237         contribute(msg.sender, msg.value); 
238         wallet.transfer(msg.value);
239     }
240 
241     /**
242         @dev Manually set a contribution, used by owners to increase owners amounts
243         @param _sender The address of the sender to set the contribution for you
244         @param _amount The amount that the owner has sent
245      */
246     function setContribution(address _sender, uint256 _amount) public onlyOwner() { contribute(_sender, _amount); }
247 
248     /**
249         @dev Registers a new contribution, sets their share
250         @param _sender The address of the wallet contributing
251         @param _amount The amount that the owner has sent
252      */
253     function contribute(address _sender, uint256 _amount) private {
254         require(!locked, "Crowdsale period over, contribution is locked");
255         require(!distributionActive, "Cannot contribute when distribution is active");
256         require(_amount >= precisionMinimum, "Amount needs to be above the minimum contribution");
257         require(hardCap >= _amount, "Your contribution is greater than the hard cap");
258         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision");
259         require(hardCap >= totalContributed.add(_amount), "Your contribution would cause the total to exceed the hardcap");
260 
261         totalContributed = totalContributed.add(_amount);
262         uint256 share = percent(_amount, valuation, 5);
263 
264         Owner storage o = owners[_sender];
265         if (o.percentage != 0) { // Existing owner
266             o.shareTokens = o.shareTokens.add(_amount);
267             o.percentage = o.percentage.add(share);
268         } else { // New owner
269             o.key = totalOwners;
270             require(ownerMap.insert(o.key, uint(_sender)) == false);
271             totalOwners += 1;
272             o.shareTokens = _amount;
273             o.percentage = share;
274         }
275 
276         if (!whitelist[msg.sender]) {
277             whitelist[msg.sender] = true;
278         }
279 
280         emit Contribution(_sender, share, _amount);
281     }
282 
283     /**
284         @dev Whitelist a wallet address
285         @param _owner Wallet of the owner
286      */
287     function whitelistWallet(address _owner) external onlyOwner() {
288         require(!locked, "Can't whitelist when the contract is locked");
289         require(_owner != address(0), "Empty address");
290         whitelist[_owner] = true;
291     }
292 
293     /**
294         @dev Start the distribution phase
295      */
296     function startContribution() external onlyOwner() {
297         require(!contributionStarted, "Contribution has started");
298         contributionStarted = true;
299     }
300 
301     /**
302         @dev Manually set a share directly, used to set the LinkPool members as owners
303         @param _owner Wallet address of the owner
304         @param _value The equivalent contribution value
305      */
306     function setOwnerShare(address _owner, uint256 _value) public onlyOwner() {
307         require(!locked, "Can't manually set shares, it's locked");
308         require(!distributionActive, "Cannot set owners share when distribution is active");
309 
310         Owner storage o = owners[_owner];
311         if (o.shareTokens == 0) {
312             whitelist[_owner] = true;
313             require(ownerMap.insert(totalOwners, uint(_owner)) == false);
314             o.key = totalOwners;
315             totalOwners += 1;
316         }
317         o.shareTokens = _value;
318         o.percentage = percent(_value, valuation, 5);
319     }
320 
321     /**
322         @dev Transfer part or all of your ownership to another address
323         @param _receiver The address that you're sending to
324         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
325      */
326     function sendOwnership(address _receiver, uint256 _amount) public onlyWhitelisted() {
327         Owner storage o = owners[msg.sender];
328         Owner storage r = owners[_receiver];
329 
330         require(o.shareTokens > 0, "You don't have any ownership");
331         require(o.shareTokens >= _amount, "The amount exceeds what you have");
332         require(!distributionActive, "Distribution cannot be active when sending ownership");
333         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision amount");
334 
335         o.shareTokens = o.shareTokens.sub(_amount);
336 
337         if (o.shareTokens == 0) {
338             o.percentage = 0;
339             require(ownerMap.remove(o.key) == true);
340         } else {
341             o.percentage = percent(o.shareTokens, valuation, 5);
342         }
343         if (r.shareTokens == 0) {
344             if (!whitelist[_receiver]) {
345                 r.key = totalOwners;
346                 whitelist[_receiver] = true;
347                 totalOwners += 1;
348             }
349             require(ownerMap.insert(r.key, uint(_receiver)) == false);
350         }
351         r.shareTokens = r.shareTokens.add(_amount);
352         r.percentage = r.percentage.add(percent(_amount, valuation, 5));
353 
354         emit OwnershipTransferred(msg.sender, _receiver, _amount);
355     }
356 
357     /**
358         @dev Lock the contribution/shares methods
359      */
360     function lockShares() public onlyOwner() {
361         require(!locked, "Shares already locked");
362         locked = true;
363     }
364 
365     /**
366         @dev Start the distribution phase in the contract so owners can claim their tokens
367         @param _token The token address to start the distribution of
368      */
369     function distributeTokens(address _token) public onlyWhitelisted() {
370         require(!distributionActive, "Distribution is already active");
371         distributionActive = true;
372 
373         ERC677 erc677 = ERC677(_token);
374 
375         uint256 currentBalance = erc677.balanceOf(this) - tokenBalance[_token];
376         require(currentBalance > distributionMinimum, "Amount in the contract isn't above the minimum distribution limit");
377 
378         totalDistributions++;
379         Distribution storage d = distributions[totalDistributions]; 
380         d.owners = ownerMap.size();
381         d.amount = currentBalance;
382         d.token = _token;
383         d.claimed = 0;
384         totalReturned[_token] += currentBalance;
385 
386         emit TokenDistributionActive(_token, currentBalance, totalDistributions, d.owners);
387     }
388 
389     /**
390         @dev Claim tokens by a owner address to add them to their balance
391         @param _owner The address of the owner to claim tokens for
392      */
393     function claimTokens(address _owner) public {
394         Owner storage o = owners[_owner];
395         Distribution storage d = distributions[totalDistributions]; 
396 
397         require(o.shareTokens > 0, "You need to have a share to claim tokens");
398         require(distributionActive, "Distribution isn't active");
399         require(!d.claimedAddresses[_owner], "Tokens already claimed for this address");
400 
401         address token = d.token;
402         uint256 tokenAmount = d.amount.mul(o.percentage).div(100000);
403         o.balance[token] = o.balance[token].add(tokenAmount);
404         tokenBalance[token] = tokenBalance[token].add(tokenAmount);
405 
406         d.claimed++;
407         d.claimedAddresses[_owner] = true;
408 
409         emit ClaimedTokens(_owner, token, tokenAmount, d.claimed, totalDistributions);
410 
411         if (d.claimed == d.owners) {
412             distributionActive = false;
413             emit TokenDistributionComplete(token, totalOwners);
414         }
415     }
416 
417     /**
418         @dev Withdraw tokens from your contract balance
419         @param _token The token address for token claiming
420         @param _amount The amount of tokens to withdraw
421      */
422     function withdrawTokens(address _token, uint256 _amount) public {
423         require(_amount > 0, "You have requested for 0 tokens to be withdrawn");
424 
425         Owner storage o = owners[msg.sender];
426         Distribution storage d = distributions[totalDistributions]; 
427 
428         if (distributionActive && !d.claimedAddresses[msg.sender]) {
429             claimTokens(msg.sender);
430         }
431         require(o.balance[_token] >= _amount, "Amount requested is higher than your balance");
432 
433         o.balance[_token] = o.balance[_token].sub(_amount);
434         tokenBalance[_token] = tokenBalance[_token].sub(_amount);
435 
436         ERC677 erc677 = ERC677(_token);
437         require(erc677.transfer(msg.sender, _amount) == true);
438 
439         emit TokenWithdrawal(_token, msg.sender, _amount);
440     }
441 
442     /**
443         @dev Set the minimum amount to be of transfered in this contract to start distribution
444         @param _minimum The minimum amount
445      */
446     function setDistributionMinimum(uint256 _minimum) public onlyOwner() {
447         distributionMinimum = _minimum;
448     }
449 
450     /**
451         @dev Set the wallet address to receive the crowdsale contributions
452         @param _wallet The wallet address
453      */
454     function setEthWallet(address _wallet) public onlyOwner() {
455         wallet = _wallet;
456     }
457 
458     /**
459         @dev Returns whether the address is whitelisted
460         @param _owner The address of the owner
461      */
462     function isWhitelisted(address _owner) public view returns (bool) {
463         return whitelist[_owner];
464     }
465 
466     /**
467         @dev Returns the contract balance of the sender for a given token
468         @param _token The address of the ERC token
469      */
470     function getOwnerBalance(address _token) public view returns (uint256) {
471         Owner storage o = owners[msg.sender];
472         return o.balance[_token];
473     }
474 
475     /**
476         @dev Returns a owner, all the values in the struct
477         @param _owner Address of the owner
478      */
479     function getOwner(address _owner) public view returns (uint256, uint256, uint256) {
480         Owner storage o = owners[_owner];
481         return (o.key, o.shareTokens, o.percentage);
482     }
483 
484     /**
485         @dev Returns the current amount of active owners, ie share above 0
486      */
487     function getCurrentOwners() public view returns (uint) {
488         return ownerMap.size();
489     }
490 
491     /**
492         @dev Returns owner address based on the key
493         @param _key The key of the address in the map
494      */
495     function getOwnerAddress(uint _key) public view returns (address) {
496         return address(ownerMap.get(_key));
497     }
498 
499     /**
500         @dev Returns whether a owner has claimed their tokens
501         @param _owner The address of the owner
502         @param _dId The distribution id
503      */
504     function hasClaimed(address _owner, uint256 _dId) public view returns (bool) {
505         Distribution storage d = distributions[_dId]; 
506         return d.claimedAddresses[_owner];
507     }
508 
509     /**
510         @dev Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
511      */
512     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
513         uint _numerator = numerator * 10 ** (precision+1);
514         uint _quotient = ((_numerator / denominator) + 5) / 10;
515         return ( _quotient);
516     }
517 }