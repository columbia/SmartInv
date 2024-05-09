1 pragma solidity ^0.4.24;
2 
3 contract Multiownable {
4 
5     bool public paused = false;
6     uint256 public howManyOwnersDecide;
7     address[] public owners;
8     bytes32[] public allOperations;
9     address internal insideCallSender;
10     uint256 internal insideCallCount;
11 
12     mapping(address => uint) public ownersIndices; // Starts from 1
13     mapping(bytes32 => uint) public allOperationsIndicies;
14 
15     mapping(bytes32 => uint256) public votesMaskByOperation;
16     mapping(bytes32 => uint256) public votesCountByOperation;
17 
18     event OperationCreated(bytes32 operation, uint howMany, uint ownersCount, address proposer);
19     event OperationUpvoted(bytes32 operation, uint votes, uint howMany, uint ownersCount, address upvoter);
20     event OperationPerformed(bytes32 operation, uint howMany, uint ownersCount, address performer);
21     event OperationDownvoted(bytes32 operation, uint votes, uint ownersCount,  address downvoter);
22     event OperationCancelled(bytes32 operation, address lastCanceller);
23     event OwnershipRenounced(address indexed previousOwner);
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25     event Pause();
26     event Unpause();
27 
28     function isOwner(address wallet) public constant returns(bool) {
29         return ownersIndices[wallet] > 0;
30     }
31 
32     function ownersCount() public view returns(uint) {
33         return owners.length;
34     }
35 
36     function allOperationsCount() public  view returns(uint) {
37         return allOperations.length;
38     }
39 
40     modifier onlyAnyOwner {
41         if (checkHowManyOwners(1)) {
42             bool update = (insideCallSender == address(0));
43             if (update) {
44                 insideCallSender = msg.sender;
45                 insideCallCount = 1;
46             }
47             _;
48             if (update) {
49                 insideCallSender = address(0);
50                 insideCallCount = 0;
51             }
52         }
53     }
54 
55     modifier onlyManyOwners {
56         if (checkHowManyOwners(howManyOwnersDecide)) {
57             bool update = (insideCallSender == address(0));
58             if (update) {
59                 insideCallSender = msg.sender;
60                 insideCallCount = howManyOwnersDecide;
61             }
62             _;
63             if (update) {
64                 insideCallSender = address(0);
65                 insideCallCount = 0;
66             }
67         }
68     }
69 
70     constructor() public {  }
71 
72     function checkHowManyOwners(uint howMany) internal returns(bool) {
73         if (insideCallSender == msg.sender) {
74             require(howMany <= insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");
75             return true;
76         }
77 
78         uint ownerIndex = ownersIndices[msg.sender] - 1;
79         require(ownerIndex < owners.length, "checkHowManyOwners: msg.sender is not an owner");
80         bytes32 operation = keccak256(abi.encodePacked(msg.data));
81 
82         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");
83         votesMaskByOperation[operation] |= (2 ** ownerIndex);
84         uint operationVotesCount = votesCountByOperation[operation] + 1;
85         votesCountByOperation[operation] = operationVotesCount;
86         if (operationVotesCount == 1) {
87             allOperationsIndicies[operation] = allOperations.length;
88             allOperations.push(operation);
89             emit OperationCreated(operation, howMany, owners.length, msg.sender);
90         }
91         emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);
92 
93         // If enough owners confirmed the same operation
94         if (votesCountByOperation[operation] == howMany) {
95             deleteOperation(operation);
96             emit OperationPerformed(operation, howMany, owners.length, msg.sender);
97             return true;
98         }
99 
100         return false;
101     }
102 
103     function deleteOperation(bytes32 operation) internal {
104         uint index = allOperationsIndicies[operation];
105         if (index < allOperations.length - 1) { // Not last
106             allOperations[index] = allOperations[allOperations.length - 1];
107             allOperationsIndicies[allOperations[index]] = index;
108         }
109         allOperations.length--;
110 
111         delete votesMaskByOperation[operation];
112         delete votesCountByOperation[operation];
113         delete allOperationsIndicies[operation];
114     }
115 
116     function cancelPending(bytes32 operation) public onlyAnyOwner {
117         uint ownerIndex = ownersIndices[msg.sender] - 1;
118         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0, "cancelPending: operation not found for this user");
119         votesMaskByOperation[operation] &= ~(2 ** ownerIndex);
120         uint operationVotesCount = votesCountByOperation[operation] - 1;
121         votesCountByOperation[operation] = operationVotesCount;
122         emit OperationDownvoted(operation, operationVotesCount, owners.length, msg.sender);
123         if (operationVotesCount == 0) {
124             deleteOperation(operation);
125             emit OperationCancelled(operation, msg.sender);
126         }
127     }
128 
129     function transferOwnership(address _newOwner, address _oldOwner) public onlyManyOwners {
130         _transferOwnership(_newOwner, _oldOwner);
131     }
132 
133     function _transferOwnership(address _newOwner, address _oldOwner) internal {
134         require(_newOwner != address(0));
135 
136         for(uint256 i = 0; i < owners.length; i++) {
137             if (_oldOwner == owners[i]) {
138                 owners[i] = _newOwner;
139                 ownersIndices[_newOwner] = ownersIndices[_oldOwner];
140                 ownersIndices[_oldOwner] = 0;
141                 break;
142             }
143         }
144         emit OwnershipTransferred(_oldOwner, _newOwner);
145     }
146 
147     modifier whenNotPaused() {
148         require(!paused);
149         _;
150     }
151 
152     modifier whenPaused() {
153         require(paused);
154         _;
155     }
156 
157     function pause() public onlyManyOwners whenNotPaused {
158 
159         paused = true;
160         emit Pause();
161     }
162 
163     function unpause() public onlyManyOwners whenPaused {
164         paused = false;
165         emit Unpause();
166     }
167 }
168 
169 contract GovernanceMigratable is Multiownable {
170     mapping(address => bool) public governanceContracts;
171 
172     event GovernanceContractAdded(address addr);
173     event GovernanceContractRemoved(address addr);
174 
175     modifier onlyGovernanceContracts() {
176         require(governanceContracts[msg.sender]);
177         _;
178     }
179 
180     function addAddressToGovernanceContract(address addr) onlyManyOwners public returns(bool success) {
181         if (!governanceContracts[addr]) {
182             governanceContracts[addr] = true;
183             emit GovernanceContractAdded(addr);
184             success = true;
185         }
186     }
187 
188     function removeAddressFromGovernanceContract(address addr) onlyManyOwners public returns(bool success) {
189         if (governanceContracts[addr]) {
190             governanceContracts[addr] = false;
191             emit GovernanceContractRemoved(addr);
192             success = true;
193         }
194     }
195 }
196 
197 contract ERC20Basic {
198     function totalSupply() public view returns (uint256);
199     function balanceOf(address _who) public view returns (uint256);
200     function transfer(address _to, uint256 _value) public returns (bool);
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 }
203 
204 library SafeMath {
205 
206     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
207 
208         if (_a == 0) {
209             return 0;
210         }
211 
212         c = _a * _b;
213         assert(c / _a == _b);
214         return c;
215     }
216 
217     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
218 
219 
220         return _a / _b;
221     }
222 
223     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
224         assert(_b <= _a);
225         return _a - _b;
226     }
227 
228 
229     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
230         c = _a + _b;
231         assert(c >= _a);
232         return c;
233     }
234 }
235 
236 contract BasicToken is ERC20Basic {
237     using SafeMath for uint256;
238 
239     mapping(address => uint256) internal balances;
240 
241     uint256 internal totalSupply_;
242 
243     /**
244     * @dev Total number of tokens in existence
245     */
246     function totalSupply() public view returns (uint256) {
247         return totalSupply_;
248     }
249 
250     /**
251     * @dev Transfer token for a specified address
252     * @param _to The address to transfer to.
253     * @param _value The amount to be transferred.
254     */
255     function transfer(address _to, uint256 _value) public returns (bool) {
256         require(_value <= balances[msg.sender]);
257         require(_to != address(0));
258 
259         balances[msg.sender] = balances[msg.sender].sub(_value);
260         balances[_to] = balances[_to].add(_value);
261         emit Transfer(msg.sender, _to, _value);
262         return true;
263     }
264 
265     /**
266     * @dev Gets the balance of the specified address.
267     * @param _owner The address to query the the balance of.
268     * @return An uint256 representing the amount owned by the passed address.
269     */
270     function balanceOf(address _owner) public view returns (uint256) {
271         return balances[_owner];
272     }
273 
274 }
275 
276 contract ERC20 is ERC20Basic {
277     function allowance(address _owner, address _spender)
278     public view returns (uint256);
279 
280     function transferFrom(address _from, address _to, uint256 _value)
281     public returns (bool);
282 
283     function approve(address _spender, uint256 _value) public returns (bool);
284     event Approval(
285         address indexed owner,
286         address indexed spender,
287         uint256 value
288     );
289 }
290 
291 contract StandardToken is ERC20, BasicToken {
292 
293     mapping (address => mapping (address => uint256)) internal allowed;
294 
295 
296     /**
297      * @dev Transfer tokens from one address to another
298      * @param _from address The address which you want to send tokens from
299      * @param _to address The address which you want to transfer to
300      * @param _value uint256 the amount of tokens to be transferred
301      */
302     function transferFrom(
303         address _from,
304         address _to,
305         uint256 _value
306     )
307     public
308     returns (bool)
309     {
310         require(_value <= balances[_from]);
311         require(_value <= allowed[_from][msg.sender]);
312         require(_to != address(0));
313 
314         balances[_from] = balances[_from].sub(_value);
315         balances[_to] = balances[_to].add(_value);
316         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317         emit Transfer(_from, _to, _value);
318         return true;
319     }
320 
321     /**
322      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323      * Beware that changing an allowance with this method brings the risk that someone may use both the old
324      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
325      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
326      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
327      * @param _spender The address which will spend the funds.
328      * @param _value The amount of tokens to be spent.
329      */
330     function approve(address _spender, uint256 _value) public returns (bool) {
331         allowed[msg.sender][_spender] = _value;
332         emit Approval(msg.sender, _spender, _value);
333         return true;
334     }
335 
336     /**
337      * @dev Function to check the amount of tokens that an owner allowed to a spender.
338      * @param _owner address The address which owns the funds.
339      * @param _spender address The address which will spend the funds.
340      * @return A uint256 specifying the amount of tokens still available for the spender.
341      */
342     function allowance(
343         address _owner,
344         address _spender
345     )
346     public
347     view
348     returns (uint256)
349     {
350         return allowed[_owner][_spender];
351     }
352 
353     /**
354      * @dev Increase the amount of tokens that an owner allowed to a spender.
355      * approve should be called when allowed[_spender] == 0. To increment
356      * allowed value is better to use this function to avoid 2 calls (and wait until
357      * the first transaction is mined)
358      * From MonolithDAO Token.sol
359      * @param _spender The address which will spend the funds.
360      * @param _addedValue The amount of tokens to increase the allowance by.
361      */
362     function increaseApproval(
363         address _spender,
364         uint256 _addedValue
365     )
366     public
367     returns (bool)
368     {
369         allowed[msg.sender][_spender] = (
370         allowed[msg.sender][_spender].add(_addedValue));
371         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
372         return true;
373     }
374 
375     /**
376      * @dev Decrease the amount of tokens that an owner allowed to a spender.
377      * approve should be called when allowed[_spender] == 0. To decrement
378      * allowed value is better to use this function to avoid 2 calls (and wait until
379      * the first transaction is mined)
380      * From MonolithDAO Token.sol
381      * @param _spender The address which will spend the funds.
382      * @param _subtractedValue The amount of tokens to decrease the allowance by.
383      */
384     function decreaseApproval(
385         address _spender,
386         uint256 _subtractedValue
387     )
388     public
389     returns (bool)
390     {
391         uint256 oldValue = allowed[msg.sender][_spender];
392         if (_subtractedValue >= oldValue) {
393             allowed[msg.sender][_spender] = 0;
394         } else {
395             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
396         }
397         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398         return true;
399     }
400 
401 }
402 
403 contract DetailedERC20 is ERC20 {
404     string public name;
405     string public symbol;
406     uint8 public decimals;
407 
408     constructor(string _name, string _symbol, uint8 _decimals) public {
409         name = _name;
410         symbol = _symbol;
411         decimals = _decimals;
412     }
413 }
414 
415 contract QDAOBurnableToken is BasicToken {
416 
417     event Burn(address indexed burner, uint256 value);
418 
419     function _burn(address _who, uint256 _value) internal {
420         require(_value <= balances[_who]);
421 
422         balances[_who] = balances[_who].sub(_value);
423         totalSupply_ = totalSupply_.sub(_value);
424         emit Burn(_who, _value);
425         emit Transfer(_who, address(0), _value);
426     }
427 }
428 
429 contract QDAOPausableToken is StandardToken, GovernanceMigratable {
430 
431     function transfer(
432         address _to,
433         uint256 _value
434     )
435     public
436     whenNotPaused
437     returns (bool)
438     {
439         return super.transfer(_to, _value);
440     }
441 
442     function transferFrom(
443         address _from,
444         address _to,
445         uint256 _value
446     )
447     public
448     whenNotPaused
449     returns (bool)
450     {
451         return super.transferFrom(_from, _to, _value);
452     }
453 
454     function approve(
455         address _spender,
456         uint256 _value
457     )
458     public
459     whenNotPaused
460     returns (bool)
461     {
462         return super.approve(_spender, _value);
463     }
464 
465     function increaseApproval(
466         address _spender,
467         uint _addedValue
468     )
469     public
470     whenNotPaused
471     returns (bool success)
472     {
473         return super.increaseApproval(_spender, _addedValue);
474     }
475 
476     function decreaseApproval(
477         address _spender,
478         uint _subtractedValue
479     )
480     public
481     whenNotPaused
482     returns (bool success)
483     {
484         return super.decreaseApproval(_spender, _subtractedValue);
485     }
486 }
487 
488 contract QDAO is StandardToken, QDAOBurnableToken, DetailedERC20, QDAOPausableToken  {
489 
490     event Mint(address indexed to, uint256 amount);
491 
492     uint8 constant DECIMALS = 18;
493 
494     constructor(address _firstOwner,
495         address _secondOwner,
496         address _thirdOwner,
497         address _fourthOwner,
498         address _fifthOwner) DetailedERC20("Q DAO Governance token v1.0", "QDAO", DECIMALS) public {
499 
500         owners.push(_firstOwner);
501         owners.push(_secondOwner);
502         owners.push(_thirdOwner);
503         owners.push(_fourthOwner);
504         owners.push(_fifthOwner);
505         owners.push(msg.sender);
506 
507         ownersIndices[_firstOwner] = 1;
508         ownersIndices[_secondOwner] = 2;
509         ownersIndices[_thirdOwner] = 3;
510         ownersIndices[_fourthOwner] = 4;
511         ownersIndices[_fifthOwner] = 5;
512         ownersIndices[msg.sender] = 6;
513 
514         howManyOwnersDecide = 4;
515     }
516 
517     function mint(address _to, uint256 _amount) external onlyGovernanceContracts() returns (bool){
518         totalSupply_ = totalSupply_.add(_amount);
519         balances[_to] = balances[_to].add(_amount);
520         emit Mint(_to, _amount);
521         emit Transfer(address(0), _to, _amount);
522         return true;
523     }
524 
525     function approveForOtherContracts(address _sender, address _spender, uint256 _value) external onlyGovernanceContracts() {
526         allowed[_sender][_spender] = _value;
527         emit Approval(_sender, _spender, _value);
528     }
529 
530     function burnFrom(address _to, uint256 _amount) external onlyGovernanceContracts() returns (bool) {
531         allowed[_to][msg.sender] = _amount;
532         transferFrom(_to, msg.sender, _amount);
533         _burn(msg.sender, _amount);
534         return true;
535     }
536 
537     function transferMany(address[] _recipients, uint[] _values) public onlyGovernanceContracts() {
538         require(_recipients.length == _values.length);
539         require(_recipients.length > 0);
540 
541         for(uint i = 0; i < _recipients.length; i++) {
542             address recipient = _recipients[i];
543             uint value = _values[i];
544 
545             require(recipient != address(0) && value != 0);
546 
547             balances[msg.sender] = balances[msg.sender].sub(value);
548             balances[recipient] = balances[recipient].add(value);
549             emit Transfer(msg.sender, recipient, value);
550         }
551     }
552 }