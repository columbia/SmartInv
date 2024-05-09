1 pragma solidity ^0.4.23;
2 
3 // File: contracts/NokuPricingPlan.sol
4 
5 /**
6 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
7 */
8 contract NokuPricingPlan {
9     /**
10     * @dev Pay the fee for the service identified by the specified name.
11     * The fee amount shall already be approved by the client.
12     * @param serviceName The name of the target service.
13     * @param multiplier The multiplier of the base service fee to apply.
14     * @param client The client of the target service.
15     * @return true if fee has been paid.
16     */
17     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
18 
19     /**
20     * @dev Get the usage fee for the service identified by the specified name.
21     * The returned fee amount shall be approved before using #payFee method.
22     * @param serviceName The name of the target service.
23     * @param multiplier The multiplier of the base service fee to apply.
24     * @return The amount to approve before really paying such fee.
25     */
26     function usageFee(bytes32 serviceName, uint256 multiplier) public view returns(uint fee);
27 }
28 
29 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipRenounced(address indexed previousOwner);
41   event OwnershipTransferred(
42     address indexed previousOwner,
43     address indexed newOwner
44   );
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to relinquish control of the contract.
65    */
66   function renounceOwnership() public onlyOwner {
67     emit OwnershipRenounced(owner);
68     owner = address(0);
69   }
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param _newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address _newOwner) public onlyOwner {
76     _transferOwnership(_newOwner);
77   }
78 
79   /**
80    * @dev Transfers control of the contract to a newOwner.
81    * @param _newOwner The address to transfer ownership to.
82    */
83   function _transferOwnership(address _newOwner) internal {
84     require(_newOwner != address(0));
85     emit OwnershipTransferred(owner, _newOwner);
86     owner = _newOwner;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
91 
92 /**
93  * @title Pausable
94  * @dev Base contract which allows children to implement an emergency stop mechanism.
95  */
96 contract Pausable is Ownable {
97   event Pause();
98   event Unpause();
99 
100   bool public paused = false;
101 
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is not paused.
105    */
106   modifier whenNotPaused() {
107     require(!paused);
108     _;
109   }
110 
111   /**
112    * @dev Modifier to make a function callable only when the contract is paused.
113    */
114   modifier whenPaused() {
115     require(paused);
116     _;
117   }
118 
119   /**
120    * @dev called by the owner to pause, triggers stopped state
121    */
122   function pause() onlyOwner whenNotPaused public {
123     paused = true;
124     emit Pause();
125   }
126 
127   /**
128    * @dev called by the owner to unpause, returns to normal state
129    */
130   function unpause() onlyOwner whenPaused public {
131     paused = false;
132     emit Unpause();
133   }
134 }
135 
136 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
137 
138 /**
139  * @title SafeMath
140  * @dev Math operations with safety checks that throw on error
141  */
142 library SafeMath {
143 
144   /**
145   * @dev Multiplies two numbers, throws on overflow.
146   */
147   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
148     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
149     // benefit is lost if 'b' is also tested.
150     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151     if (a == 0) {
152       return 0;
153     }
154 
155     c = a * b;
156     assert(c / a == b);
157     return c;
158   }
159 
160   /**
161   * @dev Integer division of two numbers, truncating the quotient.
162   */
163   function div(uint256 a, uint256 b) internal pure returns (uint256) {
164     // assert(b > 0); // Solidity automatically throws when dividing by 0
165     // uint256 c = a / b;
166     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167     return a / b;
168   }
169 
170   /**
171   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
172   */
173   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174     assert(b <= a);
175     return a - b;
176   }
177 
178   /**
179   * @dev Adds two numbers, throws on overflow.
180   */
181   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
182     c = a + b;
183     assert(c >= a);
184     return c;
185   }
186 }
187 
188 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
189 
190 /**
191  * @title ERC20Basic
192  * @dev Simpler version of ERC20 interface
193  * @dev see https://github.com/ethereum/EIPs/issues/179
194  */
195 contract ERC20Basic {
196   function totalSupply() public view returns (uint256);
197   function balanceOf(address who) public view returns (uint256);
198   function transfer(address to, uint256 value) public returns (bool);
199   event Transfer(address indexed from, address indexed to, uint256 value);
200 }
201 
202 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
203 
204 /**
205  * @title ERC20 interface
206  * @dev see https://github.com/ethereum/EIPs/issues/20
207  */
208 contract ERC20 is ERC20Basic {
209   function allowance(address owner, address spender)
210     public view returns (uint256);
211 
212   function transferFrom(address from, address to, uint256 value)
213     public returns (bool);
214 
215   function approve(address spender, uint256 value) public returns (bool);
216   event Approval(
217     address indexed owner,
218     address indexed spender,
219     uint256 value
220   );
221 }
222 
223 // File: contracts/NokuTokenBurner.sol
224 
225 contract BurnableERC20 is ERC20 {
226     function burn(uint256 amount) public returns (bool burned);
227 }
228 
229 /**
230 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
231 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
232 */
233 contract NokuTokenBurner is Pausable {
234     using SafeMath for uint256;
235 
236     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
237     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
238 
239     // The wallet receiving the unburnt tokens.
240     address public wallet;
241 
242     // The percentage of tokens to burn after being received (range [0, 100])
243     uint256 public burningPercentage;
244 
245     // The cumulative amount of burnt tokens.
246     uint256 public burnedTokens;
247 
248     // The cumulative amount of tokens transferred back to the wallet.
249     uint256 public transferredTokens;
250 
251     /**
252     * @dev Create a new NokuTokenBurner with predefined burning fraction.
253     * @param _wallet The wallet receiving the unburnt tokens.
254     */
255     constructor(address _wallet) public {
256         require(_wallet != address(0), "_wallet is zero");
257         
258         wallet = _wallet;
259         burningPercentage = 100;
260 
261         emit LogNokuTokenBurnerCreated(msg.sender, _wallet);
262     }
263 
264     /**
265     * @dev Change the percentage of tokens to burn after being received.
266     * @param _burningPercentage The percentage of tokens to be burnt.
267     */
268     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
269         require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");
270         require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");
271         
272         burningPercentage = _burningPercentage;
273 
274         emit LogBurningPercentageChanged(msg.sender, _burningPercentage);
275     }
276 
277     /**
278     * @dev Called after burnable tokens has been transferred for burning.
279     * @param _token THe extended ERC20 interface supported by the sent tokens.
280     * @param _amount The amount of burnable tokens just arrived ready for burning.
281     */
282     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
283         require(_token != address(0), "_token is zero");
284         require(_amount > 0, "_amount is zero");
285 
286         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
287         if (amountToBurn > 0) {
288             assert(BurnableERC20(_token).burn(amountToBurn));
289             
290             burnedTokens = burnedTokens.add(amountToBurn);
291         }
292 
293         uint256 amountToTransfer = _amount.sub(amountToBurn);
294         if (amountToTransfer > 0) {
295             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
296 
297             transferredTokens = transferredTokens.add(amountToTransfer);
298         }
299     }
300 }
301 
302 // File: contracts/NokuFlatPlan.sol
303 
304 /**
305 * @dev The NokuFlatPlan contract implements a flat pricing plan, manageable by the contract owner.
306 */
307 contract NokuFlatPlan is NokuPricingPlan, Ownable {
308     using SafeMath for uint256;
309 
310     event LogNokuFlatPlanCreated(
311         address indexed caller,
312         uint256 indexed paymentInterval,
313         uint256 indexed flatFee,
314         address nokuMasterToken,
315         address tokenBurner
316     );
317     event LogPaymentIntervalChanged(address indexed caller, uint256 indexed paymentInterval);
318     event LogFlatFeeChanged(address indexed caller, uint256 indexed flatFee);
319 
320     // The validity time interval of the flat subscription. 
321     uint256 public paymentInterval;
322 
323     // When the next payment is required as timestamp in seconds from Unix epoch
324     uint256 public nextPaymentTime;
325 
326     // The fee amount expressed in NOKU tokens.
327     uint256 public flatFee;
328 
329     // The NOKU utility token used for paying fee  
330     address public nokuMasterToken;
331 
332     // The contract responsible for burning the NOKU tokens paid as service fee
333     address public tokenBurner;
334 
335     constructor(
336         uint256 _paymentInterval,
337         uint256 _flatFee,
338         address _nokuMasterToken,
339         address _tokenBurner
340     )
341     public
342     {
343         require(_paymentInterval != 0, "_paymentInterval is zero");
344         require(_flatFee != 0, "_flatFee is zero");
345         require(_nokuMasterToken != 0, "_nokuMasterToken is zero");
346         require(_tokenBurner != 0, "_tokenBurner is zero");
347 
348         paymentInterval = _paymentInterval;
349         flatFee = _flatFee;
350         nokuMasterToken = _nokuMasterToken;
351         tokenBurner = _tokenBurner;
352 
353         nextPaymentTime = block.timestamp;
354 
355         emit LogNokuFlatPlanCreated(
356             msg.sender,
357             _paymentInterval,
358             _flatFee,
359             _nokuMasterToken,
360             _tokenBurner
361         );
362     }
363 
364     function setPaymentInterval(uint256 _paymentInterval) public onlyOwner {
365         require(_paymentInterval != 0, "_paymentInterval is zero");
366         require(_paymentInterval != paymentInterval, "_paymentInterval equal to current one");
367 
368         paymentInterval = _paymentInterval;
369 
370         emit LogPaymentIntervalChanged(msg.sender, _paymentInterval);
371     }
372 
373     function setFlatFee(uint256 _flatFee) public onlyOwner {
374         require(_flatFee != 0, "_flatFee is zero");
375         require(_flatFee != flatFee, "_flatFee equal to current one");
376 
377         flatFee = _flatFee;
378 
379         emit LogFlatFeeChanged(msg.sender, _flatFee);
380     }
381 
382     function isValidService(bytes32 _serviceName) public pure returns(bool isValid) {
383         return _serviceName != 0;
384     }
385 
386     /**
387     * @dev Defines the operation by checking if flat fee has been paid or not.
388     */
389     function payFee(bytes32 _serviceName, uint256 _multiplier, address _client) public returns(bool paid) {
390         require(isValidService(_serviceName), "_serviceName in invalid");
391         require(_multiplier != 0, "_multiplier is zero");
392         require(_client != 0, "_client is zero");
393         
394         require(block.timestamp < nextPaymentTime);
395 
396         return true;
397     }
398 
399     function usageFee(bytes32 /*_serviceName*/, uint256 /*_multiplier*/) public view returns(uint fee) {
400         return 0;
401     }
402 
403     function paySubscription(address _client) public returns(bool paid) {
404         require(_client != 0, "_client is zero");
405 
406         nextPaymentTime = nextPaymentTime.add(paymentInterval);
407 
408         assert(ERC20(nokuMasterToken).transferFrom(_client, tokenBurner, flatFee));
409 
410         NokuTokenBurner(tokenBurner).tokenReceived(nokuMasterToken, flatFee);
411 
412         return true;
413     }
414 }