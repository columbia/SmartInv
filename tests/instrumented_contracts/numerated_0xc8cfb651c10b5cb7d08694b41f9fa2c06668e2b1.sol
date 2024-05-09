1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5 
6   function balanceOf(address _who) public view returns (uint256);
7 
8   function allowance(address _owner, address _spender)
9     public view returns (uint256);
10 
11   function transfer(address _to, uint256 _value) public returns (bool);
12 
13   function approve(address _spender, uint256 _value)
14     public returns (bool);
15 
16   function transferFrom(address _from, address _to, uint256 _value)
17     public returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 contract Ownable {
33 
34   // Owner's address
35   address public owner;
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address _newOwner) public onlyOwner {
58     require(_newOwner != address(0));
59     emit OwnerChanged(owner, _newOwner);
60     owner = _newOwner;
61   }
62 
63   event OwnerChanged(address indexed previousOwner,address indexed newOwner);
64 
65 }
66 
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
73     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
74     // benefit is lost if 'b' is also tested.
75     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76     if (_a == 0) {
77       return 0;
78     }
79 
80     c = _a * _b;
81     assert(c / _a == _b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
89     // assert(_b > 0); // Solidity automatically throws when dividing by 0
90     // uint256 c = _a / _b;
91     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
92     return _a / _b;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
99     assert(_b <= _a);
100     return _a - _b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
107     c = _a + _b;
108     assert(c >= _a);
109     return c;
110   }
111 }
112 
113 contract Stoppable is Ownable {
114     
115     // Indicates if crowdsale is stopped
116     bool public stopped = false;
117 
118     // Indicates if ELP or ETH withdrawal is enabled
119     bool public withdrawalEnabled = false;
120 
121     /**
122     * @dev Modifier to make a function callable only when the contract is stopped.
123     */
124     modifier whenStopped() {
125         require(stopped);
126         _;
127     }
128 
129     /**
130     * @dev Modifier to make a function callable only when the contract is not stopped.
131     */
132     modifier whenNotStopped() {
133         require(!stopped);
134         _;
135     }
136 
137     modifier whenWithdrawalEnabled() {
138         require(withdrawalEnabled);
139         _;
140     }
141 
142     modifier whenWithdrawalDisabled() {
143         require(!withdrawalEnabled);
144         _;
145     }
146 
147     /**
148     * @dev called by the owner to stop, triggers stopped state
149     */
150     function stop() public onlyOwner whenNotStopped {
151         stopped = true;
152         emit Stopped(owner);
153     }
154 
155     /**
156     * @dev called by the owner to restart, triggers restarted state
157     */
158     function restart() public onlyOwner whenStopped {
159         stopped = false;
160         withdrawalEnabled = false;
161         emit Restarted(owner);
162     }
163 
164     /** 
165     * @dev enables withdrawals, only callable by the owner when the withdrawals are disabled
166     * @notice enables withdrawals, only callable by the owner when the withdrawals are disabled
167     */
168     function enableWithdrawal() public onlyOwner whenStopped whenWithdrawalDisabled {
169         withdrawalEnabled = true;
170         emit WithdrawalEnabled(owner);
171     }
172 
173     /** 
174     * @dev disables withdrawals, only callable by the owner when the withdrawals are enabled
175     * @notice disables withdrawals, only callable by the owner when the withdrawals are enabled
176     */
177     function disableWithdrawal() public onlyOwner whenWithdrawalEnabled {
178         withdrawalEnabled = false;
179         emit WithdrawalDisabled(owner);
180     }
181 
182     /** 
183     * Event for logging contract stopping
184     * @param owner who owns the contract
185     */
186     event Stopped(address owner);
187     
188     /** 
189     * Event for logging contract restarting
190     * @param owner who owns the contract
191     */
192     event Restarted(address owner);
193 
194     /** 
195     * Event for logging enabling withdrawals
196     * @param owner who owns the contract
197     */
198     event WithdrawalEnabled(address owner);
199     
200     /** 
201     * Event for logging disabling withdrawals
202     * @param owner who owns the contract
203     */
204     event WithdrawalDisabled(address owner);
205 }
206 
207 contract Whitelist {
208 
209     // who can whitelist
210     address public whitelister;
211 
212     // Whitelist mapping
213     mapping (address => bool) whitelist;
214 
215     /**
216       * @dev The Whitelist constructor sets the original `whitelister` of the contract to the sender
217       * account.
218       */
219     constructor() public {
220         whitelister = msg.sender;
221     }
222 
223     /**
224       * @dev Throws if called by any account other than the whitelister.
225       */
226     modifier onlyWhitelister() {
227         require(msg.sender == whitelister);
228         _;
229     }
230 
231     /** 
232     * @dev Only callable by the whitelister. Whitelists the specified address.
233     * @notice Only callable by the whitelister. Whitelists the specified address.
234     * @param _address Address to be whitelisted. 
235     */
236     function addToWhitelist(address _address) public onlyWhitelister {
237         require(_address != address(0));
238         emit WhitelistAdd(whitelister, _address);
239         whitelist[_address] = true;
240     }
241     
242     /** 
243     * @dev Only callable by the whitelister. Removes the specified address from whitelist.
244     * @notice Only callable by the whitelister. Removes the specified address from whitelist.
245     * @param _address Address to be removed from whitelist. 
246     */
247     function removeFromWhitelist(address _address) public onlyWhitelister {
248         require(_address != address(0));
249         emit WhitelistRemove(whitelister, _address);
250         whitelist[_address] = false;
251     }
252 
253     /**
254     * @dev Checks if the specified address is whitelisted.
255     * @notice Checks if the specified address is whitelisted. 
256     * @param _address Address to be whitelisted.
257     */
258     function isWhitelisted(address _address) public view returns (bool) {
259         return whitelist[_address];
260     }
261 
262     /**
263       * @dev Changes the current whitelister. Callable only by the whitelister.
264       * @notice Changes the current whitelister. Callable only by the whitelister.
265       * @param _newWhitelister Address of new whitelister.
266       */
267     function changeWhitelister(address _newWhitelister) public onlyWhitelister {
268         require(_newWhitelister != address(0));
269         emit WhitelisterChanged(whitelister, _newWhitelister);
270         whitelister = _newWhitelister;
271     }
272 
273     /** 
274     * Event for logging the whitelister change. 
275     * @param previousWhitelister Old whitelister.
276     * @param newWhitelister New whitelister.
277     */
278     event WhitelisterChanged(address indexed previousWhitelister, address indexed newWhitelister);
279     
280     /** 
281     * Event for logging when the user is whitelisted.
282     * @param whitelister Current whitelister.
283     * @param whitelistedAddress User added to whitelist.
284     */
285     event WhitelistAdd(address indexed whitelister, address indexed whitelistedAddress);
286     /** 
287     * Event for logging when the user is removed from the whitelist.
288     * @param whitelister Current whitelister.
289     * @param whitelistedAddress User removed from whitelist.
290     */
291     event WhitelistRemove(address indexed whitelister, address indexed whitelistedAddress); 
292 }
293 
294 contract ElpisCrowdsale is Stoppable, Whitelist {
295     using SafeMath for uint256;
296 
297     // The token being sold
298     ERC20 public token;
299 
300     // Wallet for contributions
301     address public wallet;
302 
303     // Cumulative wei contributions per address
304     mapping (address => uint256) public ethBalances;
305 
306     // Cumulative ELP allocations per address
307     mapping (address => uint256) public elpBalances;
308 
309     // USD/ETH rate
310     uint256 public rate;
311 
312     // Maximum wei contribution for non-whitelisted addresses
313     uint256 public threshold;
314 
315     // Amount of wei raised
316     uint256 public weiRaised;
317 
318     // Amount of USD raised
319     uint256 public usdRaised;
320 
321     // Amount of tokens sold so far
322     uint256 public tokensSold;
323 
324     // Maximum amount of ELP tokens to be sold
325     uint256 public cap;
326 
327     // Block on which crowdsale is deployed
328     uint256 public deploymentBlock;
329 
330     // Amount of ELP tokens sold per phase
331     uint256 public constant AMOUNT_PER_PHASE = 14500000 ether;
332 
333     /**
334     * @param _rate USD/ETH rate
335     * @param _threshold Maximum wei contribution for non-whitelisted addresses
336     * @param _token Address of the token being sold
337     * @param _wallet Address of the wallet for contributions
338     */
339     constructor(uint256 _rate, uint256 _threshold, uint256 _cap, ERC20 _token, address _wallet) public {
340         require(_rate > 0);
341         require(_threshold > 0);
342         require(_cap > 0);
343         require(_token != address(0));
344         require(_wallet != address(0));
345 
346         rate = _rate;
347         threshold = _threshold;
348         cap = _cap;
349         token = _token;
350         wallet = _wallet;
351         deploymentBlock = block.number;
352     }
353 
354     /**
355     * @dev Sets the USD/ETH rate
356     * @param _rate USD/ETH rate
357     */
358     function setRate(uint256 _rate) public onlyOwner {
359         emit RateChanged(owner, rate, _rate);
360         rate = _rate;
361     }
362 
363     /**
364     * @dev Sets the threshold
365     * @param _threshold Maximum wei contribution for non-whitelisted addresses
366     */
367     function setThreshold(uint256 _threshold) public onlyOwner {
368         emit ThresholdChanged(owner, threshold, _threshold);
369         threshold = _threshold;
370     }
371 
372     /**
373     * @dev fallback function ***DO NOT OVERRIDE***
374     */
375     function () external payable {
376         buyTokens(msg.sender);
377     }
378 
379     /**
380     * @dev low level token purchase ***DO NOT OVERRIDE***
381     * @param _beneficiary Address performing the token purchase
382     */
383     function buyTokens(address _beneficiary) public payable whenNotStopped {
384         uint256 weiAmount = msg.value;
385         require(_beneficiary != address(0));
386         require(weiAmount != 0);
387         weiRaised = weiRaised.add(weiAmount);
388         require(weiRaised <= cap);
389 
390         uint256 dollars = _getUsdAmount(weiAmount);
391         uint256 tokens = _getTokenAmount(dollars);
392 
393         // update state & statistics
394         uint256 previousEthBalance = ethBalances[_beneficiary];
395         ethBalances[_beneficiary] = ethBalances[_beneficiary].add(weiAmount);
396         elpBalances[_beneficiary] = elpBalances[_beneficiary].add(tokens);
397         tokensSold = tokensSold.add(tokens);
398         usdRaised = usdRaised.add(dollars);
399 
400         if (ethBalances[_beneficiary] > threshold) {
401             whitelist[_beneficiary] = false;
402             // Transfer difference (up to threshold) to wallet
403             // if previous balance is lower than threshold
404             if (previousEthBalance < threshold)
405                 wallet.transfer(threshold - previousEthBalance);
406             emit NeedKyc(_beneficiary, weiAmount, ethBalances[_beneficiary]);
407         } else {
408             whitelist[_beneficiary] = true;
409             // When cumulative contributions for address are lower
410             // than threshold, transfer whole contribution to wallet
411             wallet.transfer(weiAmount);
412             emit Contribution(_beneficiary, weiAmount, ethBalances[_beneficiary]);
413         }
414 
415         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
416     }
417 
418     /**
419     * @notice Withdraws the tokens. For whitelisted contributors it withdraws ELP tokens.
420     * For non-whitelisted contributors it withdraws the threshold amount of ELP tokens,
421     * everything above the threshold amount is transfered back to contributor as ETH.
422     */
423     function withdraw() external whenWithdrawalEnabled {
424         uint256 ethBalance = ethBalances[msg.sender];
425         require(ethBalance > 0);
426         uint256 elpBalance = elpBalances[msg.sender];
427 
428         // reentrancy protection
429         elpBalances[msg.sender] = 0;
430         ethBalances[msg.sender] = 0;
431 
432         if (isWhitelisted(msg.sender)) {
433             // Transfer all ELP tokens to contributor
434             token.transfer(msg.sender, elpBalance);
435         } else {
436             // Transfer threshold equivalent ELP amount based on average price
437             token.transfer(msg.sender, elpBalance.mul(threshold).div(ethBalance));
438 
439             if (ethBalance > threshold) {
440                 // Excess amount (over threshold) of contributed ETH is
441                 // transferred back to non-whitelisted contributor
442                 msg.sender.transfer(ethBalance - threshold);
443             }
444         }
445         emit Withdrawal(msg.sender, ethBalance, elpBalance);
446     }
447 
448     /**
449     * @dev This method can be used by the owner to extract mistakenly sent tokens
450     * or Ether sent to this contract.
451     * @param _token address The address of the token contract that you want to
452     * recover set to 0 in case you want to extract ether. It can't be ElpisToken.
453     */
454     function claimTokens(address _token) public onlyOwner {
455         require(_token != address(token));
456         if (_token == address(0)) {
457             owner.transfer(address(this).balance);
458             return;
459         }
460 
461         ERC20 tokenReference = ERC20(_token);
462         uint balance = tokenReference.balanceOf(address(this));
463         token.transfer(owner, balance);
464         emit ClaimedTokens(_token, owner, balance);
465     }
466 
467     /**
468     * @dev Checks how much of ELP tokens one can get for the specified USD amount.
469     * @param _usdAmount Specified USD amount.
470     * @return Returns how much ELP tokens you can currently get for the specified USD amount.
471     */
472     function _getTokenAmount(uint256 _usdAmount) internal view returns (uint256) {
473         uint256 phase = getPhase();
474         uint256 initialPriceNumerator = 110;
475         uint256 initialPriceDenominator = 1000;
476 
477         uint256 scaleNumerator = 104 ** phase;
478         uint256 scaleDenominator = 100 ** phase;
479 
480         return _usdAmount.mul(initialPriceNumerator).mul(scaleNumerator).div(initialPriceDenominator).div(scaleDenominator);
481     }
482 
483     /**
484     * @dev Gets the USD amount for specified wei amount
485     * @param _weiAmount Specified wei amount
486     * @return Returns USD amount based on wei amount
487     */
488     function _getUsdAmount(uint256 _weiAmount) internal view returns (uint256) {
489         return _weiAmount.mul(rate);
490     }
491 
492     /**
493     * @notice Gets the current phase of crowdsale.
494     * Tokens have different price during each phase.
495     * @return Returns the current crowdsale phase.
496     */
497     function getPhase() public view returns (uint256) {
498         return tokensSold / AMOUNT_PER_PHASE;
499     }
500 
501     /**
502     * Event for token purchase logging
503     * @param purchaser who paid for the tokens
504     * @param beneficiary who got the tokens
505     * @param value weis paid for purchase
506     * @param amount amount of tokens purchased
507     */
508     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
509 
510     /**
511     * Event for rate change logging
512     * @param owner who owns the contract
513     * @param oldValue old USD/ETH rate
514     * @param newValue new USD/ETH rate
515     */
516     event RateChanged(address indexed owner, uint256 oldValue, uint256 newValue);
517 
518     /**
519     * Event for rate change logging
520     * @param owner who owns the contract
521     * @param oldValue old maximum wei contribution for non-whitelisted addresses value
522     * @param newValue new maximum wei contribution for non-whitelisted addresses value
523     */
524     event ThresholdChanged(address indexed owner, uint256 oldValue, uint256 newValue);
525 
526     /**
527     * @param beneficiary who is the recipient of tokens from the contribution
528     * @param contributionAmount Amount of ETH contributor has contributed
529     * @param totalAmount Total amount of ETH contributor has contributed
530     */
531     event Contribution(address indexed beneficiary, uint256 contributionAmount, uint256 totalAmount);
532 
533     /**
534     * @param beneficiary who is the recipient of tokens from the contribution
535     * @param contributionAmount Amount of ETH contributor has contributed
536     * @param totalAmount Total amount of ETH contributor has contributed
537     */
538     event NeedKyc(address indexed beneficiary, uint256 contributionAmount, uint256 totalAmount);
539 
540     /**
541     * @param beneficiary who is the recipient of tokens from the contribution
542     * @param ethBalance ETH balance of the recipient of tokens from the contribution
543     * @param elpBalance ELP balance of the recipient of tokens from the contribution
544     */
545     event Withdrawal(address indexed beneficiary, uint256 ethBalance, uint256 elpBalance);
546 
547     /**
548     * @param token claimed token
549     * @param owner who owns the contract
550     * @param amount amount of the claimed token
551     */
552     event ClaimedTokens(address indexed token, address indexed owner, uint256 amount);
553 }