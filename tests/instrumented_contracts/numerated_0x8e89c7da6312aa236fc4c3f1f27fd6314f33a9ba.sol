1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Crowdsale {
30   using SafeMath for uint256;
31 
32   // The token being sold
33   MintableToken public token;
34 
35   // start and end timestamps where investments are allowed (both inclusive)
36   uint256 public startTime;
37   uint256 public endTime;
38 
39   // address where funds are collected
40   address public wallet;
41 
42   // how many token units a buyer gets per wei
43   uint256 public rate;
44 
45   // amount of raised money in wei
46   uint256 public weiRaised;
47 
48   /**
49    * event for token purchase logging
50    * @param purchaser who paid for the tokens
51    * @param beneficiary who got the tokens
52    * @param value weis paid for purchase
53    * @param amount amount of tokens purchased
54    */
55   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
56 
57 
58   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
59     require(_startTime >= now);
60     require(_endTime >= _startTime);
61     require(_rate > 0);
62     require(_wallet != 0x0);
63 
64     token = createTokenContract();
65     startTime = _startTime;
66     endTime = _endTime;
67     rate = _rate;
68     wallet = _wallet;
69   }
70 
71   // creates the token to be sold.
72   // override this method to have crowdsale of a specific mintable token.
73   function createTokenContract() internal returns (MintableToken) {
74     return new MintableToken();
75   }
76 
77 
78   // fallback function can be used to buy tokens
79   function () payable {
80     buyTokens(msg.sender);
81   }
82 
83   // low level token purchase function
84   function buyTokens(address beneficiary) public payable {
85     require(beneficiary != 0x0);
86     require(validPurchase());
87 
88     uint256 weiAmount = msg.value;
89 
90     // calculate token amount to be created
91     uint256 tokens = weiAmount.mul(rate);
92 
93     // update state
94     weiRaised = weiRaised.add(weiAmount);
95 
96     token.mint(beneficiary, tokens);
97     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
98 
99     forwardFunds();
100   }
101 
102   // send ether to the fund collection wallet
103   // override to create custom fund forwarding mechanisms
104   function forwardFunds() internal {
105     wallet.transfer(msg.value);
106   }
107 
108   // @return true if the transaction can buy tokens
109   function validPurchase() internal constant returns (bool) {
110     bool withinPeriod = now >= startTime && now <= endTime;
111     bool nonZeroPurchase = msg.value != 0;
112     return withinPeriod && nonZeroPurchase;
113   }
114 
115   // @return true if crowdsale event has ended
116   function hasEnded() public constant returns (bool) {
117     return now > endTime;
118   }
119 
120 
121 }
122 
123 contract Ownable {
124   address public owner;
125 
126 
127   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
128 
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   function Ownable() {
135     owner = msg.sender;
136   }
137 
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147 
148   /**
149    * @dev Allows the current owner to transfer control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function transferOwnership(address newOwner) onlyOwner public {
153     require(newOwner != address(0));
154     OwnershipTransferred(owner, newOwner);
155     owner = newOwner;
156   }
157 
158 }
159 
160 contract ERC20Basic {
161   uint256 public totalSupply;
162   function balanceOf(address who) public constant returns (uint256);
163   function transfer(address to, uint256 value) public returns (bool);
164   event Transfer(address indexed from, address indexed to, uint256 value);
165 }
166 
167 contract BasicToken is ERC20Basic {
168   using SafeMath for uint256;
169 
170   mapping(address => uint256) balances;
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179 
180     // SafeMath.sub will throw if there is not enough balance.
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     Transfer(msg.sender, _to, _value);
184     return true;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param _owner The address to query the the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address _owner) public constant returns (uint256 balance) {
193     return balances[_owner];
194   }
195 
196 }
197 
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender) public constant returns (uint256);
200   function transferFrom(address from, address to, uint256 value) public returns (bool);
201   function approve(address spender, uint256 value) public returns (bool);
202   event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 library SafeERC20 {
206   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
207     assert(token.transfer(to, value));
208   }
209 
210   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
211     assert(token.transferFrom(from, to, value));
212   }
213 
214   function safeApprove(ERC20 token, address spender, uint256 value) internal {
215     assert(token.approve(spender, value));
216   }
217 }
218 
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
231     require(_to != address(0));
232 
233     uint256 _allowance = allowed[_from][msg.sender];
234 
235     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
236     // require (_value <= _allowance);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = _allowance.sub(_value);
241     Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    */
277   function increaseApproval (address _spender, uint _addedValue)
278     returns (bool success) {
279     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   function decreaseApproval (address _spender, uint _subtractedValue)
285     returns (bool success) {
286     uint oldValue = allowed[msg.sender][_spender];
287     if (_subtractedValue > oldValue) {
288       allowed[msg.sender][_spender] = 0;
289     } else {
290       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291     }
292     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296 }
297 
298 contract BurnableToken is StandardToken {
299 
300     event Burn(address indexed burner, uint256 value);
301 
302     /**
303      * @dev Burns a specific amount of tokens.
304      * @param _value The amount of token to be burned.
305      */
306     function burn(uint256 _value) public {
307         require(_value > 0);
308 
309         address burner = msg.sender;
310         balances[burner] = balances[burner].sub(_value);
311         totalSupply = totalSupply.sub(_value);
312         Burn(burner, _value);
313     }
314 }
315 
316 contract MintableToken is StandardToken, Ownable {
317   event Mint(address indexed to, uint256 amount);
318   event MintFinished();
319 
320   bool public mintingFinished = false;
321 
322 
323   modifier canMint() {
324     require(!mintingFinished);
325     _;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
335     totalSupply = totalSupply.add(_amount);
336     balances[_to] = balances[_to].add(_amount);
337     Mint(_to, _amount);
338     Transfer(0x0, _to, _amount);
339     return true;
340   }
341 
342   /**
343    * @dev Function to stop minting new tokens.
344    * @return True if the operation was successful.
345    */
346   function finishMinting() onlyOwner public returns (bool) {
347     mintingFinished = true;
348     MintFinished();
349     return true;
350   }
351 }
352 
353 contract TokenTimelock {
354   using SafeERC20 for ERC20Basic;
355 
356   // ERC20 basic token contract being held
357   ERC20Basic public token;
358 
359   // beneficiary of tokens after they are released
360   address public beneficiary;
361 
362   // timestamp when token release is enabled
363   uint64 public releaseTime;
364 
365   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) {
366     require(_releaseTime > now);
367     token = _token;
368     beneficiary = _beneficiary;
369     releaseTime = _releaseTime;
370   }
371 
372   /**
373    * @notice Transfers tokens held by timelock to beneficiary.
374    * Deprecated: please use TokenTimelock#release instead.
375    */
376   function claim() public {
377     require(msg.sender == beneficiary);
378     release();
379   }
380 
381   /**
382    * @notice Transfers tokens held by timelock to beneficiary.
383    */
384   function release() public {
385     require(now >= releaseTime);
386 
387     uint256 amount = token.balanceOf(this);
388     require(amount > 0);
389 
390     token.safeTransfer(beneficiary, amount);
391   }
392 }
393 
394 contract AidCoin is MintableToken, BurnableToken {
395     string public name = "AidCoin";
396     string public symbol = "AID";
397     uint256 public decimals = 18;
398     uint256 public maxSupply = 100000000 * (10 ** decimals);
399 
400     function AidCoin() public {
401 
402     }
403 
404     modifier canTransfer(address _from, uint _value) {
405         require(mintingFinished);
406         _;
407     }
408 
409     function transfer(address _to, uint _value) canTransfer(msg.sender, _value) public returns (bool) {
410         return super.transfer(_to, _value);
411     }
412 
413     function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) public returns (bool) {
414         return super.transferFrom(_from, _to, _value);
415     }
416 }
417 
418 contract AidCoinPresale is Ownable, Crowdsale {
419     using SafeMath for uint256;
420 
421     // max tokens cap
422     uint256 public tokenCap = 10000000 * (10 ** 18);
423 
424     // amount of sold tokens
425     uint256 public soldTokens;
426 
427     // Team wallet
428     address public teamWallet;
429     // Advisor wallet
430     address public advisorWallet;
431     // AID pool wallet
432     address public aidPoolWallet;
433     // Company wallet
434     address public companyWallet;
435     // Bounty wallet
436     address public bountyWallet;
437 
438     // reserved tokens
439     uint256 public teamTokens 		= 	10000000 * (10 ** 18);
440     uint256 public advisorTokens 	= 	10000000 * (10 ** 18);
441     uint256 public aidPoolTokens 	= 	10000000 * (10 ** 18);
442     uint256 public companyTokens 	= 	27000000 * (10 ** 18);
443     uint256 public bountyTokens 	= 	3000000 * (10 ** 18);
444 
445     uint256 public claimedAirdropTokens;
446     mapping (address => bool) public claimedAirdrop;
447 
448     // team locked tokens
449     TokenTimelock public teamTimeLock;
450     // advisor locked tokens
451     TokenTimelock public advisorTimeLock;
452     // company locked tokens
453     TokenTimelock public companyTimeLock;
454 
455     modifier beforeEnd() {
456         require(now < endTime);
457         _;
458     }
459 
460     function AidCoinPresale(
461         uint256 _startTime,
462         uint256 _endTime,
463         uint256 _rate,
464         address _wallet,
465         address _teamWallet,
466         address _advisorWallet,
467         address _aidPoolWallet,
468         address _companyWallet,
469         address _bountyWallet
470     ) public
471     Crowdsale (_startTime, _endTime, _rate, _wallet)
472     {
473 
474         require(_teamWallet != 0x0);
475         require(_advisorWallet != 0x0);
476         require(_aidPoolWallet != 0x0);
477         require(_companyWallet != 0x0);
478         require(_bountyWallet != 0x0);
479 
480         teamWallet = _teamWallet;
481         advisorWallet = _advisorWallet;
482         aidPoolWallet = _aidPoolWallet;
483         companyWallet = _companyWallet;
484         bountyWallet = _bountyWallet;
485 
486         // give tokens to aid pool
487         token.mint(aidPoolWallet, aidPoolTokens);
488 
489         // give tokens to team with lock
490         teamTimeLock = new TokenTimelock(token, teamWallet, uint64(now + 1 years));
491         token.mint(address(teamTimeLock), teamTokens);
492 
493         // give tokens to company with lock
494         companyTimeLock = new TokenTimelock(token, companyWallet, uint64(now + 1 years));
495         token.mint(address(companyTimeLock), companyTokens);
496 
497         // give tokens to advisor
498         uint256 initialAdvisorTokens = advisorTokens.mul(20).div(100);
499         token.mint(advisorWallet, initialAdvisorTokens);
500         uint256 lockedAdvisorTokens = advisorTokens.sub(initialAdvisorTokens);
501         advisorTimeLock = new TokenTimelock(token, advisorWallet, uint64(now + 180 days));
502         token.mint(address(advisorTimeLock), lockedAdvisorTokens);
503     }
504 
505     /**
506      * @dev Create new instance of ico token contract
507      */
508     function createTokenContract() internal returns (MintableToken) {
509         return new AidCoin();
510     }
511 
512     // low level token purchase function
513     function buyTokens(address beneficiary) public payable {
514         require(beneficiary != 0x0);
515         require(validPurchase());
516 
517         // get wei amount
518         uint256 weiAmount = msg.value;
519 
520         // calculate token amount to be transferred
521         uint256 tokens = weiAmount.mul(rate);
522 
523         // calculate new total sold
524         uint256 newTotalSold = soldTokens.add(tokens);
525 
526         // check if we are over the max token cap
527         require(newTotalSold <= tokenCap);
528 
529         // update states
530         weiRaised = weiRaised.add(weiAmount);
531         soldTokens = newTotalSold;
532 
533         // mint tokens to beneficiary
534         token.mint(beneficiary, tokens);
535         TokenPurchase(
536             msg.sender,
537             beneficiary,
538             weiAmount,
539             tokens
540         );
541 
542         forwardFunds();
543     }
544 
545     // mint tokens for airdrop
546     function airdrop(address[] users) public onlyOwner beforeEnd {
547         require(users.length > 0);
548 
549         uint256 amount = 5 * (10 ** 18);
550 
551         uint len = users.length;
552         for (uint i = 0; i < len; i++) {
553             address to = users[i];
554             if (!claimedAirdrop[to]) {
555                 claimedAirdropTokens = claimedAirdropTokens.add(amount);
556                 require(claimedAirdropTokens <= bountyTokens);
557 
558                 claimedAirdrop[to] = true;
559                 token.mint(to, amount);
560             }
561         }
562     }
563 
564     // close token sale and transfer ownership, also move unclaimed airdrop tokens
565     function closeTokenSale(address _icoContract) public onlyOwner {
566         require(hasEnded());
567         require(_icoContract != 0x0);
568 
569         // mint unclaimed bounty tokens
570         uint256 unclaimedAirdropTokens = bountyTokens.sub(claimedAirdropTokens);
571         if (unclaimedAirdropTokens > 0) {
572             token.mint(bountyWallet, unclaimedAirdropTokens);
573         }
574 
575         // transfer token ownership to ico contract
576         token.transferOwnership(_icoContract);
577     }
578 
579     // overriding Crowdsale#hasEnded to add tokenCap logic
580     // @return true if crowdsale event has ended or cap is reached
581     function hasEnded() public constant returns (bool) {
582         bool capReached = soldTokens >= tokenCap;
583         return super.hasEnded() || capReached;
584     }
585 
586     // @return true if crowdsale event has started
587     function hasStarted() public constant returns (bool) {
588         return now >= startTime && now < endTime;
589     }
590 }