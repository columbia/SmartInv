1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 contract Pausable is Ownable {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69 
70   /**
71    * @dev modifier to allow actions only when the contract IS paused
72    */
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   /**
79    * @dev modifier to allow actions only when the contract IS NOT paused
80    */
81   modifier whenPaused {
82     require(paused);
83     _;
84   }
85 
86   /**
87    * @dev called by the owner to pause, triggers stopped state
88    */
89   function pause() onlyOwner whenNotPaused returns (bool) {
90     paused = true;
91     Pause();
92     return true;
93   }
94 
95   /**
96    * @dev called by the owner to unpause, returns to normal state
97    */
98   function unpause() onlyOwner whenPaused returns (bool) {
99     paused = false;
100     Unpause();
101     return true;
102   }
103 }
104 
105 contract ERC20Basic {
106   uint256 public totalSupply;
107   function balanceOf(address who) constant returns (uint256);
108   function transfer(address to, uint256 value) returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) returns (bool) {
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of. 
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) constant returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) constant returns (uint256);
142   function transferFrom(address from, address to, uint256 value) returns (bool);
143   function approve(address spender, uint256 value) returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amout of tokens to be transfered
157    */
158   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
159     var _allowance = allowed[_from][msg.sender];
160 
161     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
162     // require (_value <= _allowance);
163 
164     balances[_to] = balances[_to].add(_value);
165     balances[_from] = balances[_from].sub(_value);
166     allowed[_from][msg.sender] = _allowance.sub(_value);
167     Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) returns (bool) {
177 
178     // To change the approve amount you first have to reduce the addresses`
179     //  allowance to zero by calling `approve(_spender, 0)` if it is not
180     //  already 0 to mitigate the race condition described here:
181     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
183 
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifing the amount of tokens still avaible for the spender.
194    */
195   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199 }
200 
201 contract CATContract is Ownable, Pausable {
202 	CATServicePaymentCollector public catPaymentCollector;
203 	uint public contractFee = 0.1 * 10**18; // Base fee is 0.1 CAT
204 	// Limits all transactions to a small amount to avoid financial risk with early code
205 	uint public ethPerTransactionLimit = 0.1 ether;
206 	string public contractName;
207 	string public versionIdent = "0.1.0";
208 
209 	event ContractDeployed(address indexed byWho);
210 	event ContractFeeChanged(uint oldFee, uint newFee);
211 	event ContractEthLimitChanged(uint oldLimit, uint newLimit);
212 
213 	event CATWithdrawn(uint numOfTokens);
214 
215 	modifier blockCatEntryPoint() {
216 		// Collect payment
217 		catPaymentCollector.collectPayment(msg.sender, contractFee);
218 		ContractDeployed(msg.sender);
219 		_;
220 	}
221 
222 	modifier limitTransactionValue() {
223 		require(msg.value <= ethPerTransactionLimit);
224 		_;
225 	}
226 
227 	function CATContract(address _catPaymentCollector, string _contractName) {
228 		catPaymentCollector = CATServicePaymentCollector(_catPaymentCollector);
229 		contractName = _contractName;
230 	}
231 
232 	// Administrative functions
233 
234 	function changeContractFee(uint _newFee) external onlyOwner {
235 		// _newFee is assumed to be given in full CAT precision (18 decimals)
236 		ContractFeeChanged(contractFee, _newFee);
237 		contractFee = _newFee;
238 	}
239 
240 	function changeEtherTxLimit(uint _newLimit) external onlyOwner {
241 		ContractEthLimitChanged(ethPerTransactionLimit, _newLimit);
242 		ethPerTransactionLimit = _newLimit;
243 	}
244 
245 	function withdrawCAT() external onlyOwner {
246 		StandardToken CAT = catPaymentCollector.CAT();
247 		uint ourTokens = CAT.balanceOf(this);
248 		CAT.transfer(owner, ourTokens);
249 		CATWithdrawn(ourTokens);
250 	}
251 }
252 
253 contract CATServicePaymentCollector is Ownable {
254 	StandardToken public CAT;
255 	address public paymentDestination;
256 	uint public totalDeployments = 0;
257 	mapping(address => bool) public registeredServices;
258 	mapping(address => uint) public serviceDeployCount;
259 	mapping(address => uint) public userDeployCount;
260 
261 	event CATPayment(address indexed service, address indexed payer, uint price);
262 	event EnableService(address indexed service);
263 	event DisableService(address indexed service);
264 	event ChangedPaymentDestination(address indexed oldDestination, address indexed newDestination);
265 
266 	event CATWithdrawn(uint numOfTokens);
267 	
268 	function CATServicePaymentCollector(address _CAT) {
269 		CAT = StandardToken(_CAT);
270 		paymentDestination = msg.sender;
271 	}
272 	
273 	function enableService(address _service) public onlyOwner {
274 		registeredServices[_service] = true;
275 		EnableService(_service);
276 	}
277 	
278 	function disableService(address _service) public onlyOwner {
279 		registeredServices[_service] = false;
280 		DisableService(_service);
281 	}
282 	
283 	function collectPayment(address _fromWho, uint _payment) public {
284 		require(registeredServices[msg.sender] == true);
285 		
286 		serviceDeployCount[msg.sender]++;
287 		userDeployCount[_fromWho]++;
288 		totalDeployments++;
289 		
290 		CAT.transferFrom(_fromWho, paymentDestination, _payment);
291 		CATPayment(_fromWho, msg.sender, _payment);
292 	}
293 
294 	// Administrative functions
295 
296 	function changePaymentDestination(address _newPaymentDest) external onlyOwner {
297 		ChangedPaymentDestination(paymentDestination, _newPaymentDest);
298 		paymentDestination = _newPaymentDest;
299 	}
300 
301 	function withdrawCAT() external onlyOwner {
302 		uint ourTokens = CAT.balanceOf(this);
303 		CAT.transfer(owner, ourTokens);
304 		CATWithdrawn(ourTokens);
305 	}
306 }
307 
308 contract Hodl is CATContract {
309     uint public instanceId = 1;
310     mapping(uint => HodlInstance) public instances;
311 
312     uint public maximumHodlDuration = 4 weeks;
313 
314     event HodlCreated(uint indexed id, address indexed instOwner, uint hodlAmount, uint endTime);
315     event HodlWithdrawn(uint indexed id, address indexed byWho, uint hodlAmount);
316 
317     event MaximumHodlDurationChanged(uint oldLimit, uint newLimit);
318 
319     struct HodlInstance {
320         uint instId;
321         address instOwner;
322         bool hasBeenWithdrawn;
323         uint hodlAmount;
324         uint endTime;
325     }
326 
327     modifier onlyInstanceOwner(uint _instId) {
328         require(instances[_instId].instOwner == msg.sender);
329         _;
330     }
331     
332     modifier instanceExists(uint _instId) {
333         require(instances[_instId].instId == _instId);
334         _;
335     }
336 
337     // Chain constructor
338     function Hodl(address _catPaymentCollector) CATContract(_catPaymentCollector, "Hodl") {}
339 
340     function createNewHodl(uint _endTime) external payable blockCatEntryPoint limitTransactionValue whenNotPaused returns (uint currentId) {
341         // Cannot hodl in the past
342         require(_endTime >= now);
343         // Cannot hodl for longer than the max cap on duration
344         require((_endTime - now) <= maximumHodlDuration);
345         // Cannot hodl nothing
346         require(msg.value > 0);
347 
348         currentId = instanceId;
349         address instanceOwner = msg.sender;
350         uint hodlAmount = msg.value;
351         uint endTime = _endTime;
352         HodlInstance storage curInst = instances[currentId];
353 
354         curInst.instId = currentId;
355         curInst.instOwner = instanceOwner;
356         curInst.hasBeenWithdrawn = false;
357         curInst.hodlAmount = hodlAmount;
358         curInst.endTime = endTime;
359         
360         HodlCreated(currentId, instanceOwner, hodlAmount, endTime);
361         instanceId++;
362     }
363 
364     function withdraw(uint _instId) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {
365         HodlInstance storage curInst = instances[_instId];
366         // The hodl has passed its unlock date
367         require(now >= curInst.endTime);
368         // The hodl has not been withdrawn before
369         require(curInst.hasBeenWithdrawn == false);
370 
371         curInst.hasBeenWithdrawn = true;
372         curInst.instOwner.transfer(curInst.hodlAmount);
373         HodlWithdrawn(_instId, msg.sender, curInst.hodlAmount);
374     }
375 
376     function changeMaximumHodlDuration(uint _newLimit) external onlyOwner {
377         MaximumHodlDurationChanged(maximumHodlDuration, _newLimit);
378         maximumHodlDuration = _newLimit;
379     }
380 
381     // Information functions
382     function getHodlOwner(uint _instId) constant external returns (address) {
383         return instances[_instId].instOwner;
384     }
385 
386     function getHodlHasBeenWithdrawn(uint _instId) constant external returns (bool) {
387         return instances[_instId].hasBeenWithdrawn;
388     }
389 
390     function getHodlAmount(uint _instId) constant external returns (uint) {
391         return instances[_instId].hodlAmount;
392     }
393 
394     function getEndTime(uint _instId) constant external returns (uint) {
395         return instances[_instId].endTime;
396     }
397 
398     function getTimeUntilEnd(uint _instId) constant external returns (int) {
399         return int(instances[_instId].endTime - now);
400     }
401 }