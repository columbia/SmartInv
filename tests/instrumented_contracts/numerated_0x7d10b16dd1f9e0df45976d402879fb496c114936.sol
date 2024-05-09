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
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) allowed;
208 
209 
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218 
219     uint256 _allowance = allowed[_from][msg.sender];
220 
221     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
222     // require (_value <= _allowance);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = _allowance.sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    */
263   function increaseApproval (address _spender, uint _addedValue)
264     returns (bool success) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   function decreaseApproval (address _spender, uint _subtractedValue)
271     returns (bool success) {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 contract BurnableToken is StandardToken {
285 
286     event Burn(address indexed burner, uint256 value);
287 
288     /**
289      * @dev Burns a specific amount of tokens.
290      * @param _value The amount of token to be burned.
291      */
292     function burn(uint256 _value) public {
293         require(_value > 0);
294 
295         address burner = msg.sender;
296         balances[burner] = balances[burner].sub(_value);
297         totalSupply = totalSupply.sub(_value);
298         Burn(burner, _value);
299     }
300 }
301 
302 contract MintableToken is StandardToken, Ownable {
303   event Mint(address indexed to, uint256 amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307 
308 
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
321     totalSupply = totalSupply.add(_amount);
322     balances[_to] = balances[_to].add(_amount);
323     Mint(_to, _amount);
324     Transfer(0x0, _to, _amount);
325     return true;
326   }
327 
328   /**
329    * @dev Function to stop minting new tokens.
330    * @return True if the operation was successful.
331    */
332   function finishMinting() onlyOwner public returns (bool) {
333     mintingFinished = true;
334     MintFinished();
335     return true;
336   }
337 }
338 
339 contract AidCoin is MintableToken, BurnableToken {
340     string public name = "AidCoin";
341     string public symbol = "AID";
342     uint256 public decimals = 18;
343     uint256 public maxSupply = 100000000 * (10 ** decimals);
344 
345     function AidCoin() public {
346 
347     }
348 
349     modifier canTransfer(address _from, uint _value) {
350         require(mintingFinished);
351         _;
352     }
353 
354     function transfer(address _to, uint _value) canTransfer(msg.sender, _value) public returns (bool) {
355         return super.transfer(_to, _value);
356     }
357 
358     function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) public returns (bool) {
359         return super.transferFrom(_from, _to, _value);
360     }
361 }
362 
363 contract AidCoinIco is Ownable, Crowdsale {
364     using SafeMath for uint256;
365 
366     mapping (address => uint256) public whitelist;
367     mapping (address => uint256) public boughtTokens;
368 
369     mapping (address => uint256) public claimedAirdropTokens;
370 
371     // max tokens cap
372     uint256 public tokenCap = 12000000 * (10 ** 18);
373 
374     // with whitelist
375     uint256 public maxWithWhitelist = 8000000 * (10 ** 18);
376     uint256 public boughtWithWhitelist = 0;
377 
378     // without whitelist
379     uint256 public maxWithoutWhitelist = 4000000 * (10 ** 18);
380     uint256 public maxWithoutWhitelistPerUser = 5 * 2000 * (10 ** 18); //5 * 2000 (rate)
381     uint256 public boughtWithoutWhitelist = 0;
382 
383     // amount of sold tokens
384     uint256 public soldTokens;
385 
386     function AidCoinIco(
387         uint256 _startTime,
388         uint256 _endTime,
389         uint256 _rate,
390         address _wallet,
391         address _token
392     ) public
393     Crowdsale (_startTime, _endTime, _rate, _wallet)
394     {
395         require(_token != 0x0);
396         token = AidCoin(_token);
397     }
398 
399     /**
400      * @dev Set the ico token contract
401      */
402     function createTokenContract() internal returns (MintableToken) {
403         return AidCoin(0x0);
404     }
405 
406     // low level token purchase function
407     function buyTokens(address beneficiary) public payable {
408         require(beneficiary != 0x0);
409         require(validPurchase());
410 
411         // get wei amount
412         uint256 weiAmount = msg.value;
413 
414         // calculate token amount to be transferred
415         uint256 tokens = weiAmount.mul(rate);
416 
417         // check if amount is less than allowed limits
418         checkValidAmount(beneficiary, tokens);
419 
420         // calculate new total sold
421         uint256 newTotalSold = soldTokens.add(tokens);
422 
423         // check if we are over the max token cap
424         require(newTotalSold <= tokenCap);
425 
426         // update states
427         weiRaised = weiRaised.add(weiAmount);
428         soldTokens = newTotalSold;
429 
430         // mint tokens to beneficiary
431         token.mint(beneficiary, tokens);
432         TokenPurchase(
433             msg.sender,
434             beneficiary,
435             weiAmount,
436             tokens
437         );
438 
439         forwardFunds();
440     }
441 
442     function updateEndDate(uint256 _endTime) public onlyOwner {
443         require(_endTime > now);
444         require(_endTime > startTime);
445 
446         endTime = _endTime;
447     }
448 
449     function closeTokenSale() public onlyOwner {
450         require(hasEnded());
451 
452         // transfer token ownership to ico owner
453         token.transferOwnership(owner);
454     }
455 
456     function changeParticipationLimits(uint256 newMaxWithWhitelist, uint256 newMaxWithoutWhitelist) public onlyOwner {
457         newMaxWithWhitelist = newMaxWithWhitelist * (10 ** 18);
458         newMaxWithoutWhitelist = newMaxWithoutWhitelist * (10 ** 18);
459         uint256 totalCap = newMaxWithWhitelist.add(newMaxWithoutWhitelist);
460 
461         require(totalCap == tokenCap);
462         require(newMaxWithWhitelist >= boughtWithWhitelist);
463         require(newMaxWithoutWhitelist >= boughtWithoutWhitelist);
464 
465         maxWithWhitelist = newMaxWithWhitelist;
466         maxWithoutWhitelist = newMaxWithoutWhitelist;
467     }
468 
469     function changeWhitelistStatus(address[] users, uint256[] amount) public onlyOwner {
470         require(users.length > 0);
471 
472         uint len = users.length;
473         for (uint i = 0; i < len; i++) {
474             address user = users[i];
475             uint256 newAmount = amount[i] * (10 ** 18);
476             whitelist[user] = newAmount;
477         }
478     }
479 
480     function checkValidAmount(address beneficiary, uint256 tokens) internal {
481         bool isWhitelist = false;
482         uint256 limit = maxWithoutWhitelistPerUser;
483 
484         // check if user is whitelisted
485         if (whitelist[beneficiary] > 0) {
486             isWhitelist = true;
487             limit = whitelist[beneficiary];
488         }
489 
490         // check the previous amount of tokes owned during ICO
491         uint256 ownedTokens = boughtTokens[beneficiary];
492 
493         // calculate new total owned by beneficiary
494         uint256 newOwnedTokens = ownedTokens.add(tokens);
495 
496         // check if we are over the max per user
497         require(newOwnedTokens <= limit);
498 
499         if (!isWhitelist) {
500             // calculate new total sold
501             uint256 newBoughtWithoutWhitelist = boughtWithoutWhitelist.add(tokens);
502 
503             // check if we are over the max token cap
504             require(newBoughtWithoutWhitelist <= maxWithoutWhitelist);
505 
506             // update states
507             boughtWithoutWhitelist = newBoughtWithoutWhitelist;
508         } else {
509             // calculate new total sold
510             uint256 newBoughtWithWhitelist = boughtWithWhitelist.add(tokens);
511 
512             // check if we are over the max token cap
513             require(newBoughtWithWhitelist <= maxWithWhitelist);
514 
515             // update states
516             boughtWithWhitelist = newBoughtWithWhitelist;
517         }
518 
519         boughtTokens[beneficiary] = boughtTokens[beneficiary].add(tokens);
520     }
521 
522     function airdrop(address[] users, uint256[] amounts) public onlyOwner {
523         require(users.length > 0);
524         require(amounts.length > 0);
525         require(users.length == amounts.length);
526 
527         uint256 oldRate = 1200;
528         uint256 newRate = 2400;
529 
530         uint len = users.length;
531         for (uint i = 0; i < len; i++) {
532             address to = users[i];
533             uint256 value = amounts[i];
534 
535             uint256 oldTokens = value.mul(oldRate);
536             uint256 newTokens = value.mul(newRate);
537 
538             uint256 tokensToAirdrop = newTokens.sub(oldTokens);
539 
540             if (claimedAirdropTokens[to] == 0) {
541                 claimedAirdropTokens[to] = tokensToAirdrop;
542                 token.mint(to, tokensToAirdrop);
543             }
544         }
545     }
546 
547     // overriding Crowdsale#hasEnded to add tokenCap logic
548     // @return true if crowdsale event has ended or cap is reached
549     function hasEnded() public constant returns (bool) {
550         bool capReached = soldTokens >= tokenCap;
551         return super.hasEnded() || capReached;
552     }
553 
554     // @return true if crowdsale event has started
555     function hasStarted() public constant returns (bool) {
556         return now >= startTime && now < endTime;
557     }
558 }