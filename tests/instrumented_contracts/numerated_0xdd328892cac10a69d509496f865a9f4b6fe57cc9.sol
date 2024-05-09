1 pragma solidity ^0.5.0;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 library SafeMath {
6 
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) return 0;
9 
10     uint256 c = a * b;
11     require(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     require(b > 0);
17     uint256 c = a / b;
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     require(b <= a);
23     uint256 c = a - b;
24     return c;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     require(c >= a);
30 
31     return c;
32   }
33 
34   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b != 0);
36     return a % b;
37   }
38 }
39 
40 // File: contracts/blacklist/Blacklist.sol
41 
42 library Blacklist {
43   struct List {
44     mapping(address => bool) registry;
45   }
46   function add(List storage list, address beneficiary) internal {
47     list.registry[beneficiary] = true;
48   }
49   function remove(List storage list, address beneficiary) internal {
50     list.registry[beneficiary] = false;
51   }
52   function check(List storage list, address beneficiary) view internal returns (bool) {
53     return list.registry[beneficiary];
54   }
55 }
56 
57 // File: contracts/ownership/Multiownable.sol
58 
59 contract Multiownable {
60 
61   uint256 public ownersGeneration;
62   uint256 public howManyOwnersDecide;
63   address[] public owners;
64   bytes32[] public allOperations;
65   address internal insideCallSender;
66   uint256 internal insideCallCount;
67 
68   // Reverse lookup tables for owners and allOperations
69   mapping(address => uint) public ownersIndices;
70   mapping(bytes32 => uint) public allOperationsIndicies;
71 
72   // Owners voting mask per operations
73   mapping(bytes32 => uint256) public votesMaskByOperation;
74   mapping(bytes32 => uint256) public votesCountByOperation;
75 
76   event OwnershipTransferred(address[] previousOwners, uint howManyOwnersDecide, address[] newOwners, uint newHowManyOwnersDecide);
77   event OperationCreated(bytes32 operation, uint howMany, uint ownersCount, address proposer);
78   event OperationUpvoted(bytes32 operation, uint votes, uint howMany, uint ownersCount, address upvoter);
79   event OperationPerformed(bytes32 operation, uint howMany, uint ownersCount, address performer);
80   event OperationDownvoted(bytes32 operation, uint votes, uint ownersCount,  address downvoter);
81   event OperationCancelled(bytes32 operation, address lastCanceller);
82 
83   function isOwner(address wallet) public view returns(bool) {
84     return ownersIndices[wallet] > 0;
85   }
86 
87   function ownersCount() public view returns(uint) {
88     return owners.length;
89   }
90 
91   function allOperationsCount() public view returns(uint) {
92     return allOperations.length;
93   }
94 
95   /**
96   * @dev Allows to perform method by any of the owners
97   */
98   modifier onlyAnyOwner {
99     if (checkHowManyOwners(1)) {
100       bool update = (insideCallSender == address(0));
101       if (update) {
102         insideCallSender = msg.sender;
103         insideCallCount = 1;
104       }
105       _;
106       if (update) {
107         insideCallSender = address(0);
108         insideCallCount = 0;
109       }
110     }
111   }
112 
113   /**
114   * @dev Allows to perform method only after some owners call it with the same arguments
115   */
116   modifier onlyOwners() {
117     require(howManyOwnersDecide > 0);
118     require(howManyOwnersDecide <= owners.length);
119 
120     if (checkHowManyOwners(howManyOwnersDecide)) {
121       bool update = (insideCallSender == address(0));
122       if (update) {
123         insideCallSender = msg.sender;
124         insideCallCount = howManyOwnersDecide;
125       }
126       _;
127       if (update) {
128         insideCallSender = address(0);
129         insideCallCount = 0;
130       }
131     }
132   }
133 
134   constructor(address[] memory _owners) public {
135     owners.push(msg.sender);
136     ownersIndices[msg.sender] = 1;
137     howManyOwnersDecide = 1;
138     transferOwnership(_owners, 2);
139   }
140 
141   /**
142   * @dev onlyManyOwners modifier helper
143   */
144   function checkHowManyOwners(uint howMany) internal returns(bool) {
145     if (insideCallSender == msg.sender) {
146       require(howMany <= insideCallCount);
147       return true;
148     }
149 
150     uint ownerIndex = ownersIndices[msg.sender] - 1;
151     require(ownerIndex < owners.length);
152     bytes32 operation = keccak256(abi.encodePacked(msg.data, ownersGeneration));
153 
154     require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0);
155     votesMaskByOperation[operation] |= (2 ** ownerIndex);
156     uint operationVotesCount = votesCountByOperation[operation] + 1;
157     votesCountByOperation[operation] = operationVotesCount;
158     if (operationVotesCount == 1) {
159       allOperationsIndicies[operation] = allOperations.length;
160       allOperations.push(operation);
161       emit OperationCreated(operation, howMany, owners.length, msg.sender);
162     }
163     emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);
164 
165     // If enough owners confirmed the same operation
166     if (votesCountByOperation[operation] == howMany) {
167       deleteOperation(operation);
168       emit OperationPerformed(operation, howMany, owners.length, msg.sender);
169       return true;
170     }
171 
172     return false;
173   }
174 
175   function deleteOperation(bytes32 operation) internal {
176     uint index = allOperationsIndicies[operation];
177     if (index < allOperations.length - 1) { // Not last
178       allOperations[index] = allOperations[allOperations.length - 1];
179       allOperationsIndicies[allOperations[index]] = index;
180     }
181     allOperations.length--;
182 
183     delete votesMaskByOperation[operation];
184     delete votesCountByOperation[operation];
185     delete allOperationsIndicies[operation];
186   }
187 
188   function cancelPending(bytes32 operation) public onlyAnyOwner {
189     uint ownerIndex = ownersIndices[msg.sender] - 1;
190     require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0);
191     votesMaskByOperation[operation] &= ~(2 ** ownerIndex);
192     uint operationVotesCount = votesCountByOperation[operation] - 1;
193     votesCountByOperation[operation] = operationVotesCount;
194     emit OperationDownvoted(operation, operationVotesCount, owners.length, msg.sender);
195     if (operationVotesCount == 0) {
196       deleteOperation(operation);
197       emit OperationCancelled(operation, msg.sender);
198     }
199   }
200 
201   function transferOwnership(address[] memory newOwners, uint256 _howManyOwnersDecide) public onlyAnyOwner {
202     _transferOwnership(newOwners, _howManyOwnersDecide);
203   }
204 
205   function _transferOwnership(address[] memory newOwners, uint256 newHowManyOwnersDecide) internal onlyOwners {
206     require(newOwners.length > 0);
207     require(newOwners.length <= 256);
208     require(newHowManyOwnersDecide > 0);
209     require(newHowManyOwnersDecide <= newOwners.length);
210 
211     // Reset owners reverse lookup table
212     for (uint j = 0; j < owners.length; j++) {
213       delete ownersIndices[owners[j]];
214     }
215     for (uint i = 0; i < newOwners.length; i++) {
216       require(newOwners[i] != address(0));
217       require(ownersIndices[newOwners[i]] == 0);
218       ownersIndices[newOwners[i]] = i + 1;
219     }
220 
221     emit OwnershipTransferred(owners, howManyOwnersDecide, newOwners, newHowManyOwnersDecide);
222     owners = newOwners;
223     howManyOwnersDecide = newHowManyOwnersDecide;
224     allOperations.length = 0;
225     ownersGeneration++;
226   }
227 
228 }
229 
230 // File: contracts/blacklist/Blacklisted.sol
231 
232 contract Blacklisted is Multiownable {
233   Blacklist.List private _list;
234   modifier whenNotFrozen() {
235     require(Blacklist.check(_list, msg.sender) == false);
236     _;
237   }
238   event AddressAdded(address[] beneficiary);
239   event AddressRemoved(address[] beneficiary);
240 
241   function freezeAccount(address[] calldata _beneficiary) external onlyOwners {
242     for (uint256 i = 0; i < _beneficiary.length; i++) {
243       Blacklist.add(_list, _beneficiary[i]);
244     }
245     emit AddressAdded(_beneficiary);
246   }
247 
248   function deFreezeAccount(address[] calldata _beneficiary) external onlyOwners {
249     for (uint256 i = 0; i < _beneficiary.length; i++) {
250       Blacklist.remove(_list, _beneficiary[i]);
251     }
252     emit AddressRemoved(_beneficiary);
253   }
254 
255   function isFrozen(address _beneficiary) external view returns (bool){
256     return Blacklist.check(_list, _beneficiary);
257   }
258 }
259 
260 // File: contracts/lifecycle/Pausable.sol
261 
262 contract Pausable is Multiownable {
263 
264   event Pause();
265   event Unpause();
266 
267   bool public paused = false;
268 
269   modifier whenNotPaused() {
270     require(!paused);
271     _;
272   }
273 
274   modifier whenPaused() {
275     require(paused);
276     _;
277   }
278 
279   function pause() whenNotPaused onlyOwners external {
280     paused = true;
281     emit Pause();
282   }
283 
284   function unpause() whenPaused onlyOwners external {
285     paused = false;
286     emit Unpause();
287   }
288 }
289 
290 // File: contracts/token/BasicInterface.sol
291 
292 contract ERC20 {
293     function balanceOf(address tokenOwner) public view returns (uint256 balance);
294     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
295     function transfer(address to, uint256 tokens) public returns (bool success);
296     function approve(address spender, uint256 tokens) public returns (bool success);
297     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
298 
299     event Transfer(address indexed from, address indexed to, uint256 tokens);
300     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
301 }
302 
303 // File: contracts/token/BasicToken.sol
304 
305 contract BasicToken is ERC20 {
306   using SafeMath for uint256;
307 
308   mapping(address => uint256) balances;
309   uint256 public _totalSupply;
310 
311   function totalSupply() public view returns (uint256) {
312     return _totalSupply;
313   }
314 
315   function balanceOf(address owner) public view returns (uint256 balance) {
316     return balances[owner];
317   }
318 
319   function transfer(address to, uint256 value) public returns (bool) {
320     _transfer(msg.sender, to, value);
321     return true;
322   }
323 
324   function _transfer(address from, address to, uint256 value) internal {
325     require(address(to) != address(0));
326     balances[from] = balances[from].sub(value);
327     balances[to] = balances[to].add(value);
328     emit Transfer(from, to, value);
329   }
330 
331 }
332 
333 // File: contracts/token/StandardToken.sol
334 
335 contract StandardToken is BasicToken {
336   mapping (address => mapping (address => uint256)) allowed;
337 
338   function transferFrom(address from, address to, uint256 value) public returns (bool) {
339     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
340     _transfer(from, to, value);
341     emit Approval(from, msg.sender, allowed[from][msg.sender]);
342     return true;
343   }
344 
345   function approve(address spender, uint256 value) public returns (bool) {
346     allowed[msg.sender][spender] = value;
347     emit Approval(msg.sender, spender, value);
348     return true;
349   }
350 
351   function allowance(address owner, address spender) public view returns (uint256 remaining) {
352     return allowed[owner][spender];
353   }
354 
355   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
356     require(spender != address(0));
357     allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
358     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
359     return true;
360   }
361 
362   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
363     require(spender != address(0));
364     allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
365     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
366     return true;
367   }
368 }
369 
370 // File: contracts/token/BurnableToken.sol
371 
372 contract BurnableToken is StandardToken {
373 
374   function burn(address account, uint256 value) public {
375     require(account != address(0));
376     _totalSupply = _totalSupply.sub(value);
377     balances[account] = balances[account].sub(value);
378     emit Transfer(account, address(0), value);
379   }
380 
381   function burnFrom(address account, uint256 value) public {
382     allowed[account][msg.sender] = allowed[account][msg.sender].sub(value);
383     burn(account, value);
384     emit Approval(account, msg.sender, allowed[account][msg.sender]);
385   }
386 
387 }
388 
389 // File: contracts/Hydra.sol
390 
391 contract MultiSignatureVault is Multiownable {
392 
393   bool lockState;
394   function () external payable {}
395 
396   constructor(address[] memory _owners) public Multiownable(_owners) {
397     lockState = false;
398   }
399 
400   function transferTo(address payable to, uint256 amount) external onlyOwners {
401     require(!lockState);
402     lockState = true;
403     to.transfer(amount);
404     lockState = false;
405   }
406 
407   function transferTokensTo(address token, address to, uint256 amount) external onlyOwners {
408     require(!lockState);
409     lockState = true;
410     ERC20(token).transfer(to, amount);
411     lockState = false;
412   }
413 }
414 
415 contract Hydra is StandardToken, BurnableToken, Blacklisted, Pausable {
416 
417   string private _name;
418   string private _symbol;
419   uint8 private _decimals;
420 
421   MultiSignatureVault public vaultTeam;
422   MultiSignatureVault public vaultInvestor;
423   MultiSignatureVault public vaultOperation;
424 
425   constructor(address[] memory owners) public Multiownable(owners) {
426     _name = "Hydra Token";
427     _symbol = "HDRA";
428     _decimals = 18;
429     _totalSupply = 300000000E18;
430 
431     vaultTeam = new MultiSignatureVault(owners);
432     vaultInvestor = new MultiSignatureVault(owners);
433     vaultOperation = new MultiSignatureVault(owners);
434 
435     balances[address(vaultTeam)] = 60000000E18;
436     balances[address(vaultInvestor)] = 150000000E18;
437     balances[address(vaultOperation)] = 90000000E18;
438 
439     emit Transfer(address(this), address(vaultTeam), 60000000E18);
440     emit Transfer(address(this), address(vaultInvestor), 150000000E18);
441     emit Transfer(address(this), address(vaultOperation), 90000000E18);
442   }
443 
444   function name() public view returns (string memory) {
445     return _name;
446   }
447 
448   function symbol() public view returns (string memory) {
449     return _symbol;
450   }
451 
452   function decimals() public view returns (uint8) {
453     return _decimals;
454   }
455 
456   function transfer(address to, uint256 value) public whenNotPaused whenNotFrozen returns (bool) {
457     return super.transfer(to, value);
458   }
459 
460   function transferFrom(address from, address to, uint256 value) public whenNotPaused whenNotFrozen returns (bool) {
461     return super.transferFrom(from, to, value);
462   }
463 
464   function approve(address spender, uint256 value) public whenNotPaused whenNotFrozen returns (bool) {
465     return super.approve(spender, value);
466   }
467 
468   function increaseAllowance(address spender, uint addedValue) public whenNotPaused whenNotFrozen returns (bool success) {
469     return super.increaseAllowance(spender, addedValue);
470   }
471 
472   function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused whenNotFrozen returns (bool success) {
473     return super.decreaseAllowance(spender, subtractedValue);
474   }
475 }