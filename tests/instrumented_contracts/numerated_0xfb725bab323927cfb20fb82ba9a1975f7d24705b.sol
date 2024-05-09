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
183 // Smart contract for the JoyToken token & the first crowdsale
184 contract JoyToken is StandardToken, Ownable {
185     string public constant name = "JoyToken";
186     string public constant symbol = "JOY";
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
200     uint256 public totalSupply = 700000000 * (10**uint256(decimals)); //Token total supply: 500000000 RPX
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
216     uint256 private teamWithdrawalCount = 0;
217     uint256 public averageBlockTime = 18; //Average block time in seconds
218 
219     bool public presaleStarted = false;
220     bool public presaleConcluded = false;
221     bool public crowdsaleStarted = false;
222     bool public crowdsaleConcluded = false;
223     bool public halted = false; //Halt crowdsale in emergency
224 
225     uint256 contributionCount = 0;
226     bytes32[] public contributionHashes;
227     mapping (bytes32 => Contribution) private contributions;
228 
229     address public platformWithdrawalRecipient = address(0);
230     bool public platformWithdrawalProposed = false;
231     bool platformWithdrawn = false;
232     
233     address public rewardsWithdrawalRecipient = address(0);
234     bool public rewardsWithdrawalProposed = false;
235     bool rewardsWithdrawn = false;
236 
237     event Halt(); //Halt event
238     event Unhalt(); //Unhalt event
239     event Burn(address burner, uint256 amount);
240     event StartPresale();
241     event ConcludePresale();
242     event StartCrowdsale();
243     event ConcludeCrowdsale();
244     event SetMultisig(address newMultisig);
245 
246     struct Contribution {
247         address contributor;
248         address recipient;
249         uint256 ethWei;
250         uint256 tokens;
251         bool resolved;
252         bool success;
253         uint8 stage;
254     }
255 
256     event ContributionReceived(bytes32 contributionHash, address contributor, address recipient,
257         uint256 ethWei, uint256 pendingTokens);
258 
259     event ContributionResolved(bytes32 contributionHash, bool pass, address contributor, 
260         address recipient, uint256 ethWei, uint256 tokens);
261 
262 
263     // lockup during and after 48h of end of crowdsale
264     modifier crowdsaleTransferLock() {
265         require(crowdsaleStarted && block.number >= endBlock.add(transferLockup));
266         _;
267     }
268 
269     modifier whenNotHalted() {
270         require(!halted);
271         _;
272     }
273 
274     //Constructor: set owner (team) address & crowdsale recipient multisig wallet address
275     //Allocate reward tokens to the team wallet
276   	function JoyToken(address _multisig) public {
277         owner = msg.sender;
278         multisig = _multisig;
279         teamLockUp = dayToBlockNumber(31); // 31 days between withdrawing 1/36 of team tokens - vesting period in total is 3 years
280   	}
281 
282     //Fallback function when receiving Ether. Contributors can directly send Ether to the token address during crowdsale.
283     function() public payable {
284         buy();
285     }
286 
287 
288     //Halt ICO in case of emergency.
289     function halt() public onlyOwner {
290         halted = true;
291         Halt();
292     }
293 
294     function unhalt() public onlyOwner {
295         halted = false;
296         Unhalt();
297     }
298 
299     function startPresale() public onlyOwner {
300         require(!presaleStarted);
301         presaleStarted = true;
302         StartPresale();
303     }
304 
305     function concludePresale() public onlyOwner {
306         require(presaleStarted && !presaleConcluded);
307         presaleConcluded = true;
308         //Unsold tokens in the presale are made available in the crowdsale.
309         crowdsaleTokenSupply = crowdsaleTokenSupply.add(presaleTokenSupply.sub(presaleTokenSold)); 
310         ConcludePresale();
311     }
312 
313     // Can only be called after presale is concluded.
314     function startCrowdsale() public onlyOwner {
315         require(presaleConcluded && !crowdsaleStarted);
316         crowdsaleStarted = true;
317         phase1StartBlock = block.number;
318         phase1EndBlock = phase1StartBlock.add(dayToBlockNumber(7));
319         phase2EndBlock = phase1EndBlock.add(dayToBlockNumber(6));
320         phase3EndBlock = phase2EndBlock.add(dayToBlockNumber(6));
321         phase4EndBlock = phase3EndBlock.add(dayToBlockNumber(6));
322         phase5EndBlock = phase4EndBlock.add(dayToBlockNumber(6));
323         endBlock = phase5EndBlock;
324         StartCrowdsale();
325     }
326 
327     // Can only be called either after crowdsale time period ends, or after tokens have sold out
328     function concludeCrowdsale() public onlyOwner {
329         require(crowdsaleStarted && !crowdsaleOn() && !crowdsaleConcluded);
330         
331         crowdsaleConcluded = true;
332         endBlock = block.number;
333         uint256 unsold = crowdsaleTokenSupply.sub(crowdsaleTokenSold);
334         
335         if (unsold > 0) {
336             //Burn unsold tokens
337             totalSupply = totalSupply.sub(unsold);
338             Burn(this, unsold);
339             Transfer(this, address(0), unsold);
340         }
341         
342         ConcludeCrowdsale();
343     }
344 
345     // Make it possible for team to withdraw team tokens over 3 years
346     function withdrawTeamToken(address recipient) public onlyOwner {
347         require(crowdsaleStarted);
348         require(teamWithdrawalCount < 36);
349         require(block.number >= endBlock.add(teamLockUp.mul(teamWithdrawalCount.add(1)))); // 36-month lock-up in total, team can withdraw 1/36 of tokens each month
350         
351         teamWithdrawalCount++;
352         uint256 tokens = teamTokenSupply.div(36); // distribute 1/36 of team tokens each month
353         balances[recipient] = balances[recipient].add(tokens);
354         Transfer(this, recipient, tokens);
355     }
356     
357     // Withdrawing Platform Tokens supply
358     function proposePlatformWithdrawal(address recipient) public onlyOwner {
359         require(!platformWithdrawn);
360 
361         platformWithdrawalRecipient = recipient;
362         platformWithdrawalProposed = true;
363     }
364 
365     function cancelPlatformWithdrawal() public onlyOwner {
366         require(!platformWithdrawn);
367         require(platformWithdrawalProposed);
368 
369         platformWithdrawalProposed = false;
370         platformWithdrawalRecipient = address(0); 
371     }
372 
373     function confirmPlatformWithdrawal() public {
374         require(!platformWithdrawn);
375         require(platformWithdrawalProposed);
376         require(msg.sender == platformWithdrawalRecipient);
377 
378         platformWithdrawn = true;
379         balances[msg.sender] = balances[msg.sender].add(platformTokenSupply);
380 
381         Transfer(this, msg.sender, platformTokenSupply);
382     }
383     
384     // Withdrawing Rewards Pool Tokens
385     function proposeRewardsWithdrawal(address recipient) public onlyOwner {
386         require(!rewardsWithdrawn);
387 
388         rewardsWithdrawalRecipient = recipient;
389         rewardsWithdrawalProposed = true;
390     }
391 
392     function cancelRewardsWithdrawal() public onlyOwner {
393         require(!rewardsWithdrawn);
394         require(rewardsWithdrawalProposed);
395 
396         rewardsWithdrawalProposed = false;
397         rewardsWithdrawalRecipient = address(0); 
398     }
399 
400     function confirmRewardsWithdrawal() public {
401         require(!rewardsWithdrawn);
402         require(rewardsWithdrawalProposed);
403         require(msg.sender == rewardsWithdrawalRecipient);
404 
405         rewardsWithdrawn = true;
406         balances[msg.sender] = balances[msg.sender].add(rewardsTokenSupply);
407 
408         Transfer(this, msg.sender, rewardsTokenSupply);
409     }
410 
411     function buy() public payable {
412         buyRecipient(msg.sender);
413     }
414 
415     // Allow addresses to buy token for another account
416     function buyRecipient(address recipient) public payable whenNotHalted {
417         require(msg.value > 0);
418         require(presaleOn()||crowdsaleOn()); //Contribution only allowed during presale/crowdsale
419         uint256 tokens = msg.value.mul(10**uint256(decimals)).div(tokenPrice()); 
420         uint8 stage = 0;
421 
422         if(presaleOn()) {
423             require(presaleTokenSold.add(tokens) <= presaleTokenSupply);
424             presaleTokenSold = presaleTokenSold.add(tokens);
425         } else {
426             require(crowdsaleTokenSold.add(tokens) <= crowdsaleTokenSupply);
427             crowdsaleTokenSold = crowdsaleTokenSold.add(tokens);
428             stage = 1;
429         }
430         contributionCount = contributionCount.add(1);
431         bytes32 transactionHash = keccak256(contributionCount, msg.sender, msg.value, msg.data,
432             msg.gas, block.number, tx.gasprice);
433         contributions[transactionHash] = Contribution(msg.sender, recipient, msg.value, 
434             tokens, false, false, stage);
435         contributionHashes.push(transactionHash);
436         ContributionReceived(transactionHash, msg.sender, recipient, msg.value, tokens);
437     }
438 
439     //Accept a contribution if KYC passed.
440     function acceptContribution(bytes32 transactionHash) public onlyOwner {
441         Contribution storage c = contributions[transactionHash];
442         require(!c.resolved);
443         c.resolved = true;
444         c.success = true;
445         balances[c.recipient] = balances[c.recipient].add(c.tokens);
446         assert(multisig.send(c.ethWei));
447         Transfer(this, c.recipient, c.tokens);
448         ContributionResolved(transactionHash, true, c.contributor, c.recipient, c.ethWei, 
449             c.tokens);
450     }
451 
452     //Reject a contribution if KYC failed.
453     function rejectContribution(bytes32 transactionHash) public onlyOwner {
454         Contribution storage c = contributions[transactionHash];
455         require(!c.resolved);
456         c.resolved = true;
457         c.success = false;
458         if (c.stage == 0) {
459             presaleTokenSold = presaleTokenSold.sub(c.tokens);
460         } else {
461             crowdsaleTokenSold = crowdsaleTokenSold.sub(c.tokens);
462         }
463         assert(c.contributor.send(c.ethWei));
464         ContributionResolved(transactionHash, false, c.contributor, c.recipient, c.ethWei, 
465             c.tokens);
466     }
467 
468     // Team manually mints tokens in case of BTC/wire-transfer contributions
469     function mint(address recipient, uint256 value) public onlyOwner {
470     	require(value > 0);
471     	require(presaleStarted && !crowdsaleConcluded); // Minting allowed after presale started, up to crowdsale concluded (time for team to distribute tokens)
472 
473     	if (presaleOn()) {
474             require(presaleTokenSold.add(value) <= presaleTokenSupply);
475             presaleTokenSold = presaleTokenSold.add(value);
476         } else {
477             require(crowdsaleTokenSold.add(value) <= crowdsaleTokenSupply);
478             crowdsaleTokenSold = crowdsaleTokenSold.add(value);
479         }
480 
481         balances[recipient] = balances[recipient].add(value);
482         Transfer(this, recipient, value);
483     }
484 
485     //Burns the specified amount of tokens from the team wallet address
486     function burn(uint256 _value) public onlyOwner returns (bool) {
487         balances[msg.sender] = balances[msg.sender].sub(_value);
488         totalSupply = totalSupply.sub(_value);
489         Transfer(msg.sender, address(0), _value);
490         Burn(msg.sender, _value);
491         return true;
492     }
493 
494     //Allow team to change the recipient multisig address
495     function setMultisig(address addr) public onlyOwner {
496       	require(addr != address(0));
497       	multisig = addr;
498         SetMultisig(addr);
499     }
500 
501     //Allows Team to adjust average blocktime according to network status, 
502     //in order to provide more precise timing for ICO phases & lock-up periods
503     function setAverageBlockTime(uint256 newBlockTime) public onlyOwner {
504         require(newBlockTime > 0);
505         averageBlockTime = newBlockTime;
506     }
507 
508     //Allows Team to adjust basePrice so price of the token has correct correlation to dollar
509     function setBasePrice(uint256 newBasePrice) public onlyOwner {
510         require(!crowdsaleStarted);
511         require(newBasePrice > 0);
512         basePrice = newBasePrice;
513     }
514 
515     function transfer(address _to, uint256 _value) public crowdsaleTransferLock 
516     returns(bool) {
517         return super.transfer(_to, _value);
518     }
519 
520     function transferFrom(address _from, address _to, uint256 _value) public 
521     crowdsaleTransferLock returns(bool) {
522         return super.transferFrom(_from, _to, _value);
523     }
524 
525     //Price of token in terms of ether.
526     function tokenPrice() public constant returns(uint256) {
527         uint8 p = phase();
528         if (p == 0) return basePrice.mul(50).div(100); //Presale: 50% discount
529         if (p == 1) return basePrice.mul(70).div(100); //ICO phase 1: 30% discount
530         if (p == 2) return basePrice.mul(75).div(100); //Phase 2 :25% discount
531         if (p == 3) return basePrice.mul(80).div(100); //Phase 3: 20% discount
532         if (p == 4) return basePrice.mul(85).div(100); //Phase 4: 15% discount
533         if (p == 5) return basePrice.mul(90).div(100); //Phase 5: 10% discount
534         return basePrice;
535     }
536 
537     function phase() public constant returns (uint8) {
538         if (presaleOn()) return 0;
539         if (crowdsaleTokenSold <= phase1Cap && block.number <= phase1EndBlock) return 1;
540         if (crowdsaleTokenSold <= phase2Cap && block.number <= phase2EndBlock) return 2;
541         if (crowdsaleTokenSold <= phase3Cap && block.number <= phase3EndBlock) return 3;
542         if (crowdsaleTokenSold <= phase4Cap && block.number <= phase4EndBlock) return 4;
543         if (crowdsaleTokenSold <= crowdsaleTokenSupply && block.number <= phase5EndBlock) return 5;
544         return 6;
545     }
546 
547     function presaleOn() public constant returns (bool) {
548         return (presaleStarted && !presaleConcluded && presaleTokenSold < presaleTokenSupply);
549     }
550 
551     function crowdsaleOn() public constant returns (bool) {
552         return (crowdsaleStarted && block.number <= endBlock && crowdsaleTokenSold < crowdsaleTokenSupply);
553     }
554 
555     function dayToBlockNumber(uint256 dayNum) public constant returns(uint256) {
556         return dayNum.mul(86400).div(averageBlockTime); //86400 = 24*60*60 = number of seconds in a day
557     }
558 
559     function getContributionFromHash(bytes32 contributionHash) public constant returns (
560             address contributor,
561             address recipient,
562             uint256 ethWei,
563             uint256 tokens,
564             bool resolved,
565             bool success
566         ) {
567         Contribution c = contributions[contributionHash];
568         contributor = c.contributor;
569         recipient = c.recipient;
570         ethWei = c.ethWei;
571         tokens = c.tokens;
572         resolved = c.resolved;
573         success = c.success;
574     }
575 
576     function getContributionHashes() public constant returns (bytes32[]) {
577         return contributionHashes;
578     }
579 
580 }