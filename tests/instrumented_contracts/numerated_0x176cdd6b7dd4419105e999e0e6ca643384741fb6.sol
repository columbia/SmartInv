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
26     function usageFee(bytes32 serviceName, uint256 multiplier) public constant returns(uint fee);
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
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     emit OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = false;
82 
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is not paused.
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is paused.
94    */
95   modifier whenPaused() {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused public {
104     paused = true;
105     emit Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused public {
112     paused = false;
113     emit Unpause();
114   }
115 }
116 
117 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
118 
119 /**
120  * @title SafeMath
121  * @dev Math operations with safety checks that throw on error
122  */
123 library SafeMath {
124 
125   /**
126   * @dev Multiplies two numbers, throws on overflow.
127   */
128   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
129     if (a == 0) {
130       return 0;
131     }
132     c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     // uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return a / b;
145   }
146 
147   /**
148   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
159     c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
166 
167 /**
168  * @title ERC20Basic
169  * @dev Simpler version of ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/179
171  */
172 contract ERC20Basic {
173   function totalSupply() public view returns (uint256);
174   function balanceOf(address who) public view returns (uint256);
175   function transfer(address to, uint256 value) public returns (bool);
176   event Transfer(address indexed from, address indexed to, uint256 value);
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender) public view returns (uint256);
187   function transferFrom(address from, address to, uint256 value) public returns (bool);
188   function approve(address spender, uint256 value) public returns (bool);
189   event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 // File: contracts/NokuTokenBurner.sol
193 
194 contract BurnableERC20 is ERC20 {
195     function burn(uint256 amount) public returns (bool burned);
196 }
197 
198 /**
199 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
200 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
201 */
202 contract NokuTokenBurner is Pausable {
203     using SafeMath for uint256;
204 
205     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
206     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
207 
208     // The wallet receiving the unburnt tokens.
209     address public wallet;
210 
211     // The percentage of tokens to burn after being received (range [0, 100])
212     uint256 public burningPercentage;
213 
214     // The cumulative amount of burnt tokens.
215     uint256 public burnedTokens;
216 
217     // The cumulative amount of tokens transferred back to the wallet.
218     uint256 public transferredTokens;
219 
220     /**
221     * @dev Create a new NokuTokenBurner with predefined burning fraction.
222     * @param _wallet The wallet receiving the unburnt tokens.
223     */
224     constructor(address _wallet) public {
225         require(_wallet != address(0), "_wallet is zero");
226         
227         wallet = _wallet;
228         burningPercentage = 100;
229 
230         emit LogNokuTokenBurnerCreated(msg.sender, _wallet);
231     }
232 
233     /**
234     * @dev Change the percentage of tokens to burn after being received.
235     * @param _burningPercentage The percentage of tokens to be burnt.
236     */
237     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
238         require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");
239         require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");
240         
241         burningPercentage = _burningPercentage;
242 
243         emit LogBurningPercentageChanged(msg.sender, _burningPercentage);
244     }
245 
246     /**
247     * @dev Called after burnable tokens has been transferred for burning.
248     * @param _token THe extended ERC20 interface supported by the sent tokens.
249     * @param _amount The amount of burnable tokens just arrived ready for burning.
250     */
251     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
252         require(_token != address(0), "_token is zero");
253         require(_amount > 0, "_amount is zero");
254 
255         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
256         if (amountToBurn > 0) {
257             assert(BurnableERC20(_token).burn(amountToBurn));
258             
259             burnedTokens = burnedTokens.add(amountToBurn);
260         }
261 
262         uint256 amountToTransfer = _amount.sub(amountToBurn);
263         if (amountToTransfer > 0) {
264             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
265 
266             transferredTokens = transferredTokens.add(amountToTransfer);
267         }
268     }
269 }
270 
271 // File: contracts/NokuFlatPlan.sol
272 
273 /**
274 * @dev The NokuFlatPlan contract implements a flat pricing plan, manageable by the contract owner.
275 */
276 contract NokuFlatPlan is NokuPricingPlan, Ownable {
277     using SafeMath for uint256;
278 
279     event LogNokuFlatPlanCreated(
280         address indexed caller,
281         uint256 indexed paymentInterval,
282         uint256 indexed flatFee,
283         address nokuMasterToken,
284         address tokenBurner
285     );
286     event LogPaymentIntervalChanged(address indexed caller, uint256 indexed paymentInterval);
287     event LogFlatFeeChanged(address indexed caller, uint256 indexed flatFee);
288 
289     // The validity time interval of the flat subscription. 
290     uint256 public paymentInterval;
291 
292     // When the next payment is required as timestamp in seconds from Unix epoch
293     uint256 public nextPaymentTime;
294 
295     // The fee amount expressed in NOKU tokens.
296     uint256 public flatFee;
297 
298     // The NOKU utility token used for paying fee  
299     address public nokuMasterToken;
300 
301     // The contract responsible for burning the NOKU tokens paid as service fee
302     address public tokenBurner;
303 
304     constructor(
305         uint256 _paymentInterval,
306         uint256 _flatFee,
307         address _nokuMasterToken,
308         address _tokenBurner
309     )
310     public
311     {
312         require(_paymentInterval != 0, "_paymentInterval is zero");
313         require(_flatFee != 0, "_flatFee is zero");
314         require(_nokuMasterToken != 0, "_nokuMasterToken is zero");
315         require(_tokenBurner != 0, "_tokenBurner is zero");
316 
317         paymentInterval = _paymentInterval;
318         flatFee = _flatFee;
319         nokuMasterToken = _nokuMasterToken;
320         tokenBurner = _tokenBurner;
321 
322         nextPaymentTime = block.timestamp;
323 
324         emit LogNokuFlatPlanCreated(
325             msg.sender,
326             _paymentInterval,
327             _flatFee,
328             _nokuMasterToken,
329             _tokenBurner
330         );
331     }
332 
333     function setPaymentInterval(uint256 _paymentInterval) public onlyOwner {
334         require(_paymentInterval != 0, "_paymentInterval is zero");
335         require(_paymentInterval != paymentInterval, "_paymentInterval equal to current one");
336 
337         paymentInterval = _paymentInterval;
338 
339         emit LogPaymentIntervalChanged(msg.sender, _paymentInterval);
340     }
341 
342     function setFlatFee(uint256 _flatFee) public onlyOwner {
343         require(_flatFee != 0, "_flatFee is zero");
344         require(_flatFee != flatFee, "_flatFee equal to current one");
345 
346         flatFee = _flatFee;
347 
348         emit LogFlatFeeChanged(msg.sender, _flatFee);
349     }
350 
351     function isValidService(bytes32 _serviceName) public pure returns(bool isValid) {
352         return _serviceName != 0;
353     }
354 
355     /**
356     * @dev Defines the operation by checking if flat fee has been paid or not.
357     */
358     function payFee(bytes32 _serviceName, uint256 _multiplier, address _client) public returns(bool paid) {
359         require(isValidService(_serviceName), "_serviceName in invalid");
360         require(_multiplier != 0, "_multiplier is zero");
361         require(_client != 0, "_client is zero");
362         
363         require(block.timestamp < nextPaymentTime);
364 
365         return true;
366     }
367 
368     function usageFee(bytes32 _serviceName, uint256 _multiplier) public constant returns(uint fee) {
369         require(isValidService(_serviceName), "_serviceName in invalid");
370         require(_multiplier != 0, "_multiplier is zero");
371         
372         return 0;
373     }
374 
375     function paySubscription(address _client) public returns(bool paid) {
376         require(_client != 0, "_client is zero");
377 
378         nextPaymentTime = nextPaymentTime.add(paymentInterval);
379 
380         assert(ERC20(nokuMasterToken).transferFrom(_client, tokenBurner, flatFee));
381 
382         NokuTokenBurner(tokenBurner).tokenReceived(nokuMasterToken, flatFee);
383 
384         return true;
385     }
386 }