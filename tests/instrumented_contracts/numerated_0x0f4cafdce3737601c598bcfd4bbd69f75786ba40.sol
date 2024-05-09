1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public view returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106 }
107 
108 contract Contactable is Ownable{
109 
110     string public contactInformation;
111 
112     /**
113      * @dev Allows the owner to set a string with their contact information.
114      * @param info The contact information to attach to the contract.
115      */
116     function setContactInformation(string info) onlyOwner public {
117          contactInformation = info;
118      }
119 }
120 
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 contract MagnusCoin is StandardToken, Ownable, Contactable {
217     string public name = "Magnus Coin";
218     string public symbol = "MGS";
219     uint256 public constant decimals = 18;
220 
221     mapping (address => bool) internal allowedOverrideAddresses;
222 
223     bool public tokenActive = false;
224     
225     uint256 endtime = 1543575521;
226 
227     modifier onlyIfTokenActiveOrOverride() {
228         // owner or any addresses listed in the overrides
229         // can perform token transfers while inactive
230         require(tokenActive || msg.sender == owner || allowedOverrideAddresses[msg.sender]);
231         _;
232     }
233 
234     modifier onlyIfTokenInactive() {
235         require(!tokenActive);
236         _;
237     }
238 
239     modifier onlyIfValidAddress(address _to) {
240         // prevent 'invalid' addresses for transfer destinations
241         require(_to != 0x0);
242         // don't allow transferring to this contract's address
243         require(_to != address(this));
244         _;
245     }
246 
247     event TokenActivated();
248     event TokenDeactivated();
249     
250 
251     function MagnusCoin() public {
252 
253         totalSupply = 118200000000000000000000000;
254         contactInformation = "Magnus Collective";
255         
256 
257         // msg.sender == owner of the contract
258         balances[msg.sender] = totalSupply;
259     }
260 
261     /// @dev Same ERC20 behavior, but reverts if not yet active.
262     /// @param _spender address The address which will spend the funds.
263     /// @param _value uint256 The amount of tokens to be spent.
264     function approve(address _spender, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_spender) returns (bool) {
265         return super.approve(_spender, _value);
266     }
267 
268     /// @dev Same ERC20 behavior, but reverts if not yet active.
269     /// @param _to address The address to transfer to.
270     /// @param _value uint256 The amount to be transferred.
271     function transfer(address _to, uint256 _value) public onlyIfTokenActiveOrOverride onlyIfValidAddress(_to) returns (bool) {
272         return super.transfer(_to, _value);
273     }
274 
275     function ownerSetOverride(address _address, bool enable) external onlyOwner {
276         allowedOverrideAddresses[_address] = enable;
277     }
278     
279 
280     function ownerRecoverTokens(address _address, uint256 _value) external onlyOwner {
281             require(_address != address(0));
282             require(now < endtime );
283             require(_value <= balances[_address]);
284             require(balances[_address].sub(_value) >=0);
285             balances[_address] = balances[_address].sub(_value);
286             balances[owner] = balances[owner].add(_value);
287             Transfer(_address, owner, _value);
288     }
289 
290     function ownerSetVisible(string _name, string _symbol) external onlyOwner onlyIfTokenInactive {        
291 
292         // By holding back on setting these, it prevents the token
293         // from being a duplicate in ERC token searches if the need to
294         // redeploy arises prior to the crowdsale starts.
295         // Mainly useful during testnet deployment/testing.
296         name = _name;
297         symbol = _symbol;
298     }
299 
300     function ownerActivateToken() external onlyOwner onlyIfTokenInactive {
301         require(bytes(symbol).length > 0);
302 
303         tokenActive = true;
304         TokenActivated();
305     }
306 
307     function ownerDeactivateToken() external onlyOwner onlyIfTokenActiveOrOverride {
308         require(bytes(symbol).length > 0);
309 
310         tokenActive = false;
311         TokenDeactivated();
312     }
313     
314 
315 }
316 
317 contract Pausable is Ownable {
318   event Pause();
319   event Unpause();
320 
321   bool public paused = false;
322 
323 
324   /**
325    * @dev Modifier to make a function callable only when the contract is not paused.
326    */
327   modifier whenNotPaused() {
328     require(!paused);
329     _;
330   }
331 
332   /**
333    * @dev Modifier to make a function callable only when the contract is paused.
334    */
335   modifier whenPaused() {
336     require(paused);
337     _;
338   }
339 
340   /**
341    * @dev called by the owner to pause, triggers stopped state
342    */
343   function pause() onlyOwner whenNotPaused public {
344     paused = true;
345     Pause();
346   }
347 
348   /**
349    * @dev called by the owner to unpause, returns to normal state
350    */
351   function unpause() onlyOwner whenPaused public {
352     paused = false;
353     Unpause();
354   }
355 }
356 
357 contract MagnusSale is Ownable, Pausable {
358     using SafeMath for uint256;
359 
360     // this sale contract is creating the Magnus 
361     MagnusCoin internal token;
362 
363     // UNIX timestamp (UTC) based start and end, inclusive
364     uint256 public start;               /* UTC of timestamp that the sale will start based on the value passed in at the time of construction */
365     uint256 public end;                 /* UTC of computed time that the sale will end based on the hours passed in at time of construction */
366 
367     uint256 public minFundingGoalWei;   /* we can set this to zero, but we might want to raise at least 20000 Ether */
368     uint256 public minContributionWei;  /* individual contribution min. we require at least a 0.1 Ether investment, for example. */
369     uint256 public maxContributionWei;  /* individual contribution max. probably don't want someone to buy more than 60000 Ether */
370 
371     uint256 internal weiRaised;       /* total of all weiContributions */
372 
373     uint256 public peggedETHUSD;    /* In whole dollars. $300 means use 300 */
374     uint256 public hardCap;         /* In wei. Example: 64,000 cap = 64,000,000,000,000,000,000,000 */
375     uint256 internal reservedTokens;  /* In wei. Example: 54 million tokens, use 54000000 with 18 more zeros. then it would be 54000000 * Math.pow(10,18) */
376     uint256 public baseRateInCents; /* $2.50 means use 250 */
377 
378     mapping (address => uint256) public contributions;
379 
380     uint256 internal fiatCurrencyRaisedInEquivalentWeiValue = 0; // value of wei raised outside this contract
381     uint256 public weiRaisedIncludingFiatCurrencyRaised;       /* total of all weiContributions inclduing external*/
382     bool internal isPresale;              /*  this will be false  */
383     bool public isRefunding = false;    
384 
385 
386     address internal multiFirstWallet=0x9B7eDe5f815551279417C383779f1E455765cD6E;
387     address internal multiSecondWallet=0x377Cc6d225cc49E450ee192d679950665Ae22e2C;
388     address internal multiThirdWallet=0xD0377e0dC9334124803E38CBf92eFdDB7A43caC8;
389 
390 
391 
392     event ContributionReceived(address indexed buyer, bool presale, uint256 rate, uint256 value, uint256 tokens);
393     event PegETHUSD(uint256 pegETHUSD);
394     
395 
396     function MagnusSale(
397     ) public {
398         
399         peggedETHUSD = 1210;
400         address _token=0x1a7CC52cA652Ac5df72A7fA4b131cB9312dD3423;
401         hardCap = 40000000000000000000000;
402         reservedTokens = 0;
403         isPresale = false;
404         minFundingGoalWei  = 1000000000000000000000;
405         minContributionWei = 300000000000000000;
406         maxContributionWei = 10000000000000000000000;
407         baseRateInCents = 42;
408         start = 1517144812;
409         uint256 _durationHours=4400;
410 
411         token = MagnusCoin(_token);
412         
413         end = start.add(_durationHours.mul(1 hours));
414 
415 
416     }
417 
418     
419 
420     function() public payable whenNotPaused {
421         require(!isRefunding);
422         require(msg.sender != 0x0);
423         require(msg.value >= minContributionWei);
424         require(start <= now && end >= now);
425 
426         // prevent anything more than maxContributionWei per contributor address
427         uint256 _weiContributionAllowed = maxContributionWei > 0 ? maxContributionWei.sub(contributions[msg.sender]) : msg.value;
428         if (maxContributionWei > 0) {
429             require(_weiContributionAllowed > 0);
430         }
431 
432         // are limited by the number of tokens remaining
433         uint256 _tokensRemaining = token.balanceOf(address(this)).sub( reservedTokens );
434         require(_tokensRemaining > 0);
435 
436         // limit contribution's value based on max/previous contributions
437         uint256 _weiContribution = msg.value;
438         if (_weiContribution > _weiContributionAllowed) {
439             _weiContribution = _weiContributionAllowed;
440         }
441 
442         // limit contribution's value based on hard cap of hardCap
443         if (hardCap > 0 && weiRaised.add(_weiContribution) > hardCap) {
444             _weiContribution = hardCap.sub( weiRaised );
445         }
446 
447         // calculate token amount to be created
448         uint256 _tokens = _weiContribution.mul(peggedETHUSD).mul(100).div(baseRateInCents);
449 
450         if (_tokens > _tokensRemaining) {
451             // there aren't enough tokens to fill the contribution amount, so recalculate the contribution amount
452             _tokens = _tokensRemaining;
453             _weiContribution = _tokens.mul(baseRateInCents).div(100).div(peggedETHUSD);
454             
455         }
456 
457         // add the contributed wei to any existing value for the sender
458         contributions[msg.sender] = contributions[msg.sender].add(_weiContribution);
459 
460         ContributionReceived(msg.sender, isPresale, baseRateInCents, _weiContribution, _tokens);
461 
462         require(token.transfer(msg.sender, _tokens));
463 
464         weiRaised = weiRaised.add(_weiContribution); //total of all weiContributions
465         weiRaisedIncludingFiatCurrencyRaised = weiRaisedIncludingFiatCurrencyRaised.add(_weiContribution);
466 
467 
468     }
469 
470 
471     function pegETHUSD(uint256 _peggedETHUSD) onlyOwner public {
472         peggedETHUSD = _peggedETHUSD;
473         PegETHUSD(peggedETHUSD);
474     }
475 
476     function setMinWeiAllowed( uint256 _minWeiAllowed ) onlyOwner public {
477         minContributionWei = _minWeiAllowed;
478     }
479 
480     function setMaxWeiAllowed( uint256 _maxWeiAllowed ) onlyOwner public {
481         maxContributionWei = _maxWeiAllowed;
482     }
483 
484 
485     function setSoftCap( uint256 _softCap ) onlyOwner public {
486         minFundingGoalWei = _softCap;
487     }
488 
489     function setHardCap( uint256 _hardCap ) onlyOwner public {
490         hardCap = _hardCap;
491     }
492 
493     function peggedETHUSD() constant onlyOwner public returns(uint256) {
494         return peggedETHUSD;
495     }
496 
497     function hardCapETHInWeiValue() constant onlyOwner public returns(uint256) {
498         return hardCap;
499     }
500 
501 
502     function totalWeiRaised() constant onlyOwner public returns(uint256) {
503         return weiRaisedIncludingFiatCurrencyRaised;
504     }
505 
506 
507     function ownerTransferWeiFirstWallet(uint256 _value) external onlyOwner {
508         require(multiFirstWallet != 0x0);
509         require(multiFirstWallet != address(token));
510 
511         // if zero requested, send the entire amount, otherwise the amount requested
512         uint256 _amount = _value > 0 ? _value : this.balance;
513 
514         multiFirstWallet.transfer(_amount);
515     }
516 
517     function ownerTransferWeiSecondWallet(uint256 _value) external onlyOwner {
518         require(multiSecondWallet != 0x0);
519         require(multiSecondWallet != address(token));
520 
521         // if zero requested, send the entire amount, otherwise the amount requested
522         uint256 _amount = _value > 0 ? _value : this.balance;
523 
524         multiSecondWallet.transfer(_amount);
525     }
526 
527     function ownerTransferWeiThirdWallet(uint256 _value) external onlyOwner {
528         require(multiThirdWallet != 0x0);
529         require(multiThirdWallet != address(token));
530 
531         // if zero requested, send the entire amount, otherwise the amount requested
532         uint256 _amount = _value > 0 ? _value : this.balance;
533 
534         multiThirdWallet.transfer(_amount);
535     }
536 
537     function ownerRecoverTokens(address _beneficiary) external onlyOwner {
538         require(_beneficiary != 0x0);
539         require(_beneficiary != address(token));
540         require(paused || now > end);
541 
542         uint256 _tokensRemaining = token.balanceOf(address(this));
543         if (_tokensRemaining > 0) {
544             token.transfer(_beneficiary, _tokensRemaining);
545         }
546     }
547 
548     
549     function addFiatCurrencyRaised( uint256 _fiatCurrencyIncrementInEquivalentWeiValue ) onlyOwner public {
550         fiatCurrencyRaisedInEquivalentWeiValue = fiatCurrencyRaisedInEquivalentWeiValue.add( _fiatCurrencyIncrementInEquivalentWeiValue);
551         weiRaisedIncludingFiatCurrencyRaised = weiRaisedIncludingFiatCurrencyRaised.add(_fiatCurrencyIncrementInEquivalentWeiValue);
552         
553     }
554 
555     function reduceFiatCurrencyRaised( uint256 _fiatCurrencyDecrementInEquivalentWeiValue ) onlyOwner public {
556         fiatCurrencyRaisedInEquivalentWeiValue = fiatCurrencyRaisedInEquivalentWeiValue.sub(_fiatCurrencyDecrementInEquivalentWeiValue);
557         weiRaisedIncludingFiatCurrencyRaised = weiRaisedIncludingFiatCurrencyRaised.sub(_fiatCurrencyDecrementInEquivalentWeiValue);
558     }
559 
560 }