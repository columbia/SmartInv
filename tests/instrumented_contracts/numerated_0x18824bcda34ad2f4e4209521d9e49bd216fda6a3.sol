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
189     mapping(address => bool)    public tokenWhitelist;
190     mapping(address => uint256) public tokenBalance;
191     mapping(address => uint256) public totalReturned;
192     mapping(address => bool)    public whitelist;
193     mapping(address => bool)    public allOwners;
194 
195     itmap.itmap ownerMap;
196     
197     uint256 public totalContributed     = 0;
198     uint256 public totalOwners          = 0;
199     uint256 public totalDistributions   = 0;
200     bool    public distributionActive   = false;
201     uint256 public distributionMinimum  = 20 ether;
202     uint256 public precisionMinimum     = 0.04 ether;
203     bool    public locked               = false;
204     address public wallet;
205 
206     bool    private contributionStarted = false;
207     uint256 private valuation           = 4000 ether;
208     uint256 private hardCap             = 1000 ether;
209 
210     event Contribution(address indexed sender, uint256 share, uint256 amount);
211     event ClaimedTokens(address indexed owner, address indexed token, uint256 amount, uint256 claimedStakers, uint256 distributionId);
212     event TokenDistributionActive(address indexed token, uint256 amount, uint256 distributionId, uint256 amountOfOwners);
213     event TokenWithdrawal(address indexed token, address indexed owner, uint256 amount);
214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 amount);
215     event TokenDistributionComplete(address indexed token, uint256 amountOfOwners);
216 
217     modifier onlyPoolOwner() {
218         require(allOwners[msg.sender]);
219         _;
220     }
221 
222     /**
223         @dev Constructor set set the wallet initally
224         @param _wallet Address of the ETH wallet
225      */
226     constructor(address _wallet) public {
227         require(_wallet != address(0));
228         wallet = _wallet;
229     }
230 
231     /**
232         @dev Fallback function, redirects to contribution
233         @dev Transfers tokens to LP wallet address
234      */
235     function() public payable {
236         require(contributionStarted, "Contribution phase hasn't started");
237         require(whitelist[msg.sender], "You are not whitelisted");
238         contribute(msg.sender, msg.value); 
239         wallet.transfer(msg.value);
240     }
241 
242     /**
243         @dev Manually set a contribution, used by owners to increase owners amounts
244         @param _sender The address of the sender to set the contribution for you
245         @param _amount The amount that the owner has sent
246      */
247     function setContribution(address _sender, uint256 _amount) public onlyOwner() { contribute(_sender, _amount); }
248 
249     /**
250         @dev Registers a new contribution, sets their share
251         @param _sender The address of the wallet contributing
252         @param _amount The amount that the owner has sent
253      */
254     function contribute(address _sender, uint256 _amount) private {
255         require(!locked, "Crowdsale period over, contribution is locked");
256         require(!distributionActive, "Cannot contribute when distribution is active");
257         require(_amount >= precisionMinimum, "Amount needs to be above the minimum contribution");
258         require(hardCap >= _amount, "Your contribution is greater than the hard cap");
259         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision");
260         require(hardCap >= totalContributed.add(_amount), "Your contribution would cause the total to exceed the hardcap");
261 
262         totalContributed = totalContributed.add(_amount);
263         uint256 share = percent(_amount, valuation, 5);
264 
265         Owner storage o = owners[_sender];
266         if (o.percentage != 0) { // Existing owner
267             o.shareTokens = o.shareTokens.add(_amount);
268             o.percentage = o.percentage.add(share);
269         } else { // New owner
270             o.key = totalOwners;
271             require(ownerMap.insert(o.key, uint(_sender)) == false);
272             totalOwners += 1;
273             o.shareTokens = _amount;
274             o.percentage = share;
275             allOwners[_sender] = true;
276         }
277 
278         emit Contribution(_sender, share, _amount);
279     }
280 
281     /**
282         @dev Whitelist a wallet address
283         @param _owner Wallet of the owner
284      */
285     function whitelistWallet(address _owner) external onlyOwner() {
286         require(!locked, "Can't whitelist when the contract is locked");
287         require(_owner != address(0), "Blackhole address");
288         whitelist[_owner] = true;
289     }
290 
291     /**
292         @dev Start the distribution phase
293      */
294     function startContribution() external onlyOwner() {
295         require(!contributionStarted, "Contribution has started");
296         contributionStarted = true;
297     }
298 
299     /**
300         @dev Manually set a share directly, used to set the LinkPool members as owners
301         @param _owner Wallet address of the owner
302         @param _value The equivalent contribution value
303      */
304     function setOwnerShare(address _owner, uint256 _value) public onlyOwner() {
305         require(!locked, "Can't manually set shares, it's locked");
306         require(!distributionActive, "Cannot set owners share when distribution is active");
307 
308         Owner storage o = owners[_owner];
309         if (o.shareTokens == 0) {
310             allOwners[_owner] = true;
311             require(ownerMap.insert(totalOwners, uint(_owner)) == false);
312             o.key = totalOwners;
313             totalOwners += 1;
314         }
315         o.shareTokens = _value;
316         o.percentage = percent(_value, valuation, 5);
317     }
318 
319     /**
320         @dev Transfer part or all of your ownership to another address
321         @param _receiver The address that you're sending to
322         @param _amount The amount of ownership to send, for your balance refer to `ownerShareTokens`
323      */
324     function sendOwnership(address _receiver, uint256 _amount) public onlyPoolOwner() {
325         Owner storage o = owners[msg.sender];
326         Owner storage r = owners[_receiver];
327 
328         require(o.shareTokens > 0, "You don't have any ownership");
329         require(o.shareTokens >= _amount, "The amount exceeds what you have");
330         require(!distributionActive, "Distribution cannot be active when sending ownership");
331         require(_amount % precisionMinimum == 0, "Your amount isn't divisible by the minimum precision amount");
332 
333         o.shareTokens = o.shareTokens.sub(_amount);
334 
335         if (o.shareTokens == 0) {
336             o.percentage = 0;
337             require(ownerMap.remove(o.key) == true);
338         } else {
339             o.percentage = percent(o.shareTokens, valuation, 5);
340         }
341         
342         if (r.shareTokens == 0) {
343             if (!allOwners[_receiver]) {
344                 r.key = totalOwners;
345                 allOwners[_receiver] = true;
346                 totalOwners += 1;
347             }
348             require(ownerMap.insert(r.key, uint(_receiver)) == false);
349         }
350         r.shareTokens = r.shareTokens.add(_amount);
351         r.percentage = r.percentage.add(percent(_amount, valuation, 5));
352 
353         emit OwnershipTransferred(msg.sender, _receiver, _amount);
354     }
355 
356     /**
357         @dev Lock the contribution/shares methods
358      */
359     function lockShares() public onlyOwner() {
360         require(!locked, "Shares already locked");
361         locked = true;
362     }
363 
364     /**
365         @dev Start the distribution phase in the contract so owners can claim their tokens
366         @param _token The token address to start the distribution of
367      */
368     function distributeTokens(address _token) public onlyPoolOwner() {
369         require(tokenWhitelist[_token], "Token is not whitelisted to be distributed");
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
393     function claimTokens(address _owner) public onlyPoolOwner() {
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
422     function withdrawTokens(address _token, uint256 _amount) public onlyPoolOwner() {
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
443         @dev Whitelist a token so it can be distributed
444         @dev Token whitelist is due to the potential of minting tokens and constantly lock this contract in distribution
445      */
446     function whitelistToken(address _token) public onlyOwner() {
447         require(!tokenWhitelist[_token], "Token is already whitelisted");
448         tokenWhitelist[_token] = true;
449     }
450 
451     /**
452         @dev Set the minimum amount to be of transfered in this contract to start distribution
453         @param _minimum The minimum amount
454      */
455     function setDistributionMinimum(uint256 _minimum) public onlyOwner() {
456         distributionMinimum = _minimum;
457     }
458 
459     /**
460         @dev Returns the contract balance of the sender for a given token
461         @param _token The address of the ERC token
462      */
463     function getOwnerBalance(address _token) public view returns (uint256) {
464         Owner storage o = owners[msg.sender];
465         return o.balance[_token];
466     }
467 
468     /**
469         @dev Returns the current amount of active owners, ie share above 0
470      */
471     function getCurrentOwners() public view returns (uint) {
472         return ownerMap.size();
473     }
474 
475     /**
476         @dev Returns owner address based on the key
477         @param _key The key of the address in the map
478      */
479     function getOwnerAddress(uint _key) public view returns (address) {
480         return address(ownerMap.get(_key));
481     }
482 
483     /**
484         @dev Returns whether a owner has claimed their tokens
485         @param _owner The address of the owner
486         @param _dId The distribution id
487      */
488     function hasClaimed(address _owner, uint256 _dId) public view returns (bool) {
489         Distribution storage d = distributions[_dId]; 
490         return d.claimedAddresses[_owner];
491     }
492 
493     /**
494         @dev Credit to Rob Hitchens: https://stackoverflow.com/a/42739843
495      */
496     function percent(uint numerator, uint denominator, uint precision) private pure returns (uint quotient) {
497         uint _numerator = numerator * 10 ** (precision+1);
498         uint _quotient = ((_numerator / denominator) + 5) / 10;
499         return ( _quotient);
500     }
501 }