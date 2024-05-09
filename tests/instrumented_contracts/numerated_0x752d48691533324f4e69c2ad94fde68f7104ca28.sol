1 pragma solidity ^0.4.8;
2 
3 
4 /**
5  * Math operations with safety checks
6  * By OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/contracts/SafeMath.sol
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ContractReceiver {
35     function tokenFallback(address _from, uint256 _value, bytes  _data) external;
36 }
37 
38 contract Ownable {
39     address public owner;
40     address public ownerCandidate;
41     event OwnerTransfer(address originalOwner, address currentOwner);
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function proposeNewOwner(address newOwner) public onlyOwner {
49         require(newOwner != address(0) && newOwner != owner);
50         ownerCandidate = newOwner;
51     }
52 
53     function acceptOwnerTransfer() public {
54         require(msg.sender == ownerCandidate);
55         OwnerTransfer(owner, ownerCandidate);
56         owner = ownerCandidate;
57     }
58 }
59 
60 contract ERC20Basic {
61   uint256 public totalSupply;
62   function balanceOf(address who) public constant returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) balances;
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public constant returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 contract StandardToken is ERC20, BasicToken {
107 
108   mapping (address => mapping (address => uint256)) internal allowed;
109 
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amount of tokens to be transferred
116    */
117   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
118     require(_to != address(0));
119     require(_value <= balances[_from]);
120     require(_value <= allowed[_from][msg.sender]);
121 
122     balances[_from] = balances[_from].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    *
132    * Beware that changing an allowance with this method brings the risk that someone may use both the old
133    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param _owner address The address which owns the funds.
148    * @param _spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
152     return allowed[_owner][_spender];
153   }
154 
155   /**
156    * approve should be called when allowed[_spender] == 0. To increment
157    * allowed value is better to use this function to avoid 2 calls (and wait until
158    * the first transaction is mined)
159    * From MonolithDAO Token.sol
160    */
161   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
162     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
168     uint oldValue = allowed[msg.sender][_spender];
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
173     }
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178 }
179 
180 
181 // Based in part on code by Open-Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
182 // Based in part on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183 // Smart contract for the RepuX token & the first crowdsale
184 contract RepuX is StandardToken, Ownable {
185     string public constant name = "RepuX";
186     string public constant symbol = "REPUX";
187     uint8 public constant decimals = 18;
188     address public multisig; //multisig wallet, to which all contributions will be sent
189 
190     uint256 public phase1StartBlock; //Crowdsale start block
191     uint256 public phase1EndBlock; // Day 7 (estimate)
192     uint256 public phase2EndBlock; // Day 13 (estimate)
193     uint256 public phase3EndBlock; // Day 19 (estimate)
194     uint256 public phase4EndBlock; // Day 25 (estimate)
195     uint256 public phase5EndBlock; // Day 31 (estimate)
196     uint256 public endBlock; //whole crowdsale end block
197 
198     uint256 public basePrice = 1818 * (10**11); // ICO token base price: ~$0.20 (estimate assuming $1100 per Eth)
199 
200     uint256 public totalSupply = 500000000 * (10**uint256(decimals)); //Token total supply: 500000000 RPX
201     uint256 public presaleTokenSupply = totalSupply.mul(20).div(100); //Amount of tokens available during presale (10%)
202     uint256 public crowdsaleTokenSupply = totalSupply.mul(30).div(100); //Amount of tokens available during crowdsale (50%)
203     uint256 public rewardsTokenSupply = totalSupply.mul(15).div(100); //Rewards pool (VIP etc, 10%), ambassador share(3%) & ICO bounties(2%)
204     uint256 public teamTokenSupply = totalSupply.mul(12).div(100); //Tokens distributed to team (12% in total, 4% vested for 12, 24 & 36 months)
205     uint256 public platformTokenSupply = totalSupply.mul(23).div(100); //Token reserve for sale on platform
206     uint256 public presaleTokenSold = 0; //Records the amount of tokens sold during presale
207     uint256 public crowdsaleTokenSold = 0; //Records the amount of tokens sold during the crowdsale
208 
209     uint256 public phase1Cap = crowdsaleTokenSupply.mul(50).div(100);
210     uint256 public phase2Cap = crowdsaleTokenSupply.mul(60).div(100);
211     uint256 public phase3Cap = crowdsaleTokenSupply.mul(70).div(100);
212     uint256 public phase4Cap = crowdsaleTokenSupply.mul(80).div(100);
213 
214     uint256 public transferLockup = 5760; //Lock up token transfer until ~2 days after crowdsale concludes
215     uint256 public teamLockUp; 
216     uint256 private teamWithdrawlCount = 0;
217     uint256 public averageBlockTime = 18; //Average block time in seconds
218 
219     bool public presaleStarted = false;
220     bool public presaleConcluded = false;
221     bool public crowdsaleStarted = false;
222     bool public crowdsaleConcluded = false;
223     bool public ICOReserveWithdrawn = false;
224     bool public halted = false; //Halt crowdsale in emergency
225 
226     uint256 contributionCount = 0;
227     bytes32[] public contributionHashes;
228     mapping (bytes32 => Contribution) private contributions;
229 
230     address public teamWithdrawalRecipient = address(0);
231     bool public teamWithdrawalProposed = false;
232     bool teamWithdrawn = false;
233 
234     event Halt(); //Halt event
235     event Unhalt(); //Unhalt event
236     event Burn(address burner, uint256 amount);
237     event StartPresale();
238     event ConcludePresale();
239     event StartCrowdsale();
240     event ConcludeCrowdsale();
241     event SetMultisig(address newMultisig);
242 
243     struct Contribution {
244         address contributor;
245         address recipient;
246         uint256 ethWei;
247         uint256 tokens;
248         bool resolved;
249         bool success;
250         uint8 stage;
251     }
252 
253     event ContributionReceived(bytes32 contributionHash, address contributor, address recipient,
254         uint256 ethWei, uint256 pendingTokens);
255 
256     event ContributionResolved(bytes32 contributionHash, bool pass, address contributor, 
257         address recipient, uint256 ethWei, uint256 tokens);
258 
259 
260     // lockup during and after 48h of end of crowdsale
261     modifier crowdsaleTransferLock() {
262         require(crowdsaleConcluded && block.number >= endBlock.add(transferLockup));
263         _;
264     }
265 
266     modifier whenNotHalted() {
267         require(!halted);
268         _;
269     }
270 
271     //Constructor: set owner (team) address & crowdsale recipient multisig wallet address
272     //Allocate reward tokens to the team wallet
273   	function RepuX(address _multisig) {
274         owner = msg.sender;
275         multisig = _multisig;
276   	}
277 
278     //Fallback function when receiving Ether. Contributors can directly send Ether to the token address during crowdsale.
279     function() payable {
280         buy();
281     }
282 
283 
284     //Halt ICO in case of emergency.
285     function halt() public onlyOwner {
286         halted = true;
287         Halt();
288     }
289 
290     function unhalt() public onlyOwner {
291         halted = false;
292         Unhalt();
293     }
294 
295     function startPresale() public onlyOwner {
296         require(!presaleStarted);
297         presaleStarted = true;
298         StartPresale();
299     }
300 
301     function concludePresale() public onlyOwner {
302         require(presaleStarted && !presaleConcluded);
303         presaleConcluded = true;
304         //Unsold tokens in the presale are made available in the crowdsale.
305         crowdsaleTokenSupply = crowdsaleTokenSupply.add(presaleTokenSupply.sub(presaleTokenSold)); 
306         ConcludePresale();
307     }
308 
309     //Can only be called after presale is concluded.
310     function startCrowdsale() public onlyOwner {
311         require(presaleConcluded && !crowdsaleStarted);
312         crowdsaleStarted = true;
313         phase1StartBlock = block.number;
314         phase1EndBlock = phase1StartBlock.add(dayToBlockNumber(7));
315         phase2EndBlock = phase1EndBlock.add(dayToBlockNumber(6));
316         phase3EndBlock = phase2EndBlock.add(dayToBlockNumber(6));
317         phase4EndBlock = phase3EndBlock.add(dayToBlockNumber(6));
318         phase5EndBlock = phase4EndBlock.add(dayToBlockNumber(6));
319         endBlock = phase5EndBlock;
320         StartCrowdsale();
321     }
322 
323     //Can only be called either after crowdsale time period ends, or after tokens have sold out
324     function concludeCrowdsale() public onlyOwner {
325         require(crowdsaleStarted && !crowdsaleOn() && !crowdsaleConcluded);
326         crowdsaleConcluded = true;
327         endBlock = block.number;
328         uint256 unsold = crowdsaleTokenSupply.sub(crowdsaleTokenSold);
329         if (unsold > 0) {
330             //Burn unsold tokens
331             totalSupply = totalSupply.sub(unsold);
332             Burn(this, unsold);
333             Transfer(this, address(0), unsold);
334         }
335         teamLockUp = dayToBlockNumber(365); //12-month lock-up period
336         ConcludeCrowdsale();
337     }
338 
339     function proposeTeamWithdrawal(address recipient) public onlyOwner {
340         require(!teamWithdrawn);
341         teamWithdrawalRecipient = recipient;
342         teamWithdrawalProposed = true;
343     }
344 
345     function cancelTeamWithdrawal() public onlyOwner {
346         require(!teamWithdrawn);
347         require(teamWithdrawalProposed);
348         teamWithdrawalProposed = false;
349         teamWithdrawalRecipient = address(0); 
350     }
351 
352     function confirmTeamWithdrawal() public {
353         require(!teamWithdrawn);
354         require(teamWithdrawalProposed);
355         require(msg.sender == teamWithdrawalRecipient);
356         teamWithdrawn = true;
357         uint256 tokens = rewardsTokenSupply.add(teamTokenSupply).add(platformTokenSupply);
358         balances[msg.sender] = balances[msg.sender].add(tokens);
359         Transfer(this, msg.sender, tokens);
360     }
361 
362 
363     function buy() payable {
364         buyRecipient(msg.sender);
365     }
366 
367 
368     //Allow addresses to buy token for another account
369     function buyRecipient(address recipient) public payable whenNotHalted {
370         require(msg.value > 0);
371         require(presaleOn()||crowdsaleOn()); //Contribution only allowed during presale/crowdsale
372         uint256 tokens = msg.value.mul(10**uint256(decimals)).div(tokenPrice()); 
373         uint8 stage = 0;
374 
375         if(presaleOn()) {
376             require(presaleTokenSold.add(tokens) <= presaleTokenSupply);
377             presaleTokenSold = presaleTokenSold.add(tokens);
378         } else {
379             require(crowdsaleTokenSold.add(tokens) <= crowdsaleTokenSupply);
380             crowdsaleTokenSold = crowdsaleTokenSold.add(tokens);
381             stage = 1;
382         }
383         contributionCount = contributionCount.add(1);
384         bytes32 transactionHash = keccak256(contributionCount, msg.sender, msg.value, msg.data,
385             msg.gas, block.number, tx.gasprice);
386         contributions[transactionHash] = Contribution(msg.sender, recipient, msg.value, 
387             tokens, false, false, stage);
388         contributionHashes.push(transactionHash);
389         ContributionReceived(transactionHash, msg.sender, recipient, msg.value, tokens);
390     }
391 
392     //Accept a contribution if KYC passed.
393     function acceptContribution(bytes32 transactionHash) public onlyOwner {
394         Contribution storage c = contributions[transactionHash];
395         require(!c.resolved);
396         c.resolved = true;
397         c.success = true;
398         balances[c.recipient] = balances[c.recipient].add(c.tokens);
399         assert(multisig.send(c.ethWei));
400         Transfer(this, c.recipient, c.tokens);
401         ContributionResolved(transactionHash, true, c.contributor, c.recipient, c.ethWei, 
402             c.tokens);
403     }
404 
405     //Reject a contribution if KYC failed.
406     function rejectContribution(bytes32 transactionHash) public onlyOwner {
407         Contribution storage c = contributions[transactionHash];
408         require(!c.resolved);
409         c.resolved = true;
410         c.success = false;
411         if (c.stage == 0) {
412             presaleTokenSold = presaleTokenSold.sub(c.tokens);
413         } else {
414             crowdsaleTokenSold = crowdsaleTokenSold.sub(c.tokens);
415         }
416         assert(c.contributor.send(c.ethWei));
417         ContributionResolved(transactionHash, false, c.contributor, c.recipient, c.ethWei, 
418             c.tokens);
419     }
420 
421     // Team manually mints tokens in case of BTC/wire-transfer contributions
422     function mint(address recipient, uint256 value) public onlyOwner {
423     	require(value > 0);
424     	require(presaleOn()||crowdsaleOn()); //Minting only allowed during presale/crowdsale
425     	if(presaleOn()) {
426             require(presaleTokenSold.add(value) <= presaleTokenSupply);
427             presaleTokenSold = presaleTokenSold.add(value);
428         } else {
429             require(crowdsaleTokenSold.add(value) <= crowdsaleTokenSupply);
430             crowdsaleTokenSold = crowdsaleTokenSold.add(value);
431         }
432         balances[recipient] = balances[recipient].add(value);
433         Transfer(this, recipient, value);
434     }
435 
436 
437     //Burns the specified amount of tokens from the team wallet address
438     function burn(uint256 _value) public onlyOwner returns (bool) {
439         balances[msg.sender] = balances[msg.sender].sub(_value);
440         totalSupply = totalSupply.sub(_value);
441         Transfer(msg.sender, address(0), _value);
442         Burn(msg.sender, _value);
443         return true;
444     }
445 
446     //Allow team to change the recipient multisig address
447     function setMultisig(address addr) public onlyOwner {
448       	require(addr != address(0));
449       	multisig = addr;
450         SetMultisig(addr);
451     }
452 
453     //Allows Team to adjust average blocktime according to network status, 
454     //in order to provide more precise timing for ICO phases & lock-up periods
455     function setAverageBlockTime(uint256 newBlockTime) public onlyOwner {
456         require(newBlockTime > 0);
457         averageBlockTime = newBlockTime;
458     }
459 
460     //Allows Team to adjust basePrice so price of the token has correct correlation to dollar
461     function setBasePrice(uint256 newBasePrice) public onlyOwner {
462         require(newBasePrice > 0);
463         basePrice = newBasePrice;
464     }
465 
466     function transfer(address _to, uint256 _value) public crowdsaleTransferLock 
467     returns(bool) {
468         return super.transfer(_to, _value);
469     }
470 
471     function transferFrom(address _from, address _to, uint256 _value) public 
472     crowdsaleTransferLock returns(bool) {
473         return super.transferFrom(_from, _to, _value);
474     }
475 
476     //Price of token in terms of ether.
477     function tokenPrice() public constant returns(uint256) {
478         uint8 p = phase();
479         if (p == 0) return basePrice.mul(50).div(100); //Presale: 50% discount
480         if (p == 1) return basePrice.mul(70).div(100); //ICO phase 1: 30% discount
481         if (p == 2) return basePrice.mul(75).div(100); //Phase 2 :25% discount
482         if (p == 3) return basePrice.mul(80).div(100); //Phase 3: 20% discount
483         if (p == 4) return basePrice.mul(85).div(100); //Phase 4: 15% discount
484         if (p == 5) return basePrice.mul(90).div(100); //Phase 5: 10% discount
485         return basePrice;
486     }
487 
488     function phase() public constant returns (uint8) {
489         if (presaleOn()) return 0;
490         if (crowdsaleTokenSold <= phase1Cap && block.number <= phase1EndBlock) return 1;
491         if (crowdsaleTokenSold <= phase2Cap && block.number <= phase2EndBlock) return 2;
492         if (crowdsaleTokenSold <= phase3Cap && block.number <= phase3EndBlock) return 3;
493         if (crowdsaleTokenSold <= phase4Cap && block.number <= phase4EndBlock) return 4;
494         if (crowdsaleTokenSold <= crowdsaleTokenSupply && block.number <= phase5EndBlock) return 5;
495         return 6;
496     }
497 
498     function presaleOn() public constant returns (bool) {
499         return (presaleStarted && !presaleConcluded && presaleTokenSold < presaleTokenSupply);
500     }
501 
502     function crowdsaleOn() public constant returns (bool) {
503         return (crowdsaleStarted && block.number <= endBlock && crowdsaleTokenSold < crowdsaleTokenSupply);
504     }
505 
506     function dayToBlockNumber(uint256 dayNum) public constant returns(uint256) {
507         return dayNum.mul(86400).div(averageBlockTime); //86400 = 24*60*60 = number of seconds in a day
508     }
509 
510     function getContributionFromHash(bytes32 contributionHash) public constant returns (
511             address contributor,
512             address recipient,
513             uint256 ethWei,
514             uint256 tokens,
515             bool resolved,
516             bool success
517         ) {
518         Contribution c = contributions[contributionHash];
519         contributor = c.contributor;
520         recipient = c.recipient;
521         ethWei = c.ethWei;
522         tokens = c.tokens;
523         resolved = c.resolved;
524         success = c.success;
525     }
526 
527     function getContributionHashes() public constant returns (bytes32[]) {
528         return contributionHashes;
529     }
530 
531 }