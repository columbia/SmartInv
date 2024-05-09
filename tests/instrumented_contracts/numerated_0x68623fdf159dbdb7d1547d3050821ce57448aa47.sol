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
308 contract SecurityDeposit is CATContract {
309     uint public depositorLimit = 100;
310     uint public instanceId = 1;
311     mapping(uint => SecurityInstance) public instances;
312     
313     event SecurityDepositCreated(uint indexed id, address indexed instOwner, string ownerNote, string depositPurpose, uint depositAmount);
314     event Deposit(uint indexed id, address indexed depositor, uint depositAmount, string note);
315     event DepositClaimed(uint indexed id, address indexed fromWho, uint amountClaimed);
316     event RefundSent(uint indexed id, address indexed toWho, uint amountRefunded);
317 
318     event DepositorLimitChanged(uint oldLimit, uint newLimit);
319 
320     enum DepositorState {None, Active, Claimed, Refunded}
321     
322     struct SecurityInstance {
323         uint instId;
324         address instOwner;
325         string ownerNote;
326         string depositPurpose;
327         uint depositAmount;
328         mapping(address => DepositorState) depositorState;
329         mapping(address => string) depositorNote;
330         address[] depositors;
331     }
332     
333     modifier onlyInstanceOwner(uint _instId) {
334         require(instances[_instId].instOwner == msg.sender);
335         _;
336     }
337     
338     modifier instanceExists(uint _instId) {
339         require(instances[_instId].instId == _instId);
340         _;
341     }
342 
343     // Chain constructor to pass along CAT payment address, and contract name
344     function SecurityDeposit(address _catPaymentCollector) CATContract(_catPaymentCollector, "Security Deposit") {}
345     
346     function createNewSecurityDeposit(string _ownerNote, string _depositPurpose, uint _depositAmount) external blockCatEntryPoint whenNotPaused returns (uint currentId) {
347         // Deposit can't be greater than maximum allowed for each user
348         require(_depositAmount <= ethPerTransactionLimit);
349         // Cannot have a 0 deposit security deposit
350         require(_depositAmount > 0);
351 
352         currentId = instanceId;
353         address instanceOwner = msg.sender;
354         uint depositAmountETH = _depositAmount;
355         SecurityInstance storage curInst = instances[currentId];
356 
357         curInst.instId = currentId;
358         curInst.instOwner = instanceOwner;
359         curInst.ownerNote = _ownerNote;
360         curInst.depositPurpose = _depositPurpose;
361         curInst.depositAmount = depositAmountETH;
362         
363         SecurityDepositCreated(currentId, instanceOwner, _ownerNote, _depositPurpose, depositAmountETH);
364         instanceId++;
365     }
366     
367     function deposit(uint _instId, string _note) external payable instanceExists(_instId) limitTransactionValue whenNotPaused {
368         SecurityInstance storage curInst = instances[_instId];
369         // Must deposit the right amount
370         require(curInst.depositAmount == msg.value);
371         // Cannot have more depositors than the limit
372         require(curInst.depositors.length < depositorLimit);
373         // Cannot double-deposit
374         require(curInst.depositorState[msg.sender] == DepositorState.None);
375 
376         curInst.depositorState[msg.sender] = DepositorState.Active;
377         curInst.depositorNote[msg.sender] = _note;
378         curInst.depositors.push(msg.sender);
379         
380         Deposit(curInst.instId, msg.sender, msg.value, _note);
381     }
382     
383     function claim(uint _instId, address _whoToClaim) public onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused returns (bool) {
384         SecurityInstance storage curInst = instances[_instId];
385         
386         // Can only call if the state is active
387         if(curInst.depositorState[_whoToClaim] != DepositorState.Active) {
388             return false;
389         }
390 
391         curInst.depositorState[_whoToClaim] = DepositorState.Claimed;
392         curInst.instOwner.transfer(curInst.depositAmount);
393         DepositClaimed(_instId, _whoToClaim, curInst.depositAmount);
394         
395         return true;
396     }
397     
398     function refund(uint _instId, address _whoToRefund) public onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused returns (bool) {
399         SecurityInstance storage curInst = instances[_instId];
400         
401         // Can only call if state is active
402         if(curInst.depositorState[_whoToRefund] != DepositorState.Active) {
403             return false;
404         }
405 
406         curInst.depositorState[_whoToRefund] = DepositorState.Refunded;
407         _whoToRefund.transfer(curInst.depositAmount);
408         RefundSent(_instId, _whoToRefund, curInst.depositAmount);
409         
410         return true;
411     }
412     
413     function claimFromSeveral(uint _instId, address[] _toClaim) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {
414         for(uint i = 0; i < _toClaim.length; i++) {
415             claim(_instId, _toClaim[i]);
416         }
417     }
418     
419     function refundFromSeveral(uint _instId, address[] _toRefund) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {
420         for(uint i = 0; i < _toRefund.length; i++) {
421             refund(_instId, _toRefund[i]);
422         }
423     }
424     
425     function claimAll(uint _instId) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {
426         SecurityInstance storage curInst = instances[_instId];
427         
428         for(uint i = 0; i < curInst.depositors.length; i++) {
429             claim(_instId, curInst.depositors[i]);
430         }
431     }
432     
433     function refundAll(uint _instId) external onlyInstanceOwner(_instId) instanceExists(_instId) whenNotPaused {
434         SecurityInstance storage curInst = instances[_instId];
435         
436         for(uint i = 0; i < curInst.depositors.length; i++) {
437             refund(_instId, curInst.depositors[i]);
438         }
439     }
440 
441     function changeDepositorLimit(uint _newLimit) external onlyOwner {
442         DepositorLimitChanged(depositorLimit, _newLimit);
443         depositorLimit = _newLimit;
444     }
445     
446     // Information functions
447     
448     function getInstanceMetadata(uint _instId) constant external returns (address instOwner, string ownerNote, string depositPurpose, uint depositAmount) {
449         instOwner = instances[_instId].instOwner;
450         ownerNote = instances[_instId].ownerNote;
451         depositPurpose = instances[_instId].depositPurpose;
452         depositAmount = instances[_instId].depositAmount;
453     }
454     
455     function getAllDepositors(uint _instId) constant external returns (address[]) {
456         return instances[_instId].depositors;
457     }
458     
459     function checkInfo(uint _instId, address _depositor) constant external returns (DepositorState depositorState, string note) {
460         depositorState = instances[_instId].depositorState[_depositor];
461         note = instances[_instId].depositorNote[_depositor];
462     }
463 
464     // Metrics
465 
466     function getDepositInstanceCount() constant external returns (uint) {
467         return instanceId - 1; // ID is 1-indexed
468     }
469 }