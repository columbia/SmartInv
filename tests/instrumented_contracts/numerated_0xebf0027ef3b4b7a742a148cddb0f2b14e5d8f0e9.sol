1 pragma solidity ^0.4.24;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (a == 0) {
20       return 0;
21     }
22 
23     c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return a / b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipRenounced(address indexed previousOwner);
69   event OwnershipTransferred(
70     address indexed previousOwner,
71     address indexed newOwner
72   );
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   constructor() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to relinquish control of the contract.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address _newOwner) public onlyOwner {
104     _transferOwnership(_newOwner);
105   }
106 
107   /**
108    * @dev Transfers control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function _transferOwnership(address _newOwner) internal {
112     require(_newOwner != address(0));
113     emit OwnershipTransferred(owner, _newOwner);
114     owner = _newOwner;
115   }
116 }
117 
118 
119 
120 
121 
122 contract Administratable is Ownable {
123   using SafeMath for uint256;
124 
125   address[] public adminsForIndex;
126   address[] public superAdminsForIndex;
127   mapping (address => bool) public admins;
128   mapping (address => bool) public superAdmins;
129   mapping (address => bool) private processedAdmin;
130   mapping (address => bool) private processedSuperAdmin;
131 
132   event AddAdmin(address indexed admin);
133   event RemoveAdmin(address indexed admin);
134   event AddSuperAdmin(address indexed admin);
135   event RemoveSuperAdmin(address indexed admin);
136 
137   modifier onlyAdmins {
138     require (msg.sender == owner || superAdmins[msg.sender] || admins[msg.sender]);
139     _;
140   }
141 
142   modifier onlySuperAdmins {
143     require (msg.sender == owner || superAdmins[msg.sender]);
144     _;
145   }
146 
147   function totalSuperAdminsMapping() public view returns (uint256) {
148     return superAdminsForIndex.length;
149   }
150 
151   function addSuperAdmin(address admin) public onlySuperAdmins {
152     require(admin != address(0));
153     superAdmins[admin] = true;
154     if (!processedSuperAdmin[admin]) {
155       superAdminsForIndex.push(admin);
156       processedSuperAdmin[admin] = true;
157     }
158 
159     emit AddSuperAdmin(admin);
160   }
161 
162   function removeSuperAdmin(address admin) public onlySuperAdmins {
163     require(admin != address(0));
164     superAdmins[admin] = false;
165 
166     emit RemoveSuperAdmin(admin);
167   }
168 
169   function totalAdminsMapping() public view returns (uint256) {
170     return adminsForIndex.length;
171   }
172 
173   function addAdmin(address admin) public onlySuperAdmins {
174     require(admin != address(0));
175     admins[admin] = true;
176     if (!processedAdmin[admin]) {
177       adminsForIndex.push(admin);
178       processedAdmin[admin] = true;
179     }
180 
181     emit AddAdmin(admin);
182   }
183 
184   function removeAdmin(address admin) public onlySuperAdmins {
185     require(admin != address(0));
186     admins[admin] = false;
187 
188     emit RemoveAdmin(admin);
189   }
190 }
191 
192 
193 
194 /**
195  * @title ERC20Basic
196  * @dev Simpler version of ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/179
198  */
199 contract ERC20Basic {
200   function totalSupply() public view returns (uint256);
201   function balanceOf(address who) public view returns (uint256);
202   function transfer(address to, uint256 value) public returns (bool);
203   event Transfer(address indexed from, address indexed to, uint256 value);
204 }
205 
206 
207 
208 /**
209  * @title ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 contract ERC20 is ERC20Basic {
213   function allowance(address owner, address spender)
214     public view returns (uint256);
215 
216   function transferFrom(address from, address to, uint256 value)
217     public returns (bool);
218 
219   function approve(address spender, uint256 value) public returns (bool);
220   event Approval(
221     address indexed owner,
222     address indexed spender,
223     uint256 value
224   );
225 }
226 
227 /**
228  * @title Crowdsale
229  * @dev Crowdsale is a base contract for managing a token crowdsale,
230  * allowing investors to purchase tokens with ether. This contract implements
231  * such functionality in its most fundamental form and can be extended to provide additional
232  * functionality and/or custom behavior.
233  * The external interface represents the basic interface for purchasing tokens, and conform
234  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
235  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
236  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
237  * behavior.
238  */
239 contract Crowdsale {
240   using SafeMath for uint256;
241 
242   // The token being sold
243   ERC20 public token;
244 
245   // Address where funds are collected
246   address public wallet;
247 
248   // How many token units a buyer gets per wei.
249   // The rate is the conversion between wei and the smallest and indivisible token unit.
250   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
251   // 1 wei will give you 1 unit, or 0.001 TOK.
252   uint256 public rate;
253 
254   // Amount of wei raised
255   uint256 public weiRaised;
256 
257   /**
258    * Event for token purchase logging
259    * @param purchaser who paid for the tokens
260    * @param beneficiary who got the tokens
261    * @param value weis paid for purchase
262    * @param amount amount of tokens purchased
263    */
264   event TokenPurchase(
265     address indexed purchaser,
266     address indexed beneficiary,
267     uint256 value,
268     uint256 amount
269   );
270 
271   /**
272    * @param _rate Number of token units a buyer gets per wei
273    * @param _wallet Address where collected funds will be forwarded to
274    * @param _token Address of the token being sold
275    */
276   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
277     require(_rate > 0);
278     require(_wallet != address(0));
279     require(_token != address(0));
280 
281     rate = _rate;
282     wallet = _wallet;
283     token = _token;
284   }
285 
286   // -----------------------------------------
287   // Crowdsale external interface
288   // -----------------------------------------
289 
290   /**
291    * @dev fallback function ***DO NOT OVERRIDE***
292    */
293   function () external payable {
294     buyTokens(msg.sender);
295   }
296 
297   /**
298    * @dev low level token purchase ***DO NOT OVERRIDE***
299    * @param _beneficiary Address performing the token purchase
300    */
301   function buyTokens(address _beneficiary) public payable {
302 
303     uint256 weiAmount = msg.value;
304     _preValidatePurchase(_beneficiary, weiAmount);
305 
306     // calculate token amount to be created
307     uint256 tokens = _getTokenAmount(weiAmount);
308 
309     // update state
310     weiRaised = weiRaised.add(weiAmount);
311 
312     _processPurchase(_beneficiary, tokens);
313     emit TokenPurchase(
314       msg.sender,
315       _beneficiary,
316       weiAmount,
317       tokens
318     );
319 
320     _updatePurchasingState(_beneficiary, weiAmount);
321 
322     _forwardFunds();
323     _postValidatePurchase(_beneficiary, weiAmount);
324   }
325 
326   // -----------------------------------------
327   // Internal interface (extensible)
328   // -----------------------------------------
329 
330   /**
331    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
332    * @param _beneficiary Address performing the token purchase
333    * @param _weiAmount Value in wei involved in the purchase
334    */
335   function _preValidatePurchase(
336     address _beneficiary,
337     uint256 _weiAmount
338   )
339     internal
340   {
341     require(_beneficiary != address(0));
342     require(_weiAmount != 0);
343   }
344 
345   /**
346    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
347    * @param _beneficiary Address performing the token purchase
348    * @param _weiAmount Value in wei involved in the purchase
349    */
350   function _postValidatePurchase(
351     address _beneficiary,
352     uint256 _weiAmount
353   )
354     internal
355   {
356     // optional override
357   }
358 
359   /**
360    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
361    * @param _beneficiary Address performing the token purchase
362    * @param _tokenAmount Number of tokens to be emitted
363    */
364   function _deliverTokens(
365     address _beneficiary,
366     uint256 _tokenAmount
367   )
368     internal
369   {
370     token.transfer(_beneficiary, _tokenAmount);
371   }
372 
373   /**
374    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
375    * @param _beneficiary Address receiving the tokens
376    * @param _tokenAmount Number of tokens to be purchased
377    */
378   function _processPurchase(
379     address _beneficiary,
380     uint256 _tokenAmount
381   )
382     internal
383   {
384     _deliverTokens(_beneficiary, _tokenAmount);
385   }
386 
387   /**
388    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
389    * @param _beneficiary Address receiving the tokens
390    * @param _weiAmount Value in wei involved in the purchase
391    */
392   function _updatePurchasingState(
393     address _beneficiary,
394     uint256 _weiAmount
395   )
396     internal
397   {
398     // optional override
399   }
400 
401   /**
402    * @dev Override to extend the way in which ether is converted to tokens.
403    * @param _weiAmount Value in wei to be converted into tokens
404    * @return Number of tokens that can be purchased with the specified _weiAmount
405    */
406   function _getTokenAmount(uint256 _weiAmount)
407     internal view returns (uint256)
408   {
409     return _weiAmount.mul(rate);
410   }
411 
412   /**
413    * @dev Determines how ETH is stored/forwarded on purchases.
414    */
415   function _forwardFunds() internal {
416     wallet.transfer(msg.value);
417   }
418 }
419 
420 
421 
422 
423 
424 /**
425  * @title Pausable
426  * @dev Base contract which allows children to implement an emergency stop mechanism.
427  */
428 contract Pausable is Ownable {
429   event Pause();
430   event Unpause();
431 
432   bool public paused = false;
433 
434 
435   /**
436    * @dev Modifier to make a function callable only when the contract is not paused.
437    */
438   modifier whenNotPaused() {
439     require(!paused);
440     _;
441   }
442 
443   /**
444    * @dev Modifier to make a function callable only when the contract is paused.
445    */
446   modifier whenPaused() {
447     require(paused);
448     _;
449   }
450 
451   /**
452    * @dev called by the owner to pause, triggers stopped state
453    */
454   function pause() onlyOwner whenNotPaused public {
455     paused = true;
456     emit Pause();
457   }
458 
459   /**
460    * @dev called by the owner to unpause, returns to normal state
461    */
462   function unpause() onlyOwner whenPaused public {
463     paused = false;
464     emit Unpause();
465   }
466 }
467 
468 
469 contract TokenSale is
470     Crowdsale,
471     Ownable {
472 
473     constructor(uint256 _rate, address _wallet, ERC20 _token) public
474     Crowdsale(_rate, _wallet, _token) {}
475 
476     function changeTokenAddress(ERC20 _token) public onlyOwner {
477         token = _token;
478     }
479 
480     function changeWalletAddress(address _wallet) public onlyOwner {
481         wallet = _wallet;
482     }
483 
484     function changeRate(uint256 _rate) public onlyOwner {
485         rate = _rate;
486     }
487 }