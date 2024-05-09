1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   function Ownable() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) onlyOwner public {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 }
60 
61 contract ERC20Basic {
62   uint256 public totalSupply;
63   function balanceOf(address who) public constant returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[msg.sender]);
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender) public constant returns (uint256);
102   function transferFrom(address from, address to, uint256 value) public returns (bool);
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * approve should be called when allowed[_spender] == 0. To increment
158    * allowed value is better to use this function to avoid 2 calls (and wait until
159    * the first transaction is mined)
160    * From MonolithDAO Token.sol
161    */
162   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
163     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
169     uint oldValue = allowed[msg.sender][_spender];
170     if (_subtractedValue > oldValue) {
171       allowed[msg.sender][_spender] = 0;
172     } else {
173       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174     }
175     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176     return true;
177   }
178 
179 }
180 
181 contract MintableToken is StandardToken, Ownable {
182   event Mint(address indexed to, uint256 amount);
183   event MintFinished();
184 
185   bool public mintingFinished = false;
186 
187 
188   modifier canMint() {
189     require(!mintingFinished);
190     _;
191   }
192 
193   /**
194    * @dev Function to mint tokens
195    * @param _to The address that will receive the minted tokens.
196    * @param _amount The amount of tokens to mint.
197    * @return A boolean that indicates if the operation was successful.
198    */
199   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
200     totalSupply = totalSupply.add(_amount);
201     balances[_to] = balances[_to].add(_amount);
202     Mint(_to, _amount);
203     Transfer(0x0, _to, _amount);
204     return true;
205   }
206 
207   /**
208    * @dev Function to stop minting new tokens.
209    * @return True if the operation was successful.
210    */
211   function finishMinting() onlyOwner public returns (bool) {
212     mintingFinished = true;
213     MintFinished();
214     return true;
215   }
216 }
217 
218 contract FundCruToken is MintableToken {
219   // token identity
220   string public constant name = "FundCru";
221   string public constant symbol = "FUND";
222   uint256 public constant decimals = 18;
223   bytes4 public constant magic = 0x46554E44;    // "FUND"
224 
225   // whether token transfering will be blocked during crowdsale timeframe
226   bool public blockTransfering;
227 
228   function FundCruToken(bool _blockTransfering) public {
229     blockTransfering = _blockTransfering;
230   }
231 
232   function blockTransfer() onlyOwner public {
233     require(!blockTransfering);
234     blockTransfering = true;
235   }
236 
237   function unblockTransfer() onlyOwner public {
238     require(blockTransfering);
239     blockTransfering = false;
240   }
241 
242   function transfer(address _to, uint256 _value) public returns (bool) {
243     require(!blockTransfering);
244     return super.transfer(_to, _value);
245   }
246 
247   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
248     require(!blockTransfering);
249     return super.transferFrom(_from, _to, _value);
250   }
251 
252   function approve(address _spender, uint256 _value) public returns (bool) {
253     require(!blockTransfering);
254     return super.approve(_spender, _value);
255   }
256 
257   function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
258     require(!blockTransfering);
259     return super.increaseApproval(_spender, _addedValue);
260   }
261 
262   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
263     require(!blockTransfering);
264     return super.decreaseApproval(_spender, _subtractedValue);
265   }
266 }
267 
268 contract FundCruCrowdsale is Ownable {
269   using SafeMath for uint256;
270 
271   // the token being sold
272   FundCruToken public fundcruToken;
273 
274   // address where funds/ethers are collected
275   address public crowdsaleOwner;
276 
277   // lock-up time of FUND tokens that belongs to Fundcru
278   uint256 public fundcruVaultLockTime;
279 
280   // better trust our data, block timestamp can be malicious
281   bool public crowdsaleActive = false;
282 
283   // duration of the crowdsale, in seconds
284   uint256 public duration;
285 
286   // start and end timestamps where investments are allowed (both inclusive)
287   uint256 public startTime;
288   uint256 public endTime;
289 
290   // minimum accepted transaction
291   uint256 public minimumPurchaseInWei;
292 
293   // crowdsale configs
294   uint256[] public goalOfState;
295   uint256[] public durationOfState;
296   uint256[] public conversionRateOfState;
297 
298   // keep track of the current state
299   uint256 public currentState;
300   uint256 public currentStateStartTime;
301 
302   // and the last state where we have countdown reset mechanism
303   uint256 public lastState;
304   uint256 public softCapCountDownTimer;
305 
306   event StateTransition(uint256 from_state, uint256 to_state, uint256 timestamp);
307 
308   event TokenPurchase(uint256 current_state,
309                       uint256 timestamp,
310                       address indexed purchaser,
311                       address indexed beneficiary,
312                       uint256 transaction_amount_in_wei,
313                       uint256 num_tokens);
314 
315   // transaction sanity test
316   modifier validPurchase() {
317     require(crowdsaleActive);
318     require(now >= startTime && now <= endTime);    // buy within valid timeframe
319     require(msg.value >= minimumPurchaseInWei);     // buy at least minimumPurchaseInWei
320     _;
321   }
322 
323   // state transition
324   modifier stateTransition() {
325     require(currentState >= 0 && currentState <= lastState);
326     require(now >= currentStateStartTime);
327 
328     if (currentState == lastState) {
329       // If we achieve the soft cap goal, make sure the timeframe is valid
330       uint256 totalSupply = fundcruToken.totalSupply();
331       if (totalSupply >= goalOfState[lastState - 1]) {
332         assert(now < currentStateStartTime + softCapCountDownTimer);
333       }
334     } else {
335       // how long since current state start time
336       uint256 timePassed = now - currentStateStartTime;
337 
338       // what state we suppose to be in
339       uint256 newState;
340       uint256 sumTime = 0;
341       for (uint256 i=currentState; i<lastState; i++) {
342         sumTime = sumTime.add(durationOfState[i]);
343         if (sumTime >= timePassed) {
344           newState = i;
345           break;
346         }
347       }
348 
349       if (i == lastState) {
350         newState = lastState;
351       }
352 
353       // do we need to switch to new state
354       if (newState != currentState) {
355         StateTransition(currentState, newState, now);
356         currentState = newState;
357         currentStateStartTime = now;
358       }
359     }
360 
361     _;
362   }
363 
364   function FundCruCrowdsale(uint256   _duration,                // in seconds, convenience for testing
365                             uint256   _minimumPurchaseInWei,    // minimum accepted transaction
366                             uint256[] _goalOfState,             // goal of each state in FUND
367                             uint256[] _durationOfState,         // how long each funding state lasts, in seconds
368                             uint256[] _conversionRateOfState,   // ETH -> FUND conversion rate
369                             uint256   _softCapCountDownTimer,   // count down timer (in seconds) after soft cap goal reached
370                             uint256   _fundcruVaultLockTime,
371                             address   _crowdsaleOwner) public {
372     require(_duration > 0);
373     require(_minimumPurchaseInWei > 0);
374     require(_goalOfState.length > 0);
375     require(_crowdsaleOwner != 0x0);
376 
377     duration = _duration;
378     minimumPurchaseInWei = _minimumPurchaseInWei;
379 
380     lastState = _goalOfState.length - 1;
381     require(_durationOfState.length == (lastState + 1) &&
382             _conversionRateOfState.length == (lastState + 1));
383 
384     // funding goal configs
385     for (uint256 i=0; i<=lastState; i++) {
386       goalOfState.push(_goalOfState[i].mul(1 ether)); // 10^18, like our token's decimal
387       durationOfState.push(_durationOfState[i]);
388       conversionRateOfState.push(_conversionRateOfState[i]);
389     }
390 
391     // last state countdown parameters
392     softCapCountDownTimer = _softCapCountDownTimer;
393 
394     fundcruToken = createTokenContract();
395     assert(fundcruToken.magic() == 0x46554E44);
396     assert(fundcruToken.blockTransfering() == true);
397 
398     // locked vault
399     fundcruVaultLockTime = _fundcruVaultLockTime;
400 
401     // crowdsale owner
402     crowdsaleOwner = _crowdsaleOwner;
403   }
404 
405   // creates the token to be sold.
406   // override this method to have crowdsale of a specific mintable token.
407   function createTokenContract() internal returns (FundCruToken) {
408     // don't allow FUND tokens being traded during crowdsale period
409     return new FundCruToken(/*_blockTransfering = */true);
410   }
411 
412   // fallback function can be used to buy tokens
413   function () payable public {
414     buyTokens(msg.sender);
415   }
416 
417   // low level token purchase function
418   function buyTokens(address beneficiary) public payable stateTransition validPurchase {
419     require(beneficiary != 0x0);
420 
421     // calculate token amount to be created
422     uint256 weiAmount = msg.value;
423     uint256 numTokens = weiAmount.mul(conversionRateOfState[currentState]);
424 
425     fundcruToken.mint(beneficiary, numTokens);
426     TokenPurchase(currentState, now, msg.sender, beneficiary, weiAmount, numTokens);
427 
428     // get total supply to see if we need to change state
429     uint256 totalSupply = fundcruToken.totalSupply();
430 
431     // check if we need to go to new state
432     if (currentState < lastState) {
433       // what state we suppose to be in after this transaction
434       uint256 newState = currentState;
435       for (uint256 i=currentState; i<lastState; i++) {
436         if (goalOfState[i] > totalSupply) {
437           newState = i;
438           break;
439         }
440       }
441 
442       if (i == lastState) {
443         newState = lastState;
444       }
445 
446       // do we need to switch to new state
447       if (newState != currentState) {
448         StateTransition(currentState, newState, now);
449         currentState = newState;
450         currentStateStartTime = now;
451       }
452     }
453 
454     forwardFunds();
455   }
456 
457   function startCrowdsale() public onlyOwner {
458     require(!crowdsaleActive);
459     crowdsaleActive = true;
460 
461     // start now
462     startTime = now;
463     endTime = startTime.add(duration);
464 
465     // start from state 0
466     currentState = 0;
467     currentStateStartTime = startTime;
468   }
469 
470   function endCrowdsale() public onlyOwner {
471     require(crowdsaleActive);
472     crowdsaleActive = false;
473 
474     uint256 totalSupply = fundcruToken.totalSupply();
475 
476     // fundcru only offers 50% of tokens, keeps 50% for the company
477     // 90% of company tokens will be locked
478     uint256 unlocked_tokens = totalSupply.div(10);
479     fundcruToken.mint(crowdsaleOwner, unlocked_tokens);
480     fundcruToken.mint(this, totalSupply.sub(unlocked_tokens));
481 
482     // stop minting new coins
483     fundcruToken.finishMinting();
484 
485     // allow token being traded
486     fundcruToken.unblockTransfer();
487 
488     // lock company tokens
489     fundcruVaultLockTime = fundcruVaultLockTime.add(now);
490   }
491 
492   function withdrawTokens() public onlyOwner {
493     // must wait until lock-up time expires
494     require(!crowdsaleActive);
495     require(now > fundcruVaultLockTime);
496 
497     // withdraw all FUND tokens to company wallet
498     fundcruToken.transfer(crowdsaleOwner, fundcruToken.balanceOf(this));
499 
500     // transfer ownership to crowdsale's organizer
501     fundcruToken.transferOwnership(crowdsaleOwner);
502   }
503 
504   // send ether to the fund collection wallet
505   // override to create custom fund forwarding mechanisms
506   function forwardFunds() internal {
507     crowdsaleOwner.transfer(msg.value);
508   }
509 }