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
34 contract ContractReceiver{
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
180 // Based in part on code by Open-Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
181 // Based in part on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182 // Smart contract for the RepuX token & the first crowdsale
183 contract RepuX is StandardToken, Ownable {
184     string public constant name = "RepuX";
185     string public constant symbol = "RPX";
186     uint256 public constant decimals = 18;
187     address public multisig; //multisig wallet, to which all contributions will be sent
188 
189     uint256 public phase1StartBlock; //Crowdsale start block
190     uint256 public phase1EndBlock; // Day 7 (estimate)
191     uint256 public phase2EndBlock; // Day 13 (estimate)
192     uint256 public phase3EndBlock; // Day 19 (estimate)
193     uint256 public phase4EndBlock; // Day 25 (estimate)
194     uint256 public phase5EndBlock; // Day 31 (estimate)
195     uint256 public endBlock; //whole crowdsale end block
196 
197     uint256 public basePrice = 1226 * (10**12); // ICO token base price: ~$0.35 (estimate assuming $290 per Eth)
198 
199     uint256 public totalSupply = 500000000 * (10**decimals); //Token total supply: 500000000 RPX
200     uint256 public presaleTokenSupply = totalSupply.mul(10).div(100); //Amount of tokens available during presale (10%)
201     uint256 public crowdsaleTokenSupply = totalSupply.mul(50).div(100); //Amount of tokens available during crowdsale (50%)
202     uint256 public rewardsTokenSupply = totalSupply.mul(15).div(100); //Rewards pool (VIP etc, 10%), ambassador share(3%) & ICO bounties(2%)
203     uint256 public teamTokenSupply = totalSupply.mul(12).div(100); //Tokens distributed to team (12% in total, 4% vested for 12, 24 & 36 months)
204     uint256 public ICOReserveSupply = totalSupply.mul(13).div(100); //Token reserve for 2nd ICO (after 2 years min, 13%)
205     uint256 public presaleTokenSold = 0; //Records the amount of tokens sold during presale
206     uint256 public crowdsaleTokenSold = 0; //Records the amount of tokens sold during the crowdsale
207 
208     uint256 public phase1Cap = 125000000 * (10**decimals);
209     uint256 public phase2Cap = phase1Cap.add(50000000 * (10**decimals));
210     uint256 public phase3Cap = phase2Cap.add(37500000 * (10**decimals));
211     uint256 public phase4Cap = phase3Cap.add(25000000 * (10**decimals));
212 
213     uint256 public transferLockup = 5760; //Lock up token transfer until ~2 days after crowdsale concludes
214     uint256 public teamLockUp; 
215     uint256 public ICOReserveLockUp;
216     uint256 private teamWithdrawlCount = 0;
217     uint256 public averageBlockTime = 30; //Average block time in seconds
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
230     event Halt(); //Halt event
231     event Unhalt(); //Unhalt event
232     event Burn(address burner, uint256 amount);
233 
234     struct Contribution {
235         address contributor;
236         address recipient;
237         uint256 ethWei;
238         uint256 tokens;
239         bool resolved;
240         bool success;
241         uint8 stage;
242     }
243 
244     event ContributionReceived(bytes32 contributionHash, address contributor, address recipient,
245         uint256 ethWei, uint256 pendingTokens);
246 
247     event ContributionResolved(bytes32 contributionHash, bool pass, address contributor, 
248         address recipient, uint256 ethWei, uint256 tokens);
249 
250 
251     // lockup during and after 48h of end of crowdsale
252     modifier crowdsaleTransferLock() {
253         require(crowdsaleConcluded && block.number >= endBlock.add(transferLockup));
254         _;
255     }
256 
257     modifier whenNotHalted() {
258         require(!halted);
259         _;
260     }
261 
262     //Constructor: set owner (team) address & crowdsale recipient multisig wallet address
263     //Allocate reward tokens to the team wallet
264   	function RepuX(address _multisig) {
265         owner = msg.sender;
266         multisig = _multisig;
267         balances[owner] = rewardsTokenSupply;
268   	}
269 
270     //Fallback function when receiving Ether. Contributors can directly send Ether to the token address during crowdsale.
271     function() payable {
272         buy();
273     }
274 
275 
276     //Halt ICO in case of emergency.
277     function halt() public onlyOwner {
278         halted = true;
279         Halt();
280     }
281 
282     function unhalt() public onlyOwner {
283         halted = false;
284         Unhalt();
285     }
286 
287     function startPresale() public onlyOwner {
288         require(!presaleStarted);
289         presaleStarted = true;
290     }
291 
292     function concludePresale() public onlyOwner {
293         require(presaleStarted && !presaleConcluded);
294         presaleConcluded = true;
295         //Unsold tokens in the presale are made available in the crowdsale.
296         crowdsaleTokenSupply = crowdsaleTokenSupply.add(presaleTokenSupply.sub(presaleTokenSold)); 
297     }
298 
299     //Can only be called after presale is concluded.
300     function startCrowdsale() public onlyOwner {
301         require(presaleConcluded && !crowdsaleStarted);
302         crowdsaleStarted = true;
303         phase1StartBlock = block.number;
304         phase1EndBlock = phase1StartBlock.add(dayToBlockNumber(7));
305         phase2EndBlock = phase1EndBlock.add(dayToBlockNumber(6));
306         phase3EndBlock = phase2EndBlock.add(dayToBlockNumber(6));
307         phase4EndBlock = phase3EndBlock.add(dayToBlockNumber(6));
308         phase5EndBlock = phase4EndBlock.add(dayToBlockNumber(6));
309         endBlock = phase5EndBlock;
310     }
311 
312     //Can only be called either after crowdsale time period ends, or after tokens have sold out
313     function concludeCrowdsale() public onlyOwner {
314         require(crowdsaleStarted && !crowdsaleOn() && !crowdsaleConcluded);
315         crowdsaleConcluded = true;
316         endBlock = block.number;
317         uint256 unsold = crowdsaleTokenSupply.sub(crowdsaleTokenSold);
318         if (unsold > 0) {
319             //Burn unsold tokens
320             totalSupply = totalSupply.sub(unsold);
321             Burn(this, unsold);
322             Transfer(this, address(0), unsold);
323         }
324         teamLockUp = dayToBlockNumber(365); //12-month lock-up period
325         ICOReserveLockUp = dayToBlockNumber(365 * 2); //2 years lock up period
326     }
327 
328     function withdrawTeamToken() public onlyOwner {
329         require(teamWithdrawlCount < 3);
330         require(crowdsaleConcluded);
331         if (teamWithdrawlCount == 0) {
332             require(block.number >= endBlock.add(teamLockUp)); //12-month lock-up
333         } else if (teamWithdrawlCount == 1) {
334             require(block.number >= endBlock.add(teamLockUp.mul(2))); //24-month lock-up
335         } else {
336             require(block.number >= endBlock.add(teamLockUp.mul(3))); //36-month lock-up
337         }
338         teamWithdrawlCount++;
339         uint256 tokens = teamTokenSupply.div(3);
340         balances[owner] = balances[owner].add(tokens);
341         Transfer(this, owner, tokens);
342     }
343 
344     function withdrawICOReserve() public onlyOwner {
345         require(!ICOReserveWithdrawn);
346         require(crowdsaleConcluded);
347         require(block.number >= endBlock.add(ICOReserveLockUp));
348         ICOReserveWithdrawn = true;
349         balances[owner] = balances[owner].add(ICOReserveSupply);
350         Transfer(this, owner, ICOReserveSupply);
351     }
352 
353     function buy() payable {
354         buyRecipient(msg.sender);
355     }
356 
357 
358     //Allow addresses to buy token for another account
359     function buyRecipient(address recipient) public payable whenNotHalted {
360         require(msg.value > 0);
361         require(presaleOn()||crowdsaleOn()); //Contribution only allowed during presale/crowdsale
362         uint256 tokens = msg.value.div(tokenPrice()); 
363         uint8 stage = 0;
364 
365         if(presaleOn()) {
366             require(presaleTokenSold.add(tokens) <= presaleTokenSupply);
367             presaleTokenSold = presaleTokenSold.add(tokens);
368         } else {
369             require(crowdsaleTokenSold.add(tokens) <= crowdsaleTokenSupply);
370             crowdsaleTokenSold = crowdsaleTokenSold.add(tokens);
371             stage = 1;
372         }
373         contributionCount = contributionCount.add(1);
374         bytes32 transactionHash = keccak256(contributionCount, msg.sender, msg.value, msg.data,
375             msg.gas, block.number, tx.gasprice);
376         contributions[transactionHash] = Contribution(msg.sender, recipient, msg.value, 
377             tokens, false, false, stage);
378         contributionHashes.push(transactionHash);
379         ContributionReceived(transactionHash, msg.sender, recipient, msg.value, tokens);
380     }
381 
382     //Accept a contribution if KYC passed.
383     function acceptContribution(bytes32 transactionHash) public onlyOwner {
384         Contribution storage c = contributions[transactionHash];
385         require(!c.resolved);
386         c.resolved = true;
387         c.success = true;
388         balances[c.recipient] = balances[c.recipient].add(c.tokens);
389         assert(multisig.send(c.ethWei));
390         Transfer(this, c.recipient, c.tokens);
391         ContributionResolved(transactionHash, true, msg.sender, c.recipient, c.ethWei, 
392             c.tokens);
393     }
394 
395     //Reject a contribution if KYC failed.
396     function rejectContribution(bytes32 transactionHash) public onlyOwner {
397         Contribution storage c = contributions[transactionHash];
398         require(!c.resolved);
399         c.resolved = true;
400         c.success = false;
401         if (c.stage == 0) {
402             presaleTokenSold = presaleTokenSold.sub(c.tokens);
403         } else {
404             crowdsaleTokenSold = crowdsaleTokenSold.sub(c.tokens);
405         }
406         assert(c.contributor.send(c.ethWei));
407         ContributionResolved(transactionHash, false, msg.sender, c.recipient, c.ethWei, 
408             c.tokens);
409     }
410 
411 
412     //Burns the specified amount of tokens from the team wallet address
413     function burn(uint256 _value) public onlyOwner returns (bool) {
414         balances[msg.sender] = balances[msg.sender].sub(_value);
415         totalSupply = totalSupply.sub(_value);
416         Transfer(msg.sender, address(0), _value);
417         Burn(msg.sender, _value);
418         return true;
419     }
420 
421     //Allow team to change the recipient multisig address
422     function setMultisig(address addr) public onlyOwner {
423       	require(addr != address(0));
424       	multisig = addr;
425     }
426 
427     //Allows Team to adjust average blocktime according to network status, 
428     //in order to provide more precise timing for ICO phases & lock-up periods
429     function setAverageBlockTime(uint256 newBlockTime) public onlyOwner {
430         require(newBlockTime > 0);
431         averageBlockTime = newBlockTime;
432     }
433 
434     function transfer(address _to, uint256 _value) public crowdsaleTransferLock 
435     returns(bool) {
436         return super.transfer(_to, _value);
437     }
438 
439     function transferFrom(address _from, address _to, uint256 _value) public 
440     crowdsaleTransferLock returns(bool) {
441         return super.transferFrom(_from, _to, _value);
442     }
443 
444     //Price of token in terms of ether.
445     function tokenPrice() public constant returns(uint256) {
446         uint8 p = phase();
447         if (p == 0) return basePrice.mul(40).div(100); //Presale: 60% discount
448         if (p == 1) return basePrice.mul(50).div(100); //ICO phase 1: 50% discount
449         if (p == 2) return basePrice.mul(60).div(100); //Phase 2 :40% discount
450         if (p == 3) return basePrice.mul(70).div(100); //Phase 3: 30% discount
451         if (p == 4) return basePrice.mul(80).div(100); //Phase 4: 20% discount
452         if (p == 5) return basePrice.mul(90).div(100); //Phase 5: 10% discount
453         return basePrice;
454     }
455 
456     function phase() public constant returns (uint8) {
457         if (presaleOn()) return 0;
458         if (crowdsaleTokenSold <= phase1Cap && block.number <= phase1EndBlock) return 1;
459         if (crowdsaleTokenSold <= phase2Cap && block.number <= phase2EndBlock) return 2;
460         if (crowdsaleTokenSold <= phase3Cap && block.number <= phase3EndBlock) return 3;
461         if (crowdsaleTokenSold <= phase4Cap && block.number <= phase4EndBlock) return 4;
462         if (crowdsaleTokenSold <= crowdsaleTokenSupply && block.number <= phase5EndBlock) return 5;
463         return 6;
464     }
465 
466     function presaleOn() public constant returns (bool) {
467         return (presaleStarted && !presaleConcluded && presaleTokenSold < presaleTokenSupply);
468     }
469 
470     function crowdsaleOn() public constant returns (bool) {
471         return (crowdsaleStarted && block.number <= endBlock && crowdsaleTokenSold < crowdsaleTokenSupply);
472     }
473 
474     function dayToBlockNumber(uint256 dayNum) public constant returns(uint256) {
475         return dayNum.mul(86400).div(averageBlockTime); //86400 = 24*60*60 = number of seconds in a day
476     }
477 
478     function getContributionFromHash(bytes32 contributionHash) public constant returns (
479             address contributor,
480             address recipient,
481             uint256 ethWei,
482             uint256 tokens,
483             bool resolved,
484             bool success
485         ) {
486         Contribution c = contributions[contributionHash];
487         contributor = c.contributor;
488         recipient = c.recipient;
489         ethWei = c.ethWei;
490         tokens = c.tokens;
491         resolved = c.resolved;
492         success = c.success;
493     }
494 
495     function getContributionHashes() public constant returns (bytes32[]) {
496         return contributionHashes;
497     }
498 
499 }