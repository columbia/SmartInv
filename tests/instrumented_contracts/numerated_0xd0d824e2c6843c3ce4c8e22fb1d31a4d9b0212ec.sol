1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 
27 
28 
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
101  * Originally based on code by FirstBlood:
102  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  *
104  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
105  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
106  * compliant implementations may not do it.
107  */
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowed;
114 
115     uint256 private _totalSupply;
116 
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return _totalSupply;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param owner The address to query the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address owner) public view returns (uint256) {
130         return _balances[owner];
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param owner address The address which owns the funds.
136      * @param spender address The address which will spend the funds.
137      * @return A uint256 specifying the amount of tokens still available for the spender.
138      */
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowed[owner][spender];
141     }
142 
143     /**
144     * @dev Transfer token for a specified address
145     * @param to The address to transfer to.
146     * @param value The amount to be transferred.
147     */
148     function transfer(address to, uint256 value) public returns (bool) {
149         _transfer(msg.sender, to, value);
150         return true;
151     }
152 
153     /**
154      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155      * Beware that changing an allowance with this method brings the risk that someone may use both the old
156      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      * @param spender The address which will spend the funds.
160      * @param value The amount of tokens to be spent.
161      */
162     function approve(address spender, uint256 value) public returns (bool) {
163         require(spender != address(0));
164 
165         _allowed[msg.sender][spender] = value;
166         emit Approval(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another.
172      * Note that while this function emits an Approval event, this is not required as per the specification,
173      * and other compliant implementations may not emit the event.
174      * @param from address The address which you want to send tokens from
175      * @param to address The address which you want to transfer to
176      * @param value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
180         _transfer(from, to, value);
181         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
182         return true;
183     }
184 
185     /**
186      * @dev Increase the amount of tokens that an owner allowed to a spender.
187      * approve should be called when allowed_[_spender] == 0. To increment
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * Emits an Approval event.
192      * @param spender The address which will spend the funds.
193      * @param addedValue The amount of tokens to increase the allowance by.
194      */
195     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
196         require(spender != address(0));
197 
198         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
199         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
200         return true;
201     }
202 
203     /**
204      * @dev Decrease the amount of tokens that an owner allowed to a spender.
205      * approve should be called when allowed_[_spender] == 0. To decrement
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      * Emits an Approval event.
210      * @param spender The address which will spend the funds.
211      * @param subtractedValue The amount of tokens to decrease the allowance by.
212      */
213     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
214         require(spender != address(0));
215 
216         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
217         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218         return true;
219     }
220 
221     /**
222     * @dev Transfer token for a specified addresses
223     * @param from The address to transfer from.
224     * @param to The address to transfer to.
225     * @param value The amount to be transferred.
226     */
227     function _transfer(address from, address to, uint256 value) internal {
228         require(to != address(0));
229 
230         _balances[from] = _balances[from].sub(value);
231         _balances[to] = _balances[to].add(value);
232         emit Transfer(from, to, value);
233     }
234 
235     /**
236      * @dev Internal function that mints an amount of the token and assigns it to
237      * an account. This encapsulates the modification of balances such that the
238      * proper events are emitted.
239      * @param account The account that will receive the created tokens.
240      * @param value The amount that will be created.
241      */
242     function _mint(address account, uint256 value) internal {
243         require(account != address(0));
244 
245         _totalSupply = _totalSupply.add(value);
246         _balances[account] = _balances[account].add(value);
247         emit Transfer(address(0), account, value);
248     }
249 
250     /**
251      * @dev Internal function that burns an amount of the token of a given
252      * account.
253      * @param account The account whose tokens will be burnt.
254      * @param value The amount that will be burnt.
255      */
256     function _burn(address account, uint256 value) internal {
257         require(account != address(0));
258 
259         _totalSupply = _totalSupply.sub(value);
260         _balances[account] = _balances[account].sub(value);
261         emit Transfer(account, address(0), value);
262     }
263 
264     /**
265      * @dev Internal function that burns an amount of the token of a given
266      * account, deducting from the sender's allowance for said account. Uses the
267      * internal burn function.
268      * Emits an Approval event (reflecting the reduced allowance).
269      * @param account The account whose tokens will be burnt.
270      * @param value The amount that will be burnt.
271      */
272     function _burnFrom(address account, uint256 value) internal {
273         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
274         _burn(account, value);
275         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
276     }
277 }
278 
279 
280 
281 
282 
283 /**
284  * @title ERC20Detailed token
285  * @dev The decimals are only for visualization purposes.
286  * All the operations are done using the smallest and indivisible token unit,
287  * just as on Ethereum all the operations are done in wei.
288  */
289 contract ERC20Detailed is IERC20 {
290     string private _name;
291     string private _symbol;
292     uint8 private _decimals;
293 
294     constructor (string memory name, string memory symbol, uint8 decimals) public {
295         _name = name;
296         _symbol = symbol;
297         _decimals = decimals;
298     }
299 
300     /**
301      * @return the name of the token.
302      */
303     function name() public view returns (string memory) {
304         return _name;
305     }
306 
307     /**
308      * @return the symbol of the token.
309      */
310     function symbol() public view returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @return the number of decimals of the token.
316      */
317     function decimals() public view returns (uint8) {
318         return _decimals;
319     }
320 }
321 
322 
323 
324 
325 contract Multiownable {
326 
327     // VARIABLES
328 
329     uint256 public ownersGeneration;
330     uint256 public howManyOwnersDecide;
331     address[] public owners;
332     bytes32[] public allOperations;
333     address internal insideCallSender;
334     uint256 internal insideCallCount;
335 
336     // Reverse lookup tables for owners and allOperations
337     mapping(address => uint) public ownersIndices; // Starts from 1
338     mapping(bytes32 => uint) public allOperationsIndicies;
339 
340     // Owners voting mask per operations
341     mapping(bytes32 => uint256) public votesMaskByOperation;
342     mapping(bytes32 => uint256) public votesCountByOperation;
343 
344     // EVENTS
345 
346     event OwnershipTransferred(address[] previousOwners, uint howManyOwnersDecide, address[] newOwners, uint newHowManyOwnersDecide);
347     event OperationCreated(bytes32 operation, uint howMany, uint ownersCount, address proposer);
348     event OperationUpvoted(bytes32 operation, uint votes, uint howMany, uint ownersCount, address upvoter);
349     event OperationPerformed(bytes32 operation, uint howMany, uint ownersCount, address performer);
350     event OperationDownvoted(bytes32 operation, uint votes, uint ownersCount,  address downvoter);
351     event OperationCancelled(bytes32 operation, address lastCanceller);
352     
353     // ACCESSORS
354 
355     function isOwner(address wallet) public view returns(bool) {
356         return ownersIndices[wallet] > 0;
357     }
358 
359     function ownersCount() public view returns(uint) {
360         return owners.length;
361     }
362 
363     function allOperationsCount() public view returns(uint) {
364         return allOperations.length;
365     }
366 
367     // MODIFIERS
368 
369     /**
370     * @dev Allows to perform method by any of the owners
371     */
372     modifier onlyAnyOwner {
373         if (checkHowManyOwners(1)) {
374             bool update = (insideCallSender == address(0));
375             if (update) {
376                 insideCallSender = msg.sender;
377                 insideCallCount = 1;
378             }
379             _;
380             if (update) {
381                 insideCallSender = address(0);
382                 insideCallCount = 0;
383             }
384         }
385     }
386 
387     /**
388     * @dev Allows to perform method only after many owners call it with the same arguments
389     */
390     modifier onlyManyOwners {
391         if (checkHowManyOwners(howManyOwnersDecide)) {
392             bool update = (insideCallSender == address(0));
393             if (update) {
394                 insideCallSender = msg.sender;
395                 insideCallCount = howManyOwnersDecide;
396             }
397             _;
398             if (update) {
399                 insideCallSender = address(0);
400                 insideCallCount = 0;
401             }
402         }
403     }
404 
405     /**
406     * @dev Allows to perform method only after all owners call it with the same arguments
407     */
408     modifier onlyAllOwners {
409         if (checkHowManyOwners(owners.length)) {
410             bool update = (insideCallSender == address(0));
411             if (update) {
412                 insideCallSender = msg.sender;
413                 insideCallCount = owners.length;
414             }
415             _;
416             if (update) {
417                 insideCallSender = address(0);
418                 insideCallCount = 0;
419             }
420         }
421     }
422 
423     /**
424     * @dev Allows to perform method only after some owners call it with the same arguments
425     */
426     modifier onlySomeOwners(uint howMany) {
427         require(howMany > 0, "onlySomeOwners: howMany argument is zero");
428         require(howMany <= owners.length, "onlySomeOwners: howMany argument exceeds the number of owners");
429         
430         if (checkHowManyOwners(howMany)) {
431             bool update = (insideCallSender == address(0));
432             if (update) {
433                 insideCallSender = msg.sender;
434                 insideCallCount = howMany;
435             }
436             _;
437             if (update) {
438                 insideCallSender = address(0);
439                 insideCallCount = 0;
440             }
441         }
442     }
443 
444     // Will be initialized from inherited contract
445     // CONSTRUCTOR
446     constructor (address[] memory _owners, uint threshold) public {
447         require(_owners.length > 0, "Owners list is empty");
448         require(threshold > 0 && threshold <= _owners.length, "Incorrect threshold");
449 
450         for (uint n = 0; n < _owners.length; n++) {
451             owners.push(_owners[n]);
452             ownersIndices[_owners[n]] = n + 1;
453         }
454 
455         howManyOwnersDecide = threshold;
456     }
457 
458     // INTERNAL METHODS
459 
460     /**
461      * @dev onlyManyOwners modifier helper
462      */    
463     function checkHowManyOwners(uint howMany) internal returns(bool) {
464         if (insideCallSender == msg.sender) {
465             require(howMany <= insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");
466             return true;
467         }
468 
469         uint ownerIndex = ownersIndices[msg.sender] - 1;
470         require(ownerIndex < owners.length, "checkHowManyOwners: msg.sender is not an owner");
471         bytes32 operation = keccak256(abi.encodePacked(msg.data, ownersGeneration));
472 
473         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");
474         votesMaskByOperation[operation] |= (2 ** ownerIndex);
475         uint operationVotesCount = votesCountByOperation[operation] + 1;
476         votesCountByOperation[operation] = operationVotesCount;
477         if (operationVotesCount == 1) {
478             allOperationsIndicies[operation] = allOperations.length;
479             allOperations.push(operation);
480             emit OperationCreated(operation, howMany, owners.length, msg.sender);
481         }
482         emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);
483 
484         // If enough owners confirmed the same operation
485         if (votesCountByOperation[operation] == howMany) {
486             deleteOperation(operation);
487             emit OperationPerformed(operation, howMany, owners.length, msg.sender);
488             return true;
489         }
490 
491         return false;
492     }
493 
494     /**
495     * @dev Used to delete cancelled or performed operation
496     * @param operation defines which operation to delete
497     */
498     function deleteOperation(bytes32 operation) internal {
499         uint index = allOperationsIndicies[operation];
500         if (index < allOperations.length - 1) { // Not last
501             allOperations[index] = allOperations[allOperations.length - 1];
502             allOperationsIndicies[allOperations[index]] = index;
503         }
504         allOperations.length--;
505 
506         delete votesMaskByOperation[operation];
507         delete votesCountByOperation[operation];
508         delete allOperationsIndicies[operation];
509     }
510 
511     // PUBLIC METHODS
512 
513     /**
514     * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations
515     * @param operation defines which operation to delete
516     */
517     function cancelPending(bytes32 operation) public onlyAnyOwner {
518         uint ownerIndex = ownersIndices[msg.sender] - 1;
519         require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0, "cancelPending: operation not found for this user");
520         votesMaskByOperation[operation] &= ~(2 ** ownerIndex);
521         uint operationVotesCount = votesCountByOperation[operation] - 1;
522         votesCountByOperation[operation] = operationVotesCount;
523         emit OperationDownvoted(operation, operationVotesCount, owners.length, msg.sender);
524         if (operationVotesCount == 0) {
525             deleteOperation(operation);
526             emit OperationCancelled(operation, msg.sender);
527         }
528     }
529 
530     /**
531     * @dev Allows owners to change ownership
532     * @param newOwners defines array of addresses of new owners
533     */
534     function transferOwnership(address[] memory newOwners) public {
535         transferOwnershipWithHowMany(newOwners, newOwners.length);
536     }
537 
538     /**
539     * @dev Allows owners to change ownership
540     * @param newOwners defines array of addresses of new owners
541     * @param newHowManyOwnersDecide defines how many owners can decide
542     */
543     function transferOwnershipWithHowMany(address[] memory newOwners, uint256 newHowManyOwnersDecide) public onlyManyOwners {
544         require(newOwners.length > 0, "transferOwnershipWithHowMany: owners array is empty");
545         require(newOwners.length <= 256, "transferOwnershipWithHowMany: owners count is greater then 256");
546         require(newHowManyOwnersDecide > 0, "transferOwnershipWithHowMany: newHowManyOwnersDecide equal to 0");
547         require(newHowManyOwnersDecide <= newOwners.length, "transferOwnershipWithHowMany: newHowManyOwnersDecide exceeds the number of owners");
548 
549         // Reset owners reverse lookup table
550         for (uint j = 0; j < owners.length; j++) {
551             delete ownersIndices[owners[j]];
552         }
553         for (uint i = 0; i < newOwners.length; i++) {
554             require(newOwners[i] != address(0), "transferOwnershipWithHowMany: owners array contains zero");
555             require(ownersIndices[newOwners[i]] == 0, "transferOwnershipWithHowMany: owners array contains duplicates");
556             ownersIndices[newOwners[i]] = i + 1;
557         }
558         
559         emit OwnershipTransferred(owners, howManyOwnersDecide, newOwners, newHowManyOwnersDecide);
560         owners = newOwners;
561         howManyOwnersDecide = newHowManyOwnersDecide;
562         allOperations.length = 0;
563         ownersGeneration++;
564     }
565 
566 }
567 
568 contract vUSD is ERC20, ERC20Detailed, Multiownable {    
569     address public operator;
570     uint256 public availableForMinting = 0;
571 
572     event OperatorSet(address _address);
573     event OperatorDisabled();
574 
575     constructor (string memory name, string memory symbol, uint8 decimals, address[] memory _owners, uint8 threshold) public 
576         ERC20Detailed(name, symbol, decimals) 
577         Multiownable(_owners, threshold) {     
578     }
579 
580     modifier onlyOperator() {
581         require(operator != address(0) && msg.sender == operator, "Forbidden");
582         _;
583     }
584     
585     function setOperator(address _address) public onlyManyOwners {            
586         operator = _address;
587         emit OperatorSet(_address);
588     }
589 
590     function disableOperator() public onlyOperator {
591         operator = address(0);
592         emit OperatorDisabled();
593     }
594 
595     function allowMint(uint256 amount) public onlyManyOwners { 
596         require(amount > 0, "Amount below zero");
597         availableForMinting = availableForMinting.add(amount);
598     }
599 
600     function burn (uint256 amount) public {
601         _burn(msg.sender, amount);
602     }
603 
604     function burnFrom(address _address, uint256 amount) public {
605         _burnFrom(_address, amount);
606     }
607 
608     function mint(address _address, uint256 amount) public onlyOperator returns (bool) {
609         require(availableForMinting >= amount, "Insufficient available for minting");    
610         _mint(_address, amount);
611         availableForMinting = availableForMinting.sub(amount);
612         return true;
613     }        
614 }