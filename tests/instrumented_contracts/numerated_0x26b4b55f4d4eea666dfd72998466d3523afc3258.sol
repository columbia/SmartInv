1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
46 
47 /**
48  * @title Claimable
49  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
50  * This allows the new owner to accept the transfer.
51  */
52 contract Claimable is Ownable {
53   address public pendingOwner;
54 
55   /**
56    * @dev Modifier throws if called by any account other than the pendingOwner.
57    */
58   modifier onlyPendingOwner() {
59     require(msg.sender == pendingOwner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to set the pendingOwner address.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     pendingOwner = newOwner;
69   }
70 
71   /**
72    * @dev Allows the pendingOwner address to finalize the transfer.
73    */
74   function claimOwnership() onlyPendingOwner public {
75     emit OwnershipTransferred(owner, pendingOwner);
76     owner = pendingOwner;
77     pendingOwner = address(0);
78   }
79 }
80 
81 // File: contracts/external/KYCWhitelist.sol
82 
83 /**
84  * @title KYCWhitelist
85  * @dev Crowdsale in which only whitelisted users can contribute.
86  */
87 contract KYCWhitelist is Claimable {
88 
89    mapping(address => bool) public whitelist;
90 
91   /**
92    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
93    */
94   modifier isWhitelisted(address _beneficiary) {
95     require(whitelist[_beneficiary]);
96     _;
97   }
98 
99   /**
100    * @dev Does a "require" check if _beneficiary address is approved
101    * @param _beneficiary Token beneficiary
102    */
103   function validateWhitelisted(address _beneficiary) internal view {
104     require(whitelist[_beneficiary]);
105   }
106 
107   /**
108    * @dev Adds single address to whitelist.
109    * @param _beneficiary Address to be added to the whitelist
110    */
111   function addToWhitelist(address _beneficiary) external onlyOwner {
112     whitelist[_beneficiary] = true;
113   }
114   
115   /**
116    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing. 
117    * @param _beneficiaries Addresses to be added to the whitelist
118    */
119   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
120     for (uint256 i = 0; i < _beneficiaries.length; i++) {
121       whitelist[_beneficiaries[i]] = true;
122     }
123   }
124 
125   /**
126    * @dev Removes single address from whitelist. 
127    * @param _beneficiary Address to be removed to the whitelist
128    */
129   function removeFromWhitelist(address _beneficiary) external onlyOwner {
130     whitelist[_beneficiary] = false;
131   }
132 
133   
134 }
135 
136 // File: contracts/external/Pausable.sol
137 
138 /**
139  * @title Pausable
140  * @dev Base contract which allows children to implement an emergency stop mechanism.
141  */
142 contract Pausable is Claimable {
143   event Pause();
144   event Unpause();
145 
146   bool public paused = false;
147 
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is not paused.
151    */
152   modifier whenNotPaused() {
153     require(!paused);
154     _;
155   }
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is paused.
159    */
160   modifier whenPaused() {
161     require(paused);
162     _;
163   }
164 
165   /**
166    * @dev called by the owner to pause, triggers stopped state
167    */
168   function pause() onlyOwner whenNotPaused public {
169     paused = true;
170     emit Pause();
171   }
172 
173   /**
174    * @dev called by the owner to unpause, returns to normal state
175    */
176   function unpause() onlyOwner whenPaused public {
177     paused = false;
178     emit Unpause();
179   }
180 }
181 
182 // File: zeppelin-solidity/contracts/math/SafeMath.sol
183 
184 /**
185  * @title SafeMath
186  * @dev Math operations with safety checks that throw on error
187  */
188 library SafeMath {
189 
190   /**
191   * @dev Multiplies two numbers, throws on overflow.
192   */
193   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
194     if (a == 0) {
195       return 0;
196     }
197     uint256 c = a * b;
198     assert(c / a == b);
199     return c;
200   }
201 
202   /**
203   * @dev Integer division of two numbers, truncating the quotient.
204   */
205   function div(uint256 a, uint256 b) internal pure returns (uint256) {
206     // assert(b > 0); // Solidity automatically throws when dividing by 0
207     uint256 c = a / b;
208     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209     return c;
210   }
211 
212   /**
213   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
214   */
215   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216     assert(b <= a);
217     return a - b;
218   }
219 
220   /**
221   * @dev Adds two numbers, throws on overflow.
222   */
223   function add(uint256 a, uint256 b) internal pure returns (uint256) {
224     uint256 c = a + b;
225     assert(c >= a);
226     return c;
227   }
228 }
229 
230 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
231 
232 /**
233  * @title ERC20Basic
234  * @dev Simpler version of ERC20 interface
235  * @dev see https://github.com/ethereum/EIPs/issues/179
236  */
237 contract ERC20Basic {
238   function totalSupply() public view returns (uint256);
239   function balanceOf(address who) public view returns (uint256);
240   function transfer(address to, uint256 value) public returns (bool);
241   event Transfer(address indexed from, address indexed to, uint256 value);
242 }
243 
244 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
245 
246 /**
247  * @title ERC20 interface
248  * @dev see https://github.com/ethereum/EIPs/issues/20
249  */
250 contract ERC20 is ERC20Basic {
251   function allowance(address owner, address spender) public view returns (uint256);
252   function transferFrom(address from, address to, uint256 value) public returns (bool);
253   function approve(address spender, uint256 value) public returns (bool);
254   event Approval(address indexed owner, address indexed spender, uint256 value);
255 }
256 
257 // File: contracts/PrivatePreSale.sol
258 
259 /**
260  * @title PrivatePreSale
261  * 
262  * Private Pre-sale contract for Energis tokens
263  *
264  * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.
265  */
266 contract PrivatePreSale is Claimable, KYCWhitelist, Pausable {
267   using SafeMath for uint256;
268 
269   
270   // Wallet Address for funds
271   address public constant FUNDS_WALLET = 0xDc17D222Bc3f28ecE7FCef42EDe0037C739cf28f;
272   // Token Wallet Address
273   address public constant TOKEN_WALLET = 0x1EF91464240BB6E0FdE7a73E0a6f3843D3E07601;
274   // Token adderss being sold
275   address public constant TOKEN_ADDRESS = 0x14121EEe7995FFDF47ED23cfFD0B5da49cbD6EB3;
276   // Lockup Address
277   address public constant LOCKUP_WALLET = 0xaB18B66F75D13a38158f9946662646105C3bC45D;
278   // Token being sold
279   ERC20 public constant TOKEN = ERC20(TOKEN_ADDRESS);
280   // Conversion Rate (Eth cost of 1 NRG)
281   uint256 public constant TOKENS_PER_ETH = 4970;
282   // Max NRG tokens to sell
283   uint256 public constant MAX_TOKENS = 20000000 * (10**18) - 119545639989300000000000;
284   // Min investment in Tokens
285   uint256 public constant MIN_TOKEN_INVEST = 4970 * (10**18);
286   // Token sale start date
287   uint256 public START_DATE = 1531915200;
288 
289   // -----------------------------------------
290   // State Variables
291   // -----------------------------------------
292 
293   // Amount of wei raised
294   uint256 public weiRaised;
295   // Amount of tokens issued
296   uint256 public tokensIssued;
297   // If the pre-sale has ended
298   bool public closed;
299 
300   // -----------------------------------------
301   // Events
302   // -----------------------------------------
303 
304   /**
305    * Event for token purchase logging
306    * @param purchaser who paid for the tokens
307    * @param beneficiary who got the tokens
308    * @param value weis paid for purchase
309    * @param amount amount of tokens purchased
310    */
311   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
312 
313 
314   // -----------------------------------------
315   // Constructor
316   // -----------------------------------------
317 
318 
319   constructor() public {
320     require(TOKENS_PER_ETH > 0);
321     require(FUNDS_WALLET != address(0));
322     require(TOKEN_WALLET != address(0));
323     require(TOKEN_ADDRESS != address(0));
324     require(MAX_TOKENS > 0);
325     require(MIN_TOKEN_INVEST >= 0);
326   }
327 
328   // -----------------------------------------
329   // Private PreSale external Interface
330   // -----------------------------------------
331 
332   /**
333    * @dev Checks whether the cap has been reached. 
334    * @return Whether the cap was reached
335    */
336   function capReached() public view returns (bool) {
337     return tokensIssued >= MAX_TOKENS;
338   }
339 
340   /**
341    * @dev Closes the sale, can only be called once. Once closed can not be opened again.
342    */
343   function closeSale() public onlyOwner {
344     require(!closed);
345     closed = true;
346   }
347 
348   /**
349    * @dev Returns the amount of tokens given for the amount in Wei
350    * @param _weiAmount Value in wei
351    */
352   function getTokenAmount(uint256 _weiAmount) public pure returns (uint256) {
353     // Amount in wei (10**18 wei == 1 eth) and the token is 18 decimal places
354     return _weiAmount.mul(TOKENS_PER_ETH);
355   }
356 
357   /**
358    * @dev fallback function ***DO NOT OVERRIDE***
359    */
360   function () external payable {
361     buyTokens(msg.sender);
362   }
363 
364   // -----------------------------------------
365   // Private PreSale internal
366   // -----------------------------------------
367 
368    /**
369    * @dev low level token purchase ***DO NOT OVERRIDE***
370    * @param _beneficiary Address performing the token purchase
371    */
372   function buyTokens(address _beneficiary) internal whenNotPaused {
373     
374     uint256 weiAmount = msg.value;
375 
376     // calculate token amount to be created
377     uint256 tokenAmount = getTokenAmount(weiAmount);
378 
379     // Validation Checks
380     preValidateChecks(_beneficiary, weiAmount, tokenAmount);
381     
382     // update state
383     tokensIssued = tokensIssued.add(tokenAmount);
384     weiRaised = weiRaised.add(weiAmount);
385 
386     // Send tokens from token wallet
387     TOKEN.transferFrom(TOKEN_WALLET, LOCKUP_WALLET, tokenAmount);
388 
389     // Forward the funds to wallet
390     FUNDS_WALLET.transfer(msg.value);
391 
392     // Event trigger
393     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokenAmount);
394   }
395 
396   /**
397    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
398    * @param _beneficiary Address performing the token purchase
399    * @param _weiAmount Value in wei involved in the purchase
400    * @param _tokenAmount Amount of token to purchase
401    */
402   function preValidateChecks(address _beneficiary, uint256 _weiAmount, uint256 _tokenAmount) internal view {
403     require(_beneficiary != address(0));
404     require(_weiAmount != 0);
405     require(now >= START_DATE);
406     require(!closed);
407 
408     // KYC Check
409     validateWhitelisted(_beneficiary);
410 
411     // Test Min Investment
412     require(_tokenAmount >= MIN_TOKEN_INVEST);
413 
414     // Test hard cap
415     require(tokensIssued.add(_tokenAmount) <= MAX_TOKENS);
416   }
417 }