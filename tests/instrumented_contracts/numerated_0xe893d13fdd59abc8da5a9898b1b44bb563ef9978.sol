1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
68 
69 /**
70  * @title Claimable
71  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
72  * This allows the new owner to accept the transfer.
73  */
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() public onlyPendingOwner {
97     emit OwnershipTransferred(owner, pendingOwner);
98     owner = pendingOwner;
99     pendingOwner = address(0);
100   }
101 }
102 
103 // File: contracts/external/KYCWhitelist.sol
104 
105 /**
106  * @title KYCWhitelist
107  * @dev Crowdsale in which only whitelisted users can contribute.
108  */
109 contract KYCWhitelist is Claimable {
110 
111     mapping(address => bool) public whitelist;
112 
113     /**
114     * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
115     */
116     modifier isWhitelisted(address _beneficiary) {
117         require(whitelist[_beneficiary]);
118         _;
119     }
120 
121     /**
122     * @dev Does a "require" check if _beneficiary address is approved
123     * @param _beneficiary Token beneficiary
124     */
125     function validateWhitelisted(address _beneficiary) internal view {
126         require(whitelist[_beneficiary]);
127     }
128 
129     /**
130     * @dev Adds single address to whitelist.
131     * @param _beneficiary Address to be added to the whitelist
132     */
133     function addToWhitelist(address _beneficiary) external onlyOwner {
134         whitelist[_beneficiary] = true;
135         emit addToWhiteListE(_beneficiary);
136     }
137     
138     // ******************************** Test Start
139 
140     event addToWhiteListE(address _beneficiary);
141 
142     // ******************************** Test End
143 
144 
145     /**
146     * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
147     * @param _beneficiaries Addresses to be added to the whitelist
148     */
149     function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
150         for (uint256 i = 0; i < _beneficiaries.length; i++) {
151             whitelist[_beneficiaries[i]] = true;
152         }
153     }
154 
155     /**
156     * @dev Removes single address from whitelist. 
157     * @param _beneficiary Address to be removed to the whitelist
158     */
159     function removeFromWhitelist(address _beneficiary) external onlyOwner {
160         whitelist[_beneficiary] = false;
161     }
162 }
163 
164 // File: contracts/external/Pausable.sol
165 
166 /**
167  * @title Pausable
168  * @dev Base contract which allows children to implement an emergency stop mechanism.
169  */
170 contract Pausable is Ownable {
171     event Pause();
172     event Unpause();
173 
174     bool public paused = false;
175 
176 
177     /**
178     * @dev Modifier to make a function callable only when the contract is not paused.
179     */
180     modifier whenNotPaused() {
181         require(!paused);
182         _;
183     }
184 
185     /**
186     * @dev Modifier to make a function callable only when the contract is paused.
187     */
188     modifier whenPaused() {
189         require(paused);
190         _;
191     }
192 
193     /**
194     * @dev called by the owner to pause, triggers stopped state
195     */
196     function pause() public onlyOwner whenNotPaused {
197         paused = true;
198         emit Pause();
199     }
200 
201     /**
202     * @dev called by the owner to unpause, returns to normal state
203     */
204     function unpause() public onlyOwner whenPaused {
205         paused = false;
206         emit Unpause();
207     }
208 }
209 
210 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
211 
212 /**
213  * @title SafeMath
214  * @dev Math operations with safety checks that throw on error
215  */
216 library SafeMath {
217 
218   /**
219   * @dev Multiplies two numbers, throws on overflow.
220   */
221   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
222     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
223     // benefit is lost if 'b' is also tested.
224     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
225     if (_a == 0) {
226       return 0;
227     }
228 
229     c = _a * _b;
230     assert(c / _a == _b);
231     return c;
232   }
233 
234   /**
235   * @dev Integer division of two numbers, truncating the quotient.
236   */
237   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
238     // assert(_b > 0); // Solidity automatically throws when dividing by 0
239     // uint256 c = _a / _b;
240     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
241     return _a / _b;
242   }
243 
244   /**
245   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
246   */
247   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
248     assert(_b <= _a);
249     return _a - _b;
250   }
251 
252   /**
253   * @dev Adds two numbers, throws on overflow.
254   */
255   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
256     c = _a + _b;
257     assert(c >= _a);
258     return c;
259   }
260 }
261 
262 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
263 
264 /**
265  * @title ERC20Basic
266  * @dev Simpler version of ERC20 interface
267  * See https://github.com/ethereum/EIPs/issues/179
268  */
269 contract ERC20Basic {
270   function totalSupply() public view returns (uint256);
271   function balanceOf(address _who) public view returns (uint256);
272   function transfer(address _to, uint256 _value) public returns (bool);
273   event Transfer(address indexed from, address indexed to, uint256 value);
274 }
275 
276 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
277 
278 /**
279  * @title ERC20 interface
280  * @dev see https://github.com/ethereum/EIPs/issues/20
281  */
282 contract ERC20 is ERC20Basic {
283   function allowance(address _owner, address _spender)
284     public view returns (uint256);
285 
286   function transferFrom(address _from, address _to, uint256 _value)
287     public returns (bool);
288 
289   function approve(address _spender, uint256 _value) public returns (bool);
290   event Approval(
291     address indexed owner,
292     address indexed spender,
293     uint256 value
294   );
295 }
296 
297 // File: contracts/PrivatePreSale.sol
298 
299 /**
300  * @title PrivatePreSale
301  * 
302  * Private Pre-sale contract for Energis tokens
303  *
304  * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.
305  */
306 contract PrivatePreSale is Claimable, KYCWhitelist, Pausable {
307     using SafeMath for uint256;
308 
309   
310     // Send ETH to this address
311     address public FUNDS_WALLET = 0xDc17D222Bc3f28ecE7FCef42EDe0037C739cf28f;
312     // ZCC for sale wallet address
313     address public TOKEN_WALLET = 0x1EF91464240BB6E0FdE7a73E0a6f3843D3E07601;
314     // ZCC token contract address
315     ERC20 public TOKEN = ERC20(0x6737fE98389Ffb356F64ebB726aA1a92390D94Fb);
316     // Wallet to store sold Tokens needs to be locked
317     address public LOCKUP_WALLET = 0xaB18B66F75D13a38158f9946662646105C3bC45D;
318     // Conversion Rate (Eth cost of 1 ZCC)
319     uint256 public constant TOKENS_PER_ETH = 650;
320     // Max ZCC tokens to sell
321     uint256 public MAX_TOKENS = 20000000 * (10**18);
322     // Min investment in Tokens
323     uint256 public MIN_TOKEN_INVEST = 97500 * (10**18);
324     // Token sale start date
325     uint256 public START_DATE = 1542888000;
326 
327     // -----------------------------------------
328     // State Variables
329     // -----------------------------------------
330 
331     // Amount of wei raised
332     uint256 public weiRaised;
333     // Amount of tokens issued
334     uint256 public tokensIssued;
335     // If the pre-sale has ended
336     bool public closed;
337 
338     // -----------------------------------------
339     // Events
340     // -----------------------------------------
341 
342     /**
343     * @dev Event for token purchased
344     * @param purchaser who paid for the tokens
345     * @param beneficiary who got the tokens
346     * @param value weis paid for purchase
347     * @param amount amount of tokens purchased
348     */
349     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
350 
351 
352     /**
353      * @dev Constructor
354      */
355     constructor() public {
356         assert(FUNDS_WALLET != address(0));
357         assert(TOKEN != address(0));
358         assert(TOKEN_WALLET != address(0));
359         assert(LOCKUP_WALLET != address(0));
360         assert(MAX_TOKENS > 0);
361         assert(MIN_TOKEN_INVEST >= 0);
362     }
363 
364     // -----------------------------------------
365     // Private PreSale external Interface
366     // -----------------------------------------
367 
368     /**
369     * @dev Checks whether the cap has been reached. 
370     * @return Whether the cap was reached
371     */
372     function capReached() public view returns (bool) {
373         return tokensIssued >= MAX_TOKENS;
374     }
375 
376     /**
377     * @dev Closes the sale, can only be called once. Once closed can not be opened again.
378     */
379     function closeSale() public onlyOwner {
380         assert(!closed);
381         closed = true;
382     }
383 
384     /**
385     * @dev Returns the amount of tokens given for the amount in Wei
386     * @param _weiAmount Value in wei
387     */
388     function getTokenAmount(uint256 _weiAmount) public pure returns (uint256) {
389         // Amount in wei (10**18 wei == 1 eth) and the token is 18 decimal places
390         return _weiAmount.mul(TOKENS_PER_ETH);
391     }
392 
393     /**
394     * @dev fallback function ***DO NOT OVERRIDE***
395     */
396     function () external payable {
397         buyTokens(msg.sender);
398     }
399 
400     // -----------------------------------------
401     // Private PreSale internal
402     // -----------------------------------------
403 
404     /**
405     * @dev low level token purchase ***DO NOT OVERRIDE***
406     * @param _beneficiary Address performing the token purchase
407     */
408     function buyTokens(address _beneficiary) internal whenNotPaused {
409 
410         uint256 weiAmount = msg.value;
411 
412         // calculate token amount to be created
413         uint256 tokenAmount = getTokenAmount(weiAmount);
414 
415         // Validation Checks
416         preValidateChecks(_beneficiary, weiAmount, tokenAmount);
417         
418         
419 
420         // update state
421         tokensIssued = tokensIssued.add(tokenAmount);
422         weiRaised = weiRaised.add(weiAmount);
423 
424         // Send tokens from token wallet
425         TOKEN.transferFrom(TOKEN_WALLET, LOCKUP_WALLET, tokenAmount);       
426 
427         // Forward the funds to wallet
428         FUNDS_WALLET.transfer(msg.value);
429 
430         // Event trigger
431         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokenAmount);
432     }
433 
434     /**
435     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
436     * @param _beneficiary Address performing the token purchase
437     * @param _weiAmount Value in wei involved in the purchase
438     * @param _tokenAmount Amount of token to purchase
439     */
440     function preValidateChecks(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal view {
441         require(_beneficiary != address(0));
442         require(_weiAmount != 0);
443         require(now >= START_DATE);
444         require(!closed);
445 
446         // KYC Check
447         validateWhitelisted(_beneficiary);
448 
449         // Test Min Investment
450         require(_tokenAmount >= MIN_TOKEN_INVEST);
451 
452         // Test hard cap
453         require(tokensIssued.add(_tokenAmount) <= MAX_TOKENS);
454     }
455 }