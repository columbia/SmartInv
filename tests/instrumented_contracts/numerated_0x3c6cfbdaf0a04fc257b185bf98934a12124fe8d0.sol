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
129 
130     function transferOwnership(address _newOwner, address _oldOwner) public onlyManyOwners {
131         _transferOwnership(_newOwner, _oldOwner);
132     }
133 
134     function _transferOwnership(address _newOwner, address _oldOwner) internal {
135         require(_newOwner != address(0));
136 
137         for(uint256 i = 0; i < owners.length; i++) {
138             if (_oldOwner == owners[i]) {
139                 owners[i] = _newOwner;
140                 ownersIndices[_newOwner] = ownersIndices[_oldOwner];
141                 ownersIndices[_oldOwner] = 0;
142                 break;
143             }
144         }
145         emit OwnershipTransferred(_oldOwner, _newOwner);
146     }
147 
148     modifier whenNotPaused() {
149         require(!paused);
150         _;
151     }
152 
153     modifier whenPaused() {
154         require(paused);
155         _;
156     }
157 
158     function pause() public onlyManyOwners whenNotPaused {
159 
160         paused = true;
161         emit Pause();
162     }
163 
164     function unpause() public onlyManyOwners whenPaused {
165         paused = false;
166         emit Unpause();
167     }
168 }
169 
170 contract GovernanceMigratable is Multiownable {
171     mapping(address => bool) public governanceContracts;
172 
173     event GovernanceContractAdded(address addr);
174     event GovernanceContractRemoved(address addr);
175 
176     modifier onlyGovernanceContracts() {
177         require(governanceContracts[msg.sender]);
178         _;
179     }
180 
181     function addAddressToGovernanceContract(address addr) onlyManyOwners public returns(bool success) {
182         if (!governanceContracts[addr]) {
183             governanceContracts[addr] = true;
184             emit GovernanceContractAdded(addr);
185             success = true;
186         }
187     }
188 
189     function removeAddressFromGovernanceContract(address addr) onlyManyOwners public returns(bool success) {
190         if (governanceContracts[addr]) {
191             governanceContracts[addr] = false;
192             emit GovernanceContractRemoved(addr);
193             success = true;
194         }
195     }
196 }
197 
198 contract BlacklistMigratable is GovernanceMigratable {
199     mapping(address => bool) public blacklist;
200 
201     event BlacklistedAddressAdded(address addr);
202     event BlacklistedAddressRemoved(address addr);
203 
204     function addAddressToBlacklist(address addr) onlyGovernanceContracts() public returns(bool success) {
205         if (!blacklist[addr]) {
206             blacklist[addr] = true;
207             emit BlacklistedAddressAdded(addr);
208             success = true;
209         }
210     }
211 
212     function removeAddressFromBlacklist(address addr) onlyGovernanceContracts() public returns(bool success) {
213         if (blacklist[addr]) {
214             blacklist[addr] = false;
215             emit BlacklistedAddressRemoved(addr);
216             success = true;
217         }
218     }
219 }
220 
221 library SafeMath {
222 
223     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
224 
225         if (_a == 0) {
226             return 0;
227         }
228         c = _a * _b;
229         assert(c / _a == _b);
230         return c;
231     }
232     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
233         return _a / _b;
234     }
235 
236     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
237         assert(_b <= _a);
238         return _a - _b;
239     }
240 
241     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
242         c = _a + _b;
243         assert(c >= _a);
244         return c;
245     }
246 }
247 
248 contract ERC20Basic {
249     function totalSupply() public view returns (uint256);
250     function balanceOf(address _who) public view returns (uint256);
251     function transfer(address _to, uint256 _value) public returns (bool);
252     event Transfer(address indexed from, address indexed to, uint256 value);
253 }
254 
255 contract ERC20 is ERC20Basic {
256     function allowance(address _owner, address _spender)
257     public view returns (uint256);
258 
259     function transferFrom(address _from, address _to, uint256 _value)
260     public returns (bool);
261 
262     function approve(address _spender, uint256 _value) public returns (bool);
263     event Approval(
264         address indexed owner,
265         address indexed spender,
266         uint256 value
267     );
268 }
269 
270 contract BasicToken is ERC20Basic {
271     using SafeMath for uint256;
272 
273     mapping(address => uint256) internal balances;
274 
275     uint256 internal totalSupply_;
276 
277     function totalSupply() public view returns (uint256) {
278         return totalSupply_;
279     }
280 
281     function transfer(address _to, uint256 _value) public returns (bool) {
282         require(_value <= balances[msg.sender]);
283         require(_to != address(0));
284 
285         balances[msg.sender] = balances[msg.sender].sub(_value);
286         balances[_to] = balances[_to].add(_value);
287         emit Transfer(msg.sender, _to, _value);
288         return true;
289     }
290 
291     function balanceOf(address _owner) public view returns (uint256) {
292         return balances[_owner];
293     }
294 }
295 
296 contract StandardToken is ERC20, BasicToken {
297 
298     mapping (address => mapping (address => uint256)) internal allowed;
299 
300     function transferFrom(
301         address _from,
302         address _to,
303         uint256 _value
304     )
305     public
306     returns (bool)
307     {
308         require(_value <= balances[_from]);
309         require(_value <= allowed[_from][msg.sender]);
310         require(_to != address(0));
311 
312         balances[_from] = balances[_from].sub(_value);
313         balances[_to] = balances[_to].add(_value);
314         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315         emit Transfer(_from, _to, _value);
316         return true;
317     }
318 
319 
320     function approve(address _spender, uint256 _value) public returns (bool) {
321         allowed[msg.sender][_spender] = _value;
322         emit Approval(msg.sender, _spender, _value);
323         return true;
324     }
325 
326 
327     function allowance(
328         address _owner,
329         address _spender
330     )
331     public
332     view
333     returns (uint256)
334     {
335         return allowed[_owner][_spender];
336     }
337 
338 
339     function increaseApproval(
340         address _spender,
341         uint256 _addedValue
342     )
343     public
344     returns (bool)
345     {
346         allowed[msg.sender][_spender] = (
347         allowed[msg.sender][_spender].add(_addedValue));
348         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
349         return true;
350     }
351 
352     function decreaseApproval(
353         address _spender,
354         uint256 _subtractedValue
355     )
356     public
357     returns (bool)
358     {
359         uint256 oldValue = allowed[msg.sender][_spender];
360         if (_subtractedValue >= oldValue) {
361             allowed[msg.sender][_spender] = 0;
362         } else {
363             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
364         }
365         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
366         return true;
367     }
368 }
369 
370 contract TruePausableToken is StandardToken, BlacklistMigratable {
371 
372     function transfer(
373         address _to,
374         uint256 _value
375     )
376     public
377     whenNotPaused
378     returns (bool)
379     {
380         require(!blacklist[msg.sender]);
381         return super.transfer(_to, _value);
382     }
383 
384     function transferFrom(
385         address _from,
386         address _to,
387         uint256 _value
388     )
389     public
390     whenNotPaused
391     returns (bool)
392     {
393         require(!blacklist[_from]);
394         return super.transferFrom(_from, _to, _value);
395     }
396 
397     function approve(
398         address _spender,
399         uint256 _value
400     )
401     public
402     whenNotPaused
403     returns (bool)
404     {
405         return super.approve(_spender, _value);
406     }
407 
408     function increaseApproval(
409         address _spender,
410         uint _addedValue
411     )
412     public
413     whenNotPaused
414     returns (bool success)
415     {
416         return super.increaseApproval(_spender, _addedValue);
417     }
418 
419     function decreaseApproval(
420         address _spender,
421         uint _subtractedValue
422     )
423     public
424     whenNotPaused
425     returns (bool success)
426     {
427         return super.decreaseApproval(_spender, _subtractedValue);
428     }
429 }
430 
431 contract DetailedERC20 is ERC20 {
432     string public name;
433     string public symbol;
434     uint8 public decimals;
435 
436     constructor(string _name, string _symbol, uint8 _decimals) public {
437         name = _name;
438         symbol = _symbol;
439         decimals = _decimals;
440     }
441 }
442 
443 contract TrueBurnableToken is BasicToken {
444 
445     event Burn(address indexed burner, uint256 value);
446 
447     function _burn(address _who, uint256 _value) internal {
448         require(_value <= balances[_who]);
449 
450         balances[_who] = balances[_who].sub(_value);
451         totalSupply_ = totalSupply_.sub(_value);
452         emit Burn(_who, _value);
453         emit Transfer(_who, address(0), _value);
454     }
455 }
456 
457 contract KRWQToken is StandardToken, TrueBurnableToken, DetailedERC20, TruePausableToken {
458 
459     event Mint(address indexed to, uint256 amount);
460 
461     uint8 constant DECIMALS = 18;
462 
463     constructor(address _firstOwner,
464                 address _secondOwner,
465                 address _thirdOwner,
466                 address _fourthOwner,
467                 address _fifthOwner) DetailedERC20("KRWQ Stablecoin by Q DAO v1.0", "KRWQ", DECIMALS)  public {
468 
469         owners.push(_firstOwner);
470         owners.push(_secondOwner);
471         owners.push(_thirdOwner);
472         owners.push(_fourthOwner);
473         owners.push(_fifthOwner);
474         owners.push(msg.sender);
475 
476         ownersIndices[_firstOwner] = 1;
477         ownersIndices[_secondOwner] = 2;
478         ownersIndices[_thirdOwner] = 3;
479         ownersIndices[_fourthOwner] = 4;
480         ownersIndices[_fifthOwner] = 5;
481         ownersIndices[msg.sender] = 6;
482 
483         howManyOwnersDecide = 4;
484     }
485 
486     function mint(address _to, uint256 _amount) external onlyGovernanceContracts() returns (bool){
487         totalSupply_ = totalSupply_.add(_amount);
488         balances[_to] = balances[_to].add(_amount);
489         emit Mint(_to, _amount);
490         emit Transfer(address(0), _to, _amount);
491         return true;
492     }
493 
494     function approveForOtherContracts(address _sender, address _spender, uint256 _value) external onlyGovernanceContracts() {
495         allowed[_sender][_spender] = _value;
496         emit Approval(_sender, _spender, _value);
497     }
498 
499     function burnFrom(address _to, uint256 _amount) external onlyGovernanceContracts() returns (bool) {
500         allowed[_to][msg.sender] = _amount;
501         transferFrom(_to, msg.sender, _amount);
502         _burn(msg.sender, _amount);
503         return true;
504     }
505 }