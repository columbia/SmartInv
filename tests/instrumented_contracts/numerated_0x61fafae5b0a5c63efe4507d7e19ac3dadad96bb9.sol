1 pragma solidity 0.4.19;
2 
3 // File: contracts/NokuPricingPlan.sol
4 
5 /**
6 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
7 */
8 interface NokuPricingPlan {
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
29 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
65     OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
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
105     Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused public {
112     paused = false;
113     Unpause();
114   }
115 }
116 
117 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
128   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129     if (a == 0) {
130       return 0;
131     }
132     uint256 c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return c;
145   }
146 
147   /**
148   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
164 
165 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
179 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
224     function NokuTokenBurner(address _wallet) public {
225         require(_wallet != address(0));
226         
227         wallet = _wallet;
228         burningPercentage = 100;
229 
230         LogNokuTokenBurnerCreated(msg.sender, _wallet);
231     }
232 
233     /**
234     * @dev Change the percentage of tokens to burn after being received.
235     * @param _burningPercentage The percentage of tokens to be burnt.
236     */
237     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
238         require(0 <= _burningPercentage && _burningPercentage <= 100);
239         require(_burningPercentage != burningPercentage);
240         
241         burningPercentage = _burningPercentage;
242 
243         LogBurningPercentageChanged(msg.sender, _burningPercentage);
244     }
245 
246     /**
247     * @dev Called after burnable tokens has been transferred for burning.
248     * @param _token THe extended ERC20 interface supported by the sent tokens.
249     * @param _amount The amount of burnable tokens just arrived ready for burning.
250     */
251     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
252         require(_token != address(0));
253         require(_amount > 0);
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
271 // File: contracts/NokuConsumptionPlan.sol
272 
273 /**
274 * @dev The NokuConsumptionPlan contract implements a flexible pricing plan, manageable by the contract owner, which can be:
275 * - extended by inserting a new service with its associated fee
276 * - modified by updating an existing service fee
277 * - reduced by removing an existing service with its associated fee
278 * - queried to obtain the count of services
279 * The service [name, fee] association is maintained using an index in order to make the data traversable.
280 */
281 contract NokuConsumptionPlan is NokuPricingPlan, Ownable {
282     using SafeMath for uint256;
283 
284     event LogNokuConsumptionPlanCreated(address indexed caller, address indexed nokuMasterToken, address indexed tokenBurner);
285     event LogServiceAdded(bytes32 indexed serviceName, uint indexed index, uint indexed serviceFee);
286     event LogServiceChanged(bytes32 indexed serviceName, uint indexed index, uint indexed serviceFee);
287     event LogServiceRemoved(bytes32 indexed serviceName, uint indexed index);
288     
289     struct NokuService {
290         uint serviceFee;
291         uint index;
292     }
293 
294     bytes32[] private serviceIndex;
295 
296     mapping(bytes32 => NokuService) private services;
297 
298     // The NOKU utility token used for paying fee  
299     address public nokuMasterToken;
300 
301     // The contract responsible for burning the NOKU tokens paid as service fee
302     address public tokenBurner;
303 
304     function NokuConsumptionPlan(address _nokuMasterToken, address _tokenBurner) public {
305         require(_nokuMasterToken != 0);
306         require(_tokenBurner != 0);
307 
308         nokuMasterToken = _nokuMasterToken;
309         tokenBurner = _tokenBurner;
310 
311         LogNokuConsumptionPlanCreated(msg.sender, _nokuMasterToken, _tokenBurner);
312     }
313 
314     function isService(bytes32 _serviceName) public constant returns(bool isIndeed) {
315         require(_serviceName != 0);
316 
317         if (serviceIndex.length == 0)
318             return false;
319         else
320             return (serviceIndex[services[_serviceName].index] == _serviceName);
321     }
322 
323     function addService(bytes32 _serviceName, uint _serviceFee) public onlyOwner returns(uint index) {
324         require(!isService(_serviceName));
325         
326         services[_serviceName].serviceFee = _serviceFee;
327         services[_serviceName].index = serviceIndex.push(_serviceName)-1;
328 
329         LogServiceAdded(_serviceName, serviceIndex.length-1, _serviceFee);
330 
331         return serviceIndex.length-1;
332     }
333 
334     function removeService(bytes32 _serviceName) public onlyOwner returns(uint index) {
335         require(isService(_serviceName));
336 
337         uint rowToDelete = services[_serviceName].index;
338         bytes32 keyToMove = serviceIndex[serviceIndex.length-1];
339         serviceIndex[rowToDelete] = keyToMove;
340         services[keyToMove].index = rowToDelete; 
341         serviceIndex.length--;
342 
343         LogServiceRemoved(_serviceName,  rowToDelete);
344         LogServiceChanged(keyToMove, rowToDelete, services[keyToMove].serviceFee);
345 
346         return rowToDelete;
347     }
348 
349     function updateServiceFee(bytes32 _serviceName, uint _serviceFee) public onlyOwner returns(bool success) {
350         require(isService(_serviceName));
351 
352         services[_serviceName].serviceFee = _serviceFee;
353 
354         LogServiceChanged(_serviceName, services[_serviceName].index, _serviceFee);
355 
356         return true;
357     }
358 
359     function payFee(bytes32 _serviceName, uint256 _multiplier, address _client) public returns(bool paid) {
360         //require(isService(_serviceName)); // Already checked by #usageFee
361         //require(_multiplier != 0); // Already checked by #usageFee
362         require(_client != 0);
363 
364         uint256 fee = usageFee(_serviceName, _multiplier);
365 
366         assert(ERC20(nokuMasterToken).transferFrom(_client, tokenBurner, fee));
367 
368         NokuTokenBurner(tokenBurner).tokenReceived(nokuMasterToken, fee);
369 
370         return true;
371     }
372 
373     function usageFee(bytes32 _serviceName, uint256 _multiplier) public constant returns(uint fee) {
374         require(isService(_serviceName));
375         require(_multiplier != 0);
376         
377         return _multiplier.mul(services[_serviceName].serviceFee);
378     }
379 
380     function serviceCount() public constant returns(uint count) {
381         return serviceIndex.length;
382     }
383 
384     function serviceAtIndex(uint _index) public constant returns(bytes32 serviceName) {
385         return serviceIndex[_index];
386     }
387 }