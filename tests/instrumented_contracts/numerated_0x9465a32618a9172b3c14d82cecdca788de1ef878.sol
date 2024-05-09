1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ReinvestProxy.sol
4 
5 /*
6  * Visit: https://p4rty.io
7  * Discord: https://discord.gg/7y3DHYF
8  * Copyright Mako Labs LLC 2018 All Rights Reseerved
9 */
10 interface ReinvestProxy {
11 
12     /// @dev Converts all incoming ethereum to tokens for the caller,
13     function reinvestFor(address customer) external payable;
14 
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/Math.sol
18 
19 /**
20  * @title Math
21  * @dev Assorted math operations
22  */
23 library Math {
24   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
25     return a >= b ? a : b;
26   }
27 
28   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
29     return a < b ? a : b;
30   }
31 
32   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
33     return a >= b ? a : b;
34   }
35 
36   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
37     return a < b ? a : b;
38   }
39 }
40 
41 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     if (a == 0) {
54       return 0;
55     }
56     c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     // uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return a / b;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address public owner;
98 
99 
100   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110 
111   /**
112    * @dev Throws if called by any account other than the owner.
113    */
114   modifier onlyOwner() {
115     require(msg.sender == owner);
116     _;
117   }
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) public onlyOwner {
124     require(newOwner != address(0));
125     emit OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 
129 }
130 
131 // File: openzeppelin-solidity/contracts/ownership/Whitelist.sol
132 
133 /**
134  * @title Whitelist
135  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
136  * @dev This simplifies the implementation of "user permissions".
137  */
138 contract Whitelist is Ownable {
139   mapping(address => bool) public whitelist;
140 
141   event WhitelistedAddressAdded(address addr);
142   event WhitelistedAddressRemoved(address addr);
143 
144   /**
145    * @dev Throws if called by any account that's not whitelisted.
146    */
147   modifier onlyWhitelisted() {
148     require(whitelist[msg.sender]);
149     _;
150   }
151 
152   /**
153    * @dev add an address to the whitelist
154    * @param addr address
155    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
156    */
157   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
158     if (!whitelist[addr]) {
159       whitelist[addr] = true;
160       emit WhitelistedAddressAdded(addr);
161       success = true;
162     }
163   }
164 
165   /**
166    * @dev add addresses to the whitelist
167    * @param addrs addresses
168    * @return true if at least one address was added to the whitelist,
169    * false if all addresses were already in the whitelist
170    */
171   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
172     for (uint256 i = 0; i < addrs.length; i++) {
173       if (addAddressToWhitelist(addrs[i])) {
174         success = true;
175       }
176     }
177   }
178 
179   /**
180    * @dev remove an address from the whitelist
181    * @param addr address
182    * @return true if the address was removed from the whitelist,
183    * false if the address wasn't in the whitelist in the first place
184    */
185   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
186     if (whitelist[addr]) {
187       whitelist[addr] = false;
188       emit WhitelistedAddressRemoved(addr);
189       success = true;
190     }
191   }
192 
193   /**
194    * @dev remove addresses from the whitelist
195    * @param addrs addresses
196    * @return true if at least one address was removed from the whitelist,
197    * false if all addresses weren't in the whitelist in the first place
198    */
199   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
200     for (uint256 i = 0; i < addrs.length; i++) {
201       if (removeAddressFromWhitelist(addrs[i])) {
202         success = true;
203       }
204     }
205   }
206 
207 }
208 
209 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
210 
211 /**
212  * @title ERC20Basic
213  * @dev Simpler version of ERC20 interface
214  * @dev see https://github.com/ethereum/EIPs/issues/179
215  */
216 contract ERC20Basic {
217   function totalSupply() public view returns (uint256);
218   function balanceOf(address who) public view returns (uint256);
219   function transfer(address to, uint256 value) public returns (bool);
220   event Transfer(address indexed from, address indexed to, uint256 value);
221 }
222 
223 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
224 
225 /**
226  * @title ERC20 interface
227  * @dev see https://github.com/ethereum/EIPs/issues/20
228  */
229 contract ERC20 is ERC20Basic {
230   function allowance(address owner, address spender) public view returns (uint256);
231   function transferFrom(address from, address to, uint256 value) public returns (bool);
232   function approve(address spender, uint256 value) public returns (bool);
233   event Approval(address indexed owner, address indexed spender, uint256 value);
234 }
235 
236 // File: contracts/P4RTYDaoVault.sol
237 
238 /*
239  * Visit: https://p4rty.io
240  * Discord: https://discord.gg/7y3DHYF
241 */
242 
243 contract P4RTYDaoVault is Whitelist {
244 
245 
246     /*=================================
247     =            MODIFIERS            =
248     =================================*/
249 
250     /// @dev Only people with profits
251     modifier onlyDivis {
252         require(myDividends() > 0);
253         _;
254     }
255 
256 
257     /*==============================
258     =            EVENTS            =
259     ==============================*/
260 
261     event onStake(
262         address indexed customerAddress,
263         uint256 stakedTokens,
264         uint256 timestamp
265     );
266 
267     event onDeposit(
268         address indexed fundingSource,
269         uint256 ethDeposited,
270         uint    timestamp
271     );
272 
273     event onWithdraw(
274         address indexed customerAddress,
275         uint256 ethereumWithdrawn,
276         uint timestamp
277     );
278 
279     event onReinvestmentProxy(
280         address indexed customerAddress,
281         address indexed destinationAddress,
282         uint256 ethereumReinvested
283     );
284 
285 
286 
287 
288     /*=====================================
289     =            CONFIGURABLES            =
290     =====================================*/
291 
292 
293     uint256 constant internal magnitude = 2 ** 64;
294 
295 
296     /*=================================
297      =            DATASETS            =
298      ================================*/
299 
300     // amount of shares for each address (scaled number)
301     mapping(address => uint256) internal tokenBalanceLedger_;
302     mapping(address => int256) internal payoutsTo_;
303 
304     //Initial deposits backed by one virtual share that cannot be unstaked
305     uint256 internal tokenSupply_ = 1;
306     uint256 internal profitPerShare_;
307 
308     ERC20 public p4rty;
309 
310 
311     /*=======================================
312     =            PUBLIC FUNCTIONS           =
313     =======================================*/
314 
315     constructor(address _p4rtyAddress) Ownable() public {
316 
317         p4rty = ERC20(_p4rtyAddress);
318 
319     }
320 
321     /**
322      * @dev Fallback function to handle ethereum that was send straight to the contract
323      */
324     function() payable public {
325         deposit();
326     }
327 
328     /// @dev Internal function to actually purchase the tokens.
329     function deposit() payable public  {
330 
331         uint256 _incomingEthereum = msg.value;
332         address _fundingSource = msg.sender;
333 
334         // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
335         profitPerShare_ += (_incomingEthereum * magnitude / tokenSupply_);
336 
337 
338         // fire event
339         emit onDeposit(_fundingSource, _incomingEthereum, now);
340 
341     }
342 
343     function stake(uint _amountOfTokens) public {
344 
345 
346         //Approval has to happen separately directly with p4rty
347         //p4rty.approve(<DAO>, _amountOfTokens);
348 
349         address _customerAddress = msg.sender;
350 
351         //Customer needs to have P4RTY
352         require(p4rty.balanceOf(_customerAddress) > 0);
353 
354 
355 
356         uint256 _balance = p4rty.balanceOf(_customerAddress);
357         uint256 _stakeAmount = Math.min256(_balance,_amountOfTokens);
358 
359         require(_stakeAmount > 0);
360         p4rty.transferFrom(_customerAddress, address(this), _stakeAmount);
361 
362         //Add to the tokenSupply_
363         tokenSupply_ = SafeMath.add(tokenSupply_, _stakeAmount);
364 
365         // update circulating supply & the ledger address for the customer
366         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _stakeAmount);
367 
368         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
369         // really i know you think you do but you don't
370         int256 _updatedPayouts = (int256) (profitPerShare_ * _stakeAmount);
371         payoutsTo_[_customerAddress] += _updatedPayouts;
372 
373         emit onStake(_customerAddress, _amountOfTokens, now);
374     }
375 
376     /// @dev Withdraws all of the callers earnings.
377     function withdraw() onlyDivis public {
378 
379         address _customerAddress = msg.sender;
380         // setup data
381         uint256 _dividends = dividendsOf(_customerAddress);
382 
383         // update dividend tracker
384         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
385 
386 
387         // lambo delivery service
388         _customerAddress.transfer(_dividends);
389 
390         // fire event
391         emit onWithdraw(_customerAddress, _dividends, now);
392     }
393 
394     function reinvestByProxy(address _customerAddress) onlyWhitelisted public {
395         // setup data
396         uint256 _dividends = dividendsOf(_customerAddress);
397 
398         // update dividend tracker
399         payoutsTo_[_customerAddress] += (int256) (_dividends * magnitude);
400 
401 
402         // dispatch a buy order with the virtualized "withdrawn dividends"
403         ReinvestProxy reinvestProxy =  ReinvestProxy(msg.sender);
404         reinvestProxy.reinvestFor.value(_dividends)(_customerAddress);
405 
406         emit onReinvestmentProxy(_customerAddress,msg.sender,_dividends);
407 
408     }
409 
410 
411     /*=====================================
412     =      HELPERS AND CALCULATORS        =
413     =====================================*/
414 
415     /**
416      * @dev Method to view the current Ethereum stored in the contract
417      *  Example: totalEthereumBalance()
418      */
419     function totalEthereumBalance() public view returns (uint256) {
420         return address(this).balance;
421     }
422 
423     /// @dev Retrieve the total token supply.
424     function totalSupply() public view returns (uint256) {
425         return tokenSupply_;
426     }
427 
428     /// @dev Retrieve the tokens owned by the caller.
429     function myTokens() public view returns (uint256) {
430         address _customerAddress = msg.sender;
431         return balanceOf(_customerAddress);
432     }
433 
434     /// @dev The percentage of the
435     function votingPower(address _customerAddress) public view returns (uint256) {
436         return SafeMath.div(balanceOf(_customerAddress), totalSupply());
437     }
438 
439     /**
440      * @dev Retrieve the dividends owned by the caller.
441      *  If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
442      *  The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
443      *  But in the internal calculations, we want them separate.
444      */
445     function myDividends() public view returns (uint256) {
446         return dividendsOf(msg.sender);
447 
448     }
449 
450     /// @dev Retrieve the token balance of any single address.
451     function balanceOf(address _customerAddress) public view returns (uint256) {
452         return tokenBalanceLedger_[_customerAddress];
453     }
454 
455     /// @dev Retrieve the dividend balance of any single address.
456     function dividendsOf(address _customerAddress) public view returns (uint256) {
457         return (uint256) ((int256) (profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
458     }
459 
460 }