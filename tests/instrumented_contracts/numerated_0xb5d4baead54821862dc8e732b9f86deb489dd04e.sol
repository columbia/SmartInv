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
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract LimitedTransferToken is ERC20 {
112 
113   /**
114    * @dev Checks whether it can transfer or otherwise throws.
115    */
116   modifier canTransfer(address _sender, uint256 _value) {
117    require(_value <= transferableTokens(_sender, uint64(now)));
118    _;
119   }
120 
121   /**
122    * @dev Checks modifier and allows transfer if tokens are not locked.
123    * @param _to The address that will receive the tokens.
124    * @param _value The amount of tokens to be transferred.
125    */
126   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
127     return super.transfer(_to, _value);
128   }
129 
130   /**
131   * @dev Checks modifier and allows transfer if tokens are not locked.
132   * @param _from The address that will send the tokens.
133   * @param _to The address that will receive the tokens.
134   * @param _value The amount of tokens to be transferred.
135   */
136   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
137     return super.transferFrom(_from, _to, _value);
138   }
139 
140   /**
141    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
142    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
143    * specific logic for limiting token transferability for a holder over time.
144    */
145   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
146     return balanceOf(holder);
147   }
148 }
149 
150 library SafeERC20 {
151   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
152     assert(token.transfer(to, value));
153   }
154 
155   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
156     assert(token.transferFrom(from, to, value));
157   }
158 
159   function safeApprove(ERC20 token, address spender, uint256 value) internal {
160     assert(token.approve(spender, value));
161   }
162 }
163 
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177 
178     uint256 _allowance = allowed[_from][msg.sender];
179 
180     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
181     // require (_value <= _allowance);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = _allowance.sub(_value);
186     Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    */
222   function increaseApproval (address _spender, uint _addedValue)
223     returns (bool success) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   function decreaseApproval (address _spender, uint _subtractedValue)
230     returns (bool success) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 contract MintableToken is StandardToken, Ownable {
244   event Mint(address indexed to, uint256 amount);
245   event MintFinished();
246 
247   bool public mintingFinished = false;
248 
249 
250   modifier canMint() {
251     require(!mintingFinished);
252     _;
253   }
254 
255   /**
256    * @dev Function to mint tokens
257    * @param _to The address that will receive the minted tokens.
258    * @param _amount The amount of tokens to mint.
259    * @return A boolean that indicates if the operation was successful.
260    */
261   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
262     totalSupply = totalSupply.add(_amount);
263     balances[_to] = balances[_to].add(_amount);
264     Mint(_to, _amount);
265     Transfer(0x0, _to, _amount);
266     return true;
267   }
268 
269   /**
270    * @dev Function to stop minting new tokens.
271    * @return True if the operation was successful.
272    */
273   function finishMinting() onlyOwner public returns (bool) {
274     mintingFinished = true;
275     MintFinished();
276     return true;
277   }
278 }
279 
280 contract TokenTimelock {
281   using SafeERC20 for ERC20Basic;
282 
283   // ERC20 basic token contract being held
284   ERC20Basic public token;
285 
286   // beneficiary of tokens after they are released
287   address public beneficiary;
288 
289   // timestamp when token release is enabled
290   uint64 public releaseTime;
291 
292   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) {
293     require(_releaseTime > now);
294     token = _token;
295     beneficiary = _beneficiary;
296     releaseTime = _releaseTime;
297   }
298 
299   /**
300    * @notice Transfers tokens held by timelock to beneficiary.
301    * Deprecated: please use TokenTimelock#release instead.
302    */
303   function claim() public {
304     require(msg.sender == beneficiary);
305     release();
306   }
307 
308   /**
309    * @notice Transfers tokens held by timelock to beneficiary.
310    */
311   function release() public {
312     require(now >= releaseTime);
313 
314     uint256 amount = token.balanceOf(this);
315     require(amount > 0);
316 
317     token.safeTransfer(beneficiary, amount);
318   }
319 }
320 
321 contract StarterCoin is MintableToken, LimitedTransferToken {
322 
323     string public constant name = "StarterCoin";
324     string public constant symbol = "STAC";
325     uint8 public constant decimals = 18;
326 
327     uint256 public endTimeICO;
328     address public bountyWallet;
329 
330     function StarterCoin(uint256 _endTimeICO, address _bountyWallet) {
331         endTimeICO = _endTimeICO;
332         bountyWallet = _bountyWallet;
333     }
334 
335     function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
336         // allow transfers after the end of ICO
337         return (time > endTimeICO) || (holder == bountyWallet) ? balanceOf(holder) : 0;
338     }
339 
340 }
341 
342 contract StarterCoinCrowdsale is Ownable {
343     using SafeMath for uint256;
344     // The token being sold
345     MintableToken public token;
346 
347     // start and end timestamps where investments are allowed (both inclusive)
348     uint256 public startTime;
349     uint256 public endTime;
350 
351     uint256[11] public timings;
352     uint8[10] public bonuses;
353 
354     // address where funds are collected
355     address public wallet89;
356     address public wallet10;
357     address public wallet1;
358 
359     // how many token units a buyer gets per wei
360     uint256 public constant RATE = 4500;
361 
362     // amount of raised money in wei
363     uint256 public weiRaised;
364 
365     uint256 public tokenSold;
366 
367     uint256 public constant CAP = 154622 ether;
368     uint256 public constant TOKEN_CAP = 695797500 * (10 ** uint256(18)); // 45000000+62797500+588000000 STC
369 
370     TokenTimelock public devTokenTimelock;
371     TokenTimelock public foundersTokenTimelock;
372     TokenTimelock public teamTokenTimelock;
373     TokenTimelock public advisersTokenTimelock;
374 
375     uint256 public constant BOUNTY_SUPPLY = 78400000 * (10 ** uint256(18));
376     uint256 public constant DEV_SUPPLY = 78400000 * (10 ** uint256(18));
377     uint256 public constant FOUNDERS_SUPPLY = 59600000 * (10 ** uint256(18));
378     uint256 public constant TEAM_SUPPLY = 39200000 * (10 ** uint256(18));
379     uint256 public constant ADVISERS_SUPPLY = 29400000 * (10 ** uint256(18));
380 
381 
382     function StarterCoinCrowdsale(
383         uint256 [11] _timings,
384         uint8 [10] _bonuses,
385         address [3] _wallets,
386         address bountyWallet,
387         address devWallet,
388         uint64 devReleaseTime,
389         address foundersWallet,
390         uint64 foundersReleaseTime,
391         address teamWallet,
392         uint64 teamReleaseTime,
393         address advisersWallet,
394         uint64 advisersReleaseTime
395         ) {
396             require(_timings[0] >= now);
397 
398             for(uint i = 1; i < timings.length; i++) {
399               require(_timings[i] >= _timings[i-1]);
400             }
401 
402             timings = _timings;
403             bonuses = _bonuses;
404             startTime = timings[0];
405             endTime = timings[timings.length-1];
406 
407             require(devReleaseTime >= endTime);
408             require(foundersReleaseTime >= endTime);
409             require(teamReleaseTime >= endTime);
410             require(advisersReleaseTime >= endTime);
411 
412             require(_wallets[0] != 0x0);
413             require(_wallets[1] != 0x0);
414             require(_wallets[2] != 0x0);
415 
416             require(bountyWallet != 0x0);
417             require(devWallet != 0x0);
418             require(foundersWallet != 0x0);
419             require(teamWallet != 0x0);
420             require(advisersWallet != 0x0);
421 
422             wallet89 = _wallets[0];
423             wallet10 = _wallets[1];
424             wallet1 = _wallets[2];
425 
426             token = new StarterCoin(endTime, bountyWallet);
427 
428             token.mint(bountyWallet, BOUNTY_SUPPLY);
429 
430             devTokenTimelock = new TokenTimelock(token, devWallet, devReleaseTime);
431             token.mint(devTokenTimelock, DEV_SUPPLY);
432 
433             foundersTokenTimelock = new TokenTimelock(token, foundersWallet, foundersReleaseTime);
434             token.mint(foundersTokenTimelock, FOUNDERS_SUPPLY);
435 
436             teamTokenTimelock = new TokenTimelock(token, teamWallet, teamReleaseTime);
437             token.mint(teamTokenTimelock, TEAM_SUPPLY);
438 
439             advisersTokenTimelock = new TokenTimelock(token, advisersWallet, advisersReleaseTime);
440             token.mint(advisersTokenTimelock, ADVISERS_SUPPLY);
441         }
442 
443         /**
444         * event for token purchase logging
445         * @param purchaser who paid for the tokens
446         * @param beneficiary who got the tokens
447         * @param value weis paid for purchase
448         * @param amount amount of tokens purchased
449         */
450         event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
451 
452         // creates the token to be sold.
453         // override this method to have crowdsale of a specific mintable token.
454         function createTokenContract() internal returns (MintableToken) {
455             return new MintableToken();
456         }
457 
458 
459         // fallback function can be used to buy tokens
460         function () payable {
461             buyTokens(msg.sender);
462         }
463 
464         // low level token purchase function
465         function buyTokens(address beneficiary) public payable {
466             require(beneficiary != 0x0);
467             require(msg.value >= 100); // required for proper splitting funds between 3 wallets
468 
469             uint256 weiAmount = msg.value;
470 
471             // calculate period bonus
472             uint256 periodBonus;
473 
474             for (uint8 i = 1; i < timings.length; i++) {
475               if ( now < timings[i] ) {
476                 periodBonus = RATE.mul(uint256(bonuses[i-1])).div(100);
477                 break;
478               }
479             }
480 
481             // calculate bulk purchase bonus
482             uint256 bulkPurchaseBonus;
483             if (weiAmount >= 50 ether) {
484             bulkPurchaseBonus = 3600; // 80% bonus for RATE 4500
485             } else if (weiAmount >= 30 ether) {
486             bulkPurchaseBonus = 3150; // 70% bonus for RATE 4500
487             } else if (weiAmount >= 10 ether) {
488             bulkPurchaseBonus = 2250; // 50% bonus for RATE 4500
489             } else if (weiAmount >= 5 ether) {
490             bulkPurchaseBonus = 1350; // 30% bonus for RATE 4500
491             } else if (weiAmount >= 3 ether) {
492             bulkPurchaseBonus = 450; // 10% bonus for RATE 4500
493             }
494 
495             uint256 actualRate = RATE.add(periodBonus).add(bulkPurchaseBonus);
496 
497             // calculate token amount to be created
498             uint256 tokens = weiAmount.mul(actualRate);
499 
500             // update state
501             weiRaised = weiRaised.add(weiAmount);
502             tokenSold = tokenSold.add(tokens);
503 
504             require(validPurchase());
505 
506             token.mint(beneficiary, tokens);
507             TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
508 
509             forwardFunds();
510         }
511 
512         // send ether to the fund collection wallet
513         // override to create custom fund forwarding mechanisms
514         function forwardFunds() internal {
515           uint256 wei89 = msg.value.mul(89).div(100);
516           uint256 wei10 = msg.value.div(10);
517           uint256 wei1 = msg.value.sub(wei89).sub(wei10);
518           wallet89.transfer(wei89);
519           wallet10.transfer(wei10);
520           wallet1.transfer(wei1);
521         }
522 
523         // add off chain contribution. BTC address of contribution added for transparency
524         function addOffChainContribution(address beneficiar, uint256 weiAmount, uint256 tokenAmount, string btcAddress) onlyOwner public {
525             require(beneficiar != 0x0);
526             require(weiAmount > 0);
527             require(tokenAmount > 0);
528             weiRaised += weiAmount;
529             tokenSold += tokenAmount;
530             require(validPurchase());
531             token.mint(beneficiar, tokenAmount);
532         }
533 
534 
535         // overriding Crowdsale#validPurchase to add extra CAP logic
536         // @return true if investors can buy at the moment
537         function validPurchase() internal constant returns (bool) {
538             bool withinCap = weiRaised <= CAP;
539             bool withinPeriod = now >= startTime && now <= endTime;
540             bool withinTokenCap = tokenSold <= TOKEN_CAP;
541             return withinPeriod && withinCap && withinTokenCap;
542         }
543 
544         // overriding Crowdsale#hasEnded to add CAP logic
545         // @return true if crowdsale event has ended
546         function hasEnded() public constant returns (bool) {
547             bool capReached = weiRaised >= CAP;
548             return now > endTime || capReached;
549         }
550 
551     }